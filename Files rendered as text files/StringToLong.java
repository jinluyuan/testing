/**
 * StringToLong class contains the method for the coding test.
 * @author Ginny Huang
 */
public class StringToLong {
	
	/**
	 * This method tries convert a string to a long type number,
	 * or return the largest/smallest number a long type could hold, if 
	 * the given input exceeds the limit
	 *
	 * Limitations:
	 *
	 * 1) The string cannot contain letters that are not -, + or 0-9.
	 * If it does, the method only returns the value of the sub string
	 * prior to the first invalid letter
	 * Also, since long type only holds whole numbers, only the whole part
	 * of a decimal input would be returned.
	 *
	 * 2) The method cannot return a number that is larger than 2^(63) - 1,
	 * or a number smaller than -2^(63). From Java documentation, these are
	 * the maximum and minimum values that the long type could hold without overflow.
	 *
	 * @param  s The string that represents a long type number
	 */
	long stringToLong(String s)
	{
		long MAX_DIV_10 = Long.MAX_VALUE / 10;
		long MAX_DIV_REM = 8; // From Oracle's Java Documentation
		
		/* code goes here to convert a string to a long */
		long sum = 0;
		int cursor = 0;
		
		// Strip leading spaces
		while (cursor < s.length() && s.charAt(cursor) == ' ') {
			cursor++;
		}
		
		// Determine the sign
		boolean sign = true;
		if (s.charAt(cursor) == '-' || s.charAt(cursor) == '+') {
			sign = (s.charAt(cursor) == '+');
			cursor++;
		}
		
		// Adds number by digits
		while (cursor < s.length() && '0' <= s.charAt(cursor) && s.charAt(cursor) <= '9') {
			int cur = Character.getNumericValue(s.charAt(cursor));
			
			// Check overflow
			if (sum > MAX_DIV_10) {
				return sign? Long.MAX_VALUE: Long.MIN_VALUE;
			} else if (sum == MAX_DIV_10) {
				if (sign && cur >= MAX_DIV_REM - 1) {
					return Long.MAX_VALUE;
				} else if (!sign && cur >= MAX_DIV_REM) {
					return Long.MIN_VALUE;
				}	
			}
			
			sum = (long)sum * 10 + (long)cur;
			cursor++;
		}	
		return sign? sum : 0 - sum;
	
	}
	
	void test() { 
		String[] inputs = new String[]{"-0a", "1", "-35", "+0009223372036854775806", "9223372036854775808", "-0009223372036854775807", "-0009223372036854775808"};
		long[] expected = new long[]{(long)0, (long)1, (long)-35, Long.MAX_VALUE - 1, Long.MAX_VALUE, Long.MIN_VALUE + 1, Long.MIN_VALUE};
		for (int i = 0; i < inputs.length; i++) {
			System.out.println("Input: " + inputs[i] + ";");
			System.out.println("Expected: " + expected[i] + ";");
			System.out.println("Actual: " + this.stringToLong(inputs[i]) + ";");
			System.out.println(this.stringToLong(inputs[i]) == expected[i]);
			System.out.println("-----------------");
		}
	}
	
	public static void main(String[] args) {
		StringToLong sol = new StringToLong();
		sol.test();
	}
}

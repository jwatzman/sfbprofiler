structure MD5 :> MD5 = struct

	type ptr = MLton.Pointer.t

	fun read_bytes (p, n) =
		Word8Vector.tabulate (n, fn i => MLton.Pointer.getWord8 (p, i))

	val malloc = _import "malloc" : int -> ptr;
	val free = _import "free" : ptr -> unit;

	val md5_digest_length = 16
	val openssl_md5 = _import "MD5" : string * int * ptr -> unit;

	fun hex v =
		let
			val digits = "0123456789abcdef"
			fun hexSingle (b, accum) =
				(String.sub (digits, (Word8.toInt b) div 16))::
				(String.sub (digits, (Word8.toInt b) mod 16))::
				accum
		in
			String.implode (Word8Vector.foldr hexSingle [] v)
		end

	fun md5 s =
		let
			val outp = malloc md5_digest_length
			val () = openssl_md5 (s, (size s), outp)
			val bytes = read_bytes (outp, md5_digest_length)
			val result = hex bytes
			val () = free outp
		in
			result
		end
end

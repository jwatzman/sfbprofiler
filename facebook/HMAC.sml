(* This should probably be a functor parameterized over the hash function, but
   for now all I need is HMAC-SHA-256 so not going to bother. *)
structure HMAC :> HMAC = struct

	type ptr = MLton.Pointer.t

	fun read_bytes (p, n) =
		Word8Vector.tabulate (n, fn i => MLton.Pointer.getWord8 (p, i))

	val malloc = _import "malloc" : int -> ptr;
	val free = _import "free" : ptr -> unit;

	val evp =
		let
			val get_evp = _import "EVP_sha256" : unit -> ptr;
		in
			get_evp ()
		end

	val evp_max_md_size = 64
	val openssl_hmac =
		_import "HMAC" : ptr * string * int * string * int * ptr * ptr -> unit;

	fun hmac (key, s) =
		let
			val outp = malloc evp_max_md_size
			val lenoutp = malloc 4 (* sizeof(unsigned int) *)

			val () =
				openssl_hmac (evp, key, (size key), s, (size s), outp, lenoutp)

			val bytes = read_bytes (outp, MLton.Pointer.getInt32(lenoutp, 0))

			val () = free outp
			val () = free lenoutp
		in
			Byte.bytesToString bytes
		end

end

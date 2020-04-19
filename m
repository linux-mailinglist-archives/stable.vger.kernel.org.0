Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520761AFE1D
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 22:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgDSUea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 16:34:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51898 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgDSUe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 16:34:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jQGe3-0005Nc-M2; Sun, 19 Apr 2020 21:34:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jQGe3-003kXT-6I; Sun, 19 Apr 2020 21:34:27 +0100
Message-ID: <4bf47792424516d5ee0f41831fd4ebc181f7d3a5.camel@decadent.org.uk>
Subject: [stable] kvm: x86: Host feature SSBD doesn't imply guest feature 
 SPEC_CTRL_SSBD
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Date:   Sun, 19 Apr 2020 21:34:18 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-7ro9OqCGmsCX3dsOySGm"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-7ro9OqCGmsCX3dsOySGm
Content-Type: multipart/mixed; boundary="=-+BEgBaW9RYTJr++vFvP1"


--=-+BEgBaW9RYTJr++vFvP1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please apply the attached backport of commit
396d2e878f92ec108e4293f1c77ea3bc90b414ff to the 4.4, 4.9, 4.14, and
4.19 stable branches.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.
It's the only way to be sure.



--=-+BEgBaW9RYTJr++vFvP1
Content-Disposition: attachment;
	filename="kvm-x86-host-feature-ssbd-doesn-t-imply-guest-feature.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="kvm-x86-host-feature-ssbd-doesn-t-imply-guest-feature.patch";
	charset="UTF-8"

RnJvbTogSmltIE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5jb20+CkRhdGU6IEZyaSwgMTMgRGVj
IDIwMTkgMTY6MTU6MTUgLTA4MDAKU3ViamVjdDoga3ZtOiB4ODY6IEhvc3QgZmVhdHVyZSBTU0JE
IGRvZXNuJ3QgaW1wbHkgZ3Vlc3QgZmVhdHVyZQogU1BFQ19DVFJMX1NTQkQKCmNvbW1pdCAzOTZk
MmU4NzhmOTJlYzEwOGU0MjkzZjFjNzdlYTNiYzkwYjQxNGZmIHVwc3RyZWFtLgoKVGhlIGhvc3Qg
cmVwb3J0cyBzdXBwb3J0IGZvciB0aGUgc3ludGhldGljIGZlYXR1cmUgWDg2X0ZFQVRVUkVfU1NC
RAp3aGVuIGFueSBvZiB0aGUgdGhyZWUgZm9sbG93aW5nIGhhcmR3YXJlIGZlYXR1cmVzIGFyZSBz
ZXQ6CiAgQ1BVSUQuKEVBWD03LEVDWD0wKTpFRFguU1NCRFtiaXQgMzFdCiAgQ1BVSUQuODAwMDAw
MDhIOkVCWC5BTURfU1NCRFtiaXQgMjRdCiAgQ1BVSUQuODAwMDAwMDhIOkVCWC5WSVJUX1NTQkRb
Yml0IDI1XQoKRWl0aGVyIG9mIHRoZSBmaXJzdCB0d28gaGFyZHdhcmUgZmVhdHVyZXMgaW1wbGll
cyB0aGUgZXhpc3RlbmNlIG9mIHRoZQpJQTMyX1NQRUNfQ1RSTCBNU1IsIGJ1dCBDUFVJRC44MDAw
MDAwOEg6RUJYLlZJUlRfU1NCRFtiaXQgMjVdIGRvZXMKbm90LiBUaGVyZWZvcmUsIENQVUlELihF
QVg9NyxFQ1g9MCk6RURYLlNTQkRbYml0IDMxXSBzaG91bGQgb25seSBiZQpzZXQgaW4gdGhlIGd1
ZXN0IGlmIENQVUlELihFQVg9NyxFQ1g9MCk6RURYLlNTQkRbYml0IDMxXSBvcgpDUFVJRC44MDAw
MDAwOEg6RUJYLkFNRF9TU0JEW2JpdCAyNF0gaXMgc2V0IG9uIHRoZSBob3N0LgoKRml4ZXM6IDBj
NTQ5MTRkMGM1MmEgKCJLVk06IHg4NjogdXNlIEludGVsIHNwZWN1bGF0aW9uIGJ1Z3MgYW5kIGZl
YXR1cmVzIGFzIGRlcml2ZWQgaW4gZ2VuZXJpYyB4ODYgY29kZSIpClNpZ25lZC1vZmYtYnk6IEpp
bSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPgpSZXZpZXdlZC1ieTogSmFjb2IgWHUgPGph
Y29iaHh1QGdvb2dsZS5jb20+ClJldmlld2VkLWJ5OiBQZXRlciBTaGllciA8cHNoaWVyQGdvb2ds
ZS5jb20+CkNjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPgpSZXBvcnRlZC1i
eTogRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBQYW9s
byBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPgpbYndoOiBCYWNrcG9ydGVkIHRvIDQueDog
YWRqdXN0IGluZGVudGF0aW9uXQpTaWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVj
YWRlbnQub3JnLnVrPgotLS0KIGFyY2gveDg2L2t2bS9jcHVpZC5jIHwgMyArKy0KIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCi0tLSBhL2FyY2gveDg2L2t2
bS9jcHVpZC5jCisrKyBiL2FyY2gveDg2L2t2bS9jcHVpZC5jCkBAIC00MDAsNyArNDAwLDggQEAg
c3RhdGljIGlubGluZSBpbnQgX19kb19jcHVpZF9lbnQoc3RydWN0CiAJCQkJZW50cnktPmVkeCB8
PSBGKFNQRUNfQ1RSTCk7CiAJCQlpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1NUSUJQKSkK
IAkJCQllbnRyeS0+ZWR4IHw9IEYoSU5URUxfU1RJQlApOwotCQkJaWYgKGJvb3RfY3B1X2hhcyhY
ODZfRkVBVFVSRV9TU0JEKSkKKwkJCWlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfU1BFQ19D
VFJMX1NTQkQpIHx8CisJCQkgICAgYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0FNRF9TU0JEKSkK
IAkJCQllbnRyeS0+ZWR4IHw9IEYoU1BFQ19DVFJMX1NTQkQpOwogCQkJLyoKIAkJCSAqIFdlIGVt
dWxhdGUgQVJDSF9DQVBBQklMSVRJRVMgaW4gc29mdHdhcmUgZXZlbgo=


--=-+BEgBaW9RYTJr++vFvP1--

--=-7ro9OqCGmsCX3dsOySGm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6ctcoACgkQ57/I7JWG
EQkUxg//beshCkkXPSLJjbPF0QL689uDMSfIrq96aotgpDs5Km7fhWjk55UOEoXJ
QriBk/Zvo6dYl7QErEtgRwZdJRoQ25qjACS7qO9n3NktuJ0dJ1oI9Uk3EDK5rVI3
FQ8r5Qd6mckS/snLoUhdQ7XB3drvfcgUfyMwF3XM9E4LUDSm2LKyDHSl7UMFqgNy
gBnqYob2563lE/w691UX0F4J7BBWhrQKZ0604eimyS10KAyH+C8iqBBLtelDnO+K
Sa8DASXgH4BdsoobV8MSSoth8bSXN3MNq6BM6LRL5vfo/gNJFTuk2h9iiUQiDhTS
nbmqamwhvfr7Pa0T+CXlxUra0ApMAySiYTZKP2E4TSVtZ7a3iWFzFXPBgY55xdp9
y5JSZeX3TynnQQ/6a3fOVkSDfKhifaVMEbCnaEpMsJzxqbE64/fufNeXt81Flg6G
Q8bX5WBEq1kxr1zbYV9CS5FSE/52wzYzDi3wIE6rvR3rPA/1kFLX1011I+cwViEw
2ZuhAIMc/3pGi0c1Pza30JKA0NXwJdMFDAczMA9rBNcsKA27lT74fNm31jmAVKcV
n3s1L0Bf1vTzHjFYVrX1ZpN4fxzKfsxGjnpDz59xS1XJqEMUZep/zEXCvUXsTEbW
ulFTd51zT2I5MONZqoeRO/y3RWtvkDxABsxopd3XfsKBW7Pjn9M=
=kDHr
-----END PGP SIGNATURE-----

--=-7ro9OqCGmsCX3dsOySGm--

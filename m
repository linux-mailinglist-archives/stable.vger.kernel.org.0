Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F35D587079
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 20:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiHASo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 14:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiHASo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 14:44:58 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF26764E
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 11:44:57 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oIaPN-0001cR-PX; Mon, 01 Aug 2022 20:44:53 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oIaPN-001RpR-0q;
        Mon, 01 Aug 2022 20:44:53 +0200
Message-ID: <08d4bd45b7d9bfc10d7cf69185e7f81695ba905c.camel@decadent.org.uk>
Subject: Re: FAILED: patch "[PATCH] x86/speculation: Make all RETbleed
 mitigations 64-bit only" failed to apply to 5.10-stable tree
From:   Ben Hutchings <ben@decadent.org.uk>
To:     gregkh@linuxfoundation.org, bp@suse.de, stable@vger.kernel.org
Date:   Mon, 01 Aug 2022 20:44:35 +0200
In-Reply-To: <1658741699227195@kroah.com>
References: <1658741699227195@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-JXaT9dkOb0vGUHXZOo/V"
User-Agent: Evolution 3.44.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-JXaT9dkOb0vGUHXZOo/V
Content-Type: multipart/mixed; boundary="=-wVBbTOsWawKDpi3hdrTS"

--=-wVBbTOsWawKDpi3hdrTS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


I'm attaching a backport that should work for all of 5.10, 5.15, and
5.18.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-wVBbTOsWawKDpi3hdrTS
Content-Disposition: attachment;
	filename*0=0001-x86-speculation-Make-all-RETbleed-mitigations-64-bit.pat;
	filename*1=ch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-x86-speculation-Make-all-RETbleed-mitigations-64-bit.patch";
	charset="UTF-8"

RnJvbSA5OTliYzIzOTY5ZjE5MGVjOWFhNTRhMGNhMjBhOGM5NGUyZDY3YmExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPgpE
YXRlOiBTYXQsIDIzIEp1bCAyMDIyIDE3OjIyOjQ3ICswMjAwClN1YmplY3Q6IFtQQVRDSF0geDg2
L3NwZWN1bGF0aW9uOiBNYWtlIGFsbCBSRVRibGVlZCBtaXRpZ2F0aW9ucyA2NC1iaXQgb25seQoK
Y29tbWl0IGI2NDhhYjQ4N2YzMWJjNGMzODk0MWJjNzcwZWE5N2ZlMzk0MzA0YmIgdXBzdHJlYW0u
CgpUaGUgbWl0aWdhdGlvbnMgZm9yIFJFVEJsZWVkIGFyZSBjdXJyZW50bHkgaW5lZmZlY3RpdmUg
b24geDg2XzMyIHNpbmNlCmVudHJ5XzMyLlMgZG9lcyBub3QgdXNlIHRoZSByZXF1aXJlZCBtYWNy
b3MuICBIb3dldmVyLCBmb3IgYW4geDg2XzMyCnRhcmdldCwgdGhlIGtjb25maWcgc3ltYm9scyBm
b3IgdGhlbSBhcmUgc3RpbGwgZW5hYmxlZCBieSBkZWZhdWx0IGFuZAovc3lzL2RldmljZXMvc3lz
dGVtL2NwdS92dWxuZXJhYmlsaXRpZXMvcmV0YmxlZWQgd2lsbCB3cm9uZ2x5IHJlcG9ydAp0aGF0
IG1pdGlnYXRpb25zIGFyZSBpbiBwbGFjZS4KCk1ha2UgYWxsIG9mIHRoZXNlIHN5bWJvbHMgZGVw
ZW5kIG9uIFg4Nl82NCwgYW5kIG9ubHkgZW5hYmxlIFJFVEhVTksgYnkKZGVmYXVsdCBvbiBYODZf
NjQuCgpGaXhlczogZjQzYjk4NzZlODU3ICgieDg2L3JldGJsZWVkOiBBZGQgZmluZSBncmFpbmVk
IEtjb25maWcga25vYnMiKQpTaWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRl
bnQub3JnLnVrPgpTaWduZWQtb2ZmLWJ5OiBCb3Jpc2xhdiBQZXRrb3YgPGJwQHN1c2UuZGU+CkNj
OiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
ci9ZdHdTUjNOTnNXcDFvaGZWQGRlY2FkZW50Lm9yZy51awpbYndoOiBCYWNrcG9ydGVkIHRvIDUu
MTAvNS4xNS81LjE4OiBhZGp1c3QgY29udGV4dF0KU2lnbmVkLW9mZi1ieTogQmVuIEh1dGNoaW5n
cyA8YmVuQGRlY2FkZW50Lm9yZy51az4KLS0tCiBhcmNoL3g4Ni9LY29uZmlnIHwgOCArKysrLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9LY29uZmlnIGIvYXJjaC94ODYvS2NvbmZpZwppbmRleCA0ZDFkODdm
NzZhNzQuLmNlMWY1YTg3NmNmZSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvS2NvbmZpZworKysgYi9h
cmNoL3g4Ni9LY29uZmlnCkBAIC0yNDY5LDcgKzI0NjksNyBAQCBjb25maWcgUkVUUE9MSU5FCiBj
b25maWcgUkVUSFVOSwogCWJvb2wgIkVuYWJsZSByZXR1cm4tdGh1bmtzIgogCWRlcGVuZHMgb24g
UkVUUE9MSU5FICYmIENDX0hBU19SRVRVUk5fVEhVTksKLQlkZWZhdWx0IHkKKwlkZWZhdWx0IHkg
aWYgWDg2XzY0CiAJaGVscAogCSAgQ29tcGlsZSB0aGUga2VybmVsIHdpdGggdGhlIHJldHVybi10
aHVua3MgY29tcGlsZXIgb3B0aW9uIHRvIGd1YXJkCiAJICBhZ2FpbnN0IGtlcm5lbC10by11c2Vy
IGRhdGEgbGVha3MgYnkgYXZvaWRpbmcgcmV0dXJuIHNwZWN1bGF0aW9uLgpAQCAtMjQ3OCwyMSAr
MjQ3OCwyMSBAQCBjb25maWcgUkVUSFVOSwogCiBjb25maWcgQ1BVX1VOUkVUX0VOVFJZCiAJYm9v
bCAiRW5hYmxlIFVOUkVUIG9uIGtlcm5lbCBlbnRyeSIKLQlkZXBlbmRzIG9uIENQVV9TVVBfQU1E
ICYmIFJFVEhVTksKKwlkZXBlbmRzIG9uIENQVV9TVVBfQU1EICYmIFJFVEhVTksgJiYgWDg2XzY0
CiAJZGVmYXVsdCB5CiAJaGVscAogCSAgQ29tcGlsZSB0aGUga2VybmVsIHdpdGggc3VwcG9ydCBm
b3IgdGhlIHJldGJsZWVkPXVucmV0IG1pdGlnYXRpb24uCiAKIGNvbmZpZyBDUFVfSUJQQl9FTlRS
WQogCWJvb2wgIkVuYWJsZSBJQlBCIG9uIGtlcm5lbCBlbnRyeSIKLQlkZXBlbmRzIG9uIENQVV9T
VVBfQU1ECisJZGVwZW5kcyBvbiBDUFVfU1VQX0FNRCAmJiBYODZfNjQKIAlkZWZhdWx0IHkKIAlo
ZWxwCiAJICBDb21waWxlIHRoZSBrZXJuZWwgd2l0aCBzdXBwb3J0IGZvciB0aGUgcmV0YmxlZWQ9
aWJwYiBtaXRpZ2F0aW9uLgogCiBjb25maWcgQ1BVX0lCUlNfRU5UUlkKIAlib29sICJFbmFibGUg
SUJSUyBvbiBrZXJuZWwgZW50cnkiCi0JZGVwZW5kcyBvbiBDUFVfU1VQX0lOVEVMCisJZGVwZW5k
cyBvbiBDUFVfU1VQX0lOVEVMICYmIFg4Nl82NAogCWRlZmF1bHQgeQogCWhlbHAKIAkgIENvbXBp
bGUgdGhlIGtlcm5lbCB3aXRoIHN1cHBvcnQgZm9yIHRoZSBzcGVjdHJlX3YyPWlicnMgbWl0aWdh
dGlvbi4K


--=-wVBbTOsWawKDpi3hdrTS--

--=-JXaT9dkOb0vGUHXZOo/V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmLoHxMACgkQ57/I7JWG
EQnb2A/+PMBMUqFXMbWL7LQTHqv3c8n+joivIViNwT/PUBuUKO/QipHLX9M/LjME
7u4NtgKNhp6lkME7bexvhZNZMX4QJkuh5NyEhwvGSR4WkYSYn5gVtohW+5azjHnb
N4w14ZZveSw6sInH16cMK8FjZudb3U5Xw96t6ECHtUF2pyI8B9cy1KRREP0X52ly
0ruxVUNQuUAvWA1xbMySsaL2tlf3c5qbwygy0T0HQoDXiiOWHRDOFgI8AHICVbyv
Dgru4U3yFV2Vv9vbq+i61zp2wT2aPyMi8tLl+dE8Eb0iN7KJ1lBom0gwlQ5isyXq
w4HuKoRjFfH93UUHyxApi5uXWjMfLxOGDnSbv9iJ7ctpNbZbSKlyjKXtznLqEtT9
OLLm9cMPUesr429Su7frycrjXdHkwWY0Wdqslm4uFiCXVn8+Vzk0V3JNuN3K4mYW
vIPu42muJLbHNk6PFB4C0rGBn0UUUZnS83fefCNxFuxTe/ZfeVmeQpXwmMpywhH5
NhocKxDxmOybZ0sT7dJM1pz0cAOXunU2YUrwdKLnILKI/wFKXou8g5RsJU3q6EcT
VusYhpefiLOud9/mG8gxBE9gPQ2h+QA51+jgbxYUScKnYlHcboxt2/A0L3hPjNhr
+GTSYGCC+vUBmu6hBOO9fmKcjNIHvqMhMZnZNG420n8JAlWCWXs=
=bGBy
-----END PGP SIGNATURE-----

--=-JXaT9dkOb0vGUHXZOo/V--

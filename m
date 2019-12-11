Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E6C11C01D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 23:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLKWsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 17:48:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58420 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbfLKWsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 17:48:25 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifAmL-0000m1-Ul; Wed, 11 Dec 2019 22:48:22 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifAmL-0000da-H8; Wed, 11 Dec 2019 22:48:21 +0000
Message-ID: <cc141cf4643194c9a8f35370ca620e0aff4ef70e.camel@decadent.org.uk>
Subject: [stable] appletalk fixes
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Date:   Wed, 11 Dec 2019 22:48:16 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-TqXv6eO5P1JwHXuTdFdL"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-TqXv6eO5P1JwHXuTdFdL
Content-Type: multipart/mixed; boundary="=-SpIlJtLuD2yzq5v6Poc7"


--=-SpIlJtLuD2yzq5v6Poc7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pick the following for stable branches 4.4, 4.9, 4.14, 4.19:

commit 9804501fa1228048857910a6bf23e085aade37cc
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Thu Mar 14 13:47:59 2019 +0800

    appletalk: Fix potential NULL pointer dereference in unregister_snap_cl=
ient

commit c93ad1337ad06a718890a89cdd85188ff9a5a5cc
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Tue Apr 30 19:34:08 2019 +0800

    appletalk: Set error code if register_snap_client failed

The first commit doesn't apply cleanly to 4.4, 4.9, 4.14; you can use
the attached backport.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                       - Robert Coveyou



--=-SpIlJtLuD2yzq5v6Poc7
Content-Disposition: attachment;
	filename="appletalk-fix-potential-null-pointer-dereference-in.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="appletalk-fix-potential-null-pointer-dereference-in.patch";
	charset="UTF-8"

RnJvbTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPgpEYXRlOiBUaHUsIDE0IE1h
ciAyMDE5IDEzOjQ3OjU5ICswODAwClN1YmplY3Q6IGFwcGxldGFsazogRml4IHBvdGVudGlhbCBO
VUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4KIHVucmVnaXN0ZXJfc25hcF9jbGllbnQKCmNvbW1p
dCA5ODA0NTAxZmExMjI4MDQ4ODU3OTEwYTZiZjIzZTA4NWFhZGUzN2NjIHVwc3RyZWFtLgoKcmVn
aXN0ZXJfc25hcF9jbGllbnQgbWF5IHJldHVybiBOVUxMLCBhbGwgdGhlIGNhbGxlcnMKY2hlY2sg
aXQsIGJ1dCBvbmx5IHByaW50IGEgd2FybmluZy4gVGhpcyB3aWxsIHJlc3VsdCBpbgpOVUxMIHBv
aW50ZXIgZGVyZWZlcmVuY2UgaW4gdW5yZWdpc3Rlcl9zbmFwX2NsaWVudCBhbmQgb3RoZXIKcGxh
Y2VzLgoKSXQgaGFzIGFsd2F5cyBiZWVuIHVzZWQgbGlrZSB0aGlzIHNpbmNlIHYyLjYKClJlcG9y
dGVkLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+ClNpZ25lZC1v
ZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4KU2lnbmVkLW9mZi1ieTog
RGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PgpbYndoOiBCYWNrcG9ydGVkIHRv
IDw0LjE1OiBhZGp1c3QgY29udGV4dF0KU2lnbmVkLW9mZi1ieTogQmVuIEh1dGNoaW5ncyA8YmVu
QGRlY2FkZW50Lm9yZy51az4KLS0tCiBpbmNsdWRlL2xpbnV4L2F0YWxrLmggfCAgMiArLQogbmV0
L2FwcGxldGFsay9hYXJwLmMgIHwgMTUgKysrKysrKysrKysrLS0tCiBuZXQvYXBwbGV0YWxrL2Rk
cC5jICAgfCAyMCArKysrKysrKysrKystLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNl
cnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkKCi0tLSBhL2luY2x1ZGUvbGludXgvYXRhbGsuaAor
KysgYi9pbmNsdWRlL2xpbnV4L2F0YWxrLmgKQEAgLTEwNyw3ICsxMDcsNyBAQCBzdGF0aWMgX19p
bmxpbmVfXyBzdHJ1Y3QgZWxhcGFhcnAgKmFhcnBfCiAjZGVmaW5lIEFBUlBfUkVTT0xWRV9USU1F
CSgxMCAqIEhaKQogCiBleHRlcm4gc3RydWN0IGRhdGFsaW5rX3Byb3RvICpkZHBfZGwsICphYXJw
X2RsOwotZXh0ZXJuIHZvaWQgYWFycF9wcm90b19pbml0KHZvaWQpOworZXh0ZXJuIGludCBhYXJw
X3Byb3RvX2luaXQodm9pZCk7CiAKIC8qIEludGVyIG1vZHVsZSBleHBvcnRzICovCiAKLS0tIGEv
bmV0L2FwcGxldGFsay9hYXJwLmMKKysrIGIvbmV0L2FwcGxldGFsay9hYXJwLmMKQEAgLTg3OSwx
NSArODc5LDI0IEBAIHN0YXRpYyBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgYWFycF9ub3RpZmkKIAog
c3RhdGljIHVuc2lnbmVkIGNoYXIgYWFycF9zbmFwX2lkW10gPSB7IDB4MDAsIDB4MDAsIDB4MDAs
IDB4ODAsIDB4RjMgfTsKIAotdm9pZCBfX2luaXQgYWFycF9wcm90b19pbml0KHZvaWQpCitpbnQg
X19pbml0IGFhcnBfcHJvdG9faW5pdCh2b2lkKQogeworCWludCByYzsKKwogCWFhcnBfZGwgPSBy
ZWdpc3Rlcl9zbmFwX2NsaWVudChhYXJwX3NuYXBfaWQsIGFhcnBfcmN2KTsKLQlpZiAoIWFhcnBf
ZGwpCisJaWYgKCFhYXJwX2RsKSB7CiAJCXByaW50ayhLRVJOX0NSSVQgIlVuYWJsZSB0byByZWdp
c3RlciBBQVJQIHdpdGggU05BUC5cbiIpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CiAJc2V0dXBf
dGltZXIoJmFhcnBfdGltZXIsIGFhcnBfZXhwaXJlX3RpbWVvdXQsIDApOwogCWFhcnBfdGltZXIu
ZXhwaXJlcyAgPSBqaWZmaWVzICsgc3lzY3RsX2FhcnBfZXhwaXJ5X3RpbWU7CiAJYWRkX3RpbWVy
KCZhYXJwX3RpbWVyKTsKLQlyZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXIoJmFhcnBfbm90aWZp
ZXIpOworCXJjID0gcmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyKCZhYXJwX25vdGlmaWVyKTsK
KwlpZiAocmMpIHsKKwkJZGVsX3RpbWVyX3N5bmMoJmFhcnBfdGltZXIpOworCQl1bnJlZ2lzdGVy
X3NuYXBfY2xpZW50KGFhcnBfZGwpOworCX0KKwlyZXR1cm4gcmM7CiB9CiAKIC8qIFJlbW92ZSB0
aGUgQUFSUCBlbnRyaWVzIGFzc29jaWF0ZWQgd2l0aCBhIGRldmljZS4gKi8KLS0tIGEvbmV0L2Fw
cGxldGFsay9kZHAuYworKysgYi9uZXQvYXBwbGV0YWxrL2RkcC5jCkBAIC0xOTEyLDkgKzE5MTIs
NiBAQCBzdGF0aWMgdW5zaWduZWQgY2hhciBkZHBfc25hcF9pZFtdID0geyAwCiBFWFBPUlRfU1lN
Qk9MKGF0cnRyX2dldF9kZXYpOwogRVhQT1JUX1NZTUJPTChhdGFsa19maW5kX2Rldl9hZGRyKTsK
IAotc3RhdGljIGNvbnN0IGNoYXIgYXRhbGtfZXJyX3NuYXBbXSBfX2luaXRjb25zdCA9Ci0JS0VS
Tl9DUklUICJVbmFibGUgdG8gcmVnaXN0ZXIgRERQIHdpdGggU05BUC5cbiI7Ci0KIC8qIENhbGxl
ZCBieSBwcm90by5jIG9uIGtlcm5lbCBzdGFydCB1cCAqLwogc3RhdGljIGludCBfX2luaXQgYXRh
bGtfaW5pdCh2b2lkKQogewpAQCAtMTkyOSwxNyArMTkyNiwyMiBAQCBzdGF0aWMgaW50IF9faW5p
dCBhdGFsa19pbml0KHZvaWQpCiAJCWdvdG8gb3V0X3Byb3RvOwogCiAJZGRwX2RsID0gcmVnaXN0
ZXJfc25hcF9jbGllbnQoZGRwX3NuYXBfaWQsIGF0YWxrX3Jjdik7Ci0JaWYgKCFkZHBfZGwpCi0J
CXByaW50ayhhdGFsa19lcnJfc25hcCk7CisJaWYgKCFkZHBfZGwpIHsKKwkJcHJfY3JpdCgiVW5h
YmxlIHRvIHJlZ2lzdGVyIEREUCB3aXRoIFNOQVAuXG4iKTsKKwkJZ290byBvdXRfc29jazsKKwl9
CiAKIAlkZXZfYWRkX3BhY2soJmx0YWxrX3BhY2tldF90eXBlKTsKIAlkZXZfYWRkX3BhY2soJnBw
cHRhbGtfcGFja2V0X3R5cGUpOwogCiAJcmMgPSByZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXIo
JmRkcF9ub3RpZmllcik7CiAJaWYgKHJjKQotCQlnb3RvIG91dF9zb2NrOworCQlnb3RvIG91dF9z
bmFwOworCisJcmMgPSBhYXJwX3Byb3RvX2luaXQoKTsKKwlpZiAocmMpCisJCWdvdG8gb3V0X2Rl
djsKIAotCWFhcnBfcHJvdG9faW5pdCgpOwogCXJjID0gYXRhbGtfcHJvY19pbml0KCk7CiAJaWYg
KHJjKQogCQlnb3RvIG91dF9hYXJwOwpAQCAtMTk1MywxMSArMTk1NSwxMyBAQCBvdXRfcHJvYzoK
IAlhdGFsa19wcm9jX2V4aXQoKTsKIG91dF9hYXJwOgogCWFhcnBfY2xlYW51cF9tb2R1bGUoKTsK
K291dF9kZXY6CiAJdW5yZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXIoJmRkcF9ub3RpZmllcik7
Ci1vdXRfc29jazoKK291dF9zbmFwOgogCWRldl9yZW1vdmVfcGFjaygmcHBwdGFsa19wYWNrZXRf
dHlwZSk7CiAJZGV2X3JlbW92ZV9wYWNrKCZsdGFsa19wYWNrZXRfdHlwZSk7CiAJdW5yZWdpc3Rl
cl9zbmFwX2NsaWVudChkZHBfZGwpOworb3V0X3NvY2s6CiAJc29ja191bnJlZ2lzdGVyKFBGX0FQ
UExFVEFMSyk7CiBvdXRfcHJvdG86CiAJcHJvdG9fdW5yZWdpc3RlcigmZGRwX3Byb3RvKTsK


--=-SpIlJtLuD2yzq5v6Poc7--

--=-TqXv6eO5P1JwHXuTdFdL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3xcjAACgkQ57/I7JWG
EQkwvA/9HiDQSgDM02xpODy0IPzcCt4j3U3nuRmEY/9uTrfNeO5URvf7mrq894Tk
NrrEC8BJlwquVo61uR1g8QVEl+jgXjkFNyHrpnj87gnKNrb/rOotHOeCX7RJEXzG
Sek5qXdrHenc7i77OGBc0hElRjPe1RV4hK0zt9BbG5Ye6sM40AvOhAlDgVKu5nwN
HRvW/sCugAhD3DMqzuMNFh5OrAjCt0lJo7eqwAhEbwxNCtdZsjy6wrI8/OC5MheD
kBbCIJlOF4145A+G/6fBifQFpm8hCmNehU7pbxb0F3oXsWH1ld3nwkMh1Uh8d3Ux
/VDH4mhGa8sfmX44RmExkB8Ou8Tf2WSmZyL3fwtluONclPJFCUKc++deyqVTBNEu
Kq60YrnmrTailQQIgUSTnukXp0Cc9cEwVLctdYcGwjXO173fIZp7bloG9BMbyXWm
0bg06uOQ1ijRkUCezSo22VQ/MhXETn2ga3cswnugnRteXGy/JZeWLhco3qNa3X2i
Hol5mVXJNyRQBACTVool71bhx4pTuBUo90R+WEkNpSp+wcWTPXCWme2/asld12qP
V6zVBJJy1RRo+kAildEl9yVIdN4np0Lk/cC/KrbRTohU/z+Sy8g2367tW2qJWXGg
3aLNAmFH9dG5TI3+wbtyCyXA1BTNCi8Z4a8LvzdSLQfdz8SsQ7o=
=Y4Vf
-----END PGP SIGNATURE-----

--=-TqXv6eO5P1JwHXuTdFdL--

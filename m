Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D9459FC56
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiHXNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiHXNyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 09:54:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB8C84ED9
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 06:52:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2D3933438E;
        Wed, 24 Aug 2022 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661349148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UBVLAYB9K4zmo9TpX8miaAEpcH8Dab5FCfyS14SUX24=;
        b=oBaa3LMpCYpvXveNcirVOlKG1B4rTnR0gIGEeC/lIsgWpqZn/bte0Yt7y861AGbqJghUVk
        beVaZ84sxNnhb0GpPnMgmg9Sf2HBQbSusz08bX9b6gkopfyGzEbSO7qzJBKJeHDNZzkPGO
        AcmDsdftBlEA/wwF4S5QBI9R4Qr9Cyc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 068A613780;
        Wed, 24 Aug 2022 13:52:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bWMbABwtBmNcdgAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 24 Aug 2022 13:52:28 +0000
Message-ID: <1199e064-3311-09cd-283f-d74d5f5c48e3@suse.com>
Date:   Wed, 24 Aug 2022 15:52:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Backport request
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
References: <f02f8fb3-2e68-a405-aaef-adc769754bd3@suse.com>
 <YwYVIgnHnKUnoChu@kroah.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <YwYVIgnHnKUnoChu@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0Ho7txo44F4Pz1EBqHbGrKoo"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0Ho7txo44F4Pz1EBqHbGrKoo
Content-Type: multipart/mixed; boundary="------------tUyxgDTQAqmIJA8oEnyUuwpp";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Message-ID: <1199e064-3311-09cd-283f-d74d5f5c48e3@suse.com>
Subject: Re: Backport request
References: <f02f8fb3-2e68-a405-aaef-adc769754bd3@suse.com>
 <YwYVIgnHnKUnoChu@kroah.com>
In-Reply-To: <YwYVIgnHnKUnoChu@kroah.com>

--------------tUyxgDTQAqmIJA8oEnyUuwpp
Content-Type: multipart/mixed; boundary="------------3Prv0lK3oZQzkdrsP0xjOYXj"

--------------3Prv0lK3oZQzkdrsP0xjOYXj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMDguMjIgMTQ6MTAsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gT24gV2Vk
LCBBdWcgMjQsIDIwMjIgYXQgMDE6MjA6MjJQTSArMDIwMCwgSnVlcmdlbiBHcm9zcyB3cm90
ZToNCj4+IEhpIEdyZWcsDQo+Pg0KPj4gc3RhYmxlIGtlcm5lbHMgNS4xOCBhbmQgNS4xNSBz
ZWVtIHRvIGJlIG1pc3NpbmcgdXBzdHJlYW0gcGF0Y2gNCj4+IGM2NGNjMjgwMmE3OCAoIng4
Ni9lbnRyeTogTW92ZSBDTEQgdG8gdGhlIHN0YXJ0IG9mIHRoZSBpZHRlbnRyeSBtYWNybyIp
Lg0KPj4gVGhpcyBpcyBhIHByZXJlcXVpc2l0ZSBwYXRjaCBmb3IgNjRjYmQwYWNiNTgyICgi
eDg2L2VudHJ5OiBEb24ndCBjYWxsDQo+PiBlcnJvcl9lbnRyeSgpIGZvciBYRU5QViIpLCB3
aGljaCBpcyBpbmNsdWRlZCBpbiA1LjE1LnkgYW5kIDUuMTgueS4NCj4+DQo+PiBDb3VsZCB5
b3UgcGxlYXNlIHRha2UgYzY0Y2MyODAyYTc4IGZvciA1LjE1IGFuZCA1LjE4Pw0KPiANCj4g
NS4xOCBpcyBlbmQtb2YtbGlmZSwgc28gdGhhdCdzIGltcG9zc2libGUgdG8gZG8gbm93IDoo
DQo+IA0KPiBGb3IgNS4xNS55LCB0aGUgY29tbWl0IGRvZXMgbm90IGFwcGx5IGNsZWFubHks
IGNhbiB5b3UgcHJvdmlkZSBhIHdvcmtpbmcNCj4gYmFja3BvcnQ/DQoNCkF0dGFjaGVkLg0K
DQoNCkp1ZXJnZW4NCg0K
--------------3Prv0lK3oZQzkdrsP0xjOYXj
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-x86-entry-Move-CLD-to-the-start-of-the-idtentry-macr.patch"
Content-Disposition: attachment;
 filename*0="0001-x86-entry-Move-CLD-to-the-start-of-the-idtentry-macr.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAwODJmNDBlODBjMTVjN2IxMTczYzA4NTcwMTRlMzBlZWYxNDcxYWZkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMYWkgSmlhbmdzaGFuIDxqaWFuZ3NoYW4ubGpzQGFu
dGdyb3VwLmNvbT4KRGF0ZTogVGh1LCAyMSBBcHIgMjAyMiAyMjoxMDo1MSArMDgwMApTdWJq
ZWN0OiBbUEFUQ0hdIHg4Ni9lbnRyeTogTW92ZSBDTEQgdG8gdGhlIHN0YXJ0IG9mIHRoZSBp
ZHRlbnRyeSBtYWNybwoKY29tbWl0IGM2NGNjMjgwMmE3ODRlY2ZkMjVkMzk5NDVlNTdlN2Ex
NDc4NTRhNWIgdXBzdHJlYW0uCgpNb3ZlIGl0IGFmdGVyIENMQUMuCgpTdWdnZXN0ZWQtYnk6
IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KU2lnbmVkLW9mZi1ieTog
TGFpIEppYW5nc2hhbiA8amlhbmdzaGFuLmxqc0BhbnRncm91cC5jb20+ClNpZ25lZC1vZmYt
Ynk6IEJvcmlzbGF2IFBldGtvdiA8YnBAc3VzZS5kZT4KTGluazogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvci8yMDIyMDUwMzAzMjEwNy42ODAxOTAtNS1qaWFuZ3NoYW5sYWlAZ21haWwu
Y29tClNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4KLS0t
CiBhcmNoL3g4Ni9lbnRyeS9lbnRyeV82NC5TIHwgOCArKysrKy0tLQogMSBmaWxlIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9lbnRyeS9lbnRyeV82NC5TIGIvYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUwppbmRl
eCA3NjNmZjI0M2FlY2EuLmEzYWYyYTkxNTliMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvZW50
cnkvZW50cnlfNjQuUworKysgYi9hcmNoL3g4Ni9lbnRyeS9lbnRyeV82NC5TCkBAIC0zNzMs
NiArMzczLDcgQEAgU1lNX0NPREVfRU5EKHhlbl9lcnJvcl9lbnRyeSkKIFNZTV9DT0RFX1NU
QVJUKFxhc21zeW0pCiAJVU5XSU5EX0hJTlRfSVJFVF9SRUdTIG9mZnNldD1caGFzX2Vycm9y
X2NvZGUqOAogCUFTTV9DTEFDCisJY2xkCiAKIAkuaWYgXGhhc19lcnJvcl9jb2RlID09IDAK
IAkJcHVzaHEJJC0xCQkJLyogT1JJR19SQVg6IG5vIHN5c2NhbGwgdG8gcmVzdGFydCAqLwpA
QCAtNDQwLDYgKzQ0MSw3IEBAIFNZTV9DT0RFX0VORChcYXNtc3ltKQogU1lNX0NPREVfU1RB
UlQoXGFzbXN5bSkKIAlVTldJTkRfSElOVF9JUkVUX1JFR1MKIAlBU01fQ0xBQworCWNsZAog
CiAJcHVzaHEJJC0xCQkJLyogT1JJR19SQVg6IG5vIHN5c2NhbGwgdG8gcmVzdGFydCAqLwog
CkBAIC00OTUsNiArNDk3LDcgQEAgU1lNX0NPREVfRU5EKFxhc21zeW0pCiBTWU1fQ09ERV9T
VEFSVChcYXNtc3ltKQogCVVOV0lORF9ISU5UX0lSRVRfUkVHUwogCUFTTV9DTEFDCisJY2xk
CiAKIAkvKgogCSAqIElmIHRoZSBlbnRyeSBpcyBmcm9tIHVzZXJzcGFjZSwgc3dpdGNoIHN0
YWNrcyBhbmQgdHJlYXQgaXQgYXMKQEAgLTU1Nyw2ICs1NjAsNyBAQCBTWU1fQ09ERV9FTkQo
XGFzbXN5bSkKIFNZTV9DT0RFX1NUQVJUKFxhc21zeW0pCiAJVU5XSU5EX0hJTlRfSVJFVF9S
RUdTIG9mZnNldD04CiAJQVNNX0NMQUMKKwljbGQKIAogCS8qIHBhcmFub2lkX2VudHJ5IHJl
dHVybnMgR1MgaW5mb3JtYXRpb24gZm9yIHBhcmFub2lkX2V4aXQgaW4gRUJYLiAqLwogCWNh
bGwJcGFyYW5vaWRfZW50cnkKQEAgLTg3Niw3ICs4ODAsNiBAQCBTWU1fQ09ERV9FTkQoeGVu
X2ZhaWxzYWZlX2NhbGxiYWNrKQogICovCiBTWU1fQ09ERV9TVEFSVF9MT0NBTChwYXJhbm9p
ZF9lbnRyeSkKIAlVTldJTkRfSElOVF9GVU5DCi0JY2xkCiAJUFVTSF9BTkRfQ0xFQVJfUkVH
UyBzYXZlX3JldD0xCiAJRU5DT0RFX0ZSQU1FX1BPSU5URVIgOAogCkBAIC0xMDEyLDcgKzEw
MTUsNiBAQCBTWU1fQ09ERV9FTkQocGFyYW5vaWRfZXhpdCkKICAqLwogU1lNX0NPREVfU1RB
UlRfTE9DQUwoZXJyb3JfZW50cnkpCiAJVU5XSU5EX0hJTlRfRlVOQwotCWNsZAogCiAJUFVT
SF9BTkRfQ0xFQVJfUkVHUyBzYXZlX3JldD0xCiAJRU5DT0RFX0ZSQU1FX1BPSU5URVIgOApA
QCAtMTE1NSw2ICsxMTU3LDcgQEAgU1lNX0NPREVfU1RBUlQoYXNtX2V4Y19ubWkpCiAJICov
CiAKIAlBU01fQ0xBQworCWNsZAogCiAJLyogVXNlICVyZHggYXMgb3VyIHRlbXAgdmFyaWFi
bGUgdGhyb3VnaG91dCAqLwogCXB1c2hxCSVyZHgKQEAgLTExNzQsNyArMTE3Nyw2IEBAIFNZ
TV9DT0RFX1NUQVJUKGFzbV9leGNfbm1pKQogCSAqLwogCiAJc3dhcGdzCi0JY2xkCiAJRkVO
Q0VfU1dBUEdTX1VTRVJfRU5UUlkKIAlTV0lUQ0hfVE9fS0VSTkVMX0NSMyBzY3JhdGNoX3Jl
Zz0lcmR4CiAJbW92cQklcnNwLCAlcmR4Ci0tIAoyLjM1LjMKCg==
--------------3Prv0lK3oZQzkdrsP0xjOYXj
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------3Prv0lK3oZQzkdrsP0xjOYXj--

--------------tUyxgDTQAqmIJA8oEnyUuwpp--

--------------0Ho7txo44F4Pz1EBqHbGrKoo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMGLRsFAwAAAAAACgkQsN6d1ii/Ey+8
Dgf/YIZjCyYdv3wDl6Dn2odZQG5UsbRNCx3ISZvCtQ2xGAGU+OBjtc3sBDnWYIniEkjHTrGT3HhV
wfDuDBQzM3L0HzTnEuAbvLTejKAFKw4qTejCrQxhmbBK0DrHAHt2uRSIJn5sXq37U6DPk6SMeTnC
IPZDovExn6RUUg0Vlfyw+Maq0YGF1ESnoLRFIZfYQ1z6KSGVOpXhUKfLAMirpRH5Q1uozSA98UFs
9iexxQe0kDW6TFSzdejWHJzHaVVzlAv1Ev3gmots012A9/ZjzQ3IksOqREZFhUJuWt04eLkkrZ/6
fF8SAhkhcSqhQuYjVSoaslmWGbbD8Gdu92o1PbtooA==
=W4tC
-----END PGP SIGNATURE-----

--------------0Ho7txo44F4Pz1EBqHbGrKoo--

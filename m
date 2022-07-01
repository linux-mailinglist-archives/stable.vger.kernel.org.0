Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2857562B1E
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 07:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiGAF4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 01:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiGAF4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 01:56:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49F76B27C
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 22:56:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 468EC21C26;
        Fri,  1 Jul 2022 05:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656654989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qGY+fb4jHEgpNQOrTyUGd4p4le7j0ClKGpEy809VyLI=;
        b=UrcglVgtxl9CKCufg5DLg0hHRQxzUJ7hTOf3jc4y0lT1wFLyNK+B8yOY3e7KeByaqnlxVq
        DuatSpsjkyd5j3vlb31799JeH3A50ZozKZqd/dpEwnooMY6pCmKPxWS7Ko1F3Sn0089tZB
        mvTioCvFFarcP3Xg8ylYRKwCPFJh+oA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A2CF13A20;
        Fri,  1 Jul 2022 05:56:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UtDxBI2MvmJEDAAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 01 Jul 2022 05:56:29 +0000
Message-ID: <1c3bfe41-b86d-660c-6ccf-17777d1a5801@suse.com>
Date:   Fri, 1 Jul 2022 07:56:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
Content-Language: en-US
To:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
 <Yr2KKpWSiuzOQr7v@kroah.com> <5136812e-e296-4acb-cafd-f189c4013ed3@suse.com>
 <Yr3VQaM0NBcIV2Kl@itl-email>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <Yr3VQaM0NBcIV2Kl@itl-email>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------e8U5GsjWGwcFuQTgLqHD4612"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------e8U5GsjWGwcFuQTgLqHD4612
Content-Type: multipart/mixed; boundary="------------aQbktJ2tEprMjgd7033LRGfL";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Xen developer discussion <xen-devel@lists.xenproject.org>
Message-ID: <1c3bfe41-b86d-660c-6ccf-17777d1a5801@suse.com>
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
 <Yr2KKpWSiuzOQr7v@kroah.com> <5136812e-e296-4acb-cafd-f189c4013ed3@suse.com>
 <Yr3VQaM0NBcIV2Kl@itl-email>
In-Reply-To: <Yr3VQaM0NBcIV2Kl@itl-email>

--------------aQbktJ2tEprMjgd7033LRGfL
Content-Type: multipart/mixed; boundary="------------kcDGp3wXm6PeKrV2bwHWB0nV"

--------------kcDGp3wXm6PeKrV2bwHWB0nV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzAuMDYuMjIgMTg6NTQsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4gT24gVGh1
LCBKdW4gMzAsIDIwMjIgYXQgMDM6MTY6NDFQTSArMDIwMCwgSnVlcmdlbiBHcm9zcyB3cm90
ZToNCj4+IE9uIDMwLjA2LjIyIDEzOjM0LCBHcmVnIEtIIHdyb3RlOg0KPj4+IE9uIE1vbiwg
SnVuIDI3LCAyMDIyIGF0IDAyOjEwOjAyUE0gLTA0MDAsIERlbWkgTWFyaWUgT2Jlbm91ciB3
cm90ZToNCj4+Pj4gY29tbWl0IGRiZTk3Y2ZmN2RkOWYwZjc1YzUyNGFmZGQ1NWFkNDZiZTNk
MTUyOTUgdXBzdHJlYW0NCj4+Pj4NCj4+Pj4gdW5tYXBfZ3JhbnRfcGFnZXMoKSBjdXJyZW50
bHkgd2FpdHMgZm9yIHRoZSBwYWdlcyB0byBubyBsb25nZXIgYmUgdXNlZC4NCj4+Pj4gSW4g
aHR0cHM6Ly9naXRodWIuY29tL1F1YmVzT1MvcXViZXMtaXNzdWVzL2lzc3Vlcy83NDgxLCB0
aGlzIGxlYWQgdG8gYQ0KPj4+PiBkZWFkbG9jayBhZ2FpbnN0IGk5MTU6IGk5MTUgd2FzIHdh
aXRpbmcgZm9yIGdudGRldidzIE1NVSBub3RpZmllciB0bw0KPj4+PiBmaW5pc2gsIHdoaWxl
IGdudGRldiB3YXMgd2FpdGluZyBmb3IgaTkxNSB0byBmcmVlIGl0cyBwYWdlcy4gIEkgYWxz
bw0KPj4+PiBiZWxpZXZlIHRoaXMgaXMgcmVzcG9uc2libGUgZm9yIHZhcmlvdXMgZGVhZGxv
Y2tzIEkgaGF2ZSBleHBlcmllbmNlZCBpbg0KPj4+PiB0aGUgcGFzdC4NCj4+Pj4NCj4+Pj4g
QXZvaWQgdGhlc2UgcHJvYmxlbXMgYnkgbWFraW5nIHVubWFwX2dyYW50X3BhZ2VzIGFzeW5j
LiAgVGhpcyByZXF1aXJlcw0KPj4+PiBtYWtpbmcgaXQgcmV0dXJuIHZvaWQsIGFzIGFueSBl
cnJvcnMgd2lsbCBub3QgYmUgYXZhaWxhYmxlIHdoZW4gdGhlDQo+Pj4+IGZ1bmN0aW9uIHJl
dHVybnMuICBGb3J0dW5hdGVseSwgdGhlIG9ubHkgdXNlIG9mIHRoZSByZXR1cm4gdmFsdWUg
aXMgYQ0KPj4+PiBXQVJOX09OKCksIHdoaWNoIGNhbiBiZSByZXBsYWNlZCBieSBhIFdBUk5f
T04gd2hlbiB0aGUgZXJyb3IgaXMNCj4+Pj4gZGV0ZWN0ZWQuICBBZGRpdGlvbmFsbHksIGEg
ZmFpbGVkIGNhbGwgd2lsbCBub3QgcHJldmVudCBmdXJ0aGVyIGNhbGxzDQo+Pj4+IGZyb20g
YmVpbmcgbWFkZSwgYnV0IHRoaXMgaXMgaGFybWxlc3MuDQo+Pj4+DQo+Pj4+IEJlY2F1c2Ug
dW5tYXBfZ3JhbnRfcGFnZXMgaXMgbm93IGFzeW5jLCB0aGUgZ3JhbnQgaGFuZGxlIHdpbGwg
YmUgc2VudCB0bw0KPj4+PiBJTlZBTElEX0dSQU5UX0hBTkRMRSB0b28gbGF0ZSB0byBwcmV2
ZW50IG11bHRpcGxlIHVubWFwcyBvZiB0aGUgc2FtZQ0KPj4+PiBoYW5kbGUuICBJbnN0ZWFk
LCBhIHNlcGFyYXRlIGJvb2wgYXJyYXkgaXMgYWxsb2NhdGVkIGZvciB0aGlzIHB1cnBvc2Uu
DQo+Pj4+IFRoaXMgd2FzdGVzIG1lbW9yeSwgYnV0IHN0dWZmaW5nIHRoaXMgaW5mb3JtYXRp
b24gaW4gcGFkZGluZyBieXRlcyBpcw0KPj4+PiB0b28gZnJhZ2lsZS4gIEZ1cnRoZXJtb3Jl
LCBpdCBpcyBuZWNlc3NhcnkgdG8gZ3JhYiBhIHJlZmVyZW5jZSB0byB0aGUNCj4+Pj4gbWFw
IGJlZm9yZSBtYWtpbmcgdGhlIGFzeW5jaHJvbm91cyBjYWxsLCBhbmQgcmVsZWFzZSB0aGUg
cmVmZXJlbmNlIHdoZW4NCj4+Pj4gdGhlIGNhbGwgcmV0dXJucy4NCj4+Pj4NCj4+Pj4gSXQg
aXMgYWxzbyBuZWNlc3NhcnkgdG8gZ3VhcmQgYWdhaW5zdCByZWVudHJhbmN5IGluIGdudGRl
dl9tYXBfcHV0KCksDQo+Pj4+IGFuZCB0byBoYW5kbGUgdGhlIGNhc2Ugd2hlcmUgdXNlcnNw
YWNlIHRyaWVzIHRvIG1hcCBhIG1hcHBpbmcgd2hvc2UNCj4+Pj4gY29udGVudHMgaGF2ZSBu
b3QgYWxsIGJlZW4gZnJlZWQgeWV0Lg0KPj4+Pg0KPj4+PiBGaXhlczogNzQ1MjgyMjU2Yzc1
ICgieGVuL2dudGRldjogc2FmZWx5IHVubWFwIGdyYW50cyBpbiBjYXNlIHRoZXkgYXJlIHN0
aWxsIGluIHVzZSIpDQo+Pj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+Pj4+IFNp
Z25lZC1vZmYtYnk6IERlbWkgTWFyaWUgT2Jlbm91ciA8ZGVtaUBpbnZpc2libGV0aGluZ3Ns
YWIuY29tPg0KPj4+PiBSZXZpZXdlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2Uu
Y29tPg0KPj4+PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIwNjIyMDIy
NzI2LjI1MzgtMS1kZW1pQGludmlzaWJsZXRoaW5nc2xhYi5jb20NCj4+Pj4gU2lnbmVkLW9m
Zi1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KPj4+PiAtLS0NCj4+Pj4g
ICAgZHJpdmVycy94ZW4vZ250ZGV2LWNvbW1vbi5oIHwgICA3ICsrDQo+Pj4+ICAgIGRyaXZl
cnMveGVuL2dudGRldi5jICAgICAgICB8IDE0MiArKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0NCj4+Pj4gICAgMiBmaWxlcyBjaGFuZ2VkLCAxMDYgaW5zZXJ0aW9ucygr
KSwgNDMgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBBbGwgbm93IHF1ZXVlZCB1cCwgdGhhbmtz
Lg0KPj4NCj4+IFNvcnJ5LCBidXQgSSB0aGluayBhdCBsZWFzdCB0aGUgdmVyc2lvbiBmb3Ig
NS4xMCBpcyBmaXNoeSwgYXMgaXQgcmVtb3Zlcw0KPj4gdGhlIHRlc3RzIGZvciBzdWNjZXNz
ZnVsIGFsbG9jYXRpb25zIG9mIGFkZC0+bWFwX29wcyBhbmQgYWRkLT51bm1hcF9vcHMuDQo+
IA0KPiBUaGF0IGlzIGRlZmluaXRlbHkgYSBidWc7IEkgd2lsbCBzZW5kIGFub3RoZXIgdmVy
c2lvbiAod2l0aG91dCB5b3VyDQo+IFJldmlld2VkLWJ5KS4NCj4gDQo+PiBJIG5lZWQgdG8g
ZG8gYSB0aG9yb3VnaCByZXZpZXcgb2YgdGhlIHBhdGNoZXMgKHRoZSAiUmV2aWV3ZWQtYnk6
IiB0YWcgaW4NCj4+IHRoZSBwYXRjaGVzIGlzIHRoZSBvbmUgZm9yIHRoZSB1cHN0cmVhbSBw
YXRjaCkuDQo+IA0KPiBZZWFoLCB0aGF0IHdhcyBteSBmYXVsdCwgc29ycnkuDQo+IA0KPj4g
R3JlZywgY2FuIHlvdSBwbGVhc2Ugd2FpdCBmb3IgbXkgZXhwbGljaXQgIm9rYXkiIGZvciB0
aGUgYmFja3BvcnRzPw0KPiANCj4gQ29uZmlybWluZyB0aGF0IHRoZXNlIHBhdGNoZXMgZG8g
bmVlZCByZXZpZXcgYmVmb3JlIHRoZXkgY2FuIGJlIGFwcGxpZWQuDQo+IEp1ZXJnZW4sIHdv
dWxkIHlvdSBtaW5kIG1ha2luZyBzdXJlIHRoYXQgdGhlIHVwc3RyZWFtIHBhdGNoIHdhcyBh
bHNvDQo+IGNvcnJlY3QgZm9yIDUuMTUgYW5kIDUuMTg/ICBJdCBhcHBsaWVkIGNsZWFubHks
IGJ1dCB0aGF0IGlzIG5vIGd1YXJhbnRlZQ0KPiBvZiBjb3JyZWN0bmVzcy4NCg0KVGhvc2Ug
dHdvIGFyZSBmaW5lLg0KDQoNCkp1ZXJnZW4NCg==
--------------kcDGp3wXm6PeKrV2bwHWB0nV
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------kcDGp3wXm6PeKrV2bwHWB0nV--

--------------aQbktJ2tEprMjgd7033LRGfL--

--------------e8U5GsjWGwcFuQTgLqHD4612
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmK+jIwFAwAAAAAACgkQsN6d1ii/Ey/y
9AgAmLODtE5pc6JWFdsb5L9GPw2SUn5SZlRNTZqIFQRK5NYgAQaCwyIJ0gZANW4D2MYj/YE30Q7M
u/U6f6PqJIZdxe8UevPpI5tsZOJ1EkQINEI1VMpt7d0nSSdkBM6+7nOKFfphs5+sy/tAOh6HBYHn
eIWzq5M/2bXdc4I4HTDOLsUgoj8gG61m3kiS1w1fW8mOQKtE8A4oL5inIbFECLweSO8KNO516tWz
1VjywIm+qMEPHUz9LXAptdDX8tWGe0j3XX+yNfkpBUl0moKyXoAuF3i3lK0ymzsfllLgmEtDG7hL
jFUUICYmQjf9cBaPryER3Nx84xR+YpqED8WzYlTl1Q==
=YfaH
-----END PGP SIGNATURE-----

--------------e8U5GsjWGwcFuQTgLqHD4612--

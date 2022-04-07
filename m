Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E54B4F7A64
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiDGIxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbiDGIxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:53:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAB7E92;
        Thu,  7 Apr 2022 01:50:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5A5EC21117;
        Thu,  7 Apr 2022 08:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649321457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6SzK6SzOgNWz1m/SzosRnb7vWlnb02hg+E4YETlNzYU=;
        b=Fv7RgqTwrGDFRVK8OyrzYTjVn6wJQjiS3DmVe55+4UZu/AlxWAmlwWwXrxBUzDtnt18eit
        PWpp4aawl7rCmHQPgJojrn2Ogw1gptw5r+02Wj1fBq0Q+F6flTQzAB5O0aRpOZARDK3/uc
        0dbBqCiH+jIHx63L2+TxOEuQw8vgAXA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1BF213A66;
        Thu,  7 Apr 2022 08:50:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CCuBOfClTmKqGAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Apr 2022 08:50:56 +0000
Message-ID: <4f1908b5-5674-a772-3cd9-78e4dc40f776@suse.com>
Date:   Thu, 7 Apr 2022 10:50:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Michal Hocko <mhocko@kernel.org>
References: <20220406133229.15979-1-jgross@suse.com>
 <89ad978d-e95e-d3ea-5c8f-acf4b28f992c@redhat.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/balloon: fix page onlining when populating new zone
In-Reply-To: <89ad978d-e95e-d3ea-5c8f-acf4b28f992c@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OMFgksYuijuhI3hZ2iAJlos0"
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OMFgksYuijuhI3hZ2iAJlos0
Content-Type: multipart/mixed; boundary="------------Pgc0gcsWI2D0D5pFykv836Uc";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: David Hildenbrand <david@redhat.com>, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@kernel.org>
Message-ID: <4f1908b5-5674-a772-3cd9-78e4dc40f776@suse.com>
Subject: Re: [PATCH] xen/balloon: fix page onlining when populating new zone
References: <20220406133229.15979-1-jgross@suse.com>
 <89ad978d-e95e-d3ea-5c8f-acf4b28f992c@redhat.com>
In-Reply-To: <89ad978d-e95e-d3ea-5c8f-acf4b28f992c@redhat.com>

--------------Pgc0gcsWI2D0D5pFykv836Uc
Content-Type: multipart/mixed; boundary="------------lBWdgohUpDbOpCr4EznLRraE"

--------------lBWdgohUpDbOpCr4EznLRraE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDQuMjIgMTA6MjMsIERhdmlkIEhpbGRlbmJyYW5kIHdyb3RlOg0KPiBPbiAwNi4w
NC4yMiAxNTozMiwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+IFdoZW4gb25saW5pbmcgYSBu
ZXcgbWVtb3J5IHBhZ2UgaW4gYSBndWVzdCB0aGUgWGVuIGJhbGxvb24gZHJpdmVyIGlzDQo+
PiBhZGRpbmcgaXQgdG8gdGhlIGJhbGxvb25lZCBwYWdlcyBpbnN0ZWFkIG1ha2luZyBpdCBh
dmFpbGFibGUgdG8gYmUNCj4+IHVzZWQgaW1tZWRpYXRlbHkuIFRoaXMgaXMgbWVhbnQgdG8g
ZW5hYmxlIHRvIGFkZCBhIG5ldyB1cHBlciBtZW1vcnkNCj4+IGxpbWl0IHRvIGEgZ3Vlc3Qg
dmlhIGhvdHBsdWdnaW5nIG1lbW9yeSwgd2l0aG91dCBoYXZpbmcgdG8gYXNzaWduIHRoZQ0K
Pj4gbmV3IG1lbW9yeSBpbiBvbmUgZ28uDQo+Pg0KPj4gSW4gY2FzZSB0aGUgdXBwZXIgbWVt
b3J5IGxpbWl0IHdpbGwgYmUgcmFpc2VkIGFib3ZlIDRHLCB0aGUgbmV3IG1lbW9yeQ0KPj4g
d2lsbCBwb3B1bGF0ZSB0aGUgWk9ORV9OT1JNQUwgbWVtb3J5IHpvbmUsIHdoaWNoIHdhc24n
dCBwb3B1bGF0ZWQNCj4+IGJlZm9yZS4gVGhlIG5ld2x5IHBvcHVsYXRlZCB6b25lIHdvbid0
IGJlIGFkZGVkIHRvIHRoZSBsaXN0IG9mIHpvbmVzDQo+PiBsb29rZWQgYXQgYnkgdGhlIHBh
Z2UgYWxsb2NhdG9yIHRob3VnaCwgYXMgb25seSB6b25lcyB3aXRoIGF2YWlsYWJsZQ0KPj4g
bWVtb3J5IGFyZSBiZWluZyBhZGRlZCwgYW5kIHRoZSBtZW1vcnkgaXNuJ3QgeWV0IGF2YWls
YWJsZSBhcyBpdCBpcw0KPj4gYmFsbG9vbmVkIG91dC4NCj4gDQo+IEkgdGhpbmsgd2UganVz
dCByZWNlbnRseSBkaXNjdXNzZWQgdGhlc2UgY29ybmVyIGNhc2VzIG9uIHRoZSAtbW0gbGlz
dC4NCg0KSW5kZWVkLg0KDQo+IFRoZSBpc3N1ZSBpcyBoYXZpbmcgZWZmZWN0aXZlbHkgcG9w
dWxhdGVkIHpvbmVzIHdpdGhvdXQgbWFuYWdlcyBwYWdlcw0KPiBiZWNhdXNlIGV2ZXJ5dGhp
bmcgaXMgaW5mbGF0ZWQgaW4gYSBiYWxsb29uLg0KDQpDb3JyZWN0Lg0KDQo+IFRoYXQgY2Fu
IHRoZW9yZXRpY2FsbHkgYWxzbyBoYXBwZW4gd2hlbiBtYW5hZ2luZyB0byBmdWxseSBpbmZs
YXRlIHRoZQ0KPiBiYWxsb29uIGluIG9uZSB6b25lIGFuZCB0aGVuLCBzb21laG93LCB0aGUg
em9uZXMgZ2V0IHJlYnVpbHQuDQoNCkkgdGhpbmsgeW91IGFyZSByaWdodC4gSSBkaWRuJ3Qg
dGhpbmsgb2YgdGhhdCBzY2VuYXJpby4NCg0KPiBidWlsZF96b25lcmVmc19ub2RlKCkgZG9j
dW1lbnRzICJBZGQgYWxsIHBvcHVsYXRlZCB6b25lcyBvZiBhIG5vZGUgdG8NCj4gdGhlIHpv
bmVsaXN0IiBidXQgY2hlY2tzIGZvciBtYW5hZ2VkIHpvbmVzLCB3aGljaCBpcyB3cm9uZy4N
Cj4gDQo+IFNlZSBodHRwczovL2xrbWwua2VybmVsLm9yZy9yLzIwMjIwMjAxMDcwMDQ0Lnpi
bTNvYnNvaW1oejN4ZDNAbWFzdGVyDQoNCkkgZm91bmQgY29tbWl0IDZhYTMwM2RlZmI3NDU0
IHdoaWNoIGludHJvZHVjZWQgdGhpcyB0ZXN0LiBJIHRob3VnaHQNCml0IHdhcyBuZWVkZWQg
ZHVlIHRvIHRoZSBwcm9ibGVtIHRoaXMgY29tbWl0IHRyaWVkIHRvIHNvbHZlLiBNYXliZSBJ
DQp3YXMgd3JvbmcgYW5kIHRoYXQgY29tbWl0IHNob3VsZG4ndCBoYXZlIGNoYW5nZWQgdGhl
IGNvbmRpdGlvbiB3aGVuDQpidWlsZGluZyB0aGUgem9uZWxpc3QsIGJ1dCBqdXN0IHRoZSBv
bmVzIGluIHRoZSBhbGxvY2F0aW9uIHBhdGhzLg0KDQo+IA0KPj4NCj4+IFRoaXMgd2lsbCBy
ZXN1bHQgaW4gdGhlIG5ldyBtZW1vcnkgYmVpbmcgYXNzaWduZWQgdG8gdGhlIGd1ZXN0LCBi
dXQNCj4+IHdpdGhvdXQgdGhlIGFsbG9jYXRvciBiZWluZyBhYmxlIHRvIHVzZSBpdC4NCj4+
DQo+PiBXaGVuIHJ1bm5pbmcgYXMgYSBQViBndWVzdCB0aGUgc2l0dWF0aW9uIGlzIGV2ZW4g
d29yc2U6IHdoZW4gaGF2aW5nDQo+PiBiZWVuIHN0YXJ0ZWQgd2l0aCBsZXNzIG1lbW9yeSB0
aGFuIGFsbG93ZWQsIGFuZCB0aGUgdXBwZXIgbGltaXQgYmVpbmcNCj4+IGxvd2VyIHRoYW4g
NEcsIGJhbGxvb25pbmcgdXAgd2lsbCBoYXZlIHRoZSBzYW1lIGVmZmVjdCBhcyBob3RwbHVn
Z2luZw0KPj4gbmV3IG1lbW9yeS4gVGhpcyBpcyBkdWUgdG8gdGhlIHVzYWdlIG9mIHRoZSB6
b25lIGRldmljZSBmdW5jdGlvbmFsaXR5DQo+PiBzaW5jZSBjb21taXQgOWUyMzY5YzA2Yzhh
ICgieGVuOiBhZGQgaGVscGVycyB0byBhbGxvY2F0ZSB1bnBvcHVsYXRlZA0KPj4gbWVtb3J5
IikgZm9yIGNyZWF0aW5nIG1hcHBpbmdzIG9mIG90aGVyIGd1ZXN0J3MgcGFnZXMsIHdoaWNo
IGFzIGEgc2lkZQ0KPj4gZWZmZWN0IGlzIGJlaW5nIHVzZWQgZm9yIFBWIGd1ZXN0IGJhbGxv
b25pbmcsIHRvby4NCj4+DQo+PiBGaXggdGhpcyBieSBjaGVja2luZyBpbiB4ZW5fb25saW5l
X3BhZ2UoKSB3aGV0aGVyIHRoZSBuZXcgbWVtb3J5IHBhZ2UNCj4+IHdpbGwgYmUgdGhlIGZp
cnN0IGluIGEgbmV3IHpvbmUuIElmIHRoaXMgaXMgdGhlIGNhc2UsIGFkZCBhbm90aGVyIHBh
Z2UNCj4+IHRvIHRoZSBiYWxsb29uIGFuZCB1c2UgdGhlIGZpcnN0IG1lbW9yeSBwYWdlIG9m
IHRoZSBuZXcgY2h1bmsgYXMgYQ0KPj4gcmVwbGFjZW1lbnQgZm9yIHRoaXMgbm93IGJhbGxv
b25lZCBvdXQgcGFnZS4gVGhpcyB3aWxsIHJlc3VsdCBpbiB0aGUNCj4+IG5ld2x5IHBvcHVs
YXRlZCB6b25lIGNvbnRhaW5pbmcgb25lIHBhZ2UgYmVpbmcgYXZhaWxhYmxlIGZvciB0aGUg
cGFnZQ0KPj4gYWxsb2NhdG9yLCB3aGljaCBpbiB0dXJuIHdpbGwgbGVhZCB0byB0aGUgem9u
ZSBiZWluZyBhZGRlZCB0byB0aGUNCj4+IGFsbG9jYXRvci4NCj4gDQo+IFRoaXMgc29tZWhv
dyBmZWVscyBsaWtlIGEgaGFjayBmb3Igc29tZXRoaW5nIHRoYXQgc2hvdWxkIGJlIGhhbmRs
ZWQgaW4NCj4gdGhlIGNvcmUgaW5zdGVhZCA6Lw0KDQpPa2F5LCBJJ2xsIHJld29yayB0aGUg
cGF0Y2ggKGJldHRlciB3b3JkaW5nIG1pZ2h0IGJlOiByZXBsYWNlKSB0byBzd2l0Y2gNCmJ1
aWxkX3pvbmVyZWZzX25vZGUoKSB0byB1c2UgcG9wdWxhdGVkX3pvbmUoKSBpbnN0ZWFkIG9m
IG1hbmFnZWRfem9uZSgpLg0KDQoNCkp1ZXJnZW4NCg==
--------------lBWdgohUpDbOpCr4EznLRraE
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------lBWdgohUpDbOpCr4EznLRraE--

--------------Pgc0gcsWI2D0D5pFykv836Uc--

--------------OMFgksYuijuhI3hZ2iAJlos0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmJOpfAFAwAAAAAACgkQsN6d1ii/Ey+N
tAf+OKaLICMk6ZJi29vD8L8v6HtVrz+K0ZW3vob8jSe0Gl1bjadVddpD4A+zG1tLW2gQWaCnqLUP
kjS4x44UWX3qhV/piaXve2Qcd2iyy6WOvp/ZTfihXD5w6aStLo2sfPHTY5OtExk6TlflmaZzUEr9
ePBxQMyUd8ApPirAaybmOPrK+ler5ppLftCbH9VGcJuXCNdgIoeAuMDA7Gg3pM06AkhwE0jhljGL
50T7v0nY548SF9jKaDQ+Op0aQr36JYgKkvEAsSAE0+0A/KSbrFiQk5POUpUlHlbDkeqja234ekPl
tvyQ1SS//5iSGhQd1bd7sQ3YgmBU+k3WN0f7+xbheQ==
=xIhG
-----END PGP SIGNATURE-----

--------------OMFgksYuijuhI3hZ2iAJlos0--

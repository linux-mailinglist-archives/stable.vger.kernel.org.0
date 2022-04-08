Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DC4F8DA7
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 08:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiDHFwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 01:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiDHFwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 01:52:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBFD1A5D6F;
        Thu,  7 Apr 2022 22:50:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 92DD3215FF;
        Fri,  8 Apr 2022 05:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649397005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CCWJpKBkGkBtB6QKi+SIV4EeTDG+NjneafWSyWp8DjY=;
        b=ElU7Gmkq8YB7VD4P/ytTyDkRrTrye9prti/xWakjXrFE93JsPT3eNBNpPJXbO6dK+JkDm1
        vsk8mhNxecz7BdgaBFAzpMUhuJFrLeURrT1KhvSLatK2a9l6llBKTwAVvL4zPI7eLZ6RPQ
        K2BqESUxFiA0wopZ9XQvaVgcF6wV6UY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 58C6113A9C;
        Fri,  8 Apr 2022 05:50:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xew+Ew3NT2JdbwAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 08 Apr 2022 05:50:05 +0000
Message-ID: <fa36ede3-3f5c-e10c-107d-0e4fae4af098@suse.com>
Date:   Fri, 8 Apr 2022 07:50:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] mm, page_alloc: fix build_zonerefs_node()
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>
References: <20220407120637.9035-1-jgross@suse.com>
 <20220407154426.7076e19f5b80d927dd715de9@linux-foundation.org>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220407154426.7076e19f5b80d927dd715de9@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------sl2QoL0SE9T9mqPa0uesbJXC"
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
--------------sl2QoL0SE9T9mqPa0uesbJXC
Content-Type: multipart/mixed; boundary="------------nrdROtZnvzPMdkoaABz0zRfP";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>
Message-ID: <fa36ede3-3f5c-e10c-107d-0e4fae4af098@suse.com>
Subject: Re: [PATCH v2] mm, page_alloc: fix build_zonerefs_node()
References: <20220407120637.9035-1-jgross@suse.com>
 <20220407154426.7076e19f5b80d927dd715de9@linux-foundation.org>
In-Reply-To: <20220407154426.7076e19f5b80d927dd715de9@linux-foundation.org>

--------------nrdROtZnvzPMdkoaABz0zRfP
Content-Type: multipart/mixed; boundary="------------5RLqE0Putz0HASSlv97z00ZA"

--------------5RLqE0Putz0HASSlv97z00ZA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMDQuMjIgMDA6NDQsIEFuZHJldyBNb3J0b24gd3JvdGU6DQo+IE9uIFRodSwgIDcg
QXByIDIwMjIgMTQ6MDY6MzcgKzAyMDAgSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29t
PiB3cm90ZToNCj4gDQo+PiBTaW5jZSBjb21taXQgNmFhMzAzZGVmYjc0ICgibW0sIHZtc2Nh
bjogb25seSBhbGxvY2F0ZSBhbmQgcmVjbGFpbSBmcm9tDQo+PiB6b25lcyB3aXRoIHBhZ2Vz
IG1hbmFnZWQgYnkgdGhlIGJ1ZGR5IGFsbG9jYXRvciIpDQo+IA0KPiBTaXggeWVhcnMgYWdv
IQ0KPiANCj4+IG9ubHkgem9uZXMgd2l0aCBmcmVlDQo+PiBtZW1vcnkgYXJlIGluY2x1ZGVk
IGluIGEgYnVpbHQgem9uZWxpc3QuIFRoaXMgaXMgcHJvYmxlbWF0aWMgd2hlbiBlLmcuDQo+
PiBhbGwgbWVtb3J5IG9mIGEgem9uZSBoYXMgYmVlbiBiYWxsb29uZWQgb3V0IHdoZW4gem9u
ZWxpc3RzIGFyZSBiZWluZw0KPj4gcmVidWlsdC4NCj4+DQo+PiBUaGUgZGVjaXNpb24gd2hl
dGhlciB0byByZWJ1aWxkIHRoZSB6b25lbGlzdHMgd2hlbiBvbmxpbmluZyBuZXcgbWVtb3J5
DQo+PiBpcyBkb25lIGJhc2VkIG9uIHBvcHVsYXRlZF96b25lKCkgcmV0dXJuaW5nIDAgZm9y
IHRoZSB6b25lIHRoZSBtZW1vcnkNCj4+IHdpbGwgYmUgYWRkZWQgdG8uIFRoZSBuZXcgem9u
ZSBpcyBhZGRlZCB0byB0aGUgem9uZWxpc3RzIG9ubHksIGlmIGl0DQo+PiBoYXMgZnJlZSBt
ZW1vcnkgcGFnZXMgKG1hbmFnZWRfem9uZSgpIHJldHVybnMgYSBub24temVybyB2YWx1ZSkg
YWZ0ZXINCj4+IHRoZSBtZW1vcnkgaGFzIGJlZW4gb25saW5lZC4gVGhpcyBpbXBsaWVzLCB0
aGF0IG9ubGluaW5nIG1lbW9yeSB3aWxsDQo+PiBhbHdheXMgZnJlZSB0aGUgYWRkZWQgcGFn
ZXMgdG8gdGhlIGFsbG9jYXRvciBpbW1lZGlhdGVseSwgYnV0IHRoaXMgaXMNCj4+IG5vdCB0
cnVlIGluIGFsbCBjYXNlczogd2hlbiBlLmcuIHJ1bm5pbmcgYXMgYSBYZW4gZ3Vlc3QgdGhl
IG9ubGluZWQNCj4+IG5ldyBtZW1vcnkgd2lsbCBiZSBhZGRlZCBvbmx5IHRvIHRoZSBiYWxs
b29uZWQgbWVtb3J5IGxpc3QsIGl0IHdpbGwgYmUNCj4+IGZyZWVkIG9ubHkgd2hlbiB0aGUg
Z3Vlc3QgaXMgYmVpbmcgYmFsbG9vbmVkIHVwIGFmdGVyd2FyZHMuDQo+Pg0KPj4gQW5vdGhl
ciBwcm9ibGVtIHdpdGggdXNpbmcgbWFuYWdlZF96b25lKCkgZm9yIHRoZSBkZWNpc2lvbiB3
aGV0aGVyIGENCj4+IHpvbmUgaXMgYmVpbmcgYWRkZWQgdG8gdGhlIHpvbmVsaXN0cyBpcywg
dGhhdCBhIHpvbmUgd2l0aCBhbGwgbWVtb3J5DQo+PiB1c2VkIHdpbGwgaW4gZmFjdCBiZSBy
ZW1vdmVkIGZyb20gYWxsIHpvbmVsaXN0cyBpbiBjYXNlIHRoZSB6b25lbGlzdHMNCj4+IGhh
cHBlbiB0byBiZSByZWJ1aWx0Lg0KPj4NCj4+IFVzZSBwb3B1bGF0ZWRfem9uZSgpIHdoZW4g
YnVpbGRpbmcgYSB6b25lbGlzdCBhcyBpdCBoYXMgYmVlbiBkb25lDQo+PiBiZWZvcmUgdGhh
dCBjb21taXQuDQo+Pg0KPj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gDQo+IFNv
bWUgZGV0YWlscywgcGxlYXNlLiAgSXMgdGhpcyByZWFsbHkgc2VyaW91cyBlbm91Z2ggdG8g
d2FycmFudA0KPiBiYWNrcG9ydGluZz8gIElzIHNvbWUgbmV3IHdvcmtsb2FkL3VzYWdlIHBh
dHRlcm4gY2F1c2luZyBwZW9wbGUgdG8gaGl0DQo+IHRoaXM/DQoNClllcy4gVGhlcmUgd2Fz
IGEgcmVwb3J0IHRoYXQgUXViZXNPUyAoYmFzZWQgb24gWGVuKSBpcyBoaXR0aW5nIHRoaXMN
CnByb2JsZW0uIFhlbiBoYXMgc3dpdGNoZWQgdG8gdXNlIHRoZSB6b25lIGRldmljZSBmdW5j
dGlvbmFsaXR5IGluDQprZXJuZWwgNS45IGFuZCBRdWJlc09TIHdhbnRzIHRvIHVzZSBtZW1v
cnkgaG90cGx1Z2dpbmcgZm9yIGd1ZXN0cyBpbg0Kb3JkZXIgdG8gYmUgYWJsZSB0byBzdGFy
dCBhIGd1ZXN0IHdpdGggbWluaW1hbCBtZW1vcnkgYW5kIGV4cGFuZCBpdA0KYXMgbmVlZGVk
LiBUaGlzIHdhcyB0aGUgcmVwb3J0IGxlYWRpbmcgdG8gdGhlIHBhdGNoLg0KDQoNCkp1ZXJn
ZW4NCg0K
--------------5RLqE0Putz0HASSlv97z00ZA
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------5RLqE0Putz0HASSlv97z00ZA--

--------------nrdROtZnvzPMdkoaABz0zRfP--

--------------sl2QoL0SE9T9mqPa0uesbJXC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmJPzQwFAwAAAAAACgkQsN6d1ii/Ey+q
xwf+Nu5lwR5zq7N46XnDYJl+VsQfKsv7hOhxKwDvLg5gKUurgIIEMvrue6mUa240PbY69VmJYap+
8TjtG0Ate4TKSO+a/XeBPAXI6A2RFHoVczzCPRXnS0LAPF0t9gHEWWnD9mle73VNQZrGCwbrdn9e
1fii2ZPxyMGcEvJdZS+2Ef+bMMsqMlWo8MbSUdfEItKmr6pTdrKle9SJl/RO2o7OhP2LbO9hso+F
XViLpw/Ej+BDPLtHO0umxQv2c8be5A9f2/uk4WAqTBezTgBopyFywodAwCNQ5T4G+szybMfb1ZKe
fZ7eq6d8ml4alH/p80fqN0rC/8hHsJc4xLEOdAb7vg==
=wRjz
-----END PGP SIGNATURE-----

--------------sl2QoL0SE9T9mqPa0uesbJXC--

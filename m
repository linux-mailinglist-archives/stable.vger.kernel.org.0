Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434EF4F7F76
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 14:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbiDGMwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbiDGMvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:51:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E8B20833F;
        Thu,  7 Apr 2022 05:49:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5F51F210DF;
        Thu,  7 Apr 2022 12:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649335791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JRuyghqBSswsUg1+uaNCd7gZNZ3+HLGOdgUt2B+8tHk=;
        b=Cu0pSc2YSWAmZ64wj3ik7Q11oXy0oNKXvhbg38csHSX12KU+ew66rQtr817EaJXS8EifYR
        vxOMQzZSP+JcsP3MWAHIKwV7w/pTmfqwtNuykoH5Is+4fp9BkZJuboBwx2oZbrJC0KKize
        HyaQDI4VCkHEE2HMbV6oYTKzCNXYSbk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C4EB13485;
        Thu,  7 Apr 2022 12:49:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1q52Be/dTmJPHgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Apr 2022 12:49:51 +0000
Message-ID: <67bde881-434e-8aca-ac68-21aff4bdb231@suse.com>
Date:   Thu, 7 Apr 2022 14:49:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek Marczykowski-G?recki <marmarek@invisiblethingslab.com>,
        Mel Gorman <mgorman@suse.de>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
 <20220407115414.GA4148@techsingularity.net>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
In-Reply-To: <20220407115414.GA4148@techsingularity.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------CRFwnQwTs316DYKyrzvZhvNI"
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
--------------CRFwnQwTs316DYKyrzvZhvNI
Content-Type: multipart/mixed; boundary="------------0a3DHUPxD30uAbBuyhfGEwS6";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
 Marek Marczykowski-G?recki <marmarek@invisiblethingslab.com>,
 Mel Gorman <mgorman@suse.de>
Message-ID: <67bde881-434e-8aca-ac68-21aff4bdb231@suse.com>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
 <20220407115414.GA4148@techsingularity.net>
In-Reply-To: <20220407115414.GA4148@techsingularity.net>

--------------0a3DHUPxD30uAbBuyhfGEwS6
Content-Type: multipart/mixed; boundary="------------YPysLWDWql3vQilGpQWrCUm5"

--------------YPysLWDWql3vQilGpQWrCUm5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDQuMjIgMTQ6MzIsIE1lbCBHb3JtYW4gd3JvdGU6DQo+IE9uIFRodSwgQXByIDA3
LCAyMDIyIGF0IDAxOjE3OjE5UE0gKzAyMDAsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+PiBP
biAwNy4wNC4yMiAxMzowNywgTWljaGFsIEhvY2tvIHdyb3RlOg0KPj4+IE9uIFRodSAwNy0w
NC0yMiAxMjo0NTo0MSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+Pj4gT24gMDcuMDQuMjIg
MTI6MzQsIE1pY2hhbCBIb2NrbyB3cm90ZToNCj4+Pj4+IENjaW5nIE1lbA0KPj4+Pj4NCj4+
Pj4+IE9uIFRodSAwNy0wNC0yMiAxMTozMjoyMSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+
Pj4+PiBTaW5jZSBjb21taXQgOWQzYmUyMWJmOWMwICgibW0sIHBhZ2VfYWxsb2M6IHNpbXBs
aWZ5IHpvbmVsaXN0DQo+Pj4+Pj4gaW5pdGlhbGl6YXRpb24iKSBvbmx5IHpvbmVzIHdpdGgg
ZnJlZSBtZW1vcnkgYXJlIGluY2x1ZGVkIGluIGEgYnVpbHQNCj4+Pj4+PiB6b25lbGlzdC4g
VGhpcyBpcyBwcm9ibGVtYXRpYyB3aGVuIGUuZy4gYWxsIG1lbW9yeSBvZiBhIHpvbmUgaGFz
IGJlZW4NCj4+Pj4+PiBiYWxsb29uZWQgb3V0Lg0KPj4+Pj4NCj4+Pj4+IFdoYXQgaXMgdGhl
IGFjdHVhbCBwcm9ibGVtIHRoZXJlPw0KPj4+Pg0KPj4+PiBXaGVuIHJ1bm5pbmcgYXMgWGVu
IGd1ZXN0IG5ldyBob3RwbHVnZ2VkIG1lbW9yeSB3aWxsIG5vdCBiZSBvbmxpbmVkDQo+Pj4+
IGF1dG9tYXRpY2FsbHksIGJ1dCBvbmx5IG9uIHNwZWNpYWwgcmVxdWVzdC4gVGhpcyBpcyBk
b25lIGluIG9yZGVyIHRvDQo+Pj4+IHN1cHBvcnQgYWRkaW5nIGUuZy4gdGhlIHBvc3NpYmls
aXR5IHRvIHVzZSBhbm90aGVyIEdCIG9mIG1lbW9yeSwgd2hpbGUNCj4+Pj4gYWRkaW5nIG9u
bHkgYSBwYXJ0IG9mIHRoYXQgbWVtb3J5IGluaXRpYWxseS4NCj4+Pj4NCj4+Pj4gSW4gY2Fz
ZSBhZGRpbmcgdGhhdCBtZW1vcnkgaXMgcG9wdWxhdGluZyBhIG5ldyB6b25lLCB0aGUgcGFn
ZSBhbGxvY2F0b3INCj4+Pj4gd29uJ3QgYmUgYWJsZSB0byB1c2UgdGhpcyBtZW1vcnkgd2hl
biBpdCBpcyBvbmxpbmVkLCBhcyB0aGUgem9uZSB3YXNuJ3QNCj4+Pj4gYWRkZWQgdG8gdGhl
IHpvbmVsaXN0LCBkdWUgdG8gbWFuYWdlZF96b25lKCkgcmV0dXJuaW5nIDAuDQo+Pj4NCj4+
PiBIb3cgaXMgdGhhdCBtZW1vcnkgb25saW5lZD8gQmVjYXVzZSAicmVndWxhciIgb25saW5p
bmcgKG9ubGluZV9wYWdlcygpKQ0KPj4+IGRvZXMgcmVidWlsZCB6b25lbGlzdHMgaWYgdGhl
aXIgem9uZSBoYXNuJ3QgYmVlbiBwb3B1bGF0ZWQgYmVmb3JlLg0KPj4NCj4+IFRoZSBYZW4g
YmFsbG9vbiBkcml2ZXIgaGFzIGFuIG93biBjYWxsYmFjayBmb3Igb25saW5pbmcgcGFnZXMu
IFRoZSBwYWdlcw0KPj4gYXJlIGp1c3QgYWRkZWQgdG8gdGhlIGJhbGxvb25lZC1vdXQgcGFn
ZSBsaXN0IHdpdGhvdXQgaGFuZGluZyB0aGVtIHRvIHRoZQ0KPj4gYWxsb2NhdG9yLiBUaGlz
IGlzIGRvbmUgb25seSB3aGVuIHRoZSBndWVzdCBpcyBiYWxsb29uZWQgdXAuDQo+Pg0KPiAN
Cj4gSXMgdGhpcyBuZXcgYmVoYXZpb3VyPyBJIGFzayBiZWNhdXNlIGtlZXBpbmcgIW1hbmFn
ZWRfem9uZXMgb3V0IG9mIHRoZQ0KDQpGb3Igc29tZSB0aW1lIChzaW5jZSBrZXJuZWwgNS45
KSBYZW4gaXMgdXNpbmcgdGhlIHpvbmUgZGV2aWNlIGZ1bmN0aW9uYWxpdHkNCndpdGggbWVt
cmVtYXBfcGFnZXMoKSBhbmQgcGdtYXAtPnR5cGUgPSBNRU1PUllfREVWSUNFX0dFTkVSSUMu
DQoNCj4gem9uZWxpc3QgYW5kIHJlY2xhaW0gcGF0aHMgYW5kIHRoZSBiZWhhdmlvdXIgbWFr
ZXMgc2Vuc2UuIEVsc2V3aGVyZSB5b3UNCj4gc3RhdGUgInpvbmUgY2FuIGFsd2F5cyBoYXBw
ZW4gdG8gaGF2ZSBubyBmcmVlIG1lbW9yeSBsZWZ0IiBhbmQgdGhpcyBpcyB0cnVlDQo+IGJ1
dCBpdCdzIHVzdWFsbHkgYSB0cmFuc2llbnQgZXZlbnQuIFRoZSBkaWZmZXJlbmNlIGJldHdl
ZW4gYSBwb3B1bGF0ZWQNCg0KQW5kIGlmIHRoaXMgInRyYW5zaWVudCBldmVudCIgaXMganVz
dCBoYXBwZW5pbmcgd2hlbiB0aGUgem9uZWxpc3RzIGFyZQ0KYmVpbmcgcmVidWlsdCB0aGUg
em9uZSB3aWxsIGJlIG9mZiB0aGUgbGlzdHMgbWF5YmUgZm9yZXZlci4NCg0KPiB2cyBtYW5h
Z2VkIHpvbmUgaXMgdXN1YWxseSBwZXJtYW5lbnQgZXZlbnQgd2hlcmUgbm8gbWVtb3J5IHdp
bGwgZXZlciBiZQ0KPiBwbGFjZWQgb24gdGhlIGJ1ZGR5IGxpc3RzIGJlY2F1c2UgdGhlIG1l
bW9yeSB3YXMgcmVzZXJ2ZWQgZWFybHkgaW4gYm9vdA0KPiBvciBhIHNpbWlsYXIgcmVhc29u
LiBUaGUgcGF0Y2ggaXMgcHJvYmFibHkgaGFybWxlc3MgYnV0IGl0IGhhcyB0aGUNCj4gcG90
ZW50aWFsIHRvIHdhc3RlIENQVXMgYWxsb2NhdGluZyBvciByZWNsYWltaW5nIGZyb20gem9u
ZXMgdGhhdCB3aWxsDQo+IG5ldmVyIHN1Y2NlZWQuDQoNCkknZCByZWNvbW1lbmQgdG8gaGF2
ZSBhbiBleHBsaWNpdCBmbGFnIHBlci16b25lIGZvciB0aGlzIGNhc2UgaWYgeW91DQpyZWFs
bHkgY2FyZSBhYm91dCB0aGF0LiBUaGlzIHdvdWxkIGJlIG11Y2ggY2xlYW5lciB0aGFuIHRv
IGltcGx5IGZyb20NCm5vIGZyZWUgcGFnZSBiZWluZyBwcmVzZW50IGF0IGEgc3BlY2lmaWMg
cG9pbnQgaW4gdGltZSwgdGhhdCB0aGUgem9uZQ0Kd2lsbCBuZXZlciBiZSBzdWJqZWN0IHRv
IG1lbW9yeSBhbGxvY2F0aW9uLg0KDQoNCkp1ZXJnZW4NCg==
--------------YPysLWDWql3vQilGpQWrCUm5
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------YPysLWDWql3vQilGpQWrCUm5--

--------------0a3DHUPxD30uAbBuyhfGEwS6--

--------------CRFwnQwTs316DYKyrzvZhvNI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmJO3e4FAwAAAAAACgkQsN6d1ii/Ey+X
YAgAnYflQLETlejV5vQWm61d5tudx9M3lEU2RyVGrXKexR0dJyeREbRoCJXE76wlZ7xeV/RbiVmj
NppAkYsI+3Dve9D0emCXYdxKwnnTjrpRXIDdA8o8IyFwkqxAWSvA1NrQFlyJ/fMmJ6Db4NP2j+hC
VYFAWEZBaIXf8rufT75PWibg3wGhAHYuJQl/VuUaTlpazXf0RkjZkE+jD2FNtIlCogZUOxqefQGK
cIBBtM8DpQs0FKqPez4uNMC82EX1KfoOUyLR02B7UiYogPsj/2vg7M30JdxLFc0EsmLqolYqDrWb
wyJN7POWb6zJeiEKO7LJK6qjnRz/8TRYipLj9fp1tA==
=2FSz
-----END PGP SIGNATURE-----

--------------CRFwnQwTs316DYKyrzvZhvNI--

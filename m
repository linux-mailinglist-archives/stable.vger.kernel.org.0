Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C132C596BF6
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiHQJRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 05:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHQJRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 05:17:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E60F6B8CE;
        Wed, 17 Aug 2022 02:17:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E74C134BD6;
        Wed, 17 Aug 2022 09:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660727822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x0zzqcO39x1ZtAyVbggrm2KK0G3hoH83gUBEVO4Wejs=;
        b=a5V0qM0+iWc25Sjc1Y1rELMBPf+TwUcGnbMVK4PntU+XG11M7Lg1OndJF+fMnSCiJBwbUu
        6ZpA/pDnD9+Rr5KRdlANmSMCKGarS9dWU2izKhv1RHVY+N+6Gy0Gd0R5SxrPr30bdFO0a3
        rv17qEmgn+wDEpCJJxUnNlYspYSM1o8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8274B13A8E;
        Wed, 17 Aug 2022 09:17:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id diq0HQ6y/GLTaQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 17 Aug 2022 09:17:02 +0000
Message-ID: <e5431d53-fa43-d6e6-9af3-4313c466e991@suse.com>
Date:   Wed, 17 Aug 2022 11:17:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, brchuckz@netscape.net,
        jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
References: <20220715142549.25223-1-jgross@suse.com>
 <20220715142549.25223-4-jgross@suse.com> <YtbKf51S4lTaziKm@zn.tnic>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 3/3] x86: decouple pat and mtrr handling
In-Reply-To: <YtbKf51S4lTaziKm@zn.tnic>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Z7OE21cz2H45kr0rcs0pbiE6"
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
--------------Z7OE21cz2H45kr0rcs0pbiE6
Content-Type: multipart/mixed; boundary="------------pJOUs7dfyavWU5Lwp2GyJCvK";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Borislav Petkov <bp@alien8.de>
Cc: xen-devel@lists.xenproject.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, brchuckz@netscape.net, jbeulich@suse.com,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, stable@vger.kernel.org
Message-ID: <e5431d53-fa43-d6e6-9af3-4313c466e991@suse.com>
Subject: Re: [PATCH 3/3] x86: decouple pat and mtrr handling
References: <20220715142549.25223-1-jgross@suse.com>
 <20220715142549.25223-4-jgross@suse.com> <YtbKf51S4lTaziKm@zn.tnic>
In-Reply-To: <YtbKf51S4lTaziKm@zn.tnic>

--------------pJOUs7dfyavWU5Lwp2GyJCvK
Content-Type: multipart/mixed; boundary="------------ZrVFAX000v0VzwJtOArH1frP"

--------------ZrVFAX000v0VzwJtOArH1frP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTkuMDcuMjIgMTc6MTUsIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4gT24gRnJpLCBK
dWwgMTUsIDIwMjIgYXQgMDQ6MjU6NDlQTSArMDIwMCwgSnVlcmdlbiBHcm9zcyB3cm90ZToN
Cj4+IFRvZGF5IFBBVCBpcyB1c2FibGUgb25seSB3aXRoIE1UUlIgYmVpbmcgYWN0aXZlLCB3
aXRoIHNvbWUgbmFzdHkgdHdlYWtzDQo+PiB0byBtYWtlIFBBVCB1c2FibGUgd2hlbiBydW5u
aW5nIGFzIFhlbiBQViBndWVzdCwgd2hpY2ggZG9lc24ndCBzdXBwb3J0DQo+PiBNVFJSLg0K
Pj4NCj4+IFRoZSByZWFzb24gZm9yIHRoaXMgY291cGxpbmcgaXMsIHRoYXQgYm90aCwgUEFU
IE1TUiBjaGFuZ2VzIGFuZCBNVFJSDQo+PiBjaGFuZ2VzLCByZXF1aXJlIGEgc2ltaWxhciBz
ZXF1ZW5jZSBhbmQgc28gZnVsbCBQQVQgc3VwcG9ydCB3YXMgYWRkZWQNCj4+IHVzaW5nIHRo
ZSBhbHJlYWR5IGF2YWlsYWJsZSBNVFJSIGhhbmRsaW5nLg0KPj4NCj4+IFhlbiBQViBQQVQg
aGFuZGxpbmcgY2FuIHdvcmsgd2l0aG91dCBNVFJSLCBhcyBpdCBqdXN0IG5lZWRzIHRvIGNv
bnN1bWUNCj4+IHRoZSBQQVQgTVNSIHNldHRpbmcgZG9uZSBieSB0aGUgaHlwZXJ2aXNvciB3
aXRob3V0IHRoZSBhYmlsaXR5IGFuZCBuZWVkDQo+PiB0byBjaGFuZ2UgaXQuIFRoaXMgaW4g
dHVybiBoYXMgcmVzdWx0ZWQgaW4gYSBjb252b2x1dGVkIGluaXRpYWxpemF0aW9uDQo+PiBz
ZXF1ZW5jZSBhbmQgd3JvbmcgZGVjaXNpb25zIHJlZ2FyZGluZyBjYWNoZSBtb2RlIGF2YWls
YWJpbGl0eSBkdWUgdG8NCj4+IG1pc2d1aWRpbmcgUEFUIGF2YWlsYWJpbGl0eSBmbGFncy4N
Cj4+DQo+PiBGaXggYWxsIG9mIHRoYXQgYnkgYWxsb3dpbmcgdG8gdXNlIFBBVCB3aXRob3V0
IE1UUlIgYW5kIGJ5IGFkZGluZyBhbg0KPj4gZW52aXJvbm1lbnQgZGVwZW5kZW50IFBBVCBp
bml0IGZ1bmN0aW9uLg0KPiANCj4gQWhhLCB0aGVyZSdzIHRoZSBleHBsYW5hdGlvbiBJIHdh
cyBsb29raW5nIGZvci4NCj4gDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2Nw
dS9jb21tb24uYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMNCj4+IGluZGV4IDBh
MWJkMTRmNzk2Ni4uM2VkZmI3NzlkYWI1IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva2Vy
bmVsL2NwdS9jb21tb24uYw0KPj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24u
Yw0KPj4gQEAgLTI0MDgsOCArMjQwOCw4IEBAIHZvaWQgX19pbml0IGNhY2hlX2JwX2luaXQo
dm9pZCkNCj4+ICAgew0KPj4gICAJaWYgKElTX0VOQUJMRUQoQ09ORklHX01UUlIpKQ0KPj4g
ICAJCW10cnJfYnBfaW5pdCgpOw0KPj4gLQllbHNlDQo+PiAtCQlwYXRfZGlzYWJsZSgiUEFU
IHN1cHBvcnQgZGlzYWJsZWQgYmVjYXVzZSBDT05GSUdfTVRSUiBpcyBkaXNhYmxlZCBpbiB0
aGUga2VybmVsLiIpOw0KPj4gKw0KPj4gKwlwYXRfY3B1X2luaXQoKTsNCj4+ICAgfQ0KPj4g
ICANCj4+ICAgdm9pZCBjYWNoZV9hcF9pbml0KHZvaWQpDQo+PiBAQCAtMjQxNyw3ICsyNDE3
LDggQEAgdm9pZCBjYWNoZV9hcF9pbml0KHZvaWQpDQo+PiAgIAlpZiAoY2FjaGVfYXBzX2Rl
bGF5ZWRfaW5pdCkNCj4+ICAgCQlyZXR1cm47DQo+PiAgIA0KPj4gLQltdHJyX2FwX2luaXQo
KTsNCj4+ICsJaWYgKCFtdHJyX2FwX2luaXQoKSkNCj4+ICsJCXBhdF9hcF9pbml0X25vbXRy
cigpOw0KPj4gICB9DQo+IA0KPiBTbyBJJ20gcmVhZGluZyB0aGlzIGFzOiBpZiBpdCBjb3Vs
ZG4ndCBpbml0IEFQJ3MgTVRSUnMsIGluaXQgaXRzIFBBVC4NCj4gDQo+IEJ1dCBjdXJyZW50
bHksIHRoZSBjb2RlIHNldHMgdGhlIE1UUlJzIGZvciB0aGUgZGVsYXllZCBjYXNlIG9yIHdo
ZW4gdGhlDQo+IENQVSBpcyBub3Qgb25saW5lIGJ5IGRvaW5nIC0+c2V0X2FsbCBhbmQgaW4g
dGhlcmUgaXQgc2V0cyBmaXJzdCBNVFJScw0KPiBhbmQgdGhlbiBQQVQuDQo+IA0KPiBJIHRo
aW5rIHRoZSBjb2RlIGFib3ZlIHNob3VsZCBzaW1wbHkgdHJ5IHRoZSB0d28gdGhpbmdzLCBv
bmUgYWZ0ZXIgdGhlDQo+IG90aGVyLCBpbmRlcGVuZGVudGx5IGZyb20gb25lIGFub3RoZXIu
DQo+IA0KPiBBbmQgSSBzZWUgeW91J3ZlIGFkZGVkIGFub3RoZXIgc3RvbXAgbWFjaGluZSBj
YWxsIGZvciBQQVQgb25seS4NCj4gDQo+IE5vdywgd2hhdCBJIHRoaW5rIHRoZSBkZXNpZ24g
b2YgYWxsIHRoaXMgc2hvdWxkIGJlLCBpczoNCj4gDQo+IHlvdSBoYXZlIGEgYnVuY2ggb2Yg
dGhpbmdzIHlvdSBuZWVkIHRvIGRvIGF0IGVhY2ggcG9pbnQ6DQo+IA0KPiAqIGNhY2hlX2Fw
X2luaXQNCj4gDQo+ICogY2FjaGVfYXBzX2luaXQNCj4gDQo+ICogLi4uDQo+IA0KPiBOb3cs
IGluIGVhY2ggdGhvc2UsIHlvdSBsb29rIGF0IHdoZXRoZXIgUEFUIG9yIE1UUlIgaXMgc3Vw
cG9ydGVkIGFuZCB5b3UNCj4gZG8gb25seSB0aG9zZSB3aGljaCBhcmUgc3VwcG9ydGVkLg0K
PiANCj4gQWxzbywgdGhlIHJlbmRlenZvdXMgaGFuZGxlciBzaG91bGQgZG86DQo+IA0KPiAJ
aWYgTVRSUjoNCj4gCQlkbyBNVFJSIHNwZWNpZmljIHN0dWZmDQo+IA0KPiAJaWYgUEFUOg0K
PiAJCWRvIFBBVCBzcGVjaWZpYyBzdHVmZg0KPiANCj4gVGhpcyB3YXkgeW91IGhhdmUgY2xl
YW4gZGVmaW5pdGlvbnMgb2Ygd2hhdCBuZWVkcyB0byBoYXBwZW4gd2hlbiBhbmQgeW91DQo+
IGFsc28gZG8gKm9ubHkqIHRoZSB0aGluZ3MgdGhhdCB0aGUgcGxhdGZvcm0gc3VwcG9ydHMs
IGJ5IGtlZXBpbmcgdGhlDQo+IHByb3BlciBvcmRlciBvZiBvcGVyYXRpb25zIC0gSSBiZWxp
ZXZlIE1UUlJzIGZpcnN0IGFuZCB0aGVuIFBBVC4NCj4gDQo+IFRoaXMgd2F5IHdlJ2xsIGdl
dCByaWQgb2YgdGhhdCBjcmF6eSBtYXplIG9mIHdobyBjYWxscyB3aGF0IGFuZCB3aGVuLg0K
PiANCj4gQnV0IGZpcnN0IHdlIG5lZWQgdG8gZGVmaW5lIHRob3NlIHBvaW50cyB3aGVyZSBz
dHVmZiBuZWVkcyB0byBoYXBwZW4gYW5kDQo+IHRoZW4gZm9yIGVhY2ggcG9pbnQgZGVmaW5l
IHdoYXQgc3R1ZmYgbmVlZHMgdG8gaGFwcGVuLg0KPiANCj4gSG93IGRvZXMgdGhhdCBzb3Vu
ZD8NCg0KVGhpcyBhc2tzIGZvciBzb21lIG1vcmUgY2xlYW51cCBpbiB0aGUgTVRSUiBjb2Rl
Og0KDQptdHJyX2lmLT5zZXRfYWxsKCkgaXMgdGhlIHJlbGV2YW50IGNhbGxiYWNrLCBhbmQg
aXQgd2lsbCBvbmx5IGV2ZXIgYmUgY2FsbGVkDQpmb3IgdGhlIGdlbmVyaWMgY2FzZSAodXNl
X2ludGVsKCkgPT0gdHJ1ZSksIHNvIEkgdGhpbmsgd2Ugd2FudCB0bzoNCg0KLSByZW1vdmUg
dGhlIGN5cml4IHNwZWNpZmljIHNldF9hbGwoKSBmdW5jdGlvbg0KLSBzcGxpdCB0aGUgc2V0
X2FsbCgpIGNhbGxiYWNrIGNhc2UgZnJvbSBtdHJyX3JlbmRlenZvdXNfaGFuZGxlcigpIGlu
dG8gYQ0KICAgZGVkaWNhdGVkIHJlbmRlenZvdXMgaGFuZGxlcg0KLSByZW1vdmUgdGhlIHNl
dF9hbGwoKSBtZW1iZXIgZnJvbSBzdHJ1Y3QgbXRycl9vcHMgYW5kIGRpcmVjdGx5IGNhbGwN
CiAgIGdlbmVyaWNfc2V0X2FsbCgpIGZyb20gdGhlIG5ldyByZW5kZXp2b3VzIGhhbmRsZXIN
Ci0gb3B0aW9uYWw6IHJlbmFtZSB1c2VfaW50ZWwoKSB0byB1c2VfZ2VuZXJpYygpLCBvciBl
dmVuIGludHJvZHVjZSBqdXN0DQogICBhIHN0YXRpYyBib29sIGZvciB0aGF0IHB1cnBvc2UN
Cg0KVGhlbiB0aGUgbmV3IHJlbmRlenZvdXMgaGFuZGxlciBjYW4gYmUgbW9kaWZpZWQgYXMg
eW91IHN1Z2dlc3RlZC4NCg0KQXJlIHlvdSBva2F5IHdpdGggdGhhdCByb3V0ZT8NCg0KDQpK
dWVyZ2VuDQo=
--------------ZrVFAX000v0VzwJtOArH1frP
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------ZrVFAX000v0VzwJtOArH1frP--

--------------pJOUs7dfyavWU5Lwp2GyJCvK--

--------------Z7OE21cz2H45kr0rcs0pbiE6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmL8sg4FAwAAAAAACgkQsN6d1ii/Ey9u
5Af/UId+yeYmWBhxv+5XBJJI4+6KyTStKpmbrtzmIJQKj/OS0Swt9/ieNtDZaDw0wSnxPQeeQ5t+
eo2He5R98jVj760WTIWHDcWUwgYAU9WLN+JcsfZn21zxJKT6uvmOLRbU7WIw2CrEiOLmoamF+jzu
47sUgh7sw1cbXzS9WxeOOfAacWfsIliLpEFB53no/UK6Wr2NdI0SdyzwncgpQ5YLBAv38GhXQ4Gs
0fmHUTqrgG/0Fy+e0zVdci/DlQG+enstdIPr90a6W/5VqqiYZapLaAyJ9iKwxNaKhIEKU81O8mMF
aWWvmuaJvEuz1lr/go3zwf4OEHgyWLwZbA+YXOLz1A==
=OLfb
-----END PGP SIGNATURE-----

--------------Z7OE21cz2H45kr0rcs0pbiE6--

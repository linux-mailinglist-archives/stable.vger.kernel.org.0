Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684DB5337F2
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiEYIEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiEYIEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:04:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED497819B8;
        Wed, 25 May 2022 01:04:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D242821A2C;
        Wed, 25 May 2022 08:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653465874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u54F3tBmZy4oEFFTEii/zsvHbSaqW5NzYzMHIue11NU=;
        b=qr6HgqRj4PEUo3/fXiBQRoD33u8fWnrhW12UNFY0flwr/f0PC+eeIwANzVMPLYDLxw4M6q
        CkU02Yg+tyBQxTDJvYfOQl1nFeR4HAW8Zd2zHYWB0JCB8Av5oZg0twLhSs6hru2kDPKZxI
        6sYDAUrljLpfA0C8y4T4zmOpbZ5cXEA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A0E913ADF;
        Wed, 25 May 2022 08:04:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ecAVARLjjWLhKAAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 25 May 2022 08:04:34 +0000
Message-ID: <1cb5b845-a326-ce60-3a08-c2e13fe6d4ad@suse.com>
Date:   Wed, 25 May 2022 10:04:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Chuck Zmudzinski <brchuckz@netscape.net>,
        Jan Beulich <jbeulich@suse.com>, regressions@lists.linux.dev,
        stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
References: <20220503132207.17234-1-jgross@suse.com>
 <20220503132207.17234-3-jgross@suse.com>
 <1d86d8ff-6878-5488-e8c4-cbe8a5e8f624@suse.com>
 <0dcb05d0-108f-6252-e768-f75b393a7f5c@suse.com>
 <77255e5b-12bf-5390-6910-dafbaff18e96@netscape.net>
 <a2e95587-418b-879f-2468-8699a6df4a6a@suse.com>
 <8b1ebea5-7820-69c4-2e2b-9866d55bc180@netscape.net>
 <c5fa3c3f-e602-ed68-d670-d59b93c012a0@netscape.net>
 <3bff3562-bb1e-04e6-6eca-8d9bc355f2eb@suse.com>
 <3ca084a9-768e-a6f5-ace4-cd347978dec7@netscape.net>
 <9af0181a-e143-4474-acda-adbe72fc6227@suse.com>
 <b2585c19-d38b-9640-64ab-d0c9be24be34@netscape.net>
 <dae4cc45-a1cd-e33f-25ef-c536df9b49e6@leemhuis.info>
 <3fc70595-3dcc-4901-0f3f-193f043b753f@netscape.net>
 <eab9fdb0-11ef-4556-bdd7-f021cc5f10b7@leemhuis.info>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 2/2] x86/pat: add functions to query specific cache mode
 availability
In-Reply-To: <eab9fdb0-11ef-4556-bdd7-f021cc5f10b7@leemhuis.info>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BfyGk3XKVACj6W41lAYZo2BD"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BfyGk3XKVACj6W41lAYZo2BD
Content-Type: multipart/mixed; boundary="------------53G0UGMnr335AXWugItqKkAF";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Thorsten Leemhuis <regressions@leemhuis.info>,
 Chuck Zmudzinski <brchuckz@netscape.net>, Jan Beulich <jbeulich@suse.com>,
 regressions@lists.linux.dev, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
 xen-devel@lists.xenproject.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org
Message-ID: <1cb5b845-a326-ce60-3a08-c2e13fe6d4ad@suse.com>
Subject: Re: [PATCH 2/2] x86/pat: add functions to query specific cache mode
 availability
References: <20220503132207.17234-1-jgross@suse.com>
 <20220503132207.17234-3-jgross@suse.com>
 <1d86d8ff-6878-5488-e8c4-cbe8a5e8f624@suse.com>
 <0dcb05d0-108f-6252-e768-f75b393a7f5c@suse.com>
 <77255e5b-12bf-5390-6910-dafbaff18e96@netscape.net>
 <a2e95587-418b-879f-2468-8699a6df4a6a@suse.com>
 <8b1ebea5-7820-69c4-2e2b-9866d55bc180@netscape.net>
 <c5fa3c3f-e602-ed68-d670-d59b93c012a0@netscape.net>
 <3bff3562-bb1e-04e6-6eca-8d9bc355f2eb@suse.com>
 <3ca084a9-768e-a6f5-ace4-cd347978dec7@netscape.net>
 <9af0181a-e143-4474-acda-adbe72fc6227@suse.com>
 <b2585c19-d38b-9640-64ab-d0c9be24be34@netscape.net>
 <dae4cc45-a1cd-e33f-25ef-c536df9b49e6@leemhuis.info>
 <3fc70595-3dcc-4901-0f3f-193f043b753f@netscape.net>
 <eab9fdb0-11ef-4556-bdd7-f021cc5f10b7@leemhuis.info>
In-Reply-To: <eab9fdb0-11ef-4556-bdd7-f021cc5f10b7@leemhuis.info>

--------------53G0UGMnr335AXWugItqKkAF
Content-Type: multipart/mixed; boundary="------------1JYoJE0gc0gGkSGQBbWTf8g3"

--------------1JYoJE0gc0gGkSGQBbWTf8g3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDUuMjIgMDk6NDUsIFRob3JzdGVuIExlZW1odWlzIHdyb3RlOg0KPiANCj4gDQo+
IE9uIDI0LjA1LjIyIDIwOjMyLCBDaHVjayBabXVkemluc2tpIHdyb3RlOg0KPj4gT24gNS8y
MS8yMiA2OjQ3IEFNLCBUaG9yc3RlbiBMZWVtaHVpcyB3cm90ZToNCj4+PiBPbiAyMC4wNS4y
MiAxNjo0OCwgQ2h1Y2sgWm11ZHppbnNraSB3cm90ZToNCj4+Pj4gT24gNS8yMC8yMDIyIDEw
OjA2IEFNLCBKYW4gQmV1bGljaCB3cm90ZToNCj4+Pj4+IE9uIDIwLjA1LjIwMjIgMTU6MzMs
IENodWNrIFptdWR6aW5za2kgd3JvdGU6DQo+Pj4+Pj4gT24gNS8yMC8yMDIyIDU6NDEgQU0s
IEphbiBCZXVsaWNoIHdyb3RlOg0KPj4+Pj4+PiBPbiAyMC4wNS4yMDIyIDEwOjMwLCBDaHVj
ayBabXVkemluc2tpIHdyb3RlOg0KPj4+Pj4+Pj4gT24gNS8yMC8yMDIyIDI6NTkgQU0sIENo
dWNrIFptdWR6aW5za2kgd3JvdGU6DQo+Pj4+Pj4+Pj4gT24gNS8yMC8yMDIyIDI6MDUgQU0s
IEphbiBCZXVsaWNoIHdyb3RlOg0KPj4+Pj4+Pj4+PiBPbiAyMC4wNS4yMDIyIDA2OjQzLCBD
aHVjayBabXVkemluc2tpIHdyb3RlOg0KPj4+Pj4+Pj4+Pj4gT24gNS80LzIyIDU6MTQgQU0s
IEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+Pj4+Pj4+Pj4+Pj4gT24gMDQuMDUuMjIgMTA6MzEs
IEphbiBCZXVsaWNoIHdyb3RlOg0KPj4+Pj4+Pj4+Pj4+PiBPbiAwMy4wNS4yMDIyIDE1OjIy
LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4+Pj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+Pj4+PiAu
Li4gdGhlc2UgdXNlcyB0aGVyZSBhcmUgc2V2ZXJhbCBtb3JlLiBZb3Ugc2F5IG5vdGhpbmcg
b24gd2h5DQo+Pj4+Pj4+Pj4+Pj4+IHRob3NlIHdhbnQNCj4+Pj4+Pj4+Pj4+Pj4gbGVhdmlu
ZyB1bmFsdGVyZWQuIFdoZW4gcHJlcGFyaW5nIG15IGVhcmxpZXIgcGF0Y2ggSSBkaWQNCj4+
Pj4+Pj4+Pj4+Pj4gaW5zcGVjdCB0aGVtDQo+Pj4+Pj4+Pj4+Pj4+IGFuZCBjYW1lIHRvIHRo
ZSBjb25jbHVzaW9uIHRoYXQgdGhlc2UgYWxsIHdvdWxkIGFsc28gYmV0dGVyDQo+Pj4+Pj4+
Pj4+Pj4+IG9ic2VydmUgdGhlDQo+Pj4+Pj4+Pj4+Pj4+IGFkanVzdGVkIGJlaGF2aW9yIChv
ciBlbHNlIEkgY291bGRuJ3QgaGF2ZSBsZWZ0IHBhdF9lbmFibGVkKCkNCj4+Pj4+Pj4+Pj4+
Pj4gYXMgdGhlDQo+Pj4+Pj4+Pj4+Pj4+IG9ubHkgcHJlZGljYXRlKS4gSW4gZmFjdCwgYXMg
c2FpZCBpbiB0aGUgZGVzY3JpcHRpb24gb2YgbXkNCj4+Pj4+Pj4+Pj4+Pj4gZWFybGllcg0K
Pj4+Pj4+Pj4+Pj4+PiBwYXRjaCwgaW4NCj4+Pj4+Pj4+Pj4+Pj4gbXkgZGVidWdnaW5nIEkg
ZGlkIGZpbmQgdGhlIHVzZSBpbiBpOTE1X2dlbV9vYmplY3RfcGluX21hcCgpDQo+Pj4+Pj4+
Pj4+Pj4+IHRvIGJlDQo+Pj4+Pj4+Pj4+Pj4+IHRoZQ0KPj4+Pj4+Pj4+Pj4+PiBwcm9ibGVt
YXRpYyBvbmUsIHdoaWNoIHlvdSBsZWF2ZSBhbG9uZS4NCj4+Pj4+Pj4+Pj4+PiBPaCwgSSBt
aXNzZWQgdGhhdCBvbmUsIHNvcnJ5Lg0KPj4+Pj4+Pj4+Pj4gVGhhdCBpcyB3aHkgeW91ciBw
YXRjaCB3b3VsZCBub3QgZml4IG15IEhhc3dlbGwgdW5sZXNzDQo+Pj4+Pj4+Pj4+PiBpdCBh
bHNvIHRvdWNoZXMgaTkxNV9nZW1fb2JqZWN0X3Bpbl9tYXAoKSBpbg0KPj4+Pj4+Pj4+Pj4g
ZHJpdmVycy9ncHUvZHJtL2k5MTUvZ2VtL2k5MTVfZ2VtX3BhZ2VzLmMNCj4+Pj4+Pj4+Pj4+
DQo+Pj4+Pj4+Pj4+Pj4gSSB3YW50ZWQgdG8gYmUgcmF0aGVyIGRlZmVuc2l2ZSBpbiBteSBj
aGFuZ2VzLCBidXQgSSBhZ3JlZSBhdA0KPj4+Pj4+Pj4+Pj4+IGxlYXN0DQo+Pj4+Pj4+Pj4+
Pj4gdGhlDQo+Pj4+Pj4+Pj4+Pj4gY2FzZSBpbiBhcmNoX3BoeXNfd2NfYWRkKCkgbWlnaHQg
d2FudCB0byBiZSBjaGFuZ2VkLCB0b28uDQo+Pj4+Pj4+Pj4+PiBJIHRoaW5rIHlvdXIgYXBw
cm9hY2ggbmVlZHMgdG8gYmUgbW9yZSBhZ2dyZXNzaXZlIHNvIGl0IHdpbGwgZml4DQo+Pj4+
Pj4+Pj4+PiBhbGwgdGhlIGtub3duIGZhbHNlIG5lZ2F0aXZlcyBpbnRyb2R1Y2VkIGJ5IGJk
ZDhiNmM5ODIzOQ0KPj4+Pj4+Pj4+Pj4gc3VjaCBhcyB0aGUgb25lIGluIGk5MTVfZ2VtX29i
amVjdF9waW5fbWFwKCkuDQo+Pj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+Pj4gSSBsb29rZWQgYXQg
SmFuJ3MgYXBwcm9hY2ggYW5kIEkgdGhpbmsgaXQgd291bGQgZml4IHRoZSBpc3N1ZQ0KPj4+
Pj4+Pj4+Pj4gd2l0aCBteSBIYXN3ZWxsIGFzIGxvbmcgYXMgSSBkb24ndCB1c2UgdGhlIG5v
cGF0IG9wdGlvbi4gSQ0KPj4+Pj4+Pj4+Pj4gcmVhbGx5IGRvbid0IGhhdmUgYSBzdHJvbmcg
b3BpbmlvbiBvbiB0aGF0IHF1ZXN0aW9uLCBidXQgSQ0KPj4+Pj4+Pj4+Pj4gdGhpbmsgdGhl
IG5vcGF0IG9wdGlvbiBhcyBhIExpbnV4IGtlcm5lbCBvcHRpb24sIGFzIG9wcG9zZWQNCj4+
Pj4+Pj4+Pj4+IHRvIGEgaHlwZXJ2aXNvciBvcHRpb24sIHNob3VsZCBvbmx5IGFmZmVjdCB0
aGUga2VybmVsLCBhbmQNCj4+Pj4+Pj4+Pj4+IGlmIHRoZSBoeXBlcnZpc29yIHByb3ZpZGVz
IHRoZSBwYXQgZmVhdHVyZSwgdGhlbiB0aGUga2VybmVsDQo+Pj4+Pj4+Pj4+PiBzaG91bGQg
bm90IG92ZXJyaWRlIHRoYXQsDQo+Pj4+Pj4+Pj4+IEhtbSwgd2h5IHdvdWxkIHRoZSBrZXJu
ZWwgbm90IGJlIGFsbG93ZWQgdG8gb3ZlcnJpZGUgdGhhdD8gU3VjaA0KPj4+Pj4+Pj4+PiBh
biBvdmVycmlkZSB3b3VsZCBhZmZlY3Qgb25seSB0aGUgc2luZ2xlIGRvbWFpbiB3aGVyZSB0
aGUNCj4+Pj4+Pj4+Pj4ga2VybmVsIHJ1bnM7IG90aGVyIGRvbWFpbnMgY291bGQgdGFrZSB0
aGVpciBvd24gZGVjaXNpb25zLg0KPj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+PiBBbHNvLCBmb3Ig
dGhlIHNha2Ugb2YgY29tcGxldGVuZXNzOiAibm9wYXQiIHVzZWQgd2hlbiBydW5uaW5nIG9u
DQo+Pj4+Pj4+Pj4+IGJhcmUgbWV0YWwgaGFzIHRoZSBzYW1lIGJhZCBlZmZlY3Qgb24gc3lz
dGVtIGJvb3QsIHNvIHRoZXJlDQo+Pj4+Pj4+Pj4+IHByZXR0eSBjbGVhcmx5IGlzIGFuIGVy
cm9yIGNsZWFudXAgaXNzdWUgaW4gdGhlIGk5MTUgZHJpdmVyLiBCdXQNCj4+Pj4+Pj4+Pj4g
dGhhdCdzIG9ydGhvZ29uYWwsIGFuZCBJIGV4cGVjdCB0aGUgbWFpbnRhaW5lcnMgbWF5IG5v
dCBldmVuIGNhcmUNCj4+Pj4+Pj4+Pj4gKGJ1dCB0ZWxsIHVzICJkb24ndCBkbyB0aGF0IHRo
ZW4iKS4NCj4+Pj4+Pj4+IEFjdHVhbGx5IEkganVzdCBkaWQgYSB0ZXN0IHdpdGggdGhlIGxh
c3Qgb2ZmaWNpYWwgRGViaWFuIGtlcm5lbA0KPj4+Pj4+Pj4gYnVpbGQgb2YgTGludXggNS4x
NiwgdGhhdCBpcywgYSBrZXJuZWwgYmVmb3JlIGJkZDhiNmM5ODIzOSB3YXMNCj4+Pj4+Pj4+
IGFwcGxpZWQuIEluIGZhY3QsIHRoZSBub3BhdCBvcHRpb24gZG9lcyAqbm90KiBicmVhayB0
aGUgaTkxNSBkcml2ZXINCj4+Pj4+Pj4+IGluIDUuMTYuIFRoYXQgaXMsIHdpdGggdGhlIG5v
cGF0IG9wdGlvbiwgdGhlIGk5MTUgZHJpdmVyIGxvYWRzDQo+Pj4+Pj4+PiBub3JtYWxseSBv
biBib3RoIHRoZSBiYXJlIG1ldGFsIGFuZCBvbiB0aGUgWGVuIGh5cGVydmlzb3IuDQo+Pj4+
Pj4+PiBUaGF0IG1lYW5zIHlvdXIgcHJlc3VtcHRpb24gKGFuZCB0aGUgcHJlc3VtcHRpb24g
b2YNCj4+Pj4+Pj4+IHRoZSBhdXRob3Igb2YgYmRkOGI2Yzk4MjM5KSB0aGF0IHRoZSAibm9w
YXQiIG9wdGlvbiB3YXMNCj4+Pj4+Pj4+IGJlaW5nIG9ic2VydmVkIGJ5IHRoZSBpOTE1IGRy
aXZlciBpcyBpbmNvcnJlY3QuIFNldHRpbmcgIm5vcGF0Ig0KPj4+Pj4+Pj4gaGFkIG5vIGVm
ZmVjdCBvbiBteSBzeXN0ZW0gd2l0aCBMaW51eCA1LjE2LiBTbyBhZnRlciBkb2luZyB0aGVz
ZQ0KPj4+Pj4+Pj4gdGVzdHMsIEkgYW0gYWdhaW5zdCB0aGUgYWdncmVzc2l2ZSBhcHByb2Fj
aCBvZiBicmVha2luZyB0aGUgaTkxNQ0KPj4+Pj4+Pj4gZHJpdmVyIHdpdGggdGhlICJub3Bh
dCIgb3B0aW9uIGJlY2F1c2UgcHJpb3IgdG8gYmRkOGI2Yzk4MjM5LA0KPj4+Pj4+Pj4gbm9w
YXQgZGlkIG5vdCBicmVhayB0aGUgaTkxNSBkcml2ZXIuIFdoeSBicmVhayBpdCBub3c/DQo+
Pj4+Pj4+IEJlY2F1c2UgdGhhdCdzLCBpbiBteSB1bmRlcnN0YW5kaW5nLCBpcyB0aGUgcHVy
cG9zZSBvZiAibm9wYXQiDQo+Pj4+Pj4+IChub3QgYnJlYWtpbmcgdGhlIGRyaXZlciBvZiBj
b3Vyc2UgLSB0aGF0J3MgYSBkcml2ZXIgYnVnIC0sIGJ1dA0KPj4+Pj4+PiBoYXZpbmcgYW4g
ZWZmZWN0IG9uIHRoZSBkcml2ZXIpLg0KPj4+Pj4+IEkgd291bGRuJ3QgY2FsbCBpdCBhIGRy
aXZlciBidWcsIGJ1dCBhbiBpbmNvcnJlY3QgY29uZmlndXJhdGlvbiBvZiB0aGUNCj4+Pj4+
PiBrZXJuZWwgYnkgdGhlIHVzZXIuwqAgSSBwcmVzdW1lIFg4Nl9GRUFUVVJFX1BBVCBpcyBy
ZXF1aXJlZCBieSB0aGUNCj4+Pj4+PiBpOTE1IGRyaXZlcg0KPj4+Pj4gVGhlIGRyaXZlciBv
dWdodCB0byB3b3JrIGZpbmUgd2l0aG91dCBQQVQgKGFuZCBoZW5jZSB3aXRob3V0IGJlaW5n
DQo+Pj4+PiBhYmxlIHRvIG1ha2UgV0MgbWFwcGluZ3MpLiBJdCB3b3VsZCB1c2UgVUMgaW5z
dGVhZCBhbmQgYmUgc2xvdywgYnV0DQo+Pj4+PiBpdCBvdWdodCB0byB3b3JrLg0KPj4+Pj4N
Cj4+Pj4+PiBhbmQgdGhlcmVmb3JlIHRoZSBkcml2ZXIgc2hvdWxkIHJlZnVzZSB0byBkaXNh
YmxlDQo+Pj4+Pj4gaXQgaWYgdGhlIHVzZXIgcmVxdWVzdHMgdG8gZGlzYWJsZSBpdCBhbmQg
aW5zdGVhZCB3YXJuIHRoZSB1c2VyIHRoYXQNCj4+Pj4+PiB0aGUgZHJpdmVyIGRpZCBub3Qg
ZGlzYWJsZSB0aGUgZmVhdHVyZSwgY29udHJhcnkgdG8gd2hhdCB0aGUgdXNlcg0KPj4+Pj4+
IHJlcXVlc3RlZCB3aXRoIHRoZSBub3BhdCBvcHRpb24uDQo+Pj4+Pj4NCj4+Pj4+PiBJbiBh
bnkgY2FzZSwgbXkgdGVzdCBkaWQgbm90IHZlcmlmeSB0aGF0IHdoZW4gbm9wYXQgaXMgc2V0
IGluIExpbnV4DQo+Pj4+Pj4gNS4xNiwNCj4+Pj4+PiB0aGUgdGhyZWFkIHRha2VzIHRoZSBz
YW1lIGNvZGUgcGF0aCBhcyB3aGVuIG5vcGF0IGlzIG5vdCBzZXQsDQo+Pj4+Pj4gc28gSSBh
bSBub3QgdG90YWxseSBzdXJlIHRoYXQgdGhlIHJlYXNvbiBub3BhdCBkb2VzIG5vdCBicmVh
ayB0aGUNCj4+Pj4+PiBpOTE1IGRyaXZlciBpbiA1LjE2IGlzIHRoYXQgc3RhdGljX2NwdV9o
YXMoWDg2X0ZFQVRVUkVfUEFUKQ0KPj4+Pj4+IHJldHVybnMgdHJ1ZSBldmVuIHdoZW4gbm9w
YXQgaXMgc2V0LiBJIGNvdWxkIHRlc3QgaXQgd2l0aCBhIGN1c3RvbQ0KPj4+Pj4+IGxvZyBt
ZXNzYWdlIGluIDUuMTYgaWYgdGhhdCBpcyBuZWNlc3NhcnkuDQo+Pj4+Pj4NCj4+Pj4+PiBB
cmUgeW91IHNheWluZyBpdCB3YXMgd3JvbmcgZm9yIHN0YXRpY19jcHVfaGFzKFg4Nl9GRUFU
VVJFX1BBVCkNCj4+Pj4+PiB0byByZXR1cm4gdHJ1ZSBpbiA1LjE2IHdoZW4gdGhlIHVzZXIg
cmVxdWVzdHMgbm9wYXQ/DQo+Pj4+PiBObywgSSdtIG5vdCBzYXlpbmcgdGhhdC4gSXQgd2Fz
IHdyb25nIGZvciB0aGlzIGNvbnN0cnVjdCB0byBiZSB1c2VkDQo+Pj4+PiBpbiB0aGUgZHJp
dmVyLCB3aGljaCB3YXMgZml4ZWQgZm9yIDUuMTcgKGFuZCB3aGljaCBoYWQgY2F1c2VkIHRo
ZQ0KPj4+Pj4gcmVncmVzc2lvbiBJIGRpZCBvYnNlcnZlLCBsZWFkaW5nIHRvIHRoZSBwYXRj
aCBhcyBhIGhvcGVmdWxseSBsZWFzdA0KPj4+Pj4gYmFkIG9wdGlvbikuDQo+Pj4+Pg0KPj4+
Pj4+IEkgdGhpbmsgdGhhdCBpcw0KPj4+Pj4+IGp1c3QgcGVybWl0dGluZyBhIGJhZCBjb25m
aWd1cmF0aW9uIHRvIGJyZWFrIHRoZSBkcml2ZXIgdGhhdCBhDQo+Pj4+Pj4gd2VsbC13cml0
dGVuIG9wZXJhdGluZyBzeXN0ZW0gc2hvdWxkIG5vdCBhbGxvdy4gVGhlIGk5MTUgZHJpdmVy
DQo+Pj4+Pj4gd2FzLCBpbiBteSBvcGluaW9uLCBjb3JyZWN0bHkgaWdub3JpbmcgdGhlIG5v
cGF0IG9wdGlvbiBpbiA1LjE2DQo+Pj4+Pj4gYmVjYXVzZSB0aGF0IG9wdGlvbiBpcyBub3Qg
Y29tcGF0aWJsZSB3aXRoIHRoZSBoYXJkd2FyZSB0aGUNCj4+Pj4+PiBpOTE1IGRyaXZlciBp
cyB0cnlpbmcgdG8gaW5pdGlhbGl6ZSBhbmQgc2V0dXAgYXQgYm9vdCB0aW1lLiBBdCBsZWFz
dA0KPj4+Pj4+IHRoYXQgaXMgbXkgdW5kZXJzdGFuZGluZyBub3csIGJ1dCBJIHdpbGwgbmVl
ZCB0byB0ZXN0IGl0IG9uIDUuMTYNCj4+Pj4+PiB0byBiZSBzdXJlIEkgdW5kZXJzdGFuZCBp
dCBjb3JyZWN0bHkuDQo+Pj4+Pj4NCj4+Pj4+PiBBbHNvLCBBRkFJQ1QsIHlvdXIgcGF0Y2gg
d291bGQgYnJlYWsgdGhlIGRyaXZlciB3aGVuIHRoZSBub3BhdA0KPj4+Pj4+IG9wdGlvbiBp
cyBzZXQgYW5kIG9ubHkgZml4IHRoZSByZWdyZXNzaW9uIGludHJvZHVjZWQgYnkgYmRkOGI2
Yzk4MjM5DQo+Pj4+Pj4gd2hlbiBub3BhdCBpcyBub3Qgc2V0IG9uIG15IGJveCwgc28geW91
ciBwYXRjaCB3b3VsZA0KPj4+Pj4+IGludHJvZHVjZSBhIHJlZ3Jlc3Npb24gcmVsYXRpdmUg
dG8gTGludXggNS4xNiBhbmQgZWFybGllciBmb3IgdGhlDQo+Pj4+Pj4gY2FzZSB3aGVuIG5v
cGF0IGlzIHNldCBvbiBteSBib3guIEkgdGhpbmsgeW91ciBwb2ludCB3b3VsZA0KPj4+Pj4+
IGJlIHRoYXQgaXQgaXMgbm90IGEgcmVncmVzc2lvbiBpZiBpdCBpcyBhbiBpbmNvcnJlY3Qg
dXNlcg0KPj4+Pj4+IGNvbmZpZ3VyYXRpb24uDQo+Pj4+PiBBZ2FpbiBubyAtIG15IHZpZXcg
aXMgdGhhdCB0aGVyZSdzIGEgc2VwYXJhdGUsIHByZS1leGlzdGluZyBpc3N1ZQ0KPj4+Pj4g
aW4gdGhlIGRyaXZlciB3aGljaCB3YXMgdW5jb3ZlcmVkIGJ5IHRoZSBjaGFuZ2UuIFRoaXMg
bWF5IGJlIGENCj4+Pj4+IHBlcmNlaXZlZCByZWdyZXNzaW9uLCBidXQgaXMgaW1vIGRpZmZl
cmVudCBmcm9tIGEgcmVhbCBvbmUuDQo+Pj4gU29ycnksIGZvciB5b3UgbWF5YmUsIGJ1dCBJ
J20gcHJldHR5IHN1cmUgZm9yIExpbnVzIGl0J3Mgbm90IHdoZW4gaXQNCj4+PiBjb21lcyB0
byB0aGUgIm5vIHJlZ3Jlc3Npb25zIHJ1bGUiLiBKdXN0IHRvb2sgYSBxdWljayBsb29rIGF0
IHF1b3Rlcw0KPj4+IGZyb20gTGludXMNCj4+PiBodHRwczovL3d3dy5rZXJuZWwub3JnL2Rv
Yy9odG1sL2xhdGVzdC9wcm9jZXNzL2hhbmRsaW5nLXJlZ3Jlc3Npb25zLmh0bWwNCj4+PiBh
bmQgZm91bmQgdGhpcyBzdGF0ZW1lbnQgZnJvbSBMaW51cyB0byBiYWNrIHRoaXMgdXA6DQo+
Pj4NCj4+PiBgYGANCj4+PiBPbmUgX3BhcnRpY3VsYXJseV8gbGFzdC1taW51dGUgcmV2ZXJ0
IGlzIHRoZSB0b3AtbW9zdCBjb21taXQgKGlnbm9yaW5nDQo+Pj4gdGhlIHZlcnNpb24gY2hh
bmdlIGl0c2VsZikgZG9uZSBqdXN0IGJlZm9yZSB0aGUgcmVsZWFzZSwgYW5kIHdoaWxlDQo+
Pj4gaXQncyB2ZXJ5IGFubm95aW5nLCBpdCdzIHBlcmhhcHMgYWxzbyBpbnN0cnVjdGl2ZS4N
Cj4+Pg0KPj4+IFdoYXQncyBpbnN0cnVjdGl2ZSBhYm91dCBpdCBpcyB0aGF0IEkgcmV2ZXJ0
ZWQgYSBjb21taXQgdGhhdCB3YXNuJ3QNCj4+PiBhY3R1YWxseSBidWdneS4gSW4gZmFjdCwg
aXQgd2FzIGRvaW5nIGV4YWN0bHkgd2hhdCBpdCBzZXQgb3V0IHRvIGRvLA0KPj4+IGFuZCBk
aWQgaXQgdmVyeSB3ZWxsLiBJbiBmYWN0IGl0IGRpZCBpdCBfc29fIHdlbGwgdGhhdCB0aGUg
bXVjaA0KPj4+IGltcHJvdmVkIElPIHBhdHRlcm5zIGl0IGNhdXNlZCB0aGVuIGVuZGVkIHVw
IHJldmVhbGluZyBhIHVzZXItdmlzaWJsZQ0KPj4+IHJlZ3Jlc3Npb24gZHVlIHRvIGEgcmVh
bCBidWcgaW4gYSBjb21wbGV0ZWx5IHVucmVsYXRlZCBhcmVhLg0KPj4+IGBgYA0KPj4+DQo+
Pj4gSGUgc2FpZCB0aGF0IGhlcmU6DQo+Pj4gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2Mv
aHRtbC9sYXRlc3QvcHJvY2Vzcy9oYW5kbGluZy1yZWdyZXNzaW9ucy5odG1sDQo+Pj4NCj4+
PiBUaGUgc2l0dWF0aW9uIGlzIG9mIGNvdXJzZSBkaWZmZXJlbnQgaGVyZSwgYnV0IHNpbWls
YXIgZW5vdWdoLg0KPj4+DQo+Pj4+IFNpbmNlIGl0IGlzIGEgcmVncmVzc2lvbiwgSSB0aGlu
ayBmb3Igbm93IGJkZDhiNmM5ODIzOSBzaG91bGQNCj4+Pj4gYmUgcmV2ZXJ0ZWQgYW5kIHRo
ZSBmaXggYmFja3BvcnRlZCB0byBMaW51eCA1LjE3IHN0YWJsZSB1bnRpbA0KPj4+PiB0aGUg
dW5kZXJseWluZyBtZW1vcnkgc3Vic3lzdGVtIGNhbiBwcm92aWRlIHRoZSBpOTE1IGRyaXZl
cg0KPj4+PiB3aXRoIGFuIHVwZGF0ZWQgdGVzdCBmb3IgdGhlIFBBVCBmZWF0dXJlIHRoYXQg
YWxzbyBtZWV0cyB0aGUNCj4+Pj4gcmVxdWlyZW1lbnRzIG9mIHRoZSBhdXRob3Igb2YgYmRk
OGI2Yzk4MjM5IHdpdGhvdXQgYnJlYWtpbmcNCj4+Pj4gdGhlIGk5MTUgZHJpdmVyLg0KPj4+
IEknbSBub3QgYSBkZXZlbG9wZXIgYW5kIEknbSBkb24ndCBrbm93biB0aGUgZGV0YWlscyBv
ZiB0aGlzIHRocmVhZCBhbmQNCj4+PiB0aGUgYmFja3N0b3J5IG9mIHRoZSByZWdyZXNzaW9u
LCBidXQgaXQgc291bmRzIGxpa2UgdGhhdCdzIHRoZSBhcHByb2FjaA0KPj4+IHRoYXQgaXMg
bmVlZGVkIGhlcmUgdW50aWwgc29tZW9uZSBjb21lcyB1cCB3aXRoIGEgZml4IGZvciB0aGUg
cmVncmVzc2lvbg0KPj4+IGV4cG9zZWQgYnkgYmRkOGI2Yzk4MjM5Lg0KPj4+DQo+Pj4gQnV0
IGlmIEknbSB3cm9uZywgcGxlYXNlIHRlbGwgbWUuDQo+Pg0KPj4gWW91IGFyZSBtb3N0bHkg
cmlnaHQsIEkgdGhpbmsuIFJldmVydGluZyBiZGQ4YjZjOTgyMzkgZml4ZXMNCj4+IGl0LiBU
aGVyZSBpcyBhbm90aGVyIHdheSB0byBmaXggaXQsIHRob3VnaC4NCj4gDQo+IFllYWgsIEkn
bSBhd2FyZSBvZiBpdC4gQnV0IGl0IHNlZW1zLi4uDQo+IA0KPj4gVGhlIHBhdGNoIHByb3Bv
c2VkDQo+PiBieSBKYW4gQmV1bGljaCBhbHNvIGZpeGVzIHRoZSByZWdyZXNzaW9uIG9uIG15
IHN5c3RlbSwgc28gYXMNCj4+IHRoZSBwZXJzb24gcmVwb3J0aW5nIHRoaXMgaXMgYSByZWdy
ZXNzaW9uLCBJIHdvdWxkIGFsc28gYmUgc2F0aXNmaWVkDQo+PiB3aXRoIEphbidzIHBhdGNo
IGluc3RlYWQgb2YgcmV2ZXJ0aW5nIGJkZDhiNmM5ODIzOSBhcyBhIGZpeC4gSmFuDQo+PiBw
b3N0ZWQgaGlzIHByb3Bvc2VkIHBhdGNoIGhlcmU6DQo+Pg0KPj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC85Mzg1ZmE2MC1mYTVkLWY1NTktYTEzNy02NjA4NDA4Zjg4YjBAc3Vz
ZS5jb20vDQo+IA0KPiAuLi50aGF0IGFwcHJvYWNoIGlzIG5vdCBtYWtpbmcgYW55IHByb2dy
ZXNzIGVpdGhlcj8NCj4gDQo+IEphbiwgY2FuIGNvdWxkIHByb3ZpZGUgYSBzaG9ydCBzdGF0
dXMgdXBkYXRlIGhlcmU/IEknZCByZWFsbHkgbGlrZSB0bw0KPiBnZXQgdGhpcyByZWdyZXNz
aW9uIGZpeGVkIG9uZSB3YXkgb3IgYW5vdGhlciByYXRoZXIgc29vbmVyIHRoYW4gbGF0ZXIs
DQo+IGFzIHRoaXMgaXMgdGFrZW4gd2F5IHRvIGxvbmcgYWxyZWFkeSBJTUhPLg0KPiANCj4+
IFRoZSBvbmx5IHJlc2VydmF0aW9uIEkgaGF2ZSBhYm91dCBKYW4ncyBwYXRjaCBpcyB0aGF0
IHRoZSBjb21taXQNCj4+IG1lc3NhZ2UgZG9lcyBub3QgY2xlYXJseSBleHBsYWluIGhvdyB0
aGUgcGF0Y2ggY2hhbmdlcyB3aGF0DQo+PiB0aGUgbm9wYXQga2VybmVsIGJvb3Qgb3B0aW9u
IGRvZXMuIEl0IGRvZXNuJ3QgYWZmZWN0IG1lIGJlY2F1c2UNCj4+IEkgZG9uJ3QgdXNlIG5v
cGF0LCBidXQgaXQgc2hvdWxkIHByb2JhYmx5IGJlIG1lbnRpb25lZCBpbiB0aGUNCj4+IGNv
bW1pdCBtZXNzYWdlLCBhcyBwb2ludGVkIG91dCBoZXJlOg0KPj4NCj4+IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2xrbWwvYmQ5ZWQyYzItMTMzNy0yN2JiLWM5ZGEtZGZjN2IzMWQ0OTJj
QG5ldHNjYXBlLm5ldC8NCj4+DQo+Pg0KPj4gV2hhdGV2ZXIgZml4IGZvciB0aGUgcmVncmVz
c2lvbiBleHBvc2VkIGJ5IGJkZDhiNmM5ODIzOSBhbHNvDQo+PiBuZWVkcyB0byBiZSBiYWNr
cG9ydGVkIHRvIHRoZSBzdGFibGUgdmVyc2lvbnMgNS4xNyBhbmQgNS4xOC4NCj4gDQo+IFN1
cmUuDQo+IA0KPiBCVFcsIGFzIHlvdSBzZWVtIHRvIGJlIGZhbWlsaWFyIHdpdGggdGhlIGlz
c3VlOiB0aGVyZSBpcyBhbm90aGVyIHJlcG9ydA0KPiBhYm91dCBhIHJlZ3Jlc3Npb24gV1JU
IHRvIFhlbiBhbmQgaTkxNSAodGhhdCBpcyBhbHNvIG5vdCBtYWtpbmcgcmVhbGx5DQo+IHBy
b2dyZXNzKToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9ZbiUyRlRnajFFaHMl
MkZCZHBIcEBpdGwtZW1haWwvDQo+IA0KPiBJdCdzIGp1c3QgYSB3aWxkIGd1ZXNzLCBidXQg
Ym91bGQgdGhpcyBzb21laG93IGJlIHJlbGF0ZWQ/DQoNCk5vLCBkb2Vzbid0IHNlZW0gc28u
DQoNCkknbSBqdXN0IHJldmlld2luZyB0aGUgc3VnZ2VzdGVkIGZpeDoNCg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC9ZbzBMd21WVURTQlpiNDRLQGl0bC1lbWFpbC8NCg0KDQpK
dWVyZ2VuDQo=
--------------1JYoJE0gc0gGkSGQBbWTf8g3
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------1JYoJE0gc0gGkSGQBbWTf8g3--

--------------53G0UGMnr335AXWugItqKkAF--

--------------BfyGk3XKVACj6W41lAYZo2BD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmKN4xEFAwAAAAAACgkQsN6d1ii/Ey+J
awf/UGRdyZzPs0sv6p9bQhiaqdyYojQ0J5NbXM0b9Ib3Tt9fZU8sd+mMbYBi7mFpZjUeHcd9BuN6
7YMWPs0HlVJQOzww9nfd9pbwOndzbll8JmYLDGhRCOC2uffROxp6mxGBraNNPUdFxYZ7piwMdPwB
NRvAr8E6HGriaiA6t1y3iiTtkMHNZmKAe1ILof4mIBNFOwVacGHKiDU1FOrKFHqjYfncSOh+p6Hn
XskdgoFUNP8G2KUM1xehwvk1bFWk+m59+hWoHmJqomTYCkn6PogPpbkJiRBe5B3tUcmuIED0VOPY
tjJMPtkkk97jswLdC2BSjp3XIbXSMmqs3uFFtk5NfQ==
=rhGD
-----END PGP SIGNATURE-----

--------------BfyGk3XKVACj6W41lAYZo2BD--

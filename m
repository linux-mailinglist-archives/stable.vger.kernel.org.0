Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750AE461A0C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378423AbhK2Oox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:44:53 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:46232 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378848AbhK2Omk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 09:42:40 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 82EB71FCA1;
        Mon, 29 Nov 2021 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638196760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7uRp09YN+2wwoLXxVBcU3pfHZe88L/deD7R42M+YS8=;
        b=bDuBVaOCI2Jte50hcwFHZesvTNeoIHO47fD7LtWPgm3eNoKRZq8wsqCNHXR4oq64LqIUal
        Pd0RhrRj4sEpboM+ubV2MaMEcaDhw4XSYlSX6W0QJ+A5wm43EOsvpCFewNqPp7w+TFDuB6
        JAQrt2poofsGS6s5XP5S7WCzu/aO+lI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638196760;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7uRp09YN+2wwoLXxVBcU3pfHZe88L/deD7R42M+YS8=;
        b=YrRKqm8hESMq65g/AmZkNHO/Edk1fC7lkhXr4UvthN2XPdISdmKptwUvOk88XdoA5bQ14L
        S/AJ0FqIBpSraDAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B70B13B15;
        Mon, 29 Nov 2021 14:39:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eJFpMBfmpGEjCAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 29 Nov 2021 14:39:19 +0000
Message-ID: <800280a5-ea6f-2f9c-1ae1-d626f3a18e23@suse.de>
Date:   Mon, 29 Nov 2021 15:39:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] efi: Move efifb_setup_from_dmi() prototype from arch
 headers
Content-Language: en-US
To:     Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        stable@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, x86@kernel.org
References: <20211126001333.555514-1-javierm@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20211126001333.555514-1-javierm@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zGJ8z5U3jir98KXlGDVY7zsl"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zGJ8z5U3jir98KXlGDVY7zsl
Content-Type: multipart/mixed; boundary="------------6KQ91Ngk6Y2LlxOCUjB8Gk4a";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Javier Martinez Canillas <javierm@redhat.com>,
 linux-kernel@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
 stable@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
 Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Daniel Vetter <daniel.vetter@ffwll.ch>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Russell King <linux@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org, x86@kernel.org
Message-ID: <800280a5-ea6f-2f9c-1ae1-d626f3a18e23@suse.de>
Subject: Re: [PATCH] efi: Move efifb_setup_from_dmi() prototype from arch
 headers
References: <20211126001333.555514-1-javierm@redhat.com>
In-Reply-To: <20211126001333.555514-1-javierm@redhat.com>

--------------6KQ91Ngk6Y2LlxOCUjB8Gk4a
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjYuMTEuMjEgdW0gMDE6MTMgc2NocmllYiBKYXZpZXIgTWFydGluZXogQ2Fu
aWxsYXM6DQo+IENvbW1pdCA4NjMzZWY4MmYxMDEgKCJkcml2ZXJzL2Zpcm13YXJlOiBjb25z
b2xpZGF0ZSBFRkkgZnJhbWVidWZmZXIgc2V0dXANCj4gZm9yIGFsbCBhcmNoZXMiKSBtYWRl
IHRoZSBHZW5lcmljIFN5c3RlbSBGcmFtZWJ1ZmZlcnMgKHN5c2ZiKSBkcml2ZXIgYWJsZQ0K
PiB0byBiZSBidWlsdCBvbiBub24teDg2IGFyY2hpdGVjdHVyZXMuDQo+IA0KPiBCdXQgbGVm
dCB0aGUgZWZpZmJfc2V0dXBfZnJvbV9kbWkoKSBmdW5jdGlvbiBwcm90b3R5cGUgZGVjbGFy
YXRpb24gaW4gdGhlDQo+IGFyY2hpdGVjdHVyZSBzcGVjaWZpYyBoZWFkZXJzLiBUaGlzIGNv
dWxkIGxlYWQgdG8gdGhlIGZvbGxvd2luZyBjb21waWxlcg0KPiB3YXJuaW5nIGFzIHJlcG9y
dGVkIGJ5IHRoZSBrZXJuZWwgdGVzdCByb2JvdDoNCj4gDQo+ICAgICBkcml2ZXJzL2Zpcm13
YXJlL2VmaS9zeXNmYl9lZmkuYzo3MDo2OiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5
cGUgZm9yIGZ1bmN0aW9uICdlZmlmYl9zZXR1cF9mcm9tX2RtaScgWy1XbWlzc2luZy1wcm90
b3R5cGVzXQ0KPiAgICAgdm9pZCBlZmlmYl9zZXR1cF9mcm9tX2RtaShzdHJ1Y3Qgc2NyZWVu
X2luZm8gKnNpLCBjb25zdCBjaGFyICpvcHQpDQo+ICAgICAgICAgIF4NCj4gICAgIGRyaXZl
cnMvZmlybXdhcmUvZWZpL3N5c2ZiX2VmaS5jOjcwOjE6IG5vdGU6IGRlY2xhcmUgJ3N0YXRp
YycgaWYgdGhlIGZ1bmN0aW9uIGlzIG5vdCBpbnRlbmRlZCB0byBiZSB1c2VkIG91dHNpZGUg
b2YgdGhpcyB0cmFuc2xhdGlvbiB1bml0DQo+ICAgICB2b2lkIGVmaWZiX3NldHVwX2Zyb21f
ZG1pKHN0cnVjdCBzY3JlZW5faW5mbyAqc2ksIGNvbnN0IGNoYXIgKm9wdCkNCj4gDQo+IEZp
eGVzOiA4NjMzZWY4MmYxMDEgKCJkcml2ZXJzL2Zpcm13YXJlOiBjb25zb2xpZGF0ZSBFRkkg
ZnJhbWVidWZmZXIgc2V0dXAgZm9yIGFsbCBhcmNoZXMiKQ0KPiBSZXBvcnRlZC1ieToga2Vy
bmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+IENjOiA8c3RhYmxlQHZnZXIua2Vy
bmVsLm9yZz4gIyA1LjE1LngNCj4gU2lnbmVkLW9mZi1ieTogSmF2aWVyIE1hcnRpbmV6IENh
bmlsbGFzIDxqYXZpZXJtQHJlZGhhdC5jb20+DQoNCkFja2VkLWJ5OiBUaG9tYXMgWmltbWVy
bWFubiA8dHppbW1lcm1hbm5Ac3VzZS5kZT4NCg0KPiAtLS0NCj4gDQo+ICAgYXJjaC9hcm0v
aW5jbHVkZS9hc20vZWZpLmggICB8IDEgLQ0KPiAgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20v
ZWZpLmggfCAxIC0NCj4gICBhcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2VmaS5oIHwgMSAtDQo+
ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vZWZpLmggICB8IDIgLS0NCj4gICBpbmNsdWRlL2xp
bnV4L2VmaS5oICAgICAgICAgIHwgNiArKysrKysNCj4gICA1IGZpbGVzIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L2FybS9pbmNsdWRlL2FzbS9lZmkuaCBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2VmaS5oDQo+
IGluZGV4IGE2ZjNiMTc5ZThhOS4uMjcyMThlYWJiZjlhIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L2FybS9pbmNsdWRlL2FzbS9lZmkuaA0KPiArKysgYi9hcmNoL2FybS9pbmNsdWRlL2FzbS9l
ZmkuaA0KPiBAQCAtMTcsNyArMTcsNiBAQA0KPiAgIA0KPiAgICNpZmRlZiBDT05GSUdfRUZJ
DQo+ICAgdm9pZCBlZmlfaW5pdCh2b2lkKTsNCj4gLWV4dGVybiB2b2lkIGVmaWZiX3NldHVw
X2Zyb21fZG1pKHN0cnVjdCBzY3JlZW5faW5mbyAqc2ksIGNvbnN0IGNoYXIgKm9wdCk7DQo+
ICAgDQo+ICAgaW50IGVmaV9jcmVhdGVfbWFwcGluZyhzdHJ1Y3QgbW1fc3RydWN0ICptbSwg
ZWZpX21lbW9yeV9kZXNjX3QgKm1kKTsNCj4gICBpbnQgZWZpX3NldF9tYXBwaW5nX3Blcm1p
c3Npb25zKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBlZmlfbWVtb3J5X2Rlc2NfdCAqbWQpOw0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9lZmkuaCBiL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20vZWZpLmgNCj4gaW5kZXggZDNlMTgyNTMzN2JlLi5hZDU1MDc5YWJl
NDcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vZWZpLmgNCj4gKysr
IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9lZmkuaA0KPiBAQCAtMTQsNyArMTQsNiBAQA0K
PiAgIA0KPiAgICNpZmRlZiBDT05GSUdfRUZJDQo+ICAgZXh0ZXJuIHZvaWQgZWZpX2luaXQo
dm9pZCk7DQo+IC1leHRlcm4gdm9pZCBlZmlmYl9zZXR1cF9mcm9tX2RtaShzdHJ1Y3Qgc2Ny
ZWVuX2luZm8gKnNpLCBjb25zdCBjaGFyICpvcHQpOw0KPiAgICNlbHNlDQo+ICAgI2RlZmlu
ZSBlZmlfaW5pdCgpDQo+ICAgI2VuZGlmDQo+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2lu
Y2x1ZGUvYXNtL2VmaS5oIGIvYXJjaC9yaXNjdi9pbmNsdWRlL2FzbS9lZmkuaA0KPiBpbmRl
eCA0OWIzOThmZTk5ZjEuLmNjNGY2Nzg3ZjkzNyAxMDA2NDQNCj4gLS0tIGEvYXJjaC9yaXNj
di9pbmNsdWRlL2FzbS9lZmkuaA0KPiArKysgYi9hcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2Vm
aS5oDQo+IEBAIC0xMyw3ICsxMyw2IEBADQo+ICAgDQo+ICAgI2lmZGVmIENPTkZJR19FRkkN
Cj4gICBleHRlcm4gdm9pZCBlZmlfaW5pdCh2b2lkKTsNCj4gLWV4dGVybiB2b2lkIGVmaWZi
X3NldHVwX2Zyb21fZG1pKHN0cnVjdCBzY3JlZW5faW5mbyAqc2ksIGNvbnN0IGNoYXIgKm9w
dCk7DQo+ICAgI2Vsc2UNCj4gICAjZGVmaW5lIGVmaV9pbml0KCkNCj4gICAjZW5kaWYNCj4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2VmaS5oIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vZWZpLmgNCj4gaW5kZXggNGQwYjEyNjgzNWI4Li42MzE1OGZkNTU4NTYgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2VmaS5oDQo+ICsrKyBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2VmaS5oDQo+IEBAIC0xOTcsOCArMTk3LDYgQEAgc3RhdGljIGlu
bGluZSBib29sIGVmaV9ydW50aW1lX3N1cHBvcnRlZCh2b2lkKQ0KPiAgIA0KPiAgIGV4dGVy
biB2b2lkIHBhcnNlX2VmaV9zZXR1cCh1NjQgcGh5c19hZGRyLCB1MzIgZGF0YV9sZW4pOw0K
PiAgIA0KPiAtZXh0ZXJuIHZvaWQgZWZpZmJfc2V0dXBfZnJvbV9kbWkoc3RydWN0IHNjcmVl
bl9pbmZvICpzaSwgY29uc3QgY2hhciAqb3B0KTsNCj4gLQ0KPiAgIGV4dGVybiB2b2lkIGVm
aV90aHVua19ydW50aW1lX3NldHVwKHZvaWQpOw0KPiAgIGVmaV9zdGF0dXNfdCBlZmlfc2V0
X3ZpcnR1YWxfYWRkcmVzc19tYXAodW5zaWduZWQgbG9uZyBtZW1vcnlfbWFwX3NpemUsDQo+
ICAgCQkJCQkgdW5zaWduZWQgbG9uZyBkZXNjcmlwdG9yX3NpemUsDQo+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L2VmaS5oIGIvaW5jbHVkZS9saW51eC9lZmkuaA0KPiBpbmRleCBk
YmQzOWIyMGUwMzQuLmVmOGRiYzBhMTUyMiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51
eC9lZmkuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2VmaS5oDQo+IEBAIC0xMjgzLDQgKzEy
ODMsMTAgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgZWZpX21va3Zhcl90YWJsZV9lbnRyeSAq
ZWZpX21va3Zhcl9lbnRyeV9maW5kKA0KPiAgIH0NCj4gICAjZW5kaWYNCj4gICANCj4gKyNp
ZmRlZiBDT05GSUdfU1lTRkINCj4gK2V4dGVybiB2b2lkIGVmaWZiX3NldHVwX2Zyb21fZG1p
KHN0cnVjdCBzY3JlZW5faW5mbyAqc2ksIGNvbnN0IGNoYXIgKm9wdCk7DQo+ICsjZWxzZQ0K
PiArc3RhdGljIGlubGluZSB2b2lkIGVmaWZiX3NldHVwX2Zyb21fZG1pKHN0cnVjdCBzY3Jl
ZW5faW5mbyAqc2ksIGNvbnN0IGNoYXIgKm9wdCkgeyB9DQo+ICsjZW5kaWYNCj4gKw0KPiAg
ICNlbmRpZiAvKiBfTElOVVhfRUZJX0ggKi8NCj4gDQoNCi0tIA0KVGhvbWFzIFppbW1lcm1h
bm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25z
IEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55
DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRv
dGV2DQo=

--------------6KQ91Ngk6Y2LlxOCUjB8Gk4a--

--------------zGJ8z5U3jir98KXlGDVY7zsl
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmGk5hcFAwAAAAAACgkQlh/E3EQov+BU
IBAAsrJse0TjcHf8zr6/2DkGksRGeAdo2qzMsN++QB4k5UCY7x3qo3kE8iSOU5BPtBE+EI9ColSs
mSjE4reGmcjo6RKpPqhUQGFyhwG5Aa2TQcXmobdSnMrAZUa3eoNpg0K4joRJoFTzujG2Ap0zawr1
pv7ygAzexGU8UzhxYW1p+4kwoHL7ehz3VA6wUqYaUlE22zk3Mr1Nnkhqz3XQ2pGbdTSqY9c7j3/q
4QDBZhVvS0W6kHcRGw/nHypwpAYUH8GgFjr5NOUntm6K2oZRRR9tg+hm97igR/FDF6wkQkIDDH0A
vtRIVKWq+ByLF9djP5Wj9csmUQ4GckdHGYsD+jmAcJFSBkIFer87NGJABa+TfL2Nc4R70cEiMfeQ
PcrL7cu6jAFJQ/MCh660ByMoV8t905fjhV0xZicNdBc4bMRY3zxepxgwuWttrTwcBkAlF1TqdLuP
PgcpEKQxCFXay7b+rWuWkH7A4ewbrIOfqljftsCbAPgYP3JXJyi66Wx7vEiS53cZsYzNyUEJgnTT
45nqSIT4xiTCdQF2zHKiYZjacCqzUMV1zAEn2CF3+wSNB1DKOjiKfKQHOMdZUgV0IAHP2aXYxdJz
hqAaSED/o1wFc95toK42TyKgLh0zRHVTDM1OdP94SRPB2bGQkJ4yWxVxZuAGJohKWWGv0pEFNr+c
Jx8=
=+2u3
-----END PGP SIGNATURE-----

--------------zGJ8z5U3jir98KXlGDVY7zsl--

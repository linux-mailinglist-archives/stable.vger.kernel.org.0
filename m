Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F504981E7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbiAXOTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:19:07 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51310 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiAXOTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:19:07 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 538C51F38B;
        Mon, 24 Jan 2022 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643033946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vBlEAG4oR1EQ+xTOGHhbgnbAWxjzqEx/takgh63gjNs=;
        b=eJb+M+NlVPb9E73+T71x2jFz9kMCQVjekR70BqYpWvEjU7B+b8DK/GPUmgD/t1oSdD840A
        bDN46GjTEEH/m5CQvFFuO3MAh/eREyMisADiyX7ZoXwZ10NilQCBhwS93pBwXh4jUqokJw
        3h/Iz5tUAKYjzuRHZD2qhpIJOmuggyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643033946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vBlEAG4oR1EQ+xTOGHhbgnbAWxjzqEx/takgh63gjNs=;
        b=NAsORfBBsQZssMVpAGd7YJjVBKSE7BjP7jCARZs97xSRi27HpE/1xZd16tIAcw0JQ5xMsF
        pEnqgTe1jvByoFCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 091EC13BF6;
        Mon, 24 Jan 2022 14:19:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nxs3AVq17mEKcQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 24 Jan 2022 14:19:06 +0000
Message-ID: <77e52472-4af7-c03f-f6e4-45ec820f2778@suse.de>
Date:   Mon, 24 Jan 2022 15:19:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced
 removal
Content-Language: en-US
To:     Javier Martinez Canillas <javierm@redhat.com>, zackr@vmware.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, deller@gmx.de,
        hdegoede@redhat.com
Cc:     linux-fbdev@vger.kernel.org, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <20220124123659.4692-1-tzimmermann@suse.de>
 <20220124123659.4692-2-tzimmermann@suse.de>
 <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------xPH0sPVAForQpIKm8KBQfGrp"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------xPH0sPVAForQpIKm8KBQfGrp
Content-Type: multipart/mixed; boundary="------------jbZfzBZvALXY47A0Gnk0rPzH";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Javier Martinez Canillas <javierm@redhat.com>, zackr@vmware.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@linux.ie,
 daniel@ffwll.ch, deller@gmx.de, hdegoede@redhat.com
Cc: linux-fbdev@vger.kernel.org, stable@vger.kernel.org,
 dri-devel@lists.freedesktop.org
Message-ID: <77e52472-4af7-c03f-f6e4-45ec820f2778@suse.de>
Subject: Re: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced
 removal
References: <20220124123659.4692-1-tzimmermann@suse.de>
 <20220124123659.4692-2-tzimmermann@suse.de>
 <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>
In-Reply-To: <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>

--------------jbZfzBZvALXY47A0Gnk0rPzH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjQuMDEuMjIgdW0gMTQ6NTIgc2NocmllYiBKYXZpZXIgTWFydGluZXogQ2Fu
aWxsYXM6DQo+IEhlbGxvIFRob21hcywNCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHBhdGNoLg0K
PiANCj4gT24gMS8yNC8yMiAxMzozNiwgVGhvbWFzIFppbW1lcm1hbm4gd3JvdGU6DQo+PiBI
b3QtdW5wbHVnIGFsbCBmaXJtd2FyZS1mcmFtZWJ1ZmZlciBkZXZpY2VzIGFzIHBhcnQgb2Yg
cmVtb3ZpbmcNCj4+IHRoZW0gdmlhIHJlbW92ZV9jb25mbGljdGluZ19mcmFtZWJ1ZmZlcnMo
KSBldCBhbC4gUmVsZWFzZXMgYWxsDQo+PiBtZW1vcnkgcmVnaW9ucyB0byBiZSBhY3F1aXJl
ZCBieSBuYXRpdmUgZHJpdmVycy4NCj4+DQo+PiBGaXJtd2FyZSwgc3VjaCBhcyBFRkksIGlu
c3RhbGwgYSBmcmFtZWJ1ZmZlciB3aGlsZSBwb3N0aW5nIHRoZQ0KPj4gY29tcHV0ZXIuIEFm
dGVyIHJlbW92aW5nIHRoZSBmaXJtd2FyZS1mcmFtZWJ1ZmZlciBkZXZpY2UgZnJvbSBmYmRl
diwNCj4+IGEgbmF0aXZlIGRyaXZlciB0YWtlcyBvdmVyIHRoZSBoYXJkd2FyZSBhbmQgdGhl
IGZpcm13YXJlIGZyYW1lYnVmZmVyDQo+PiBiZWNvbWVzIGludmFsaWQuDQo+Pg0KPj4gRmly
bXdhcmUtZnJhbWVidWZmZXIgZHJpdmVycywgc3BlY2lmaWNhbGx5IHNpbXBsZWZiLCBkb24n
dCByZWxlYXNlDQo+PiB0aGVpciBkZXZpY2UgZnJvbSBMaW51eCcgZGV2aWNlIGhpZXJhcmNo
eS4gSXQgc3RpbGwgb3ducyB0aGUgZmlybXdhcmUNCj4+IGZyYW1lYnVmZmVyIGFuZCBibG9j
a3MgdGhlIG5hdGl2ZSBkcml2ZXJzIGZyb20gbG9hZGluZy4gVGhpcyBoYXMgYmVlbg0KPj4g
b2JzZXJ2ZWQgaW4gdGhlIHZtd2dmeCBkcml2ZXIuIFsxXQ0KPj4NCj4+IEluaXRpYXRpbmcg
YSBkZXZpY2UgcmVtb3ZhbCAoaS5lLiwgaG90IHVucGx1ZykgYXMgcGFydCBvZg0KPj4gcmVt
b3ZlX2NvbmZsaWN0aW5nX2ZyYW1lYnVmZmVycygpIHJlbW92ZXMgdGhlIHVuZGVybHlpbmcg
ZGV2aWNlIGFuZA0KPj4gcmV0dXJucyB0aGUgbWVtb3J5IHJhbmdlIHRvIHRoZSBzeXN0ZW0u
DQo+Pg0KPj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaS1kZXZlbC8yMDIyMDEx
NzE4MDM1OS4xODExNC0xLXphY2tAa2RlLm9yZy8NCj4+DQo+IA0KPiBJIHdvdWxkIGFkZCBh
IFJlcG9ydGVkLWJ5IHRhZyBoZXJlIGZvciBaYWNrLg0KDQpJbmRlZWQsIEkgc2ltcGx5IGZv
cmdvdCBhYm91dCBpdC4NCg0KPiANCj4+IFNpZ25lZC1vZmYtYnk6IFRob21hcyBaaW1tZXJt
YW5uIDx0emltbWVybWFubkBzdXNlLmRlPg0KPj4gQ0M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcgIyB2NS4xMSsNCj4+IC0tLQ0KPj4gICBkcml2ZXJzL3ZpZGVvL2ZiZGV2L2NvcmUvZmJt
ZW0uYyB8IDI5ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tDQo+PiAgIGluY2x1ZGUv
bGludXgvZmIuaCAgICAgICAgICAgICAgIHwgIDEgKw0KPj4gICAyIGZpbGVzIGNoYW5nZWQs
IDI3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYm1lbS5jIGIvZHJpdmVycy92aWRlby9mYmRl
di9jb3JlL2ZibWVtLmMNCj4+IGluZGV4IDBmYTdlZGU5NGZhNi4uZjczZjg0MTViOGNiIDEw
MDY0NA0KPj4gLS0tIGEvZHJpdmVycy92aWRlby9mYmRldi9jb3JlL2ZibWVtLmMNCj4+ICsr
KyBiL2RyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYm1lbS5jDQo+PiBAQCAtMjUsNiArMjUs
NyBAQA0KPj4gICAjaW5jbHVkZSA8bGludXgvaW5pdC5oPg0KPj4gICAjaW5jbHVkZSA8bGlu
dXgvbGludXhfbG9nby5oPg0KPj4gICAjaW5jbHVkZSA8bGludXgvcHJvY19mcy5oPg0KPj4g
KyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4+ICAgI2luY2x1ZGUgPGxp
bnV4L3NlcV9maWxlLmg+DQo+PiAgICNpbmNsdWRlIDxsaW51eC9jb25zb2xlLmg+DQo+PiAg
ICNpbmNsdWRlIDxsaW51eC9rbW9kLmg+DQo+PiBAQCAtMTU1NywxOCArMTU1OCwzNiBAQCBz
dGF0aWMgdm9pZCBkb19yZW1vdmVfY29uZmxpY3RpbmdfZnJhbWVidWZmZXJzKHN0cnVjdCBh
cGVydHVyZXNfc3RydWN0ICphLA0KPj4gICAJLyogY2hlY2sgYWxsIGZpcm13YXJlIGZicyBh
bmQga2ljayBvZmYgaWYgdGhlIGJhc2UgYWRkciBvdmVybGFwcyAqLw0KPj4gICAJZm9yX2Vh
Y2hfcmVnaXN0ZXJlZF9mYihpKSB7DQo+PiAgIAkJc3RydWN0IGFwZXJ0dXJlc19zdHJ1Y3Qg
Kmdlbl9hcGVyOw0KPj4gKwkJc3RydWN0IGRldmljZSAqZGV2Ow0KPj4gICANCj4+ICAgCQlp
ZiAoIShyZWdpc3RlcmVkX2ZiW2ldLT5mbGFncyAmIEZCSU5GT19NSVNDX0ZJUk1XQVJFKSkN
Cj4+ICAgCQkJY29udGludWU7DQo+PiAgIA0KPj4gICAJCWdlbl9hcGVyID0gcmVnaXN0ZXJl
ZF9mYltpXS0+YXBlcnR1cmVzOw0KPj4gKwkJZGV2ID0gcmVnaXN0ZXJlZF9mYltpXS0+ZGV2
aWNlOw0KPj4gICAJCWlmIChmYl9kb19hcGVydHVyZXNfb3ZlcmxhcChnZW5fYXBlciwgYSkg
fHwNCj4+ICAgCQkJKHByaW1hcnkgJiYgZ2VuX2FwZXIgJiYgZ2VuX2FwZXItPmNvdW50ICYm
DQo+PiAgIAkJCSBnZW5fYXBlci0+cmFuZ2VzWzBdLmJhc2UgPT0gVkdBX0ZCX1BIWVMpKSB7
DQo+PiAgIA0KPj4gICAJCQlwcmludGsoS0VSTl9JTkZPICJmYiVkOiBzd2l0Y2hpbmcgdG8g
JXMgZnJvbSAlc1xuIiwNCj4+ICAgCQkJICAgICAgIGksIG5hbWUsIHJlZ2lzdGVyZWRfZmJb
aV0tPmZpeC5pZCk7DQo+PiAtCQkJZG9fdW5yZWdpc3Rlcl9mcmFtZWJ1ZmZlcihyZWdpc3Rl
cmVkX2ZiW2ldKTsNCj4+ICsNCj4+ICsJCQkvKg0KPj4gKwkJCSAqIElmIHdlIGtpY2stb3V0
IGEgZmlybXdhcmUgZHJpdmVyLCB3ZSBhbHNvIHdhbnQgdG8gcmVtb3ZlDQo+PiArCQkJICog
dGhlIHVuZGVybHlpbmcgcGxhdGZvcm0gZGV2aWNlLCBzdWNoIGFzIHNpbXBsZS1mcmFtZWJ1
ZmZlciwNCj4+ICsJCQkgKiBWRVNBLCBFRkksIGV0Yy4gQSBuYXRpdmUgZHJpdmVyIHdpbGwg
dGhlbiBiZSBhYmxlIHRvDQo+PiArCQkJICogYWxsb2NhdGUgdGhlIG1lbW9yeSByYW5nZS4N
Cj4+ICsJCQkgKg0KPj4gKwkJCSAqIElmIGl0J3Mgbm90IGEgcGxhdGZvcm0gZGV2aWNlLCBh
dCBsZWFzdCBwcmludCBhIHdhcm5pbmcuIEENCj4+ICsJCQkgKiBmaXggd291bGQgYWRkIGNv
ZGUgdG8gcmVtb3ZlIHRoZSBkZXZpY2UgZnJvbSB0aGUgc3lzdGVtLg0KPj4gKwkJCSAqLw0K
Pj4gKwkJCWlmIChkZXZfaXNfcGxhdGZvcm0oZGV2KSkgew0KPiANCj4gSW4gZG9fcmVnaXN0
ZXJfZnJhbWVidWZmZXIoKSBjcmVhdGluZyB0aGUgZmIlZCBpcyBub3QgYSBmYXRhbCBlcnJv
ci4gSXQgd291bGQNCj4gYmUgc2FmZXIgdG8gZG8gaWYgKCFJU19FUlJfT1JfTlVMTChkZXYp
ICYmIGRldl9pc19wbGF0Zm9ybShkZXYpKSBpbnN0ZWFkIGhlcmUuDQo+IA0KPiBodHRwczov
L2VsaXhpci5ib290bGluLmNvbS9saW51eC9sYXRlc3Qvc291cmNlL2RyaXZlcnMvdmlkZW8v
ZmJkZXYvY29yZS9mYm1lbS5jI0wxNjA1DQoNCidkZXYnIGhlcmUgcmVmZXJzIHRvICdmYl9p
bmZvLT5kZXZpY2UnLCB3aGljaCBpcyB0aGUgdW5kZXJseWluZyBkZXZpY2UgDQpjcmVhdGVk
IGJ5IHRoZSBzeXNmYiBjb2RlLiAgZmJfaW5mby0+ZGV2IGlzIHNvbWV0aGluZyBkaWZmZXJl
bnQuDQoNCj4gDQo+PiArCQkJCXJlZ2lzdGVyZWRfZmJbaV0tPmZvcmNlZF9vdXQgPSB0cnVl
Ow0KPj4gKwkJCQlwbGF0Zm9ybV9kZXZpY2VfdW5yZWdpc3Rlcih0b19wbGF0Zm9ybV9kZXZp
Y2UoZGV2KSk7DQo+PiArCQkJfSBlbHNlIHsNCj4+ICsJCQkJcHJfd2FybigiZmIlZDogY2Fu
bm90IHJlbW92ZSBkZXZpY2VcbiIsIGkpOw0KPj4gKwkJCQlkb191bnJlZ2lzdGVyX2ZyYW1l
YnVmZmVyKHJlZ2lzdGVyZWRfZmJbaV0pOw0KPj4gKwkJCX0NCj4+ICAgCQl9DQo+PiAgIAl9
DQo+PiAgIH0NCj4+IEBAIC0xODk4LDkgKzE5MTcsMTMgQEAgRVhQT1JUX1NZTUJPTChyZWdp
c3Rlcl9mcmFtZWJ1ZmZlcik7DQo+PiAgIHZvaWQNCj4+ICAgdW5yZWdpc3Rlcl9mcmFtZWJ1
ZmZlcihzdHJ1Y3QgZmJfaW5mbyAqZmJfaW5mbykNCj4+ICAgew0KPj4gLQltdXRleF9sb2Nr
KCZyZWdpc3RyYXRpb25fbG9jayk7DQo+PiArCWJvb2wgZm9yY2VkX291dCA9IGZiX2luZm8t
PmZvcmNlZF9vdXQ7DQo+PiArDQo+PiArCWlmICghZm9yY2VkX291dCkNCj4+ICsJCW11dGV4
X2xvY2soJnJlZ2lzdHJhdGlvbl9sb2NrKTsNCj4+ICAgCWRvX3VucmVnaXN0ZXJfZnJhbWVi
dWZmZXIoZmJfaW5mbyk7DQo+PiAtCW11dGV4X3VubG9jaygmcmVnaXN0cmF0aW9uX2xvY2sp
Ow0KPj4gKwlpZiAoIWZvcmNlZF9vdXQpDQo+PiArCQltdXRleF91bmxvY2soJnJlZ2lzdHJh
dGlvbl9sb2NrKTsNCj4+ICAgfQ0KPiANCj4gSSdtIG5vdCBzdXJlIHRvIGZvbGxvdyB0aGUg
bG9naWMgaGVyZS4gVGhlIGZvcmNlZF9vdXQgYm9vbCBpcyBzZXQgd2hlbiB0aGUNCj4gcGxh
dGZvcm0gZGV2aWNlIGlzIHVucmVnaXN0ZXJlZCBpbiBkb19yZW1vdmVfY29uZmxpY3Rpbmdf
ZnJhbWVidWZmZXJzKCksDQo+IGJ1dCBzaG91bGRuJ3QgdGhlIHN0cnVjdCBwbGF0Zm9ybV9k
cml2ZXIgLnJlbW92ZSBjYWxsYmFjayBiZSBleGVjdXRlZCBldmVuDQo+IGluIHRoaXMgY2Fz
ZSA/DQo+IA0KPiBUaGF0IGlzLCB0aGUgcGxhdGZvcm1fZGV2aWNlX3VucmVnaXN0ZXIoKSB3
aWxsIHRyaWdnZXIgdGhlIGNhbGwgdG8gdGhlDQo+IC5yZW1vdmUgY2FsbGJhY2sgdGhhdCBp
biB0dXJuIHdpbGwgY2FsbCB1bnJlZ2lzdGVyX2ZyYW1lYnVmZmVyKCkuDQo+IA0KPiBTaG91
bGRuJ3Qgd2UgYWx3YXlzIGhvbGQgdGhlIG11dGV4IHdoZW4gY2FsbGluZyBkb191bnJlZ2lz
dGVyX2ZyYW1lYnVmZmVyKCkgPw0KDQpEb2luZyB0aGUgaG90LXVucGx1ZyB3aWxsIGVuZCB1
cCBpbiB1bnJlZ2lzdGVyX2ZyYW1lYnVmZmVyKCksIGJ1dCB3ZSANCmFscmVhZHkgaG9sZCB0
aGUgbG9jayBmcm9tIHRoZSBkb19yZW1vdmVfY29uZmxpY3RpbmdfZnJhbWVidWZmZXIoKSBj
b2RlLg0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQoN
Ci0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNV
U0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0
MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNj
aMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------jbZfzBZvALXY47A0Gnk0rPzH--

--------------xPH0sPVAForQpIKm8KBQfGrp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHutVkFAwAAAAAACgkQlh/E3EQov+B4
Ng//appVyEC2IQ4pxPPadyR6m+EdPei4AbiGjEtu1VCf4w7XiftkiG7kgQHw5P0FWlaaOPdOKauP
Mtd2G2cLpNza2+h5d7cS5+89Zsc5HdRcL5hXk7REzlgPbiYJxxM5pGuGOI0NhMql97vL80SIZGTh
SxpMNtm67PcNiXZ0jZil9nlDliEARUHEMGF0tH5hISciQBs1inuTmqd5JICdtOi6CFnY/npgKAaY
HaIEBJKpBlAPlJRkpNmqo0Gi3mUB8gaCDVz7fr5yIr3jVcp3IEUb6TxNT0G/jlZ8xDMUIYRrkdvA
hIYDeybDRzDlRu0XS0fWNtP8LgFrzi3+twYG3W/dR9F5mmHv1ubWSF9yzDi+1SNlF20rDBo91bKq
vVsIIAlMAc4hDZXNUd9KqXv5CsuYW20ISVMivEtePFXNimfNfMg/dfJOLNEj+d7sbw+bXUHGDmje
T9hvAoJqob4SPEzUD/Yl2p7zDcxkBK+TAg8hn4kR4eJpRuOjB7PwjD9cIz5ijFleJ7lM2HFBBDwX
AXJOr9SCEgRdboJcL99IAA8qwHh0k1gPxTF1vCwfk8aZVHJAA1opc/gMQtoJbqHmDBo8Qtr2n9gU
9voOrRfzDheOW/ICoIOKdiQgC+hRy4NLVaXi0tH0VIzYSH7FTkZGwczUSH2wKCQcUcQUgEh99tBu
o+s=
=oIBd
-----END PGP SIGNATURE-----

--------------xPH0sPVAForQpIKm8KBQfGrp--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8ECC610D5D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJ1Jem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 05:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJ1Jej (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 05:34:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60881BE0;
        Fri, 28 Oct 2022 02:34:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1EE941F889;
        Fri, 28 Oct 2022 09:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666949675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IASvnouu8bXp1HLvl/aTvpzlma7fG6NsS/FM4LUv/5w=;
        b=aySnVG5tvRMm+fMHel5DomYNAQK5AUaL2bxuE4gw+jvzhO5Zj7HrPsETzroKV+vvKceh5/
        n+uoI7fgvyiuUDvWGJDZkyfrIUqJFC/6MObAvj+swWBdAeSN0EV2uAxl83hQRyquaai8Va
        9g5VhADfwcPYJlVmWi4xB65SzcTfYAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666949675;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IASvnouu8bXp1HLvl/aTvpzlma7fG6NsS/FM4LUv/5w=;
        b=uJg/8YiHXJ4sRpxPpmbIjbflpK9V96GigRIS6+AGF/Q9ZPG5gYgXQ7k6R0oM2Z7SOT29rl
        A/OxvCNkzz4fnpDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EBBB91377D;
        Fri, 28 Oct 2022 09:34:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uvhaOCqiW2OuHgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Oct 2022 09:34:34 +0000
Message-ID: <98ec2c54-cf99-6465-31a1-b63e3b4d021d@suse.de>
Date:   Fri, 28 Oct 2022 11:34:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Content-Language: en-US
To:     Pekka Paalanen <ppaalanen@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, Hector Martin <marcan@marcan.st>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        asahi@lists.linux.dev
References: <20221027135711.24425-1-marcan@marcan.st>
 <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
 <20221028113705.084502b6@eldfell>
 <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
 <20221028121744.2073d196@eldfell>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20221028121744.2073d196@eldfell>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0AxWpwoHyF0q7DYhX0rHPIRu"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0AxWpwoHyF0q7DYhX0rHPIRu
Content-Type: multipart/mixed; boundary="------------O1RsfhCMykoaZOWTfKA05bea";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Pekka Paalanen <ppaalanen@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Hector Martin <marcan@marcan.st>,
 Javier Martinez Canillas <javierm@redhat.com>, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, asahi@lists.linux.dev
Message-ID: <98ec2c54-cf99-6465-31a1-b63e3b4d021d@suse.de>
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
References: <20221027135711.24425-1-marcan@marcan.st>
 <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
 <20221028113705.084502b6@eldfell>
 <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
 <20221028121744.2073d196@eldfell>
In-Reply-To: <20221028121744.2073d196@eldfell>

--------------O1RsfhCMykoaZOWTfKA05bea
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjguMTAuMjIgdW0gMTE6MTcgc2NocmllYiBQZWtrYSBQYWFsYW5lbjoNCj4g
T24gRnJpLCAyOCBPY3QgMjAyMiAxMDo1Mzo0OSArMDIwMA0KPiBUaG9tYXMgWmltbWVybWFu
biA8dHppbW1lcm1hbm5Ac3VzZS5kZT4gd3JvdGU6DQo+IA0KPj4gSGkNCj4+DQo+PiBBbSAy
OC4xMC4yMiB1bSAxMDozNyBzY2hyaWViIFBla2thIFBhYWxhbmVuOg0KPj4+IE9uIEZyaSwg
MjggT2N0IDIwMjIgMTA6MDc6MjcgKzAyMDANCj4+PiBUaG9tYXMgWmltbWVybWFubiA8dHpp
bW1lcm1hbm5Ac3VzZS5kZT4gd3JvdGU6DQo+Pj4gICAgDQo+Pj4+IEhpDQo+Pj4+DQo+Pj4+
IEFtIDI3LjEwLjIyIHVtIDE1OjU3IHNjaHJpZWIgSGVjdG9yIE1hcnRpbjoNCj4+Pj4+IGRy
bV9mYl9idWlsZF9mb3VyY2NfbGlzdCgpIGN1cnJlbnRseSByZXR1cm5zIGFsbCBlbXVsYXRl
ZCBmb3JtYXRzDQo+Pj4+PiB1bmNvbmRpdGlvbmFsbHkgYXMgbG9uZyBhcyB0aGUgbmF0aXZl
IGZvcm1hdCBpcyBhbW9uZyB0aGVtLCBldmVuIHRob3VnaA0KPj4+Pj4gbm90IGFsbCBjb21i
aW5hdGlvbnMgaGF2ZSBjb252ZXJzaW9uIGhlbHBlcnMuIEFsdGhvdWdoIHRoZSBsaXN0IGlz
DQo+Pj4+PiBhcmd1YWJseSBwcm92aWRlZCB0byB1c2Vyc3BhY2UgaW4gcHJlY2VkZW5jZSBv
cmRlciwgdXNlcnNwYWNlIGNhbiBwaWNrDQo+Pj4+PiBzb21ldGhpbmcgb3V0LW9mLW9yZGVy
IChhbmQgdGh1cyBicmVhayB3aGVuIGl0IHNob3VsZG4ndCksIG9yIHNpbXBseQ0KPj4+Pj4g
b25seSBzdXBwb3J0IGEgZm9ybWF0IHRoYXQgaXMgdW5zdXBwb3J0ZWQgKGFuZCB0aHVzIHRo
aW5rIGl0IGNhbiB3b3JrLA0KPj4+Pj4gd2hpY2ggcmVzdWx0cyBpbiB0aGUgYXBwZWFyYW5j
ZSBvZiBhIGhhbmcgYXMgRkIgYmxpdHMgZmFpbCBsYXRlciBvbiwNCj4+Pj4+IGluc3RlYWQg
b2YgdGhlIGluaXRpYWxpemF0aW9uIGVycm9yIHlvdSdkIGV4cGVjdCBpbiB0aGlzIGNhc2Up
Lg0KPj4+Pj4NCj4+Pj4+IEFkZCBjaGVja3MgdG8gZmlsdGVyIHRoZSBsaXN0IG9mIGVtdWxh
dGVkIGZvcm1hdHMgdG8gb25seSB0aG9zZQ0KPj4+Pj4gc3VwcG9ydGVkIGZvciBjb252ZXJz
aW9uIHRvIHRoZSBuYXRpdmUgZm9ybWF0LiBUaGlzIHByZXN1bWVzIHRoYXQgdGhlcmUNCj4+
Pj4+IGlzIGEgc2luZ2xlIG5hdGl2ZSBmb3JtYXQgKG9ubHkgdGhlIGZpcnN0IGlzIGNoZWNr
ZWQsIGlmIHRoZXJlIGFyZQ0KPj4+Pj4gbXVsdGlwbGUpLiBSZWZhY3RvcmluZyB0aGlzIEFQ
SSB0byBkcm9wIHRoZSBuYXRpdmUgbGlzdCBvciBzdXBwb3J0IGl0DQo+Pj4+PiBwcm9wZXJs
eSAoYnkgcmV0dXJuaW5nIHRoZSBhcHByb3ByaWF0ZSBlbXVsYXRlZC0+bmF0aXZlIG1hcHBp
bmcgdGFibGUpDQo+Pj4+PiBpcyBsZWZ0IGZvciBhIGZ1dHVyZSBwYXRjaC4NCj4+Pj4+DQo+
Pj4+PiBUaGUgc2ltcGxlZHJtIGRyaXZlciBpcyBsZWZ0IGFzLWlzIHdpdGggYSBmdWxsIHRh
YmxlIG9mIGVtdWxhdGVkDQo+Pj4+PiBmb3JtYXRzLiBUaGlzIGtlZXBzIGFsbCBjdXJyZW50
bHkgd29ya2luZyBjb252ZXJzaW9ucyBhdmFpbGFibGUgYW5kDQo+Pj4+PiBkcm9wcyBhbGwg
dGhlIGJyb2tlbiBvbmVzIChpLmUuIHRoaXMgYSBzdHJpY3QgYnVnZml4IHBhdGNoLCBhZGRp
bmcgbm8NCj4+Pj4+IG5ldyBzdXBwb3J0ZWQgZm9ybWF0cyBub3IgcmVtb3ZpbmcgYW55IGFj
dHVhbGx5IHdvcmtpbmcgb25lcykuIEluIG9yZGVyDQo+Pj4+PiB0byBhdm9pZCBwcm9saWZl
cmF0aW9uIG9mIGVtdWxhdGVkIGZvcm1hdHMsIGZ1dHVyZSBkcml2ZXJzIHNob3VsZA0KPj4+
Pj4gYWR2ZXJ0aXNlIG9ubHkgWFJHQjg4ODggYXMgdGhlIHNvbGUgZW11bGF0ZWQgZm9ybWF0
IChzaW5jZSBzb21lDQo+Pj4+PiB1c2Vyc3BhY2UgYXNzdW1lcyBpdHMgcHJlc2VuY2UpLg0K
Pj4+Pj4NCj4+Pj4+IFRoaXMgZml4ZXMgYSByZWFsIHVzZXIgcmVncmVzc2lvbiB3aGVyZSB0
aGUgP1JHQjIxMDEwMTAgc3VwcG9ydCBjb21taXQNCj4+Pj4+IHN0YXJ0ZWQgYWR2ZXJ0aXNp
bmcgaXQgdW5jb25kaXRpb25hbGx5IHdoZXJlIG5vdCBzdXBwb3J0ZWQsIGFuZCBLV2luDQo+
Pj4+PiBkZWNpZGVkIHRvIHN0YXJ0IHRvIHVzZSBpdCBvdmVyIHRoZSBuYXRpdmUgZm9ybWF0
IGFuZCBicm9rZSwgYnV0IGFsc28NCj4+Pj4+IHRoZSBmaXhlcyB0aGUgc3B1cmlvdXMgUkdC
NTY1L1JHQjg4OCBmb3JtYXRzIHdoaWNoIGhhdmUgYmVlbiB3cm9uZ2x5DQo+Pj4+PiB1bmNv
bmRpdGlvbmFsbHkgYWR2ZXJ0aXNlZCBzaW5jZSB0aGUgZGF3biBvZiBzaW1wbGVkcm0uDQo+
Pj4+Pg0KPj4+Pj4gRml4ZXM6IDZlYTk2NmZjYTA4NCAoImRybS9zaW1wbGVkcm06IEFkZCBb
QVhdUkdCMjEwMTAxMCBmb3JtYXRzIikNCj4+Pj4+IEZpeGVzOiAxMWU4ZjVmZDIyM2IgKCJk
cm06IEFkZCBzaW1wbGVkcm0gZHJpdmVyIikNCj4+Pj4+IENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFy
Y2FuLnN0Pg0KPj4+Pg0KPj4+PiBSZXZpZXdlZC1ieTogVGhvbWFzIFppbW1lcm1hbm4gPHR6
aW1tZXJtYW5uQHN1c2UuZGU+DQo+Pj4+DQo+Pj4+IFRoYW5rcyBmb3IgeW91ciBwYXRjaC4g
SSBoYXZlIHZlcmlmaWVkIHRoYXQgdmlkZW89LXsxNiwyNH0gc3RpbGwgd29ya3MNCj4+Pj4g
d2l0aCBzaW1wbGVkcm0uDQo+Pj4+ICAgDQo+Pj4+PiAtLS0NCj4+Pj4+IEknbSBwcm9wb3Np
bmcgdGhpcyBhbHRlcm5hdGl2ZSBhcHByb2FjaCBhZnRlciBhIGhlYXRlZCBkaXNjdXNzaW9u
IG9uDQo+Pj4+PiBJUkMuIEknbSBvdXQgb2YgaWRlYXMsIGlmIHknYWxsIGRvbid0IGxpa2Ug
dGhpcyBvbmUgeW91IGNhbiBmaWd1cmUgaXQNCj4+Pj4+IG91dCBmb3IgeW91cnNldmVzIDot
KQ0KPj4+Pj4NCj4+Pj4+IENoYW5nZXMgc2luY2UgdjE6DQo+Pj4+PiBUaGlzIHYyIG1vdmVz
IGFsbCB0aGUgY2hhbmdlcyB0byB0aGUgaGVscGVyIChzbyB0aGV5IHdpbGwgYXBwbHkgdG8N
Cj4+Pj4+IHRoZSB1cGNvbWluZyBvZmRybSwgdGhvdWdoIG9mZHJtIGFsc28gbmVlZHMgdG8g
YmUgZml4ZWQgdG8gdHJpbSBpdHMNCj4+Pj4+IGZvcm1hdCB0YWJsZSB0byBvbmx5IGZvcm1h
dHMgdGhhdCBzaG91bGQgYmUgZW11bGF0ZWQsIHByb2JhYmx5IG9ubHkNCj4+Pj4+IFhSR0I4
ODg4LCB0byBhdm9pZCBmdXJ0aGVyIHByb2xpZmVyYXRpbmcgdGhlIHVzZSBvZiBjb252ZXJz
aW9ucyksDQo+Pj4+PiBhbmQgYXZvaWRzIHRvdWNoaW5nIG1vcmUgdGhhbiBvbmUgZmlsZS4g
VGhlIEFQSSBzdGlsbCBuZWVkcyBjbGVhbnVwDQo+Pj4+PiBhcyBtZW50aW9uZWQgKHN1cHBv
cnRpbmcgbW9yZSB0aGFuIG9uZSBuYXRpdmUgZm9ybWF0IGlzIGZ1bmRhbWVudGFsbHkNCj4+
Pj4+IGJyb2tlbiwgc2luY2UgdGhlIGhlbHBlciB3b3VsZCBuZWVkIHRvIHRlbGwgdGhlIGRy
aXZlciAqd2hhdCogbmF0aXZlDQo+Pj4+PiBmb3JtYXQgdG8gdXNlIGZvciAqZWFjaCogZW11
bGF0ZWQgZm9ybWF0IHNvbWVob3cpLCBidXQgYWxsIGN1cnJlbnQgYW5kDQo+Pj4+PiBwbGFu
bmVkIHVzZXJzIG9ubHkgcGFzcyBpbiBvbmUgbmF0aXZlIGZvcm1hdCwgc28gdGhpcyBjYW4g
KGFuZCBzaG91bGQpDQo+Pj4+PiBiZSBmaXhlZCBsYXRlci4NCj4+Pj4+DQo+Pj4+PiBBc2lk
ZTogQWZ0ZXIgb3RoZXIgSVJDIGRpc2N1c3Npb24sIEknbSB0ZXN0aW5nIG51a2luZyB0aGUN
Cj4+Pj4+IFhSR0IyMTAxMDEwIDwtPiBBUkdCMjEwMTAxMCBhZHZlcnRpc2VtZW50ICh3aGlj
aCBkb2VzIG5vdCBpbnZvbHZlDQo+Pj4+PiBjb252ZXJzaW9uKSBieSByZW1vdmluZyB0aG9z
ZSBlbnRyaWVzIGZyb20gc2ltcGxlZHJtIGluIHRoZSBBc2FoaSBMaW51eA0KPj4+Pj4gZG93
bnN0cmVhbSB0cmVlLiBBcyBmYXIgYXMgSSdtIGNvbmNlcm5lZCwgaXQgY2FuIGJlIHJlbW92
ZWQgaWYgbm9ib2R5DQo+Pj4+PiBjb21wbGFpbnMgKGJ5IHJlbW92aW5nIHRob3NlIGVudHJp
ZXMgZnJvbSB0aGUgc2ltcGxlZHJtIGFycmF5KSwgaWYNCj4+Pj4+IG1haW50YWluZXJzIGFy
ZSBnZW5lcmFsbHkgb2theSB3aXRoIHJlbW92aW5nIGFkdmVydGlzZWQgZm9ybWF0cyBhdCBh
bGwuDQo+Pj4+PiBJZiBzbywgdGhlcmUgbWlnaHQgYmUgb3RoZXIgb3Bwb3J0dW5pdGllcyBm
b3IgZnVydGhlciB0cmltbWluZyB0aGUgbGlzdA0KPj4+Pj4gbm9uLW5hdGl2ZSBmb3JtYXRz
IGFkdmVydGlzZWQgdG8gdXNlcnNwYWNlLg0KPj4+Pg0KPj4+PiBJTUhPIGFsbCBvZiB0aGUg
ZXh0cmEgQSBmb3JtYXRzIGNhbiBpbW1lZGlhdGVseSBnby4gV2UgaGF2ZSBwbGVudHkgb2YN
Cj4+Pj4gc2ltcGxlIGRyaXZlcnMgdGhhdCBvbmx5IGV4cG9ydCBYUkdCODg4OCBwbHVzIHNv
bWV0aW1lcyBhIGZldyBvdGhlcg0KPj4+PiBub24tQSBmb3JtYXRzLiBJZiBhbnl0aGluZyBp
biB1c2Vyc3BhY2UgaGFkIGEgaGFyZCBkZXBlbmRlbmN5IG9uIGFuIEENCj4+Pj4gZm9ybWF0
LCB3ZSdkIHByb2JhYmx5IGhlYXJkIGFib3V0IGl0Lg0KPj4+Pg0KPj4+PiBJbiB5ZXN0ZXJk
YXkncyBkaXNjdXNzaW9uIG9uIElSQywgaXQgd2FzIHNhaWQgdGhhdCBzZXZlcmFsIGRldmlj
ZXMNCj4+Pj4gYWR2ZXJ0aXNlIEFSR0IgZnJhbWVidWZmZXJzIHdoZW4gdGhlIGhhcmR3YXJl
IGFjdHVhbGx5IHVzZXMgWFJHQj8gSXMNCj4+Pj4gdGhlcmUgaGFyZHdhcmUgdGhhdCBzdXBw
b3J0cyB0cmFuc3BhcmVudCBwcmltYXJ5IHBsYW5lcz8NCj4+Pg0KPj4+IEknbSBmYWlybHkg
c3VyZSBzdWNoIGhhcmR3YXJlIGRvZXMgZXhpc3QsIGJ1dCBJIGRvbid0IGtub3cgaWYgaXQn
cyB0aGUNCj4+PiBkcml2ZXJzIGluIHF1ZXN0aW9uIGhlcmUuDQo+Pj4NCj4+PiBJdCdzIG5v
dCB1bmNvbW1vbiB0byBoYXZlIGV4dHJhIGhhcmR3YXJlIHBsYW5lcyBiZWxvdyB0aGUgcHJp
bWFyeQ0KPj4+IHBsYW5lLCBhbmQgdGhlbiB1c2UgYWxwaGEgb24gcHJpbWFyeSBwbGFuZSB0
byBjdXQgYSBob2xlIHRvIHNlZSB0aHJvdWdoDQo+Pj4gdG8gdGhlICJ1bmRlcmxheSIgcGxh
bmUuIFRoaXMgaXMgYSBnb29kIHNldHVwIGZvciB2aWRlbyBwbGF5YmFjaywgd2hlcmUNCj4+
PiB0aGUgdmlkZW8gaXMgb24gdGhlIHVuZGVybGF5LCBhbmQgKGEgc2xvdyBHUFUgb3IgQ1BV
IHJlbmRlcnMpIHRoZQ0KPj4+IHN1YnRpdGxlcyBhbmQgVUkgb24gdGhlIHByaW1hcnkgcGxh
bmUuDQo+Pj4NCj4+PiBJJ3ZlIGhlYXJkIHRoYXQgc29tZSBoYXJkd2FyZSBhbHNvIGhhcyBh
IHNlcGFyYXRlIGJhY2tncm91bmQgY29sb3INCj4+PiAicGxhbmUiIGJlbG93IGFsbCBoYXJk
d2FyZSBwbGFuZXMsIGJ1dCBJIGZvcmdldCBpZiB1cHN0cmVhbSBLTVMgZXhwb3Nlcw0KPj4+
IHRoYXQuDQo+Pg0KPj4gVGhhdCdzIGFsc28gd2hhdCBJIGhlYXJkIG9mLiBJdCdzIG5vdCBz
b21ldGhpbmcgd2UgY2FuIGNvbnRyb2wgd2l0aGluDQo+PiBzaW1wbGVkcm0gb3IgYW55IG90
aGVyIGdlbmVyaWMgZHJpdmVyLg0KPj4NCj4+IEknbSB3b3JyaWVkIHRoYXQgd2UgYWR2ZXJ0
aXNlIEFSR0IgdG8gdXNlcnNwYWNlIHdoZW4gdGhlIHNjYW5vdXQgYnVmZmVyDQo+PiBpcyBh
Y3R1YWxseSBYUkdCLg0KPiANCj4gV2hhdCB3b3VsZCBiZSB0aGUgcHJvYmxlbSB3aXRoIHRo
YXQ/DQo+IHNpbXBsZWRybSB3b3VsZCBuZXZlciBleHBvc2UgbW9yZSB0aGFuIG9ubHkgdGhl
IHByaW1hcnkgcGxhbmUsIHJpZ2h0Pw0KPiBOb3QgZXZlbiBiYWNrZ3JvdW5kIGNvbG9yLg0K
DQpSaWdodC4gTXkgY29uY2VybnMgYXJlIHRoZSBwcm9saWZlcmF0aW9uIG9mIEEgZm9ybWF0
LCBhbmQgdXNlcnNwYWNlIHRoYXQgDQp0cmllcyBzb21ldGhpbmcgZmFuY3kgd2l0aCB0aGF0
IGluY29ycmVjdCBBIGJ5dGUsIHdoaWNoIGxlYWRzIHRvIGRpc3BsYXkgDQphcnRpZmFjdHMu
IExpa2UgZmFkaW5nIGluL291dCB0aGUgY29udGVudCBvZiB0aGUgcHJpbWFyeSBwbGFuZS4N
Cg0KPiANCj4gVGhhdCBtZWFucyB0aGF0IHVzZXJzcGFjZSBjYW5ub3QgdXNlIHRoZSBhbHBo
YSBjaGFubmVsIGZvciBhbnl0aGluZw0KPiBhbnl3YXksIHRoZXJlIGlzIG5vdGhpbmcgdG8g
c2hvdyB0aHJvdWdoLiBPciBhcmUgeW91IHRoaW5raW5nIGFib3V0DQo+IHRyYW5zcGFyZW50
IG1vbml0b3JzPw0KDQpJIGNhbid0IHRlbGwgaWYgeW91J3JlIHNlcmlvdXMsIGJ1dCBJJ20g
bm90IGdvaW5nIHRvIHJ1bGUgdGhpcyBvdXQuIDspDQoNCj4gDQo+IE9mIGNvdXJzZSwgaXQg
d291bGQgYmUgYmVzdCB0byBhZHZlcnRpc2Ugc3RyaWN0bHkgd2hhdCB0aGUgaGFyZHdhcmUN
Cj4gZG9lcy4NCj4gDQo+PiBCdXQgaWYgd2UgYWR2ZXJ0aXNlIFhSR0IgYW5kIHRoZSBzY2Fu
b3V0IGJ1ZmZlciBpcw0KPj4gcmVhbGx5IEFSR0IsIGFueSBnYXJiYWdlIGluIHRoZSBYIGZp
bGxlciBieXRlIHdvdWxkIGludGVyZmVyZS4NCj4gDQo+IFllcywgcHJvYmFibHkuIEdhcmJh
Z2UgYWxwaGEgYmVpbmcgdXNlZCB3b3VsZCBub3QgaHVydCBpZiBhKSB1c2Vyc3BhY2UNCj4g
dGhpbmtzIGl0J3MgcmVuZGVyaW5nIFhSR0Igd2hpY2ggbWVhbnMgdGhhdCBSR0IgdmFsdWVz
IGFyZSBhbGwgb3BhcXVlLA0KPiBhbmQgYikgdGhlIGhhcmR3YXJlIGJsZW5kaW5nIG1vZGUg
aXMgcHJlLW11bHRpcGxpZWQtYWxwaGEsIGFuZCBjKQ0KPiB3aGF0ZXZlciBpcyBiZWhpbmQg
dGhlIHByaW1hcnkgcGxhbmUgaXMgYWxsIHplcm9lcy4NCg0KVG8gbXkga25vd2xlZGdlLCB0
aGVyZSdzIG5vIHJlbGlhYmxlIHdheSBvZiBkZXRlY3RpbmcgYW55IG9mIHRoaXMuIA0KRXNw
ZWNpYWxseSBub3QgZnJvbSB3aXRoaW4gdGhlIGhhcmR3YXJlLWFnbm9zdGljIGNvZGUuDQoN
CkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gDQo+PiBJZiB3ZSBoYXZlIGEgbmF0aXZlIEFS
R0Igc2Nhbm91dCBidWZmZXIsIHdlIGNvdWxkIGFkdmVydGlzZSBYUkdCIHRvDQo+PiB1c2Vy
c3BhY2UgYW5kIHNldCB0aGUgZmlsbGVyIGJ5dGUgdW5jb25kaXRpb25hbGx5IGR1cmluZyB0
aGUgcGFnZWZsaXANCj4+IHN0ZXAuIFRoYXQgc2hvdWxkIGJlIHNhZmUgb24gYWxsIGhhcmR3
YXJlLg0KPiANCj4gQ29ycmVjdC4gU2luY2UgeW91IHNheSAiZmlsbGVyIGJ5dGUiLCBJIGFz
c3VtZSB5b3UgYXJlIHJlZmVycmluZyB0bw0KPiBYUkdCODg4OCBvbmx5LiBUaGF0J3MgZ29v
ZC4gT3RoZXIgZm9ybWF0cyBzaG91bGQgbm90IGJlIGVtdWxhdGVkLg0KPiANCj4gDQo+IFRo
YW5rcywNCj4gcHENCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVy
IERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhm
ZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7D
vHJuYmVyZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------O1RsfhCMykoaZOWTfKA05bea--

--------------0AxWpwoHyF0q7DYhX0rHPIRu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNboioFAwAAAAAACgkQlh/E3EQov+BA
tA/9EUFuykEMue+kPLx2pPgiQC1BOuJhnVIaxRpzj5XbyeFr8HU+JG87lIcGD32WFs4wSMKCGn5X
IfwdMq36pk3YODtycRpWuNgeJVy9+5wsSqRcE79lOzhl0BUnhwk0pM4hIHBmKzLlZ3PFQ1u+UfMy
biGo7ssBaM9zJUSQwyeY9S8CWM1E/bcibrJiR9CKRACIxRoFhBlSvETIRk1Z/LdqMhLZiXNfAtPd
4YHq+n29PEesmuNpRtg91oBbnF4BPCxgj/mo38QAii4OryW3PdC6o2nDjSyElJOd6GN68RVIzvlL
SPPDXWDvIfpkEO00VezWYzLOb+vYtnW7fpv9iX8rU8L5Kae/xvPwp9wAbeiuimgZEOXQfr7wSYo/
R02uDZc2gdcVJgfVs4yyokk/c4EGQbnIY01CFtF8hDIUH0nXcH319NvDfFTLctDbGPX5XWv0Usht
0O+K+idark+ApBZS08+LWnWysFDva2zF8nPu55021xXEm3wN/i9Wh1pn81sigUShtja8TWE2M9CH
7mJT4UfL3SnAWwK42J2KR1mri7xBwzp2A3vQV4S8Ofk7oOk/mnmRkTI1LMfhn1lKhwMZmgqNprpF
K3BUiomf7Wf8z7gtGTC0aAYDegoQASHT/YHG4pJfq7FHyIo5tVaaaWO2RfukjChZbZxVexu9A8Fq
jB4=
=aV/h
-----END PGP SIGNATURE-----

--------------0AxWpwoHyF0q7DYhX0rHPIRu--

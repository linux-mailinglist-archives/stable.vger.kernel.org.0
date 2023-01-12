Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB46666BDD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 08:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbjALHzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 02:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbjALHzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 02:55:50 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6644318C
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 23:55:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 27B9C3F56B;
        Thu, 12 Jan 2023 07:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673510147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36KAVXTMN+Iyaf31MxrkPWKpu1Ahbk925rp132O88m0=;
        b=udvnrcsXb+elsr5ogExahXdz+JkEpCjx394jdr/fEV3+9SfwBmAfcFf8m1p3+YRFyg4nB1
        9mGRDJByPGJ7ZagQAVt3ftC1U9AFdCKdvwTkTOk+MB92eoriQQxORKaOlEAC+/2uAfSlch
        xzzD207ww6rR2vCAJOTxGDyRJGQ0UtA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673510147;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36KAVXTMN+Iyaf31MxrkPWKpu1Ahbk925rp132O88m0=;
        b=NxEktvDj3fLWnKCZpaDQdZ6T8KX70w5uLUbDpI/Ed6OlR//9kY8JX52ggwXsdt8SL3Thmw
        G3WKCpFQNq52p5CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4A03134B3;
        Thu, 12 Jan 2023 07:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BnDuNgK9v2MCYQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 12 Jan 2023 07:55:46 +0000
Message-ID: <7b00e592-345f-4dd5-3452-7f6f70fc608a@suse.de>
Date:   Thu, 12 Jan 2023 08:55:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
Content-Language: en-US
To:     Aaron Plattner <aplattner@nvidia.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
 <fb72e067-3f5f-1bac-dc9b-3abd9d7739a2@redhat.com>
 <ad725823-f4ef-904f-c04c-90a6aad43323@nvidia.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <ad725823-f4ef-904f-c04c-90a6aad43323@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hpfABm4PvLrLVHf2a930S203"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hpfABm4PvLrLVHf2a930S203
Content-Type: multipart/mixed; boundary="------------WZQSsnqF3oUrj5F9fnzUrEPy";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Aaron Plattner <aplattner@nvidia.com>,
 Javier Martinez Canillas <javierm@redhat.com>,
 Daniel Vetter <daniel.vetter@ffwll.ch>,
 DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 LKML <linux-kernel@vger.kernel.org>, Daniel Vetter
 <daniel.vetter@intel.com>, Helge Deller <deller@gmx.de>,
 Sam Ravnborg <sam@ravnborg.org>, Alex Deucher <alexander.deucher@amd.com>,
 stable@vger.kernel.org
Message-ID: <7b00e592-345f-4dd5-3452-7f6f70fc608a@suse.de>
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
 <fb72e067-3f5f-1bac-dc9b-3abd9d7739a2@redhat.com>
 <ad725823-f4ef-904f-c04c-90a6aad43323@nvidia.com>
In-Reply-To: <ad725823-f4ef-904f-c04c-90a6aad43323@nvidia.com>

--------------WZQSsnqF3oUrj5F9fnzUrEPy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTEuMDEuMjMgdW0gMjA6MjEgc2NocmllYiBBYXJvbiBQbGF0dG5lcjoNCj4g
T24gMS8xMS8yMyA4OjU44oCvQU0sIEphdmllciBNYXJ0aW5leiBDYW5pbGxhcyB3cm90ZToN
Cj4+IEhlbGxvIERhbmllbCwNCj4+DQo+PiBPbiAxLzExLzIzIDE2OjQxLCBEYW5pZWwgVmV0
dGVyIHdyb3RlOg0KPj4+IFRoaXMgZml4ZXMgYSByZWdyZXNzaW9uIGludHJvZHVjZWQgYnkg
ZWU3YTY5YWEzOGQ4ICgiZmJkZXY6IERpc2FibGUNCj4+PiBzeXNmYiBkZXZpY2UgcmVnaXN0
cmF0aW9uIHdoZW4gcmVtb3ZpbmcgY29uZmxpY3RpbmcgRkJzIiksIHdoZXJlIHdlDQo+Pj4g
cmVtb3ZlIHRoZSBzeXNmYiB3aGVuIGxvYWRpbmcgYSBkcml2ZXIgZm9yIGFuIHVucmVsYXRl
ZCBwY2kgZGV2aWNlLA0KPj4+IHJlc3VsdGluZyBpbiB0aGUgdXNlciBsb29zaW5nIHRoZWly
IGVmaWZiIGNvbnNvbGUgb3Igc2ltaWxhci4NCj4+Pg0KPj4+IE5vdGUgdGhhdCBpbiBwcmFj
dGljZSB0aGlzIG9ubHkgaXMgYSBwcm9ibGVtIHdpdGggdGhlIG52aWRpYSBibG9iLA0KPj4+
IGJlY2F1c2UgdGhhdCdzIHRoZSBvbmx5IGdwdSBkcml2ZXIgcGVvcGxlIG1pZ2h0IGluc3Rh
bGwgd2hpY2ggZG9lcyBub3QNCj4+PiBjb21lIHdpdGggYW4gZmJkZXYgZHJpdmVyIG9mIGl0
J3Mgb3duLiBGb3IgZXZlcnlvbmUgZWxzZSB0aGUgcmVhbCBncHUNCj4+PiBkcml2ZXIgd2ls
bCByZXN0b3IgYSB3b3JraW5nIGNvbnNvbGUuDQo+Pg0KPj4gcmVzdG9yZQ0KPj4NCj4+Pg0K
Pj4+IEFsc28gbm90ZSB0aGF0IGluIHRoZSByZWZlcmVuY2VkIGJ1ZyB0aGVyZSdzIGNvbmZ1
c2lvbiB0aGF0IHRoaXMgc2FtZQ0KPj4+IGJ1ZyBhbHNvIGhhcHBlbnMgb24gYW1kZ3B1LiBC
dXQgdGhhdCB3YXMganVzdCBhbm90aGVyIGFtZGdwdSBzcGVjaWZpYw0KPj4+IHJlZ3Jlc3Np
b24sIHdoaWNoIGp1c3QgaGFwcGVuZWQgdG8gaGFwcGVuIGF0IHJvdWdobHkgdGhlIHNhbWUg
dGltZSBhbmQNCj4+PiB3aXRoIHRoZSBzYW1lIHVzZXItb2JzZXJ2YWJsZSBzeW1wdG9ucy4g
VGhhdCBidWcgaXMgZml4ZWQgbm93LCBzZWUNCj4+DQo+PiBzeW1wdG9tcw0KPj4NCj4+PiBo
dHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjMzMSNjMTUN
Cj4+Pg0KPj4+IEZvciB0aGUgYWJvdmUgcmVhc29ucyB0aGUgY2M6IHN0YWJsZSBpcyBqdXN0
IG5vdGlvbmFsbHksIHRoaXMgcGF0Y2gNCj4+PiB3aWxsIG5lZWQgYSBiYWNrcG9ydCBhbmQg
dGhhdCdzIHVwIHRvIG52aWRpYSBpZiB0aGV5IGNhcmUgZW5vdWdoLg0KPj4+DQo+Pg0KPj4g
TWF5YmUgYWRkaW5nIGEgRml4ZXM6IGVlN2E2OWFhMzhkOCB0YWcgaGVyZSB0b28gPw0KPj4N
Cj4+PiBSZWZlcmVuY2VzOiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcu
Y2dpP2lkPTIxNjMwMyNjMjgNCj4+PiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgVmV0dGVyIDxk
YW5pZWwudmV0dGVyQGludGVsLmNvbT4NCj4+PiBDYzogQWFyb24gUGxhdHRuZXIgPGFwbGF0
dG5lckBudmlkaWEuY29tPg0KPj4+IENjOiBKYXZpZXIgTWFydGluZXogQ2FuaWxsYXMgPGph
dmllcm1AcmVkaGF0LmNvbT4NCj4+PiBDYzogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJt
YW5uQHN1c2UuZGU+DQo+Pj4gQ2M6IEhlbGdlIERlbGxlciA8ZGVsbGVyQGdteC5kZT4NCj4+
PiBDYzogU2FtIFJhdm5ib3JnIDxzYW1AcmF2bmJvcmcub3JnPg0KPj4+IENjOiBBbGV4IERl
dWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+Pj4gQ2M6IDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPiAjIHY1LjE5KyAoaWYgc29tZW9uZSBlbHNlIGRvZXMgdGhlIA0KPj4+
IGJhY2twb3J0KQ0KPj4+IC0tLQ0KPj4+IMKgIGRyaXZlcnMvdmlkZW8vYXBlcnR1cmUuYyB8
IDcgKysrKy0tLQ0KPj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aWRlby9hcGVy
dHVyZS5jIGIvZHJpdmVycy92aWRlby9hcGVydHVyZS5jDQo+Pj4gaW5kZXggYmE1NjU1MTU0
ODBkLi5hMTgyMWQzNjliYjEgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy92aWRlby9hcGVy
dHVyZS5jDQo+Pj4gKysrIGIvZHJpdmVycy92aWRlby9hcGVydHVyZS5jDQo+Pj4gQEAgLTMy
MSwxNSArMzIxLDE2IEBAIGludCANCj4+PiBhcGVydHVyZV9yZW1vdmVfY29uZmxpY3Rpbmdf
cGNpX2RldmljZXMoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IA0KPj4+IGNoYXIgKm5h
DQo+Pj4gwqDCoMKgwqDCoCBwcmltYXJ5ID0gcGRldiA9PSB2Z2FfZGVmYXVsdF9kZXZpY2Uo
KTsNCj4+PiArwqDCoMKgIGlmIChwcmltYXJ5KQ0KPj4+ICvCoMKgwqDCoMKgwqDCoCBzeXNm
Yl9kaXNhYmxlKCk7DQo+Pj4gKw0KPj4+IMKgwqDCoMKgwqAgZm9yIChiYXIgPSAwOyBiYXIg
PCBQQ0lfU1REX05VTV9CQVJTOyArK2Jhcikgew0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoIShwY2lfcmVzb3VyY2VfZmxhZ3MocGRldiwgYmFyKSAmIElPUkVTT1VSQ0VfTUVNKSkN
Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsNCj4+PiDCoMKgwqDC
oMKgwqDCoMKgwqAgYmFzZSA9IHBjaV9yZXNvdXJjZV9zdGFydChwZGV2LCBiYXIpOw0KPj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCBzaXplID0gcGNpX3Jlc291cmNlX2xlbihwZGV2LCBiYXIp
Ow0KPj4+IC3CoMKgwqDCoMKgwqDCoCByZXQgPSBhcGVydHVyZV9yZW1vdmVfY29uZmxpY3Rp
bmdfZGV2aWNlcyhiYXNlLCBzaXplLCBuYW1lKTsNCj4+PiAtwqDCoMKgwqDCoMKgwqAgaWYg
KHJldCkNCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4+ICvC
oMKgwqDCoMKgwqDCoCBhcGVydHVyZV9kZXRhY2hfZGV2aWNlcyhiYXNlLCBzaXplKTsNCj4+
DQo+PiBNYXliZSBtZW50aW9uIGluIHRoZSBjb21taXQgbWVzc2FnZSB0aGF0IHlvdSBhcmUg
ZG9pbmcgdGhpcyBjaGFuZ2UsIA0KPj4gc29tZXRoaW5nIGxpa2U6DQo+Pg0KPj4gIkluc3Rl
YWQgb2YgY2FsbGluZyBhcGVydHVyZV9yZW1vdmVfY29uZmxpY3RpbmdfZGV2aWNlcygpIHRv
IHJlbW92ZSANCj4+IHRoZSBjb25mbGljdGluZw0KPj4gZGV2aWNlcywganVzdCBjYWxsIHRv
IGFwZXJ0dXJlX2RldGFjaF9kZXZpY2VzKCkgdG8gZGV0YWNoIHRoZSBkZXZpY2UgDQo+PiB0
aGF0IG1hdGNoZXMNCj4+IHRoZSBzYW1lIFBDSSBCQVIgLyBhcGVydHVyZSByYW5nZS4gU2lu
Y2UgdGhlIGZvcm1lciBpcyBqdXN0IGEgd3JhcHBlciANCj4+IG9mIHRoZSBsYXR0ZXINCj4+
IHBsdXMgYSBzeXNmYl9kaXNhYmxlKCkgY2FsbCwgYW5kIG5vdyB0aGF0J3MgZG9uZSBpbiB0
aGlzIGZ1bmN0aW9uIGJ1dCANCj4+IG9ubHkgZm9yIHRoZQ0KPj4gcHJpbWFyeSBkZXZpY2Vz
Ig0KPj4NCj4+IFBhdGNoIGxvb2tzIGdvb2QgdG8gbWU6DQo+Pg0KPj4gUmV2aWV3ZWQtYnk6
IEphdmllciBNYXJ0aW5leiBDYW5pbGxhcyA8amF2aWVybUByZWRoYXQuY29tPg0KPiANCj4g
VGhhbmtzIERhbmllbCBhbmQgSmF2aWVyIQ0KPiANCj4gSSB3YXNuJ3QgYWJsZSB0byByZXBy
b2R1Y2UgdGhlIG9yaWdpbmFsIHByb2JsZW0gb24gbXkgaHlicmlkIGxhcHRvcCANCj4gc2lu
Y2UgaXQgcmVmdXNlcyB0byBib290IHdpdGggdGhlIGNvbnNvbGUgb24gYW4gZXh0ZXJuYWwg
ZGlzcGxheSwgYnV0IEkgDQo+IHdhcyBhYmxlIHRvIHJlcHJvZHVjZSBpdCBieSBzd2l0Y2hp
bmcgdGhlIGNvbmZpZ3VyYXRpb24gYXJvdW5kOiBib290aW5nIA0KPiB3aXRoIGk5MTUubW9k
ZXNldD0wIGFuZCB3aXRoIGFuIGV4cGVyaW1lbnRhbCB2ZXJzaW9uIG9mIG52aWRpYS1kcm0g
dGhhdCANCj4gcmVnaXN0ZXJzIGEgZnJhbWVidWZmZXIgY29uc29sZS4gSSB2ZXJpZmllZCB0
aGF0IGxvYWRpbmcgbnZpZGlhLWRybSANCg0KVGhhbmsgeW91IGZvciB0ZXN0aW5nLg0KDQpP
bmUgdGhpbmcgSSdkIGxpa2UgdG8gbm90ZSBpcyB0aGF0IHVzaW5nIERSTSdzIGZiZGV2IGVt
dWxhdGlvbiBpcyB0aGUgDQpjb3JyZWN0IHdheSB0byBzdXBwb3J0IGEgY29uc29sZS4gTnZp
ZGlhLWRybSdzIGN1cnJlbnQgYXBwcm9hY2ggb2YgDQp1dGlsaXppbmcgZWZpZmIgaXMgZnJh
Z2lsZSBhbmQgcmVxdWlyZXMgd29ya2Fyb3VuZHMgZnJvbSBkaXN0cmlidXRpb25zIA0KKGF0
IGxlYXN0IGhlcmUgYXQgU1VTRSkuIFN0ZXBzIHRvd2FyZHMgZmJkZXYgZW11bGF0aW9uIGFy
ZSBtdWNoIGFwcHJlY2lhdGVkLg0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQo+IGJyZWFr
cyB0aGUgZWZpLWZpcm13YXJlIGZyYW1lYnVmZmVyIG9uIEludGVsIG9uIEFyY2gncyANCj4g
bGludXgtNi4xLjQtYXJjaDEtMSBrZXJuZWwgYW5kIHRoYXQgYXBwbHlpbmcgdGhpcyBwYXRj
aCBzZXJpZXMgZml4ZXMgaXQuIFNvDQo+IA0KPiBUZXN0ZWQtYnk6IEFhcm9uIFBsYXR0bmVy
IDxhcGxhdHRuZXJAbnZpZGlhLmNvbT4NCj4gDQo+IEZXSVcsIHRoZSBidWcgb3VnaHQgdG8g
YmUgcmVwcm9kdWNpYmxlIHdpdGggaTkxNS5tb2Rlc2V0PTAgKyBhbnkgb3RoZXIgDQo+IGRy
bSBkcml2ZXIgdGhhdCByZWdpc3RlcnMgYSBmcmFtZWJ1ZmZlci4NCj4gDQo+IC0tIEFhcm9u
DQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXIN
ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwg
OTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpH
ZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------WZQSsnqF3oUrj5F9fnzUrEPy--

--------------hpfABm4PvLrLVHf2a930S203
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmO/vQIFAwAAAAAACgkQlh/E3EQov+BF
yRAAyZIZZrGUZMumbhM7yvcSZBTwlN2hHSJX5KOu7bd/QVZSoqsL5Ml3pDmIUftE8VZUdElxwp0L
5+8mloj5nMYSRaLQH1oPn3pgwXFH25I6QwB1+l2idtrDllwhlDWt8uKXJhOCz3KCMAXwS3nO7+QN
iwfJbT/CMYGNSheNpRmygoaZi6PMqsxCK1sAX1Qds9q6bDP0ClDCe18tzThlwcEZovDnXNqFfW4n
rx4UV8ayNTFAuKQidXs8MgDUhdg84p5f3O1LyVhTKwX4kMTp72jCceDOFwzX3sxGedcisF98NzLA
0uUL1HIW5iGNNcXAyVerqxbaLZXxWnNFPfd0wW6+MYerqCrPhlGdOota8xhZkxYtrz6d+YaFwWQi
QwSjvSqZkWE7PcsUwbVboh5ol+hzuV46GTx+jxDOCkMpWJaRqPeZOA+yJTp9npWQBKNH/SR/d/V4
IyngDL+ZwndO/9NJTAe/8WqV+t6CmPdSiBlf8xusuuevZtykrUcgPOF/DiYvWpivnee5gQMU8MpP
xNIRZl0CG9WccJGkjBKUXoWR8ANpssW+bVldhlSXfmoTTdtJtZXSj4kcN4pIbCoOa+h3D25Oqxz0
rVUPHgKkl8gx5nhqswHUR3gx7JfPk604HxGGZvVc9LIKxSZLpHYyL5zkUekN4PH2XoJEa3YhOd/+
xs0=
=E5TE
-----END PGP SIGNATURE-----

--------------hpfABm4PvLrLVHf2a930S203--

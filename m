Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602984F47DB
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbiDEVWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573224AbiDES0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 14:26:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F6B25C2;
        Tue,  5 Apr 2022 11:24:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B8DF0210DD;
        Tue,  5 Apr 2022 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649183045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/UaHUhXP/6OW2Mqxi6B6bcE72E7O2P+vDx0bpq6fCD0=;
        b=pqhYullHKEZcRzyV9KDNZfK7jW52sxGHcAi/2KZx1QxTJ2kUfQY0A0Z8M0BlIkkf8AzhQu
        yrROFfern0yovw5wEgDENCRgMeNMg/AthADMX4Gx3FkxZMh33CYHzJeuefCRYSDG/NmfY9
        7WtenkFQpk+CArUN04/RknR8kCVeL3U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649183045;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/UaHUhXP/6OW2Mqxi6B6bcE72E7O2P+vDx0bpq6fCD0=;
        b=qMab4mkpwoCE/8ubZ5H4Tl7M7e8MXgDl6Bp19coISrPiFU9A2NVA+XffwaTdaCPVkk2u9H
        jufOqT77k9cld3Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D1F3913522;
        Tue,  5 Apr 2022 18:24:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KrjWMUSJTGK1PQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 05 Apr 2022 18:24:04 +0000
Message-ID: <47e867e4-0a6f-1352-37a7-b8b04ec137ee@suse.de>
Date:   Tue, 5 Apr 2022 20:24:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] fbdev: Fix unregistering of framebuffers without device
Content-Language: en-US
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     deller@gmx.de, sudipm.mukherjee@gmail.com, sam@ravnborg.org,
        javierm@redhat.com, zackr@vmware.com, hdegoede@redhat.com,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Guenter Roeck <linux@roeck-us.net>
References: <20220404194402.29974-1-tzimmermann@suse.de>
 <YkwFfusqI2Nuu7Dn@phenom.ffwll.local>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <YkwFfusqI2Nuu7Dn@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------f3b4P60Lu6y2LkFjpCd2Q0Hs"
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------f3b4P60Lu6y2LkFjpCd2Q0Hs
Content-Type: multipart/mixed; boundary="------------DzAeDAUN9vZwABa46Ebx90t5";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: deller@gmx.de, sudipm.mukherjee@gmail.com, sam@ravnborg.org,
 javierm@redhat.com, zackr@vmware.com, hdegoede@redhat.com,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
 Zheyu Ma <zheyuma97@gmail.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
 Zhen Lei <thunder.leizhen@huawei.com>, Matthew Wilcox <willy@infradead.org>,
 Alex Deucher <alexander.deucher@amd.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Guenter Roeck <linux@roeck-us.net>
Message-ID: <47e867e4-0a6f-1352-37a7-b8b04ec137ee@suse.de>
Subject: Re: [PATCH] fbdev: Fix unregistering of framebuffers without device
References: <20220404194402.29974-1-tzimmermann@suse.de>
 <YkwFfusqI2Nuu7Dn@phenom.ffwll.local>
In-Reply-To: <YkwFfusqI2Nuu7Dn@phenom.ffwll.local>

--------------DzAeDAUN9vZwABa46Ebx90t5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMDUuMDQuMjIgdW0gMTE6MDEgc2NocmllYiBEYW5pZWwgVmV0dGVyOg0KPiBP
biBNb24sIEFwciAwNCwgMjAyMiBhdCAwOTo0NDowMlBNICswMjAwLCBUaG9tYXMgWmltbWVy
bWFubiB3cm90ZToNCj4+IE9GIGZyYW1lYnVmZmVycyBkbyBub3QgaGF2ZSBhbiB1bmRlcmx5
aW5nIGRldmljZSBpbiB0aGUgTGludXgNCj4+IGRldmljZSBoaWVyYXJjaHkuIERvIGEgcmVn
dWxhciB1bnJlZ2lzdGVyIGNhbGwgaW5zdGVhZCBvZiBob3QNCj4+IHVucGx1Z2dpbmcgc3Vj
aCBhIG5vbi1leGlzdGluZyBkZXZpY2UuIEZpeGVzIGEgTlVMTCBkZXJlZmVyZW5jZS4NCj4+
IEFuIGV4YW1wbGUgZXJyb3IgbWVzc2FnZSBvbiBwcGM2NGxlIGlzIHNob3duIGJlbG93Lg0K
Pj4NCj4+ICAgIEJVRzogS2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBvbiByZWFk
IGF0IDB4MDAwMDAwNjANCj4+ICAgIEZhdWx0aW5nIGluc3RydWN0aW9uIGFkZHJlc3M6IDB4
YzAwMDAwMDAwMDgwZGZhNA0KPj4gICAgT29wczogS2VybmVsIGFjY2VzcyBvZiBiYWQgYXJl
YSwgc2lnOiAxMSBbIzFdDQo+PiAgICBMRSBQQUdFX1NJWkU9NjRLIE1NVT1IYXNoIFNNUCBO
Ul9DUFVTPTIwNDggTlVNQSBwU2VyaWVzDQo+PiAgICBbLi4uXQ0KPj4gICAgQ1BVOiAyIFBJ
RDogMTM5IENvbW06IHN5c3RlbWQtdWRldmQgTm90IHRhaW50ZWQgNS4xNy4wLWFlMDg1ZDdm
OTM2NSAjMQ0KPj4gICAgTklQOiAgYzAwMDAwMDAwMDgwZGZhNCBMUjogYzAwMDAwMDAwMDgw
ZGY5YyBDVFI6IGMwMDAwMDAwMDA3OTc0MzANCj4+ICAgIFJFR1M6IGMwMDAwMDAwMDQxMzJm
ZTAgVFJBUDogMDMwMCAgIE5vdCB0YWludGVkICAoNS4xNy4wLWFlMDg1ZDdmOTM2NSkNCj4+
ICAgIE1TUjogIDgwMDAwMDAwMDIwMDkwMzMgPFNGLFZFQyxFRSxNRSxJUixEUixSSSxMRT4g
IENSOiAyODIyODI4MiAgWEVSOiAyMDAwMDAwMA0KPj4gICAgQ0ZBUjogYzAwMDAwMDAwMDAw
YzgwYyBEQVI6IDAwMDAwMDAwMDAwMDAwNjAgRFNJU1I6IDQwMDAwMDAwIElSUU1BU0s6IDAN
Cj4+ICAgIEdQUjAwOiBjMDAwMDAwMDAwODBkZjljIGMwMDAwMDAwMDQxMzMyODAgYzAwMDAw
MDAwMTY5ZDIwMCAwMDAwMDAwMDAwMDAwMDI5DQo+PiAgICBHUFIwNDogMDAwMDAwMDBmZmZm
ZWZmZiBjMDAwMDAwMDA0MTMyZjkwIGMwMDAwMDAwMDQxMzJmODggMDAwMDAwMDAwMDAwMDAw
MA0KPj4gICAgR1BSMDg6IGMwMDAwMDAwMDE1NjU4ZjggYzAwMDAwMDAwMTVjZDIwMCBjMDAw
MDAwMDAxNGY1N2QwIDAwMDAwMDAwNDgyMjgyODMNCj4+ICAgIEdQUjEyOiAwMDAwMDAwMDAw
MDAwMDAwIGMwMDAwMDAwM2ZmZmUzMDAgMDAwMDAwMDAyMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwDQo+PiAgICBHUFIxNjogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMTEzZmM0YTQwIDAw
MDAwMDAwMDAwMDAwMDUgMDAwMDAwMDExM2ZjZmI4MA0KPj4gICAgR1BSMjA6IDAwMDAwMTAw
MGY3MjgzYjAgMDAwMDAwMDAwMDAwMDAwMCBjMDAwMDAwMDAwZTRhNTg4IGMwMDAwMDAwMDBl
NGE1YjANCj4+ICAgIEdQUjI0OiAwMDAwMDAwMDAwMDAwMDAxIDAwMDAwMDAwMDAwYTAwMDAg
YzAwODAwMDAwMGRiMDE2OCBjMDAwMDAwMDAyMWY2ZWMwDQo+PiAgICBHUFIyODogYzAwMDAw
MDAwMTZkNjVhOCBjMDAwMDAwMDA0YjM2NDYwIDAwMDAwMDAwMDAwMDAwMDAgYzAwMDAwMDAw
MTZkNjRiMA0KPj4gICAgTklQIFtjMDAwMDAwMDAwODBkZmE0XSBkb19yZW1vdmVfY29uZmxp
Y3RpbmdfZnJhbWVidWZmZXJzKzB4MTg0LzB4MWQwDQo+PiAgICBbYzAwMDAwMDAwNDEzMzI4
MF0gW2MwMDAwMDAwMDA4MGRmOWNdIGRvX3JlbW92ZV9jb25mbGljdGluZ19mcmFtZWJ1ZmZl
cnMrMHgxN2MvMHgxZDAgKHVucmVsaWFibGUpDQo+PiAgICBbYzAwMDAwMDAwNDEzMzM1MF0g
W2MwMDAwMDAwMDA4MGU0ZDBdIHJlbW92ZV9jb25mbGljdGluZ19mcmFtZWJ1ZmZlcnMrMHg2
MC8weDE1MA0KPj4gICAgW2MwMDAwMDAwMDQxMzMzYTBdIFtjMDAwMDAwMDAwODBlNmY0XSBy
ZW1vdmVfY29uZmxpY3RpbmdfcGNpX2ZyYW1lYnVmZmVycysweDEzNC8weDFiMA0KPj4gICAg
W2MwMDAwMDAwMDQxMzM0NTBdIFtjMDA4MDAwMDAwZTcwNDM4XSBkcm1fYXBlcnR1cmVfcmVt
b3ZlX2NvbmZsaWN0aW5nX3BjaV9mcmFtZWJ1ZmZlcnMrMHg5MC8weDEwMCBbZHJtXQ0KPj4g
ICAgW2MwMDAwMDAwMDQxMzM0OTBdIFtjMDA4MDAwMDAwZGEwY2U0XSBib2Noc19wY2lfcHJv
YmUrMHg2Yy8weGE2NCBbYm9jaHNdDQo+PiAgICBbLi4uXQ0KPj4gICAgW2MwMDAwMDAwMDQx
MzNkYjBdIFtjMDAwMDAwMDAwMDJhYWEwXSBzeXN0ZW1fY2FsbF9leGNlcHRpb24rMHgxNzAv
MHgyZDANCj4+ICAgIFtjMDAwMDAwMDA0MTMzZTEwXSBbYzAwMDAwMDAwMDAwYzNjY10gc3lz
dGVtX2NhbGxfY29tbW9uKzB4ZWMvMHgyNTANCj4+DQo+PiBUaGUgYnVnIFsxXSB3YXMgaW50
cm9kdWNlZCBieSBjb21taXQgMjc1OTlhYWNiYWVmICgiZmJkZXY6IEhvdC11bnBsdWcNCj4+
IGZpcm13YXJlIGZiIGRldmljZXMgb24gZm9yY2VkIHJlbW92YWwiKS4gTW9zdCBmaXJtd2Fy
ZSBmcmFtZWJ1ZmZlcnMNCj4+IGhhdmUgYW4gdW5kZXJseWluZyBwbGF0Zm9ybSBkZXZpY2Us
IHdoaWNoIGNhbiBiZSBob3QtdW5wbHVnZ2VkDQo+PiBiZWZvcmUgbG9hZGluZyB0aGUgbmF0
aXZlIGdyYXBoaWNzIGRyaXZlci4gT0YgZnJhbWVidWZmZXJzIGRvIG5vdA0KPj4gKHlldCkg
aGF2ZSB0aGF0IGRldmljZS4gRml4IHRoZSBjb2RlIGJ5IHVucmVnaXN0ZXJpbmcgdGhlIGZy
YW1lYnVmZmVyDQo+PiBhcyBiZWZvcmUgd2l0aG91dCBhIGhvdCB1bnBsdWcuDQo+Pg0KPj4g
VGVzdGVkIHdpdGggNS4xNyBvbiBxZW11IHBwYzY0bGUgZW11bGF0aW9uLg0KPj4NCj4+IFNp
Z25lZC1vZmYtYnk6IFRob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPg0K
Pj4gRml4ZXM6IDI3NTk5YWFjYmFlZiAoImZiZGV2OiBIb3QtdW5wbHVnIGZpcm13YXJlIGZi
IGRldmljZXMgb24gZm9yY2VkIHJlbW92YWwiKQ0KPj4gUmVwb3J0ZWQtYnk6IFN1ZGlwIE11
a2hlcmplZSA8c3VkaXBtLm11a2hlcmplZUBnbWFpbC5jb20+DQo+PiBDYzogWmFjayBSdXNp
biA8emFja3JAdm13YXJlLmNvbT4NCj4+IENjOiBKYXZpZXIgTWFydGluZXogQ2FuaWxsYXMg
PGphdmllcm1AcmVkaGF0LmNvbT4NCj4+IENjOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUBy
ZWRoYXQuY29tPg0KPj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NS4xMSsNCj4+
IENjOiBIZWxnZSBEZWxsZXIgPGRlbGxlckBnbXguZGU+DQo+PiBDYzogRGFuaWVsIFZldHRl
ciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCj4+IENjOiBTYW0gUmF2bmJvcmcgPHNhbUBy
YXZuYm9yZy5vcmc+DQo+PiBDYzogWmhleXUgTWEgPHpoZXl1bWE5N0BnbWFpbC5jb20+DQo+
PiBDYzogWGl5dSBZYW5nIDx4aXl1eWFuZzE5QGZ1ZGFuLmVkdS5jbj4NCj4+IENjOiBaaGVu
IExlaSA8dGh1bmRlci5sZWl6aGVuQGh1YXdlaS5jb20+DQo+PiBDYzogTWF0dGhldyBXaWxj
b3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+PiBDYzogQWxleCBEZXVjaGVyIDxhbGV4YW5k
ZXIuZGV1Y2hlckBhbWQuY29tPg0KPj4gQ2M6IFRldHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJu
ZWxAaS1sb3ZlLnNha3VyYS5uZS5qcD4NCj4+IENjOiBHdWVudGVyIFJvZWNrIDxsaW51eEBy
b2Vjay11cy5uZXQ+DQo+PiBDYzogbGludXgtZmJkZXZAdmdlci5rZXJuZWwub3JnDQo+PiBD
YzogZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPj4gTGluazogaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsL1lrSFhPNkxHSEFOMHAxcHFAZGViaWFuLyAjIFsxXQ0KPj4g
LS0tDQo+PiAgIGRyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYm1lbS5jIHwgOSArKysrKysr
Ky0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2ZiZGV2L2NvcmUvZmJtZW0u
YyBiL2RyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYm1lbS5jDQo+PiBpbmRleCAzNGQ2YmIx
YmY4MmUuLmE2YmIwZTQzODIxNiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdmlkZW8vZmJk
ZXYvY29yZS9mYm1lbS5jDQo+PiArKysgYi9kcml2ZXJzL3ZpZGVvL2ZiZGV2L2NvcmUvZmJt
ZW0uYw0KPj4gQEAgLTE1NzksNyArMTU3OSwxNCBAQCBzdGF0aWMgdm9pZCBkb19yZW1vdmVf
Y29uZmxpY3RpbmdfZnJhbWVidWZmZXJzKHN0cnVjdCBhcGVydHVyZXNfc3RydWN0ICphLA0K
Pj4gICAJCQkgKiBJZiBpdCdzIG5vdCBhIHBsYXRmb3JtIGRldmljZSwgYXQgbGVhc3QgcHJp
bnQgYSB3YXJuaW5nLiBBDQo+PiAgIAkJCSAqIGZpeCB3b3VsZCBhZGQgY29kZSB0byByZW1v
dmUgdGhlIGRldmljZSBmcm9tIHRoZSBzeXN0ZW0uDQo+PiAgIAkJCSAqLw0KPj4gLQkJCWlm
IChkZXZfaXNfcGxhdGZvcm0oZGV2aWNlKSkgew0KPj4gKwkJCWlmICghZGV2aWNlKSB7DQo+
PiArCQkJCS8qIFRPRE86IFJlcHJlc2VudCBlYWNoIE9GIGZyYW1lYnVmZmVyIGFzIGl0cyBv
d24NCj4+ICsJCQkJICogZGV2aWNlIGluIHRoZSBkZXZpY2UgaGllcmFyY2h5LiBGb3Igbm93
LCBvZmZiDQo+PiArCQkJCSAqIGRvZXNuJ3QgaGF2ZSBzdWNoIGEgZGV2aWNlLCBzbyB1bnJl
Z2lzdGVyIHRoZQ0KPj4gKwkJCQkgKiBmcmFtZWJ1ZmZlciBhcyBiZWZvcmUgd2l0aG91dCB3
YXJuaW5nLg0KPj4gKwkJCQkgKi8NCj4+ICsJCQkJZG9fdW5yZWdpc3Rlcl9mcmFtZWJ1ZmZl
cihyZWdpc3RlcmVkX2ZiW2ldKTsNCj4gDQo+IFJldmlld2VkLWJ5OiBEYW5pZWwgVmV0dGVy
IDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPg0KPiANCj4gTWlnaHQgYmUgZ29vZCB0byBoYXZl
IGEgZmJfaW5mbyBmbGFnIGZvciBvZmZiIGFuZCB0aGVuIGNoZWNrIGluDQo+IHJlZ2lzdGVy
X2ZyYW1lYnVmZmVyIHRoYXQgZXZlcnlvbmUgZWxzZSBkb2VzIGhhdmUgYSBkZXZpY2U/IEp1
c3QgdG8gbWFrZQ0KPiBzdXJlIHdlIGRvbid0IGhhdmUgbW9yZSBzdXJwcmlzZXMgaGVyZSAu
Li4NCg0KVGhhdCBleGlzdHMgYWxyZWFkeTogYWxsIGdlbmVyaWMvZmlybXdhcmUgZHJpdmVy
cyBhcmUgZmxhZ2dlZCB3aXRoIA0KRkJJTkZPX01JU0NfRklSTVdBUkUgc3BlY2lmaWNhbGx5
IGZvciB0aGUgcHVycG9zZSBvZiB1bmxvYWRpbmcuIA0KSFctbmF0aXZlIGZiZGV2IGRyaXZl
cnMgZG9uJ3QgaGF2ZSB0aGUgZmxhZ3MgYW5kIHdpbGwgbmV2ZXIgYmUgdW5sb2FkZWQuIA0K
SSBkb3VibGUtY2hlY2tlZCBhbmQgb2YgdGhlIGdlbmVyaWMgZHJpdmVycywgKGVmaWZiLCB2
ZXNhZmIsIG9mZmIsIA0Kc2ltcGxlZmIsIHZnYTE2KSBvbmx5IG9mZmIgaGFkIG5vIGRldmlj
ZSBzZXQuDQoNCkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gLURhbmllbA0KPiANCj4gDQo+
PiArCQkJfSBlbHNlIGlmIChkZXZfaXNfcGxhdGZvcm0oZGV2aWNlKSkgew0KPj4gICAJCQkJ
cmVnaXN0ZXJlZF9mYltpXS0+Zm9yY2VkX291dCA9IHRydWU7DQo+PiAgIAkJCQlwbGF0Zm9y
bV9kZXZpY2VfdW5yZWdpc3Rlcih0b19wbGF0Zm9ybV9kZXZpY2UoZGV2aWNlKSk7DQo+PiAg
IAkJCX0gZWxzZSB7DQo+PiAtLSANCj4+IDIuMzUuMQ0KPj4NCj4gDQoNCi0tIA0KVGhvbWFz
IFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUg
U29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJn
LCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJl
cjogSXZvIFRvdGV2DQo=

--------------DzAeDAUN9vZwABa46Ebx90t5--

--------------f3b4P60Lu6y2LkFjpCd2Q0Hs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmJMiUQFAwAAAAAACgkQlh/E3EQov+DY
CA/6AyZykpdsrLCf7xx9/Or4pIqG7E6pXI4XKowuzac+N2mhGZGsyXgBtsy4p2n1NkwS/KfUo9XO
mTREqIbIwD6v11YV3jykQInGEfJexJDaBFe1sOFh7ROwVM17ko46ZVSUtc3Dd1kgG8Mf4QnsglUe
zLRqdVnI2bh9BcIhBxnod4r9Xrj0MTh3yzUxQB/RvPgZy4HrvDxpuq64CeYf8hcALyY9ZdAIGr82
nO5eF5M1/vn3jg4hQz6s+fFOMD5KTPNmQyMW5EI2i++ihroPbdasoZyUoK1PD4/SILZz1Pp152ea
ukiEZUuvUv2SYw/+fxRuPssAIfid2I4zb4N/4FxLYqq1OgtGFsZXQs1dAa8e83BfTpAx+SrFTmeu
HEmtxVKhHpR2YsnjtQNpFg8kInN5MFb2MI0ScbEB5CkvTHSGpfSIyJfZ25nHCtGHAMZlaK7O6Na5
gp76QOo8rqmq2J9mc2vZQhZKEOEBJnRz2QOHZ/G6RLygeSye8nHCUt+/wBATc/AycNvUBi4y6VGn
esqy5pZtFrl1tpCEZ7/5RX092V1F7yaMCgHGHpm04Q0IbHtQ4hEHSwAlEMSbKbJe+AgcwktUP5Jn
vTa5KfzJ0w9ylEtn61GiBPMJXhxebIYHMtdgt1kRruarn7vWuoVxf/2OukCb7qEnKiEGjTj8IUM9
DiI=
=FjfZ
-----END PGP SIGNATURE-----

--------------f3b4P60Lu6y2LkFjpCd2Q0Hs--

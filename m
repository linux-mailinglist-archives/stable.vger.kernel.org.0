Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79A60C62C
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 10:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiJYIQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 04:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiJYIQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 04:16:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B306ACF5E
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 01:16:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 16B5C2208B;
        Tue, 25 Oct 2022 08:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666685810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g2qKrsx5UZLQDbuwTkZZ7+/Pp2pFj53EyFrBcWR4YJU=;
        b=Xge/xqw1EZWHYCaYrGumLwQbpv8UlE5RuwHHJo6b0uSQ4drO5a8GTaenfFhWxci+Xyq9Z1
        Oa2W9a0Xdd4WL74NLM/8ZhRLGnSqUcMj8zADpaDFz5c27Cv3ua+W4l1vb+PUbqJELsa7s4
        NRWasPB5Wo8h1u6Ky+C2HZWtS4MIkmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666685810;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g2qKrsx5UZLQDbuwTkZZ7+/Pp2pFj53EyFrBcWR4YJU=;
        b=Td8PoLuWJl2nn/orkAzyUt/ty9/PM3tPk2EMFIYErBS5nEBqw3g5yxE3/pPFWnA3Jd7jqr
        W98IprUv+hUAoeBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DC9D013A64;
        Tue, 25 Oct 2022 08:16:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FhLmNHGbV2PtGAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 25 Oct 2022 08:16:49 +0000
Message-ID: <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
Date:   Tue, 25 Oct 2022 10:16:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
Content-Language: en-US
To:     andreas.thalhammer@linux.com, Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Sasha Levin <sashal@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Javier Martinez Canillas <javierm@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com> <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
 <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------C0Wq6r4JUYkvcSOCppHERUjp"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------C0Wq6r4JUYkvcSOCppHERUjp
Content-Type: multipart/mixed; boundary="------------umjUTZvMaDodS5JaBA2BfnQ1";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: andreas.thalhammer@linux.com, Greg KH <gregkh@linuxfoundation.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sasha Levin <sashal@kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 Javier Martinez Canillas <javierm@redhat.com>,
 ML dri-devel <dri-devel@lists.freedesktop.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com> <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
 <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
In-Reply-To: <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>

--------------umjUTZvMaDodS5JaBA2BfnQ1
Content-Type: multipart/mixed; boundary="------------xFNo3LKiAe9GTnIK4fswRIqd"

--------------xFNo3LKiAe9GTnIK4fswRIqd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgQW5kcmVhcw0KDQpBbSAyNC4xMC4yMiB1bSAxODoxOSBzY2hyaWViIEFuZHJlYXMgVGhh
bGhhbW1lcjoNCj4gQW0gMjQuMTAuMjIgdW0gMTM6MzEgc2NocmllYiBUaG9tYXMgWmltbWVy
bWFubjoNCj4+IEhpDQo+Pg0KPj4gQW0gMjQuMTAuMjIgdW0gMTM6Mjcgc2NocmllYiBHcmVn
IEtIOg0KPj4+IE9uIE1vbiwgT2N0IDI0LCAyMDIyIGF0IDEyOjQxOjQzUE0gKzAyMDAsIFRo
b3JzdGVuIExlZW1odWlzIHdyb3RlOg0KPj4+PiBIaSEgVGh4IGZvciB0aGUgcmVwbHkuDQo+
Pj4+DQo+Pj4+IE9uIDI0LjEwLjIyIDEyOjI2LCBUaG9tYXMgWmltbWVybWFubiB3cm90ZToN
Cj4+Pj4+IEFtIDIzLjEwLjIyIHVtIDEwOjA0IHNjaHJpZWIgVGhvcnN0ZW4gTGVlbWh1aXM6
DQo+Pj4+Pj4NCj4+Pj4+PiBJIG5vdGljZWQgYSByZWdyZXNzaW9uIHJlcG9ydCBpbiBidWd6
aWxsYS5rZXJuZWwub3JnLiBBcyBtYW55IChtb3N0PykNCj4+Pj4+PiBrZXJuZWwgZGV2ZWxv
cGVyIGRvbid0IGtlZXAgYW4gZXllIG9uIGl0LCBJIGRlY2lkZWQgdG8gZm9yd2FyZCBpdCBi
eQ0KPj4+Pj4+IG1haWwuIFF1b3RpbmcgZnJvbQ0KPj4+Pj4+IGh0dHBzOi8vYnVnemlsbGEu
a2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE2NjE2wqAgOg0KPj4+Pj4+DQo+Pj4+Pj4+
IMKgwqAgQW5kcmVhcyAyMDIyLTEwLTIyIDE0OjI1OjMyIFVUQw0KPj4+Pj4+Pg0KPj4+Pj4+
PiBDcmVhdGVkIGF0dGFjaG1lbnQgMzAzMDc0IFtkZXRhaWxzXQ0KPj4+Pj4+PiBkbWVzZw0K
Pj4+Pj4NCj4+Pj4+IEkndmUgbG9va2VkIGF0IHRoZSBrZXJuZWwgbG9nIGFuZCBmb3VuZCB0
aGF0IHNpbXBsZWRybSBoYXMgYmVlbiBsb2FkZWQNCj4+Pj4+ICphZnRlciogYW1kZ3B1LCB3
aGljaCBzaG91bGQgbmV2ZXIgaGFwcGVuLiBUaGUgcHJvYmxlbWF0aWMgcGF0Y2ggaGFzDQo+
Pj4+PiBiZWVuIHRha2VuIGZyb20gYSBsb25nIGxpc3Qgb2YgcmVmYWN0b3Jpbmcgd29yayBv
biB0aGlzIGNvZGUuIE5vIA0KPj4+Pj4gd29uZGVyDQo+Pj4+PiB0aGF0IGl0IGRvZXNuJ3Qg
d29yayBhcyBleHBlY3RlZC4NCj4+Pj4+DQo+Pj4+PiBQbGVhc2UgY2hlcnJ5LXBpY2sgY29t
bWl0IDlkNjllZjE4MzgxNSAoImZiZGV2L2NvcmU6IFJlbW92ZQ0KPj4+Pj4gcmVtb3ZlX2Nv
bmZsaWN0aW5nX3BjaV9mcmFtZWJ1ZmZlcnMoKSIpIGludG8gdGhlIDYuMCBzdGFibGUgYnJh
bmNoIGFuZA0KPj4+Pj4gcmVwb3J0IG9uIHRoZSByZXN1bHRzLiBJdCBzaG91bGQgZml4IHRo
ZSBwcm9ibGVtLg0KPj4+Pg0KPj4+PiBHcmVnLCBpcyB0aGF0IGVub3VnaCBmb3IgeW91IHRv
IHBpY2sgdGhpcyB1cD8gT3IgZG8geW91IHdhbnQgQW5kcmVhcyB0bw0KPj4+PiB0ZXN0IGZp
cnN0IGlmIGl0IHJlYWxseSBmaXhlcyB0aGUgcmVwb3J0ZWQgcHJvYmxlbT8NCj4+Pg0KPj4+
IFRoaXMgc2hvdWxkIGJlIGdvb2QgZW5vdWdoLsKgIElmIHRoaXMgZG9lcyBOT1QgZml4IHRo
ZSBpc3N1ZSwgcGxlYXNlIGxldA0KPj4+IG1lIGtub3cuDQo+Pg0KPj4gVGhhbmtzIGEgbG90
LiBJIHRoaW5rIEkgY2FuIHByb3ZpZGVkIGEgZGVkaWNhdGVkIGZpeCBpZiB0aGUgcHJvcG9z
ZWQNCj4+IGNvbW1pdCBkb2Vzbid0IHdvcmsuDQo+Pg0KPj4gQmVzdCByZWdhcmRzDQo+PiBU
aG9tYXMNCj4+DQo+Pj4NCj4+PiB0aGFua3MsDQo+Pj4NCj4+PiBncmVnIGstaA0KPj4NCj4g
DQo+IFRoYW5rcy4uLiBJbiBzaG9ydDogdGhlIGFkZGl0aW9uYWwgcGF0Y2ggZGlkIE5PVCBm
aXggdGhlIHByb2JsZW0uDQoNClllYWgsIGl0J3MgYWxzbyBwYXJ0IG9mIGEgbGFyZ2VyIGNo
YW5nZXNldC4gQnV0IEkgd291bGRuJ3Qgd2FudCB0byANCmJhY2twb3J0IGFsbCB0aG9zZSBj
aGFuZ2VzIGVpdGhlci4NCg0KQXR0YWNoZWQgaXMgYSBzaW1wbGUgcGF0Y2ggZm9yIGxpbnV4
LXN0YWJsZSB0aGF0IGFkZHMgdGhlIG5lY2Vzc2FyeSBmaXguIA0KSWYgdGhpcyBzdGlsbCBk
b2Vzbid0IHdvcmssIHdlIHNob3VsZCBwcm9iYWJseSByZXZlcnQgdGhlIHByb2JsZW1hdGlj
IHBhdGNoLg0KDQpQbGVhc2UgdGVzdCB0aGUgcGF0Y2ggYW5kIGxldCBtZSBrbm93IGlmIGl0
IHdvcmtzLg0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQo+IA0KPiBJIGRvbid0IHVzZSBn
aXQgYW5kIEkgZG9uJ3Qga25vdyBob3cgdG8gL2NoZXJyeS1waWNrIGNvbW1pdC8NCj4gOWQ2
OWVmMTgzODE1LCBidXQgSSBmb3VuZCB0aGUgcGF0Y2ggaGVyZToNCj4gaHR0cHM6Ly9wYXRj
aHdvcmsuZnJlZWRlc2t0b3Aub3JnL3BhdGNoLzQ5NDYwOS8NCj4gDQo+IEkgaG9wZSB0aGF0
J3MgdGhlIHJpZ2h0IG9uZS4gSSByZWludGVncmF0ZWQNCj4gdjItMDctMTEtdmlkZW8tYXBl
cnR1cmUtRGlzYWJsZS1hbmQtdW5yZWdpc3Rlci1zeXNmYi1kZXZpY2VzLXZpYS1hcGVydHVy
ZS1oZWxwZXJzLnBhdGNoDQo+IGFuZCBhbHNvIGFwcGxpZWQNCj4gdjItMDQtMTEtZmJkZXYt
Y29yZS1SZW1vdmUtcmVtb3ZlX2NvbmZsaWN0aW5nX3BjaV9mcmFtZWJ1ZmZlcnMucGF0Y2gs
DQo+IGRpZCBhICJtYWtlIG1ycHJvcGVyIiBhbmQgdGhlcmVhZnRlciBjb21waWxlZCBhIGNs
ZWFuIG5ldyA2LjAuMyBrZXJuZWwNCj4gKHNhbWUgLmNvbmZpZykuDQo+IA0KPiBOb3cgdGhl
IHN5c3RlbSBkb2Vzbid0IGV2ZW4gYm9vdCB0byBhIGNvbnNvbGUuIFRoZSBmaXJzdCBib290
IGdvdCBtZSB0bw0KPiBhIHJjdV9zaGVkIHN0YWxsIG9uIENQVXMvdGFza3MsIHNhbWUgYXMg
YWJvdmUsIGJ1dCB0aGlzIHRpbWUgd2l0aDoNCj4gV29ya3F1ZXVlOiBidHJmcy1jYWNoZSBi
dHJmc193b3JrX2hlbHBlcg0KPiANCj4gSSBib290ZWQgYSBzZWNvbmQgdGltZSB3aXRoIHRo
ZSBzYW1lIGtlcm5lbCwgYW5kIGl0IGdvdCBzdHVjayBhZnRlcg0KPiBtb3VudGluZyB0aGUg
cm9vdCBidHJmcyBmaWxlc3lzdGVtICh3aGF0IGxvb2tlZCBsaWtlIGEgdG90YWwgZnJlZXpl
LCBidXQNCj4gd2hlbiBpdCBkaWRuJ3Qgc2hvdyBhIHJjdV9zdGFsbCBtZXNzYWdlIGFmdGVy
IH4yIG1pbiBJIGdvdCBpbXBhdGllbnQgYW5kDQo+IHdhbnRlZCB0byBzZWUgaWYgSSBoYWQg
anVzdCBidXN0ZWQgbXkgcm9vdCBmaWxlc3lzdGVtLi4uKQ0KPiANCj4gSSBib290ZWQgNi4w
LjIgYW5kIGV2ZXJ5dGhpbmcgaXMgZmluZS4gKEknbSB2ZXJ5IGdsYWQhIEkgZGVmaW5pdGVs
eQ0KPiBzaG91bGQgdXBkYXRlIG15IGJhY2t1cCByaWdodCBhd2F5ISkNCj4gDQo+IEkgd2ls
bCB0cnkgNi4xLXJjMSBuZXh0LCBiZWFyIHdpdGguLi4NCj4gDQoNCi0tIA0KVGhvbWFzIFpp
bW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29s
dXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBH
ZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjog
SXZvIFRvdGV2DQo=
--------------xFNo3LKiAe9GTnIK4fswRIqd
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-video-aperture-Call-sysfb_disable-before-removing-PC.patch"
Content-Disposition: attachment;
 filename*0="0001-video-aperture-Call-sysfb_disable-before-removing-PC.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBiYTU1ZTIzOGU2NDgxN2EyMzY5YTI2NzE1M2E1Yjk4MDY4MzQ2NWExIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgWmltbWVybWFubiA8dHppbW1lcm1hbm5A
c3VzZS5kZT4KRGF0ZTogVHVlLCAyNSBPY3QgMjAyMiAwOTozODo0NCArMDIwMApTdWJqZWN0
OiBbUEFUQ0hdIHZpZGVvL2FwZXJ0dXJlOiBDYWxsIHN5c2ZiX2Rpc2FibGUoKSBiZWZvcmUg
cmVtb3ZpbmcgUENJCiBkZXZpY2VzCgpDYWxsIHN5c2ZiX2Rpc2FibGUoKSBmcm9tIGFwZXJ0
dXJlX3JlbW92ZV9jb25mbGljdGluZ19wY2lfZGV2aWNlcygpCmJlZm9yZSByZW1vdmluZyBQ
Q0kgZGV2aWNlcy4gV2l0aG91dCwgc2ltcGxlZHJtIGNhbiBzdGlsbCBiaW5kIHRvCnNpbXBs
ZS1mcmFtZWJ1ZmZlciBkZXZpY2VzIGFmdGVyIHRoZSBoYXJkd2FyZSBkcml2ZXIgaGFzIHRh
a2VuIG92ZXIKdGhlIGhhcmR3YXJlLiBCb3RoIGRyaXZlcnMgaW50ZXJmZXJlIHdpdGggZWFj
aCBvdGhlciBhbmQgcmVzdWx0cyBhcmUKdW5kZWZpbmVkLgoKUmVwb3J0ZWQgbW9kZXNldHRp
bmcgZXJyb3JzIGFyZSBzaG93biBiZWxvdy4KCi0tLS0gc25hcCAtLS0tCnJjdTogSU5GTzog
cmN1X3NjaGVkIGRldGVjdGVkIGV4cGVkaXRlZCBzdGFsbHMgb24gQ1BVcy90YXNrczogeyAx
My0uLi4uIH0gNyBqaWZmaWVzIHM6IDE2NSByb290OiAweDIwMDAvLgpyY3U6IGJsb2NraW5n
IHJjdV9ub2RlIHN0cnVjdHVyZXMgKGludGVybmFsIFJDVSBkZWJ1Zyk6ClRhc2sgZHVtcCBm
b3IgQ1BVIDEzOgp0YXNrOlggICAgICAgICAgICAgICBzdGF0ZTpSICBydW5uaW5nIHRhc2sg
ICAgIHN0YWNrOiAgICAwIHBpZDogNDI0MiBwcGlkOiAgNDIyOCBmbGFnczoweDAwMDAwMDA4
CkNhbGwgVHJhY2U6CiA8VEFTSz4KID8gY29tbWl0X3RhaWwrMHhkNy8weDEzMAogPyBkcm1f
YXRvbWljX2hlbHBlcl9jb21taXQrMHgxMjYvMHgxNTAKID8gZHJtX2F0b21pY19jb21taXQr
MHhhNC8weGUwCiA/IGRybV9wbGFuZV9nZXRfZGFtYWdlX2NsaXBzLmNvbGQrMHgxYy8weDFj
CiA/IGRybV9hdG9taWNfaGVscGVyX2RpcnR5ZmIrMHgxOWUvMHgyODAKID8gZHJtX21vZGVf
ZGlydHlmYl9pb2N0bCsweDEwZi8weDFlMAogPyBkcm1fbW9kZV9nZXRmYjJfaW9jdGwrMHgy
ZDAvMHgyZDAKID8gZHJtX2lvY3RsX2tlcm5lbCsweGM0LzB4MTUwCiA/IGRybV9pb2N0bCsw
eDI0Ni8weDNmMAogPyBkcm1fbW9kZV9nZXRmYjJfaW9jdGwrMHgyZDAvMHgyZDAKID8gX194
NjRfc3lzX2lvY3RsKzB4OTEvMHhkMAogPyBkb19zeXNjYWxsXzY0KzB4NjAvMHhkMAogPyBl
bnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0Yi8weGI1CiA8L1RBU0s+Ci4uLgpy
Y3U6IElORk86IHJjdV9zY2hlZCBkZXRlY3RlZCBleHBlZGl0ZWQgc3RhbGxzIG9uIENQVXMv
dGFza3M6IHsgMTMtLi4uLiB9IDMwIGppZmZpZXMgczogMTY5IHJvb3Q6IDB4MjAwMC8uCnJj
dTogYmxvY2tpbmcgcmN1X25vZGUgc3RydWN0dXJlcyAoaW50ZXJuYWwgUkNVIGRlYnVnKToK
VGFzayBkdW1wIGZvciBDUFUgMTM6CnRhc2s6WCAgICAgICAgICAgICAgIHN0YXRlOlIgIHJ1
bm5pbmcgdGFzayAgICAgc3RhY2s6ICAgIDAgcGlkOiA0MjQyIHBwaWQ6ICA0MjI4IGZsYWdz
OjB4MDAwMDQwMGUKQ2FsbCBUcmFjZToKIDxUQVNLPgogPyBtZW1jcHlfdG9pbysweDc2LzB4
YzAKID8gbWVtY3B5X3RvaW8rMHgxYi8weGMwCiA/IGRybV9mYl9tZW1jcHlfdG9pbysweDc2
LzB4YjAKID8gZHJtX2ZiX2JsaXRfdG9pbysweDc1LzB4MmIwCiA/IHNpbXBsZWRybV9zaW1w
bGVfZGlzcGxheV9waXBlX3VwZGF0ZSsweDEzMi8weDE1MAogPyBkcm1fYXRvbWljX2hlbHBl
cl9jb21taXRfcGxhbmVzKzB4YjYvMHgyMzAKID8gZHJtX2F0b21pY19oZWxwZXJfY29tbWl0
X3RhaWwrMHg0NC8weDgwCiA/IGNvbW1pdF90YWlsKzB4ZDcvMHgxMzAKID8gZHJtX2F0b21p
Y19oZWxwZXJfY29tbWl0KzB4MTI2LzB4MTUwCiA/IGRybV9hdG9taWNfY29tbWl0KzB4YTQv
MHhlMAogPyBkcm1fcGxhbmVfZ2V0X2RhbWFnZV9jbGlwcy5jb2xkKzB4MWMvMHgxYwogPyBk
cm1fYXRvbWljX2hlbHBlcl9kaXJ0eWZiKzB4MTllLzB4MjgwCiA/IGRybV9tb2RlX2RpcnR5
ZmJfaW9jdGwrMHgxMGYvMHgxZTAKID8gZHJtX21vZGVfZ2V0ZmIyX2lvY3RsKzB4MmQwLzB4
MmQwCiA/IGRybV9pb2N0bF9rZXJuZWwrMHhjNC8weDE1MAogPyBkcm1faW9jdGwrMHgyNDYv
MHgzZjAKID8gZHJtX21vZGVfZ2V0ZmIyX2lvY3RsKzB4MmQwLzB4MmQwCiA/IF9feDY0X3N5
c19pb2N0bCsweDkxLzB4ZDAKID8gZG9fc3lzY2FsbF82NCsweDYwLzB4ZDAKID8gZW50cnlf
U1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NGIvMHhiNQogPC9UQVNLPgoKVGhlIHByb2Js
ZW0gd2FzIGludHJvZHVjZWQgYnkgYmFja3BvcnRpbmcgY29tbWl0IDVlMDEzNzYxMjQzMAoo
InZpZGVvL2FwZXJ0dXJlOiBEaXNhYmxlIGFuZCB1bnJlZ2lzdGVyIHN5c2ZiIGRldmljZXMg
dmlhIGFwZXJ0dXJlCiBoZWxwZXJzIikgdG8gdjYuMC4zIGFuZCBkb2VzIG5vdCBleGlzdCBp
biB0aGUgbWFpbmxpbmUgYnJhbmNoLgoKUmVwb3J0ZWQtYnk6IEFuZHJlYXMgVGhhbGhhbW1l
ciA8YW5kcmVhcy50aGFsaGFtbWVyLWxpbnV4QGdteC5uZXQ+ClJlcG9ydGVkLWJ5OiBUaG9y
c3RlbiBMZWVtaHVpcyA8cmVncmVzc2lvbnNAbGVlbWh1aXMuaW5mbz4KU2lnbmVkLW9mZi1i
eTogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+CkZpeGVzOiBjZmVj
ZmM5OGE3OGQgKCJ2aWRlby9hcGVydHVyZTogRGlzYWJsZSBhbmQgdW5yZWdpc3RlciBzeXNm
YiBkZXZpY2VzIHZpYSBhcGVydHVyZSBoZWxwZXJzIikKQ2M6IFRob21hcyBaaW1tZXJtYW5u
IDx0emltbWVybWFubkBzdXNlLmRlPgpDYzogSmF2aWVyIE1hcnRpbmV6IENhbmlsbGFzIDxq
YXZpZXJtQHJlZGhhdC5jb20+CkNjOiBaYWNrIFJ1c2luIDx6YWNrckB2bXdhcmUuY29tPgpD
YzogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4KQ2M6IERhbmllbCBW
ZXR0ZXIgPGRhbmllbEBmZndsbC5jaD4KQ2M6IFNhbSBSYXZuYm9yZyA8c2FtQHJhdm5ib3Jn
Lm9yZz4KQ2M6IEhlbGdlIERlbGxlciA8ZGVsbGVyQGdteC5kZT4KQ2M6IEFsZXggRGV1Y2hl
ciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4KQ2M6IFpoZW4gTGVpIDx0aHVuZGVyLmxl
aXpoZW5AaHVhd2VpLmNvbT4KQ2M6IENoYW5nY2hlbmcgRGVuZyA8ZGVuZy5jaGFuZ2NoZW5n
QHp0ZS5jb20uY24+CkNjOiBNYWFydGVuIExhbmtob3JzdCA8bWFhcnRlbi5sYW5raG9yc3RA
bGludXguaW50ZWwuY29tPgpDYzogTWF4aW1lIFJpcGFyZCA8bXJpcGFyZEBrZXJuZWwub3Jn
PgpDYzogZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpDYzogU2FzaGEgTGV2aW4g
PHNhc2hhbEBrZXJuZWwub3JnPgpDYzogbGludXgtZmJkZXZAdmdlci5rZXJuZWwub3JnCkNj
OiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2Ni4wLjMrCkxpbms6IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2RyaS1kZXZlbC9kNmFmZTU0Yi1mOGQ3LWJlYjItMzYwOS0xODZlNTY2
Y2JmYWNAZ214Lm5ldC9ULyN0Ci0tLQogZHJpdmVycy92aWRlby9hcGVydHVyZS5jIHwgMTEg
KysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy92aWRlby9hcGVydHVyZS5jIGIvZHJpdmVycy92aWRlby9hcGVydHVy
ZS5jCmluZGV4IGQyNDU4MjZhOTMyNGQuLmNjNjQyN2EwOTFiYzcgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvdmlkZW8vYXBlcnR1cmUuYworKysgYi9kcml2ZXJzL3ZpZGVvL2FwZXJ0dXJlLmMK
QEAgLTMzOCw2ICszMzgsMTcgQEAgaW50IGFwZXJ0dXJlX3JlbW92ZV9jb25mbGljdGluZ19w
Y2lfZGV2aWNlcyhzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3QgY2hhciAqbmEKIAlyZXNv
dXJjZV9zaXplX3QgYmFzZSwgc2l6ZTsKIAlpbnQgYmFyLCByZXQ7CiAKKwkvKgorCSAqIElm
IGEgZHJpdmVyIGFza2VkIHRvIHVucmVnaXN0ZXIgYSBwbGF0Zm9ybSBkZXZpY2UgcmVnaXN0
ZXJlZCBieQorCSAqIHN5c2ZiLCB0aGVuIGNhbiBiZSBhc3N1bWVkIHRoYXQgdGhpcyBpcyBh
IGRyaXZlciBmb3IgYSBkaXNwbGF5CisJICogdGhhdCBpcyBzZXQgdXAgYnkgdGhlIHN5c3Rl
bSBmaXJtd2FyZSBhbmQgaGFzIGEgZ2VuZXJpYyBkcml2ZXIuCisJICoKKwkgKiBEcml2ZXJz
IGZvciBkZXZpY2VzIHRoYXQgZG9uJ3QgaGF2ZSBhIGdlbmVyaWMgZHJpdmVyIHdpbGwgbmV2
ZXIKKwkgKiBhc2sgZm9yIHRoaXMsIHNvIGxldCdzIGFzc3VtZSB0aGF0IGEgcmVhbCBkcml2
ZXIgZm9yIHRoZSBkaXNwbGF5CisJICogd2FzIGFscmVhZHkgcHJvYmVkIGFuZCBwcmV2ZW50
IHN5c2ZiIHRvIHJlZ2lzdGVyIGRldmljZXMgbGF0ZXIuCisJICovCisJc3lzZmJfZGlzYWJs
ZSgpOworCiAJLyoKIAkgKiBXQVJOSU5HOiBBcHBhcmVudGx5IHdlIG11c3Qga2ljayBmYmRl
diBkcml2ZXJzIGJlZm9yZSB2Z2Fjb24sCiAJICogb3RoZXJ3aXNlIHRoZSB2Z2EgZmJkZXYg
ZHJpdmVyIGZhbGxzIG92ZXIuCi0tIAoyLjM4LjAKCg==

--------------xFNo3LKiAe9GTnIK4fswRIqd--

--------------umjUTZvMaDodS5JaBA2BfnQ1--

--------------C0Wq6r4JUYkvcSOCppHERUjp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNXm3EFAwAAAAAACgkQlh/E3EQov+Dt
qA/+PX5YxfcICWVzpbHZJT2brM6Mk4WmAQ0nz7EmYnSFiO5zA4HXHdKhSRX0BE0aokJOeOi9PDon
W/Qpn9SiTduke7yk964LzlooZWKX3yepgE7nASYQzKAQGKCKwr9FcK+j2WT64FaRm5S8ka5gZfpc
IRoqTfKuT8IlTDb6TRkWN9joRLHK5UMYI+m2j1CNqW1HG6uI+9Q5g9y7wdFY0/dg04kLvsNjXPcP
axCyEHdbw8zqBq0il6jR8EDtSXb6tUZgyKjyewVh9v1duADV0WrUcLbdm6jeqk0bjwrligBRedWG
LdwK5cUnt4tsQI2F33D6MkOVgPomMNsP/dfnJPSMjXNp1iTR+OCIwEYDUQcLyDAuJIJspS2WX7+7
13B6QuN7PgBrQ2gI3hvjVSJjrCf6+uHUmEpD+/IGqtFFSvyuSN6Lm/DVWBQlk5ooch2GWfDAnkpb
a1CVZXK3vBvah9FCtFS07+lqmI3eDLIDJzF4SbvRsdK6yjJjqFBTRcOW4h/gunEZtqoAM1LP0hT7
lqnfqVhHSgYVPNxWfceERa59+QeSEpd9yHARuo5VGebjjm2lA68uvNgtJKV6gIJs0ojPJwOZdhCd
Zz/mbQdxfS8lHg3xUPFLkxSYNC93TCHhvSbNzk1rl4tvzjowKvWAtXfXDS8brrY9WF+7wvGFSuR0
njQ=
=Om6F
-----END PGP SIGNATURE-----

--------------C0Wq6r4JUYkvcSOCppHERUjp--

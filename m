Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58851610C80
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 10:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJ1Ixy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 04:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJ1Ixw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 04:53:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAEF1BE904;
        Fri, 28 Oct 2022 01:53:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F29DE219AD;
        Fri, 28 Oct 2022 08:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666947230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xCdn9fKql75AYxVJtfMBUOilnEy+gC86JfFz/Sapfik=;
        b=adEwFkyknc9TlXinMNkotEzn6epJ/pNvU7reFBVCnHdb6pggZ4nouMX6WUsxaIWJkV3EVF
        8EkwhvgT14dUww7YpuHwMO51Xj0N2nPUl5DgPjh/11hbQC8lBkMkF3YNIAXPkQqqTG/0Ju
        ELyrPC0ndkJIhqyhKeND+Odbcb/hrUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666947230;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xCdn9fKql75AYxVJtfMBUOilnEy+gC86JfFz/Sapfik=;
        b=mQIfhOu9sr3WXr5pDkGwOJIWj8or4LhO9HY/OiqoY1OfQ63imn1UMGCIR58pe+z4Ms095k
        y+GicpaA7aX9R8CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BD23613A6E;
        Fri, 28 Oct 2022 08:53:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RTgJLZ2YW2O8CQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Oct 2022 08:53:49 +0000
Message-ID: <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
Date:   Fri, 28 Oct 2022 10:53:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Content-Language: en-US
To:     Pekka Paalanen <ppaalanen@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, asahi@lists.linux.dev
References: <20221027135711.24425-1-marcan@marcan.st>
 <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
 <20221028113705.084502b6@eldfell>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20221028113705.084502b6@eldfell>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ISP6ZAnOBi8elFTzO6WZS1LZ"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ISP6ZAnOBi8elFTzO6WZS1LZ
Content-Type: multipart/mixed; boundary="------------vNeDTCH9Xq3OTneeQ57ybLEH";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Hector Martin <marcan@marcan.st>,
 Javier Martinez Canillas <javierm@redhat.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
 asahi@lists.linux.dev
Message-ID: <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
References: <20221027135711.24425-1-marcan@marcan.st>
 <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
 <20221028113705.084502b6@eldfell>
In-Reply-To: <20221028113705.084502b6@eldfell>

--------------vNeDTCH9Xq3OTneeQ57ybLEH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjguMTAuMjIgdW0gMTA6Mzcgc2NocmllYiBQZWtrYSBQYWFsYW5lbjoNCj4g
T24gRnJpLCAyOCBPY3QgMjAyMiAxMDowNzoyNyArMDIwMA0KPiBUaG9tYXMgWmltbWVybWFu
biA8dHppbW1lcm1hbm5Ac3VzZS5kZT4gd3JvdGU6DQo+IA0KPj4gSGkNCj4+DQo+PiBBbSAy
Ny4xMC4yMiB1bSAxNTo1NyBzY2hyaWViIEhlY3RvciBNYXJ0aW46DQo+Pj4gZHJtX2ZiX2J1
aWxkX2ZvdXJjY19saXN0KCkgY3VycmVudGx5IHJldHVybnMgYWxsIGVtdWxhdGVkIGZvcm1h
dHMNCj4+PiB1bmNvbmRpdGlvbmFsbHkgYXMgbG9uZyBhcyB0aGUgbmF0aXZlIGZvcm1hdCBp
cyBhbW9uZyB0aGVtLCBldmVuIHRob3VnaA0KPj4+IG5vdCBhbGwgY29tYmluYXRpb25zIGhh
dmUgY29udmVyc2lvbiBoZWxwZXJzLiBBbHRob3VnaCB0aGUgbGlzdCBpcw0KPj4+IGFyZ3Vh
Ymx5IHByb3ZpZGVkIHRvIHVzZXJzcGFjZSBpbiBwcmVjZWRlbmNlIG9yZGVyLCB1c2Vyc3Bh
Y2UgY2FuIHBpY2sNCj4+PiBzb21ldGhpbmcgb3V0LW9mLW9yZGVyIChhbmQgdGh1cyBicmVh
ayB3aGVuIGl0IHNob3VsZG4ndCksIG9yIHNpbXBseQ0KPj4+IG9ubHkgc3VwcG9ydCBhIGZv
cm1hdCB0aGF0IGlzIHVuc3VwcG9ydGVkIChhbmQgdGh1cyB0aGluayBpdCBjYW4gd29yaywN
Cj4+PiB3aGljaCByZXN1bHRzIGluIHRoZSBhcHBlYXJhbmNlIG9mIGEgaGFuZyBhcyBGQiBi
bGl0cyBmYWlsIGxhdGVyIG9uLA0KPj4+IGluc3RlYWQgb2YgdGhlIGluaXRpYWxpemF0aW9u
IGVycm9yIHlvdSdkIGV4cGVjdCBpbiB0aGlzIGNhc2UpLg0KPj4+DQo+Pj4gQWRkIGNoZWNr
cyB0byBmaWx0ZXIgdGhlIGxpc3Qgb2YgZW11bGF0ZWQgZm9ybWF0cyB0byBvbmx5IHRob3Nl
DQo+Pj4gc3VwcG9ydGVkIGZvciBjb252ZXJzaW9uIHRvIHRoZSBuYXRpdmUgZm9ybWF0LiBU
aGlzIHByZXN1bWVzIHRoYXQgdGhlcmUNCj4+PiBpcyBhIHNpbmdsZSBuYXRpdmUgZm9ybWF0
IChvbmx5IHRoZSBmaXJzdCBpcyBjaGVja2VkLCBpZiB0aGVyZSBhcmUNCj4+PiBtdWx0aXBs
ZSkuIFJlZmFjdG9yaW5nIHRoaXMgQVBJIHRvIGRyb3AgdGhlIG5hdGl2ZSBsaXN0IG9yIHN1
cHBvcnQgaXQNCj4+PiBwcm9wZXJseSAoYnkgcmV0dXJuaW5nIHRoZSBhcHByb3ByaWF0ZSBl
bXVsYXRlZC0+bmF0aXZlIG1hcHBpbmcgdGFibGUpDQo+Pj4gaXMgbGVmdCBmb3IgYSBmdXR1
cmUgcGF0Y2guDQo+Pj4NCj4+PiBUaGUgc2ltcGxlZHJtIGRyaXZlciBpcyBsZWZ0IGFzLWlz
IHdpdGggYSBmdWxsIHRhYmxlIG9mIGVtdWxhdGVkDQo+Pj4gZm9ybWF0cy4gVGhpcyBrZWVw
cyBhbGwgY3VycmVudGx5IHdvcmtpbmcgY29udmVyc2lvbnMgYXZhaWxhYmxlIGFuZA0KPj4+
IGRyb3BzIGFsbCB0aGUgYnJva2VuIG9uZXMgKGkuZS4gdGhpcyBhIHN0cmljdCBidWdmaXgg
cGF0Y2gsIGFkZGluZyBubw0KPj4+IG5ldyBzdXBwb3J0ZWQgZm9ybWF0cyBub3IgcmVtb3Zp
bmcgYW55IGFjdHVhbGx5IHdvcmtpbmcgb25lcykuIEluIG9yZGVyDQo+Pj4gdG8gYXZvaWQg
cHJvbGlmZXJhdGlvbiBvZiBlbXVsYXRlZCBmb3JtYXRzLCBmdXR1cmUgZHJpdmVycyBzaG91
bGQNCj4+PiBhZHZlcnRpc2Ugb25seSBYUkdCODg4OCBhcyB0aGUgc29sZSBlbXVsYXRlZCBm
b3JtYXQgKHNpbmNlIHNvbWUNCj4+PiB1c2Vyc3BhY2UgYXNzdW1lcyBpdHMgcHJlc2VuY2Up
Lg0KPj4+DQo+Pj4gVGhpcyBmaXhlcyBhIHJlYWwgdXNlciByZWdyZXNzaW9uIHdoZXJlIHRo
ZSA/UkdCMjEwMTAxMCBzdXBwb3J0IGNvbW1pdA0KPj4+IHN0YXJ0ZWQgYWR2ZXJ0aXNpbmcg
aXQgdW5jb25kaXRpb25hbGx5IHdoZXJlIG5vdCBzdXBwb3J0ZWQsIGFuZCBLV2luDQo+Pj4g
ZGVjaWRlZCB0byBzdGFydCB0byB1c2UgaXQgb3ZlciB0aGUgbmF0aXZlIGZvcm1hdCBhbmQg
YnJva2UsIGJ1dCBhbHNvDQo+Pj4gdGhlIGZpeGVzIHRoZSBzcHVyaW91cyBSR0I1NjUvUkdC
ODg4IGZvcm1hdHMgd2hpY2ggaGF2ZSBiZWVuIHdyb25nbHkNCj4+PiB1bmNvbmRpdGlvbmFs
bHkgYWR2ZXJ0aXNlZCBzaW5jZSB0aGUgZGF3biBvZiBzaW1wbGVkcm0uDQo+Pj4NCj4+PiBG
aXhlczogNmVhOTY2ZmNhMDg0ICgiZHJtL3NpbXBsZWRybTogQWRkIFtBWF1SR0IyMTAxMDEw
IGZvcm1hdHMiKQ0KPj4+IEZpeGVzOiAxMWU4ZjVmZDIyM2IgKCJkcm06IEFkZCBzaW1wbGVk
cm0gZHJpdmVyIikNCj4+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPj4+IFNpZ25l
ZC1vZmYtYnk6IEhlY3RvciBNYXJ0aW4gPG1hcmNhbkBtYXJjYW4uc3Q+DQo+Pg0KPj4gUmV2
aWV3ZWQtYnk6IFRob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPg0KPj4N
Cj4+IFRoYW5rcyBmb3IgeW91ciBwYXRjaC4gSSBoYXZlIHZlcmlmaWVkIHRoYXQgdmlkZW89
LXsxNiwyNH0gc3RpbGwgd29ya3MNCj4+IHdpdGggc2ltcGxlZHJtLg0KPj4NCj4+PiAtLS0N
Cj4+PiBJJ20gcHJvcG9zaW5nIHRoaXMgYWx0ZXJuYXRpdmUgYXBwcm9hY2ggYWZ0ZXIgYSBo
ZWF0ZWQgZGlzY3Vzc2lvbiBvbg0KPj4+IElSQy4gSSdtIG91dCBvZiBpZGVhcywgaWYgeSdh
bGwgZG9uJ3QgbGlrZSB0aGlzIG9uZSB5b3UgY2FuIGZpZ3VyZSBpdA0KPj4+IG91dCBmb3Ig
eW91cnNldmVzIDotKQ0KPj4+DQo+Pj4gQ2hhbmdlcyBzaW5jZSB2MToNCj4+PiBUaGlzIHYy
IG1vdmVzIGFsbCB0aGUgY2hhbmdlcyB0byB0aGUgaGVscGVyIChzbyB0aGV5IHdpbGwgYXBw
bHkgdG8NCj4+PiB0aGUgdXBjb21pbmcgb2Zkcm0sIHRob3VnaCBvZmRybSBhbHNvIG5lZWRz
IHRvIGJlIGZpeGVkIHRvIHRyaW0gaXRzDQo+Pj4gZm9ybWF0IHRhYmxlIHRvIG9ubHkgZm9y
bWF0cyB0aGF0IHNob3VsZCBiZSBlbXVsYXRlZCwgcHJvYmFibHkgb25seQ0KPj4+IFhSR0I4
ODg4LCB0byBhdm9pZCBmdXJ0aGVyIHByb2xpZmVyYXRpbmcgdGhlIHVzZSBvZiBjb252ZXJz
aW9ucyksDQo+Pj4gYW5kIGF2b2lkcyB0b3VjaGluZyBtb3JlIHRoYW4gb25lIGZpbGUuIFRo
ZSBBUEkgc3RpbGwgbmVlZHMgY2xlYW51cA0KPj4+IGFzIG1lbnRpb25lZCAoc3VwcG9ydGlu
ZyBtb3JlIHRoYW4gb25lIG5hdGl2ZSBmb3JtYXQgaXMgZnVuZGFtZW50YWxseQ0KPj4+IGJy
b2tlbiwgc2luY2UgdGhlIGhlbHBlciB3b3VsZCBuZWVkIHRvIHRlbGwgdGhlIGRyaXZlciAq
d2hhdCogbmF0aXZlDQo+Pj4gZm9ybWF0IHRvIHVzZSBmb3IgKmVhY2gqIGVtdWxhdGVkIGZv
cm1hdCBzb21laG93KSwgYnV0IGFsbCBjdXJyZW50IGFuZA0KPj4+IHBsYW5uZWQgdXNlcnMg
b25seSBwYXNzIGluIG9uZSBuYXRpdmUgZm9ybWF0LCBzbyB0aGlzIGNhbiAoYW5kIHNob3Vs
ZCkNCj4+PiBiZSBmaXhlZCBsYXRlci4NCj4+Pg0KPj4+IEFzaWRlOiBBZnRlciBvdGhlciBJ
UkMgZGlzY3Vzc2lvbiwgSSdtIHRlc3RpbmcgbnVraW5nIHRoZQ0KPj4+IFhSR0IyMTAxMDEw
IDwtPiBBUkdCMjEwMTAxMCBhZHZlcnRpc2VtZW50ICh3aGljaCBkb2VzIG5vdCBpbnZvbHZl
DQo+Pj4gY29udmVyc2lvbikgYnkgcmVtb3ZpbmcgdGhvc2UgZW50cmllcyBmcm9tIHNpbXBs
ZWRybSBpbiB0aGUgQXNhaGkgTGludXgNCj4+PiBkb3duc3RyZWFtIHRyZWUuIEFzIGZhciBh
cyBJJ20gY29uY2VybmVkLCBpdCBjYW4gYmUgcmVtb3ZlZCBpZiBub2JvZHkNCj4+PiBjb21w
bGFpbnMgKGJ5IHJlbW92aW5nIHRob3NlIGVudHJpZXMgZnJvbSB0aGUgc2ltcGxlZHJtIGFy
cmF5KSwgaWYNCj4+PiBtYWludGFpbmVycyBhcmUgZ2VuZXJhbGx5IG9rYXkgd2l0aCByZW1v
dmluZyBhZHZlcnRpc2VkIGZvcm1hdHMgYXQgYWxsLg0KPj4+IElmIHNvLCB0aGVyZSBtaWdo
dCBiZSBvdGhlciBvcHBvcnR1bml0aWVzIGZvciBmdXJ0aGVyIHRyaW1taW5nIHRoZSBsaXN0
DQo+Pj4gbm9uLW5hdGl2ZSBmb3JtYXRzIGFkdmVydGlzZWQgdG8gdXNlcnNwYWNlLg0KPj4N
Cj4+IElNSE8gYWxsIG9mIHRoZSBleHRyYSBBIGZvcm1hdHMgY2FuIGltbWVkaWF0ZWx5IGdv
LiBXZSBoYXZlIHBsZW50eSBvZg0KPj4gc2ltcGxlIGRyaXZlcnMgdGhhdCBvbmx5IGV4cG9y
dCBYUkdCODg4OCBwbHVzIHNvbWV0aW1lcyBhIGZldyBvdGhlcg0KPj4gbm9uLUEgZm9ybWF0
cy4gSWYgYW55dGhpbmcgaW4gdXNlcnNwYWNlIGhhZCBhIGhhcmQgZGVwZW5kZW5jeSBvbiBh
biBBDQo+PiBmb3JtYXQsIHdlJ2QgcHJvYmFibHkgaGVhcmQgYWJvdXQgaXQuDQo+Pg0KPj4g
SW4geWVzdGVyZGF5J3MgZGlzY3Vzc2lvbiBvbiBJUkMsIGl0IHdhcyBzYWlkIHRoYXQgc2V2
ZXJhbCBkZXZpY2VzDQo+PiBhZHZlcnRpc2UgQVJHQiBmcmFtZWJ1ZmZlcnMgd2hlbiB0aGUg
aGFyZHdhcmUgYWN0dWFsbHkgdXNlcyBYUkdCPyBJcw0KPj4gdGhlcmUgaGFyZHdhcmUgdGhh
dCBzdXBwb3J0cyB0cmFuc3BhcmVudCBwcmltYXJ5IHBsYW5lcz8NCj4gDQo+IEknbSBmYWly
bHkgc3VyZSBzdWNoIGhhcmR3YXJlIGRvZXMgZXhpc3QsIGJ1dCBJIGRvbid0IGtub3cgaWYg
aXQncyB0aGUNCj4gZHJpdmVycyBpbiBxdWVzdGlvbiBoZXJlLg0KPiANCj4gSXQncyBub3Qg
dW5jb21tb24gdG8gaGF2ZSBleHRyYSBoYXJkd2FyZSBwbGFuZXMgYmVsb3cgdGhlIHByaW1h
cnkNCj4gcGxhbmUsIGFuZCB0aGVuIHVzZSBhbHBoYSBvbiBwcmltYXJ5IHBsYW5lIHRvIGN1
dCBhIGhvbGUgdG8gc2VlIHRocm91Z2gNCj4gdG8gdGhlICJ1bmRlcmxheSIgcGxhbmUuIFRo
aXMgaXMgYSBnb29kIHNldHVwIGZvciB2aWRlbyBwbGF5YmFjaywgd2hlcmUNCj4gdGhlIHZp
ZGVvIGlzIG9uIHRoZSB1bmRlcmxheSwgYW5kIChhIHNsb3cgR1BVIG9yIENQVSByZW5kZXJz
KSB0aGUNCj4gc3VidGl0bGVzIGFuZCBVSSBvbiB0aGUgcHJpbWFyeSBwbGFuZS4NCj4gDQo+
IEkndmUgaGVhcmQgdGhhdCBzb21lIGhhcmR3YXJlIGFsc28gaGFzIGEgc2VwYXJhdGUgYmFj
a2dyb3VuZCBjb2xvcg0KPiAicGxhbmUiIGJlbG93IGFsbCBoYXJkd2FyZSBwbGFuZXMsIGJ1
dCBJIGZvcmdldCBpZiB1cHN0cmVhbSBLTVMgZXhwb3Nlcw0KPiB0aGF0Lg0KDQpUaGF0J3Mg
YWxzbyB3aGF0IEkgaGVhcmQgb2YuIEl0J3Mgbm90IHNvbWV0aGluZyB3ZSBjYW4gY29udHJv
bCB3aXRoaW4gDQpzaW1wbGVkcm0gb3IgYW55IG90aGVyIGdlbmVyaWMgZHJpdmVyLg0KDQpJ
J20gd29ycmllZCB0aGF0IHdlIGFkdmVydGlzZSBBUkdCIHRvIHVzZXJzcGFjZSB3aGVuIHRo
ZSBzY2Fub3V0IGJ1ZmZlciANCmlzIGFjdHVhbGx5IFhSR0IuIEJ1dCBpZiB3ZSBhZHZlcnRp
c2UgWFJHQiBhbmQgdGhlIHNjYW5vdXQgYnVmZmVyIGlzIA0KcmVhbGx5IEFSR0IsIGFueSBn
YXJiYWdlIGluIHRoZSBYIGZpbGxlciBieXRlIHdvdWxkIGludGVyZmVyZS4NCg0KSWYgd2Ug
aGF2ZSBhIG5hdGl2ZSBBUkdCIHNjYW5vdXQgYnVmZmVyLCB3ZSBjb3VsZCBhZHZlcnRpc2Ug
WFJHQiB0byANCnVzZXJzcGFjZSBhbmQgc2V0IHRoZSBmaWxsZXIgYnl0ZSB1bmNvbmRpdGlv
bmFsbHkgZHVyaW5nIHRoZSBwYWdlZmxpcCANCnN0ZXAuIFRoYXQgc2hvdWxkIGJlIHNhZmUg
b24gYWxsIGhhcmR3YXJlLg0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQo+IA0KPiBZb3Un
ZCBmaW5kIHRoaXMgbW9zdGx5IGluICJlbWJlZGRlZCIgZGlzcGxheSBjaGlwcy4NCj4gDQo+
IA0KPiBUaGFua3MsDQo+IHBxDQo+IA0KPj4gQmVmb3JlIHJlbW92aW5nIHRoZSBleHRyYSBu
b24tQSBmb3JtYXRzLCB3ZSBmaXJzdCBoYXZlIHRvIGZpeCB0aGUgZmJkZXYNCj4+IGNvbnNv
bGUncyBmb3JtYXQgc2VsZWN0aW9uLiBTbyBpZiB1c2VycyBzZXQgdmlkZW89LTI0IHdpdGhv
dXQgbmF0aXZlDQo+PiBoYXJkd2FyZSBzdXBwb3J0LCBzaW1wbGVkcm0gKGFuZCBhbnkgb3Ro
ZXIgZHJpdmVyKSBmYWxscyBiYWNrIHRvIGENCj4+IHN1cHBvcnRlZCBmb3JtYXQuIFRoaXMg
d29ya2VkIHdpdGggdGhlIG9sZCBmYmRldiBkcml2ZXJzLCBzdWNoIGFzDQo+PiBzaW1wbGVm
YiBhbmQgZWZpZmIsIGFuZCBzb21lIHVzZXJzIGV4cGVjdCBpdC4NCj4+DQo+PiBJZiBub3Ro
aW5nIGVsc2UgY29tZXMgaW4sIEknbGwgbWVyZ2UgeW91ciBwYXRjaCBvbiBNb25kYXkuDQo+
Pg0KPj4gQmVzdCByZWdhcmRzDQo+PiBUaG9tYXMNCg0KLS0gDQpUaG9tYXMgWmltbWVybWFu
bg0KR3JhcGhpY3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMg
R2VybWFueSBHbWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkN
CihIUkIgMzY4MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90
ZXYNCg==

--------------vNeDTCH9Xq3OTneeQ57ybLEH--

--------------ISP6ZAnOBi8elFTzO6WZS1LZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNbmJ0FAwAAAAAACgkQlh/E3EQov+C+
eQ//cJFMsCwY34/cnzjjmsD5znrg8jCNDe1O3K7AaX+HQyv8JC5r9do4M15FrYfm4/9T6McXblTS
HXfBLT6pzQoybdSb8DRT6kgb8mLgEdYET+cv2RCIU3++YdUirclcFJNnEjZirwbl530MR4UCyLAv
b1iS5r5gL5OrC6BJP8naSOQ5zPU/LMTCYs+MnPrUxFy0k9t1uklvbgO1mbdTeyQo1AdRcIzO1CPZ
5X70B6gx5qi8AovmYgdkGzDKAbofsT8EiLDQFumKttYDCH4s3leGdblOoWZySQAAkIaus+aYsNt8
r32/hYKBL9e2eIv7JaTpIFsYmKjd4XPWYHXC8/WInxibhGfEqXbiKuInXSmPcU5+EycFocsYP12R
g6hvxeLRDma6UWQZmL7Mqat3SKy0VMUSbiC7lguWwwFZ0OSh69Ri/3miyG/86zLo9vLaF3vkiGWW
Zl0LHbI9Huz3C90WLtKb2nE4PjTi+syiGaoJe+Mp4ujVfyyV8EgLUuy3eBIJ1wC/1pv9x5Yv2J9k
tNDCJ/30n2dGqC5S41OeA7yTJQMr5klf3HfZI55pP01kr/n5xQWcpPVrH3QkeN9Vz8YVLCpPnlet
3aKQ4l/e2+mVAfwkX46/Lc2kbwFCQMeYzbhjdVcC3SHtsoTqiVaqVuWoNR8eT8hOX/foqb/NzOE3
7aU=
=Oh4c
-----END PGP SIGNATURE-----

--------------ISP6ZAnOBi8elFTzO6WZS1LZ--

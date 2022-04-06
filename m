Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E304F65E5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbiDFQvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238171AbiDFQur (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:50:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C36432F0A5
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 07:59:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nc77e-0001Ut-Ts; Wed, 06 Apr 2022 16:59:02 +0200
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nc77f-001R0l-Cl; Wed, 06 Apr 2022 16:59:01 +0200
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nc77d-000A86-3L; Wed, 06 Apr 2022 16:59:01 +0200
Message-ID: <219003f3341412cc6241d8c6e73309a74836678d.camel@pengutronix.de>
Subject: Re: [PATCH v4 2/2] media: coda: Add more H264 levels for CODA960
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>, hverkuil-cisco@xs4all.nl
Cc:     nicolas.dufresne@collabora.com, kernel@iktek.de,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@denx.de>
Date:   Wed, 06 Apr 2022 16:59:01 +0200
In-Reply-To: <20220405135957.3580343-2-festevam@gmail.com>
References: <20220405135957.3580343-1-festevam@gmail.com>
         <20220405135957.3580343-2-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmFiaW8sCgpPbiBEaSwgMjAyMi0wNC0wNSBhdCAxMDo1OSAtMDMwMCwgRmFiaW8gRXN0ZXZh
bSB3cm90ZToKPiBGcm9tOiBOaWNvbGFzIER1ZnJlc25lIDxuaWNvbGFzLmR1ZnJlc25lQGNvbGxh
Ym9yYS5jb20+Cj4gCj4gVGhpcyBhZGQgSDI2NCBsZXZlbCA0LjEsIDQuMiBhbmQgNS4wIHRvIHRo
ZSBsaXN0IG9mIHN1cHBvcnRlZAo+IGZvcm1hdHMuCj4gV2hpbGUgdGhlIGhhcmR3YXJlIGRvZXMg
bm90IGZ1bGx5IHN1cHBvcnQgdGhlc2UgbGV2ZWxzLCBpdCBkbyBzdXBwb3J0Cj4gbW9zdCBvZiB0
aGVtLiBUaGUgY29uc3RyYWludHMgb24gZnJhbWUgc2l6ZSBhbmQgcGl4ZWwgZm9ybWF0cyBhbHJl
YWR5Cj4gY292ZXIgdGhlIGxpbWl0YXRpb24uCj4gCj4gVGhpcyBmaXhlcyBuZWdvdGlhdGlvbiBv
ZiBsZXZlbCBvbiBHU3RyZWFtZXIgMS4xNy4xLgo+IAo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnCj4gRml4ZXM6IDQyYTY4MDEyZTY3YzIgKCJtZWRpYTogY29kYTogYWRkIHJlYWQtb25seSBo
LjI2NCBkZWNvZGVyCj4gcHJvZmlsZS9sZXZlbCBjb250cm9scyIpCj4gU2lnbmVkLW9mZi1ieTog
Tmljb2xhcyBEdWZyZXNuZSA8bmljb2xhcy5kdWZyZXNuZUBjb2xsYWJvcmEuY29tPgo+IFNpZ25l
ZC1vZmYtYnk6IEV6ZXF1aWVsIEdhcmNpYSA8ZXplcXVpZWxAY29sbGFib3JhLmNvbT4KPiBUZXN0
ZWQtYnk6IFBhc2NhbCBTcGVjayA8a2VybmVsQGlrdGVrLmRlPgo+IFNpZ25lZC1vZmYtYnk6IEZh
YmlvIEVzdGV2YW0gPGZlc3RldmFtQGRlbnguZGU+Cj4gUmV2aWV3ZWQtYnk6IFBoaWxpcHAgWmFi
ZWwgPHAuemFiZWxAcGVuZ3V0cm9uaXguZGU+Cj4gLS0tCj4gQ2hhbmdlcyBzaW5jZSB2MzoKPiAt
IFJlYmFzZWQgYWdhaW5zdCBsaW51eC1uZXh0IGFuZCB0b29rIHRoZSBjb2RhLT5jaGlwcy1tZWRp
YSByZW5hbWUKPiBpbiBjb25zaWRlcmF0aW9uLgo+IC0gQWRkZWQgUGhpbGlwcCdzIFJldmlld2Vk
LWJ5IHRhZy4KCkkgdGhpbmsgeW91IHJlYmFzZWQgdGhlIHdyb25nIHZlcnNpb24gb2YgdGhpcyBw
YXRjaC4KCj4gwqBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2NoaXBzLW1lZGlhL2NvZGEtY29tbW9u
LmMgfCA3ICsrKysrLS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vY2hpcHMt
bWVkaWEvY29kYS1jb21tb24uYwo+IGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9jaGlwcy1tZWRp
YS9jb2RhLWNvbW1vbi5jCj4gaW5kZXggNTNiMmRkMWIyNjhjLi5mMTIzNGFkMjRmNjUgMTAwNjQ0
Cj4gLS0tIGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9jaGlwcy1tZWRpYS9jb2RhLWNvbW1vbi5j
Cj4gKysrIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9jaGlwcy1tZWRpYS9jb2RhLWNvbW1vbi5j
Cj4gQEAgLTIzNjQsNyArMjM2NCwxMCBAQCBzdGF0aWMgdm9pZCBjb2RhX2VuY29kZV9jdHJscyhz
dHJ1Y3QgY29kYV9jdHgKPiAqY3R4KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgICgxIDw8IFY0TDJfTVBFR19WSURFT19IMjY0X0xFVkVMXzNfMCkg
fAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgx
IDw8IFY0TDJfTVBFR19WSURFT19IMjY0X0xFVkVMXzNfMSkgfAo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgxIDw8IFY0TDJfTVBFR19WSURFT19I
MjY0X0xFVkVMXzNfMikgfAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfNF8wKSksCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoMSA8PCBWNEwy
X01QRUdfVklERU9fSDI2NF9MRVZFTF80XzApIHwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgxIDw8IFY0TDJfTVBFR19WSURFT19IMjY0X0xFVkVM
XzRfMSkgfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfNF8yKSB8Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoMSA8PCBWNEwyX01QRUdfVklE
RU9fSDI2NF9MRVZFTF81XzApKSwKCkkgYXNrZWQgdG8gcmVtb3ZlIHRoZSA1LjAgbGV2ZWwgYW5k
IHRvIGluY3JlYXNlIHRoZSBtYXggbGV2ZWwgdG8gNC4yLAp5b3UgYWxyZWFkeSBmaXhlZCB0aGlz
IGluIHYzLgoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBWNEwyX01QRUdfVklERU9fSDI2NF9MRVZFTF80XzApOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4g
wqDCoMKgwqDCoMKgwqDCoHY0bDJfY3RybF9uZXdfc3RkKCZjdHgtPmN0cmxzLCAmY29kYV9jdHJs
X29wcywKPiBAQCAtMjQzNyw3ICsyNDQwLDcgQEAgc3RhdGljIHZvaWQgY29kYV9kZWNvZGVfY3Ry
bHMoc3RydWN0IGNvZGFfY3R4Cj4gKmN0eCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN0eC0+
ZGV2LT5kZXZ0eXBlLT5wcm9kdWN0ID09IENPREFfNzU0MSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoG1heCA9IFY0TDJfTVBFR19WSURFT19IMjY0X0xFVkVMXzRfMDsKPiDCoMKg
wqDCoMKgwqDCoMKgZWxzZSBpZiAoY3R4LT5kZXYtPmRldnR5cGUtPnByb2R1Y3QgPT0gQ09EQV85
NjApCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1heCA9IFY0TDJfTVBFR19WSURF
T19IMjY0X0xFVkVMXzRfMTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWF4ID0g
VjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfNV8wOwoKU2FtZSBhcyBhYm92ZSwgdGhlcmUgaXMg
bm8gd2F5IHRvIHN1cHBvcnQgbGV2ZWwgNS4wIGZyYW1lIHNpemUKcmVxdWlyZW1lbnRzLgoKcmVn
YXJkcwpQaGlsaXBwCg==


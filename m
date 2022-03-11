Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C154D5E8E
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 10:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbiCKJgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 04:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbiCKJgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 04:36:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69091BE105
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 01:35:29 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nSbgE-0003Pw-H3; Fri, 11 Mar 2022 10:35:26 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nSbgE-0001SK-OO; Fri, 11 Mar 2022 10:35:25 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nSbgC-0002tS-Hw; Fri, 11 Mar 2022 10:35:24 +0100
Message-ID: <e44d9964784fe5b00697373531ab8fbad5bdf990.camel@pengutronix.de>
Subject: Re: [PATCH v3 2/2] media: coda: Add more H264 levels for CODA960
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>, hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, nicolas.dufresne@collabora.com,
        ezequiel@collabora.com, kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Date:   Fri, 11 Mar 2022 10:35:24 +0100
In-Reply-To: <20220309173636.1879419-2-festevam@gmail.com>
References: <20220309173636.1879419-1-festevam@gmail.com>
         <20220309173636.1879419-2-festevam@gmail.com>
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

T24gTWksIDIwMjItMDMtMDkgYXQgMTQ6MzYgLTAzMDAsIEZhYmlvIEVzdGV2YW0gd3JvdGU6Cj4g
RnJvbTogTmljb2xhcyBEdWZyZXNuZSA8bmljb2xhcy5kdWZyZXNuZUBjb2xsYWJvcmEuY29tPgo+
IAo+IEFkZCBIMjY0IGxldmVsIDEuMCwgNC4xLCA0LjIgdG8gdGhlIGxpc3Qgb2Ygc3VwcG9ydGVk
IGZvcm1hdHMuCj4gV2hpbGUgdGhlIGhhcmR3YXJlIGRvZXMgbm90IGZ1bGx5IHN1cHBvcnQgdGhl
c2UgbGV2ZWxzLCBpdCBkb2VzCj4gc3VwcG9ydAo+IG1vc3Qgb2YgdGhlbS4gVGhlIGNvbnN0cmFp
bnRzIG9uIGZyYW1lIHNpemUgYW5kIHBpeGVsIGZvcm1hdHMgYWxyZWFkeQo+IGNvdmVyIHRoZSBs
aW1pdGF0aW9uLgo+IAo+IFRoaXMgZml4ZXMgbmVnb3RpYXRpb24gb2YgbGV2ZWwgb24gR1N0cmVh
bWVyIDEuMTcuMS4KPiAKPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwo+IEZpeGVzOiA0MmE2
ODAxMmU2N2MyICgibWVkaWE6IGNvZGE6IGFkZCByZWFkLW9ubHkgaC4yNjQgZGVjb2Rlcgo+IHBy
b2ZpbGUvbGV2ZWwgY29udHJvbHMiKQo+IFN1Z2dlc3RlZC1ieTogUGhpbGlwcCBaYWJlbCA8cC56
YWJlbEBwZW5ndXRyb25peC5kZT4KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIER1ZnJlc25lIDxu
aWNvbGFzLmR1ZnJlc25lQGNvbGxhYm9yYS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogRXplcXVpZWwg
R2FyY2lhIDxlemVxdWllbEBjb2xsYWJvcmEuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEZhYmlvIEVz
dGV2YW0gPGZlc3RldmFtQGRlbnguZGU+Cj4gLS0tCj4gQ2hhbmdlcyBzaW5jZSB2MjoKPiAtIFJl
bW92ZSA1LjAgbGV2ZWwgYW5kIHVzZSBQaGlsbGlwJ3Mgc3VnZ2VzdGlvbiB0byBnZXQgdGhlIGNv
cnJlY3QKPiBsZXZlbHMKPiBiZWluZyByZXBvcnRlZCBieSB2NGwyaDI2NGVuYzoKPiAKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGgyNjRfbGV2ZWwgMHgwMDk5MGE2
NyAobWVudSnCoMKgIDogbWluPTAgbWF4PTEzCj4gZGVmYXVsdD0xMSB2YWx1ZT0xMQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAwOiAxCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoDU6IDIKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgODogMwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA5OiAzLjEKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgMTA6IDMuMgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAxMTogNAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAxMjogNC4xCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDEzOiA0
LjIKPiAKPiDCoGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vY29kYS9jb2RhLWNvbW1vbi5jIHwgOSAr
KysrKystLS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vY29kYS9jb2RhLWNv
bW1vbi5jCj4gYi9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL2NvZGEvY29kYS1jb21tb24uYwo+IGlu
ZGV4IDI4MGQ3N2YxNTY3Yy4uZGE4YmMxZjg3YmEwIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWVk
aWEvcGxhdGZvcm0vY29kYS9jb2RhLWNvbW1vbi5jCj4gKysrIGIvZHJpdmVycy9tZWRpYS9wbGF0
Zm9ybS9jb2RhL2NvZGEtY29tbW9uLmMKPiBAQCAtMjM0OSwxMiArMjM0OSwxNSBAQCBzdGF0aWMg
dm9pZCBjb2RhX2VuY29kZV9jdHJscyhzdHJ1Y3QgY29kYV9jdHgKPiAqY3R4KQo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAoY3R4LT5kZXYtPmRldnR5cGUtPnByb2R1Y3QgPT0gQ09EQV85NjApIHsKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHY0bDJfY3RybF9uZXdfc3RkX21lbnUoJmN0
eC0+Y3RybHMsICZjb2RhX2N0cmxfb3BzLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoFY0TDJfQ0lEX01QRUdfVklERU9fSDI2NF9MRVZFTCwKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFY0TDJfTVBFR19WSURF
T19IMjY0X0xFVkVMXzRfMCwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoH4oKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfMl8wKSB8Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBWNEwyX01QRUdfVklE
RU9fSDI2NF9MRVZFTF80XzIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB+KCgxIDw8IFY0TDJfTVBFR19WSURFT19IMjY0X0xFVkVMXzFfMCkgfAo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRM
Ml9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfMl8wKSB8Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVW
RUxfM18wKSB8Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfM18xKSB8Cj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVH
X1ZJREVPX0gyNjRfTEVWRUxfM18yKSB8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAoMSA8PCBWNEwyX01QRUdfVklERU9fSDI2NF9MRVZFTF80XzAp
KSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgx
IDw8IFY0TDJfTVBFR19WSURFT19IMjY0X0xFVkVMXzRfMCkgfAo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gy
NjRfTEVWRUxfNF8xKSB8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAoMSA8PCBWNEwyX01QRUdfVklERU9fSDI2NF9MRVZFTF80XzIpKSwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBWNEwyX01QRUdfVklE
RU9fSDI2NF9MRVZFTF80XzApOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqDCoMKgwqDCoMKgwqDC
oHY0bDJfY3RybF9uZXdfc3RkKCZjdHgtPmN0cmxzLCAmY29kYV9jdHJsX29wcywKClJldmlld2Vk
LWJ5OiBQaGlsaXBwIFphYmVsIDxwLnphYmVsQHBlbmd1dHJvbml4LmRlPgoKcmVnYXJkcwpQaGls
aXBwCg==


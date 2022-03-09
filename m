Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F844D345A
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiCIQYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238393AbiCIQWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:22:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA494E10
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:21:01 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nRz3b-000514-1o; Wed, 09 Mar 2022 17:20:59 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nRz3a-003iS3-Mo; Wed, 09 Mar 2022 17:20:57 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nRz3Y-000Bo7-Al; Wed, 09 Mar 2022 17:20:56 +0100
Message-ID: <d75bbdb1fd01f0c1ff89efe1369860cfccc52f5f.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] media: coda: Add more H264 levels for CODA960
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>, hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, nicolas.dufresne@collabora.com,
        ezequiel@collabora.com, kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Date:   Wed, 09 Mar 2022 17:20:56 +0100
In-Reply-To: <20220309143322.1755281-2-festevam@gmail.com>
References: <20220309143322.1755281-1-festevam@gmail.com>
         <20220309143322.1755281-2-festevam@gmail.com>
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

T24gTWksIDIwMjItMDMtMDkgYXQgMTE6MzMgLTAzMDAsIEZhYmlvIEVzdGV2YW0gd3JvdGU6Cj4g
RnJvbTogTmljb2xhcyBEdWZyZXNuZSA8bmljb2xhcy5kdWZyZXNuZUBjb2xsYWJvcmEuY29tPgo+
IAo+IFRoaXMgYWRkIEgyNjQgbGV2ZWwgNC4xLCA0LjIgYW5kIDUuMCB0byB0aGUgbGlzdCBvZiBz
dXBwb3J0ZWQKPiBmb3JtYXRzLgo+IFdoaWxlIHRoZSBoYXJkd2FyZSBkb2VzIG5vdCBmdWxseSBz
dXBwb3J0IHRoZXNlIGxldmVscywgaXQgZG8gc3VwcG9ydAo+IG1vc3Qgb2YgdGhlbS4gVGhlIGNv
bnN0cmFpbnRzIG9uIGZyYW1lIHNpemUgYW5kIHBpeGVsIGZvcm1hdHMgYWxyZWFkeQo+IGNvdmVy
IHRoZSBsaW1pdGF0aW9uLgo+IAo+IFRoaXMgZml4ZXMgbmVnb3RpYXRpb24gb2YgbGV2ZWwgb24g
R1N0cmVhbWVyIDEuMTcuMS4KPiAKPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwo+IEZpeGVz
OiA0MmE2ODAxMmU2N2MyICgibWVkaWE6IGNvZGE6IGFkZCByZWFkLW9ubHkgaC4yNjQgZGVjb2Rl
cgo+IHByb2ZpbGUvbGV2ZWwgY29udHJvbHMiKQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRHVm
cmVzbmUgPG5pY29sYXMuZHVmcmVzbmVAY29sbGFib3JhLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBF
emVxdWllbCBHYXJjaWEgPGV6ZXF1aWVsQGNvbGxhYm9yYS5jb20+Cj4gVGVzdGVkLWJ5OiBQYXNj
YWwgU3BlY2sgPGtlcm5lbEBpa3Rlay5kZT4KPiBTaWduZWQtb2ZmLWJ5OiBGYWJpbyBFc3RldmFt
IDxmZXN0ZXZhbUBkZW54LmRlPgo+IC0tLQo+IENoYW5nZXMgc2luY2UgdjE6Cj4gLSBOb25lIC0g
b25seSBhZGRlZCBQYXNjYWwncyBUZXN0ZWQtYnkgdGFnLgo+IAo+IMKgZHJpdmVycy9tZWRpYS9w
bGF0Zm9ybS9jb2RhL2NvZGEtY29tbW9uLmMgfCA3ICsrKysrLS0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWVkaWEvcGxhdGZvcm0vY29kYS9jb2RhLWNvbW1vbi5jCj4gYi9kcml2ZXJzL21lZGlhL3Bs
YXRmb3JtL2NvZGEvY29kYS1jb21tb24uYwo+IGluZGV4IDUzYjJkZDFiMjY4Yy4uZjEyMzRhZDI0
ZjY1IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vY29kYS9jb2RhLWNvbW1v
bi5jCj4gKysrIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9jb2RhL2NvZGEtY29tbW9uLmMKPiBA
QCAtMjM2NCw3ICsyMzY0LDEwIEBAIHN0YXRpYyB2b2lkIGNvZGFfZW5jb2RlX2N0cmxzKHN0cnVj
dCBjb2RhX2N0eAo+ICpjdHgpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfM18wKSB8Cj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwg
VjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfM18xKSB8Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRf
TEVWRUxfM18yKSB8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAoMSA8PCBWNEwyX01QRUdfVklERU9fSDI2NF9MRVZFTF80XzApKSwKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgxIDw8IFY0TDJfTVBF
R19WSURFT19IMjY0X0xFVkVMXzRfMCkgfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKDEgPDwgVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfNF8x
KSB8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAo
MSA8PCBWNEwyX01QRUdfVklERU9fSDI2NF9MRVZFTF80XzIpIHwKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgxIDw8IFY0TDJfTVBFR19WSURFT19I
MjY0X0xFVkVMXzVfMCkpLAoKSSBzdGlsbCB0aGluayB0aGlzIGlzIHdyb25nIFsxXSwgdGhlIHZl
bmRvciBvbmx5IGFkdmVydGlzZXMgc3VwcG9ydCBmb3IKbGV2ZWwgNC4wLiBBdCBsZWFzdCBsZXZl
bCA1LjAgbXVzdCBiZSBkcm9wcGVkLCBhcyB3ZSBkb24ndCBzdXBwb3J0IHRoZQpmcmFtZSBzaXpl
IHJlcXVpcmVtZW50LgoKWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8xMTA5ODBmZWE5
YzI0ZWU0NDk0ODdiNWQyODgyMmRjY2Y3OTYyNDk0LmNhbWVsQHBlbmd1dHJvbml4LmRlLyN0Cgo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFY0TDJfTVBF
R19WSURFT19IMjY0X0xFVkVMXzRfMCk7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKg
wqDCoMKgdjRsMl9jdHJsX25ld19zdGQoJmN0eC0+Y3RybHMsICZjb2RhX2N0cmxfb3BzLAo+IEBA
IC0yNDM3LDcgKzI0NDAsNyBAQCBzdGF0aWMgdm9pZCBjb2RhX2RlY29kZV9jdHJscyhzdHJ1Y3Qg
Y29kYV9jdHgKPiAqY3R4KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3R4LT5kZXYtPmRldnR5
cGUtPnByb2R1Y3QgPT0gQ09EQV83NTQxKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgbWF4ID0gVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVWRUxfNF8wOwo+IMKgwqDCoMKgwqDCoMKg
wqBlbHNlIGlmIChjdHgtPmRldi0+ZGV2dHlwZS0+cHJvZHVjdCA9PSBDT0RBXzk2MCkKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWF4ID0gVjRMMl9NUEVHX1ZJREVPX0gyNjRfTEVW
RUxfNF8xOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtYXggPSBWNEwyX01QRUdf
VklERU9fSDI2NF9MRVZFTF81XzA7CgpJJ20gbm90IHNvIHN1cmUgYWJvdXQgdGhpcyBvbmUsIGJ1
dCBJIHRoaW5rIGl0IGlzIHdyb25nIGFzIHdlbGwsIGZvcgp0aGUgc2FtZSByZWFzb24uIE5pY29s
YXMgd2FudGVkIHRvIHJlZHVjZSB0aGlzIHRvIGxldmVsIDQuMiBpbiB2MiBbMl0uCgpbMl0gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2Y0MDlkNGRkYWQwYTM1MmNhN2VjODQ2OTljOTRhNjRl
NWRiZjA0MDcuY2FtZWxAY29sbGFib3JhLmNvbS8KCnJlZ2FyZHMKUGhpbGlwcAo=


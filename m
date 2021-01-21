Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5FA2FE2C9
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 07:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbhAUG0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 01:26:12 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41940 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726925AbhAUGZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 01:25:53 -0500
X-UUID: db84775019e34fb48449a98a5c0c0a27-20210121
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=u/2JBongcc8EOmFCMEZfjQxigadfi0DwujXfFHAcodo=;
        b=Bqwxte2tZ3n/5PkJnk6mDiQxGlK9q9hgB/NtFzAcYjH6fV5CE6S5dMQvQLs1j7XI1rFVEerUSEfI1o9cRopO8LnuHjyAaymhUUQwu0yieLdHrjJM3jHLpFkC+JjrJTjUbK7Hw0fDXB9YQ8/Yo5IscPslStq53FS5hkq0kNoqRQ4=;
X-UUID: db84775019e34fb48449a98a5c0c0a27-20210121
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <skylake.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1202323220; Thu, 21 Jan 2021 14:24:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 21 Jan 2021 14:24:53 +0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 21 Jan 2021 14:24:53 +0800
Message-ID: <1611210278.32249.12.camel@mtksdccf07>
Subject: Re: [PATCH v2] dts64: mt7622: fix slow sd card access
From:   SkyLake Huang <skylake.huang@mediatek.com>
To:     Frank Wunderlich <linux@fw-web.de>
CC:     <linux-mediatek@lists.infradead.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "Jimin Wang" <jimin.wang@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        sin_wenjiehu <sin_wenjiehu@mediatek.com>,
        <Wenbin.Mei@mediatek.com>, <stable@vger.kernel.org>
Date:   Thu, 21 Jan 2021 14:24:38 +0800
In-Reply-To: <20210113180919.49523-1-linux@fw-web.de>
References: <20210113180919.49523-1-linux@fw-web.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIxLTAxLTEzIGF0IDE5OjA5ICswMTAwLCBGcmFuayBXdW5kZXJsaWNoIHdyb3Rl
Og0KPiBGcm9tOiBGcmFuayBXdW5kZXJsaWNoIDxmcmFuay13QHB1YmxpYy1maWxlcy5kZT4NCj4g
DQo+IEZpeCBleHRyZW1lIHNsb3cgc3BlZWQgKDIwME1CIHRha2VzIH4yMCBtaW4pIG9uIHdyaXRp
bmcgc2RjYXJkIG9uDQo+IGJhbmFuYXBpLXI2NCBieSBhZGRpbmcgcmVzZXQtY29udHJvbCBmb3Ig
bW1jMSBsaWtlIGl0J3MgZG9uZSBmb3IgbW1jMC9lbW1jLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gRml4ZXM6IDJjMDAyYTMwNDlmNyAoImFybTY0OiBkdHM6IG10NzYyMjog
YWRkIG1tYyByZWxhdGVkIGRldmljZSBub2RlcyIpDQo+IFNpZ25lZC1vZmYtYnk6IEZyYW5rIFd1
bmRlcmxpY2ggPGZyYW5rLXdAcHVibGljLWZpbGVzLmRlPg0KPiAtLS0NCj4gY2hhbmdlcyBzaW5j
ZSB2MToNCj4gIC0gZHJvcCBjaGFuZ2UgdG8gdWhzLW1vZGUgYmVjYXVzZSBtdDc2MjIgZG9lcyBu
b3Qgc3VwcG9ydCBpdA0KPiAtLS0NCj4gIGFyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3
NjIyLmR0c2kgfCAyICsrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDc2MjIuZHRzaSBi
L2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLmR0c2kNCj4gaW5kZXggNWI5ZWMw
MzJjZThkLi43YzZkODcxNTM4YTYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMv
bWVkaWF0ZWsvbXQ3NjIyLmR0c2kNCj4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRl
ay9tdDc2MjIuZHRzaQ0KPiBAQCAtNjk4LDYgKzY5OCw4IEBAIG1tYzE6IG1tY0AxMTI0MDAwMCB7
DQo+ICAJCWNsb2NrcyA9IDwmcGVyaWNmZyBDTEtfUEVSSV9NU0RDMzBfMV9QRD4sDQo+ICAJCQkg
PCZ0b3Bja2dlbiBDTEtfVE9QX0FYSV9TRUw+Ow0KPiAgCQljbG9jay1uYW1lcyA9ICJzb3VyY2Ui
LCAiaGNsayI7DQo+ICsJCXJlc2V0cyA9IDwmcGVyaWNmZyBNVDc2MjJfUEVSSV9NU0RDMV9TV19S
U1Q+Ow0KPiArCQlyZXNldC1uYW1lcyA9ICJocnN0IjsNClRoaXMgbG9va3Mgb2sgdG8gbWUuIEkg
dGhpbmsgaXQncyBhbHNvIG5lY2Vzc2FyeSB0byB0cmlnZ2VyIHNvZnR3YXJlDQpyZXNldCBmb3Ig
U0QobW1jMSkgYmVjYXVzZSBsb2FkZXIodWJvb3QpIG1pZ2h0IG1lc3MgdXAgTVNEQydzIHJlZ2lz
dGVycy4NCiJTb2Z0d2FyZSByZXNldCIgaGVyZSB3aWxsIHJlc2V0IHJlZ2lzdGVycyBvZiBBSEIv
QVhJIGJ1cyBkb21haW4sIHN1Y2gNCmFzIE1TRENfQ0ZHWzg6MTVdLiBtc2RjX3Jlc2V0X2h3KCkg
aW4gbXRrLXNkLmMgd2lsbCBvbmx5IHJlc2V0IHJlZ2lzdGVycw0Kb2YgTVNEQyBDSyBkb21haW4u
DQo=


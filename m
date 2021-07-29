Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6683D9C5D
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 05:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhG2Dmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 23:42:39 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:48088 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233553AbhG2Dmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 23:42:38 -0400
X-UUID: b7c7981fbe13443dad4c914c3cb8bc6f-20210729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=g/h6d5ht0Kz0+npXpy03sIdKmA8QrRfO6V6rBdcyB/E=;
        b=rtc7fWTZ1a/NQaHEu0naUj1+QF6Q9N22WuGae/iTfkcWw71ghZrira85urEdjDYaesMBevS27+Hh1nngrxiwY4eAqqzzHkpimNTOmCC0cv39TZMfu/zfoStpXOSVNtGoQqMkKrL7giifII/fz0qZWEmnRKdrCybySgEctnFNJLM=;
X-UUID: b7c7981fbe13443dad4c914c3cb8bc6f-20210729
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <ck.hu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 996941046; Thu, 29 Jul 2021 11:42:33 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Jul 2021 11:42:31 +0800
Received: from [172.21.77.4] (172.21.77.4) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 11:42:31 +0800
Message-ID: <1627530151.32756.9.camel@mtksdaap41>
Subject: Re: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
From:   CK Hu <ck.hu@mediatek.com>
To:     Hsin-Yi Wang <hsinyi@chromium.org>
CC:     Frank Wunderlich <linux@fw-web.de>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Date:   Thu, 29 Jul 2021 11:42:31 +0800
In-Reply-To: <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
References: <20210727174025.10552-1-linux@fw-web.de>
         <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksIEhzaW4teWk6DQoNCk9uIFRodSwgMjAyMS0wNy0yOSBhdCAxMToxNSArMDgwMCwgSHNpbi1Z
aSBXYW5nIHdyb3RlOg0KPiBPbiBXZWQsIEp1bCAyOCwgMjAyMSBhdCAxOjQxIEFNIEZyYW5rIFd1
bmRlcmxpY2ggPGxpbnV4QGZ3LXdlYi5kZT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBDSyBIdSA8
Y2suaHVAbWVkaWF0ZWsuY29tPg0KPiA+DQo+ID4gU09VVCBoYXMgbWFueSBiaXRzIGFuZCBuZWVk
IHRvIGJlIGNsZWFyZWQgYmVmb3JlIHNldCBuZXcgdmFsdWUuDQo+ID4gV3JpdGUgb25seSBjb3Vs
ZCBkbyB0aGUgY2xlYXIsIGJ1dCBmb3IgTU9VVCwgaXQgY2xlYXJzIGJpdHMgdGhhdA0KPiA+IHNo
b3VsZCBub3QgYmUgY2xlYXJlZC4gU28gdXNlIGEgbWFzayB0byByZXNldCBvbmx5IHRoZSBuZWVk
ZWQgYml0cy4NCj4gPg0KPiA+IHRoaXMgZml4ZXMgSERNSSBpc3N1ZXMgb24gTVQ3NjIzL0JQSS1S
MiBzaW5jZSA1LjEzDQo+ID4NCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IEZp
eGVzOiA0NDAxNDc2MzlhYzcgKCJzb2M6IG1lZGlhdGVrOiBtbXN5czogVXNlIGFuIGFycmF5IGZv
ciBzZXR0aW5nIHRoZSByb3V0aW5nIHJlZ2lzdGVycyIpDQo+ID4gU2lnbmVkLW9mZi1ieTogRnJh
bmsgV3VuZGVybGljaCA8ZnJhbmstd0BwdWJsaWMtZmlsZXMuZGU+DQo+ID4gU2lnbmVkLW9mZi1i
eTogQ0sgSHUgPGNrLmh1QG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiBjb2RlIGlzIHRha2Vu
IGZyb20gaGVyZSAodXBzdHJlYW1lZCB3aXRob3V0IG1hc2sgcGFydCkNCj4gPiBodHRwczovL3Vy
bGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9jaHJvbWl1bS1yZXZpZXcuZ29vZ2xlc291cmNlLmNv
bS9jL2Nocm9taXVtb3MvdGhpcmRfcGFydHkva2VybmVsLyovMjM0NTE4Ni81X187S3chIUNUUk5L
QTl3TWcwQVJidyExZWJ4MkZqckhucXZPcXczSGRWeU1NWWNFVWl2TmJ4UklPaTFfRFhNV3dmeEpI
eDQ1TnlLSS1EdDRNdm8xZyQgDQo+ID4gYmFzaWNseSBDSyBIdSdzIGNvZGUgc28gaSBzZXQgaGlt
IGFzIGF1dGhvcg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3NvYy9tZWRpYXRlay9tdGstbW1zeXMu
YyB8ICAgNyArLQ0KPiA+ICBkcml2ZXJzL3NvYy9tZWRpYXRlay9tdGstbW1zeXMuaCB8IDEzMyAr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgOTgg
aW5zZXJ0aW9ucygrKSwgNDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zb2MvbWVkaWF0ZWsvbXRrLW1tc3lzLmMgYi9kcml2ZXJzL3NvYy9tZWRpYXRlay9tdGst
bW1zeXMuYw0KPiA+IGluZGV4IDA4MDY2MGVmMTFiZi4uMGY5NDk4OTZmZDA2IDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvc29jL21lZGlhdGVrL210ay1tbXN5cy5jDQo+ID4gKysrIGIvZHJpdmVy
cy9zb2MvbWVkaWF0ZWsvbXRrLW1tc3lzLmMNCj4gPiBAQCAtNjgsNyArNjgsOSBAQCB2b2lkIG10
a19tbXN5c19kZHBfY29ubmVjdChzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4NCj4gPiAgICAgICAg
IGZvciAoaSA9IDA7IGkgPCBtbXN5cy0+ZGF0YS0+bnVtX3JvdXRlczsgaSsrKQ0KPiA+ICAgICAg
ICAgICAgICAgICBpZiAoY3VyID09IHJvdXRlc1tpXS5mcm9tX2NvbXAgJiYgbmV4dCA9PSByb3V0
ZXNbaV0udG9fY29tcCkgew0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHJlZyA9IHJlYWRs
X3JlbGF4ZWQobW1zeXMtPnJlZ3MgKyByb3V0ZXNbaV0uYWRkcikgfCByb3V0ZXNbaV0udmFsOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJlZyA9IHJlYWRsX3JlbGF4ZWQobW1zeXMtPnJl
Z3MgKyByb3V0ZXNbaV0uYWRkcik7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmVnICY9
IH5yb3V0ZXNbaV0ubWFzazsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZWcgfD0gcm91
dGVzW2ldLnZhbDsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICB3cml0ZWxfcmVsYXhlZChy
ZWcsIG1tc3lzLT5yZWdzICsgcm91dGVzW2ldLmFkZHIpOw0KPiA+ICAgICAgICAgICAgICAgICB9
DQo+ID4gIH0NCj4gPiBAQCAtODUsNyArODcsOCBAQCB2b2lkIG10a19tbXN5c19kZHBfZGlzY29u
bmVjdChzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4NCj4gPiAgICAgICAgIGZvciAoaSA9IDA7IGkg
PCBtbXN5cy0+ZGF0YS0+bnVtX3JvdXRlczsgaSsrKQ0KPiA+ICAgICAgICAgICAgICAgICBpZiAo
Y3VyID09IHJvdXRlc1tpXS5mcm9tX2NvbXAgJiYgbmV4dCA9PSByb3V0ZXNbaV0udG9fY29tcCkg
ew0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHJlZyA9IHJlYWRsX3JlbGF4ZWQobW1zeXMt
PnJlZ3MgKyByb3V0ZXNbaV0uYWRkcikgJiB+cm91dGVzW2ldLnZhbDsNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICByZWcgPSByZWFkbF9yZWxheGVkKG1tc3lzLT5yZWdzICsgcm91dGVzW2ld
LmFkZHIpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJlZyAmPSB+cm91dGVzW2ldLm1h
c2s7DQo+IA0KPiBUaGlzIHBhdGNoIGlzIGJyZWFraW5nIHRoZSBtdDgxODMgaW50ZXJuYWwgZGlz
cGxheS4gSSB0aGluayBpdCdzDQo+IGJlY2F1c2UgIH5yb3V0ZXNbaV0udmFsOyBpcyByZW1vdmVk
Pw0KPiBBbHNvIHdoYXQgc2hvdWxkIHRoZSByb3V0ZXNbaV0ubWFzayBiZSBpZiBpdCdzIG5vdCBz
ZXQgaW4NCj4gbW1zeXNfbXQ4MTgzX3JvdXRpbmdfdGFibGU/DQoNCkknbSBub3Qgc3VyZSB0aGlz
IHByb2JsZW0gaXMgYWJvdXQgTU9VVCBvciBTT1VULiBCdXQgZm9yIE1PVVQsIGl0J3Mgbm90DQpu
ZWNlc3NhcnkgdG8gc2V0IG1hc2sgYmVjYXVzZSB0aGUgdmFsdWUgaXMgZXF1YWwgdG8gbWFzay4g
VG8gbWFrZSB0aGlucw0Kc2ltcGxlLCB0aGUgY29kZSBjb3VsZCBiZQ0KDQovKiBGb3IgTU9VVCwg
IHZhbHVlIGlzIGVxdWFsIHRvIG1hc2ssIHNvIG1hc2sgaXMgMCBhbmQgY2xlYXIgdGhlIHZhbHVl
DQoqLw0KcmVnICY9IH5yb3V0ZXNbaV0ubWFzayAmIH5yb3V0ZXNbaV0udmFsOw0KDQpSZWdhcmRz
LA0KQ0sNCj4gDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgd3JpdGVsX3JlbGF4ZWQocmVn
LCBtbXN5cy0+cmVncyArIHJvdXRlc1tpXS5hZGRyKTsNCj4gPiAgICAgICAgICAgICAgICAgfQ0K
PiA+ICB9DQo+IDxzbmlwPg0KDQo=


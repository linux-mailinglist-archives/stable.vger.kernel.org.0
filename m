Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C5435640A
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 08:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbhDGGf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 02:35:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3517 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345216AbhDGGfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 02:35:54 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FFZNP6mZ2zRZHy;
        Wed,  7 Apr 2021 14:33:41 +0800 (CST)
Received: from dggpemm100007.china.huawei.com (7.185.36.116) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 7 Apr 2021 14:35:41 +0800
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggpemm100007.china.huawei.com (7.185.36.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 14:35:41 +0800
Received: from dggpeml500016.china.huawei.com ([7.185.36.70]) by
 dggpeml500016.china.huawei.com ([7.185.36.70]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 14:35:41 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     David Woodhouse <dwmw2@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] iommu/vt-d: Force to flush iotlb before creating
 superpage
Thread-Topic: [PATCH] iommu/vt-d: Force to flush iotlb before creating
 superpage
Thread-Index: AQHXJsdJgAXY3vlVHUqi4t5f0DX/hKqgIfAAgAh+GPA=
Date:   Wed, 7 Apr 2021 06:35:41 +0000
Message-ID: <611cb5849c9a497b8289004dddb71150@huawei.com>
References: <20210401071834.1639-1-longpeng2@huawei.com>
 <9c368419-6e45-6b27-0f34-26b581589fa7@linux.intel.com>
In-Reply-To: <9c368419-6e45-6b27-0f34-26b581589fa7@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.151.207]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQmFvbHUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHUgQmFv
bHUgW21haWx0bzpiYW9sdS5sdUBsaW51eC5pbnRlbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgQXBy
aWwgMiwgMjAyMSAxMjo0NCBQTQ0KPiBUbzogTG9uZ3BlbmcgKE1pa2UsIENsb3VkIEluZnJhc3Ry
dWN0dXJlIFNlcnZpY2UgUHJvZHVjdCBEZXB0LikNCj4gPGxvbmdwZW5nMkBodWF3ZWkuY29tPjsg
aW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNCj4gQ2M6IGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbTsgRGF2aWQgV29vZGhvdXNl
IDxkd213MkBpbmZyYWRlYWQub3JnPjsgTmFkYXYNCj4gQW1pdCA8bmFkYXYuYW1pdEBnbWFpbC5j
b20+OyBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPjsNCj4gS2V2
aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+OyBHb25nbGVpIChBcmVpKSA8YXJlaS5nb25n
bGVpQGh1YXdlaS5jb20+Ow0KPiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0hdIGlvbW11L3Z0LWQ6IEZvcmNlIHRvIGZsdXNoIGlvdGxiIGJlZm9yZSBjcmVhdGlu
ZyBzdXBlcnBhZ2UNCj4gDQo+IEhpIExvbmdwZW5nLA0KPiANCj4gT24gNC8xLzIxIDM6MTggUE0s
IExvbmdwZW5nKE1pa2UpIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2lu
dGVsL2lvbW11LmMgYi9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMNCj4gPiBpbmRleCBlZTA5
MzIzLi5jYmNiNDM0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+IEBAIC0yMzQyLDkg
KzIzNDIsMjAgQEAgc3RhdGljIGlubGluZSBpbnQgaGFyZHdhcmVfbGFyZ2VwYWdlX2NhcHMoc3Ry
dWN0DQo+IGRtYXJfZG9tYWluICpkb21haW4sDQo+ID4gICAJCQkJICogcmVtb3ZlZCB0byBtYWtl
IHJvb20gZm9yIHN1cGVycGFnZShzKS4NCj4gPiAgIAkJCQkgKiBXZSdyZSBhZGRpbmcgbmV3IGxh
cmdlIHBhZ2VzLCBzbyBtYWtlIHN1cmUNCj4gPiAgIAkJCQkgKiB3ZSBkb24ndCByZW1vdmUgdGhl
aXIgcGFyZW50IHRhYmxlcy4NCj4gPiArCQkJCSAqDQo+ID4gKwkJCQkgKiBXZSBhbHNvIG5lZWQg
dG8gZmx1c2ggdGhlIGlvdGxiIGJlZm9yZSBjcmVhdGluZw0KPiA+ICsJCQkJICogc3VwZXJwYWdl
IHRvIGVuc3VyZSBpdCBkb2VzIG5vdCBwZXJzZXJ2ZXMgYW55DQo+ID4gKwkJCQkgKiBvYnNvbGV0
ZSBpbmZvLg0KPiA+ICAgCQkJCSAqLw0KPiA+IC0JCQkJZG1hX3B0ZV9mcmVlX3BhZ2V0YWJsZShk
b21haW4sIGlvdl9wZm4sIGVuZF9wZm4sDQo+ID4gLQkJCQkJCSAgICAgICBsYXJnZXBhZ2VfbHZs
ICsgMSk7DQo+ID4gKwkJCQlpZiAoZG1hX3B0ZV9wcmVzZW50KHB0ZSkpIHsNCj4gDQo+IFRoZSBk
bWFfcHRlX2ZyZWVfcGFnZXRhYmxlKCkgY2xlYXJzIGEgYmF0Y2ggb2YgUFRFcy4gU28gY2hlY2tp
bmcgY3VycmVudCBQVEUgaXMNCj4gaW5zdWZmaWNpZW50LiBIb3cgYWJvdXQgcmVtb3ZpbmcgdGhp
cyBjaGVjayBhbmQgYWx3YXlzIHBlcmZvcm1pbmcgY2FjaGUNCj4gaW52YWxpZGF0aW9uPw0KPiAN
Cg0KVW0uLi50aGUgUFRFIGhlcmUgbWF5IGJlIHByZXNlbnQoIGUuZy4gNEsgbWFwcGluZyAtLT4g
c3VwZXJwYWdlIG1hcHBpbmcgKSBvciBOT1QtcHJlc2VudCAoIGUuZy4gY3JlYXRlIGEgdG90YWxs
eSBuZXcgc3VwZXJwYWdlIG1hcHBpbmcgKSwgYnV0IHdlIG9ubHkgbmVlZCB0byBjYWxsIGZyZWVf
cGFnZXRhYmxlIGFuZCBmbHVzaF9pb3RsYiBpbiB0aGUgZm9ybWVyIGNhc2UsIHJpZ2h0ID8NCg0K
PiA+ICsJCQkJCWludCBpOw0KPiA+ICsNCj4gPiArCQkJCQlkbWFfcHRlX2ZyZWVfcGFnZXRhYmxl
KGRvbWFpbiwgaW92X3BmbiwgZW5kX3BmbiwNCj4gPiArCQkJCQkJCSAgICAgICBsYXJnZXBhZ2Vf
bHZsICsgMSk7DQo+ID4gKwkJCQkJZm9yX2VhY2hfZG9tYWluX2lvbW11KGksIGRvbWFpbikNCj4g
PiArCQkJCQkJaW9tbXVfZmx1c2hfaW90bGJfcHNpKGdfaW9tbXVzW2ldLCBkb21haW4sDQo+ID4g
KwkJCQkJCQkJICAgICAgaW92X3BmbiwgbnJfcGFnZXMsIDAsIDApOw0KPiA+ICsNCj4gDQo+IEJl
c3QgcmVnYXJkcywNCj4gYmFvbHUNCg==

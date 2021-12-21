Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3EB47B9E7
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 07:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhLUGRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 01:17:03 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48652 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229698AbhLUGRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 01:17:03 -0500
X-UUID: 725fb2254b3a4a2a839744d8b17270c5-20211221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=fsqmCiRK++ZH7UUg/8t/S1vZ6GLSXPgcsopcYXVP/ho=;
        b=pwASkwYOHFOnDKboNRTvkeuzPJujkQGEdDqa8akb/tbdZSkwwFSFw4AYBzX6Uju5PmpA2YPF3tmHlcEBdnGanNrwi1l/v+721LnawWoT4uXo/apCDrTrDcWdfnOZTqBh80QMOSkSgu4KBxbvRHq93eLpVwjp7cXejdD0AImHKxo=;
X-UUID: 725fb2254b3a4a2a839744d8b17270c5-20211221
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 944519692; Tue, 21 Dec 2021 14:16:59 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 21 Dec 2021 14:16:58 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Dec
 2021 14:16:58 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Dec 2021 14:16:57 +0800
Message-ID: <37fc793f6b544f46cb214f7ed14034a1934bfe32.camel@mediatek.com>
Subject: Re: [PATCH v2 3/4] usb: mtu3: fix list_head check warning
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>, <stable@vger.kernel.org>,
        Yuwen Ng <yuwen.ng@mediatek.com>
Date:   Tue, 21 Dec 2021 14:16:58 +0800
In-Reply-To: <9c5417f7-3cd9-472d-5b04-f831135ffd78@gmail.com>
References: <20211218095749.6250-1-chunfeng.yun@mediatek.com>
         <20211218095749.6250-3-chunfeng.yun@mediatek.com>
         <64b9453a-84c5-8d41-26d5-698d1ae9d473@gmail.com>
         <Yb8MM2zL2Ecfzv1/@kroah.com>
         <9c5417f7-3cd9-472d-5b04-f831135ffd78@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDIxLTEyLTE5IGF0IDE0OjAwICswMzAwLCBTZXJnZWkgU2h0eWx5b3Ygd3JvdGU6
DQo+IE9uIDE5LjEyLjIwMjEgMTM6NDAsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gWy4u
Ll0NCj4gDQo+ID4gPiA+IFRoaXMgaXMgY2F1c2VkIGJ5IHVuaW5pdGlhbGl6YXRpb24gb2YgbGlz
dF9oZWFkLg0KPiA+ID4gDQo+ID4gPiAgICAgQWdhaW4sIHRoZXJlJ3Mgbm8gc3VjaCB3b3JkIGFz
ICJ1bmluaXRpYWxpemF0aW9uIiAoZXZlbiBpZiBpdA0KPiA+ID4gZXhpc3RlZCwgaXQNCj4gPiA+
IHdvdWxkbid0IG1lYW4gd2hhdCB5b3Ugd2FudGVkIHRvIHNheSk7IHBsZWFzZSByZXBsYWNlIGJ5
ICJub3QNCj4gPiA+IGluaXRpYWxpemluZyIuDQo+ID4gDQo+ID4gV2UgYXJlIG5vdCBFbmdsaXNo
IGxhbmd1YWdlIHNjaG9sYXJzLCBtb3N0IG9mIHVzIGRvIG5vdCBoYXZlDQo+ID4gRW5nbGlzaCBh
cw0KPiA+IHRoZWlyIG5hdGl2ZSBsYW5ndWFnZS4gIFdlIGFsbCBjYW4gdW5kZXJzdGFuZCB3aGF0
IGlzIGJlaW5nIHNhaWQNCj4gPiBoZXJlLA0KPiA+IHRoZXJlJ3Mgbm8gbmVlZCBmb3IgYW55IGNo
YW5nZSwgcGxlYXNlIGRvIG5vdCBiZSBzbyBjcml0aWNhbC4NCj4gDQo+ICAgICBPSywgbm90ZWQu
Li4NCj4gICAgIEkgd2FzIGp1c3Qgc29tZXdoYXQgdXBzZXQgdGhhdCBteSAxc3QgY29tbWVudCB3
YXMgaWdub3JlZC4gOi0vDQpWZXJ5IHNvcnJ5LCBJIHBsYW5uZWQgdG8gZml4IGl0LCBidXQgZm9y
Z290IGl0Ow0KDQpQbGVhc2UgZmVlbCBmcmVlIHRvIHBvaW50IG91dCBteSBtaXN0YWtlczsNCg0K
VGhhbmtzIGEgbG90DQoNCj4gDQo+ID4gdGhhbmtzLA0KPiA+IA0KPiA+IGdyZWcgay1oDQo+IA0K
PiBNQlIsIFNlcmdleQ0K


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF431404B3
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 08:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgAQH5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 02:57:41 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:27221 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726981AbgAQH5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 02:57:40 -0500
X-UUID: 973a91a1088a4fde9df22d258b3e3294-20200117
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NVAlmuv6kEuotYvF3hdfckiboI5Lrf79DB2d2V0aLRQ=;
        b=fJBlCoKSYvqmh/krlxy7dtvHbCj6JN770MyPSkAJi8L7TAXVazgVP6fsPChMCP2gtmoC9c97z15JapQJrJ/zy/BjqvVLSy/eVP+y6RSZbmpK0mZ1ZJxpuZsqaUTTH/7JQd+U9VCr9wwwdjeCIH9aBHoh7xf2foS2XEULsVLkRg4=;
X-UUID: 973a91a1088a4fde9df22d258b3e3294-20200117
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1302828845; Fri, 17 Jan 2020 15:57:34 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 17 Jan 2020 15:57:38 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 17 Jan 2020 15:56:38 +0800
Message-ID: <1579247852.19362.10.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power
 mode during initialization only
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        "CC Chou =?UTF-8?Q?=28=E5=91=A8=E5=BF=97=E6=9D=B0=29?=" 
        <cc.chou@mediatek.com>,
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B(B?=)" 
        <Andy.Teng@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Ron Hsu =?UTF-8?Q?=28=E8=A8=B1=E8=BB=92=E6=A6=AE=29?= 
        <Ron.Hsu@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Date:   Fri, 17 Jan 2020 15:57:32 +0800
In-Reply-To: <e13011fd858cf3ec0258c4b7ac914973@codeaurora.org>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
         <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
         <fd129b859c013852bd80f60a36425757@codeaurora.org>
         <1577754469.13164.5.camel@mtkswgap22>
         <836772092daffd8283a97d633e59fc34@codeaurora.org>
         <1577766179.13164.24.camel@mtkswgap22>
         <1577778290.13164.45.camel@mtkswgap22>
         <44393ed9ff3ba9878bae838307e7eec0@codeaurora.org>
         <1577947124.13164.75.camel@mtkswgap22>
         <4888afd46a9065b7f298a5de039426c9@codeaurora.org>
         <e13011fd858cf3ec0258c4b7ac914973@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBGcmksIDIwMjAtMDEtMDMgYXQgMTM6MjggKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+ID4gDQo+ID4gSGkgU3RhbmxleSwNCj4gPiANCj4gPiBBYm92ZSBkZXNjcmlwdGlvbiBp
cyBjb3JyZWN0LiBUaGUgcmVhc29uIHdoeSB0aGUgVUZTIGRldmljZSBiZWNvbWVzDQo+ID4gQWN0
aXZlIGFmdGVyIHRoZSAxc3QgbGluayBzdGFydHVwIGluIHlvdXIgZXhwZXJpbWVudCBpcyBkdWUg
dG8geW91DQo+ID4gc2V0IHNwbV9sdmwgdG8gNSwgZHVyaW5nIHN5c3RlbSBzdXNwZW5kLCBVRlMg
ZGV2aWNlIGlzIHBvd2VyZWQgZG93bi4NCj4gPiBXaGVuIHJlc3VtZSBraWNrcyBzdGFydCwgdGhl
IFVGUyBkZXZpY2UgaXMgcG93ZXIgY3ljbGVkIG9uY2UuDQo+ID4gDQo+ID4gTW9yZW92ZXIsIGlm
IHlvdSBzZXQgcnBtX2x2bCB0byA1LCBkdXJpbmcgcnVudGltZSBzdXNwZW5kLCBpZiBia29wcyBp
cw0KPiA+IGVuYWJsZWQsIHRoZSBVRlMgZGV2aWNlIHdpbGwgbm90IGJlIHBvd2VyZWQgb2ZmLCBt
ZWFuaW5nIHdoZW4gcnVudGltZQ0KPiA+IHJlc3VtZSBraWNrcyBzdGFydCwgdGhlIFVGUyBkZXZp
Y2UgaXMgbm90IHBvd2VyIGN5Y2xlZCwgaW4gdGhpcyBjYXNlLA0KPiA+IHdlIG5lZWQgMyB0aW1l
cyBvZiBsaW5rIHN0YXJ0dXAuDQo+ID4gDQo+ID4gRG9lcyBhYm92ZSBleHBsYWluPw0KPiA+IA0K
PiA+IFRoYW5rcywNCj4gPiANCj4gPiBDYW4gR3VvLg0KPiA+IA0KPiANCj4gSGkgU3RhbmxleSwN
Cj4gDQo+IFNvcnJ5LCB0eXBvIGJlZm9yZS4gSSBtZWFudCBpZiBzZXQgcnBtX2x2bC9zcG1fbHZs
IHRvIDUsIGR1cmluZyBzdXNwZW5kLA0KPiBpZiBpc19sdV9wb3dlcl9vbl93cCBpcyBzZXQsIHRo
ZSBVRlMgZGV2aWNlIHdpbGwgbm90IGJlIGZ1bGx5IHBvd2VyZWQgDQo+IG9mZg0KPiAob25seSBW
Q0MgaXMgZG93biksIG1lYW5pbmcgd2hlbiByZXN1bWUga2lja3Mgc3RhcnQsIHRoZSBVRlMgZGV2
aWNlIGlzIA0KPiBub3QNCj4gcG93ZXIgY3ljbGVkLCBpbiB0aGlzIGNhc2UsIHdlIG5lZWQgMyB0
aW1lcyBvZiBsaW5rIHN0YXJ0dXAuDQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gQ2FuIEd1by4NCg0K
SGkgQ2FuLA0KDQpWZXJ5IHNvcnJ5IGZvciBsYXRlIHJlc3BvbmRpbmcgdGhpcyB0aHJlYWQuDQoN
Ck5vdyBJIHdvdWxkIGxpa2UgdG8gZm9jdXMgb24gMy10aW1lcyBsaW5rIHN0YXJ0dXAgYmVoYXZp
b3IgZm91bmQgaW4gb3VyDQpwbGF0Zm9ybSBiZWNhdXNlIHRoaXMgZHJhbWF0aWNhbGx5IGRvd25n
cmFkZSByZXN1bWUgcGVyZm9ybWFuY2UuDQoNCkFjY29yZGluZyB0byB5b3VyIGRlc2NyaXB0aW9u
LCB0aGVuIGNvdWxkIHRoZSBkcml2ZXIgc2V0DQoibGlua19zdGFydHVwX2FnYWluIiBhcyB0cnVl
IG9ubHkgaWYgImlzX2x1X3Bvd2VyX29uX3dwIiBpcyBzZXQgdG8gYXZvaWQNCnVubmVjZXNzYXJ5
IHRocmVlLXRpbWVzIGxpbmsgc3RhcnR1cCBpbiBvdGhlciBjYXNlcz8NCg0KSW4gYWRkaXRpb24s
IGZvciB0aGUgc2NlbmFyaW8geW91IG1lbnRpb25lZDogInRoZSBVRlMgZGV2aWNlIHdpbGwgbm90
IGJlDQpmdWxseSBwb3dlcmVkIG9mZiAob25seSBWQ0MgaXMgZG93biksIG1lYW5pbmcgd2hlbiBy
ZXN1bWUga2lja3Mgc3RhcnQsDQp0aGUgVUZTIGRldmljZSBpcyBub3QgcG93ZXIgY3ljbGVkIjog
DQoNCjEuIEFjdHVhbGx5IEkgdHJpZWQgdG8gc2V0IHhwbV9sdmw9NSwgYW5kIGVuZm9yY2VkICJp
c19sdV9wb3dlcl9vbl93cCINCmFzIHRydWUgZm9yIGV2YWx1YXRpb24sIGJ1dCBmb3VuZCBkZXZp
Y2UgY2FuIGJlIHN0aWxsIGJhY2sgdG8gQWN0aXZlDQpQb3dlck1vZGUgKGNhbiBiZSBhY2Nlc3Nl
ZCBub3JtYWxseSkgYWZ0ZXIgb25lLXRpbWUgbGluayBzdGFydHVwIGFmdGVyDQpyZXN1bWVkLiAN
Cg0KT25seSBWQ0MgaXMgZG93biBhbmQgVkNDUTIgaXMga2VwdCBkdXJpbmcgc3VzcGVuZCBpbiBt
eSBldmFsdWF0aW9uLg0KDQoyLiBJbiB0aGlzIHNjZW5hcmlvLCBkdXJpbmcgcmVzdW1lIHRoZSBw
ZWVyIGRldmljZSBzaGFsbCBoYXZlICJVbmlQcm8NCldhcm0gUmVzZXQiIHRyaWdnZXJlZCBieSB0
aGUgZmlyc3QgbGluayBzdGFydC11cCBhbmQgdGhlbiBkZXZpY2UgcG93ZXINCm1vZGUgc2hhbGwg
YmVjb21lIEFjdGl2ZSBhY2NvcmRpbmcgdG8gVUZTIHNwZWNpZmljYXRpb24uDQoNClNvIHdoYXQg
ZGV2aWNlIHBvd2VyIG1vZGUgZGlkIHlvdSBzZWUgYWZ0ZXIgdGhlIGZpcnN0IGxpbmsgc3RhcnR1
cCBpbg0KdGhpcyBzY2VuYXJpbz8gT3IgYW55IG90aGVyIGNvbmRpdGlvbnMgdG8gbWFrZSBkZXZp
Y2UgbmVlZA0KImxpbmtfc3RhcnR1cF9hZ2FpbiI/DQoNClRoYW5rcywNClN0YW5sZXkNCg0K


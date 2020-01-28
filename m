Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880E814BF90
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 19:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgA1SYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 13:24:03 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:56550 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbgA1SYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 13:24:03 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 29E91C0664;
        Tue, 28 Jan 2020 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580235842; bh=6eeTy7ey1G8nCI7yBVqNlt6ut370YBbQZLpRB4CRIF0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NQsUUpf9/IaZkiTBUpy51YK4Ij6YfKjVk38H4rike7LPqsVwQmFR6YnDoc4d/mweu
         tXPOB6GmOGyGtqm2lfa+ZypVCp4p9t7TUBGt+wuvTd4CTgrOPouvU6kvv6LPOwsIl2
         NMUjEL/VtRB7QAZGtj0E9RDY+SzQfSehsRhl2ZNrBwFZIg2598NNiTf9YuZ2KcIpnY
         JPRyKIFy5wvolf6Ftn7GtQvJ5DzJXRyRwR0Atv0i4/yQsjGgdh2Ldf8W2+d8Pw5FXx
         pkd00eHUGik7aLHQoF8saOSWUByA69oc3Rtu/LgBQ1aGra2L0hzuj7D4mhfvysXofL
         BfAaKXJrDkZZQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DA1EDA00A3;
        Tue, 28 Jan 2020 18:23:59 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 28 Jan 2020 10:23:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 28 Jan 2020 10:23:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RB/6HVgXMbuKohodVLESiaFVvfkNyQcYvvBZJ4uMgJl7rt4o42ZBG3M9EfuDzq+wQrAJ4BQtpkcWlXahiinuLYXIEZbfHp/Q7TBY1rJuzsW3T/Hci55rC8KrvSG3rXpWXwvHORGs7jJ516A34R17thXLvRsDhRZ2q+l5oe0exYSAZSl7lkkZyOEJhBDKeq5bE1XmYUHINl5og0NkvXRtEZOqlhsuKN+sI9eAZzaCywKIu3Ti2Po0Fzd0ZQis5jg3NY0hG3NAHYrfzEbGYxU2SVL8nTyIOJHml+Fhr5s6sx21WlnW+BAH5Y/k1u9PJ7RLWHyNUe6npxgqK8ZDGhqx7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eeTy7ey1G8nCI7yBVqNlt6ut370YBbQZLpRB4CRIF0=;
 b=UoPsNkh6W/1bAzz9SMcBO/mgycMPt//GEGHu4/EU7uiki5OZTF5QSG3PRRPhSK6DtJ0E10TGR6EuNkhvbdj1sfcfAL6TW37v58ecDXu4CBvDc1WCLz64hmPszRjZjm/uAbhIEz5w6EemRKp/qkTJxeNcT+vGtMy7mYV0bw+wBTJkS7uK3Fs/QA29ySjB1OSCpjhtFWXow9Za+ow+M9nTtPMGn6ja/S10sdTEvpLMtfZ6iP7CLUWl4PefaySHk2eiZo0JEncAA+/zfcUtw8iRAtEBf3gmk9qY3h6v3BHd7rfZh/tZlIcc5+hSVsfQbOod5wkH+nADCtP7XL4vkr/EfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eeTy7ey1G8nCI7yBVqNlt6ut370YBbQZLpRB4CRIF0=;
 b=c80fPbgANm9fkUzy82SHHi51VZsUErFfDVJv4gqmBYIruNd1qWRE77Pem0YWY9qD27g8+ojDvlg5QZwel7ytL7Geh4mMyQR6Hq3upd2wW1hz7rN4btLTMBOtfqh51AydpLQ3j5242v0fCoiy/BrAGKVxxXcc+rDFU+G2bETaskA=
Received: from BYAPR12MB2710.namprd12.prod.outlook.com (20.177.124.11) by
 BYAPR12MB3336.namprd12.prod.outlook.com (20.178.53.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Tue, 28 Jan 2020 18:23:53 +0000
Received: from BYAPR12MB2710.namprd12.prod.outlook.com
 ([fe80::6cae:8d93:540f:1593]) by BYAPR12MB2710.namprd12.prod.outlook.com
 ([fe80::6cae:8d93:540f:1593%3]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 18:23:53 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
CC:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        "Andrzej Pietrasiewicz" <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Linux USB List" <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl
 fields
Thread-Topic: [PATCH v2] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl
 fields
Thread-Index: AQHV1UhfPBULg1xTS0etamGDA83JAqgAEYcAgABUFwA=
Date:   Tue, 28 Jan 2020 18:23:53 +0000
Message-ID: <dfb83e3d-7e78-9568-6bed-f4ee67f90c69@synopsys.com>
References: <20200127193046.110258-1-john.stultz@linaro.org>
 <87sgjz90lt.fsf@kernel.org>
In-Reply-To: <87sgjz90lt.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e10110ca-ab1a-4746-b11e-08d7a41f3af1
x-ms-traffictypediagnostic: BYAPR12MB3336:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3336819A5859DB43484A8003AA0A0@BYAPR12MB3336.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(346002)(376002)(366004)(199004)(189003)(64756008)(26005)(186003)(86362001)(36756003)(478600001)(316002)(66556008)(66476007)(81156014)(4326008)(8676002)(76116006)(2906002)(66446008)(66946007)(8936002)(81166006)(7416002)(54906003)(110136005)(2616005)(71200400001)(6512007)(31696002)(31686004)(6506007)(6486002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3336;H:BYAPR12MB2710.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iONewOQExHl9UO2m4yY/Qwy6ADNMETDMCteH/nVYeFaMCtUy+Id89O2m77603MxE8jzx+OesFB+fRqmpc7/2FfbgvdGhic337YgMd9SJZlap56rIazcJYOCR4I+s2V+tK1oxNif8NxL/HfQZQraHXHddS/KnzJeG7FmMpTrIJq0omGH+uiCHBZFEo+T594xqS9G+xjNEI824/DrSRMLQIqzm3HyCAvCxtciHpOZwGK63jhiCTccIlvP0NQ5j/4rvvApxauXhL97SeFSEHLeraBRrQGQjd0+4jGRV+2uKNXpYt2HVdrpchMHBE1Nq/t1NGAjKFWksCl6M5Am3xAhYUAdiQkXOlFK2BJK+OmZ++MqJK7cnt0O5nvL6nOH8UGzZMF9hRvO/+x2uoPz4JGpEJSyVR30JXxrPUOSwkYpgAFqgSpwt47B2DWwdT8+spBqz
x-ms-exchange-antispam-messagedata: F/PBpLJaGzMbSFfmhYrjQYq0oLkCVN7TBwpUQBaMviIWtcCtwAjaYvsejS88w5sucm68b/3Lj0+FCg1FZ6yhNFCPMJKXlk30kOvqSdRAAzM+oNmQ8YBBLNF5tkdhB2ZlA837nzT3aCzkd+Qsqe5r7A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E5DC99CEA22DD47926297ED9DA66484@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e10110ca-ab1a-4746-b11e-08d7a41f3af1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 18:23:53.4864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tcWprI1p5TWZUDnW+NUXKvCGtiQEAAPnbyQkeFccYmoQeACH7/IlAIs4ijiXEFssahd7QvK4Sfxb6/gtn8Nhiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3336
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCkZlbGlwZSBCYWxiaSB3cm90ZToNCj4gSGksDQo+DQo+IEpvaG4gU3R1bHR6IDxqb2hu
LnN0dWx0ekBsaW5hcm8ub3JnPiB3cml0ZXM6DQo+DQo+PiBGcm9tOiBBbnVyYWcgS3VtYXIgVnVs
aXNoYSA8YW51cmFnLmt1bWFyLnZ1bGlzaGFAeGlsaW54LmNvbT4NCj4+DQo+PiBUaGUgY3VycmVu
dCBjb2RlIGluIGR3YzNfZ2FkZ2V0X2VwX3JlY2xhaW1fY29tcGxldGVkX3RyYigpIHdpbGwNCj4+
IGNoZWNrIGZvciBJT0MvTFNUIGJpdCBpbiB0aGUgZXZlbnQtPnN0YXR1cyBhbmQgcmV0dXJucyBp
Zg0KPj4gSU9DL0xTVCBiaXQgaXMgc2V0LiBUaGlzIGxvZ2ljIGRvZXNuJ3Qgd29yayBpZiBtdWx0
aXBsZSBUUkJzDQo+PiBhcmUgcXVldWVkIHBlciByZXF1ZXN0IGFuZCB0aGUgSU9DL0xTVCBiaXQg
aXMgc2V0IG9uIHRoZSBsYXN0DQo+PiBUUkIgb2YgdGhhdCByZXF1ZXN0Lg0KPj4NCj4+IENvbnNp
ZGVyIGFuIGV4YW1wbGUgd2hlcmUgYSBxdWV1ZWQgcmVxdWVzdCBoYXMgbXVsdGlwbGUgcXVldWVk
DQo+PiBUUkJzIGFuZCBJT0MvTFNUIGJpdCBpcyBzZXQgb25seSBmb3IgdGhlIGxhc3QgVFJCLiBJ
biB0aGlzIGNhc2UsDQo+PiB0aGUgY29yZSBnZW5lcmF0ZXMgWGZlckNvbXBsZXRlL1hmZXJJblBy
b2dyZXNzIGV2ZW50cyBvbmx5IGZvcg0KPj4gdGhlIGxhc3QgVFJCIChzaW5jZSBJT0MvTFNUIGFy
ZSBzZXQgb25seSBmb3IgdGhlIGxhc3QgVFJCKS4gQXMNCj4+IHBlciB0aGUgbG9naWMgaW4gZHdj
M19nYWRnZXRfZXBfcmVjbGFpbV9jb21wbGV0ZWRfdHJiKCkNCj4+IGV2ZW50LT5zdGF0dXMgaXMg
Y2hlY2tlZCBmb3IgSU9DL0xTVCBiaXQgYW5kIHJldHVybnMgb24gdGhlDQo+PiBmaXJzdCBUUkIu
IFRoaXMgbGVhdmVzIHRoZSByZW1haW5pbmcgVFJCcyBsZWZ0IHVuaGFuZGxlZC4NCj4+DQo+PiBT
aW1pbGFybHksIGlmIHRoZSBnYWRnZXQgZnVuY3Rpb24gZW5xdWV1ZXMgYW4gdW5hbGlnbmVkIHJl
cXVlc3QNCj4+IHdpdGggc2dsaXN0IGFscmVhZHkgaW4gaXQsIGl0IHNob3VsZCBmYWlsIHRoZSBz
YW1lIHdheSwgc2luY2Ugd2UNCj4+IHdpbGwgYXBwZW5kIGFub3RoZXIgVFJCIHRvIHNvbWV0aGlu
ZyB0aGF0IGFscmVhZHkgdXNlcyBtb3JlIHRoYW4NCj4+IG9uZSBUUkIuDQo+Pg0KPj4gVG8gYXZp
b2QgdGhpcywgdGhpcyBwYXRjaCBjaGFuZ2VzIHRoZSBjb2RlIHRvIGNoZWNrIGZvciBJT0MvTFNU
DQo+PiBiaXRzIGluIFRSQi0+Y3RybCBpbnN0ZWFkLg0KPj4NCj4+IEF0IGEgcHJhY3RpY2FsIGxl
dmVsLCB0aGlzIHBhdGNoIHJlc29sdmVzIFVTQiB0cmFuc2ZlciBzdGFsbHMgc2Vlbg0KPj4gd2l0
aCBhZGIgb24gZHdjMyBiYXNlZCBIaUtleTk2MCBhZnRlciBmdW5jdGlvbmZzIGdhZGdldCBhZGRl
ZA0KPj4gc2NhdHRlci1nYXRoZXIgc3VwcG9ydCBhcm91bmQgdjQuMjAuDQo+Pg0KPj4gQ2M6IEZl
bGlwZSBCYWxiaSA8YmFsYmlAa2VybmVsLm9yZz4NCj4+IENjOiBZYW5nIEZlaSA8ZmVpLnlhbmdA
aW50ZWwuY29tPg0KPj4gQ2M6IFRoaW5oIE5ndXllbiA8dGhpbmhuQHN5bm9wc3lzLmNvbT4NCj4+
IENjOiBUZWphcyBKb2dsZWthciA8dGVqYXMuam9nbGVrYXJAc3lub3BzeXMuY29tPg0KPj4gQ2M6
IEFuZHJ6ZWogUGlldHJhc2lld2ljeiA8YW5kcnplai5wQGNvbGxhYm9yYS5jb20+DQo+PiBDYzog
SmFjayBQaGFtIDxqYWNrcEBjb2RlYXVyb3JhLm9yZz4NCj4+IENjOiBUb2RkIEtqb3MgPHRram9z
QGdvb2dsZS5jb20+DQo+PiBDYzogR3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+
DQo+PiBDYzogTGludXggVVNCIExpc3QgPGxpbnV4LXVzYkB2Z2VyLmtlcm5lbC5vcmc+DQo+PiBD
Yzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4gVGVzdGVkLWJ5OiBUZWphcyBK
b2dsZWthciA8dGVqYXMuam9nbGVrYXJAc3lub3BzeXMuY29tPg0KPj4gUmV2aWV3ZWQtYnk6IFRo
aW5oIE5ndXllbiA8dGhpbmhuQHN5bm9wc3lzLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEFudXJh
ZyBLdW1hciBWdWxpc2hhIDxhbnVyYWcua3VtYXIudnVsaXNoYUB4aWxpbnguY29tPg0KPj4gW2pz
dHVsdHo6IGZvcndhcmQgcG9ydGVkIHRvIG1haW5saW5lLCByZXdvcmRlZCBjb21taXQgbG9nLCBy
ZXdvcmtlZA0KPj4gICB0byBvbmx5IGNoZWNrIHRyYi0+Y3RybCBhcyBzdWdnZXN0ZWQgYnkgRmVs
aXBlXQ0KPj4gU2lnbmVkLW9mZi1ieTogSm9obiBTdHVsdHogPGpvaG4uc3R1bHR6QGxpbmFyby5v
cmc+DQo+PiAtLS0NCj4+IHYyOg0KPj4gKiBSZXdvcmsgdG8gb25seSBjaGVjayB0cmItPmN0cmwg
YXMgc3VnZ2VzdGVkIGJ5IEZlbGlwZQ0KPj4gKiBSZXdvcmQgdGhlIGNvbW1pdCBtZXNzYWdlIHRv
IGluY2x1ZGUgbW9yZSBvZiBGZWxpcGUncyBhc3Nlc3NtZW50DQo+PiAtLS0NCj4+ICAgZHJpdmVy
cy91c2IvZHdjMy9nYWRnZXQuYyB8IDMgKystDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Iv
ZHdjMy9nYWRnZXQuYyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4+IGluZGV4IDE1NGYz
ZjNlOGNmZi4uOWEwODVlZWUxYWUzIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy91c2IvZHdjMy9n
YWRnZXQuYw0KPj4gKysrIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4gQEAgLTI0MjAs
NyArMjQyMCw4IEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRfZXBfcmVjbGFpbV9jb21wbGV0ZWRf
dHJiKHN0cnVjdCBkd2MzX2VwICpkZXAsDQo+PiAgIAlpZiAoZXZlbnQtPnN0YXR1cyAmIERFUEVW
VF9TVEFUVVNfU0hPUlQgJiYgIWNoYWluKQ0KPj4gICAJCXJldHVybiAxOw0KPj4gICANCj4+IC0J
aWYgKGV2ZW50LT5zdGF0dXMgJiBERVBFVlRfU1RBVFVTX0lPQykNCj4+ICsJaWYgKCh0cmItPmN0
cmwgJiBEV0MzX1RSQl9DVFJMX0lPQykgfHwNCj4+ICsJICAgICh0cmItPmN0cmwgJiBEV0MzX1RS
Ql9DVFJMX0xTVCkpDQo+IHdoeSB0aGUgTFNUIGJpdCBoZXJlPyBJdCB3YXNuJ3QgdGhlcmUgYmVm
b3JlLiBJbiBmYWN0LCB3ZSBuZXZlciBzZXQgTFNUDQo+IGluIGR3YzMgYW55bW9yZSA6LSkNCj4N
Cg0KSnVzdCBhIG5vdGU6IHJpZ2h0IG5vdywgaXQgbWF5IGJlIGZpbmUgZm9yIG5vbi1zdHJlYW0g
ZW5kcG9pbnRzIHRvIG5vdCANCnNldCB0aGUgTFNUIGJpdCBpbiB0aGUgVFJCcy4gRm9yIHN0cmVh
bXMsIHdlIG5lZWQgdG8gc2V0IHRoaXMgYml0IHNvIHRoZSANCmNvbnRyb2xsZXIga25vdyB0byBh
bGxvY2F0ZSByZXNvdXJjZSBmb3IgZGlmZmVyZW50IHRyYW5zZmVycyBvZiANCmRpZmZlcmVudCBz
dHJlYW1zLiBJdCBtYXkgYmUgZmluZSBub3cgaWYgeW91IHRoaW5rIHRoYXQgaXQgc2hvdWxkIGJl
IA0KYWRkZWQgbGF0ZXIgd2hlbiBtb3JlIGZpeGVzIGZvciBzdHJlYW1zIGFyZSBhZGRlZCwgYnV0
IEkgdGhpbmsgaXQgDQpkb2Vzbid0IGh1cnQgY2hlY2tpbmcgaXQgbm93IGVpdGhlci4NCg0KQlIs
DQpUaGluaA0K

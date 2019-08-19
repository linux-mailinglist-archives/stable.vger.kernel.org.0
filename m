Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D7495056
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfHSV6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 17:58:40 -0400
Received: from mail-eopbgr720131.outbound.protection.outlook.com ([40.107.72.131]:18592
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbfHSV6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 17:58:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGu7SdMCcxUkmlDolZooE5MHM3eeEbpgAKO7eZ3HPSWlRZlCOZfqynucJbJW89N2O1XkWa6KfnVELR2QIllbjTKU8lRX7TXCO4qWS1MwiiTMXGikVMxlb+pJj+KkPy8thC5rKMnYy/htUBphppnxzWNlZVr7yUF4ugi+lrSNqdCf37c4NkAKcPrCC5Bw+/i8HwBdxmXiURVF0cOZIXEsfbxiGR+g4lu7RXfIJsxCcHpasyF1JAIGSOugUwgJtnfPyEot6EPZO6s5ztSUXNp23iC6xlAKQNqUEJ1NzmodyOOh/RyYsw1kqxQ/fthSvGc7jeomhqrCOMDHcMA+mhoh1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFjP54vZWuSvei+Siz7dvFxIgo4b7q5FUgI8Mim7NjI=;
 b=DZJlVyuwramzTNdMfMtthN31QTZA+fMWek8S2pWd7w98RxMFYc2BB5P6dueJK4Obton70jPIJkHi90AS3UQdc1ITsDBctFw+02yQsBGyd+ZfWiQK0pMlEGVL/aHdapjCeDngtVLBldL27JIDPDrYDSNMl0EgzNlLmsP8FGgIpVuENnpqvxC0vJ8wxnTfuMlVnos+Mwk2U99VOBAH3bBvsD5aKsVNl6tiRvp6luuJsarHF3ZXDQ0ACgznHq7Rwq1UUDAR6SB3c/FfOw9kDzyFg8FplZnGdLioBHYn4tBu2S+JmZjUz4d6V94AeideUXJg+JNuY03co429ddgcZTyE3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFjP54vZWuSvei+Siz7dvFxIgo4b7q5FUgI8Mim7NjI=;
 b=XlqNKtjy5P8yrhFqp1rU7Gbdftf1S3ZFoXhvkL8a5a+Oi3O0JMcD5WhlVXiLq18tS+GuaxdTSunGbzTNLTEdaRpjiMYS8UnfuXG1MckqifEYOSK41Xg1s+oNRmyG6zsm2O3ogZkB7XgquSTkJX8laVAwb0jhUqvoCFGW6xho+SU=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0796.namprd21.prod.outlook.com (10.175.112.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.1; Mon, 19 Aug 2019 21:58:35 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::8985:a319:f21:530e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::c437:6219:efcc:fb8a%8]) with mapi id 15.20.2220.000; Mon, 19 Aug 2019
 21:58:35 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        tip-bot for Michael Kelley <tipbot@zytor.com>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [tip:irq/urgent] genirq: Properly pair kobject_del() with
 kobject_add()
Thread-Topic: [tip:irq/urgent] genirq: Properly pair kobject_del() with
 kobject_add()
Thread-Index: AQHVVpaWAFz9unahCkyCihJdmLkBdacC/MKAgAAHgUA=
Date:   Mon, 19 Aug 2019 21:58:34 +0000
Message-ID: <DM5PR21MB013781495B041A4FA6C8DCEAD7A80@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <tip-e1ee29624746fbf667f80e8ae3815a76e4d1bd5b@git.kernel.org>
 <20190819212758.6D03D22CEC@mail.kernel.org>
In-Reply-To: <20190819212758.6D03D22CEC@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-19T21:58:32.8572884Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8a4d0f22-e011-4226-9d10-0c0346f8ba2f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:edc7:4690:8678:e56f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c836a8a-3965-484c-23a5-08d724f061f3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM5PR21MB0796;
x-ms-traffictypediagnostic: DM5PR21MB0796:
x-microsoft-antispam-prvs: <DM5PR21MB0796FC8BE938BE63DDD75949D7A80@DM5PR21MB0796.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(8936002)(2501003)(7736002)(8676002)(305945005)(81166006)(102836004)(81156014)(186003)(6506007)(74316002)(46003)(22452003)(316002)(64756008)(66556008)(10290500003)(486006)(446003)(11346002)(476003)(71190400001)(71200400001)(6246003)(25786009)(4326008)(53936002)(478600001)(6436002)(76176011)(229853002)(86362001)(7696005)(5660300002)(8990500004)(52536014)(14454004)(55016002)(66476007)(66446008)(76116006)(9686003)(256004)(54906003)(110136005)(6116002)(2906002)(33656002)(66946007)(99286004)(10090500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0796;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Vc/y588XxxXkw4RB3qDpHKYxI2Lno/EsXK3U4tY7EAzRKl4D+o0uahANp2N2lorzFN9kl0yiiKr6EEbQCxt2YhEbLPb+P0FVc2o9rWdSE9nccYlroRTLOYNh7cwmj/AKhOE6fRARkCc0XQUY7i2C6TS9I/A/DYmhi858qavkH7XEZyn6dmh/r6rKZk+EGKpnugibzT7c63ShSmVUP2rQcsB7v23fO1cCe1s381JYNVS7X8zNHfnR8ENT+mbvuqK/XPyk0/iuE0DHZuJoQvdBq3Re5VVyFHO8uIcnKHkSc85H+uOaq9larUGpiszOHyi09uFuBnC/Lm+5cRQ8CafbmopeyX4YpK6W1TAEpGAZvNj99AJe07zg4dx55BKmYRwU2H/r+BOApQX/Ew5Q+BkQhYCRL+PSStoqtQxZic6DhZo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c836a8a-3965-484c-23a5-08d724f061f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 21:58:34.8890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 27rnR9zGKVGIGMDTGZ8IyIirqaRKFhsNuzOpiQDQhaUil0PDpmWCSj2T6bZ9mTsKjnMLfNH+PMtBDYleLbdOVl5p7QoEk9bFdJkvwfxKFfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0796
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPiAgU2VudDogTW9uZGF5LCBBdWd1
c3QgMTksIDIwMTkgMjoyOCBQTQ0KPiANCj4gVGhpcyBjb21taXQgaGFzIGJlZW4gcHJvY2Vzc2Vk
IGJlY2F1c2UgaXQgY29udGFpbnMgYSAiRml4ZXM6IiB0YWcsDQo+IGZpeGluZyBjb21taXQ6IGVj
YjNmMzk0YzVkYiBnZW5pcnE6IEV4cG9zZSBpbnRlcnJ1cHQgaW5mb3JtYXRpb24gdGhyb3VnaCBz
eXNmcy4NCj4gDQo+IFRoZSBib3QgaGFzIHRlc3RlZCB0aGUgZm9sbG93aW5nIHRyZWVzOiB2NS4y
LjksIHY0LjE5LjY3LCB2NC4xNC4xMzksIHY0LjkuMTg5Lg0KPiANCj4gdjUuMi45OiBCdWlsZCBm
YWlsZWQhIEVycm9yczoNCj4gICAgIGtlcm5lbC9pcnEvaXJxZGVzYy5jOjQ0Njo2OiBlcnJvcjog
4oCYaXJxX2tvYmpfYmFzZeKAmSB1bmRlY2xhcmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlv
bik7DQo+IGRpZCB5b3UgbWVhbiDigJhpcnFfa29ial90eXBl4oCZPw0KPiANCj4gdjQuMTkuNjc6
IEJ1aWxkIGZhaWxlZCEgRXJyb3JzOg0KPiAgICAga2VybmVsL2lycS9pcnFkZXNjLmM6NDQ1OjY6
IGVycm9yOiDigJhpcnFfa29ial9iYXNl4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlz
IGZ1bmN0aW9uKTsNCj4gZGlkIHlvdSBtZWFuIOKAmGlycV9rb2JqX3R5cGXigJk/DQo+IA0KPiB2
NC4xNC4xMzk6IEJ1aWxkIGZhaWxlZCEgRXJyb3JzOg0KPiAgICAga2VybmVsL2lycS9pcnFkZXNj
LmM6NDI4OjY6IGVycm9yOiDigJhpcnFfa29ial9iYXNl4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVz
ZSBpbiB0aGlzIGZ1bmN0aW9uKTsNCj4gZGlkIHlvdSBtZWFuIOKAmGlycV9rb2JqX3R5cGXigJk/
DQo+IA0KPiB2NC45LjE4OTogQnVpbGQgZmFpbGVkISBFcnJvcnM6DQo+ICAgICBrZXJuZWwvaXJx
L2lycWRlc2MuYzo0MTQ6NjogZXJyb3I6IOKAmGlycV9rb2JqX2Jhc2XigJkgdW5kZWNsYXJlZCAo
Zmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pOw0KPiBkaWQgeW91IG1lYW4g4oCYaXJxX2tvYmpf
dHlwZeKAmT8NCj4gDQo+IA0KPiBOT1RFOiBUaGUgcGF0Y2ggd2lsbCBub3QgYmUgcXVldWVkIHRv
IHN0YWJsZSB0cmVlcyB1bnRpbCBpdCBpcyB1cHN0cmVhbS4NCj4gDQo+IEhvdyBzaG91bGQgd2Ug
cHJvY2VlZCB3aXRoIHRoaXMgcGF0Y2g/DQoNCkNvbXBpbGUgZXJyb3Igb2NjdXJzIHdoZW4gQ09O
RklHX1NZU0ZTIGlzIG5vdCBzZWxlY3RlZC4gIEl0J3MgcHJvYmFibHkgY2xlYW5lc3QgdG8NCnJl
dmVydCB0aGUgY3VycmVudCBwYXRjaC4gICBJJ2xsIHNlbmQgb3V0IGEgbmV3IHZlcnNpb24gdGhh
dCBmaXhlcyB0aGUgcHJvYmxlbS4NCg0KTWljaGFlbA0K

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773652F5BED
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 09:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbhANIBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 03:01:18 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:51948 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727211AbhANIBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 03:01:17 -0500
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B5E3540477;
        Thu, 14 Jan 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610611216; bh=qz+nIWT1GR9r/613tPliAy7UX8n6P2vqt21a4rtIhzs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cxQj5ZIM5oBLRmjRHXfYgS7o+xc1VLtqxQ/TPD6NxzMmPCAw/RqpW8TxdzOpV6cbP
         jtIhEutuQ+kPo9USXe+tCRJoiY/sxa4hGuk25qcEO2wnIqY58UdJGQaFlmpjd0sYlV
         hSAgq409ZmguIbHtwrlDGiGp/HckQipa0WzFjkLhcUUsWQNq4bWgl7cJYn/3pnh4Bj
         vgQIVDSwz1O/2oy1xHdmlSMnVSBfbLzK7aWFi60S98iXk/EYwuomI8HKdPm2oLnlHc
         hPVZAup4WNWeXSNToxnuIW9rYv3G4JzEdMMnShp/mwRy9B7/PP/3YqPKHdCMbWtj2I
         c/M1Ni7+HisJQ==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3F606A0282;
        Thu, 14 Jan 2021 08:00:14 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 7E4C3802BD;
        Thu, 14 Jan 2021 08:00:12 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="VrVOXoqG";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6WkqvTWiJH+Bl62AEMckgFoB2l7HI1+fMsMq19cr1FeCjmHfWTbO8Izc9/q5hG8vx2/OGCszBQ/yEqWVfniZSVKkp8ecnWljMUdKe9EpSo5WaIP3vAg6H9U8Z6oA4dU1foy4jMBW6N1ao8/DmPDHpHGqAFCUeOHltjKP0H17wE5YwOr/M21UXStQhwZspI1Qhl9m5oJB161/cp2hKhysSX4BC6kGnYM+7AfjQJyk9EIBzLhfuF0rBvwfkVeZP951+mZvsPYl8Kwz1ULQepLBM0dCKD0FhGa9T1iaOgD4sYC3eXBCQi732UmVVhEtpMGXBaqQugpO87yFwNfEkGCWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz+nIWT1GR9r/613tPliAy7UX8n6P2vqt21a4rtIhzs=;
 b=hrfkXFTYHzzL3o6Sqxvm3nFGUHUix0niIRUozdoRIKlF0k1uO8pQNrou7gEqzvA+N9qGLIuig20NWj9LtsDRroQWTs840mv9T57+Hu5fMJFH4ZzfvZ1DhoDgR6IDFDMPh8FMRe5fPLNZETIeaYZA6wFh+YeqK4quxZnuvKm+i5Rc71N3DJIfnlEHTf446oYER9myrfM0sR1eShdiZrgaMjyHSPVi+5ODxbN/3c03TWsuhOEST6U90FXQASVWEeVbMkXXjMPPEehxaN9vbBC7MkFbNxelOd+Fv7c9xVTKBRRf81MxwrtMaQyTz0EDaQgUvoUdxZVxwxQWkt2QD9vqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz+nIWT1GR9r/613tPliAy7UX8n6P2vqt21a4rtIhzs=;
 b=VrVOXoqGapMjdAOv9x8KsHK4ODPEA7Sw7fktVXHvYM7h94FLpA0c0G+iofqiLdXw6qbfRInRHlS+QPlDiSPe6/RxNZle9Omoz0hOaqwiX80k5S6uyAnHgZ4T0wMpXmAIY3xATWHLdR5NQ0QWkRKW5hvyUwyIfdMjdjHmb9O/Lfo=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB3016.namprd12.prod.outlook.com (2603:10b6:a03:dc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 08:00:10 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 08:00:10 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: udc: core: Use lock when write to soft_connect
Thread-Topic: [PATCH v2] usb: udc: core: Use lock when write to soft_connect
Thread-Index: AQHW6ibvnVpQTYK6E0KZhUoKJi1D46omrCMAgAAGZICAAA+5gA==
Date:   Thu, 14 Jan 2021 08:00:10 +0000
Message-ID: <62fb4dc5-d9f7-e58d-d4c4-17a4c78a1d3e@synopsys.com>
References: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
 <X//nfLN9bW1K/yVm@lx-t490>
 <CAHp75Vf3eZjg20QEr6YqdY7R1Eu=D2za+sKb0vVBaAmETg1z4Q@mail.gmail.com>
In-Reply-To: <CAHp75Vf3eZjg20QEr6YqdY7R1Eu=D2za+sKb0vVBaAmETg1z4Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15280a93-1729-4a0e-b426-08d8b8626a42
x-ms-traffictypediagnostic: BYAPR12MB3016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3016231AA5814CC6FA9FB897AAA80@BYAPR12MB3016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GXl9eQ3DC5TvoqpSuAvkSaR8pMgsKd6nBn2lmmjzeWWN5mraDOg06ohI828WFLPx7cLIxMv+JVy+v3FokoFnv8Zgo9IlFYhrnN+z3BPE5QKnauoy3pst3u+0D2MaszwmSR+4+6iN9hjIxUP4mQZ9gVFhtVZwp3P7DX76i8RkTibCce0gfH6yUaWTq8LdVtCoZrUwMEeBPW1dP8vtGcnuL9nAXOuguJPsNxYpmRT8uaDuLxW8aoA/UqafcC4ke7/Bu+V/2SVKqg2xmaGMHcEgWI1oqUibvHjK+g/xQjymHOUEXTcE3a1yUFipd0AzE88tjGFBjwlawLim765qc6n5KcXNbv0DoZjcfU9YxNc8zZlYJmFbIRx+2izy8kco+Zz+DxLC9zKKF0B6Od6eQwK4FKWXifUHmuAq2gKUfU0MVpXQfcje60H8OIAWZBpJOtj/f7TWbUFSTauCK4CFjWNN0w0WBd3vn5qLR2qg/jiEeFc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(39860400002)(346002)(66476007)(4744005)(8676002)(36756003)(83380400001)(64756008)(66446008)(76116006)(26005)(66556008)(8936002)(186003)(6512007)(31686004)(66946007)(2906002)(5660300002)(7416002)(4326008)(110136005)(316002)(54906003)(86362001)(6486002)(71200400001)(6506007)(2616005)(31696002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YlAyQnc1YUtiREVVMnlVdmxDZlVqS0RwWkQ3TTFlT2g2V2gzVVl3cWtaWDYv?=
 =?utf-8?B?UmRlT0QxMzl5VXZxWHdaanlTN3hoWWpubnQvcXZHNzN6blZTaFlKZTYwQ0tH?=
 =?utf-8?B?ZG1kMkpVOXdBSmtuYm5SWGtvd1p2dVpLSmN4N25vRXQ2T3I4a1NGSWFmWUlB?=
 =?utf-8?B?Y2wxNm9YTzhUekRUQzhIZkltdjFMQjFxUUlVS3diVi9sc2pvN3JhOFhxQUU4?=
 =?utf-8?B?cmlOdGtFc3BCODZGalk4Y0xMQXhzcURDaXRwdG82alB6eDVSVGlmRlg5K010?=
 =?utf-8?B?UXd5SzI5SXpYWG5MZmdBWTA0ZEhCWERhNnpXWG0wMldsV05pWW9JUUx5M1pa?=
 =?utf-8?B?Tks3aHFMZEkyTStQcFN5bEpid04rSHlObFEzV0YyTGdnL1Irc0NIZDlvd09y?=
 =?utf-8?B?b21BZldqNmRWNXBCZXJsZVhibUU5NG1nR3J0UkZqaCtEaDBtd0lUOTNiOTdU?=
 =?utf-8?B?TWEzSmhkQzBnMlhadzVXbjJZcnI0a3B4SmRSZnM1bmp2NkEwQW01alo0eFZY?=
 =?utf-8?B?R1o3UnBtQ1JEbFZGcTlCNVlpMitYYS9XNkY5YjFsUytpcnBQYWdHVk5KaDJn?=
 =?utf-8?B?MGlremQvaTgxOGU1S0RjZTFIbEx2NFIrbERjMGN2b3BCd3p6Q1dkakplbDg2?=
 =?utf-8?B?NS9mZkJSazA2TFh4Y1lVTzNnb213V0xzRGZESnRlRGJBU0dIWEtKTnl5dkpL?=
 =?utf-8?B?TTRkRVlPWjMxTjRQamZiTGRjR3RSTVlJUlQ3cGF5VElBS2ZZamNJR2swUy9r?=
 =?utf-8?B?aXN0dWlXQnpjbHl6WmY0Qjc1T0txZ1VoalZMOUFlWVp3TW12Mko0VmYzU1Nu?=
 =?utf-8?B?SWNYSlhtMXk4MUtPZW90ZFkyWExBWE1VQkYyL1diWXlJK3A4dzBjdmkvdkpz?=
 =?utf-8?B?cWFSRVBEVWU3SHVUdVVKZmNQQ0pCTXNPanJMTXd5K1pXYVNiTmdqUWs5QVdZ?=
 =?utf-8?B?b3JWMFlFT292WkpWRVZCY1kzcXk3R21pREZWMDMyems0TVY2NTB3MlpvQnJk?=
 =?utf-8?B?M2VUKzJuVjVjb29lZmYyMThrMzIwbDBKaFpUNWN0anByZk93ZzcrczNIQmNM?=
 =?utf-8?B?TEdoTlRqSWQyWFhrSkE0bThlMVZxcmNnSzdaUUNIOHlmK0JodkJrVU9iRkhM?=
 =?utf-8?B?b1VOZTdvSy9OVWtHK2FQaTlSU3UvOGlaa0lwYWZxa2VhSjRLWjl4eXR3dTds?=
 =?utf-8?B?emhWQ1FQbC9tdWNtOFRrdzFjY1FueThlMFRBNzEwS3NLN01XckVNRXRpZERX?=
 =?utf-8?B?ek5Kd0QwUUduUkpkK3pSS1VzSDlsTEtwaDA2TjBENzBVSmNDamdleWJJOTU0?=
 =?utf-8?Q?R1KpOtMMHp0LU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <258560D8A7EFA54EBCE16B8894D8AE8B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15280a93-1729-4a0e-b426-08d8b8626a42
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 08:00:10.1507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i2bnMj8mXBODtzNH5xejz0TKZ9Y3L/PCwf6rt84ix7TgmAAAIDTb1pDoSl7hHsibU0Ab+rEFVdwGsIqT97U0vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3016
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QW5keSBTaGV2Y2hlbmtvIHdyb3RlOg0KPg0KPg0KPiBPbiBUaHVyc2RheSwgSmFudWFyeSAxNCwg
MjAyMSwgQWhtZWQgUy4gRGFyd2lzaA0KPiA8YS5kYXJ3aXNoQGxpbnV0cm9uaXguZGUgPG1haWx0
bzphLmRhcndpc2hAbGludXRyb25peC5kZT4+IHdyb3RlOg0KPg0KPiAgICAgT24gV2VkLCBKYW4g
MTMsIDIwMjEgYXQgMDc6Mzg6MjhQTSAtMDgwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPiAgICAg
Li4uDQo+ICAgICA+IEBAIC0xNTQzLDEwICsxNTQ2LDEyIEBAIHN0YXRpYyBzc2l6ZV90IHNvZnRf
Y29ubmVjdF9zdG9yZShzdHJ1Y3QNCj4gICAgIGRldmljZSAqZGV2LA0KPiAgICAgPsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgdXNiX2dhZGdldF91ZGNfc3RvcCh1ZGMpOw0KPiAgICAgPsKgIMKgIMKg
IMKgfSBlbHNlIHsNCj4gICAgID7CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGRldl9lcnIoZGV2LCAi
dW5zdXBwb3J0ZWQgY29tbWFuZCAnJXMnXG4iLCBidWYpOw0KPiAgICAgPiAtwqAgwqAgwqAgwqAg
wqAgwqAgwqByZXR1cm4gLUVJTlZBTDsNCj4gICAgID4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgcmV0
ID0gLUVJTlZBTDsNCj4gICAgID7CoCDCoCDCoCDCoH0NCj4gICAgID4NCj4gICAgID4gLcKgIMKg
IMKgcmV0dXJuIG47DQo+DQo+DQo+DQo+IFNob3VsZCBiZSByZXQgPSBuOyBoZXJlLg0KPiDCoA0K
Pg0KPiAgICAgPiArb3V0Og0KPiAgICAgPiArwqAgwqAgwqBtdXRleF91bmxvY2soJnVkY19sb2Nr
KTsNCj4gICAgID4gK8KgIMKgIMKgcmV0dXJuIHJldDsNCj4gICAgID7CoCB9DQo+DQo+ICAgICBU
aGlzIGlzICp2ZXJ5KiB0cmlja3k6IHRoZSByZXR1cm4gdmFsdWUgd2lsbCBiZSBlYXNpbHkgYnJv
a2VuIGlmDQo+ICAgICBzb21lb25lDQo+ICAgICBhZGRzIGFueSBjb2RlIGxhdGVyIGFmdGVyIHRo
ZSBlbHNlIGJvZHkgYW5kIGJlZm9yZSB0aGUgIm91dCIgbGFiZWwuDQo+DQo+DQo+DQo+ICsxIGFu
ZCBpdOKAmXMgbm90IGdvb2QgcGF0dGVybiB0byBhc3NpZ24gcmV0dXJuIHZhbHVlIGF0IHRoZSBk
ZWZpbml0aW9uDQo+IHRpbWUgKHNlZSBjb21tZW50IGFib3ZlICkuwqANCj4NCj4NCj4gLS0gDQo+
IFdpdGggQmVzdCBSZWdhcmRzLA0KPiBBbmR5IFNoZXZjaGVua28NCj4NCj4NCg0KR29vZCBwb2lu
dC4gSSBkaWRuJ3QgdGhpbmsgYWJvdXQgdGhhdC4gVGhhbmtzIGd1eXMuDQoNClRoaW5oDQo=

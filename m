Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452AE118AA5
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 15:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLJOTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 09:19:14 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:44700 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727007AbfLJOTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 09:19:14 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2217EC00AD;
        Tue, 10 Dec 2019 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1575987553; bh=SbBLH1O3WO1Hi7WxJDeeAfjQjj8jnRxQKWW7Mty4l+4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=f4MGwqf62+Oz5cgssbGAH90kjGIWPZfIOaZCoUE2rD7sxck0spL9pUpAas0UxoAWM
         RxdO2zGDeDDi3giBB/Hmu9UAO1T+yyweWtfTzw+NhhJlWkwV9VYjA949I7DKqgxxcx
         ibr0VkDkU2/KcWf51XNC2PCNV4pOsm7K7g/N1A1EpR361bADJc9iY/WlRuy1w4hEpW
         nTyNuCawWEKWzFJDzZKVV5tD88C2sC+ZoihoEzQpYb/h4iY2reUaT8Kzc7OSC72V+P
         rg3REzVTheaGV2r5cASUkbH78DhQ/o8+N3FQ1fq1n/LgSBAaIvkXIu6tECDABQzG5S
         91Dhy5vjr4OiQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 75D8FA008A;
        Tue, 10 Dec 2019 14:19:12 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Dec 2019 06:19:12 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 10 Dec 2019 06:19:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iN6Zd3pAFGLZzKB9lcNPcAS/PQtkxpnaMOjFVtwMFn5TIYsLgIy9DQnEhylPKZJ4Gv69yHUxG3ZHByB8qkbXu2jxey9xPjg6PUi7zT8cUNhUimMC8qZH5dcbECrPhgmKRiBGcsP3n1IPbFSiZgDakNNgeOOx0hCBQNPxEw0j75iks2w3YBQ7l5pLMjofMB9t5UuVUjyjhuH20u+vInAgRFEQrS7tmARyA97gu307mnU7yolDv0QXBnfX7WFfmZSu3KzExlujY36wjytabDofEWSn3hgHIAb6j+PrbzVNg7+grMG+RiGprIx04+rHe4KTcgz8JvegZ212TPDTaJPkOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbBLH1O3WO1Hi7WxJDeeAfjQjj8jnRxQKWW7Mty4l+4=;
 b=X+34MmBUknGSpK39oixr1xYTk7/xFgzSkmmvtZMPxE9eDeg18lI+BHTwAkPQ4b25JtJgIK/vqBxn/NsEVKDhiJ56z0XJC0LrLiYXs9GfoG+MumMFnLOaXKSz9ak3gjXsINySssvzRwEZSzP0yuhRjG9b2WUwYkwghHk8Wh7l+C1NktgDUC/LcJZJHlzKiXiPRZsVOJ/rWU96zmYmIuTNQHR8spFmQJfGodaKgL8zz43nHAjtIxiA9dmRPeP2Wu6C0ofetzJ997b4/TE7wfaXV+Tzz1Y0virMGYCHwphagu7k5A7PX7ofCVNZoRiZtHv//GfLa3/foraucc6ZcRUoZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbBLH1O3WO1Hi7WxJDeeAfjQjj8jnRxQKWW7Mty4l+4=;
 b=U71+FnOEEivyIyx4Pzh7MZe7SSGuOXyEVAs4d0RO7KcVAT+kdumfNpQnh0iyxh3/e/Rk4HjB6MtCwU4r1GG6e1rHb4HzZfv4eV/D4AHktI1mIEfUfE5ZMKH9HzgV1g0HPSNTP4tB9Nre6Lo/8NUvtjtEjaoTEG4NS1sjXGgqQ9s=
Received: from MN2PR12MB4093.namprd12.prod.outlook.com (52.135.51.203) by
 MN2PR12MB4095.namprd12.prod.outlook.com (52.135.48.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Tue, 10 Dec 2019 14:19:10 +0000
Received: from MN2PR12MB4093.namprd12.prod.outlook.com
 ([fe80::d0e:7272:4a88:ffeb]) by MN2PR12MB4093.namprd12.prod.outlook.com
 ([fe80::d0e:7272:4a88:ffeb%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 14:19:10 +0000
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Topic: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Index: AQHVpd4S46cbjx1MuUy0bLcfyWi1rqezZeCAgAAX+AA=
Date:   Tue, 10 Dec 2019 14:19:10 +0000
Message-ID: <e314d265-6d87-eb7a-997e-52d77ccdb725@synopsys.com>
References: <f8af9e4b892a8d005f0ae3d42401fee532f44a27.1574938826.git.hminas@synopsys.com>
 <8736dsl4u4.fsf@gmail.com>
In-Reply-To: <8736dsl4u4.fsf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hminas@synopsys.com; 
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39b5e110-0ce5-407b-a142-08d77d7bed1e
x-ms-traffictypediagnostic: MN2PR12MB4095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB409579378C17DF98A7814A60A75B0@MN2PR12MB4095.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(189003)(199004)(54906003)(2616005)(186003)(6486002)(4326008)(478600001)(86362001)(2906002)(6512007)(26005)(76116006)(31696002)(53546011)(6506007)(31686004)(71200400001)(4744005)(91956017)(81166006)(110136005)(36756003)(66446008)(64756008)(66476007)(66946007)(8936002)(5660300002)(8676002)(66556008)(81156014)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR12MB4095;H:MN2PR12MB4093.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mlu2uqYO6Q8D8lpheLJphxtJOQO8uciCJQvsbJMx2e9uLY07LowOlQlUyXpuE+P2ILmTL4uX0L9kLmlasBW1xac+S2wCMz1k8VSoy5VYBJbMzt/I6i4M5B4Qyg80btTdsCNWAODegL2PrlUzAcnV8DvSznnBjdMt5pCjGLMnZlW9TIpIVpmh3/jy27JgjqOW1fCL6c7bZcb4Qsri4evD6TRDHF/lkiqtEBF4uGHD3ISIDiPuGnPaZztpOcGXgr89lVnL/ntPpe99ANn8A1tj2l9o1GPAJzsbAshakoPJDzs84fF/Qc3sLsYRFLeA5fYyfmL67YL5bitDxSn7fIBHWvDP9y6nReCKLnCfdF6pIkSXFYIhQJCwIfqxxQ8sQ4G/9Ctf1fgFvJcKsUqUBhaUlgETePZ/YXG7SHbPo3wuMtqZAEMl2B3VBRH5XRnfYuVr
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1E1219AD2E6A742948B07C7D8254CAA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b5e110-0ce5-407b-a142-08d77d7bed1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 14:19:10.7447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9GFbEnEGgrU7jUC5CTbb3JSUOm2HRLWjqJ6OfKo3iIo/xgGUMphEt8uNrqbVqC1GSVDUq3W4YGH8K3EKcnB1BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4095
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpPbiAxMi8xMC8yMDE5IDQ6NTMgUE0sIEZlbGlwZSBCYWxiaSB3cm90ZToN
Cj4gDQo+IEhpLA0KPiANCj4gTWluYXMgSGFydXR5dW55YW4gPE1pbmFzLkhhcnV0eXVueWFuQHN5
bm9wc3lzLmNvbT4gd3JpdGVzOg0KPiANCj4+IFNFVC9DTEVBUl9GRUFUVVJFIGZvciBSZW1vdGUg
V2FrZXVwIGFsbG93YW5jZSBub3QgaGFuZGxlZCBjb3JyZWN0bHkuDQo+PiBHRVRfU1RBVFVTIGhh
bmRsaW5nIHByb3ZpZGVkIG5vdCBjb3JyZWN0IGRhdGEgb24gREFUQSBTdGFnZS4NCj4+IElzc3Vl
IHNlZW4gd2hlbiBnYWRnZXQncyBkcl9tb2RlIHNldCB0byAib3RnIiBtb2RlIGFuZCBjb25uZWN0
ZWQNCj4+IHRvIE1hY09TLg0KPj4gQm90aCBhcmUgZml4ZWQgYW5kIHRlc3RlZCB1c2luZyBVU0JD
ViBDaC45IHRlc3RzLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IE1pbmFzIEhhcnV0eXVueWFuIDxo
bWluYXNAc3lub3BzeXMuY29tPg0KPiANCj4gZG8geW91IHdhbnQgdG8gYWRkIGEgRml4ZXMgdGFn
IGhlcmU/DQoNCkZpeGVzOiBmYTM4OWE2ZDc3MjYgKCJ1c2I6IGR3YzI6IGdhZGdldDogQWRkIHJl
bW90ZV93YWtldXBfYWxsb3dlZCBmbGFnIikNCg0KVGhhbmtzLA0KTWluYXMNCg0KPiANCg==

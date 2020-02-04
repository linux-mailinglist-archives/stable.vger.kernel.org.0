Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFCB151A1A
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 12:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgBDLuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 06:50:16 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:45058 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgBDLuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 06:50:16 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 38F3C4052D;
        Tue,  4 Feb 2020 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580817015; bh=KUITq6NNZpoCwXbu98jDqdZEuVfwntelKsoJ1RQORxk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DtsdeqLZ1+IsqevUc5j5Tsmhx0F0UkYpm+2VhtVvI6AlaBKCmQ9b3LFHcJ0lRRY/7
         krl1yVyCX+SmUFmM07FlyBBY6uUXYrDxKQCIYwcGQ9BRYi/IwpIygAQWTM/1yRAElw
         bH6LAXPzPV0GdoEQkYT40/Jtdg/Q6jb6KllyjOJ1nnHIwYu5lXcq8eDweFqxTn0P+T
         2pj1wZ67uq66dvBygzEZ/UCuL3vUv7NNEylk1dt0c+bSqxMdFoOVOa9IIoq3drpDyg
         cAsJFIH+SOfRh6R1zm4bYqMzsZS9elVWG+XIURg0hss2AQqzUIzi/+YOKipMzOcsi8
         EpgGjESkAhxWw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 6DE5AA0067;
        Tue,  4 Feb 2020 11:50:14 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 4 Feb 2020 03:50:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 4 Feb 2020 03:50:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uy3EK/EkY6AChERCmnUWBTpxrsrlrC+KtpSc3BtzT2RMXdmWw8t85jO8mnPnCI7Hcpwk238w+GZLoKhQhBxTqIZJDmYk7RvRNqT9ejyTHE8mxR1D/1DoqED/89LZ7VWQh+7tNrusq3asNFyt+BnQ8iwAMjdLWa9Dc/pzy1xIH2S7HBK6iKN9B9Nnryw5JoU0sxOhSP8vZ2LSEfdpevCHpTUJ/Um4V+gUzpqKW7AfrltwjKNtEfYsTbs2BqJ0/188rGLepTSomixqnK0aqPYC+y0zG9Pryx5umIOooWiDTydyOCfsAFy8L12nS0/hCxTzE/B09BzjVNu8+sTLHMNBYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUITq6NNZpoCwXbu98jDqdZEuVfwntelKsoJ1RQORxk=;
 b=e/GRNUFmnX6EtF7ZrZOPCWABHkgU6AohdqmlLBUb+bER1FpFD20c5LpOJMkkHW2YORTCWX0pGmhiyVpMq9zAWxiKpX3Ox61Zc6cTcdjrJP8c60IbrnLnr6oeBRmk5KslYYz5RAQ/tnKm4LMOLtXf4OPaBo2ZPS1cqFpfaYhswp5rSHO5r+RJRX/1sEVEcK9HkKf/zjmHqCi/3ojoKMBJyfjn31H96CqMqXn6CDFn00EFcgpPcr1nKwCa9xtxtf2xF2pm9bPVGPmT1XqBcRcOVStz5Scgr0r8vzc48LKwosLqpCbkcsbMRKcLaZXR3QF5O3fzsKEnpn3z5RFEav8LtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUITq6NNZpoCwXbu98jDqdZEuVfwntelKsoJ1RQORxk=;
 b=aYNCQ9QADt2HLBhb5OaoPa7O8eWW5L345TqUD1D+LOW3dhV3c/jPee/o4QCG2L6gOAIGlGer+f9SgrC2Cb2rV4FjgJo5QJHN/M9Unjg63hDj9rL+UF4Cfb6a/y3/DfKlDflfZLra5sGzN/tle9oXkku0eVpKTlzNMUnJ+v6GQuo=
Received: from CH2PR12MB4088.namprd12.prod.outlook.com (20.180.5.200) by
 CH2PR12MB3880.namprd12.prod.outlook.com (52.132.246.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Tue, 4 Feb 2020 11:50:12 +0000
Received: from CH2PR12MB4088.namprd12.prod.outlook.com
 ([fe80::d4b3:2331:58d5:21f7]) by CH2PR12MB4088.namprd12.prod.outlook.com
 ([fe80::d4b3:2331:58d5:21f7%6]) with mapi id 15.20.2686.034; Tue, 4 Feb 2020
 11:50:12 +0000
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     John Keeping <john@metanate.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Topic: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Index: AQHVpd4S46cbjx1MuUy0bLcfyWi1rqezZeCAgAAX+ACABI57AIBTSS0AgAABRoA=
Date:   Tue, 4 Feb 2020 11:50:12 +0000
Message-ID: <fd461c4e-331e-4941-061e-a02e7259aec2@synopsys.com>
References: <f8af9e4b892a8d005f0ae3d42401fee532f44a27.1574938826.git.hminas@synopsys.com>
 <8736dsl4u4.fsf@gmail.com>
 <e314d265-6d87-eb7a-997e-52d77ccdb725@synopsys.com>
 <d89dc76f-ab19-e7e7-1375-534cd2cfaa1c@synopsys.com>
 <20200204114538.12af5d84.john@metanate.com>
In-Reply-To: <20200204114538.12af5d84.john@metanate.com>
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
x-ms-office365-filtering-correlation-id: 4e605055-82ed-4a8a-1744-08d7a968649c
x-ms-traffictypediagnostic: CH2PR12MB3880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3880C7F26BF89AC413BED797A7030@CH2PR12MB3880.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:87;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(189003)(199004)(966005)(478600001)(36756003)(66556008)(31686004)(2906002)(64756008)(66446008)(5660300002)(31696002)(66476007)(86362001)(91956017)(76116006)(66946007)(4326008)(71200400001)(6486002)(186003)(6506007)(26005)(53546011)(316002)(110136005)(6512007)(54906003)(81166006)(2616005)(8676002)(8936002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR12MB3880;H:CH2PR12MB4088.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B59mKBmb7MuAz70WUL7UZFaViZaHm6THhgN86h9umo+gewvahVYg+903ZyMyZ7a5dyHNLPV11wA22DUfnOL0IfekqoMgS0fv2AYzqynGwCzMtdTZ6w3E3Ae3UTsY4fZM+mWe/bIUrCD7L4xr596+hQJM5aZxa9PYJ1NnB9PtwQvn4KLBs592mPYTNKoOdr83/Uka62aC1kAEXs+JELygIZ3jPF6NMnxnx90wIrRojZJKiHL++XGWSz9vx0ihCaOaaZAkpJVlvX6CI87iofvaX+P7oIwkQqyltSCtuKu8b7NTXgmqz1gcdTMynJDgAhIe5ofhXupUQnG+F6SroMyJNpGCbsmyUmqOBaw5PiyWjs8SLTEzceGLU/TchTlrasdIc6GkixT1kNo6fBZR/qQrnrB4VOqIZ/iWzqAM/DB38A7U/ax4kh8hsgNedlJ1SSp2Hw9ZdjZK4C7HewLcyXj7UqKIEzp209/ZWy+3KgJw56O/aofFC5msAQsOsYSM28TN2xm0NRxw4z1qq0r8+nQtaA==
x-ms-exchange-antispam-messagedata: BCaX5pEgeDr5/F2Ruyra310/S24BxHf4meJAmzhRTvLiKN1z2+n/g/NTC0K3dOhDgp97vpYrLA7WoEFSJfNQvsoIawEtG3Iatgm/FonT8YLkuYhJCNJf4qX2Psm0kMNJlJsxq0WGsjt7KSItlucCIQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <62D6C7A1BAF7DB4D890E55E1205EB503@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e605055-82ed-4a8a-1744-08d7a968649c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 11:50:12.3917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qsYBpGH+eLj+XeAL211RmMIxiE9V/PiwPRo7dOHS8I+anmFiPSD3GiqX3y8taNWpNbxLFFNSXxjjF0VYCulV2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3880
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgSm9obiwNCg0KDQpPbiAyLzQvMjAyMCAzOjQ1IFBNLCBKb2huIEtlZXBpbmcgd3JvdGU6DQo+
IEhpIE1pbmFzLA0KPiANCj4gT24gRnJpLCAxMyBEZWMgMjAxOSAxMTo1NDoxMSArMDAwMA0KPiBN
aW5hcyBIYXJ1dHl1bnlhbiA8TWluYXMuSGFydXR5dW55YW5Ac3lub3BzeXMuY29tPiB3cm90ZToN
Cj4+IE9uIDEyLzEwLzIwMTkgNjoxOSBQTSwgTWluYXMgSGFydXR5dW55YW4gd3JvdGU6DQo+Pj4g
T24gMTIvMTAvMjAxOSA0OjUzIFBNLCBGZWxpcGUgQmFsYmkgd3JvdGU6DQo+Pj4+IE1pbmFzIEhh
cnV0eXVueWFuIDxNaW5hcy5IYXJ1dHl1bnlhbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+Pj4g
ICANCj4+Pj4+IFNFVC9DTEVBUl9GRUFUVVJFIGZvciBSZW1vdGUgV2FrZXVwIGFsbG93YW5jZSBu
b3QgaGFuZGxlZCBjb3JyZWN0bHkuDQo+Pj4+PiBHRVRfU1RBVFVTIGhhbmRsaW5nIHByb3ZpZGVk
IG5vdCBjb3JyZWN0IGRhdGEgb24gREFUQSBTdGFnZS4NCj4+Pj4+IElzc3VlIHNlZW4gd2hlbiBn
YWRnZXQncyBkcl9tb2RlIHNldCB0byAib3RnIiBtb2RlIGFuZCBjb25uZWN0ZWQNCj4+Pj4+IHRv
IE1hY09TLg0KPj4+Pj4gQm90aCBhcmUgZml4ZWQgYW5kIHRlc3RlZCB1c2luZyBVU0JDViBDaC45
IHRlc3RzLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IE1pbmFzIEhhcnV0eXVueWFuIDxo
bWluYXNAc3lub3BzeXMuY29tPg0KPj4+Pg0KPj4+PiBkbyB5b3Ugd2FudCB0byBhZGQgYSBGaXhl
cyB0YWcgaGVyZT8NCj4+Pg0KPj4+IEZpeGVzOiBmYTM4OWE2ZDc3MjYgKCJ1c2I6IGR3YzI6IGdh
ZGdldDogQWRkIHJlbW90ZV93YWtldXBfYWxsb3dlZCBmbGFnIikNCj4+PiAgICANCj4+IEdvdCB0
ZXN0ZWQgdGFnIGJ5IGlzc3VlIHJlcG9ydGVkLg0KPj4NCj4+IFRlc3RlZC1CeTogSmFjayBNaXRj
aGVsbCA8bWxAZW1iZWQubWUudWs+DQo+Pg0KPj4gU2hvdWxkIEkgcmVzdWJtaXQgcGF0Y2ggYXMg
djIgd2l0aCBhZGRlZCAiRml4ZXMiIGFuZCAiVGVzdGVkLWJ5IiB0YWdzLg0KPiANCj4gV2FzIHRo
aXMgcGF0Y2ggZXZlciBwaWNrZWQgdXA/ICBJIGRvbid0IHNlZSBpdCBpbiBjdXJyZW50IG5leHQu
DQo+IA0KWWVzLCBpdCBwaWNrZWQgdXAgYnkgRmVsaXBlLiBJdCB1bmRlciB0ZXN0aW5nL2ZpeGVz
DQoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2JhbGJp
L3VzYi5naXQvY29tbWl0Lz9oPXRlc3RpbmcvZml4ZXMmaWQ9NmRlMWUzMDFiOWNmOGViMDIzMzU3
NTg2YWI4YjAyZWRkYTA3MzIwYg0KDQpUaGFua3MsDQpNaW5hcw0KDQo+IEdpdmVuIEZlbGlwZSdz
IG1lc3NhZ2UgWzFdLCBJIGd1ZXNzIGl0IG1pZ2h0IGhhdmUgZ290IGxvc3QuDQo+IA0KPiBXb3Vs
ZCB5b3UgbWluZCByZXNlbmRpbmc/DQo+IA0KPiBbMV0gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29m
cG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19sb3JlLmtlcm5lbC5vcmdfbGludXgtMkR1c2Jf
ODc1emhkNnB3MC5mc2YtNDBrZXJuZWwub3JnXyZkPUR3SUNBZyZjPURQTDZfWF82SmtYRng3QVhX
cUIwdGcmcj02ejlBbDlGckhSX1pxYmJ0U0FzRDE2cHZPTDJTM1hIeFFuU3pxOGt1c3lJJm09RDRS
bFBmMGNneXpNcGMtaEtoSTFnaUVXWkpHY3hOSkZKV0M1eGpEVnlvSSZzPXB3N3RsVnd0N09wSHRZ
al9XcEdHM0s5V1RvZGZGNkZVV3Z5SG9KNF9fY28mZT0NCj4gDQo+IA0KPiBUaGFua3MsDQo+IEpv
aG4NCj4gDQo=

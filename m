Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E042112121
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 02:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfLDBtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 20:49:08 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:41302 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfLDBtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 20:49:08 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 21E1E404FC;
        Wed,  4 Dec 2019 01:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1575424147; bh=5G3Tfi9QbP6Gkkc9zWpZlXVImf771SG4AJym0YgjMkI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VXVXUHlXKGAZm8k5lCm/JrqEoN4cArsE4BvFwVO8c41pnDB/eY3XAIECu0KIs5awn
         yYy81uqCAq1iB23CLnMys5soID8IQgjxFz2RMPu2UFlIvevNLkjNy/IRBshagsaxZU
         iEjPnWjvWXPRFNsUAHP8YjJ34TXVAAX4prB6e6y/yhJSD+KOBoxH3qkln1szGdwRzG
         qoD5cLIvty5EjYAFe37MNHJQ9fJgKAyvJFkWk0ogowE2Il7odFMpUgxE2sTQOXst1w
         Ch45rb8ZvTeLx2xXm4gRU6ll8y+JAzmzOivaqRhT6UcROQKXdo+qPel741/eAJ9hRu
         jTuV62mp1p1Lw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D8145A008E;
        Wed,  4 Dec 2019 01:49:00 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 3 Dec 2019 17:48:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.13.177.249)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 3 Dec 2019 17:48:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsY5+Z1hK9trPA8CMMKLMY9xrLQ8A8WgAZe5Ki83U9Vaw4TIGY3b9PTgQqpVO3SRQHHtsGV3JJCFBKvn6GDVbexi4qnqFIIMCr3nOBVU+kvk621xQuQXqQ0y9dxaEbjjZLrJezciaXiNIsyGiTF01+r19Mmkyhk/4PiA31wJ4eo7fUTrPRIz635Rvy9fkLfTFOJebjP41vpKXMNBDQCl+f9XBy2HbGTNVrapkIh6KfMkEm8OV9CFfxj0jPqTAoh5wQugAXQISHQbSq6Bv6U4xnu2hV/N3g9wvzgVbZO9aMmpTrXl6x2O0RnxlQUZj2RJTwfddARGVWX5QSS6/aFSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5G3Tfi9QbP6Gkkc9zWpZlXVImf771SG4AJym0YgjMkI=;
 b=l3VlsRV6ovaY8nhr1Lcam/SNAZClwAHMuhopIf/NF1c5bOr92DapS7/IIQzmyjtlFmAGSv7LbGlrPEwMskAu67afNLZH0CC8bl9OJR0jEB27wAKb6E6FsPOVqRR7ZRn3J1GvuCqA5p9f+HsgLTLPPC1YUkK2SU/yUxI+R7E4fiD0ScbxLR1tD4wIvOXZDRL+PeThvkjU9vPqBk5jH6gxHlC5fQG8WgnWPzilN1UcJSgpmQEp/e049JYbgUn2VVhfuVHN83KnOGIWYnnVBp19Gs0kw2TmCPEbhzY/RBuwDxCLV40Kr2pKvvdOhf2swHZXMrRg/ysmyNS9Gae4FzGBfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5G3Tfi9QbP6Gkkc9zWpZlXVImf771SG4AJym0YgjMkI=;
 b=VZxtF2ppX6wAKmwcbdVkxQSIjmzJlG/M0z0m/dPrFlCd+dxQCrXRT9z166swy+RuJaDYnPhotVFUBmWFd4kokCdWH5chKuFuh84p0vHUYjI00hw2VDDLAiQ0k+0rWYxSayEHRvrX6W38s2IkuR0Ql0yHimg3hgasRfbC9ufN94A=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0181.namprd12.prod.outlook.com (10.172.79.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Wed, 4 Dec 2019 01:48:51 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4%8]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 01:48:51 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
Thread-Topic: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
Thread-Index: AQHVpWwJjRcuVvPds0SRD8AQcHPAOqeoee0AgADFLgA=
Date:   Wed, 4 Dec 2019 01:48:51 +0000
Message-ID: <b2277d8d-8b7f-15cd-fa18-e8c3d08ead4a@synopsys.com>
References: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
 <87sgm18q1x.fsf@gmail.com>
In-Reply-To: <87sgm18q1x.fsf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 062299fa-0d59-4037-b6e3-08d7785c1d0d
x-ms-traffictypediagnostic: CY4PR1201MB0181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1201MB01812D12518FA644DF8CAD5AAA5D0@CY4PR1201MB0181.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(376002)(39860400002)(136003)(199004)(189003)(316002)(66446008)(64756008)(6486002)(229853002)(66476007)(7736002)(76116006)(81156014)(8676002)(66946007)(2501003)(14444005)(4744005)(256004)(305945005)(5660300002)(6116002)(2906002)(14454004)(3846002)(31686004)(81166006)(76176011)(71190400001)(6512007)(4326008)(6436002)(86362001)(8936002)(71200400001)(6246003)(446003)(66556008)(36756003)(25786009)(54906003)(11346002)(478600001)(6506007)(186003)(2616005)(31696002)(99286004)(110136005)(102836004)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0181;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1bC7FyqWluvBcKeJXI3w7TLQzLscuOv+qfkLUoT0NzgkvlE4HXO/O1q8GPXZb6kOOjmkN6K4tTPrPVzrS053CyftbsY0+1OucRITD9TppL+jsqnjbh39/gPC8C55FEsPmIvuJep2sNFRZfS0omvm+1v0HPUpgZIrf//oshQHodT8LRlSeMQgujz5BVTw7isLGtyx8pXhlttr+AWE72EmnMvuaP4P9kDQQ3fcyb4hmNHSq3VT62bo2Vl4qzIuZwxzRJKaNxlbJVBawkIMboDkUUY82LmXquBrNpYJ73+iaCpISE1MGCzoYD49z1CQKwXb6fTt7yBOh3MZiq9Wg4gGqgyDH9q+397XF41/3Liyj2GSRInJED2BrnZGhdKEY7IGqAo9EiIlogZWKHkpRnUBXB0PqX5hhRaF1/N/r7/RGvnsYpXDjHgYnhoL0yKLKfg7
Content-Type: text/plain; charset="utf-8"
Content-ID: <545755798B32FD47BDB749AE3367AC57@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 062299fa-0d59-4037-b6e3-08d7785c1d0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 01:48:51.4527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rbmgIdnIqBlnQQFqJQ4xxFLDd4GKBFEzip/7Pq+cxn+z9tGh1EBGYMkZgCDICilNzr4tPu3d9p/va7PGqW4XKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0181
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpGZWxpcGUgQmFsYmkgd3JvdGU6DQo+IEhpLA0KPg0KPiBUaGluaCBOZ3V5
ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4NCj4+IFRoZSBmdW5jdGlv
biBkcml2ZXIgbWF5IHRyeSB0byBlbmFibGUgYW4gdW5jb25maWd1cmVkIGVuZHBvaW50LiBUaGlz
DQo+PiBjaGVjayBtYWtlIHN1cmUgdGhhdCB3ZSBkbyBub3QgYXR0ZW1wdCB0byBhY2Nlc3MgYSBO
VUxMIGRlc2NyaXB0b3IgYW5kDQo+PiBjcmFzaC4NCj4+DQo+PiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDx0aGluaG5Ac3lub3BzeXMu
Y29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgfCAzICsrKw0KPj4g
ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiBp
bmRleCA3Zjk3ODU2ZTZiMjAuLjAwZjhmMDc5YmJmMiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMv
dXNiL2R3YzMvZ2FkZ2V0LmMNCj4+ICsrKyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4+
IEBAIC02MTksNiArNjE5LDkgQEAgc3RhdGljIGludCBfX2R3YzNfZ2FkZ2V0X2VwX2VuYWJsZShz
dHJ1Y3QgZHdjM19lcCAqZGVwLCB1bnNpZ25lZCBpbnQgYWN0aW9uKQ0KPj4gICAJdTMyCQkJcmVn
Ow0KPj4gICAJaW50CQkJcmV0Ow0KPj4gICANCj4+ICsJaWYgKCFkZXNjKQ0KPj4gKwkJcmV0dXJu
IC1FSU5WQUw7DQo+IEkgd291bGQgcmF0aGVyIGhhdmUgYSBkZXZfV0FSTigpIChhbmQgcmV0dXJu
IC1FSU5WQUwpIGFkZGVkIHRvDQo+IHVzYl9lcF9lbmFibGUoKSBzbyB3ZSBjYXRjaCB0aG9zZSBk
b2luZyB0aGlzLiBUaGF0IHdheSB3ZSBkb24ndCBoYXZlIHRvDQo+IHBhdGNoIGV2ZXJ5IFVEQy4N
Cj4NCg0KU3VyZSwgd2UgY2FuIGRvIHRoYXQuDQoNClRoYW5rcywNClRoaW5oDQo=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8D105F23
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 05:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKVEAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 23:00:47 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:34250 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726343AbfKVEAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 23:00:46 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 37BEFC2808;
        Fri, 22 Nov 2019 04:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1574395246; bh=9LLeQ5hBTsDjE2Srqh8NvLmeF+SsvnlJmdasI/JAddY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=jc3JlBm/1TeZXRn+5M+M4OyqQUnjLxBBHB7PksD/dFvD7uf54U8VPms2f8leXm+tw
         /y9qIBG6LbBqRc2WFFMrfGoZynZbkIpMTuZqEdGSjSxlNFJy7lZ4i7Lumdt3HXbINT
         bQICjoovVytESjMj1KGhHnCEr2+hRysGhQZWXMwaRRMThZoO7aivnREsvjAoHh9z6E
         F6sBQt12ADgd4LH9Pf1cEBt5n/SW0F4H0Y7RRYczS2oMtq9IdieG60p9WxNIkOR4h5
         +oTuLCr2wTh4UNAd6oLeabMmYX3Cx7FWi/XrSYHjCj3jWMReNqaMrAd2vZVkGodTnj
         n8RlpjJHfVr4g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 02B9EA0066;
        Fri, 22 Nov 2019 04:00:45 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 21 Nov 2019 20:00:13 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.177.249)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 21 Nov 2019 20:00:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aaa9KSrhi8M4VufxbZKEwwJVqqrYo4WQ7zAQNOz9MrC0R1l8LBcrEqvnEGYUk/wxaXbeykUweegBreF6uVhMN026S5vzFxUrJrl9GP9XSrvwjhJC9o+9TdYNxygnuJLGABf/NoplKzpIcnEJAp4zJt9hgiSn14S/7nU5Og64aBg/pKJbLnxtvuIym7m+J7R9cLQI5hh8te9Laa4JHIFSFE9oi6Jm6J5+jGAs1mkIP+JCTuC57AiMgLjTW+qxRC4pQ5nWnEynjYdWPki/MYma8cGL6PGhE9Es8CRoBbi6rVidQ8IwCiGv/D5G8pxhhJE4OZI1CS01PV1kXuhn4LqW2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LLeQ5hBTsDjE2Srqh8NvLmeF+SsvnlJmdasI/JAddY=;
 b=DYoNVGuzLvc0i6ZED4dCtbKvCpJ/P7IomexvzOUXqcQSRiuyHHuQ4vzk8TuL/55Qi8hJSWMyGy79WZV39LxNFcn265Jgm2Nx2WVm2c2Q3SBOMli/v+TvGOcoPBZxdrwSSTXpt897RDnaGBsQY2U3W5JSzVMwPy453R1Nsr/j7NLj+HR7m9+4Uubu+08EXnhQ+D5GJ6YaVTxf0e2Thh+0y3nzzpfrXurTMK9afYY2dqm4+JAixQWNFkpYs5r2lKLDF3xTKELi20K4REN+8jlA1jrJ3T5pX6u2c0GPGH3qCII846wDS8LgBEk4km9gqhrCcz5+DhC8H3rDYQ3ZGMuPng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LLeQ5hBTsDjE2Srqh8NvLmeF+SsvnlJmdasI/JAddY=;
 b=j16uEWZp4+pbt0/wFciE1etc66Q/STcWP7A9iCR/kdxVxg0IEJdhCBEGSbSMefzK/nO7pclDOg8stCh5wOMgjRqwiprQW8cgCQujtJnX/fn9CbVvmDGWeBVo4pnmllV0bd6ud/2MCEbnix+KiopEE4LM42wkABXh/0dwa2os2/s=
Received: from BN7PR12MB2802.namprd12.prod.outlook.com (20.176.27.97) by
 BN7PR12MB2754.namprd12.prod.outlook.com (20.176.176.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 04:00:12 +0000
Received: from BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::9859:2c51:52b9:dd1d]) by BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::9859:2c51:52b9:dd1d%7]) with mapi id 15.20.2474.018; Fri, 22 Nov 2019
 04:00:11 +0000
From:   Tejas Joglekar <Tejas.Joglekar@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix logical condition
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix logical condition
Thread-Index: AQHVmel/GHfEKCMYIkmSDWBktmuPEaeWntgA
Date:   Fri, 22 Nov 2019 04:00:11 +0000
Message-ID: <9dcb74d7-17ed-c81e-c723-3f4848532b8b@synopsys.com>
References: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
In-Reply-To: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joglekar@synopsys.com; 
x-originating-ip: [183.82.21.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f5d4b48-5f1f-4f4c-ad1d-08d76f00792e
x-ms-traffictypediagnostic: BN7PR12MB2754:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR12MB2754233B7EF22319F3A8152BA4490@BN7PR12MB2754.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(346002)(376002)(366004)(189003)(199004)(3846002)(36756003)(478600001)(26005)(54906003)(71190400001)(2906002)(2616005)(66066001)(71200400001)(6116002)(11346002)(446003)(25786009)(8676002)(66946007)(66476007)(66556008)(66446008)(64756008)(76116006)(81166006)(8936002)(14454004)(31686004)(31696002)(81156014)(7736002)(2501003)(305945005)(4326008)(76176011)(6486002)(110136005)(86362001)(316002)(6512007)(6436002)(102836004)(5660300002)(99286004)(6246003)(229853002)(14444005)(256004)(6506007)(53546011)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN7PR12MB2754;H:BN7PR12MB2802.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: maSipQ+Jy08f0uAeggP2rA64Cnk5NWyn9d8qm3XytPrjOl6iI00q9anUo4jyJ3VOn7oZzxLYsyyqIff8rYO1YX8q2k45QCAiuNQloD+QQZrdwwtgeUUObz3SzKxDFYhYjaAJ9d/AUnwMIIa6y+woxij4qBOHKubNkgAh1EXZcQP3YfClw6LMLNg8cy/oWqkUkuQk6a7ppM3q81UpX+YnTCSUjEAzMNgF633GuHya8R1HT4qUUrR5MN1rHNvG/IraymQ9o/znNSjl6dRHI/+6wBchaIhljT5+N13L/x5tsLeK8/BvQDAUUQ5ceh+VnKD8IQmY4rnWIuDwAXavRQpdBz4TpIiNykFeTM1t0EB++u6Pg1ARKuAXv7rQ+3IKO00NESi1/z+ET1jBC0om1lfGf6YQSSsGRdbQwZKK8FzwXJFTRcXm1oG2BbskX3WPY4oT
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5D8521415313F42B17EFC09A41B666D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5d4b48-5f1f-4f4c-ad1d-08d76f00792e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 04:00:11.7581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WSGpfJrLepHHdVAhONNg5C5I1Qf5uZX6hIiXaN9jBGTUBl9d4q02NPlhRyATrQdtV/nNQ4wkpuXAVbrXKGkPIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2754
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gQmFsYmksDQrCoMKgwqDCoMKgwqAgVGhpcyBpcyBhIGNyaXRpY2FsIHBhdGNoIGZpeCBm
b3IgZHdjMywgY2FuIHlvdSBwbGVhc2UgcmV2aWV3ID8NCsKgwqDCoMKgDQpPbiAxMS8xMy8yMDE5
IDExOjQ1IEFNLCBUZWphcyBKb2dsZWthciB3cm90ZToNCj4gVGhpcyBwYXRjaCBjb3JyZWN0cyB0
aGUgY29uZGl0aW9uIHRvIGtpY2sgdGhlIHRyYW5zZmVyIHdpdGhvdXQNCj4gZ2l2aW5nIGJhY2sg
dGhlIHJlcXVlc3RzIHdoZW4gZWl0aGVyIHJlcXVlc3QgaGFzIHJlbWFpbmluZyBkYXRhDQo+IG9y
IHdoZW4gdGhlcmUgYXJlIHBlbmRpbmcgU0dzLiBUaGUgJiYgY2hlY2sgd2FzIGludHJvZHVjZWQg
ZHVyaW5nDQo+IHNwbGl0aW5nIHVwIHRoZSBkd2MzX2dhZGdldF9lcF9jbGVhbnVwX2NvbXBsZXRl
ZF9yZXF1ZXN0cygpIGZ1bmN0aW9uLg0KPg0KPiBGaXhlczogZjM4ZTM1ZGQ4NGUyICgidXNiOiBk
d2MzOiBnYWRnZXQ6IHNwbGl0IGR3YzNfZ2FkZ2V0X2VwX2NsZWFudXBfY29tcGxldGVkX3JlcXVl
c3RzKCkiKQ0KPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5
OiBUZWphcyBKb2dsZWthciA8am9nbGVrYXJAc3lub3BzeXMuY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvdXNiL2R3YzMvZ2FkZ2V0LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMv
Z2FkZ2V0LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+IGluZGV4IDg2ZGMxZGI3ODhh
OS4uZTA3MTU5ZTA2ZjlhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5j
DQo+ICsrKyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gQEAgLTI0ODUsNyArMjQ4NSw3
IEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdChz
dHJ1Y3QgZHdjM19lcCAqZGVwLA0KPiAgDQo+ICAJcmVxLT5yZXF1ZXN0LmFjdHVhbCA9IHJlcS0+
cmVxdWVzdC5sZW5ndGggLSByZXEtPnJlbWFpbmluZzsNCj4gIA0KPiAtCWlmICghZHdjM19nYWRn
ZXRfZXBfcmVxdWVzdF9jb21wbGV0ZWQocmVxKSAmJg0KPiArCWlmICghZHdjM19nYWRnZXRfZXBf
cmVxdWVzdF9jb21wbGV0ZWQocmVxKSB8fA0KPiAgCQkJcmVxLT5udW1fcGVuZGluZ19zZ3MpIHsN
Cj4gIAkJX19kd2MzX2dhZGdldF9raWNrX3RyYW5zZmVyKGRlcCk7DQo+ICAJCWdvdG8gb3V0Ow0K
DQpUaGFua3MgJiBSZWdhcmRzLA0KDQpUZWphcyBKb2dsZWthcg0KDQo=

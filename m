Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19431B94CE
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 02:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgD0A6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 20:58:18 -0400
Received: from mail-eopbgr1300128.outbound.protection.outlook.com ([40.107.130.128]:26240
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbgD0A6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 20:58:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCVH8W4V9Vvv2FSvFyJjc20ED4ba4RiIALAFJcYeRnHZVLI3mgNCloFZ3KhpGIU2sthGZO8kWLGh0KsgDZhK8qiRPlnmvP3tnfPY274G8oQqnuxDrKnm2sozME4hYiZqy8OBJe3Z1IcP1rtaLF5/h15sPpy3sjO+MQLGJoeiVQrCbJvIhJs/6i66GeTu4I+zyxPj/O+Rd5APpLTsrxYHsex9WDZi98wXg8clmRLcRimrJVTpQsfk2mC4IL7AZO/1Xf0SVZ+87+NvMp782JMOu73a7NUiwRHxNMJxsp8AeS3ytbPZS5BBU/GvhGp0V9hCERa8Alzsi/jqdzqqVvKUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWIW7118l21I1jeJ3Bo2SF2t+3syFp99G87y40g4xDY=;
 b=fAmHlqDLJFrJDswEEIeHU/SO+fqqLV7OXibyoqcjVFtMnfJeEnSHkUnCT6l8K4eYWecCDQxrTvLhPjh0Ms/DpetMHsZV3gKViEw2EqX+GaOr8A5LGdphSSHqXW/TBHiR7R4YWOFF48DnPJDyJ55L5yd/NfiI53SoxqaTbaZ4VhT5t0T5XocbDP8+h1Q3AYKOOf4BHuy4L/sbBBGN77ZyMmAQeUrSszAjIhp32Y5zjI7NdTEzZYuxc6zCg6dUpX7eG8SpFZPfuFEK9XHVElpJVEuQeGKqiM0LD2OJjlfgjupjIboZMrrNHgjrHLYdmoRqpco8c6tN6hr4IXBe0/Ne3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWIW7118l21I1jeJ3Bo2SF2t+3syFp99G87y40g4xDY=;
 b=aMJCX8BElUGHYiAmVSwun7KWyhkTXzxIwV4oNKJXe0VsyPPSWyo+bnQMXPVCBlxh2BALwv9N9L3iOMMUTbxyvwYzC4OAgkhIqCacHTXypq9CEGGKI3Ho9hgPmrScIZKIXp72l8Y7z71cH6wO+LH+3vz0e0K+OzFkXhQCZAfXa30=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::12)
 by HK0P153MB0323.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.3; Mon, 27 Apr
 2020 00:58:09 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2979.003; Mon, 27 Apr 2020
 00:58:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        Michael Kelley <mikelley@microsoft.com>,
        Long Li <longli@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] PM: hibernate: Freeze kernel threads in software_resume()
Thread-Topic: [PATCH] PM: hibernate: Freeze kernel threads in
 software_resume()
Thread-Index: AQHWG+cf3jJQVmOuiEmTeavdUE/dX6iLuq4AgABpj6A=
Date:   Mon, 27 Apr 2020 00:58:09 +0000
Message-ID: <HK0P153MB0273B5E4E48EFEF90893972FBFAF0@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <20200424034016.42046-1-decui@microsoft.com>
 <2420808.aENraY2TMt@kreacher> <08f28683-4978-3e3c-e85a-303f6e46ef55@acm.org>
In-Reply-To: <08f28683-4978-3e3c-e85a-303f6e46ef55@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-27T00:58:05.7777608Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bdc3d678-8825-40b2-8b7a-b614b51e8c18;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:39c4:9d02:a54c:22b3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e6de7cd-07e4-4f5f-45af-08d7ea460df7
x-ms-traffictypediagnostic: HK0P153MB0323:|HK0P153MB0323:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB0323A79E297E2EE272BBF4E0BFAF0@HK0P153MB0323.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0386B406AA
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SAAM8siL9x1TWU/LycnGg6Bd5yUUDil2C1evzOlHS+dXARh45QKMvtzU05PJA6856OzTsLzOAG7v/ndBAunBifv278Uj5c8R9xGuvgWfXzG9VllqpctWV9WTcXEy7/NKpQWGNIL6kufkM45kUiH+r7jicJBdjTaldar1XDkntEqzyS1uWrJQXgq+M896fF6uJHKX4pNDGQWqTAQHqZiZRb3rM286/Tfki3WccEvLpU/YHX3FW9CoXWN0nXddySnEGc3aJJx5R6620G0HgLxD1UvoPSfnu6jzUoNqhI6QY0BImCbiNWKnSXH/+UpI6LFDO0+ge4yfDQHPeUdaIooEV5NIp1fzaaghSavUBgmpVdlCXJ1+J5KKhnFV7K6gMnEcJLLZfh+7HDYMRkRj0O2iLc3Y8YyRQlkHH58aKH7H6XOz0CvCHmkRUAF99egk6ohyGighaByDOyeEAsQUTfA5QZPYpT3S/zTx0yeL1L83rFb4S/WS443nXE05Wjmp0gIO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(8936002)(5660300002)(8676002)(86362001)(10290500003)(66476007)(66556008)(64756008)(66446008)(66946007)(76116006)(478600001)(6506007)(9686003)(53546011)(110136005)(55016002)(186003)(2906002)(7696005)(8990500004)(54906003)(316002)(52536014)(82960400001)(71200400001)(33656002)(4326008)(82950400001)(30253002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: umVzGWS4mbKsEkQFumD924Xw4/9e30sqwX82XNT6TS3P5KD0sbYFvDjOTjy5bJMiuvWUBqdVHCQhUi+vmrNziOahVoDUpFOkp1M60jb1VjWi53mo4iVR8N2z+i6lJDJpol1861eJKHshh4adFH+AF70WrVgmsAyig5CFNxUKHjQ3R3grBlbn7WWh4YNcX3UCq6KGaShPoFt0fWEh+4pouBWcvuf2ci6JNZMX47rdzNUe31qfgPz6+zRrFhOSATYdiY1DtRWO0dzXHsTferjfN+PbMomktek1hhPdxr02BjeYeEFboZcaM/X7aJ0hEeZ7iXL9o2fdQTPOLvCalpwoC14j3PgeZIyhvBQAkIvuBA+Iz1PgLhlQkVcsam2XAVHHjXA5oIphf+W57C2ZrK9FUi/ziIVZ4GlkcRfLpZJH9K0s/sKEqOOy9k7HREjgozu2Eh3wjg2k6/miDgvaTTm6PRwYe8FriA2UqqUE6MdtbkZK1Ge49C8Oa8s+beNeYAZrRkcHPzdxD1+GygsKCw1h1YP/gEmXopzQ94hgPrQm1JbqJqYDrV2zX2j/NUBxU/Q3qasPu0QjKzkCcSFjrrXqc12OYKy1EGoblnAwa6+pZUZr9O1d5hMr3Sfg5nLnvL+8sVMlb6HpnfzkpAJqSxpbZBeiz21x/Ksk7nRnmtVLSSJTQdb3hzfbDHzbJc87QK+Q8bB480+eHPZo6Ejy6NUHLrNl1e0nJi5EelqQ+0ctUch177n/aAD7FZM9cqIEr+OSvOnukoqGvmPZMcxk3RRA6PhvRpGqDnkCEICL+CeeKXL9AMza0Lmddmx3Zs750JNSHD28eHxkfSR4WpwSD/RtIM9baEXnkqSMkjaoIV5QJZA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6de7cd-07e4-4f5f-45af-08d7ea460df7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 00:58:09.4726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jv8pOdbPKOKlxGToV2RY2GadewavaFjrlLv1qhJSB8mL1h8EO1mMfxdb24Se3vovaXZOzoq/TWWL/DYGIBni8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0323
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogU3Vu
ZGF5LCBBcHJpbCAyNiwgMjAyMCAxMTozNCBBTQ0KPiBUbzogUmFmYWVsIEouIFd5c29ja2kgPHJq
d0Byand5c29ja2kubmV0PjsgRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4NCj4gPj4g
LS0tIGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jDQo+ID4+ICsrKyBiL2tlcm5lbC9wb3dlci9o
aWJlcm5hdGUuYw0KPiA+PiBAQCAtODk4LDYgKzg5OCwxMyBAQCBzdGF0aWMgaW50IHNvZnR3YXJl
X3Jlc3VtZSh2b2lkKQ0KPiA+PiAgCWVycm9yID0gZnJlZXplX3Byb2Nlc3NlcygpOw0KPiA+PiAg
CWlmIChlcnJvcikNCj4gPj4gIAkJZ290byBDbG9zZV9GaW5pc2g7DQo+ID4+ICsNCj4gPj4gKwll
cnJvciA9IGZyZWV6ZV9rZXJuZWxfdGhyZWFkcygpOw0KPiA+PiArCWlmIChlcnJvcikgew0KPiA+
PiArCQl0aGF3X3Byb2Nlc3NlcygpOw0KPiA+PiArCQlnb3RvIENsb3NlX0ZpbmlzaDsNCj4gPj4g
Kwl9DQo+ID4+ICsNCj4gPj4gIAllcnJvciA9IGxvYWRfaW1hZ2VfYW5kX3Jlc3RvcmUoKTsNCj4g
Pj4gIAl0aGF3X3Byb2Nlc3NlcygpOw0KPiA+PiAgIEZpbmlzaDoNCj4gPg0KPiA+IEFwcGxpZWQg
YXMgYSBmaXggZm9yIDUuNy1yYzQsIHRoYW5rcyENCj4gDQo+IEhpIFJhZmFlbCwNCj4gDQo+IFdo
YXQgaXMgbm90IGNsZWFyIHRvIG1lIGlzIGhvdyBrZXJuZWwgdGhyZWFkcyBhcmUgdGhhd2VkIGFm
dGVyDQo+IGxvYWRfaW1hZ2VfYW5kX3Jlc3RvcmUoKSBoYXMgZmluaXNoZWQ/IFNob3VsZCBhIGNv
bW1lbnQgcGVyaGFwcyBiZSBhZGRlZA0KPiBhYm92ZSB0aGUgZnJlZXplX2tlcm5lbF90aHJlYWRz
KCkgY2FsbCB0aGF0IGV4cGxhaW5zIGhvdw0KPiB0aGF3X2tlcm5lbF90aHJlYWRzKCkgaXMgaW52
b2tlZCBhZnRlciBsb2FkX2ltYWdlX2FuZF9yZXN0b3JlKCkgaGFzDQo+IGZpbmlzaGVkPw0KPiAN
Cj4gQmFydC4NCg0KSGkgQmFydCwgUmFmYWVsLCBJIHdvdWxkIHN1Z2dlc3QgdGhlIGJlbG93IGNv
bW1lbnQ6DQoNCklmIGxvYWRfaW1hZ2VfYW5kX3Jlc3RvcmUoKSBzdWNjZWVkcywgaXQgd29uJ3Qg
cmV0dXJuLCBhbmQgdGhlDQpleGVjdXRpb24gd2lsbCBiZSByZXN0b3JlZCBmcm9tIHRoZSAnb2xk
JyBrZXJuZWwncyBoaWJlcm5hdGUoKSAtPiANCmhpYmVybmF0aW9uX3NuYXBzaG90KCkgLT4gY3Jl
YXRlX2ltYWdlKCkgLT4gc3dzdXNwX2FyY2hfc3VzcGVuZCgpLA0KYW5kIGxhdGVyIGhpYmVybmF0
ZSgpIC0+IHRoYXdfcHJvY2Vzc2VzKCkgd2lsbCB0aGF3IGV2ZXJ5IGZyb3plbg0Ka2VybmVsIHBy
b2Nlc3MgYW5kIHVzZXJzcGFjZSBwcm9jZXNzIG9mIHRoZSAnb2xkJyBrZXJuZWwuDQoNClRoYW5r
cywNCi0tIERleHVhbg0K

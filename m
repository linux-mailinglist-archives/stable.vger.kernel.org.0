Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9C31CEBBD
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 06:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgELEDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 00:03:49 -0400
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:47437
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgELEDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 00:03:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l87i1/jCLUHo9xo4N1eHQYkJ1dMt/IqFYISLExPirc9VLC8zW3dE/2WNtLW8J+28cJtp2xi13Mc7KE7Nz+fXjwK0uVe3FvOPwISDY6xBizYslRVwknFOt6ek1W6vc+MZ4P+ofcBwcBgucj9PK8DYOipFxucJcq9sQt8iiypgsRolcXtOKFTNSli7pYlbcplun5SfdHAZEIiYM1/AGX1/6oWZ3Tb0vo8b0oGdREWE/Fx2znMNbtwwaa7NP43vlCowLwa/F/g7CLAskVcffNu7gyDVjyFEFKQ2TD0LkQIP6FTjtPX75v5Fh+zy9fCRlkTolH9hN0ZjyeACKav0C760+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0uGWEzbZsJlNLbDFrkBF+WjX6XOOQLiqFW1L5JldkI=;
 b=BsMLmT+Dq0iIGM8RwZVr+7i4mCQkSN5xfrwFi4hf7Xu29nrsZzLgYCViF0Ox1ZCuElncIGsV/HcpZ37/LN1Fp7jzs9LALN7L8y6mIjs8/zrsl4Eu09L9JuT2VOo2Ykhz/9yLZ+jStUOWFU4LL6KvdSw2IvdIKdH1EVSpJQmfFRh2jjfqHF79OdSt2xcM7J2UKQSzg13fAb1FdRZ0jIkIDD1Y6Ym+o06j6wnXv9OBPq1TeOjavJmCtxNESLq9ONip22w2igknh5mMQLBi4l0oWxumKT3BSLVNihetg8xfqOUZ8UOxmrczyE0mwu2RjWl+Qt3G5GqesgWdjgi2Hpcduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0uGWEzbZsJlNLbDFrkBF+WjX6XOOQLiqFW1L5JldkI=;
 b=Bxwf6NUs+Ytx0ckizR9kbdgLgHyL5YriBe3H5WKwK/Qz65KPN2ASq27Ex7UNIW4KxI8mAMJEguX7pJsJ074MqSk1DrglKGNlum7h367g23c6rJXznRTFqiqNjW2O8YlepL0D7v359PcqzvQTVwDdeADh2cHXZ3wODmfNgBxzd/4=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB7095.eurprd04.prod.outlook.com (2603:10a6:20b:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Tue, 12 May
 2020 04:03:45 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792%9]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 04:03:44 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>, Jun Li <jun.li@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when remove
 host
Thread-Topic: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when
 remove host
Thread-Index: AQHWKAYIb9tWY8B1fk+YJlcdJaEypKij0LUAgAACtbA=
Date:   Tue, 12 May 2020 04:03:44 +0000
Message-ID: <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
In-Reply-To: <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [180.171.74.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 244a64f1-fb9b-46a0-ef23-08d7f6297728
x-ms-traffictypediagnostic: AM7PR04MB7095:|AM7PR04MB7095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB70953EB8746DEB2D7623FAA78BBE0@AM7PR04MB7095.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zDjC3I1/QXK2ZDdRZe/2hqcRaKl4asCJt8k84OypS/NThFksU0yN1tSEX9HAaNkn9/K1s9mnXp3MQoAOLQBGw9TtWdrtY8TPkonYfk3rOz6o1mSCfEgS0rcjljR5r2KPaWrl8eJa+SMcgac3VKUG1IakIFP6Rs1RfDzAyKG/N9sA+HcHMdiiW2tDH/mf7s/GwaOdpvQME3Le8ipKCfEUlnRz/+CeNeJ1HMq6dVOX9LksvYNDXTLH8AHX1b9acMu6Lk7215HCyHZJXYBu0Zws5q0To6NjZJne9jE6upcLsKSYbM3UYvY/HVqdKXt8TYqYT41qvobMddOW5BpfOCU1GdJW18qdamILQUMQRRQd5YmO48CVsyCI4qcVJAS4dT2Vnxt2WNtQzgX6UXr6pxSy+oXvkWn9EKcN6lg0EELBXHoopGzdupLRtl/Jrhs4GQoTgX3dawGfbmm5MdOZ6Nd5GCojbhB08LPXgXag9pLeW8qq+keq2hgvFUXNKYqNbPHyw05xI8afrLSodETaYyKcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(33430700001)(33656002)(71200400001)(44832011)(66946007)(33440700001)(66476007)(66556008)(186003)(53546011)(26005)(478600001)(64756008)(76116006)(2906002)(66446008)(7696005)(6506007)(86362001)(5660300002)(8936002)(316002)(55016002)(52536014)(54906003)(8676002)(4326008)(110136005)(9686003)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Rf6xpDuZ9/IeBHNkUNMtbjGZsvKuuR4IReqGU1L8VQ9tQubuvogCoN7gvnE83G2WdTV5uyoIXsJ/cUhfHB8GY3JTXBG/M6jDxbYtL63EflVhIVx6LePfhY7gbAMJQJstuqb/7bCSZoDDfZxlxP/Tr+kXNSrLxyC5aVWYsxUquOU/r7gA1gVSf8FIXuvN0dBJ/1/PhsFoJwGkupJwx96dda8njaw7ggCs0rz0yhUqakBhv/Bob4qxm8Y2GhSsVO6kLnq/ArETFlgf5FBR5Ain926lgEImoeUEAOGDJ7PP60TpxKXO/uvT5FN8QH6T56VetXrIxDfJKuv6igUIXu9QCNpwDMJZyjbV82DaTAjr3/RTUbEImG2OZwLSs2zJd92LwbQrtHjB8W5a6jpQzbWVxmtZgguqVusQtmt/udDIpaACI9zZnl/dm00ljJTqhfd1jHRBx0nREiiQuTytISKt8Y60hCZCdi8ukHQmSbwINJ4AdPEXqL49Cky4vJkwAts4
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 244a64f1-fb9b-46a0-ef23-08d7f6297728
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 04:03:44.8442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqkKIE3a6OdfF/tbLlq76i6eDXba/gIIRKTzBm7TZmSRAPdQ62Zzs+/0KLv/Iy9S2mMyJq0yzE7fVoJdGYr1cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7095
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IA0KPiANCj4gT24gNS8xMi8yMDIwIDg6MDUgQU0sIFBldGVyIENoZW4gd3JvdGU6DQo+ID4gQ2M6
IEJhb2xpbiBXYW5nIDxiYW9saW4ud2FuZ0BsaW5hcm8ub3JnPg0KPiA+IENjOiBNYXRoaWFzIE55
bWFuIDxtYXRoaWFzLm55bWFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogPHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmc+DQo+ID4gRml4ZXM6IGIwYzY5YjRiYWNlMyAoInVzYjogaG9zdDogcGxhdDog
RW5hYmxlIHhIQ0kgcGxhdCBydW50aW1lIFBNIikNCj4gPiBSZXZpZXdlZC1ieTogUGV0ZXIgQ2hl
biA8cGV0ZXIuY2hlbkBueHAuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIEp1biA8anVuLmxp
QG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdXNiL2hvc3QveGhjaS1wbGF0LmMgfCAx
ICsNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLXBsYXQuYw0KPiA+IGIvZHJpdmVycy91c2IvaG9z
dC94aGNpLXBsYXQuYyBpbmRleCAxZDRmNmY4NWYwZmUuLmYzOGQ1MzUyOGM5NiAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGxhdC5jDQo+ID4gKysrIGIvZHJpdmVycy91
c2IvaG9zdC94aGNpLXBsYXQuYw0KPiA+IEBAIC0zNjIsNiArMzYyLDcgQEAgc3RhdGljIGludCB4
aGNpX3BsYXRfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKmRldikNCj4gPiAgCXN0cnVj
dCBjbGsgKnJlZ19jbGsgPSB4aGNpLT5yZWdfY2xrOw0KPiA+ICAJc3RydWN0IHVzYl9oY2QgKnNo
YXJlZF9oY2QgPSB4aGNpLT5zaGFyZWRfaGNkOw0KPiA+DQo+ID4gKwlwbV9ydW50aW1lX2dldF9z
eW5jKCZkZXYtPmRldik7DQo+IFdoZXJlIGlzIGNvcnJlc3BvbmRpbmcgX3B1dCgpIGNhbGw/DQo+
IA0KIA0KQXQgdGhlIGVuZCBvZiB0aGlzIGZ1bmN0aW9uLCB0aGVyZSBpcyBhIHBtX3J1bnRpbWVf
c2V0X3N1c3BlbmRlZCgmZGV2LT5kZXYpLiBDYWxsaW5nDQogcG1fcnVudGltZV9wdXRfc3luYygm
ZGV2LT5kZXYpIHdpbGwgY2F1c2UgeGhjaV9wbGF0X3J1bnRpbWVfc3VzcGVuZCBpcyBjYWxsZWQN
CndoaWNoIGlzIG5vdCBleHBlY3RlZC4NCg0KUGV0ZXINCg==

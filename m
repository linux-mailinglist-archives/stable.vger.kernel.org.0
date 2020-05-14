Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A641D2B18
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgENJSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 05:18:18 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:57163
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbgENJSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 05:18:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqEV5UZUKwcdIAwQyRxNX4J980y92dxfE4L/R2miPRKkCdtgRmfAwdIYwTB00lG7sNWW6E0vCwEMxt3WBU+qTiulCcugjhWPHjoYUzmrVU3OBD2MA+mHNj4rvcHnr7DOcDZqH8eiigcOL/H+VK7pLr+upBsStAl3ggT9HueNtzHiQx5dMlQovGF5Y71PL9W4avwa7G/oA1VfOqyat15wTu2qIHiAXVmTG7nFJp+DJbeiDRv4/69xvO1eANMs5uu5oTxUwYngv2gdaYJM3bk5vxkJMI63ysDHbQ/OdXnFl6E2buMzvQOsjbFppKWW1Eiw5H5+Vb440ZD7A6KkX8jDxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiSIyGpk6eUvjqB7gRZ59HGz2xBigkOXs43c5B63DcY=;
 b=ht2kKZj6WdY4ZTyqEpYdSn5ceUiiSt5WfD2KDeeAYSeqCMUfJ+ag0yJUqAq50n+XL7gElXF6FHl8RQswSN6qZiCUjBb4CeTIDK7Nj4rYmA46IFUiQk+fo15YXlYeNKzOLY/eEogioj1/ky7sFzK46hffcPfNkZ7LoRHEzumKI4DMD5le9rP/ovWTIrLTyKJCbzuh/oWjaaJ9tW5/Y9QzvEt1EMXPuozK9yT6mjFBxjBjKJObv8cU1HIpskCaxe2qv2t0y7iIq2SeGxkPXOofKV3bsMwOO91Qqw748Ci5edh6oQPkTBjJThWgVvf9cOLnH+U1yFJLH10l/FYQqrMkXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiSIyGpk6eUvjqB7gRZ59HGz2xBigkOXs43c5B63DcY=;
 b=QnA/wAKTtbyMGdxux0M80dFSOCznIIJUdP3zzGhg9fJth9+Yg/W1YotGix1afKa4VpTMR1jsS1V0Go5ol+EFUgA4XpKBJH0trYUi6vWBMwTng+4lQILzOFwcBfUGltysVvKnod4UBxSns8F+z0qfFckEzjo+T0vRL612WgRYnXA=
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com (2603:10a6:803:127::18)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 09:18:12 +0000
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::5086:ae9e:6397:6b03]) by VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::5086:ae9e:6397:6b03%7]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 09:18:12 +0000
From:   Jun Li <jun.li@nxp.com>
To:     Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: =?utf-8?B?UkU6IOWbnuWkjTogW1BBVENIIDEvMV0gdXNiOiBob3N0OiB4aGNpLXBsYXQ6?=
 =?utf-8?Q?_keep_runtime_active_when_remove_host?=
Thread-Topic: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggMS8xXSB1c2I6IGhvc3Q6IHhoY2ktcGxhdDoga2Vl?=
 =?utf-8?Q?p_runtime_active_when_remove_host?=
Thread-Index: AQHWKAYJU7WBAPFTDECZ4QCbYfct56ij0LUAgAAD5wCAATYzgIABCGj5gAC7qICAAACugIAAfnKAgAABIYCAAAGmMA==
Date:   Thu, 14 May 2020 09:18:12 +0000
Message-ID: <VE1PR04MB65281EF4C768434EE0BFA91F89BC0@VE1PR04MB6528.eurprd04.prod.outlook.com>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
 <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
 <62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
 <VE1PR04MB6528D2A1C08ED9F091BCF3FD89BF0@VE1PR04MB6528.eurprd04.prod.outlook.com>
 <20200514013221.GA20346@b29397-desktop>
 <20200514013425.GB10515@rowland.harvard.edu>
 <ac353786-16a5-8e23-4948-fbdef30a786f@linux.intel.com>
 <AM7PR04MB7157262EBB26A33F69226AE48BBC0@AM7PR04MB7157.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB7157262EBB26A33F69226AE48BBC0@AM7PR04MB7157.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc57b932-429c-4f7f-5955-08d7f7e7b9fd
x-ms-traffictypediagnostic: VE1PR04MB6639:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66397AB070087A101F50BB4989BC0@VE1PR04MB6639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kdK4YTiKlRxaPMHR6mSt8Hm4DlR1drK7W0UQDuVOQM/HSp4r92ZmitGhnz519LXaaMrM1bzeNmwUoB2GqF7fvd9EnTtOR52nujO7TUFNUFeDiO4kLXjPO3DkhzDMgjBjM1WL8IMjqTt2IxSU4dQ3tHkQnvl+nhWTkLfNIlsTeAp8bjsGxb1H1U8uMuWB4rVPLvlGxZhjD+unnX/mvNdtRIXWXs6vz7Tw4tQVB5UrHzj3yALA2rwAwM4BKybcOvGdR1SlI+uGpITixr28W2PZub7mDBxmLDtgc0Zkl9ell7nSXGoeJNI/9sJ/Y4/4JbZT9p63cMgzBsr+3X0orUyoPpcWwZwfgYRjosQgvtWv1I2kU/oazTIjVHyV68wZu4EUv12tvrffmSjPdTQbCC+x6RaSXBIEnFzbdzxBMiJwqll46XbUokNCTJ/xwvcu0EO/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6528.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(44832011)(52536014)(7696005)(86362001)(110136005)(224303003)(6506007)(8936002)(2906002)(186003)(53546011)(71200400001)(64756008)(55016002)(5660300002)(316002)(26005)(54906003)(76116006)(4326008)(66446008)(9686003)(66946007)(66556008)(478600001)(66476007)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eA7kLDNsm4oncPu9s9VWZAIygGRxhwaZMG5tcUY9GRuk30mcJxp8G6AnwZtaDpSsAJHOTchttxP9YrEeGjU3o5n1XlUyULPWwV/imS5DjMg4Cnz2hVBwBvucPAEX7Qk8Dc3AjEGehbGVW389TnlaKsdUv+0tjjOfwnjFNrqIeybD5CHnmevx/FwiSzL+07Bn8Rg+u3iVUiQh5qmvliQIcSvkur9kcXBoAgrc4VaSFGnQOf5iq4341p6Lzs3LebXpH6oXfuAsuFtBuU2sBvmzB6I7ElkCew4Ko98ItnN4spIcT06nXKNQpHn5n3Vurg3V/LW73q2iLAr60N+Gqp2iqozCXF6Dc1ohbJEXS0Kktll9Mxp+xKDGPMeOS8Xo0U2SZLwBuT/gdbAXZfE9KyeQB/tpl7YVp33nLkXBh4gsHgMR3VETu1yNGpNrNOlzma0AY6yuSgNVVJ1Gn9TeStGF8ufOO4FyaS2QhRL/ADFO3I4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc57b932-429c-4f7f-5955-08d7f7e7b9fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 09:18:12.4909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+R87pcAkJhPeV2OHmnQWE1+mJA+ayqmlxqc/d9Bt+LLWHw+GOSu/nKaxOoLY+I8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgQ2hlbiA8cGV0
ZXIuY2hlbkBueHAuY29tPg0KPiBTZW50OiAyMDIw5bm0NeaciDE05pelIDE3OjExDQo+IFRvOiBN
YXRoaWFzIE55bWFuIDxtYXRoaWFzLm55bWFuQGxpbnV4LmludGVsLmNvbT47IEFsYW4gU3Rlcm4N
Cj4gPHN0ZXJuQHJvd2xhbmQuaGFydmFyZC5lZHU+DQo+IENjOiBKdW4gTGkgPGp1bi5saUBueHAu
Y29tPjsgTWFudSBHYXV0YW0gPG1nYXV0YW1AY29kZWF1cm9yYS5vcmc+Ow0KPiBtYXRoaWFzLm55
bWFuQGludGVsLmNvbTsgbGludXgtdXNiQHZnZXIua2VybmVsLm9yZzsgZ3JlZ2toQGxpbnV4Zm91
bmRhdGlvbi5vcmc7DQo+IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBCYW9saW4g
V2FuZyA8YmFvbGluLndhbmdAbGluYXJvLm9yZz47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUkU6IOWbnuWkjTogW1BBVENIIDEvMV0gdXNiOiBob3N0OiB4aGNpLXBsYXQ6
IGtlZXAgcnVudGltZSBhY3RpdmUgd2hlbiByZW1vdmUNCj4gaG9zdA0KPiANCj4gDQo+ID4gPj4+
DQo+ID4gPj4+PiB4aGNpX3BsYXRfcmVtb3ZlKCkNCj4gPiA+Pj4NCj4gPiA+Pj4+IMKgIHBtX3J1
bnRpbWVfZGlzYWJsZSgpDQo+ID4gPj4+DQo+ID4gPj4+PiDCoCA8cmVtb3ZlIGFuZCBwdXQgYm90
aCBoY2Qncz4NCj4gPiA+Pj4NCj4gPiA+Pj4+IMKgIHBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgp
DQo+ID4gPj4+DQo+ID4gPj4+DQo+ID4gPj4+DQo+ID4gPj4+PiBvciBwb3NzaWJseSB3cmFwcGlu
ZyB0aGUgcmVtb3ZlIGluIGEgcnVudGltZSBnZXQvcHV0Og0KPiA+ID4+Pg0KPiA+ID4+Pj4geGhj
aV9wbGF0X3JlbW92ZSgpDQo+ID4gPj4+DQo+ID4gPj4+PiAgcG1fcnVudGltZV9nZXRfbm9yZXN1
bWUoKQ0KPiA+ID4+Pg0KPiA+ID4+Pj4gwqAgcG1fcnVudGltZV9kaXNhYmxlKCkNCj4gPiA+Pj4N
Cj4gPiA+Pj4gwqA+ICA8cmVtb3ZlIGFuZCBwdXQgYm90aCBoY2Qncz4NCj4gPiA+Pj4NCj4gPiA+
Pj4gwqA+ICBwbV9ydW50aW1lX3NldF9zdXNwZW5kZWQoKQ0KPiA+ID4+Pg0KPiA+ID4+PiDCoD4g
IHBtX3J1bnRpbWVfcHV0X25vaWRsZSgpDQo+ID4gPj4+DQo+ID4gPj4+IEkgdGhpbmsgaXQncyBi
ZXR0ZXIgdG8ga2VlcCBydW50aW1lIGFjdGl2ZSBkdXJpbmcgZHJpdmVyIHJlbW92YWwsDQo+ID4g
Pj4+IGhvdyBhYm91dCB0aGlzOg0KPiA+ID4+Pg0KPiA+ID4+PiBwbV9ydW50aW1lX2dldF9zeW5j
KCkNCj4gPiA+Pj4gPHJlbW92ZSBhbmQgcHV0IGJvdGggaGNkJ3M+DQo+ID4gPj4+IHBtX3J1bnRp
bWVfZGlzYWJsZSgpDQo+ID4gPj4+IHBtX3J1bnRpbWVfcHV0X25vaWRsZSgpDQo+ID4gPj4+IHBt
X3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgpDQo+ID4gPj4+DQo+ID4gPj4NCj4gPiA+PiBJIHRoaW5r
IGl0IGlzIG1vcmUgcmVhc29uYWJsZSBzaW5jZSBmb3Igc29tZSBEUkQgY29udHJvbGxlcnMgaWYg
RFJEDQo+ID4gPj4gY29yZSBpcyBzdXNwZW5kZWQsIGFjY2VzcyB0aGUgeEhDSSByZWdpc3RlciAo
ZWcsIHdlIHJlbW92ZQ0KPiA+ID4+IHhoY2ktcGxhdC1oY2QgbW9kdWxlIGF0IHRoZSB0aW1lKSBt
YXkgaGFuZyB0aGUgc3lzdGVtLiBBbGFuICYNCj4gPiA+PiBNYXRoaWFzLCB3aGF0J3MgeW91ciBv
cGluaW9uPw0KPiA+DQo+ID4gTWFrZXMgc2Vuc2UgdG8gbWUNCj4gPg0KPiA+ID4NCj4gPiA+IEp1
bidzIHN1Z2dlc3Rpb24gbG9va3MgZ29vZCB0byBtZS4NCj4gPiA+DQo+ID4gPiBBbGFuIFN0ZXJu
DQo+ID4gPg0KPiA+DQo+ID4gR3JlYXQsIGxldHMgZ28gd2l0aCB0aGlzIHRoZW4uDQo+ID4gSnVu
LCBvciBQZXRlciwgY291bGQgeW91IHR1cm4gdGhpcyBpbnRvIGEgcGF0Y2ggYW5kIGNoZWNrIHRo
YXQgaXQgd29ya3M/DQo+ID4gSSBvbmx5IGdvdCBQQ0kgeEhDJ3MgdG8gcGxheSB3aXRoIG15c2Vs
Zi4NCj4gPg0KPiANCj4gSnVuLCB3b3VsZCB5b3UgcGxlYXNlIGNyZWF0ZSBhIHBhdGNoIGZvciBp
dC4gSSBoYXZlIHRlc3RlZCBpdCBhdCBDRE5TMyBwbGF0Zm9ybSwNCj4gZmVlbCBmcmVlIGFkZCBt
eSB0YWcuDQo+IA0KPiBSZXZpZXdlZC1ieTogUGV0ZXIgQ2hlbiA8cGV0ZXIuY2hlbkBueHAuY29t
Pg0KPiBUZXN0ZWQtYnk6IFBldGVyIENoZW4gPHBldGVyLmNoZW5AbnhwLmNvbT4NCg0KVGhhbmtz
LCBJIHdpbGwgc2VuZCBvdXQgYSB2MiBmb3IgdGhpcy4NCg0KTGkgSnVuDQoNCj4gDQo+IFBldGVy
DQo=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8F01D24B3
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 03:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgENBcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 21:32:03 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:54853
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725925AbgENBcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 21:32:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiEqx0dm3zgs3APpPhEBQyTihjFbAPwDRrUqSEE5wgevsM7Sg29D8EYFbP0TYh5uhXK9tvOjvuPg6D4JU2ywRsUGC4daCWQqhljX6WwtDstCDp4gZCehzDgRhofr2Nr68G8k1lTEIq1RSjDjEeQhfyE4T4AW5XRBcK/nSsiwN2tbNIrXeWG3RGn9lWJ+1CP02ZbJ5zbRjn0WM20XSWNxn/BLHScdiJ1W3iOZ1/UtOT2NFd1dX0+KAKUPwp3VfwIobCLj5+OvmYz/9v4i9H06HkL/hMMwD6IUXr8nz7AMqcnOFJ9SAuA8ktbtmXcKTKbyZ4qkr2jWgvIy900bL7jGtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx5awDYVKfd8pri/nB3BlIITBgWGM2DHIyY+hWYLYEI=;
 b=E1RvNJofNraAe8sb3pX95Y1DMjxoO3TRzASI2bJgfqVJnzwuZ017QWwfSIVBnO5UR4fUr7ojhfPjRKJwr59JK0xSOtxdECe6mC+wA7wqaIZn31mvmFaC+eWZxKHqFeXnXin0O3CBy2/2zHdBcEPf+IaduqAN4L8aGWyGeqnEmOyyP+3yBjlK1GEIjfl1dT4MpTQC9oCPmd85daDQEP3KyNU6+Kbw7EZQ035aIzwtqnEj6VMPS8mOnhalWthrasg5cWSsTEVizbMH1wL1YOqR3c9ZmWjsxQM0a1Xbq3Cy06t8PHv0iTyMC9jUo9MracP8fPoSitxLzC03oP0I98tEHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx5awDYVKfd8pri/nB3BlIITBgWGM2DHIyY+hWYLYEI=;
 b=Z6vU6xJR8L31N1Zs7vv9GxWNSNU2D76I1t11sXCjuEiqaPmWFrZtnKmp0o2nNvvAz+8oOPEP2RdI0Xl5eEWyResOLZI3IiZ7vD1l63Kb5+PPVyFNZO6tAkFPt2V8QUJNF6d8Xv7nKH/JvDhN2x67AFPgG0Asn6YQ4WhyOoMw96A=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6965.eurprd04.prod.outlook.com (2603:10a6:20b:104::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Thu, 14 May
 2020 01:31:59 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792%9]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 01:31:59 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Jun Li <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: =?utf-8?B?UmU6IOWbnuWkjTogW1BBVENIIDEvMV0gdXNiOiBob3N0OiB4aGNpLXBsYXQ6?=
 =?utf-8?Q?_keep_runtime_active_when_remove_host?=
Thread-Topic: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggMS8xXSB1c2I6IGhvc3Q6IHhoY2ktcGxhdDoga2Vl?=
 =?utf-8?Q?p_runtime_active_when_remove_host?=
Thread-Index: AQHWKAYIb9tWY8B1fk+YJlcdJaEypKij0LUAgAACtbCAATdlgIABD38AgAC0rIA=
Date:   Thu, 14 May 2020 01:31:59 +0000
Message-ID: <20200514013221.GA20346@b29397-desktop>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
 <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
 <62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
 <VE1PR04MB6528D2A1C08ED9F091BCF3FD89BF0@VE1PR04MB6528.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB6528D2A1C08ED9F091BCF3FD89BF0@VE1PR04MB6528.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 559174b0-6167-4e0a-0cdf-08d7f7a69887
x-ms-traffictypediagnostic: AM7PR04MB6965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB69655BF7F7BE610981F348698BBC0@AM7PR04MB6965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b/S9uHt5x0l2+MlpZK/zde+Ud2Xz+XJth9s5xCNzMnynUsyvFTezLzT173zPV589RwmePFnk1jaXu/tOMhFQHoRi9Kz/pMl7d7vipiaOmHw4Jd4mli3CpfAo5RFOEukW3w58uXhj7dZI4lBv9SMNArerXh89skWaJ48WEentkUlN459G+C8yHkjTR+aaYbdJgZAaoOwlRG5RM9d4I6UWWmopLP8QRyZO+DETZIhTKqVcsW2wR2nqcizy/td9RRCTkuUqzqIfcFF2yT0yOsmeCu1hkxi/FK8xf7uYBDWuBisNpON5g98fSmarCQTI+fxb9x/lJQvwRLmTuceEuwgDjhO1k+iR/xLmTp4zLIIXNWXff0M5SY7mewGlwa/k/gqIMuLp11Bsn+GJCc/645+H6RH+1InXHDCgzFSM19gA+f6Kv9rkAZxvj9pi18KGnWy5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(33656002)(91956017)(6486002)(76116006)(224303003)(66446008)(53546011)(6506007)(26005)(6512007)(66946007)(44832011)(9686003)(64756008)(8936002)(86362001)(66556008)(186003)(66476007)(478600001)(1076003)(4326008)(2906002)(71200400001)(4744005)(110136005)(54906003)(316002)(5660300002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VBmMGZtObJVTHzwYOaTMxABY38g0yL+1potik1AQO4dHDnZYiYbfUumFI68xv5aK8JMXDCmVtI+qzaOwK862zPpzPU3JUXuSmat24EIQCKXQscrD6SNK21G5POlA/UURzngOoB766ACOuZwoTh1vK0CBdl0v0A/+0TPmX/IDdIcaQZxfIwsG/yq04HagX5IYbMyQ1ObUD8heIfP3WTCUDYLnW5yUDQD43mi56FDGEGer8KcSRmrNyEsCVVG3wTptEWxjl4kvYOkC+Yl9fylVurQfTHLMT7cxKWEloJEYVpAJlMFmKl26sYG8GTcgkgyVkq9yzteObZoo7nIIf5oMGpZRSMXNmQXAAIC9KnuLtgHrX3XnnNZqAGwlNwS2rocaGckzsw0ECJMFbhbXolxx61Hgn0MaeeLj/ES8fyW75NUepAlUUixEldTpxVHgj5YmLUSuIgGwYziGvbuCd5oTQCLV4EllBYPhShOQiFdPa+k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B348B41D47BDBE4EBF29E6FC32B895C6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559174b0-6167-4e0a-0cdf-08d7f7a69887
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 01:31:59.0499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dLOS/GWXGscNXYCUGCdw92BcKzViL/vUkusUktyBI0Nm7toJ9CysY99pIzGWgi+L+6bdOyHU56g0+GVB+ThObA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6965
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjAtMDUtMTMgMTQ6NDU6NDIsIEp1biBMaSB3cm90ZToNCj4g4oCLDQo+IC4uLg0KPiA+IFdv
dWxkIGl0IG1ha2Ugc2Vuc2UgdG8gY2hhbmdlIHhoY2lfcGxhdF9yZW1vdmUoKSB0bw0KPiANCj4g
DQo+IA0KPiA+IHhoY2lfcGxhdF9yZW1vdmUoKQ0KPiANCj4gPiDCoCBwbV9ydW50aW1lX2Rpc2Fi
bGUoKQ0KPiANCj4gPiDCoCA8cmVtb3ZlIGFuZCBwdXQgYm90aCBoY2Qncz4NCj4gDQo+ID4gwqAg
cG1fcnVudGltZV9zZXRfc3VzcGVuZGVkKCkNCj4gDQo+IA0KPiANCj4gPiBvciBwb3NzaWJseSB3
cmFwcGluZyB0aGUgcmVtb3ZlIGluIGEgcnVudGltZSBnZXQvcHV0Og0KPiANCj4gPiB4aGNpX3Bs
YXRfcmVtb3ZlKCkNCj4gDQo+ID4gIHBtX3J1bnRpbWVfZ2V0X25vcmVzdW1lKCkNCj4gDQo+ID4g
wqAgcG1fcnVudGltZV9kaXNhYmxlKCkNCj4gDQo+IMKgPiAgPHJlbW92ZSBhbmQgcHV0IGJvdGgg
aGNkJ3M+DQo+IA0KPiDCoD4gIHBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgpDQo+IA0KPiDCoD4g
IHBtX3J1bnRpbWVfcHV0X25vaWRsZSgpDQo+IA0KPiBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIGtl
ZXAgcnVudGltZSBhY3RpdmUgZHVyaW5nIGRyaXZlciByZW1vdmFsLA0KPiBob3cgYWJvdXQgdGhp
czoNCj4gDQo+IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKQ0KPiA8cmVtb3ZlIGFuZCBwdXQgYm90aCBo
Y2Qncz4NCj4gcG1fcnVudGltZV9kaXNhYmxlKCkNCj4gcG1fcnVudGltZV9wdXRfbm9pZGxlKCkN
Cj4gcG1fcnVudGltZV9zZXRfc3VzcGVuZGVkKCkNCj4gDQoNCkkgdGhpbmsgaXQgaXMgbW9yZSBy
ZWFzb25hYmxlIHNpbmNlIGZvciBzb21lIERSRCBjb250cm9sbGVycyBpZg0KRFJEIGNvcmUgaXMg
c3VzcGVuZGVkLCBhY2Nlc3MgdGhlIHhIQ0kgcmVnaXN0ZXIgKGVnLCB3ZSByZW1vdmUNCnhoY2kt
cGxhdC1oY2QgbW9kdWxlIGF0IHRoZSB0aW1lKSBtYXkgaGFuZyB0aGUgc3lzdGVtLiBBbGFuICYN
Ck1hdGhpYXMsIHdoYXQncyB5b3VyIG9waW5pb24/DQoNCi0tIA0KDQpUaGFua3MsDQpQZXRlciBD
aGVu

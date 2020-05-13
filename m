Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D91D17D9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388927AbgEMOpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 10:45:50 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:29282
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388806AbgEMOpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 10:45:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6rTLYWbuiTeT6AgMfrisR4qN/83HaQz/vZ9mM6RwOOgK6pR8HFNkje1KzmJ6HxeKV9eO5t+FOdF0PROxnbIUGbtJuY2SM7rFKm+GoeEhLkUlsJBNlnjzFIBUTH5QBSFK79e5mN6h1bAW98lShu4YWsM+j90ABfCePE3kp5hy/izZHnHyyszKEMFYXLW+giqbZYVPftI+QwiKsKAFBS+30SgAE1DWWCyl0/G6KthphaRzWfcwTGsvT9LDgvCb8UkGmZ6XLvY90IAksP3c7dT4DkC4rlzQsKEhz9Tl70aOgAlw/A54E9xld78/Q4NsuJk/pQU2r1PJoE49tSy8+USJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K91445mLyzN1IDlGdsKg5jcrr6tgFRU8cIU8ihjiCLI=;
 b=DvOV4levdEXgZsdfTp3pYEpUVLMpdA6MbL1W9bxiEBWmEMhkgUn6fjHGW/C9HIBfqABe9sxXn2Nk/zeFRnZNQFbaSqxZulMNh07R9xxExBgZaU8EBrjdkvpeA8okBL8B2Q2rZZq10VRD0VewttQzNRmZVRAk6sxjizzwiTSTD3mG/S8TqQ52E4g4JYQXqpFVNurTvQoHPey4StlAS6xcXSKcFis7u5w9LJ77vzkRGW+4LGdfQqpjRh0iFCI7EiAHXJdOQhh4YCfa9tqaeFwHKy4qLVwUHgKtm7vUMDbTBwsRcCWckGmXPg04KL3jLHtqxR/ketQEq+ItY7yyKN2HTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K91445mLyzN1IDlGdsKg5jcrr6tgFRU8cIU8ihjiCLI=;
 b=rvJGuj/8NMrimDOrshnLNbVOkUGAZU4bf0c54wMA9JjUx0CKGgI0MPnJiv1J1cZc70KaJpbobXqSQn+o6UpWIX8lnywqw9mVokSBRBmvVl2JSORWA8foy/R6merJfTd1YzU7SpSaXDizcFmDXH5o6iphOPNZXatQ5GIvsWo2r6g=
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com (2603:10a6:803:127::18)
 by VE1PR04MB6493.eurprd04.prod.outlook.com (2603:10a6:803:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 13 May
 2020 14:45:43 +0000
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::5086:ae9e:6397:6b03]) by VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::5086:ae9e:6397:6b03%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 14:45:43 +0000
From:   Jun Li <jun.li@nxp.com>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Peter Chen <peter.chen@nxp.com>,
        Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggMS8xXSB1c2I6IGhvc3Q6IHhoY2ktcGxhdDoga2Vl?=
 =?utf-8?Q?p_runtime_active_when_remove_host?=
Thread-Topic: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when
 remove host
Thread-Index: AQHWKAYJU7WBAPFTDECZ4QCbYfct56ij0LUAgAAD5wCAATYzgIABCGj5
Date:   Wed, 13 May 2020 14:45:42 +0000
Message-ID: <VE1PR04MB6528D2A1C08ED9F091BCF3FD89BF0@VE1PR04MB6528.eurprd04.prod.outlook.com>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
 <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>,<62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
In-Reply-To: <62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [49.84.202.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00683f47-b873-4eac-d4cc-08d7f74c5056
x-ms-traffictypediagnostic: VE1PR04MB6493:|VE1PR04MB6493:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB649375BF4E5483C464860B6E89BF0@VE1PR04MB6493.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFly1OjloWHr8Sx0JsHEsg3sZ4y5ndPSyptSs3fN3WAJKGTBqiBdX7NQwqBNHLg1B+lfjjyvRSLNrEwA2Evl3V0TqbYrIRUU7Gn/rJHZUmlSYK6/PCIN4sjxH3AFgIUV/Y38xDd6oXJ1R2J+i3GSxYYoOhVMJjrhPpXriFbgT8VFln+7J79sGUZKIAWArydGAu+JX5ln68jLIrwZvCVIV2HoC6bufRe1W3R14Mxx0Oe4OYBkPvehhamZRcON7dS6hhhCKKVYR5AsoOtbBuKvk2WlpvzsBVD19Ojg8tjYMHHypSsN3wT+uSHnve3Hs96tFECVqlYOSdvZFkAU3jj47dZZ1aYq5hjQXR9OGcIyw0yC61VVafcs2Dpxm6ix5Lxl54ZyFE96ImX/q1sjlgwhykn2N6Qa4WIXH4yaWlgfy4xGvqdniqFYGdNeQAsfJbMhKEsy2fXfrY+VymH9890HKt0aYAPiSYQVn2fS+aqbOEdsb25LjXFSywEnzqshsbGG4v9/UaztWwGsmffWvzu7nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6528.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33430700001)(64756008)(33656002)(5660300002)(9686003)(478600001)(55016002)(110136005)(54906003)(224303003)(316002)(2906002)(6506007)(7696005)(52536014)(8936002)(91956017)(66476007)(66446008)(66946007)(76116006)(66556008)(33440700001)(71200400001)(26005)(4326008)(44832011)(86362001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dckPpGdF+Yh++CXx3OnuKTjyC6sKc7xnUFGsIB51d/gbUT01QponRlbX6z2dJkaWadgqbeQSFI7/2f9rS6j/ErUSyS4XSXtxLlPdWvmr/HBZ/pLscyd+J8o7t9MbHEwHy+v2LmT3MM2XidivRJUOR8YI/bE3WLg+JkGuGWwP5G0Tv15sM1XEdm2XG5ehblUTR2nc+rQ7GL11ir72NH5XtT9H5OI3weX7fdNFlHFs8tVfxEt0O2aZYGdyLOkUwgl+jOtSBfqGjHYHKjfcN9yt19R8zUPKwUqHZtSRf3joRmj80pqBcKhi9XdnnK7PzWoXlzVtTnnmrMt8tPh3L2LJlQ0VJrHpRfhQrMRA01Re3n6JLDlWBoUd31x8bvwZzQJ84cdPZNiLV7V4qLQYUiPbELT2j2UZAfoSsYDAcSZBWMJWXioFFhlUJy8HrH1WG+a2rjYvwGtEBjH6Ys+pnR7K7t2lanmYJdzPyQj3fcOgfJk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00683f47-b873-4eac-d4cc-08d7f74c5056
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 14:45:42.9809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dr1uU5yRy9tKA7POnXP0inlAkzHRlAKzUVPNF9QUTA1J2Y6QSI6y52gI3E3CWI3a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6493
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

4oCLCi4uLgo+IFRoaXMgc2VlbXMgb2RkLAoKPiBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IHBtX3J1
bnRpbWVfc2V0X3N1c3BlbmRlZCgpIHdvdWxkIGNhbGwgcG1fcnVudGltZV9wdXRfc3luYygpPwoK
PiBJIHRob3VnaHQgcG1fcnVudGltZV9zZXRfc3VzcGVuZGVkKCkgaXMgdXNlZCB0byBsZXQgcG0g
Y29yZSBrbm93IHRoZSBoYXJkd2FyZSBpcyBzdXNwZW5kZWQsCgo+IGFuZCBpbmZvcm0gdGhlIHBh
cmVudCBvZiB0aGlzLCBwb3NzaWJseSBhbGxvd2luZyBwYXJlbnQgdG8gcnVudGltZSBzdXNwZW5k
LiAKCj4gTm90IHN1cmUgaWYgaXQncyBuZWVkZWQgaW4gdGhlIHJlbW92ZSBmdW5jdGlvbi4gCgo+
IEl0IG1ha2VzIHNlbnNlIHRvIGFsbG93IHRoZSBwYXJlbnQgdG8gc3VzcGVuZCwgYnV0IHhoY2kg
aXNuJ3QgcmVhbGx5IHN1c3BlbmRlZC4KCj4gWWVzIGlzIHN0b3BwZWQsIGJ1dCB3ZSBjYW4ndCBy
ZXN1bWUgb3VyIHdheSBiYWNrIHRvIGEgYWN0aXZlIHN0YXRlLgoKPiAKCj4gQ291bGQgaXQgYmUg
dGhhdCB0aGUgcnVudGltZSBzdXNwZW5kIGNhbGwgeW91IGFyZSBzZWVpbmcgaXMgYmVjYXVzZSB3
ZSBhcmUgcmVtb3ZpbmcgYWxsIGNoaWxkIGRldmljZXMsCgo+IGRpc2Nvbm5lY3RpbmcgYW5kIGZy
ZWVpbmcgZXZlcnl0aGluZywgaW5jbHVkaW5nIHJvb3RodWJzIGFuZCBoY2Qncy4gCgo+IE1heWJl
IHJ1bnRpbWUgcG0gc2hvdWxkIGJlIGRpc2FibGVkIGEgYml0IGVhcmxpZXIuCgo+IAoKPiBDdXJy
ZW50bHkgcHJvYmUgYW5kIHJlbW92ZSBsb29rcyBsaWtlOgoKPiAKCj4geGhjaV9wbGF0X3Byb2Jl
KCkKCj4gcG1fcnVudGltZV9zZXRfYWN0aXZlKCkKCj4gIHBtX3J1bnRpbWVfZW5hYmxlKCkKCj4g
wqAgcG1fcnVudGltZV9nZXRfbm9yZXN1bWUoKQoKID4gLi4uCgo+IHBtX3J1bnRpbWVfcHV0X25v
aWRsZSgpCgo+IMKgIHBtX3J1bnRpbWVfZm9yYmlkKCkKCj4gCgo+IHhoY2lfcGxhdF9yZW1vdmUo
KQoKPiDCoCA8cmVtb3ZlIGFuZCBwdXQgYm90aCBoY2Qncz4KCj4gwqAgcG1fcnVudGltZV9zZXRf
c3VzcGVuZGVkKCkKCj4gwqAgcG1fcnVudGltZV9kaXNhYmxlKCkKCsKgIAoKPiBXb3VsZCBpdCBt
YWtlIHNlbnNlIHRvIGNoYW5nZSB4aGNpX3BsYXRfcmVtb3ZlKCkgdG8KCgoKPiB4aGNpX3BsYXRf
cmVtb3ZlKCkKCj4gwqAgcG1fcnVudGltZV9kaXNhYmxlKCkKCj4gwqAgPHJlbW92ZSBhbmQgcHV0
IGJvdGggaGNkJ3M+Cgo+IMKgIHBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgpCgoKCj4gb3IgcG9z
c2libHkgd3JhcHBpbmcgdGhlIHJlbW92ZSBpbiBhIHJ1bnRpbWUgZ2V0L3B1dDoKCj4geGhjaV9w
bGF0X3JlbW92ZSgpCgo+ICBwbV9ydW50aW1lX2dldF9ub3Jlc3VtZSgpCgo+IMKgIHBtX3J1bnRp
bWVfZGlzYWJsZSgpCgrCoD4gIDxyZW1vdmUgYW5kIHB1dCBib3RoIGhjZCdzPgoKwqA+ICBwbV9y
dW50aW1lX3NldF9zdXNwZW5kZWQoKQoKwqA+ICBwbV9ydW50aW1lX3B1dF9ub2lkbGUoKQoKSSB0
aGluayBpdCdzIGJldHRlciB0byBrZWVwIHJ1bnRpbWUgYWN0aXZlIGR1cmluZyBkcml2ZXIgcmVt
b3ZhbCwKaG93IGFib3V0IHRoaXM6CgpwbV9ydW50aW1lX2dldF9zeW5jKCkKPHJlbW92ZSBhbmQg
cHV0IGJvdGggaGNkJ3M+CnBtX3J1bnRpbWVfZGlzYWJsZSgpCnBtX3J1bnRpbWVfcHV0X25vaWRs
ZSgpCnBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgpCgp0aGFua3MKTGkgSnVuCgo+IC1NYXRoaWFz
IAoKCgo=

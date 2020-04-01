Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0D719A425
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 06:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgDAEHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 00:07:04 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:1287
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726557AbgDAEHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 00:07:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzAJiB5i0GDBSFFdkbcVLcDS1rKrNE2YqEfbBytrLpTPNhxp/gzgbXvOAaCJZ/gyFgcPOhegOsXl9QydGcCFfWqTj+qgXLP/YqDYdDUwUTvnZmfguMkYRy7KW2PFDxf0aSVA7sJwi97QsyefSB7CeRcv26UeFueSTLh6U+oSHlRpeybDix0YtIBZunzTI0L/kha0jRH8rQn7C41XUiPNWtR+qcGTinf2Wvs4+g86k3fy8kw+5cTzRjnq7mTe7rnZOOOcoxuqEAhGCjQMkImMbsP/MCVQg8gMhpFfrjv9j1/2g7XZKWDeke1QJDYA+0WgVon2oBR84p/fhBI5zT1Hig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvr9TbU36NK3TsgNjNaZCfb+FQhEpZKxaRxPHRszHT4=;
 b=ErZr8VfVTV0dK4onUaNdG8XggsFSL6Nk0V++ikZ4MHnqtpoTNqPVvJgQ2kwuhbq7cu26XsqWqcxADroR4QA1kvxbZsYZ++5V+wjH7rf/ixMfg+4LuQFlQ06Tkfd+GkJ3BUL7Gfr2fYDVawdwBLqF7cxPkINahFHd3mCZWqldhx+blVIdl83jKrHCwGg7slJuZBhT855HTKnKqdkwXr7yO+h3KMrgIlOgs8WA0kLRECA3EcyC3I8oXw759gHyp0heDV+WqgYTlAl2fP3Epr06NaHnajG2XPlzPaax1APGWyxLvd6ZH9YRs6dGs12+TNOm4EhFcMfLfR3eF/WuudwGPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvr9TbU36NK3TsgNjNaZCfb+FQhEpZKxaRxPHRszHT4=;
 b=XF+UX6H9SbxCbgVOgun8GwKfqlqpwqaG+XyASU3utcN2ItihaIaVgRafw02ZMkt/SMA8O/Sce2xlJZpx329AnLrrxq4VJUt26xQOVR8O+4Oxp81oArEmVz8mJKOkq3l3zsNwITgNNS1I3jrMuokw0XYeMLWk/Q9/kWmJ/rrsCWU=
Received: from VI1PR04MB5040.eurprd04.prod.outlook.com (20.177.52.24) by
 VI1PR04MB6126.eurprd04.prod.outlook.com (20.179.28.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Wed, 1 Apr 2020 04:06:58 +0000
Received: from VI1PR04MB5040.eurprd04.prod.outlook.com
 ([fe80::154e:421d:dd21:3fc3]) by VI1PR04MB5040.eurprd04.prod.outlook.com
 ([fe80::154e:421d:dd21:3fc3%5]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 04:06:58 +0000
From:   BOUGH CHEN <haibo.chen@nxp.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] driver core: platform: Initialize dma_parms for
 platform devices
Thread-Topic: [PATCH v2 1/2] driver core: platform: Initialize dma_parms for
 platform devices
Thread-Index: AQHWB4ugpHkRdkKAZ0OBnkBClhitmahjpWFw
Date:   Wed, 1 Apr 2020 04:06:58 +0000
Message-ID: <VI1PR04MB50405B4010B4EBE7078FAA8690C90@VI1PR04MB5040.eurprd04.prod.outlook.com>
References: <20200331183844.30488-1-ulf.hansson@linaro.org>
 <20200331183844.30488-2-ulf.hansson@linaro.org>
In-Reply-To: <20200331183844.30488-2-ulf.hansson@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haibo.chen@nxp.com; 
x-originating-ip: [122.194.1.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9481ba9b-f46f-45a1-6b80-08d7d5f21fdd
x-ms-traffictypediagnostic: VI1PR04MB6126:
x-microsoft-antispam-prvs: <VI1PR04MB612660A508B954ACC83230A090C90@VI1PR04MB6126.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5040.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(53546011)(55016002)(33656002)(8936002)(71200400001)(7696005)(26005)(81156014)(8676002)(2906002)(81166006)(9686003)(186003)(6506007)(5660300002)(7416002)(4326008)(316002)(54906003)(86362001)(478600001)(76116006)(110136005)(66946007)(66556008)(64756008)(66446008)(52536014)(66476007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l5GB2wAWdA9fkJJ8tGG9YNZLZGb3LRyJsN2qXR8Hbxi+9XOMweXfGQAI+1oM3Nt2cmrrj2jthucMsf7HfRQGSA61ZMBBGW6dOkcHDRBgzNq259krBHwpQcHsx9dn9z3qH3SW4a44wIlwrDBqSh80dH4gB5a9Wrv9znBBoImzhGujRwoxKSAo4GtwOoQd0n/XvpXd9+hv4lkGg4SlneJ92kdD0zyJ/t8aXvFuZULiNNviCSsLNdrdx2Ytv3rYagOHkBk32+6L8Q8ol8oyRKZSKr601Q6z7bamNV1DtWPE3XGNQUWMWhGg0KemmFfvQs7oV0B8r2pgKqRuzXkzPRxNOzwZCMEVP8gpRBIhIuhITKIdH2/+VsrmrMgnqrh8n00abfi1JrhL1N14K24IqGblye5ahXhVM2hdjftmW5LrG813A3h6bNagvWXk66RqvY47
x-ms-exchange-antispam-messagedata: ldqfigzoay+0yFWGwKD6RQ5lKdRq6/nJAKDSN2UprYzjkMWWiNUqpWXpskZMFNfA8wjWg5ljaFqaG+K+uVLwUytOcpF3IJfyUTRHmdGywgCWaRpSb6l8AhAhmKNTSZ23WFIZWO4tzi6r6fUXhOWeTw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9481ba9b-f46f-45a1-6b80-08d7d5f21fdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 04:06:58.8421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZ7956OvA9toogT7idtdLzl6KWYMKvsfYMgBr7lpLC25t7UDw5DYoYV5U6q+ioPe1d8N9sCn7SjZbQ1r3lqcKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6126
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFVsZiBIYW5zc29uIDx1bGYu
aGFuc3NvbkBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIwxOo01MIxyNUgMjozOQ0KPiBUbzogR3Jl
ZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IFJhZmFlbCBKIC4g
V3lzb2NraQ0KPiA8cmFmYWVsQGtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+IENjOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgQ2hyaXN0b3BoIEhlbGx3
aWcgPGhjaEBsc3QuZGU+Ow0KPiBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az47
IExpbnVzIFdhbGxlaWoNCj4gPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz47IFJvYmluIE11cnBo
eSA8cm9iaW4ubXVycGh5QGFybS5jb20+OyBWaW5vZA0KPiBLb3VsIDx2a291bEBrZXJuZWwub3Jn
PjsgQk9VR0ggQ0hFTiA8aGFpYm8uY2hlbkBueHAuY29tPjsgTHVkb3ZpYw0KPiBCYXJyZSA8bHVk
b3ZpYy5iYXJyZUBzdC5jb20+OyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7
DQo+IGRtYWVuZ2luZUB2Z2VyLmtlcm5lbC5vcmc7IFVsZiBIYW5zc29uIDx1bGYuaGFuc3NvbkBs
aW5hcm8ub3JnPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0gg
djIgMS8yXSBkcml2ZXIgY29yZTogcGxhdGZvcm06IEluaXRpYWxpemUgZG1hX3Bhcm1zIGZvcg0K
PiBwbGF0Zm9ybSBkZXZpY2VzDQo+IA0KPiBJdCdzIGN1cnJlbnRseSB0aGUgcGxhdGZvcm0gZHJp
dmVyJ3MgcmVzcG9uc2liaWxpdHkgdG8gaW5pdGlhbGl6ZSB0aGUgcG9pbnRlciwNCj4gZG1hX3Bh
cm1zLCBmb3IgaXRzIGNvcnJlc3BvbmRpbmcgc3RydWN0IGRldmljZS4gVGhlIGJlbmVmaXQgd2l0
aCB0aGlzDQo+IGFwcHJvYWNoIGFsbG93cyB1cyB0byBhdm9pZCB0aGUgaW5pdGlhbGl6YXRpb24g
YW5kIHRvIG5vdCB3YXN0ZSBtZW1vcnkgZm9yDQo+IHRoZSBzdHJ1Y3QgZGV2aWNlX2RtYV9wYXJh
bWV0ZXJzLCBhcyB0aGlzIGNhbiBiZSBkZWNpZGVkIG9uIGEgY2FzZSBieSBjYXNlDQo+IGJhc2lz
Lg0KPiANCj4gSG93ZXZlciwgaXQgaGFzIHR1cm5lZCBvdXQgdGhhdCB0aGlzIGFwcHJvYWNoIGlz
IG5vdCB2ZXJ5IHByYWN0aWNhbC4gIE5vdA0KPiBvbmx5IGRvZXMgaXQgbGVhZCB0byBvcGVuIGNv
ZGluZywgYnV0IGFsc28gdG8gcmVhbCBlcnJvcnMuIEluIHByaW5jaXBsZSBjYWxsZXJzIG9mDQo+
IGRtYV9zZXRfbWF4X3NlZ19zaXplKCkgZG9lc24ndCBjaGVjayB0aGUgZXJyb3IgY29kZSwgYnV0
IGp1c3QgYXNzdW1lcyBpdA0KPiBzdWNjZWVkcy4NCj4gDQo+IEZvciB0aGVzZSByZWFzb25zLCBs
ZXQncyBkbyB0aGUgaW5pdGlhbGl6YXRpb24gZnJvbSB0aGUgY29tbW9uIHBsYXRmb3JtIGJ1cw0K
PiBhdCB0aGUgZGV2aWNlIHJlZ2lzdHJhdGlvbiBwb2ludC4gVGhpcyBhbHNvIGZvbGxvd3MgdGhl
IHdheSB0aGUgUENJIGRldmljZXMgYXJlDQo+IGJlaW5nIG1hbmFnZWQsIHNlZSBwY2lfZGV2aWNl
X2FkZCgpLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4NCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBVbGYg
SGFuc3NvbiA8dWxmLmhhbnNzb25AbGluYXJvLm9yZz4NCj4gDQoNCkhpIFVsZiwNCg0KSSB0ZXN0
IGJvdGggb24gb3VyIGxvY2FsIDUuNC4yNCBicmFuY2ggYW5kIHRoZSBsYXRlc3QgTGludXgtbmV4
dCwgYm90aCB3b3JrcyBmaW5lLg0KDQpUZXN0ZWQtYnk6IEhhaWJvIENoZW4gPGhhaWJvLmNoZW5A
bnhwLmNvbT4NCg0KQmVzdCBSZWdhcmRzDQpIYWlibyBDaGVuDQoNCj4gLS0tDQo+IA0KPiBDaGFu
Z2VzIGluIHYyOg0KPiAJLSBNb3ZlIGluaXRpYWxpemF0aW9uIHRvIHNldHVwX3BkZXZfZG1hX21h
c2tzKCkuIFRoaXMgbWVhbnMgdGhlDQo+IAlpbml0aWFsaXphdGlvbiBpcyBkb25lIGFsc28gaW4g
dGhlIE9GIHBhdGguDQo+IA0KPiAtLS0NCj4gIGRyaXZlcnMvYmFzZS9wbGF0Zm9ybS5jICAgICAg
ICAgfCAyICsrDQo+ICBpbmNsdWRlL2xpbnV4L3BsYXRmb3JtX2RldmljZS5oIHwgMSArDQo+ICAy
IGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvYmFzZS9wbGF0Zm9ybS5jIGIvZHJpdmVycy9iYXNlL3BsYXRmb3JtLmMgaW5kZXgNCj4gYjVj
ZTdiMDg1Nzk1Li5jODFiNjhkNWQ2NmQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvYmFzZS9wbGF0
Zm9ybS5jDQo+ICsrKyBiL2RyaXZlcnMvYmFzZS9wbGF0Zm9ybS5jDQo+IEBAIC0zNjEsNiArMzYx
LDggQEAgc3RydWN0IHBsYXRmb3JtX29iamVjdCB7DQo+ICAgKi8NCj4gIHN0YXRpYyB2b2lkIHNl
dHVwX3BkZXZfZG1hX21hc2tzKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpICB7DQo+ICsJ
cGRldi0+ZGV2LmRtYV9wYXJtcyA9ICZwZGV2LT5kbWFfcGFybXM7DQo+ICsNCj4gIAlpZiAoIXBk
ZXYtPmRldi5jb2hlcmVudF9kbWFfbWFzaykNCj4gIAkJcGRldi0+ZGV2LmNvaGVyZW50X2RtYV9t
YXNrID0gRE1BX0JJVF9NQVNLKDMyKTsNCj4gIAlpZiAoIXBkZXYtPmRldi5kbWFfbWFzaykgew0K
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wbGF0Zm9ybV9kZXZpY2UuaA0KPiBiL2luY2x1
ZGUvbGludXgvcGxhdGZvcm1fZGV2aWNlLmggaW5kZXggMDQxYmZhNDEyYWEwLi44MTkwMGIzY2Jl
MzcNCj4gMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvcGxhdGZvcm1fZGV2aWNlLmgNCj4g
KysrIGIvaW5jbHVkZS9saW51eC9wbGF0Zm9ybV9kZXZpY2UuaA0KPiBAQCAtMjUsNiArMjUsNyBA
QCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlIHsNCj4gIAlib29sCQlpZF9hdXRvOw0KPiAgCXN0cnVj
dCBkZXZpY2UJZGV2Ow0KPiAgCXU2NAkJcGxhdGZvcm1fZG1hX21hc2s7DQo+ICsJc3RydWN0IGRl
dmljZV9kbWFfcGFyYW1ldGVycyBkbWFfcGFybXM7DQo+ICAJdTMyCQludW1fcmVzb3VyY2VzOw0K
PiAgCXN0cnVjdCByZXNvdXJjZQkqcmVzb3VyY2U7DQo+IA0KPiAtLQ0KPiAyLjIwLjENCg0K

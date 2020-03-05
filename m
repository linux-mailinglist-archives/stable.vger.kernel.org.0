Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D10617AEC6
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 20:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgCETLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 14:11:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:30249 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCETLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 14:11:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 11:11:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="240915374"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga003.jf.intel.com with ESMTP; 05 Mar 2020 11:11:44 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Mar 2020 11:11:44 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Mar 2020 11:11:43 -0800
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Mar 2020 11:11:43 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Mar 2020 11:11:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/mnn47uP/7BsdRU2t0P/+cmdh+jtJXdOqYYItE83Aaj1kRvAmSIts4DS8grwtPvDzRPEU+TV9rA1ZVs6Oir4vl0cbUdnsGjAiYQYRkhRKBAoKUW0CWr2PO3i+rlW0vP+9NWGPKNY+isQTYIJRDXGIzAh94SxWfOi/2KujY3+W6hYB1aBLtUZHelEc1g2FJd+gPNPO1kKoUoNjWRKWuyDdq6xAbFoVf+SZRmngmR4yD68aeQPpb69wK8m9UKlEVJpLI1X8FSxOXbIJl4WceZqVxhhA4pReeCYC5g69L/Mor2ET3z/5USQhlsA+tnH/+yLQJuqb5C8tkhOwPhM/BmOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jCaMeLuzwenPqFg3xOOnHJjfJgCcwj8vi1awpca/OM=;
 b=lccrhoLGzs/mWt+8Ql1mCj5U9jcvFKZnu18F7FDrjm1WyoppYN6kiGuNRmYgoqTNkit6dw7G4PXW4YZA/aYTanGC18MNlxUoO6yRCZ/zBgryYu6pmKYgEghHyYf+f4LzP7nzPSHTASZhKraOPxrk66/DB0DuNbnAOop9WM6aGLSL8VklAIwlq3tUBEbSy9SzyVNJ+hsth9SjNwIAd27hK1egEPvwVZz+YLNljk8EZ1JCV1z/o08PYGfSUN3EakXnjDsZpx1m0yoswIYe2hiHgqXaZ+RfcM3391N+rCl7bK7Sl5dW9BQCL1Wsiv4G+AsSLpSXKr00o+wjd9pRg5FOOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jCaMeLuzwenPqFg3xOOnHJjfJgCcwj8vi1awpca/OM=;
 b=hC658hXXiyg3abgrD9bhn/SB140pAHHmWjsYt/dqRNqQMxTAaDnh2P84DTO1f32j7ulEymKjlPItp8C6rqaVBoXzxnnnhXjmflj4HIViXZ7ZRDDCNM/cjU300yQSNIYTvlqcL2LsPolKYrGlX8Wq02Zc84c6ttZrIUwG62bEijg=
Received: from BN6PR11MB1522.namprd11.prod.outlook.com (2603:10b6:405:b::22)
 by BN6PR11MB4100.namprd11.prod.outlook.com (2603:10b6:405:7a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Thu, 5 Mar
 2020 19:11:37 +0000
Received: from BN6PR11MB1522.namprd11.prod.outlook.com
 ([fe80::fd05:9fbc:c9fd:9fbf]) by BN6PR11MB1522.namprd11.prod.outlook.com
 ([fe80::fd05:9fbc:c9fd:9fbf%12]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 19:11:37 +0000
From:   "Langer, Thomas" <thomas.langer@intel.com>
To:     Mathias Kresin <dev@kresin.me>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC:     "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] pinctrl: falcon: fix syntax error
Thread-Topic: [PATCH] pinctrl: falcon: fix syntax error
Thread-Index: AQHV8xsubD2jb9S29k+XCvTTsOJyZ6g6XT2g
Date:   Thu, 5 Mar 2020 19:11:37 +0000
Message-ID: <BN6PR11MB15223D35199E94BF13B0141CFEE20@BN6PR11MB1522.namprd11.prod.outlook.com>
References: <20200305182245.9636-1-dev@kresin.me>
In-Reply-To: <20200305182245.9636-1-dev@kresin.me>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thomas.langer@intel.com; 
x-originating-ip: [134.191.221.109]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15d4cc17-02ba-43f1-f16f-08d7c1390748
x-ms-traffictypediagnostic: BN6PR11MB4100:
x-microsoft-antispam-prvs: <BN6PR11MB41009B84C9A3E14F1CE01380FEE20@BN6PR11MB4100.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(39860400002)(346002)(376002)(189003)(199004)(55016002)(81166006)(9686003)(66946007)(8936002)(33656002)(66446008)(66476007)(5660300002)(66556008)(64756008)(66574012)(86362001)(4326008)(8676002)(81156014)(76116006)(7696005)(110136005)(71200400001)(53546011)(6506007)(54906003)(2906002)(52536014)(186003)(26005)(478600001)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR11MB4100;H:BN6PR11MB1522.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RL/jKNJHLJLBwkShz7guaQArKi+bOUYg4yvCP4cPzduGKrF+wnSLt5flA+hlzlmfSB1tl6Q1H1G9SnI4IAfBuW/r82Ui77qFzW+Plx7n5DXSrBA4Rrc2z7/qRlv549nd5ckPab0rYNqcw+8KWLuLPdX0kmj0GbHPqtYi0O3ecL0T5nLUy3ylPbEqzNCud0nEqyYHINepmlQ1+rWUIkorWkBnPpcaLUupQSWpCujL1J7uKA8Vq/A7Tb+/wNevQHTGfWFpkmnY7HHIHtYAVF+bhOU+B3flaWNDJep1RRVjmdvoT6EGuBR3bK0NvfX6OIdXJlQObv/sBUqCbnhEmJv39/E1scGdvluZgheyrADllFZEOWzZS5gxOc2n05HefxCGoP7bFwUOh/l5QzI1oNAF0UBDJP2SB2YQkq60PXI28j0E+P0WPpPZbxuxKa4wWB9W
x-ms-exchange-antispam-messagedata: KdcfNUYdCO3y7HbIzCE5FZtQVuDb7XKJGISwhdqi/7XmZbHZr8YDDruMSLg7TYb4iO6C6ge+NlH3xIz+UTzFN8C0BKXf/6m3SAoUAMfOmxLhF7AHBRYoOtehO+o0xQwduKpOGzU/KHrVZTzbuTxV/g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d4cc17-02ba-43f1-f16f-08d7c1390748
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 19:11:37.4672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h2I3x1pO22Df/Zhxs6EBurqWexajQEQ+ayJgkjW6tqH+qyQRF5ojx2oJEpNTcskelxq1x9DokXHpSMd+3iby6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4100
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtZ3Bpby1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWdwaW8tDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZz4g
T24gQmVoYWxmIE9mIE1hdGhpYXMgS3Jlc2luDQo+IFNlbnQ6IERvbm5lcnN0YWcsIDUuIE3DpHJ6
IDIwMjAgMTk6MjMNCj4gVG86IGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZw0KPiBDYzogbGludXgt
Z3Bpb0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BBVENIXSBwaW5jdHJsOiBmYWxjb246
IGZpeCBzeW50YXggZXJyb3INCj4gDQo+IEFkZCB0aGUgbWlzc2luZyBzZW1pY29sb24gYWZ0ZXIg
b2Zfbm9kZV9wdXQgdG8gZ2V0IHRoZSBmaWxlIGNvbXBpbGVkLg0KPiANCj4gRml4ZXM6IGYxN2Qy
ZjU0ZDM2ZCAoInBpbmN0cmw6IGZhbGNvbjogQWRkIG9mX25vZGVfcHV0KCkgYmVmb3JlDQo+IHJl
dHVybiIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgdjUuNCsNCj4gU2lnbmVkLW9m
Zi1ieTogTWF0aGlhcyBLcmVzaW4gPGRldkBrcmVzaW4ubWU+DQoNCkFja2VkLWJ5OiBUaG9tYXMg
TGFuZ2VyIDx0aG9tYXMubGFuZ2VyQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvcGlu
Y3RybC9waW5jdHJsLWZhbGNvbi5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9waW5jdHJs
L3BpbmN0cmwtZmFsY29uLmMNCj4gYi9kcml2ZXJzL3BpbmN0cmwvcGluY3RybC1mYWxjb24uYw0K
PiBpbmRleCBhNDU0ZjU3YzI2NGUuLjYyYzAyYjk2OTMyNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9waW5jdHJsL3BpbmN0cmwtZmFsY29uLmMNCj4gKysrIGIvZHJpdmVycy9waW5jdHJsL3BpbmN0
cmwtZmFsY29uLmMNCj4gQEAgLTQ1MSw3ICs0NTEsNyBAQCBzdGF0aWMgaW50IHBpbmN0cmxfZmFs
Y29uX3Byb2JlKHN0cnVjdA0KPiBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJCWZhbGNvbl9p
bmZvLmNsa1sqYmFua10gPSBjbGtfZ2V0KCZwcGRldi0+ZGV2LCBOVUxMKTsNCj4gIAkJaWYgKElT
X0VSUihmYWxjb25faW5mby5jbGtbKmJhbmtdKSkgew0KPiAgCQkJZGV2X2VycigmcHBkZXYtPmRl
diwgImZhaWxlZCB0byBnZXQgY2xvY2tcbiIpOw0KPiAtCQkJb2Zfbm9kZV9wdXQobnApDQo+ICsJ
CQlvZl9ub2RlX3B1dChucCk7DQo+ICAJCQlyZXR1cm4gUFRSX0VSUihmYWxjb25faW5mby5jbGtb
KmJhbmtdKTsNCj4gIAkJfQ0KPiAgCQlmYWxjb25faW5mby5tZW1iYXNlWypiYW5rXSA9IGRldm1f
aW9yZW1hcF9yZXNvdXJjZSgmcGRldi0NCj4gPmRldiwNCj4gLS0NCj4gMi4xNy4xDQoNCg==

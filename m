Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A12C329B3A
	for <lists+stable@lfdr.de>; Tue,  2 Mar 2021 11:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbhCBBSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 20:18:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:20864 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344531AbhCBAKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 19:10:21 -0500
IronPort-SDR: OPmlw/jEjQLtyr5QfxxrTya9Iw5Pw1eHnWJTcD7n9TR96VK3e3GwA3ivTVX228RqCUDpLk0bXT
 q1Wq03n6JWbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="248044725"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="248044725"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:09:24 -0800
IronPort-SDR: cBKTA4wYMTeKBztlkgC5XzYZXA5W9D0hdPF95GqIQtsciwR3xr+e3JB03jsTfexgGwSQLMzNLz
 +jTlykvElqyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="506108829"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 01 Mar 2021 16:09:24 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Mar 2021 16:09:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 1 Mar 2021 16:09:23 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 1 Mar 2021 16:09:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXSisJPkP9hbitLyjdrqfwuh5UNQZ6RmS4WtFLdNmC/K+EPmLWf1ImfGAwI9LxMngOpPEI/Jzvs/92ncQ/kmc/i/8RKxgz5bI4OM8bsVOvpGpKUGlXe/cuF7zWA73FkRpFXxPF54CM8hIemRF6PH0T4Ztl69Yv2LdETWXkWf7gU8mWPGUC7NqIDKxBGqv9zVU0+5tRdEMbEyOowqxibSfyHH9bF6MLMVRnPDQaj60Qv4PS1TvX0sxOsvZxpgS3P5Jmk9POqajrQYfgPFjVoT8XbuugXSzHjUtgPLAQPbLU09C3YhV7IMYIvUay+2OrqLbFrclyLPToXWSxumoi4WrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35w3yHQqdU2jVtT3paHwyXxLWDNdQ2Ho1O+Y0cPht4U=;
 b=BiHvamMLsnaxi3s989Iic1BS5Csw+ua9SFrzsIXqa/NzQzOMzEd6igMVaO4mxvL33BXNKfSku1uwrmi/sbKK1u68KnJWZNHjFxYEkQ1uxPBqbRVLTWahlVyrRDmyAZWrDMB00+Oa+Up99yxQ6RO9/dQehZ7spPBCoTyYJ1RlRfEQkwe+6A2NAKmsFYaruavCjQt45amRNbiWcjd9bhirdaPj6f9YUuyuU/0qard0NjPUyiPwOa7XrccoLBuj1jhzaajBUr04CFmVgoPXoZVZL6i/COnbDdz0RSymGScGUXI0IkhRWSvNrJBHrW5OJuNhV4DDjtNs7whjNMp1ptMHjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35w3yHQqdU2jVtT3paHwyXxLWDNdQ2Ho1O+Y0cPht4U=;
 b=tkLtjllhwrN4yO6nnlE/gfy7xP+P8AEcEhUeybWHa48eHt2EnsYaVEvFXX4iIbgGteBb242eZldk/WFlfwL/UGdI/KtQbsFO1vqpRwNWn88sGxU1soJM99raD1t/RS024H2JTr6zxDjB4iiZwADHRF1e213JDSCGS92eLk9LNrM=
Received: from BY5PR11MB3878.namprd11.prod.outlook.com (2603:10b6:a03:182::31)
 by BYAPR11MB3831.namprd11.prod.outlook.com (2603:10b6:a03:b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 2 Mar
 2021 00:09:21 +0000
Received: from BY5PR11MB3878.namprd11.prod.outlook.com
 ([fe80::4d1d:3c30:c0e7:e4d1]) by BY5PR11MB3878.namprd11.prod.outlook.com
 ([fe80::4d1d:3c30:c0e7:e4d1%3]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 00:09:21 +0000
From:   "Yoo, Jae Hyun" <jae.hyun.yoo@intel.com>
To:     Joel Stanley <joel@jms.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Wang <wangzhiqiang.bj@bytedance.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vernon Mauery <vernon.mauery@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.19 055/247] soc: aspeed: snoop: Add clock control logic
Thread-Topic: [PATCH 4.19 055/247] soc: aspeed: snoop: Add clock control logic
Thread-Index: AQHXDrlVRj2f2jXSCEKgfctZ188g/apvu1iAgAAW1NA=
Date:   Tue, 2 Mar 2021 00:09:21 +0000
Message-ID: <BY5PR11MB38788139CE6E4BA6A667CB84D2999@BY5PR11MB3878.namprd11.prod.outlook.com>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161034.369309830@linuxfoundation.org>
 <CACPK8XeoKfNCR9diNZoLCM04=G9BRVxY_VZhXr+XQcpq2+rCdQ@mail.gmail.com>
In-Reply-To: <CACPK8XeoKfNCR9diNZoLCM04=G9BRVxY_VZhXr+XQcpq2+rCdQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: request-justification,no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: jms.id.au; dkim=none (message not signed)
 header.d=none;jms.id.au; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.67.130.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61c3e8bb-6f0a-4711-0faf-08d8dd0f6e56
x-ms-traffictypediagnostic: BYAPR11MB3831:
x-ms-exchange-minimumurldomainage: kernel.org#8761
x-microsoft-antispam-prvs: <BYAPR11MB3831254F798325A597F8C249D2999@BYAPR11MB3831.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nATdajhk8BME8jLrKEB9bke1W2IVJ3OrsCY3BQnIUQmZ3GAWjDWjvwA3GoWof2M6Kf2Se1a2dS2blGbrUJrp5PoBtDgIW5wcShde/asozgsfZicpSyP/4M0eppN+9RcdKaD04NO9zY1pUO3OHNmG7OfLC3ci4lJdT6JrUecejTPPaPi+iDMAGXCQpsBB4Ok7DvL3X+0P95ljmF2Wgp/EFhxV335coXsVyEy7wGoZcd9UT946sk1aRO6h/jmU3OgaHR98GVGzpac9bz1WNps6MmwUntILUedZgEXE5n5rcIgKo8DdXNhu/KAjDFDbgkkkPy98fgqPHTIy1IedsGmUMNnGxGjWkyd/+JGSTcVC9whvb6U67Gh9vpjWW8kFTMoYawIAOKb57rrHieBSeO3FwV3cv2gVx3pShx8M5rB7J3Scy3AohJoO7NDitT4z86Pn4mT9oeLP9mmo4QKfawPoe4n6ZdhZZ8965tXSoPw/kdrRj1e1LdO440KbLhaUswecPCDmPvo4cJvVgWW33rUxF6+aeKDSI+bZjU7DXgJKFbGUmr7p/foLwxiF5kx8TYTkaXbpTdVHUItCf+xKIiWoVqM+eMPVX2M7tOqK4o4xGcM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3878.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39860400002)(346002)(366004)(6506007)(4326008)(33656002)(7696005)(186003)(53546011)(110136005)(54906003)(8676002)(966005)(8936002)(478600001)(316002)(66476007)(52536014)(64756008)(66446008)(5660300002)(66946007)(76116006)(55016002)(9686003)(2906002)(71200400001)(83380400001)(66556008)(26005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QW4rNnNYM1hNU2RxM2RlVkJWaWF6NHJuVGMxcVZYZmMva080Smx6T2VLWGIx?=
 =?utf-8?B?TEkxc0wzS1hzUThNWllwRnM5S0pJOUYrZGZhdGU0VXZ1clFjRC9SeENXVE96?=
 =?utf-8?B?MGZQNFdPUE5qcnZXR0ZvZ24vK1E5ZzVkajA1QmIvUTVDNW5GUVp0QitKdFU4?=
 =?utf-8?B?VnRENnNpOTZEa0RVZHY4Z0JLVy9ORlpwQ3AxSmhWWm5FWEdwcmJNcmdudDZm?=
 =?utf-8?B?a1ZXM2E5OVAzeUpBcUJQdGwwVnZuL1JsK3hIa2ZFenovWjNjaFFqandacFUx?=
 =?utf-8?B?VUtEM3JBdWVucmk5L3hZYU5aRksvU1NHLzVYK1Bya0YwRjNjMDJRQjZZOTJq?=
 =?utf-8?B?bjl0cTM3Y0VoQU1nNUlNSjRRRHkyY0JKTHYyY0FZeDB5Y28rWTZhZ1BpaHlD?=
 =?utf-8?B?d0pmMXpjZklHZG81b0l5MUF5V0swREVHb0diMU92UHBicndIUTE5ejVHMHZo?=
 =?utf-8?B?U2c2RVlZKzZDU1FGWG80VGQxejVGNjkyUWM5NzFJZ2JPYjMvdDFkM1NVa01Y?=
 =?utf-8?B?YXpBTWExVUNFNmo0RC9GTXpFUHNsU1Ric3BXL1Zjb2p6QWFQWWZFeXdsbTFn?=
 =?utf-8?B?MGEvRE0yTmo3aWVDNzVkQU9pWmhiWjIyQkJUV2dobzJZY09tNnpuZHNZK0sr?=
 =?utf-8?B?Z0VyakJIV0RmYlNxWWp6cm1mYnNBTnhNWXhxM3lCK2hqcGVRdlNMM1lNYmpq?=
 =?utf-8?B?elptblhFTDF0QU1Uc0RNWHl4MWRraEw4VWFOTC9WY1Z3U1B3Q2k0T1ZDM0pJ?=
 =?utf-8?B?ZXcwMTlzczlHbHl5M1RjODMycDA3Y2lWODhwd2lwL2I5d0JsTlpNY3BBU2Y4?=
 =?utf-8?B?REh5Y2xCZVh2c3ZIWGpDN3h2UEl0cGVhbzQySzhIcEJKdkl5Z1JhZGNKNldk?=
 =?utf-8?B?TDE3SFNCbFUxRkF6UnNVS1JJYS9CMGR3K2YzK0pDdVZrSW1Ba1ZtZXBiWDBE?=
 =?utf-8?B?MktGUkpmcmpOMEIxSklvQXVHTnNqd0FqMERrRFZKZm02eTIrWVU4a0kya2ds?=
 =?utf-8?B?MnZFQm1TcmVoZGtPUU9pSXVvRFl2ejVKTFpxL3dsWXBVclovWURtdVdsaTlI?=
 =?utf-8?B?dmo0ek8vSVlnc1VhT1c2TVN4b1FINW9tUW01dGh5a2RGNy9SS3lteWtFY25H?=
 =?utf-8?B?Z2ZXQUZFc2dXc3Z5MlRlZnNlMlROQnVBQ1RzTkZCR2UwVkxKcWNVQzVwTFpk?=
 =?utf-8?B?THFWSGhuUjdIa0wwdWZYV3AybzE4a21XS3hGOWNZWU9oU2FLYTl1L1NxYWxS?=
 =?utf-8?B?NTNrNytDLzlUZXk3V01URThscVB3aWJ0TWlrbjNkWkRPcStXREhEbnBqVFFC?=
 =?utf-8?B?eXVJUzREMUhBWjZiSVFjSXY2cHRMSC9uUWJzTG0zc3ZDa0FscXc2c1BQajkr?=
 =?utf-8?B?SW8xOTdlVldXYldJWjhKa2o2RGNBbzlmMSsvZHlXdDhRcW9YMkVWWE5rTnJ0?=
 =?utf-8?B?Rlo4QkVCbVR3QlZ2L0srM3FDcDRsWVZ6RzNWUXppdGxnTzl5MjdYTUxHZmZI?=
 =?utf-8?B?R2lwWWRYODBiSVpOY0dSN1JyejV4SEU4bkZTYTZSeE52SHpDTzMwYkoyQXlh?=
 =?utf-8?B?eWdMYUZNYklwMWw0YzB6cUhSdXBwZXVNSm5VdkhHZEZ6R3p3OHpxeWd3N1By?=
 =?utf-8?B?RXgveDFiS2NYL25tLzhuVHV4dVlUVmNJNTIxa1YwaXJBenV0L0p0azQ0TDZ4?=
 =?utf-8?B?REd0cHpBV0c3M3M4RWRMUUROam5rT1cxenVjUnZtVUhTQklISGEvUUNkY2U5?=
 =?utf-8?Q?gQQCwBvNcAapVN3HBzn/PXPWHRwJCkbUmJAsRQ0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3878.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c3e8bb-6f0a-4711-0faf-08d8dd0f6e56
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 00:09:21.7307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6RA4k9Vz/2dFb0hLPcIKqSuTm2FQwTRyFCAf6lQpp8M2Ukg62zDCqVwhonGYd/Hkqc0sizsDUApTCr/RKalPCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3831
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2VsIFN0YW5sZXkgPGpvZWxA
am1zLmlkLmF1Pg0KPiBTZW50OiBNb25kYXksIE1hcmNoIDEsIDIwMjEgMjo0NCBQTQ0KPiBUbzog
R3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IEpvaG4gV2Fu
Zw0KPiA8d2FuZ3poaXFpYW5nLmJqQGJ5dGVkYW5jZS5jb20+OyBZb28sIEphZSBIeXVuDQo+IDxq
YWUuaHl1bi55b29AaW50ZWwuY29tPg0KPiBDYzogTGludXggS2VybmVsIE1haWxpbmcgTGlzdCA8
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7
IFZlcm5vbiBNYXVlcnkgPHZlcm5vbi5tYXVlcnlAbGludXguaW50ZWwuY29tPjsNCj4gU2FzaGEg
TGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDQuMTkgMDU1
LzI0N10gc29jOiBhc3BlZWQ6IHNub29wOiBBZGQgY2xvY2sgY29udHJvbCBsb2dpYw0KPiANCj4g
T24gTW9uLCAxIE1hciAyMDIxIGF0IDE2OjM3LCBHcmVnIEtyb2FoLUhhcnRtYW4NCj4gPGdyZWdr
aEBsaW51eGZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IEphZSBIeXVuIFlv
byA8amFlLmh5dW4ueW9vQGludGVsLmNvbT4NCj4gPg0KPiA+IFsgVXBzdHJlYW0gY29tbWl0IDNm
OTRjZjE1NTgzYmU1NTRkZjdhYWE2NTFiOGZmOGUxYjY4ZmJlNTEgXQ0KPiA+DQo+ID4gSWYgTFBD
IFNOT09QIGRyaXZlciBpcyByZWdpc3RlcmVkIGFoZWFkIG9mIGxwYy1jdHJsIG1vZHVsZSwgTFBD
IFNOT09QDQo+ID4gYmxvY2sgd2lsbCBiZSBlbmFibGVkIHdpdGhvdXQgaGVhcnQgYmVhdGluZyBv
ZiBMQ0xLIHVudGlsIGxwYy1jdHJsDQo+ID4gZW5hYmxlcyB0aGUgTENMSy4gVGhpcyBpc3N1ZSBj
YXVzZXMgaW1wcm9wZXIgaGFuZGxpbmcgb24gaG9zdA0KPiA+IGludGVycnVwdHMgd2hlbiB0aGUg
aG9zdCBzZW5kcyBpbnRlcnJ1cHQgaW4gdGhhdCB0aW1lIGZyYW1lLg0KPiA+IFRoZW4ga2VybmVs
IGV2ZW50dWFsbHkgZm9yY2libHkgZGlzYWJsZXMgdGhlIGludGVycnVwdCB3aXRoIGR1bXBpbmcN
Cj4gPiBzdGFjayBhbmQgcHJpbnRpbmcgYSAnbm9ib2R5IGNhcmVkIHRoaXMgaXJxJyBtZXNzYWdl
IG91dC4NCj4gPg0KPiA+IFRvIHByZXZlbnQgdGhpcyBpc3N1ZSwgYWxsIExQQyBzdWItbm9kZXMg
c2hvdWxkIGVuYWJsZSBMQ0xLDQo+ID4gaW5kaXZpZHVhbGx5IHNvIHRoaXMgcGF0Y2ggYWRkcyBj
bG9jayBjb250cm9sIGxvZ2ljIGludG8gdGhlIExQQyBTTk9PUA0KPiA+IGRyaXZlci4NCj4gDQo+
IEphZSwgSm9objsgd2l0aCB0aGlzIGJhY2twb3J0ZWQgZG8gd2UgbmVlZCB0byBhbHNvIHByb3Zp
ZGUgYSBjb3JyZXNwb25kaW5nDQo+IGRldmljZSB0cmVlIGNoYW5nZSBmb3IgdGhlIHN0YWJsZSB0
cmVlLCBvdGhlcndpc2UgdGhpcyBkcml2ZXIgd2lsbCBubyBsb25nZXINCj4gcHJvYmU/DQoNClJp
Z2h0LiBUaGUgc2Vjb25kIHBhdGNoDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1hcm0t
a2VybmVsLzIwMjAxMjA4MDkxNzQ4LjE5MjAtMi13YW5nemhpcWlhbmcuYmpAYnl0ZWRhbmNlLmNv
bS8NCkpvaG4gc3VibWl0dGVkIHNob3VsZCBiZSBhcHBsaWVkIHRvIHN0YWJsZSB0cmVlIHRvbyB0
byBtYWtlIHRoaXMgbW9kdWxlIGJlIHByb2JlZA0KY29ycmVjdGx5Lg0KDQo+ID4NCj4gPiBGaXhl
czogMzc3MmU1ZGE0NDU0ICgiZHJpdmVycy9taXNjOiBBc3BlZWQgTFBDIHNub29wIG91dHB1dCB1
c2luZyBtaXNjDQo+ID4gY2hhcmRldiIpDQo+ID4gU2lnbmVkLW9mZi1ieTogSmFlIEh5dW4gWW9v
IDxqYWUuaHl1bi55b29AaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZlcm5vbiBNYXVl
cnkgPHZlcm5vbi5tYXVlcnlAbGludXguaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpv
aG4gV2FuZyA8d2FuZ3poaXFpYW5nLmJqQGJ5dGVkYW5jZS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6
IEpvZWwgU3RhbmxleSA8am9lbEBqbXMuaWQuYXU+DQo+ID4gTGluazoNCj4gPiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9yLzIwMjAxMjA4MDkxNzQ4LjE5MjAtMS13YW5nemhpcWlhbmcuYmpAYnl0
ZWRhDQo+ID4gbmNlLmNvbQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvZWwgU3RhbmxleSA8am9lbEBq
bXMuaWQuYXU+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwu
b3JnPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL21pc2MvYXNwZWVkLWxwYy1zbm9vcC5jIHwgMzAg
KysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiAtLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwg
MjcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL21pc2MvYXNwZWVkLWxwYy1zbm9vcC5jDQo+ID4gYi9kcml2ZXJzL21pc2MvYXNwZWVk
LWxwYy1zbm9vcC5jIGluZGV4IGMxMGJlMjFhMTY2M2QuLmI0YTc3NmJmNDRiYzUNCj4gPiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL21pc2MvYXNwZWVkLWxwYy1zbm9vcC5jDQo+ID4gKysrIGIv
ZHJpdmVycy9taXNjL2FzcGVlZC1scGMtc25vb3AuYw0KPiA+IEBAIC0xNSw2ICsxNSw3IEBADQo+
ID4gICAqLw0KPiA+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4NCj4gPiArI2luY2x1
ZGUgPGxpbnV4L2Nsay5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+DQo+ID4g
ICNpbmNsdWRlIDxsaW51eC9mcy5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgva2ZpZm8uaD4NCj4g
PiBAQCAtNzEsNiArNzIsNyBAQCBzdHJ1Y3QgYXNwZWVkX2xwY19zbm9vcF9jaGFubmVsIHsgIHN0
cnVjdA0KPiA+IGFzcGVlZF9scGNfc25vb3Agew0KPiA+ICAgICAgICAgc3RydWN0IHJlZ21hcCAg
ICAgICAgICAgKnJlZ21hcDsNCj4gPiAgICAgICAgIGludCAgICAgICAgICAgICAgICAgICAgIGly
cTsNCj4gPiArICAgICAgIHN0cnVjdCBjbGsgICAgICAgICAgICAgICpjbGs7DQo+ID4gICAgICAg
ICBzdHJ1Y3QgYXNwZWVkX2xwY19zbm9vcF9jaGFubmVsIGNoYW5bTlVNX1NOT09QX0NIQU5ORUxT
XTsgIH07DQo+ID4NCj4gPiBAQCAtMjg2LDIyICsyODgsNDIgQEAgc3RhdGljIGludCBhc3BlZWRf
bHBjX3Nub29wX3Byb2JlKHN0cnVjdA0KPiBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4gICAg
ICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gKyAg
ICAgICBscGNfc25vb3AtPmNsayA9IGRldm1fY2xrX2dldChkZXYsIE5VTEwpOw0KPiA+ICsgICAg
ICAgaWYgKElTX0VSUihscGNfc25vb3AtPmNsaykpIHsNCj4gPiArICAgICAgICAgICAgICAgcmMg
PSBQVFJfRVJSKGxwY19zbm9vcC0+Y2xrKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHJjICE9
IC1FUFJPQkVfREVGRVIpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2VycihkZXYs
ICJjb3VsZG4ndCBnZXQgY2xvY2tcbiIpOw0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gcmM7
DQo+ID4gKyAgICAgICB9DQo+ID4gKyAgICAgICByYyA9IGNsa19wcmVwYXJlX2VuYWJsZShscGNf
c25vb3AtPmNsayk7DQo+ID4gKyAgICAgICBpZiAocmMpIHsNCj4gPiArICAgICAgICAgICAgICAg
ZGV2X2VycihkZXYsICJjb3VsZG4ndCBlbmFibGUgY2xvY2tcbiIpOw0KPiA+ICsgICAgICAgICAg
ICAgICByZXR1cm4gcmM7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICAgICAgICAgcmMgPSBh
c3BlZWRfbHBjX3Nub29wX2NvbmZpZ19pcnEobHBjX3Nub29wLCBwZGV2KTsNCj4gPiAgICAgICAg
IGlmIChyYykNCj4gPiAtICAgICAgICAgICAgICAgcmV0dXJuIHJjOw0KPiA+ICsgICAgICAgICAg
ICAgICBnb3RvIGVycjsNCj4gPg0KPiA+ICAgICAgICAgcmMgPSBhc3BlZWRfbHBjX2VuYWJsZV9z
bm9vcChscGNfc25vb3AsIGRldiwgMCwgcG9ydCk7DQo+ID4gICAgICAgICBpZiAocmMpDQo+ID4g
LSAgICAgICAgICAgICAgIHJldHVybiByYzsNCj4gPiArICAgICAgICAgICAgICAgZ290byBlcnI7
DQo+ID4NCj4gPiAgICAgICAgIC8qIENvbmZpZ3VyYXRpb24gb2YgMm5kIHNub29wIGNoYW5uZWwg
cG9ydCBpcyBvcHRpb25hbCAqLw0KPiA+ICAgICAgICAgaWYgKG9mX3Byb3BlcnR5X3JlYWRfdTMy
X2luZGV4KGRldi0+b2Zfbm9kZSwgInNub29wLXBvcnRzIiwNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAxLCAmcG9ydCkgPT0gMCkgew0KPiA+ICAgICAgICAgICAg
ICAgICByYyA9IGFzcGVlZF9scGNfZW5hYmxlX3Nub29wKGxwY19zbm9vcCwgZGV2LCAxLCBwb3J0
KTsNCj4gPiAtICAgICAgICAgICAgICAgaWYgKHJjKQ0KPiA+ICsgICAgICAgICAgICAgICBpZiAo
cmMpIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBhc3BlZWRfbHBjX2Rpc2FibGVfc25v
b3AobHBjX3Nub29wLCAwKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVycjsN
Cj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gKyAgICAgICBy
ZXR1cm4gMDsNCj4gPiArDQo+ID4gK2VycjoNCj4gPiArICAgICAgIGNsa19kaXNhYmxlX3VucHJl
cGFyZShscGNfc25vb3AtPmNsayk7DQo+ID4gKw0KPiA+ICAgICAgICAgcmV0dXJuIHJjOw0KPiA+
ICB9DQo+ID4NCj4gPiBAQCAtMzEzLDYgKzMzNSw4IEBAIHN0YXRpYyBpbnQgYXNwZWVkX2xwY19z
bm9vcF9yZW1vdmUoc3RydWN0DQo+IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPiAgICAgICAg
IGFzcGVlZF9scGNfZGlzYWJsZV9zbm9vcChscGNfc25vb3AsIDApOw0KPiA+ICAgICAgICAgYXNw
ZWVkX2xwY19kaXNhYmxlX3Nub29wKGxwY19zbm9vcCwgMSk7DQo+ID4NCj4gPiArICAgICAgIGNs
a19kaXNhYmxlX3VucHJlcGFyZShscGNfc25vb3AtPmNsayk7DQo+ID4gKw0KPiA+ICAgICAgICAg
cmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0KPiA+IC0tDQo+ID4gMi4yNy4wDQo+ID4NCj4gPg0KPiA+
DQo=

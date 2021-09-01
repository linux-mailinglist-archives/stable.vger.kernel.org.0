Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B10A3FE445
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhIAUus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:50:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:15646 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhIAUus (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 16:50:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="241134414"
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="241134414"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 13:49:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="542081432"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 01 Sep 2021 13:49:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 1 Sep 2021 13:49:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 1 Sep 2021 13:49:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 1 Sep 2021 13:49:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doOFBBg7kzvimMGOn6imLcoyW2PuSTuvhpR97hJGNQFhlQSoxcMdmpr7+uZpcLdyNXwp4wbZfFqs4NEXZ9wTJe6/ckOijqbzVOVlbrhYtPB40xtycH7qa/3vTC51fh7rr2SmzJCYIjZkJtp+Y58TFIYeW09lrWfXc4Yo2u+tNoCiVxd+hA85L827tdsSyD0GbPtkY7RQptlZdT4q23wskWEt4GWZ8UcbBJrVneOfHHrfs55Q76H8/h5AeEcq5hrnfOh9CWJkyMl6N+K5FkLMPl90jQfH4V7KLDjHNnHCRr9wNsXrCyZ7x7GdK6yHpQAhxpSHDh7ykMKvZbHSbPTEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VlzrHMNmpyjCB/HbGELlLnW72UWN8YlQoXXYJsVJDuY=;
 b=aocZ0fwP1h+u0Qsbf8HJC3FEPUCHo391T1rmsG7EJowcwmBjC/+miKoeTZX/ZYd+xTZO6/FSjZ5roQ+8z4SMe48RAY0Ea/sx4r7IsW/BXFVnfCEXoj5K6KGy9cQTdHDeEGugLD+pwrbkFOEMkrfo+GvokIDWXtshARe4yCCV4gDw6KqrlOqZRHiIbxLzRKYwtqMH5Ho20o8vGZNs9P+VCDu9kX31hs1d9nPO3gdcD5gjGaXkiPlkMWSSEP4G05mOAE8YOnQSsQ2pPSLBh0KRQXaPeQrFIgKar5/z9/SdQFOO0PzAlGm3MrdhObUvAyuu0vTG1qeH5KRgCiBTTlwgwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlzrHMNmpyjCB/HbGELlLnW72UWN8YlQoXXYJsVJDuY=;
 b=x8AE8LlDupaxPrsq14beltWciITdgn38b2+W0fCL9p8ncr7tx/Xtsyu9HjHq5wBpv6cuuGSxes0+mEdkuNYidQtFgFYsAt3bxQw5798OrpaUUWyDlqgwXbcdpP8hESPlcBl/33e1/fWfbdf7Qs827y3NOGT1oVQSqaORDH+pLcI=
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by PH0PR11MB5126.namprd11.prod.outlook.com (2603:10b6:510:3a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Wed, 1 Sep
 2021 20:49:49 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::21ee:3ed8:d6c2:29b2]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::21ee:3ed8:d6c2:29b2%9]) with mapi id 15.20.4478.020; Wed, 1 Sep 2021
 20:49:49 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/103] ice: do not abort devlink info if board
 identifier cant be found
Thread-Topic: [PATCH 5.10 026/103] ice: do not abort devlink info if board
 identifier cant be found
Thread-Index: AQHXny3OjJSyICG6BUmoTrr5mH2R8quPlKsAgAAH3wCAAArigA==
Date:   Wed, 1 Sep 2021 20:49:49 +0000
Message-ID: <8168c579-9ba7-2c31-42b3-9ad88760110a@intel.com>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.400339475@linuxfoundation.org>
 <20210901194236.GA8962@duo.ucw.cz> <20210901201046.GC8962@duo.ucw.cz>
In-Reply-To: <20210901201046.GC8962@duo.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
authentication-results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a745b11-ef7f-407e-5d45-08d96d8a0a1f
x-ms-traffictypediagnostic: PH0PR11MB5126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB51261F761D6127FB4DFCDB96D6CD9@PH0PR11MB5126.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sUXBTvZEHQF2du5dH/DiG4bf7tFN0Rcj1mI8mY4yb8H7pRwvkbppbyzEJkPTX05KPel0HSUQImPuWMewOvM+C3TL+ZKR9gruQkoQvtkiJDIqD9hdrU1vHcTDqJpLaFJzVW09Dyrv4ZrGECAxad8JNFd6ksPoG8+qz/LsPRUJ0umF1QdHKg8PwU1SkST/T4A1WaKLqex3D7l6bprMbg3iMPMACZ4fNK8f2le4AhtH8nQeNqbo+RNE3NtwMZ4RH/lPW9BmWt7KMhjYFz4KgFmg/xwLhz/1zH0QiH0+fFUItj/eqjW5lyMt3EtLN00UFTvUN/xN/kJbLbLkhfk4go+etcWUFl5jjFNbHI3ozmE+CykAWglu5RiFfSJ922vYvF6FvIBU4kaK+q/8bwa9iluIIBMbZArxlpN3TVJbvDctpVNUGcfReuPvLh8GMke9DHQ5hEKZWsIv62BuRls/F5EffY2R5/+bcZBdd3C9bI0xWuObaWFUY9hZnBFxYdEFJsx+O3WCAft4jB8zFwvXwuj8RZyKBEbdWdbT5//NkO96HuB5p0beMO//4LjNnsx9oSpljgkTg6aFv4kvfrz74nff58DspygML4NvhMs1d4oZyxvFy5s3LLSmSB/I1XwSYCKZLRKJ9CZrx4pervy5hbbScL5gyoYIZOwglMkaeEqbwdrB/pdMTBEtM3FT3niPywsRKeIDxhpwgb1QCq+kcxxPnyZd0/WXVZ0SL2OIuz6/9YgtDo8QA8bEGlzSBtZAFBhdPFUwqXluaONR0NQAgia/sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(8676002)(83380400001)(8936002)(66946007)(478600001)(66556008)(316002)(54906003)(6916009)(91956017)(76116006)(2616005)(66476007)(26005)(31696002)(64756008)(66446008)(86362001)(2906002)(31686004)(186003)(53546011)(4326008)(6506007)(38100700002)(122000001)(6486002)(71200400001)(5660300002)(6512007)(38070700005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tm5wL0xEWllzeGp6K1BFLzRTMGhad0p3anlBL2l1SFBwdWJWd0RwQ1BhSVh4?=
 =?utf-8?B?QkJaTTRBdklsTVpyejczRHM1ajk4QXl2c0F1dGFTV1YzeEdwVlJTeG5RQ25z?=
 =?utf-8?B?ZjMwK0xNMFJydG93ejczWDJVNU9hd2ltNHc5MEJLbFliUG9OR3NRYmdTeFNX?=
 =?utf-8?B?NTFaUDRzTkhIeWNPWk9LYjhubzh2WWVsdWdZRnRQRUljYmh6YklpUWgzTi8w?=
 =?utf-8?B?RUVBOEhDK1lhclZDSWlJdUFMWkVBQ3lPV2lVQTdLYm9wcHozYi9zeHpsckJx?=
 =?utf-8?B?VnBESTE5cGVLWFJLQzBubWVVQ09OY1VOV3pqbzRLZkVVMFoxMUdFbWxYaFRL?=
 =?utf-8?B?K0J6YXVHZnA4OTlvd0s0OUp5L05SOE5kKzU5T2U5dWQvM1NTdTdoYy93bDEr?=
 =?utf-8?B?S0t5SVQ0aGFmK3NZOVJGYzJwWkRSYnpkNTR4NWNueDJZamlQcXRqVTNmWEY1?=
 =?utf-8?B?WmRwZkNhL3doSFViK1VXclFQeEh6L3p6Q3BxZE91TG1hUXFzMmZPSUpVSU5K?=
 =?utf-8?B?bVRVQnZtcXE4NkxYK3VMUDhGbytFOGpwaHpGaUZQdlp5T3FNZEZ3K1JIV3JW?=
 =?utf-8?B?MnAzc0RFMXdrWGtBa215dFJTVmY3TnpBRzF0Y21oditNYkthTWFCYVYza0sy?=
 =?utf-8?B?Z2xKL01UTFRMUXpkQ0NHZDRuWmF6bnhkcTJDU1N3cmpwL2MvOFJUOHA5Ti8w?=
 =?utf-8?B?UDZqOHUzV3A1Q3lFRlZUeGlkTmNpeUo2MzlHZXBpajhHYncvOThWZkNjRlhZ?=
 =?utf-8?B?VXJNM2RKQzFWYTJSUW9UTFd3SVQzak14blpMSmRpa0dLUnluenVESVExbjNE?=
 =?utf-8?B?T25GZ3hpUWpBWm0vSzNhYVhnSUNJZjN3SEdsaW40L3BvOWRUN01NYm1BTGpV?=
 =?utf-8?B?TEdNOHBvdm1heEo0Zm5nT2VKTWEvZzFhY081ODZHS0RJZTlUZzBxNU50c2JV?=
 =?utf-8?B?QVU0eWI0clpjdy82Ris1b0VrY3ZZZEdLQ0FXVFFrZWhEY3h1cEtyenRRSXVp?=
 =?utf-8?B?SVpjMEwrV0xlMEtybVB5NUtDUVlzY2tjRzIzNk1RTTdyWGV3UGJ4Y05aMjZQ?=
 =?utf-8?B?bW1MTjlRTTMydWZobjJGRzJXdWVaV3piZGN6ZFJMTjVXOXNpOFJ5TVRxeGw4?=
 =?utf-8?B?VTNoS1orZmZOMDBOQ25HbHl6MlZKeFRZdDZlZmNUSEJJU2hWTElwNGk1K3NU?=
 =?utf-8?B?VHI1T1FFQ0ZjRUxtbU50dFpHRkdBY0g2ckVMNDR3MU9jT0xsaGc1UHNodG8y?=
 =?utf-8?B?WnBab3hnOG9BWXZDWU5XNkRtVUo5TXJ3VVlrQWJGN2JhNmlWM3FqczBHY1da?=
 =?utf-8?B?MW15UU5lMDNPTTBjWHMrQmF3ZzZHYmRUMWs4TVZiZWhKL2M4bHl0RU9JWkNj?=
 =?utf-8?B?L1dTY1ljMmcrckQ5QlczTmExNWhUa29WQmdNNlRpU3FacUNodXV0ZjdYRXI0?=
 =?utf-8?B?bkYxdjJxZFpLaWlyRy9DTlF6NUtsUFdyV0NqMWxXQk9FRDZrN0E5UnYzSFJy?=
 =?utf-8?B?UG1rTE5UVE1UWXFFQjFudUxZbllvU1JNc0E3N3hMbVk1MGxJMWZQemYxYWgx?=
 =?utf-8?B?M2w2MHp1ZUpRZnFMRTZUdk1icWlpcjFwZmVWTmdxa3U1Wk54ck80TDJPWENI?=
 =?utf-8?B?ZzA2bEhCaHBaSDU5YnlvN0psdjRqeXhTQXlubU9ZSEJWQ3pWVXpOMy92eGR2?=
 =?utf-8?B?bHVEMk01UjlicUVJKy9sOU1wRERWdEpiY1dQZ3hZRUNMOWtRcXRKeGwwWHZz?=
 =?utf-8?Q?F+UMAvZetaVDWppNuU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B1FF85D35292A4A839CBBDCE353C0FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a745b11-ef7f-407e-5d45-08d96d8a0a1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2021 20:49:49.1740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p3MU5PG1vxOxd4vu02+8DoMu1L78VC/VQfp6oKbW9JT9Qo65cMU9TVb3aZO2LNfKrGnNQQkigEsihLe5JrCJDyTQcz06Fnf+LUMgbnJNEUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5126
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gOS8xLzIwMjEgMToxMCBQTSwgUGF2ZWwgTWFjaGVrIHdyb3RlOg0KPiBIaSENCj4gDQo+Pj4g
VGhlIGRldmxpbmsgZGV2IGluZm8gY29tbWFuZCByZXBvcnRzIHZlcnNpb24gaW5mb3JtYXRpb24g
YWJvdXQgdGhlDQo+Pj4gZGV2aWNlIGFuZCBmaXJtd2FyZSBydW5uaW5nIG9uIHRoZSBib2FyZC4g
VGhpcyBpbmNsdWRlcyB0aGUgImJvYXJkLmlkIg0KPj4+IGZpZWxkIHdoaWNoIGlzIHN1cHBvc2Vk
IHRvIHJlcHJlc2VudCBhbiBpZGVudGlmaWVyIG9mIHRoZSBib2FyZCBkZXNpZ24uDQo+Pj4gVGhl
IGljZSBkcml2ZXIgdXNlcyB0aGUgUHJvZHVjdCBCb2FyZCBBc3NlbWJseSBpZGVudGlmaWVyIGZv
ciB0aGlzLg0KPj4+DQo+Pj4gSW4gc29tZSBjYXNlcywgdGhlIFBCQSBpcyBub3QgcHJlc2VudCBp
biB0aGUgTlZNLiBJZiB0aGlzIGhhcHBlbnMsDQo+Pj4gZGV2bGluayBkZXYgaW5mbyB3aWxsIGZh
aWwgd2l0aCBhbiBlcnJvci4gSW5zdGVhZCwgbW9kaWZ5IHRoZQ0KPj4+IGljZV9pbmZvX3BiYSBm
dW5jdGlvbiB0byBqdXN0IGV4aXQgd2l0aG91dCBmaWxsaW5nIGluIHRoZSBjb250ZXh0DQo+Pj4g
YnVmZmVyLiBUaGlzIHdpbGwgY2F1c2UgdGhlIGJvYXJkLmlkIGZpZWxkIHRvIGJlIHNraXBwZWQu
IExvZyBhIGRldl9kYmcNCj4+PiBtZXNzYWdlIGluIGNhc2Ugc29tZW9uZSB3YW50cyB0byBjb25m
aXJtIHdoeSBib2FyZC5pZCBpcyBub3Qgc2hvd2luZyB1cA0KPj4+IGZvciB0aGVtLg0KPj4NCj4+
IFdpbGwgaXQgY2F1c2UgZmllbGQgdG8gYmUgc2tpcHBlZD8gSSBiZWxpZXZlIGJ1ZmZlciB3aWxs
IG5vdCBiZQ0KPj4gaW5pdGlhbGl6ZWQgd2hpY2ggd2lsbCByZXN1bHQgaW4gc29tZSBjb25mdXNp
b24uLi4NCj4gDQo+IElPVyBJIGJlbGlldmUgdGhpcyBpcyBnb29kIGlkZWEuDQo+IA0KDQpJdCdz
IG5vdCBuZWNlc3NhcnksIGJ1dCBJIGFncmVlIGl0cyBub3Qgb2J2aW91cyB3aXRob3V0IHRoZSBm
dWxsDQpjb250ZXh0LiBUaGUgY2FsbGVyIG9mIGljZV9pbmZvX3BiYSBtZW1zZXRzIHRoZSBidWZm
ZXIgYmVmb3JlIGNhbGxpbmcNCmVhY2ggaW5mbyByZXBvcnRlci4gSXRzIGFscmVhZHkgYSBrbm93
biBzZW1hbnRpY3MgdGhhdCBsZWF2aW5nIHRoZQ0KYnVmZmVyIGFsb25lIHdpbGwgc2tpcCB0aGUg
ZW50cnkuDQoNClNlZSB0aGUgY29kZSBiZWxvdyBmb3Igd2hhdCB3ZSBkby4NCg0KPiAgICAgICAg
ICAgICAgICAgbWVtc2V0KGN0eC0+YnVmLCAwLCBzaXplb2YoY3R4LT5idWYpKTsNCj4gDQo+ICAg
ICAgICAgICAgICAgICBlcnIgPSBpY2VfZGV2bGlua192ZXJzaW9uc1tpXS5nZXR0ZXIocGYsIGN0
eCk7DQo+ICAgICAgICAgICAgICAgICBpZiAoZXJyKSB7DQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIE5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssICJVbmFibGUgdG8gb2J0YWluIHZlcnNpb24g
aW5mbyIpOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dF9mcmVlX2N0eDsNCj4g
ICAgICAgICAgICAgICAgIH0NCj4gDQo+ICAgICAgICAgICAgICAgICAvKiBJZiB0aGUgZGVmYXVs
dCBnZXR0ZXIgZG9lc24ndCByZXBvcnQgYSB2ZXJzaW9uLCB1c2UgdGhlDQo+ICAgICAgICAgICAg
ICAgICAgKiBmYWxsYmFjayBmdW5jdGlvbi4gVGhpcyBpcyBwcmltYXJpbHkgdXNlZnVsIGluIHRo
ZSBjYXNlIG9mDQo+ICAgICAgICAgICAgICAgICAgKiAic3RvcmVkIiB2ZXJzaW9ucyB0aGF0IHdh
bnQgdG8gcmVwb3J0IHRoZSBzYW1lIHZhbHVlIGFzIHRoZQ0KPiAgICAgICAgICAgICAgICAgICog
cnVubmluZyB2ZXJzaW9uIGluIHRoZSBub3JtYWwgY2FzZSBvZiBubyBwZW5kaW5nIHVwZGF0ZS4N
Cj4gICAgICAgICAgICAgICAgICAqLw0KPiAgICAgICAgICAgICAgICAgaWYgKGN0eC0+YnVmWzBd
ID09ICdcMCcgJiYgaWNlX2RldmxpbmtfdmVyc2lvbnNbaV0uZmFsbGJhY2spIHsNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgZXJyID0gaWNlX2RldmxpbmtfdmVyc2lvbnNbaV0uZmFsbGJhY2so
cGYsIGN0eCk7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChlcnIpIHsNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLCAiVW5h
YmxlIHRvIG9idGFpbiB2ZXJzaW9uIGluZm8iKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBnb3RvIG91dF9mcmVlX2N0eDsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgfQ0K
PiAgICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgICAgICAgICAgLyogRG8gbm90IHJlcG9ydCBt
aXNzaW5nIHZlcnNpb25zICovDQo+ICAgICAgICAgICAgICAgICBpZiAoY3R4LT5idWZbMF0gPT0g
J1wwJykNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+IA0KDQoNCldlIG1l
bXNldCB0aGUgYnVmZmVyLCBjYWxsIHRoZSBnZXR0ZXIsIGFuZCBpZiB0aGF0IGRvZXNuJ3QgbW9k
aWZ5IHRoZQ0KYnVmZmVyLCB3ZSBjYWxsIHRoZSBmYWxsYWNrLCBhbmQgdGhlbiBjaGVjayBhZ2Fp
biBpZiBpdHMgc3RpbGwgZW1wdHkuDQoNCkJlY2F1c2Ugd2UgbWVtc2V0IGVhY2ggdGltZSwgd2Ug
ZG9uJ3QgbmVlZCB0byBhc3NpZ24gKmJ1ZiA9IDAuDQoNCkkgZ3Vlc3MgaXRzIG1vcmUgY2xlYXIg
dGhhdCB3ZSdyZSBkb2luZyB0aGUgY29ycmVjdCB0aGluZyBoZXJlLCBidXQNCnRoZXNlIGZ1bmN0
aW9ucyBhcmUgYnVpbGQtZm9yLXB1cnBvc2UgdG8gdXNlIGFzIHBvaW50ZXJzIGluIHRoaXMgQVBJ
IGFuZA0KYXJlbid0IHB1YmxpYywgc28gSSB0aGluayBpdCBpcyBmaW5lIHRvIGxlYXZlIGl0IGFz
IGlzLg0KDQpUaGFua3MsDQpKYWtlDQoNCj4gU2lnbmVkLW9mZi1ieTogUGF2ZWwgTWFjaGVrIChD
SVApIDxwYXZlbEBkZW54LmRlPg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfZGV2bGluay5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9kZXZsaW5rLmMNCj4gaW5kZXggZjE4Y2U0M2I3ZTc0Li43MDM0NzA0YjFiNTAgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZGV2bGluay5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZGV2bGluay5jDQo+
IEBAIC0yMiwxMCArMjIsMTIgQEAgc3RhdGljIGludCBpY2VfaW5mb19wYmEoc3RydWN0IGljZV9w
ZiAqcGYsIGNoYXIgKmJ1Ziwgc2l6ZV90IGxlbikNCj4gIAllbnVtIGljZV9zdGF0dXMgc3RhdHVz
Ow0KPiAgDQo+ICAJc3RhdHVzID0gaWNlX3JlYWRfcGJhX3N0cmluZyhodywgKHU4ICopYnVmLCBs
ZW4pOw0KPiAtCWlmIChzdGF0dXMpDQo+ICsJaWYgKHN0YXR1cykgew0KPiArCQkqYnVmID0gMDsN
Cj4gIAkJLyogV2UgZmFpbGVkIHRvIGxvY2F0ZSB0aGUgUEJBLCBzbyBqdXN0IHNraXAgdGhpcyBl
bnRyeSAqLw0KPiAgCQlkZXZfZGJnKGljZV9wZl90b19kZXYocGYpLCAiRmFpbGVkIHRvIHJlYWQg
UHJvZHVjdCBCb2FyZCBBc3NlbWJseSBzdHJpbmcsIHN0YXR1cyAlc1xuIiwNCj4gIAkJCWljZV9z
dGF0X3N0cihzdGF0dXMpKTsNCj4gKwl9DQo+ICANCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gDQoN
Cg==

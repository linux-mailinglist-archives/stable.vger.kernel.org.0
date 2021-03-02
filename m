Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE15932B0E3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhCCAkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:40:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:46182 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1445584AbhCBPxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 10:53:20 -0500
IronPort-SDR: k+ONzONitOq4R8gl+8K8V+6PF5vO5ZpuS951K2nAY8QlXcz5X47TsceAvm2gSD8sSZdbujk0dT
 eI6Zqg3ffYLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="183432074"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="183432074"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 06:36:40 -0800
IronPort-SDR: gXZMGtIIJI+EiUmnWhRGZtJEcS8/vREq0XFr7aKqtGzsmLrPjtbMXtG3GwdejXzZiHZylypAU4
 pk0lK2RlEc3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="434829738"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Mar 2021 06:36:40 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Mar 2021 06:36:40 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Mar 2021 06:36:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Mar 2021 06:36:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 2 Mar 2021 06:36:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P12OFFOZGAKoIWheTL4KNFsSxRNW0ROZOwcFu/tTiWUFaN4OkN57u1aq1htdE/+VvC0RZNd8KbtpV81wT9STriti1FfdQUh18ClcrK+VULjjU72nrHjZ2wksbs+X4n8fa1NTO/JjQZz08CeGEwXF9uArCclazXbTySHf3VeaTZfqR1M3klhuKea++gFTWh9hJ4URAM6Ys+d8vPFa3MW/jQb4/DoItsn/f5JKz0sCrNozlznahe7V4EwDAbFHrZQRv8Lmtb0YxB8N3FrIryiLrsgrbSwhPHlXHoPHEeN2fi9nJbJZJvWPOyQI7Dl/akjNFZjR7FN2QjLxN+oK0dtSsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1H0oELFYM5aAee4wxEX/g/phbfybBXQ9pppHQDdg/Dg=;
 b=mLQhWYpDHNPU9Zj6wFd8ZcVZsa4AYjz0VYX1ojAVH4G+OQuYonp50nps1RUMDBISo8dLrcy0OWx7Yj9b3lnYQkQIc8mFMDA4uKBYHDA8ivLM7A4dPkSFoPLK7Fhd8m7HXHAH9hfx+RYz41uGMUHwaKJsDN9N7SmSW6h91ASjhtmYVtPDr9FAVHxCACgz1793Zh9U5mq1/kpxmxxj+AH11DBcu1bghiTWuwziJG7g/oZsXlW3UedfZ8V0ANlh14wf+mTZWQtPNbGoGZDLUDbzrp05rgRh768PHv1ArJr/lNog8BtTBHH1qD0FVljDMOcR99fhJE60kArx1RlvWXwDBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1H0oELFYM5aAee4wxEX/g/phbfybBXQ9pppHQDdg/Dg=;
 b=gXF4rl+VM/Qst+LgIm9ZfUotDxBfInSMjtPYIzK3LUpJyPgdcBkgN3nphbFbXD2BJVP8eD/MY0KdGMn0AUoDwOEXRn7KDj/JfBpWm/YmJNEMN/O3T3FJZgSRIj4nFX/Y5UB8KztC17KABBgp85enfhCzTJ2vzjA9nX7YgEXitdY=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB4909.namprd11.prod.outlook.com (2603:10b6:a03:2af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 2 Mar
 2021 14:36:38 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf%3]) with mapi id 15.20.3890.023; Tue, 2 Mar 2021
 14:36:38 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ihab.zhaika@intel.com" <ihab.zhaika@intel.com>
Subject: Re: FAILED: patch "[PATCH] iwlwifi: add new cards for So and Qu
 family" failed to apply to 5.11-stable tree
Thread-Topic: FAILED: patch "[PATCH] iwlwifi: add new cards for So and Qu
 family" failed to apply to 5.11-stable tree
Thread-Index: AQHXDoOR8ywFYCk6rkqFpNLjv89aMapwwIKAgAAE9QCAAABnAA==
Date:   Tue, 2 Mar 2021 14:36:38 +0000
Message-ID: <a3fdeb4e41d0441cae9aa8f2dd93b40a26f08240.camel@intel.com>
References: <16145936091141@kroah.com>
         <f5fd7a304a92280467e1c6bfb465c408ba9fd71c.camel@intel.com>
         <YD5NHvewMnvkk/L0@kroah.com>
In-Reply-To: <YD5NHvewMnvkk/L0@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.151.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd2e1a5d-fdc3-4ac4-05da-08d8dd889687
x-ms-traffictypediagnostic: SJ0PR11MB4909:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4909F6625C12B020CA1F154790999@SJ0PR11MB4909.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQ9erQbJubYCmclj9IixMBy/Nc18eUVP1l6ch/JEeE5uSe2PrKl1m4jH+/djhoaeF0H70ATAGYUx0JaVosiIj69jiPMv5Bb7RD/wIYcMeyTa2uZka8Yu34eLOvWEbuIB+hCsMTxxyVCNBnptIE4F1F8X4NF6uTb+PMm57NZDczC6ha/NcBcIgaeOzp1o391b6c5UOtEdix8PdiVEylqCpywZsuEB/SBiMMAjpNyQ1i/nhgkzyXxbaZ48J42yop5MBXzUqewm9CP1GsZVq8ZrzfGCCbDNVULnyZgjvZAB6wTIF+wNf2++on57H8fPTDROrRAgY8yPFoGRgrREhmMnpkRDVk+qgpQZtloBoZnm5SV9DCOtsrOEM3HlRvqen7FY4nU20So7KZvmnjcSykoT7FHcs5O9ZaRb5GRV1eVwNpWeuEHLPtulIbbeveyHmVOJobqN0FCvZ3YbdodelgHeFH5K48Bz5IK6v2w6BdaK07Ot19zlaqQ7aCMZv/WNq8Y4aNZjwr3yMbxOP9ukEIm5TA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39860400002)(366004)(5660300002)(66946007)(66556008)(66476007)(64756008)(66446008)(4744005)(107886003)(478600001)(2616005)(4326008)(2906002)(186003)(6486002)(316002)(71200400001)(8936002)(6506007)(26005)(86362001)(8676002)(6916009)(6512007)(76116006)(91956017)(36756003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OHFBa1EyREJYRUNFTnk4T2Q4ODV5QTVLaFEyZ0JMaVNpUE43TGY3SUx2Z05a?=
 =?utf-8?B?M3RlTjJaUkd2ZVI0M2JTdStBajM2eURYaUhTNm5WbVpJSGN0WEEwODFReXVa?=
 =?utf-8?B?RUN0NnhTeitIVCtKdXJOQm83ak5HWWE4SDVndlk3cU11cTBaR29qUFRjdVQv?=
 =?utf-8?B?RFVpUkpaNzczeTVISFFnazVad0RNbHU2MEVmeUlSbG12ZGE4N09vQzBibWR2?=
 =?utf-8?B?dWxkaHFSeVVwOHFrb3BLSU8zSGFkdkc1eVZ3Z0pxeEdtc0lPVXNKMDgzTmRF?=
 =?utf-8?B?MkllU3BINEFNSnBzUjhWeHhaYXRKVVh5eGNKN3hvOTBmbUNKT2R1ZFB3cjBn?=
 =?utf-8?B?cFNLU2xGZlJ4Vmx5S0ZURkpvYzZaZUlxQXd0SXFUSURwNUtYTTBJODRiT1R0?=
 =?utf-8?B?NmlXNXZOWmJvRGMyek9yNHlhWGJSVDN1Q3JBblc3dUFoS2wzbUVDbHdFVHlP?=
 =?utf-8?B?SlR0MGVHZUYrUDd2dW1QaVJEUmVtbU5kVTV4OWNUSWxPbi9GUjEvdXZHYXpx?=
 =?utf-8?B?NVc0MC9ia1J4VmJZZGNVS25Sei9zZlhvSDlZd0kzNm9ZRlNCOUR4R2srYW0v?=
 =?utf-8?B?YWU5b05NMmk0L3F5SWtpQWcyZ1lrUFlsaHJxaVRNTkNpTlh1cXlxRER1dFdt?=
 =?utf-8?B?cVhZbFZMbG1wNzhqdlV0azd3Q25tcHZvL0NmTURGMUJxSi83RlNBUmI1ZkpJ?=
 =?utf-8?B?eHpLWTNQT2NzQ1ZlV3NSd3RFaG9vbmJnRjhvc1RUTlRtaWViZjNXTEZUVzZ2?=
 =?utf-8?B?Ynp0ZEtseG5YT0szMHA5YUFLZWdEaUdTKy9xNHQraEU5VHNiMUhaQ0h5Rk90?=
 =?utf-8?B?NmFiZ20rN0NVMGp1aDl4M2pKYjFHSzRTV3FDaW1rb3hkbko0ZmFVSDVFUWZX?=
 =?utf-8?B?Q1lISVRGV2Rac3FkeWhKUit2YlRiZ0Jta0cvZGtId1ZjSk5TQURzaWp4KzV4?=
 =?utf-8?B?K01BeE1ZN2wzRnlSNjVGM0FGeHA5NEl3d0hmM0NrVzNzL3YxVk5qR3NhSWcr?=
 =?utf-8?B?SVYwblphcmxCVFpKVS9yTHg0bHNSUWFSenVMcytwNXJxNEFIY01UVGhZVXlR?=
 =?utf-8?B?eVdKcmNJOWIvSjE3NWZCQ0ttcUJaQ29kb09uLzMzRkliWUFXTXJTWG01SmJz?=
 =?utf-8?B?NzQvWTZJTXJzL1p0UEUvN2lwUTRrTllIdS9BTUdiSzkwV3Jqd1l6N3lwYUpJ?=
 =?utf-8?B?ZStiLzR0Q2FkZGpCQVEyUnNyQkVIcm04a1ZEWk1SL3V2S0lrcDl4T1Z2eTRh?=
 =?utf-8?B?YWt2UEpCYjliK25KMVdKd2ZrblY4OTBjOUY5ZCtKcnd1ektPK2N5ZmMvVmVI?=
 =?utf-8?B?czE2bU9kdUgvL1FiNUQ2UEtkOTFtVXhteW1GaS8yVEpOYTFhbjVzNXZTS1pK?=
 =?utf-8?B?Unl6bkNENGVJUmxkVXZjbkVycW55OTlpckVsNStXL0pqbTdXZEVlOGw5WXlh?=
 =?utf-8?B?d2NDSUlDajB3TjhkcExuMVRkNFhMVVZxNzlmM1h1emxkeHFUQkxCdTNrM2Jk?=
 =?utf-8?B?U2pWOEM1citZS040cXJNblR2Nk43VlYwbXNqSi9HOHVtMWFrUUVMdTk1eXZs?=
 =?utf-8?B?czhSOVNWbExOS3liNVl2UG5UWXJYMDkxa2ZMVm9QU2dSd3YrbWsyNXdQSFlV?=
 =?utf-8?B?S3lyVTJyWkJRUmx0c3ZiU29aRitSOFROcjZBdXY3OGoyRnNjK3dQc2hJeGk4?=
 =?utf-8?B?ci9YejlZR1MyYzBCZmFYbDl0WVY3OTNOYUNQNkxRVlE0YnhvdFZ2ZzFIc2RR?=
 =?utf-8?B?UndoRC9sR0h3MUxEZjFrVFJ6dW1yTTFCcnBONnBZZHF0SktaOW0xSThwdTVy?=
 =?utf-8?B?ZURRT3BVWDhocUZMT3dYUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD7247A2B30F22459D0B9C178111E294@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2e1a5d-fdc3-4ac4-05da-08d8dd889687
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 14:36:38.2327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: prlU7z+YAELcWsMG6iqP2fHFJLVf+w3CsFi+lkEfaEmwcNgsw13gcOaGiHd4Ah9qR7UB7H/hbtx7NOMSqfQL31TM6nD6do94g6H520ZXUsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4909
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIxLTAzLTAyIGF0IDE1OjM1ICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVHVlLCBNYXIgMDIsIDIwMjEgYXQgMDI6MTc6MjVQTSArMDAwMCwg
Q29lbGhvLCBMdWNpYW5vIHdyb3RlOg0KPiA+IEhpIEdyZWcsDQo+ID4gDQo+ID4gSSB0cmllZCB0
byBhcHBseSB0aGlzIHBhdGggb24gdGhlIGxhdGVzdCBsaW51eC01LjExLnkgYnJhbmNoDQo+ID4g
KDI3ZTU0M2NjYTEzZmFiMDU2ODliMmQwZDYxZDIwMGE4M2NmYjAwYjYpIGFuZCBpdCBhcHBsaWVk
IGNsZWFubHkuDQo+ID4gDQo+ID4gTWF5YmUgdGhlcmUgYXJlIG90aGVyIHF1ZXVlZCBwYXRjaGVz
IHRoYXQgYXJlIGNvbmZsaWN0aW5nIHdpdGggdGhpcz8gSXMNCj4gPiB0aGVyZSBhIGJyYW5jaCBz
b21ld2hlcmUgdGhhdCBJIHNob3VsZCB1c2U/DQo+IA0KPiBJdCBhcHBsaWVzIGNsZWFubHksIGJ1
dCB5b3UgZmFpbGVkIHRvIGJ1aWxkIHRoZSBrZXJuZWwgd2l0aCB0aGF0IHBhdGNoDQo+IGFwcGxp
ZWQgdG8gc2VlIHRoZSBlcnJvciB0aGF0IGl0IGNhdXNlcyA6KA0KDQpPb3BzLCBzb3JyeSEgSSds
bCBmaXggdGhlIGNvbXBpbGF0aW9uIGlzc3VlIGFuZCBzdWJtaXQuDQoNClRoYW5rcyBmb3IgdGhl
IHF1aWNrIHJlc3BvbnNlLg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==

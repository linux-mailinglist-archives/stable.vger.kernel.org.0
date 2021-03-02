Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1433532B089
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhCCAhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:37:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:15297 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448199AbhCBOSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:18:42 -0500
IronPort-SDR: hqba3TBJ9nTnIdiXkkmzQ6/Y9Hg+t66k24PA8oe0UcDElsDBVMNZeQzv4rEc9up8nWVjTpveZG
 RhsfFIIFobAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="166060449"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="166060449"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 06:17:28 -0800
IronPort-SDR: pO0G+TQxFGYkzoTA3pgWtNVLXOLAX/GtFGJ7A+xrLyczwDSjXt8PrC7Z1rXtXX6p3TZwvegvJQ
 dcHIM8XXzhDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="444760826"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 02 Mar 2021 06:17:28 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Mar 2021 06:17:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Mar 2021 06:17:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 2 Mar 2021 06:17:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIoTYy2zdVjfGSbDwggH1wIcrO2h3oCyJec1JI0UuA6CpfdQsjkh2v/7bshm4foMFp0/K2RtLT2xlY67edeyW89cpaTWcpXOZH3sGPh6zqU2XqPwfOj8crcAJPQgNvbx2c5bx1A2BPjVU4K0NSH6J5yT0klVGKLu20x63bQzbgIXRyEdv/TsJ9uf2vs4JRf5HJS4uIGRDcf98vcEsH+H685/EIjuDgL/aahzW5D5TxidRRF1cssMpSR2eBWJcnpePzIBfTs61LBhdjs6dcnGkRXdL+3Mi0lK3fIkj7+VJFpfF4LsEIWtBQ512jzPH6GSKKMV1uXTJv5oFc3dbui5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dzkv2GmfkRoSkGRg7KnwQ39z2NZ0kWHZd6eoookTsw=;
 b=j1PN7toPaB++TM1p2tG1FfTzFRisF0tLpEqqhMVlz0CYBmXo9IIMtZXz+m35YBwMRo51gr1AeskDWOEaygVORxXZNO5KcXfzCKAy5k0Ikyqv/HQ4Q5eH2YctRc3ub3zKBIenUhRnTaTogSciG3xVzRc1OlTy5eUYE7YSIchJHDQKfhwzEcNiSAApqNykQi4TjUNjWNQfSLGqNyv0nBaE9CP3JSlGbCiCe30loUu2DYTVJW6yva+2e0GnEOqx+4k1cZ6fS7w06gTNN/W9vxEREIp/6xO9SEVIY3P9bIawbXWfxoHWHmLDolxTLJpOMh9dfxLJCtZNfwq1RaqW2aVd4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dzkv2GmfkRoSkGRg7KnwQ39z2NZ0kWHZd6eoookTsw=;
 b=R9woHuSuiuOCyW+eaNcLt80jzhiPnNQ8QPpy4cMmM3Ajzp/36lExeFVAQgYrimCCeRwVLs0v0g7uKgIWc6bMDM7wZCO4J7aQiVpaTntUxCLnKzToTIDxhTlpVnRcPIEmntJbggl+xfTYHEXdh9jfdtrrtFUTbiqZuBnXmqE7EYk=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BY5PR11MB4085.namprd11.prod.outlook.com (2603:10b6:a03:18d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 2 Mar
 2021 14:17:26 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf%3]) with mapi id 15.20.3890.023; Tue, 2 Mar 2021
 14:17:26 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ihab.zhaika@intel.com" <ihab.zhaika@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iwlwifi: add new cards for So and Qu
 family" failed to apply to 5.11-stable tree
Thread-Topic: FAILED: patch "[PATCH] iwlwifi: add new cards for So and Qu
 family" failed to apply to 5.11-stable tree
Thread-Index: AQHXDoOR8ywFYCk6rkqFpNLjv89aMapwwIKA
Date:   Tue, 2 Mar 2021 14:17:25 +0000
Message-ID: <f5fd7a304a92280467e1c6bfb465c408ba9fd71c.camel@intel.com>
References: <16145936091141@kroah.com>
In-Reply-To: <16145936091141@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.151.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 164f46c1-9c6e-4e6c-2673-08d8dd85e7b2
x-ms-traffictypediagnostic: BY5PR11MB4085:
x-ms-exchange-minimumurldomainage: kernel.org#8761
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4085DB76AA8BAB15BCD0498190999@BY5PR11MB4085.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zzm9vhccbKhKTpRXXdrt4KtW5P05mJKZj/yGUbNDlnYsz5K4d5fjFEgtT7SDGLjQnbZVs24dRLEwZW4knxpIOTZSx3aW8wqi5SnYExDL+Gl7hv6afsexgrus0bnCM5XsKdCt8WAbvrzs41ySTS1P+Z30VtES31XdkAbwtae1PFtSxiM3j3owRN/dBtkq5SeN6/mahgocvVDs46QqDpHFJTWxmLiiTMhwV7N15n1kH1q+yhqiluOq6PBv2Zd/AaKMR29HJ6dV3+0qGqFnW/7NiiDEAZc0q1MTyi2Ho7F15qLr6vhqNo/GBn78PeRoxxJFWwykiW/vGzGW+KI8VrBprd1NoRryvoltggiMpEY/1o/a8Z//UmbCvnQ0fkpm1uC2QHGP784pQP+S/v8iKSAufWpDlyml6OyZWXxvE8M8s4yUqwxYf1Hh3sDVHzlr6VObyIOaRrYdfo5nJ1HAtolizrob9QswkZA8dhKzeeJs1WLwzE3kCcFFtEw/XeXGZ7FZAQPsSxD203nYI++h+On6KiMoqa30Z6FExyZWl0J7TTNRgTfQxWm1rh4khRfEPN6AVgM2Wtj9C7NyCcY4BoeRWllkCdH5TpL0wKH3c9RZD2s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(5660300002)(6506007)(2906002)(91956017)(6636002)(83380400001)(6486002)(76116006)(53546011)(6512007)(186003)(26005)(110136005)(4326008)(64756008)(66446008)(2616005)(71200400001)(36756003)(316002)(8676002)(86362001)(66556008)(966005)(8936002)(478600001)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U1lHSE4yZ2pwUjNndy9ON0ljZ1JmRUJqY1JHY2JaN1lMWUk5SHJuR3ArSjdz?=
 =?utf-8?B?Wk9YRVdpUGVjSnRkV1VDbnQ2NnNmWHA0aGNaaUw5WGd6U0d6dEtkdU8xdTRK?=
 =?utf-8?B?ZHU4UDY4RnNKK01EWDdVWkpIN2ZSUzZ4bXBYUmpBZWM2dDFod0RHLzRxc3F0?=
 =?utf-8?B?SDBLRHlMWjdPVjJRQmV1S2I5d1ZiQUU5QjV6QndISVE4WC9uTm1JRUJYU0Rz?=
 =?utf-8?B?SzRtdUUwWkpNTmlmRk91ZXpSRUhTanBDZG1KbllSUGRFWGprV3Yxa0hvekI1?=
 =?utf-8?B?RkJGZnA4b1FsaWhSMXZPSkdMWXhVVHpBMHhTa2EyUDI5OVlTYjRON0RIYmNm?=
 =?utf-8?B?MlF4bWVSY2FRanRDdHpTa1pTTkZ2d25uVzFjRGdiS3pKanZPdWtRWDc1SklB?=
 =?utf-8?B?OXhBQjRSejNvbG1SR3NWMG5DL1FUamx1Vy9mTXJ5RFU0STVWWUtpTmJRclY0?=
 =?utf-8?B?aXU1dERBS3M1SVVrM2xZajIxWjM5aWdPUklMU1Ruc0NTSzZOY3d2cDBiNG1H?=
 =?utf-8?B?THFROUJYc0NGWnFPN1NEb0xHeWNrVTF6RTZua01wRDh4ZUFDK3ZqcGMzSkVS?=
 =?utf-8?B?czFHTDE2TGlTcDcvZ1l3L0pSNksvMDc3angzQlE0eFc0WkVONldsSHpGOGlT?=
 =?utf-8?B?cmV3N3c1WHhSRmJVWDE4WlEwSkZ6cnJ3eXBtRXRXV0VodFJyMWdRS3NadDVQ?=
 =?utf-8?B?c0N5T3p6YmxCTHNHaXhDcFR3STZMSm5PQ2F1d3hQVGkxVW5nck1yb3VkT01M?=
 =?utf-8?B?eklnVVdTZHc2LzliZ21xenBETlhuak1iSXhCdm9zV3E5Vzl6RC8wRHdCUkJv?=
 =?utf-8?B?OXFJTkg3OUhER3R1a2hWTnR5a2o0ZWhXS1hxRXFTRVFnS2VxeGxZejNHRUkx?=
 =?utf-8?B?SFBjb0l5Zy8rQWtNanhtTjg5eUVweHd3VTJvMFp2S2ZXcG5jL0NPekN5V1h3?=
 =?utf-8?B?RkdpcEZ4QXJTYmQzSWEySmhtUEVXT25hVFVzSTg3cmw3UFIzVDV1RVNnK05h?=
 =?utf-8?B?Y2hCODZJVUZmQlNURlRZNGwrVWx4Qnh5czhNN3c1V2tNZ3JUQzBtbjQxeVFL?=
 =?utf-8?B?dHdyL3MvVDJvdUxSNFhRTkgrdTR4cjRGdW9lRGlldy81N3orZ1pPZVU1VHNs?=
 =?utf-8?B?aTNYUnJuTGJQT1VESTRkakJjbG5CMEM0SnVkM0JrSEFrT3NmcVVnRUwwdFFI?=
 =?utf-8?B?UWpFYkVTYUtjUFVLYUJGOFdWaVhRSzN0c2VJMlhNdGROYW1ySy9vRnVDRGxT?=
 =?utf-8?B?WnNiL3ZweDR5ck1lTUY0bmhNQ1I0b3dXVEFxdGZnTndrbWdhSFMwYTd3Rzls?=
 =?utf-8?B?SG5GR1BvWis5YkcreGN2YXZUN0RzK2VLUmo1MUlJejRHWUlHa1p0aVBxQm55?=
 =?utf-8?B?TzNuT2tMZjcyUGxyTVFlRmdNZmRlWExTS3NBYzQvMEIyWUtKMklXKzhmaFV3?=
 =?utf-8?B?U0k1VmZaRE1HdVg2dTViWW81MktVeEJXUHdBdDdWbW5GZmRzbUxBRVpUYlh6?=
 =?utf-8?B?SWlsSi9KT0JVY095QTR4ZlVDR0wyaXZMSmpCOFpON25nbjhwRkxWcWd1NUQz?=
 =?utf-8?B?K2pFNDAwZy9EQ0F3cXQyRk4yai9UY1VuaHRjUWVxcjRXR08vcGtSUkpBK3lH?=
 =?utf-8?B?QlZSWWEvazQxUm1XMnFBYm4yeWx2a1pJNnBDKzVmMFNvbFEvTmdBMVhNcUxQ?=
 =?utf-8?B?akRFYUVxQnJpTVF6ZGFoR3U4aE44TjZLUElKVVZqOHREWFArNU85WlE0OTB5?=
 =?utf-8?B?SGhmMmhuaDZKemJWWHdoYVBlR2g3dlovWXR4OVlteFFiQk8weXBxV1IxSlJs?=
 =?utf-8?B?QzJmSWRlbW9sZkJpSlpRQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83DAF9132F2EEE458F326A3F47FF38B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164f46c1-9c6e-4e6c-2673-08d8dd85e7b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 14:17:25.9466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KWioMOSi7nvKOyYSrr6BaEzPCZlMLbt4zdbZt9tjFIzQLnmb9u0tgK7GvJ/o0Je4GsTQtBlxlr7UHzC5zD30Z0gsiGzl8bOeSCHa79X2CQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4085
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KSSB0cmllZCB0byBhcHBseSB0aGlzIHBhdGggb24gdGhlIGxhdGVzdCBsaW51
eC01LjExLnkgYnJhbmNoDQooMjdlNTQzY2NhMTNmYWIwNTY4OWIyZDBkNjFkMjAwYTgzY2ZiMDBi
NikgYW5kIGl0IGFwcGxpZWQgY2xlYW5seS4NCg0KTWF5YmUgdGhlcmUgYXJlIG90aGVyIHF1ZXVl
ZCBwYXRjaGVzIHRoYXQgYXJlIGNvbmZsaWN0aW5nIHdpdGggdGhpcz8gSXMNCnRoZXJlIGEgYnJh
bmNoIHNvbWV3aGVyZSB0aGF0IEkgc2hvdWxkIHVzZT8NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQoN
Cg0KT24gTW9uLCAyMDIxLTAzLTAxIGF0IDExOjEzICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0
aW9uLm9yZyB3cm90ZToNCj4gVGhlIHBhdGNoIGJlbG93IGRvZXMgbm90IGFwcGx5IHRvIHRoZSA1
LjExLXN0YWJsZSB0cmVlLg0KPiBJZiBzb21lb25lIHdhbnRzIGl0IGFwcGxpZWQgdGhlcmUsIG9y
IHRvIGFueSBvdGhlciBzdGFibGUgb3IgbG9uZ3Rlcm0NCj4gdHJlZSwgdGhlbiBwbGVhc2UgZW1h
aWwgdGhlIGJhY2twb3J0LCBpbmNsdWRpbmcgdGhlIG9yaWdpbmFsIGdpdCBjb21taXQNCj4gaWQg
dG8gPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+Lg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBr
LWgNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLSBvcmlnaW5hbCBjb21taXQgaW4gTGludXMncyB0
cmVlIC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbSA0MTBmNzU4NTI5YmMyMjdiMTg2YmEw
ODQ2YmNjNzVhYzA3MDBmZmIyIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBJaGFi
IFpoYWlrYSA8aWhhYi56aGFpa2FAaW50ZWwuY29tPg0KPiBEYXRlOiBTYXQsIDYgRmViIDIwMjEg
MTM6MDE6MTAgKzAyMDANCj4gU3ViamVjdDogW1BBVENIXSBpd2x3aWZpOiBhZGQgbmV3IGNhcmRz
IGZvciBTbyBhbmQgUXUgZmFtaWx5DQo+IA0KPiBhZGQgZmV3IFBDSSBJRCdTIGZvciBTbyB3aXRo
IEhyIGFuZCBRdSB3aXRoIEhyIGluIEFYIGZhbWlseS4NCj4gDQo+IENjOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEloYWIgWmhhaWthIDxpaGFiLnpoYWlrYUBpbnRl
bC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEx1Y2EgQ29lbGhvIDxsdWNpYW5vLmNvZWxob0BpbnRl
bC5jb20+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvaXdsd2lmaS4yMDIxMDIw
NjEzMDExMC42ZjBjMTg0OWY3ZGMuSTY0N2I0ZDIyZjk0NjhjMmYzNGI3NzdhNGJmYTQ0NTkxMmM2
ZjA0ZjBAY2hhbmdlaWQNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9p
bnRlbC9pd2x3aWZpL2NmZy8yMjAwMC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXds
d2lmaS9jZmcvMjIwMDAuYw0KPiBpbmRleCBlMGM3NDEwYTAxZjYuLmQxZTlmY2JhOTY0NSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9jZmcvMjIwMDAu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2NmZy8yMjAwMC5j
DQo+IEBAIC02ODIsNiArNjgyLDI0IEBAIGNvbnN0IHN0cnVjdCBpd2xfY2ZnIGl3bF9jZmdfc25q
X2EwX21yX2EwID0gew0KPiDCoAkubnVtX3JiZHMgPSBJV0xfTlVNX1JCRFNfQVgyMTBfSEUsDQo+
IMKgfTsNCj4gwqANCj4gDQo+ICtjb25zdCBzdHJ1Y3QgaXdsX2NmZyBpd2xfY2ZnX3NvX2EwX2hy
X2EwID0gew0KPiArCS5md19uYW1lX3ByZSA9IElXTF9TT19BX0hSX0JfRldfUFJFLA0KPiArCUlX
TF9ERVZJQ0VfQVgyMTAsDQo+ICsJLm51bV9yYmRzID0gSVdMX05VTV9SQkRTX0FYMjEwX0hFLA0K
PiArfTsNCj4gKw0KPiArY29uc3Qgc3RydWN0IGl3bF9jZmcgaXdsX2NmZ19xdXpfYTBfaHJfYjAg
PSB7DQo+ICsJLmZ3X25hbWVfcHJlID0gSVdMX1FVWl9BX0hSX0JfRldfUFJFLA0KPiArCUlXTF9E
RVZJQ0VfMjI1MDAsDQo+ICsJLyoNCj4gKwkgKiBUaGlzIGRldmljZSBkb2Vzbid0IHN1cHBvcnQg
cmVjZWl2aW5nIEJsb2NrQWNrIHdpdGggYSBsYXJnZSBiaXRtYXANCj4gKwkgKiBzbyB3ZSBuZWVk
IHRvIHJlc3RyaWN0IHRoZSBzaXplIG9mIHRyYW5zbWl0dGVkIGFnZ3JlZ2F0aW9uIHRvIHRoZQ0K
PiArCSAqIEhUIHNpemU7IG1hYzgwMjExIHdvdWxkIG90aGVyd2lzZSBwaWNrIHRoZSBIRSBtYXgg
KDI1NikgYnkgZGVmYXVsdC4NCj4gKwkgKi8NCj4gKwkubWF4X3R4X2FnZ19zaXplID0gSUVFRTgw
MjExX01BWF9BTVBEVV9CVUZfSFQsDQo+ICsJLm51bV9yYmRzID0gSVdMX05VTV9SQkRTXzIyMDAw
X0hFLA0KPiArfTsNCj4gKw0KPiDCoE1PRFVMRV9GSVJNV0FSRShJV0xfUVVfQl9IUl9CX01PRFVM
RV9GSVJNV0FSRShJV0xfMjIwMDBfVUNPREVfQVBJX01BWCkpOw0KPiDCoE1PRFVMRV9GSVJNV0FS
RShJV0xfUU5KX0JfSFJfQl9NT0RVTEVfRklSTVdBUkUoSVdMXzIyMDAwX1VDT0RFX0FQSV9NQVgp
KTsNCj4gwqBNT0RVTEVfRklSTVdBUkUoSVdMX1FVX0NfSFJfQl9NT0RVTEVfRklSTVdBUkUoSVdM
XzIyMDAwX1VDT0RFX0FQSV9NQVgpKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2ludGVsL2l3bHdpZmkvaXdsLWNvbmZpZy5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9pd2wtY29uZmlnLmgNCj4gaW5kZXggNDFkNzRhOGMzMTRkLi5iNzIxNDJhMjQ3
ZDAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXds
LWNvbmZpZy5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXds
LWNvbmZpZy5oDQo+IEBAIC02MDksNiArNjA5LDggQEAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBpd2xf
Y2ZnIGl3bF9jZmdfc25qX2EwX2pmX2IwOw0KPiDCoGV4dGVybiBjb25zdCBzdHJ1Y3QgaXdsX2Nm
ZyBpd2xfY2ZnX21hX2EwX2dmX2EwOw0KPiDCoGV4dGVybiBjb25zdCBzdHJ1Y3QgaXdsX2NmZyBp
d2xfY2ZnX21hX2EwX21yX2EwOw0KPiDCoGV4dGVybiBjb25zdCBzdHJ1Y3QgaXdsX2NmZyBpd2xf
Y2ZnX3Nual9hMF9tcl9hMDsNCj4gK2V4dGVybiBjb25zdCBzdHJ1Y3QgaXdsX2NmZyBpd2xfY2Zn
X3NvX2EwX2hyX2EwOw0KPiArZXh0ZXJuIGNvbnN0IHN0cnVjdCBpd2xfY2ZnIGl3bF9jZmdfcXV6
X2EwX2hyX2IwOw0KPiDCoCNlbmRpZiAvKiBDT05GSUdfSVdMTVZNICovDQo+IMKgDQo+IA0KPiDC
oCNlbmRpZiAvKiBfX0lXTF9DT05GSUdfSF9fICovDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmMgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmMNCj4gaW5kZXggYzQ1NTQyZmE4YjdmLi5jMTcyMzRj
MGM5NDUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkv
cGNpZS9kcnYuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3Bj
aWUvZHJ2LmMNCj4gQEAgLTkyNiw2ICs5MjYsMTEgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpd2xf
ZGV2X2luZm8gaXdsX2Rldl9pbmZvX3RhYmxlW10gPSB7DQo+IMKgCQkgICAgICBJV0xfQ0ZHX1JG
X1RZUEVfSFIxLCBJV0xfQ0ZHX0FOWSwNCj4gwqAJCSAgICAgIElXTF9DRkdfQU5ZLCBJV0xfQ0ZH
X0FOWSwNCj4gwqAJCSAgICAgIGl3bF9xdXpfYTBfaHIxX2IwLCBpd2xfYXgxMDFfbmFtZSksDQo+
ICsJX0lXTF9ERVZfSU5GTyhJV0xfQ0ZHX0FOWSwgSVdMX0NGR19BTlksDQo+ICsJCSAgICAgIElX
TF9DRkdfTUFDX1RZUEVfUVVaLCBTSUxJQ09OX0JfU1RFUCwNCj4gKwkJICAgICAgSVdMX0NGR19S
Rl9UWVBFX0hSMiwgSVdMX0NGR19BTlksDQo+ICsJCSAgICAgIElXTF9DRkdfTk9fMTYwLCBJV0xf
Q0ZHX0FOWSwNCj4gKwkJICAgICAgaXdsX2NmZ19xdXpfYTBfaHJfYjAsIGl3bF9heDIwM19uYW1l
KSwNCj4gwqANCj4gDQo+IMKgLyogUW5KIHdpdGggSHIgKi8NCj4gwqAJX0lXTF9ERVZfSU5GTyhJ
V0xfQ0ZHX0FOWSwgSVdMX0NGR19BTlksDQo+IEBAIC05OTcsNiArMTAwMiwyNyBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGl3bF9kZXZfaW5mbyBpd2xfZGV2X2luZm9fdGFibGVbXSA9IHsNCj4gwqAJ
CSAgICAgIElXTF9DRkdfQU5ZLCBJV0xfQ0ZHX0FOWSwNCj4gwqAJCSAgICAgIGl3bF9jZmdfc25q
X2EwX21yX2EwLCBpd2xfbWFfbmFtZSksDQo+IMKgDQo+IA0KPiArLyogU28gd2l0aCBIciAqLw0K
PiArCV9JV0xfREVWX0lORk8oSVdMX0NGR19BTlksIElXTF9DRkdfQU5ZLA0KPiArCQkgICAgICBJ
V0xfQ0ZHX01BQ19UWVBFX1NPLCBJV0xfQ0ZHX0FOWSwNCj4gKwkJICAgICAgSVdMX0NGR19SRl9U
WVBFX0hSMiwgSVdMX0NGR19BTlksDQo+ICsJCSAgICAgIElXTF9DRkdfTk9fMTYwLCBJV0xfQ0ZH
X0FOWSwNCj4gKwkJICAgICAgaXdsX2NmZ19zb19hMF9ocl9hMCwgaXdsX2F4MjAzX25hbWUpLA0K
PiArCV9JV0xfREVWX0lORk8oSVdMX0NGR19BTlksIElXTF9DRkdfQU5ZLA0KPiArCQkgICAgICBJ
V0xfQ0ZHX01BQ19UWVBFX1NPLCBJV0xfQ0ZHX0FOWSwNCj4gKwkJICAgICAgSVdMX0NGR19SRl9U
WVBFX0hSMiwgSVdMX0NGR19BTlksDQo+ICsJCSAgICAgIElXTF9DRkdfTk9fMTYwLCBJV0xfQ0ZH
X0FOWSwNCj4gKwkJICAgICAgaXdsX2NmZ19zb19hMF9ocl9hMCwgaXdsX2F4MjAzX25hbWUpLA0K
PiArCV9JV0xfREVWX0lORk8oSVdMX0NGR19BTlksIElXTF9DRkdfQU5ZLA0KPiArCQkgICAgICBJ
V0xfQ0ZHX01BQ19UWVBFX1NPLCBJV0xfQ0ZHX0FOWSwNCj4gKwkJICAgICAgSVdMX0NGR19SRl9U
WVBFX0hSMSwgSVdMX0NGR19BTlksDQo+ICsJCSAgICAgIElXTF9DRkdfMTYwLCBJV0xfQ0ZHX0FO
WSwNCj4gKwkJICAgICAgaXdsX2NmZ19zb19hMF9ocl9hMCwgaXdsX2F4MTAxX25hbWUpLA0KPiAr
CV9JV0xfREVWX0lORk8oSVdMX0NGR19BTlksIElXTF9DRkdfQU5ZLA0KPiArCQkgICAgICBJV0xf
Q0ZHX01BQ19UWVBFX1NPLCBJV0xfQ0ZHX0FOWSwNCj4gKwkJICAgICAgSVdMX0NGR19SRl9UWVBF
X0hSMiwgSVdMX0NGR19BTlksDQo+ICsJCSAgICAgIElXTF9DRkdfMTYwLCBJV0xfQ0ZHX0FOWSwN
Cj4gKwkJICAgICAgaXdsX2NmZ19zb19hMF9ocl9hMCwgaXdsX2F4MjAxX25hbWUpDQo+IMKgDQo+
IA0KPiDCoCNlbmRpZiAvKiBDT05GSUdfSVdMTVZNICovDQo+IMKgfTsNCj4gDQoNCg==

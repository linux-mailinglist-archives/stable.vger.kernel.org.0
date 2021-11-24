Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A557245B5F2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 08:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhKXHzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 02:55:49 -0500
Received: from esa.hc188666.iphmx.com ([68.232.145.191]:65427 "EHLO
        esa.hc188666.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhKXHzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 02:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=conduent.com; i=@conduent.com; q=dns/txt; s=sept2021;
  t=1637740360; x=1669276360;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uta2a2ZOOGeygwc0MmdhycJFQpuAbjl6qPokmBY15tc=;
  b=CdHGYFvyusHgPUKMKjHHozchlxHg7qAlG0ZcqIr9g/pX9SIFkUp2MLpm
   hR1RJ18UxZmDGxSAUyklbCcv046+AZxGElXceCtouyA1bJSH2ag8XC3jT
   wyTAvt+qiG512D/wFiaO+kS3HZBcu6UxQBFHVc2pNHvR8OYH24TjbcP4X
   q9eqgnM4acWj+jXEjeqEsdQxHEAb4XMyb1qHN8xcze1D0WpvrTFgL0Br3
   jPaYQdajac8cGIlM2ArRFxmDCeFIs8CVLweobAb75v+bCUZZRfP8KIvOc
   MRb1ja9JwLEt6bonJNUTxKrBPhQ38HNMJfQEttM5OBuhGcOGuk3ZWSiNS
   A==;
X-IronPort-AV: E=Sophos;i="5.87,260,1631595600"; 
   d="scan'208";a="210175872"
Received: from mail-mw2nam08lp2175.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.175])
  by ob1.hc188666.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 01:52:36 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkNPVVVT4YBXnRzPl0UtB1cO5KCXz76CJbe6Hf3FK+gYaxwnc9uIAzFHjH0kHAYXnfVotcZyIU+xHIeCh0i7ReLs7++ETTlBb2RBSQVOksAGVFFcUHQyErKo2MtyVb4++5aiCxLQeZjHIF1SxorXJyf2phBXaIOqN1GE50Z9S7AbKdrSdMdj4fW55/QyTRrrtqORst5kDh7+R4tCnLfxluuC5v93bC1YlDMINhS5SwwdUCSVjh9qByrEB9JP2cizKfjZ2CujJs9YZj82ZgUmfsvWsEfAFrf8OErOk/npLozthUKzdvHRCkbZoupbk0nIX264orQIaR+QeI9NSR71lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uta2a2ZOOGeygwc0MmdhycJFQpuAbjl6qPokmBY15tc=;
 b=VwadpzAVGd43XwWQL5CJxYq7ha7AcJSa5hxMNUKa+2EkR5TAPi90fi1Nyqb+xoSG5yS7Jm/hSOQGkzqrc9GaQEl4RhpNrKsB2ZKIJgG/1yQXLkIGqI1PIpFYyfp/4X/z7wMy0Wn036E5WBLXO9Q2c/i+lpvtoZNW/1b+NGaaPZnZXDZdvgG0Vlbi5/fVXI6ofKs1ZHP4+iibFR9ZoBcm9DbdFe299JQnaVTSCBx/lfYDbslNUJfVPXZmN3XL8boCVNHDqqSivuVFJQtDdHNT80whJ4WvYQwGilQeLiNHCAtvRwYZYQfW/2zeZrkU4NkiX2ZFGQBGOYn7HToWuP0lfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=conduent.com; dmarc=pass action=none header.from=conduent.com;
 dkim=pass header.d=conduent.com; arc=none
Received: from BN8PR20MB2674.namprd20.prod.outlook.com (2603:10b6:408:8e::17)
 by BN6PR20MB1620.namprd20.prod.outlook.com (2603:10b6:404:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 07:52:33 +0000
Received: from BN8PR20MB2674.namprd20.prod.outlook.com
 ([fe80::fd5c:cde6:a909:2325]) by BN8PR20MB2674.namprd20.prod.outlook.com
 ([fe80::fd5c:cde6:a909:2325%2]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 07:52:33 +0000
From:   "Fernandes, Francois" <Francois.Fernandes@conduent.com>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
CC:     "webmaster@kernel.org" <webmaster@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [External] - Re: EOL Kernels versions
Thread-Topic: [External] - Re: EOL Kernels versions
Thread-Index: AdfgUJIys2sQaThVQNmvMpZAGmTDrAAJvjmAAAEv8jAAAMXHAAACuiOAAABRV4AAHxXBMA==
Date:   Wed, 24 Nov 2021 07:52:32 +0000
Message-ID: <BN8PR20MB2674CE32EDE0C904C267D0D1F8619@BN8PR20MB2674.namprd20.prod.outlook.com>
References: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
 <BN8PR20MB26741ED4B21328F5F64CFC14F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123153254.pqz4ii7jhf3c5ltz@meerkat.local>
 <BN8PR20MB2674E60612008BC2114D3A3DF8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123170005.36v2fspqis2ahjgn@meerkat.local>
In-Reply-To: <20211123170005.36v2fspqis2ahjgn@meerkat.local>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=conduent.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 294aa6cf-e392-4853-9f53-08d9af1f5f96
x-ms-traffictypediagnostic: BN6PR20MB1620:
x-microsoft-antispam-prvs: <BN6PR20MB16200595C6B26080FA9B0F0DF8619@BN6PR20MB1620.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hdM+r3+6kqfcKa6TBKgmwdSrxPxOxljEDDVFbImhWXgMLAn9qMGVKr5DJ6nQZDVe10RVeQnlAdJF8lOu+xkJ/keWMhhsvaRJkrk26vMPHoivyavjRvC+KiA4HhCcO6qEA/g5mIbTVPoMD1upZcV2nOZ5siQ2qyl2uLAmV/BcguSuBSWw4GhRX6dpQFxSifXdlr2SImGZabKZPgtZqmqciXYyKTJvWdoUjhHMoG2Xg7HrN5jJ3/KKAx6jCpXyKL/ZpYlvlK7Rt9JWBQL0VC9gUXtPthbQD4lk7VDYN08mA7cqHnYmq8g9cUVr2r+VVQWZPeBtNk+B15miMclXdyPSw+qto/tMgPoA9TGIXI67S9DzNlAN9NCiQPE8zenS6IPMt14dSbwMENIIfwhoVkyPJQg3mrMFGDHdFtJZJrij723zMRiGGG+fwZ6BrL6t8pTuXtfEa4v/NH7oeJV4IAZ0o7wHk1e5FpdRv6l1DKyh/jA9OX/6aJjvzepKfRBpJVlq0/XNlVnsE+oskeKXhH7tY2SDC+7sImSWvZdtfIauZ4YrkVYE9BwMUjM17xuPyuBh4TVJs/d0YQ2Q8NmVE0lvn24pcQKrni8sqi+Y4yDKslvkhgL3IOfhqfTjbRBlveWj/TdBCDkLZCkA6NbpKQJlYMNpBdo574/aGmeh7wm3E0IfAQY7BZRvwxYTmaurkA6Tth3LD9gMbnNInlOKAI3zhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR20MB2674.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(5660300002)(54906003)(9686003)(76116006)(82960400001)(508600001)(6916009)(33656002)(6506007)(52536014)(316002)(86362001)(66556008)(38070700005)(2906002)(64756008)(55016003)(8936002)(38100700002)(66446008)(186003)(8676002)(66476007)(66574015)(26005)(71200400001)(7696005)(66946007)(83380400001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clQ5c3VGMVhvU0JrMU1JV0FSZGhaMjNGTDFUZUN1UnVFZkpyOHU0N1IvNWRa?=
 =?utf-8?B?Y1pmU3lTbVRONDBIQU43a2Ztc21xdytyZlJZbHcrT01JZDU1dW40a0lNN3lu?=
 =?utf-8?B?SlpKYVF0cHA5V29iOHFoSDZvQUhFeDUwblBZZHRuODhRV3h4bXVLOEwwZmhB?=
 =?utf-8?B?RlBYbjdMcStMTHBxeG1lbVdRaDU0R1BZTG4vVkdRajJFNGdOZTZNTm1iM1J3?=
 =?utf-8?B?Nnp0YURwTVJJV1BLOW1SNDVQaTdhU09IM28xUGtENGlERnE5SlJhSzRLNGRR?=
 =?utf-8?B?d2YxWlE5UkFPbnh5NDREMHJlK3NqYjJkelZXNXlocmoxRk9ISmh3Y2VKQ3lI?=
 =?utf-8?B?Rk9heUdqdElWWkl1VUp6eURvV3llSGpHUkpEeGpYRXdSYWl3aTlrQlFTWExN?=
 =?utf-8?B?MWNtZ0hLU2tMVUVJU3lwd0x4ZTd5ZmRKVzJSU2FsN04wRDVYRGoza1FaVHN1?=
 =?utf-8?B?b0hLYjhVM0xWRkRwRkdSek5kVk9YUzBITEx3bllnd1FFOXZxZHVVWE9NTE9u?=
 =?utf-8?B?OXdxb0NkVnZuY3dmenpUV1Y4U0wxcjZOeldlR3RDOEY5SHc2bkJwbmhtVjgz?=
 =?utf-8?B?WjdEaDZaWmlqbnlTUmpnY0I4NEkzdk01RlRFZDZ3dTFKMGtJTkxwUkJRSmxK?=
 =?utf-8?B?MHQvMTE2d3kvdmFmS2g5ZE5DbUpLczUxQ2NvaEhnclA3bW9MSEJyQzc2dGFK?=
 =?utf-8?B?NlVRbTRNc1hmc0djRjI0aG01dWJRNDNJZ05qZDBjQkpRUWJDZGNMemE0c0o4?=
 =?utf-8?B?dlg2TG42N3Z6eFpaQi9pSXYrRE9VdjkxaWgyUW5EcnJnbUd4T0ZjaVlmNEp5?=
 =?utf-8?B?TEUwakhiUTZMV1hIcVRpKzM0Y29FTzZKaVVlYmVrVWo0bWx6MGw4Qm04ajlD?=
 =?utf-8?B?WWMvdnY3dnNPcU0wSTV2N2htaXBrSTFHR2VSdGh4eDBxNFlMYzV4Y1hOTVNO?=
 =?utf-8?B?QVJEckxJdDVDdGI1bVY3K2ZsVmQxRmh5NmVwS3BiblBRUEptdkZhNGNLdlVs?=
 =?utf-8?B?RnpucWh3aTEwdTkrOHFYKzhrL0dsUGh6OENnblMrYWx1STBacENnWEhlZzVt?=
 =?utf-8?B?ZzRadnVUV0tCZUpEd0dLMjRVSkhJMnZHM1pjS2g0ejJtNVJzamRIUnpLUm1J?=
 =?utf-8?B?NHN3Q1BSWCtQUHhtRDg3aXA2U1JIRThtQ3ZJWkZwU1BjcVorbEhycVRWZlhL?=
 =?utf-8?B?SnNTcTBzTkFKeXZ0WGM0anMyeXppS01CZGZaSWlVYkNyV0JOZjc0bU45a3VW?=
 =?utf-8?B?Si92eW93TkhHczVmeitIcTY5S0VIUXlkSUtwUE5Tb3kwb0QreFFURnRKakRy?=
 =?utf-8?B?SU5iWTc2ODVkQmtLRElpSHR0SVh0WDNmcm9CRjJmclUwZE9mQlRlUVpRWXZ4?=
 =?utf-8?B?VE5udnhyT1Foa2U3L25RRi9UdFZISllncDR2ZHlaMEJmNEJUQjk4TkVxa0Y3?=
 =?utf-8?B?SkhKUFdOL0hHY01RSElNQVRUNUdmR1VpcGd6TzlncUJ5UzQ2WkxCa3RMekpJ?=
 =?utf-8?B?ckxhMW42Q1BmdmJWUCtweGtwZlAxcC9aZFJwRklpSzcxbW1aS01hUm9heERC?=
 =?utf-8?B?V0puTm5GbEg3a01OZzVWN0pzTTZxRFdXVW9hRmtnSkRoRmN1V0MwU1AwZXpi?=
 =?utf-8?B?RjFTZUl5WHhJYVVwSEtYd3lHVGl2eFNuSTVONnV6d2RmcG9GRUtOd0FGL3RJ?=
 =?utf-8?B?NHZlWEpQMHRGd0gvOUo4d0svcEdicFRrZEVUUm1UYXdEU3RaV3Y2NjRnaHR6?=
 =?utf-8?B?ZDFaVC94dm9OdVNOZU96UDc2VUNoMmtUQklKOWNpY29HM0Q3NGp1NnJvUExr?=
 =?utf-8?B?RHVPZ00zeUo5MmtEcUJNd1dwVXY3cDUrejA1dll3d0I4MnlqSVZmOU9TSDVm?=
 =?utf-8?B?dGxPdzdaa2FmSzlGZVdrM2RGTHVyWXZYZks4TkxKcWpHL3VOSWpqb2tUSUpn?=
 =?utf-8?B?cDhYYUNJTEtyYW0vTkh2TWY3M3A2Q0JRWE40Y29lZ0crN3IzZU5xZk9KRzg3?=
 =?utf-8?B?VzU4ZXV3d29JZGVOQVcyWVNXcDVPblZ3Z0tDZnNUK2NzN2hrK2hGY3RpZnJL?=
 =?utf-8?B?bFV4UTZIN0kySUpKa2hoVXlTZVZyeDVqZ3NjSTF3QTR6RjFwKzhzWDg5aTRP?=
 =?utf-8?B?Um5LZGY1NTZBRVdpVTYrcVFDRThBL21nbzZRUUs5bS9OOU9rVXlkbzA4TUtW?=
 =?utf-8?B?MlNFVVRzbVl3eFd1amlYY1lEMEhrcVhvZDV3VDNBcWVQeU05S2F3MmJ6TGFh?=
 =?utf-8?B?S0dKaFJEakFnZ2hyRXlkZ1VGUktBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: conduent.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR20MB2674.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294aa6cf-e392-4853-9f53-08d9af1f5f96
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 07:52:32.9900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1aed4588-b8ce-43a8-a775-989538fd30d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RBSKhlVitbjlMVH0fS7E3UVN7HJPnTp1lOX8ZMi8ANtEcaEdqj4AspwG7dOx4ZMDP4HE5JfOzyTjvfe3rM20tEeprfnztXA3+3jXOuZgoKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR20MB1620
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgS29uc3RhbnRpbiwNCg0KVGhhbmtzIGEgbG90LCB0aGlzIGV4YWN0bHkgb3VyIHNpdHVhdGlv
bi4NCg0KSSB3aWxsIGZvcndhcmQgdGhpcyB0byBvdXIgc3BlY2lhbGlzdCBkZXBhcnRtZW50IGFu
ZCB3aWxsIGJlIGJhY2sgaWYgbmVjZXNzYXJ5Lg0KDQpUaGFua3MgYWdhaW4gZm9yIHlvdXIgYXBw
cmVjaWF0ZWQgc3VwcG9ydCBhbmQgaGVscC4NCkhhdmUgYSBuaWNlIGRheS4NCkJlc3QgcmVnYXJk
cy4NCkZyYW7Dp29pcw0KDQotLS0tLU1lc3NhZ2UgZCdvcmlnaW5lLS0tLS0NCkRlwqA6IEtvbnN0
YW50aW4gUnlhYml0c2V2IDxrb25zdGFudGluQGxpbnV4Zm91bmRhdGlvbi5vcmc+IA0KRW52b3nD
qcKgOiBtYXJkaSAyMyBub3ZlbWJyZSAyMDIxIDE4OjAwDQrDgMKgOiBGZXJuYW5kZXMsIEZyYW5j
b2lzIDxGcmFuY29pcy5GZXJuYW5kZXNAY29uZHVlbnQuY29tPg0KQ2PCoDogd2VibWFzdGVyQGtl
cm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCk9iamV0wqA6IFJlOiBbRXh0ZXJuYWxd
IC0gUmU6IEVPTCBLZXJuZWxzIHZlcnNpb25zDQoNCk9uIFR1ZSwgTm92IDIzLCAyMDIxIGF0IDA0
OjUzOjQzUE0gKzAwMDAsIEZlcm5hbmRlcywgRnJhbmNvaXMgd3JvdGU6DQo+IE9LLA0KPiBTbyBp
biB0aGlzIGNhc2Ugd2UgJ29ubHknIGhhdmUgdG8gZm9sbG93IHRoZSB2ZXJzaW9uIGZvciB0aGUg
ZGlzdHJpYnV0aW9uIGRhdGUgYW5kIG1vdmUgdGhpcyBhdCBlYWNoIEVPTCBkaXN0cmlidXRpb24g
ZGF0ZS4NCj4gDQo+IEkgdW5kZXJzdG9vZCB0aGF0IHRoaXMga2luZCBvZiBldm9sdXRpb24gaXMg
ZWFzaWVyIHRoYW4gYSBrZXJuZWwgZXZvbHV0aW9uLg0KPiBDb3VsZCB5b3UgY29uZmlybSBwbGVh
c2UgPw0KDQpJIGNhbm5vdCBjb25maXJtIHRoaXMsIHNpbmNlIHRoZSBhbnN3ZXIgd2lsbCBkZXBl
bmQgb24gd2hhdCBleGFjdGx5IHlvdSBuZWVkIGZvciB5b3VyIHByb2plY3QuIElmIHlvdSBhcmUg
bm90IHNoaXBwaW5nIGN1c3RvbSBoYXJkd2FyZSBhbmQgZG8gbm90IHJlcXVpcmUgYSBjdXN0b20g
a2VybmVsIGJ1aWxkLCB0aGVuIHlvdSBzaG91bGQgc3RpY2sgd2l0aCB0aGUga2VybmVsIHRoYXQg
Y29tZXMgd2l0aCB0aGUgZGlzdHJpYnV0aW9uIHlvdSBhcmUgdXNpbmcgYW5kIHVwZ3JhZGUgd2hl
bmV2ZXIgdGhlIG5leHQgRGViaWFuIHZlcnNpb24gaXMgcmVsZWFzZWQuDQoNCkhvcGUgdGhpcyBo
ZWxwcy4NCg0KLUsNCg==

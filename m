Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4DE444E6A
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 06:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhKDFlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 01:41:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:10743 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhKDFlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 01:41:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="229107755"
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="229107755"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 22:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="578451098"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Nov 2021 22:38:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 3 Nov 2021 22:38:57 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 3 Nov 2021 22:38:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 3 Nov 2021 22:38:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 3 Nov 2021 22:38:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEZhH32FjYMNSTpdL3rhYTASxOaplHZnDsIRXF8Yw8YQ31d4m2aRfuGy9Mp5Okq3AmKTmblgnalmEXXxn9zt0Xvl3WFhCIonIP2D0ySxIBNo28PAwMrinRjzrUAmc7dcsPm0rFpxjGFquOgWKbjJcUDVD2/6GdYB09iUPWtrcTfSVKaqNGXt3SNu38xE1AGIkVMflBjep+am2Ioh3VM0zWgzqspF2BYVzyu2Cb2cZl2NGtmsFFV56cw5j6ZjH6U7HZf6vSt/EcegWjQlgUEEp5lK4Mk84gcZhZIa9MfIY1zf4NCFLjXrUh0hhtzoD8cA1nZ9kXr6bbtlSZSJHZ2Osg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJ2xJa5AajVJoVAySKa8mecOlSWgHkO0+2nNa0eLotI=;
 b=mdE/iXV/iA34tC7Yzz1CIv/s0963e6355tmb9HYrf3O7eQXE31th1ryQEHjg06ev0F7SQyXWNVXyUx6dQ+Yd9LDClmHEzFSPNiny71cm2SX5Db2o+Th2gMGvNLRKBOpMWiQynDiXnyL31jJnfgcR2dkd2pXTW/bY1iokWXqzk6WWPdGrssT/Pi79Zxx1RG/NVrrw5obWRnw4e+4KsFuEFm/4b4ZYJHCmW7fAZvH68Kg49cIYSGeMU//K2NnzW+ccTTidkl9dF+6raQcGI05jQYPUc8VkMUuK3FtDLZqQ/oIiLIrgJSbb4T9/UEECc0/nheqyfQFM+O73w1jxFMAmPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJ2xJa5AajVJoVAySKa8mecOlSWgHkO0+2nNa0eLotI=;
 b=H8yWy0mawdkYI3hb2vSDS3rY6HC+ljpuIvCTK+TOreF+ufzK9E4oLfXKdXJcppMeMYz+SEKB/fjALRyE27JKEqN/lGHKQf/MwdZG9D9Gud39E4ihw6jnWipK328lQhMcAHa+JW/BFgzGBsMXkTs4zGj7MKkr5UgOc2slsJ1Hnes=
Received: from SJ0PR11MB5150.namprd11.prod.outlook.com (2603:10b6:a03:2d4::18)
 by SJ0PR11MB5166.namprd11.prod.outlook.com (2603:10b6:a03:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 05:38:55 +0000
Received: from SJ0PR11MB5150.namprd11.prod.outlook.com
 ([fe80::1c99:cc97:391:1406]) by SJ0PR11MB5150.namprd11.prod.outlook.com
 ([fe80::1c99:cc97:391:1406%9]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 05:38:54 +0000
From:   "Williams, Dan J" <dan.j.williams@intel.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>
CC:     "nathan@kernel.org" <nathan@kernel.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "marmarek@invisiblethingslab.com" <marmarek@invisiblethingslab.com>,
        "Chagam, Anjaneya" <anjaneya.chagam@intel.com>,
        "bp@suse.de" <bp@suse.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Thread-Topic: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Thread-Index: AQHX0T5BODHF8DSF6EqfFZFgYvTybA==
Date:   Thu, 4 Nov 2021 05:38:54 +0000
Message-ID: <e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com>
References: <20210920120421.29276-1-jgross@suse.com>
         <163233113662.25758.10031107028271701591.tip-bot2@tip-bot2>
In-Reply-To: <163233113662.25758.10031107028271701591.tip-bot2@tip-bot2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a64d44d0-39de-45c8-5d40-08d99f556417
x-ms-traffictypediagnostic: SJ0PR11MB5166:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB51664F3029ECD1F36E85DEBBC68D9@SJ0PR11MB5166.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kUjeaKikm+mV0267D0/kaqKZ7PZ/QIKLUzaEfSjZ8Ss0MyTUF+2l9KppTnrJvGbzSdOiHmjQYHmR3C6MMie52gXLZuFWVxyRJJFXJ2cXzu8obzqEShzDYQHvQShJBs6I9OHrnTK/DFy9Z1kj0XVHsYXvUMvWfZ5DBzshoHypHkX+o54cQpd6oN/hWlB/zOgIk0+J3K8Ago7Jo9Cv+OP+4Yk6IVkdKDYaUxeeOUD1YB6pVGlf5nq6zdgoeEER0W1GMAqNmjfB0MOBI1PY+1BPeNrzdD/gXmHcA1g1XBWTG4eUwfhQXIBF13dIKsvNhiyx17Bt7t0UKOcM5xOuIBtPXvH+JTfgAQ36xeIR3O2xGbsHppPe/s92xSzRL/VuHZ9sMTeeK6Qw7fzn4hA0RZNNGSmGoHf62H2IXHPxc6K4dOZOj5f6Ib7S7t13pEEl44MQrg+yS6Vzpczgtx/HY/mbU1+qcBne8LJjgOuCzfOisSj7dyLInnBEiFljCFoI2wc+El/rXH0Lb5npLAO6aTrJHeHDn++SVRngjrG+Wo1MknQoo6MU+IUeDC8tY2Po5vA1dr1GuElFFAO4yWQbBw2MU9o0IsQujHbskKJ1pBhCasDqaEioy+Mu0QGq43vJnZylS6VeVEKt3Jz91FpMMomYmgI6dzEhMceXupzS81Zu7y3cq7onq1mefTL7OyTEV+l4SnPMSp1vm2WJWk8CHIbqxBnqFRPR1o7vXcKMUAg1WIhT6+zJ64O+2CGn1fK6/Nal1/46LVBXHtO7SbTUAC0HJ4X66clrmc6wXANLqsZs7WTZKEVTFw2OKnAEz8dRUOoPI/69E9wXa3Sec+KP8o1kXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5150.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(54906003)(2616005)(38100700002)(86362001)(71200400001)(6512007)(26005)(83380400001)(110136005)(186003)(966005)(5660300002)(66556008)(36756003)(76116006)(66446008)(64756008)(508600001)(6486002)(82960400001)(122000001)(66574015)(8676002)(66476007)(2906002)(4326008)(66946007)(38070700005)(8936002)(6506007)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmdoVXJVbVM3a0k5dDdLWnRRdlJCaWs0TUxEN2VOTmVIV0xRUWRIZGhGbHNV?=
 =?utf-8?B?TnJ2dHV6Rm9kd2QrenUyWE94bnJxck01dHlNdmhqckpRNTBjYlJjLzhZZC9u?=
 =?utf-8?B?Q3g3K3Z3blY1aG9uZEJWMFRWWW1mbzlJTzFSdGtaSGpFMHcvOE5NTlVSK2tB?=
 =?utf-8?B?MVhJSjZrTjIvckNoS09iRVA4SW1pYWt6cW5BMlZTSGxVK0YwcXZYSm1VUlRO?=
 =?utf-8?B?Kzl3aDZOd3NzSlh5amhzajBMYlhHdUxsR3VoME5WOHVFQk9qUzJqejRHV0tn?=
 =?utf-8?B?WERDSGtQanZIeXdiLzVKd2tkZ015c09jS2kyYXBNUzdieVA4SW1nbFpLbTJu?=
 =?utf-8?B?Q1dYWVZKT3Rpcmt4Qnh0dlZkZUpzaVZrSkc0K3l0cVJRaW1VcUNwc2dkYTFX?=
 =?utf-8?B?VlNHZWhVTytQTDhoUXdiWTRieURKQ0tEdTRFRlVHdm5kN0JNTWNjYzVpWEw0?=
 =?utf-8?B?cXhEcEpYTzlmdTdVMTloM0lTUllvZVdqeU1ZKzBrSUpXMHd6RkR2MGk1RUoy?=
 =?utf-8?B?K2JMcVljNjdOSXdleUdzN2NlQTNQdjdLQ0cvSzNHdlNXeVJ2Zm1SeEpOUm96?=
 =?utf-8?B?VWxwYnhlNi9pVGlhdSt5RkFFNU54K0htTzdxMUg1MWN6MGhTT2lzbHd0aFFi?=
 =?utf-8?B?aWFJclFEdUMxVVNnaGNscFNWbnFtOFRKQjZOZXpBVERkTURwSFlBNW03a0pR?=
 =?utf-8?B?NWNVVHZxNUI2ZWZkNi9aV0NvanNsNnFuSmwrU0Z1T2pXMUFXQW9lODNiQXhR?=
 =?utf-8?B?SllDU3Fqc3BvaDk4aS9vcUxhVnJPOHNyaHFla1I2cDJJTmphRWdOOWFEeG55?=
 =?utf-8?B?V3U5Z24rL05NU2xzeVE4WTQ1OGVkUDBCaUhBZ1N3M3pJSUxLcUoyN2tUREYr?=
 =?utf-8?B?N09CZ1k4N0JadUpFRjNaMU9oODFOczNsVU9VQ2RVVXk2MTl0UnhHUnpEKzBj?=
 =?utf-8?B?dTNOL0FBSW9EcE9EQjhaLy9QNEIwQjIvTnRSQzBnYUtXZTVmdis0dnNiWi9n?=
 =?utf-8?B?ck5KWnc5L0pmclorL1FCZDBsaU1qWVEyRlpVWS9zNG51Q2dNdjhDRllOQVJk?=
 =?utf-8?B?UXJEYmc3RFFZM0ZkYmw1c1p0VVZNS1ZaUlpnQTNqL2VBVWZVVGljOFI1QWVK?=
 =?utf-8?B?ellaQlR3dFJWMXhhUS9RejhrNVRCc0FpdWdlRnExZmtQWkdIdlpWNGdWUkdv?=
 =?utf-8?B?Y1V4Y1R4cktMVVhpbEFVcUVMSFhwdTdxTjdHeDR4VDVZbWt2blloM0lQY1Zi?=
 =?utf-8?B?QTlRa1FlTEg5Y2FlU2gyK1Z2SXhEbGx6Wmh1WXJoc3ZCK294QVBFYkJGSjZ5?=
 =?utf-8?B?RjllTWVWSndZRU55MXZBTE8xN1FLazNJSFBzWTFsTFVXOHJNOWdGbzRTRTFO?=
 =?utf-8?B?M1NHRHVYeGRsdHVzL1dBV0lKOFlKSU01M2FLc2k3ZlVXcDFZL25HZmg4YURy?=
 =?utf-8?B?dDJScEhla0JQTmxVU1hxeEdlZ0lnT3lJRVJmanJ0VmY3VDR4UFpmdXNOaW8w?=
 =?utf-8?B?WGk1MnVlUVRlOEdkd1B0ZDFWbGtJM0QyTTBLZ2RWTDdTaGViRDJpMDkwc0tr?=
 =?utf-8?B?dmM1Sjlad1czTUF6QzFjV2hPU1VhRzJZaDBJRHJ4ZHRmclhZRkRSd1FvTE93?=
 =?utf-8?B?ejBIajJQS0VHWTkyU2J3aERJUXlwbkUyZXhQQ3Y0TzRFZWlmSVVVcXZ5SEpk?=
 =?utf-8?B?WGFmVzR6YmhtcEtXUTdLdkhjK28vbEg3aGszbTFDTlYrQnBTV1ZTNjJYak85?=
 =?utf-8?B?NWtRckZSMDNYaTNEVXFHaVRLaVhveVQxUXp6U2NlUzJPZkZZSGJONTlYcFc5?=
 =?utf-8?B?UXltYVFHTHdydFFQcFJ0Ym5MLzhpR2JvZFRBQmZQV09ub3VrWnVuN0N1Rkpx?=
 =?utf-8?B?STNYd3VNS1JYcU5LazhMWUs2L0krdXFwaSs5Y0RHVmJyWk1GOFM4SjE2am5V?=
 =?utf-8?B?dzJxSnYvWFM3bU4ydmJPVFVQcUVmcUNOSjZyTVB4OUhxd1BtNWgvM1BKK2E4?=
 =?utf-8?B?ZlYvemF6VVlFSjkyeHZwTEVhaU5kUEpTa2R2Q0owVUN0ZU9vMFlraDFMSUVj?=
 =?utf-8?B?U0ZLSld6M01lZXluRDJwczNGcWEvUVNxb2xkUlF1aWdFd25zSlM3dnhFbENp?=
 =?utf-8?B?czYvcWk4eEUwK3ovaXJpc1Y4aWpiMER3b2U2c1JjUGJsekFvOTZTZTBvVU1C?=
 =?utf-8?B?YVNYZGZlc01UZDM4MnRuc2MzT1dicDR2QXlFUFBUMTlpWWxIL2lCYmZzQm9I?=
 =?utf-8?Q?FSZ35c7btv0MR9tdsWUhyzQXOwFe7GVnT1IwfQS7mw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7A8A723DF23724EAC9DE39EC9E037D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5150.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64d44d0-39de-45c8-5d40-08d99f556417
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 05:38:54.8571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3joytCDL8oAiNKGXSN4LblfHAlDU+ZuxoZU8lfBz6h4+6Mjbg3bCiVyd+HZ4Jt9RyXtWqt3vtslYFdFlXGJi12GBdXi0Iw9XAUfS7OnuZu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5166
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIxLTA5LTIyIGF0IDE3OjE4ICswMDAwLCB0aXAtYm90MiBmb3IgSnVlcmdlbiBH
cm9zcyB3cm90ZToNCj4gVGhlIGZvbGxvd2luZyBjb21taXQgaGFzIGJlZW4gbWVyZ2VkIGludG8g
dGhlIHg4Ni91cmdlbnQgYnJhbmNoIG9mDQo+IHRpcDoNCj4gDQo+IENvbW1pdC1JRDrCoMKgwqDC
oCA4YWE4M2U2Mzk1Y2UwNDdhNTA2ZjBiMTZlZGNhNDVmMzZjMWFlN2Y4DQo+IEdpdHdlYjrCoMKg
wqDCoMKgwqDCoA0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3RpcC84YWE4M2U2Mzk1Y2UwNDdh
NTA2ZjBiMTZlZGNhNDVmMzZjMWFlN2Y4DQo+IEF1dGhvcjrCoMKgwqDCoMKgwqDCoCBKdWVyZ2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+IEF1dGhvckRhdGU6wqDCoMKgIE1vbiwgMjAgU2Vw
IDIwMjEgMTQ6MDQ6MjEgKzAyOjAwDQo+IENvbW1pdHRlcjrCoMKgwqDCoCBCb3Jpc2xhdiBQZXRr
b3YgPGJwQHN1c2UuZGU+DQo+IENvbW1pdHRlckRhdGU6IFR1ZSwgMjEgU2VwIDIwMjEgMDk6NTI6
MDggKzAyOjAwDQo+IA0KPiB4ODYvc2V0dXA6IENhbGwgZWFybHlfcmVzZXJ2ZV9tZW1vcnkoKSBl
YXJsaWVyDQoNCkhpLA0KDQpJIGdvdCBhIHJlcG9ydCBmcm9tIEFuamFuZXlhIHRoYXQgc3RhcnRp
bmcgd2l0aCB0aGUgdjUuMTUga2VybmVsIGhlIGNhbg0Kbm8gbG9uZ2VyIHVzZSB0aGUgImVmaT1u
b3NvZnRyZXNlcnZlIiBrZXJuZWwgY29tbWFuZCBsaW5lIHBhcmFtZXRlciB0bw0Kc3VwcHJlc3Mg
InNvZnQgcmVzZXJ2YXRpb24iIGJlaGF2aW9yLiBSZWNhbGwgdGhhdCAic29mdCByZXNlcnZlZCIg
aXMNCnRoZSBMaW51eCBkZXNpZ25hdGlvbiBmb3IgbWVtb3J5IHRoYXQgaXMgbWFya2VkIHdpdGgg
dGhlIEVGSSAiU3BlY2lhbA0KUHVycG9zZSIgYXR0cmlidXRlLg0KDQpCeSBpbnNwZWN0aW9uLCB0
aGlzIGNvbW1pdCBsb29rcyBsaWtlIHRoZSBzb3VyY2Ugb2YgdGhlIHByb2JsZW0gYmVjYXVzZQ0K
ZWFybHlfcmVzZXJ2ZV9tZW1vcnkoKSBub3cgcnVucyBiZWZvcmUgcGFyc2VfZWFybHlfcGFyYW0o
KS4gSSBzdXNwZWN0DQp0aGF0IHRoaXMgYWxzbyBhZmZlY3RzIG1lbW1hcD0gc2luY2UgaXQgaXMg
YWxzbyBhbiBlYXJseV9wYXJhbSgpLiBJJ2xsDQp2ZXJpZnkgdGhhdCB0b21vcnJvdyB3aGVuIEkn
bSBtb3JlIGF3YWtlLCBidXQgd2FudGVkIHRvIGdpdmUgYSBoZWFkcyB1cA0KaW4gdGhlIG1lYW50
aW1lLg0KDQoNCj4gDQo+IENvbW1pdCBpbiBGaXhlcyBpbnRyb2R1Y2VkIGVhcmx5X3Jlc2VydmVf
bWVtb3J5KCkgdG8gZG8gYWxsIG5lZWRlZA0KPiBpbml0aWFsIG1lbWJsb2NrX3Jlc2VydmUoKSBj
YWxscyBpbiBvbmUgZnVuY3Rpb24uIFVuZm9ydHVuYXRlbHksIHRoZSBjYWxsDQo+IG9mIGVhcmx5
X3Jlc2VydmVfbWVtb3J5KCkgaXMgZG9uZSB0b28gbGF0ZSBmb3IgWGVuIGRvbTAsIGFzIGluIHNv
bWUNCj4gY2FzZXMgYSBYZW4gaG9vayBjYWxsZWQgYnkgZTgyMF9fbWVtb3J5X3NldHVwKCkgd2ls
bCBuZWVkIHRob3NlIG1lbW9yeQ0KPiByZXNlcnZhdGlvbnMgdG8gaGF2ZSBoYXBwZW5lZCBhbHJl
YWR5Lg0KPiANCj4gTW92ZSB0aGUgY2FsbCBvZiBlYXJseV9yZXNlcnZlX21lbW9yeSgpIGJlZm9y
ZSB0aGUgY2FsbCBvZg0KPiBlODIwX19tZW1vcnlfc2V0dXAoKSBpbiBvcmRlciB0byBhdm9pZCBz
dWNoIHByb2JsZW1zLg0KPiANCj4gRml4ZXM6IGE3OTljMmJkMjlkMSAoIng4Ni9zZXR1cDogQ29u
c29saWRhdGUgZWFybHkgbWVtb3J5IHJlc2VydmF0aW9ucyIpDQo+IFJlcG9ydGVkLWJ5OiBNYXJl
ayBNYXJjenlrb3dza2ktR8OzcmVja2kgPG1hcm1hcmVrQGludmlzaWJsZXRoaW5nc2xhYi5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogQm9yaXNsYXYgUGV0a292IDxicEBzdXNlLmRlPg0KPiBUZXN0ZWQtYnk6IE1h
cmVrIE1hcmN6eWtvd3NraS1Hw7NyZWNraSA8bWFybWFyZWtAaW52aXNpYmxldGhpbmdzbGFiLmNv
bT4NCj4gVGVzdGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5lbC5vcmc+DQo+
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IExpbms6IGh0dHBzOi8vbGttbC5rZXJuZWwu
b3JnL3IvMjAyMTA5MjAxMjA0MjEuMjkyNzYtMS1qZ3Jvc3NAc3VzZS5jb20NCj4gLS0tDQo+IMKg
YXJjaC94ODYva2VybmVsL3NldHVwLmMgfCAyNiArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQ0K
PiDCoDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyBiL2FyY2gveDg2L2tlcm5l
bC9zZXR1cC5jDQo+IGluZGV4IDc5ZjE2NDEuLjQwZWQ0NGUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9zZXR1cC5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jDQo+IEBA
IC04MzAsNiArODMwLDIwIEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVf
cCkNCj4gwqANCj4gwqDCoMKgwqDCoMKgwqDCoHg4Nl9pbml0Lm9lbS5hcmNoX3NldHVwKCk7DQo+
IMKgDQo+ICvCoMKgwqDCoMKgwqDCoC8qDQo+ICvCoMKgwqDCoMKgwqDCoCAqIERvIHNvbWUgbWVt
b3J5IHJlc2VydmF0aW9ucyAqYmVmb3JlKiBtZW1vcnkgaXMgYWRkZWQgdG8gbWVtYmxvY2ssIHNv
DQo+ICvCoMKgwqDCoMKgwqDCoCAqIG1lbWJsb2NrIGFsbG9jYXRpb25zIHdvbid0IG92ZXJ3cml0
ZSBpdC4NCj4gK8KgwqDCoMKgwqDCoMKgICoNCj4gK8KgwqDCoMKgwqDCoMKgICogQWZ0ZXIgdGhp
cyBwb2ludCwgZXZlcnl0aGluZyBzdGlsbCBuZWVkZWQgZnJvbSB0aGUgYm9vdCBsb2FkZXIgb3IN
Cj4gK8KgwqDCoMKgwqDCoMKgICogZmlybXdhcmUgb3Iga2VybmVsIHRleHQgc2hvdWxkIGJlIGVh
cmx5IHJlc2VydmVkIG9yIG1hcmtlZCBub3QgUkFNIGluDQo+ICvCoMKgwqDCoMKgwqDCoCAqIGU4
MjAuIEFsbCBvdGhlciBtZW1vcnkgaXMgZnJlZSBnYW1lLg0KPiArwqDCoMKgwqDCoMKgwqAgKg0K
PiArwqDCoMKgwqDCoMKgwqAgKiBUaGlzIGNhbGwgbmVlZHMgdG8gaGFwcGVuIGJlZm9yZSBlODIw
X19tZW1vcnlfc2V0dXAoKSB3aGljaCBjYWxscyB0aGUNCj4gK8KgwqDCoMKgwqDCoMKgICogeGVu
X21lbW9yeV9zZXR1cCgpIG9uIFhlbiBkb20wIHdoaWNoIHJlbGllcyBvbiB0aGUgZmFjdCB0aGF0
IHRob3NlDQo+ICvCoMKgwqDCoMKgwqDCoCAqIGVhcmx5IHJlc2VydmF0aW9ucyBoYXZlIGhhcHBl
bmVkIGFscmVhZHkuDQo+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiArwqDCoMKgwqDCoMKgwqBlYXJs
eV9yZXNlcnZlX21lbW9yeSgpOw0KPiArDQo+IMKgwqDCoMKgwqDCoMKgwqBpb21lbV9yZXNvdXJj
ZS5lbmQgPSAoMVVMTCA8PCBib290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHMpIC0gMTsNCj4gwqDC
oMKgwqDCoMKgwqDCoGU4MjBfX21lbW9yeV9zZXR1cCgpOw0KPiDCoMKgwqDCoMKgwqDCoMKgcGFy
c2Vfc2V0dXBfZGF0YSgpOw0KPiBAQCAtODc2LDE4ICs4OTAsNiBAQCB2b2lkIF9faW5pdCBzZXR1
cF9hcmNoKGNoYXIgKipjbWRsaW5lX3ApDQo+IMKgDQo+IMKgwqDCoMKgwqDCoMKgwqBwYXJzZV9l
YXJseV9wYXJhbSgpOw0KPiDCoA0KPiAtwqDCoMKgwqDCoMKgwqAvKg0KPiAtwqDCoMKgwqDCoMKg
wqAgKiBEbyBzb21lIG1lbW9yeSByZXNlcnZhdGlvbnMgKmJlZm9yZSogbWVtb3J5IGlzIGFkZGVk
IHRvDQo+IC3CoMKgwqDCoMKgwqDCoCAqIG1lbWJsb2NrLCBzbyBtZW1ibG9jayBhbGxvY2F0aW9u
cyB3b24ndCBvdmVyd3JpdGUgaXQuDQo+IC3CoMKgwqDCoMKgwqDCoCAqIERvIGl0IGFmdGVyIGVh
cmx5IHBhcmFtLCBzbyB3ZSBjb3VsZCBnZXQgKHVubGlrZWx5KSBwYW5pYyBmcm9tDQo+IC3CoMKg
wqDCoMKgwqDCoCAqIHNlcmlhbC4NCj4gLcKgwqDCoMKgwqDCoMKgICoNCj4gLcKgwqDCoMKgwqDC
oMKgICogQWZ0ZXIgdGhpcyBwb2ludCBldmVyeXRoaW5nIHN0aWxsIG5lZWRlZCBmcm9tIHRoZSBi
b290IGxvYWRlciBvcg0KPiAtwqDCoMKgwqDCoMKgwqAgKiBmaXJtd2FyZSBvciBrZXJuZWwgdGV4
dCBzaG91bGQgYmUgZWFybHkgcmVzZXJ2ZWQgb3IgbWFya2VkIG5vdA0KPiAtwqDCoMKgwqDCoMKg
wqAgKiBSQU0gaW4gZTgyMC4gQWxsIG90aGVyIG1lbW9yeSBpcyBmcmVlIGdhbWUuDQo+IC3CoMKg
wqDCoMKgwqDCoCAqLw0KPiAtwqDCoMKgwqDCoMKgwqBlYXJseV9yZXNlcnZlX21lbW9yeSgpOw0K
PiAtDQo+IMKgI2lmZGVmIENPTkZJR19NRU1PUllfSE9UUExVRw0KPiDCoMKgwqDCoMKgwqDCoMKg
LyoNCj4gwqDCoMKgwqDCoMKgwqDCoCAqIE1lbW9yeSB1c2VkIGJ5IHRoZSBrZXJuZWwgY2Fubm90
IGJlIGhvdC1yZW1vdmVkIGJlY2F1c2UgTGludXgNCg0K

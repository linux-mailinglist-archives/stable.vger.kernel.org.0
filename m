Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B7D4806BA
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 07:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhL1Gq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 01:46:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:4922 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232444AbhL1GqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Dec 2021 01:46:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640673985; x=1672209985;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=HYPWag1HEOAYBCMJkLIcUwTR37MxRKZxUxFIzQQ4buc=;
  b=Fbdm5sL9VHzOWM9ZfhqMSI1sqjjlwO+tVxCFQo8wLQXQuZoCDN1Zs5e1
   b556/Ipf32kq9HdoL1hliyPyQR62lwKofMHPjcGtLdpz9e5jv/IdX70b5
   pRJueFJJ+YlULRb9Y0Y5u08sdeRfFZvocAnNAT6qiiqzMWU9jaZXtZBGD
   JRd6D6ISRewSpxU4Zobk0stnRK3S03U1YGZvNSqgMNlin3jq/NWhubET8
   oN6o9Jw5J1/M6GbXqsjjwYi38sCWsGcsKLf7p6lnL4wpBRubWaA3JWwrY
   9w2CLIbfvTWnMXNGrnfnRrLKvqHdUx/trItIEebyb73C2pse+ir7MX9pZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="265551031"
X-IronPort-AV: E=Sophos;i="5.88,241,1635231600"; 
   d="scan'208";a="265551031"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 22:46:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,241,1635231600"; 
   d="scan'208";a="758616585"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 27 Dec 2021 22:46:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 27 Dec 2021 22:46:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 27 Dec 2021 22:46:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 27 Dec 2021 22:46:24 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 27 Dec 2021 22:46:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMeU8T4DbMD6SfY1L/WgbPBk+TCHtumyPlsJ07QmBfWT176gT2YB0J6Y6YaaUkVEWJB2XkX9UOQJWJFHHjSDEvjtTpPfnMhE2GMWPZWTrMC5VlQC23WuSaYHD/axh1NDIRn5NKE6wrrLirqtSyhf5dgU8tXrQwbhRMUoRNHLXQBzwMzeeTI1ROPPXrQM6ycSKQzqyeYQGDteDhgwvHxzQ22ZHuSYT1cSUe5gHd1nQuu9G3Zb7+yYe3D/5h2nXS/i8WfYG4ZT0XgloVORNSpV0cjD4kWrGd+cvY6lymlzBkcx8mNnhc5Lz/HU1gPXekwhdbfOs6lemYx9HghLGnlIrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYPWag1HEOAYBCMJkLIcUwTR37MxRKZxUxFIzQQ4buc=;
 b=nm1EIZWaPRBI4sbwd2naf86iUhj0IMIwpOG5jwhrsjb3lk9GXOIZ99OMuSTXmuIouqlALlulCfuySAikjMU2/BqEoVKz56WPjAlD7R+iS349Tn772ONRl1zbZB7Q+u34ZCpiYpFQx/2iUd0BYc3hxwejDih40GBCD5oQAyMHcRwcZnVICVHcgcSnREcKdU3Sfh+l7O5WNRu7nbsEEsdRTRdOnj9TPT17DCjDzuumGiCT1wiU8GemPMIocZ+5VB3rYQ1Ptg0iwppjMvI0IQ54kRJ43NJM4nCSxHWhw5CUBmcTZsJoEXCFyfNOEdeEqW13Xd/w1GLD8O1upCxN53Lp8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BY5PR11MB4452.namprd11.prod.outlook.com (2603:10b6:a03:1bf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Tue, 28 Dec
 2021 06:46:22 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::f0a6:e61:94db:53b3]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::f0a6:e61:94db:53b3%7]) with mapi id 15.20.4823.023; Tue, 28 Dec 2021
 06:46:22 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "andersonkw2@gmail.com" <andersonkw2@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Peer, Ilan" <ilan.peer@intel.com>
Subject: Re: iwlwifi Backport Request
Thread-Topic: iwlwifi Backport Request
Thread-Index: AQHX+4YscqUgxzHyhUSwHWiK48DAAKxHdjEA
Date:   Tue, 28 Dec 2021 06:46:22 +0000
Message-ID: <516a36e229e9d57fb9640d44ca4920446b38c6dc.camel@intel.com>
References: <CAJsSGwWz3qncvb-XkpZefJsCJ1wfCPaiHVdJ-BTFSdiFWvhmRQ@mail.gmail.com>
In-Reply-To: <CAJsSGwWz3qncvb-XkpZefJsCJ1wfCPaiHVdJ-BTFSdiFWvhmRQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0896839b-412b-483f-07bc-08d9c9cdc2ca
x-ms-traffictypediagnostic: BY5PR11MB4452:EE_
x-microsoft-antispam-prvs: <BY5PR11MB445205DC1D0708BB8AFEB6B190439@BY5PR11MB4452.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kzQjp2hTQ1OL2/28a8x1/Fi3Ni79EoFrOVVc2hxQ8ax1qfN+5nTMq/EGeGOv/RpAErN/ho0KN1NMiHzTxEVzc8yXFoQamvnsWvwb2O8DJb43/oZ3uKjcDaVF46MipY0Sc5fvd0Jz47NE/YPFPY710Xw9EsRq4EKkD68SCbZ8DUwQAdWrYj48kEdaNqoBhoENfOKiJivrK9HyP8lh9vn/NO+jhRqgaHzEUWDJ+B46h4Jx+kaKx1ynJhnZTyWXRYvyJTq69hljrsFFNLdAWVoiiPsv6B36ioTkatpGmhhdGYteK4BDnNTdua8Qv7SxthLtGZDSqe3z2EmYc0Y8RisNzfS3bNKUsdLAujyAL8q8C3eV3w+mxRipor+dUbye+XLt8eo/z1Sfl87LcloSVAlQxFNaW/6Zx8no6Uip/19c/Ym9aUC9Iqy1ZYLnDt4liBTR1uyvo3VRzsUnEx9o+FQIitsWkaoG41IxcqKRMA0hs8hu0HSgx4iSzTeOL1zfPHdS1OVYt34xArVSDze9uJYv0elNHHP2wszzyPf5NUgDy0/UITH156//O0+oq2IO9N+y9K3ZFYr5VW1dV2Tx18jmIZLEOYHuiZrvm7N16bc/UAAzj04nVkNOMyVDAv6XbClpqpGtvXgqt5Fws9YEsSWotS56hI7GjUo59ARtCMbxH07kZUrJ/QGrQZlelf4/D1+eCGW4XWaILVEhC76TzF9VmE/5/GyMfgE61kLaBn58layfKjUmsFkebCsDZ7S3GtcQ1XPPdHl9HRm9jMLGajXc6pGMhnw88NfF177PSnqdCFJZizBY7ohwxjlVLO1qdcJjMU4kQUXTy332zJNDhPxGXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(966005)(110136005)(66446008)(91956017)(26005)(316002)(36756003)(3480700007)(64756008)(2616005)(66476007)(8936002)(2906002)(76116006)(5660300002)(66556008)(6512007)(186003)(7116003)(66946007)(86362001)(6506007)(6636002)(6486002)(122000001)(38100700002)(38070700005)(82960400001)(71200400001)(8676002)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVMrejFkaWF5ZlJwM0NtSk1aRjZuUk55WTFZN2dtUzB6K3pLNEQ5NzNYbG44?=
 =?utf-8?B?UE81TDJsR2k4a0Ztc3MyZEpGV0RBeU9GQW5GRktzMUV1QjhQUWQzZzlxMzdh?=
 =?utf-8?B?S05kZm1NNGF4NEgvcVBpVVJ0bVZ1anFNWGN2L1k1NWhON24yT001RnJUVGlz?=
 =?utf-8?B?aERVQldrOEZ0cVFGcW9ZbENWZTZqYW1RMU5URzY3dzEzc3hwcFBOS0NpRXV1?=
 =?utf-8?B?V1RldTJMWnNxMkd0WStZc2Fva3lveVhEOVQwTWVVaUd0MXQrL3JnWFlBa0FF?=
 =?utf-8?B?dzVnRzV0OWxkSDh3dFkzaksrNXU3enFQUDdqZmZaVlAvRHlXVmVTdmRNR1Js?=
 =?utf-8?B?OEVVRTRBSGpxN1dWM3NqcCs1QVBpMUg0NkxaZ1BJYUFCTGVJV2FralRxSWVl?=
 =?utf-8?B?TVhqUmVBczFrQWgrc2grSW1yMjFKQ2x0UVcvdlJUR0VaQy9vb08xcFkwckdr?=
 =?utf-8?B?Ym04dm5UWGd4RFg3a3U1eUQwSWYxSFUvNTR3WENZY1dKTlRoNnJERTU4b0FY?=
 =?utf-8?B?LzltcTM5eTZnUFFhMFFWYW9FZGNSbnQ2ZXZYRkJ3Rkt6MEF0aGFIcUg0WkNz?=
 =?utf-8?B?N2FVRExEdXF2aXJYd0RmYUFuQjNJSjNFdlU4MU9XcUJTNVoreVNwcWhMSWoy?=
 =?utf-8?B?VTAxaGtrR1VQQXFFaVRIczNhT2V2L3h4bXU3Q0pjMmlldjIrdTdaS0dPSHRy?=
 =?utf-8?B?MmpUV2dMelp2aHZ6bDdaWFI1cnM4YURrdmJsakJIQzVFMzdsVldQT2hOQzNX?=
 =?utf-8?B?bGNTcWphaXhXbEk2a1lISXhpVHNOL0FwRkdkSGpXY21vb1BnR243dmFVaENE?=
 =?utf-8?B?WlFDajdvdlRXZHhMYU9vL2kxaDlVN1grczBtMEhFTmV4enk4OUlBZFB3VXBB?=
 =?utf-8?B?dGFpZkFvdjgxWVdCZTcyaEpVYURsTDFZRUF3QzNwZzJSbEJ1dXhuMkUxS2c0?=
 =?utf-8?B?bGo1UFZqZEpyOUFsL1hib3BqMDBMTmRHZEcwYmovelhRaEFHK3NNUW1HNEtj?=
 =?utf-8?B?ZnF0c0l4Rk9VcWtwMWk4cVVYbmc2SkhnRVNIdk9XdmRmNEx5bDFFS0xOK2tH?=
 =?utf-8?B?cW9oUHUvS2tYMkVLVEVUMDQ5NUNuNHVTamFRS3ZMdkQ4c0VKR1hFT1BzeHFv?=
 =?utf-8?B?OFRTTmZDUCtCbkczVUtKZGEyckhMckJjRU9BcXptd3VnSHUvVzlWVDdCU1FS?=
 =?utf-8?B?OVhiMStQWjlyb2wrMitvUjhUOUJHVitiRkQ3bjl0dmI3cmI5VkVranl0VE9t?=
 =?utf-8?B?cHZkMnNHMjFsZjR3bmpEQUgveTdNcG5DcDJWYXRpSk5sS0E5ekNocmlQVGtW?=
 =?utf-8?B?N0Y1RHR2Y1lPU1g1UmFDMHM4VkNxaVlMVjEzY0NwQ3hoRS9JRVBFZllCZ0V6?=
 =?utf-8?B?TGFuK0NpSzE2YnBJTGVYYTdIdzhzUUE2alVGdGdOZE5OLy9rV3VubmVwWGVV?=
 =?utf-8?B?Z1lPU0lpQlhjSllSb2dMbzhVU2gvUlFibmh3dUhKcGhEM1FwaUdHQjZDakEv?=
 =?utf-8?B?OUNBRWw1UDlzdWp2TERTQmFldmlZTW1QYmpwNGRvQkx6b1FkWWtHUk9iVnlv?=
 =?utf-8?B?NEJGMnh3czFSUTNQOFJYN2dhcFY2V0Zad3ZZSnUyNUw2MjIrdElYK1VIaE82?=
 =?utf-8?B?TW5CclZFYmlNTGV0cjJpc04zZE1lc3dLak1hdXRqeUwzS1I3dXlkR0JoRFNw?=
 =?utf-8?B?T3RPekIwOEVhQklwSVZ2UHJ2cFFFVmk4NFc3Z09OaEh5SGVjQkdUM0hYcjNG?=
 =?utf-8?B?Sko4QnkyVnA0azRiTm5mSmtHanVMSEZIZTFIZGNLTVZ6N1BaMW9kQUJqQUZI?=
 =?utf-8?B?bGQwbDFQUDRoWnpvTmxuRFdGbFpIZ0dEZCsxbzJMT3VSTno3bnlRbGIySFdJ?=
 =?utf-8?B?RGFZYU9QdUl6Si9rcWpJSG02VVNoRFpNQkxITDY1VjRzK2tLc0xBdi9wZ0g5?=
 =?utf-8?B?SXNhbkl4RGhkd3ppUEN3UC9odVF5QXFidlFjZUxINEJGOHRzcUZ5bkdLVExr?=
 =?utf-8?B?bkhJWVpOdHpkS0owV3B0Y3JKNm5mdCthYXJpd240U2QxbzM0ZzhudEo4eGVQ?=
 =?utf-8?B?OUMrZDkwN3NKVm1aUXh4T2pjTTlMVUVKeEp2R25CNlVxbWdPSGc1cGFkdDhR?=
 =?utf-8?B?VFY0QVJJc1VYdzJ0QkREMUZiSVlScmprOW9rNkZKQW41LzYxdW1MTEtHUE5R?=
 =?utf-8?B?UHhKejNlM1FmRHA0azV6aXc1WVVrUzZ2aTNsaVJjeU5pYXdVZGtFSXlrUTBl?=
 =?utf-8?Q?8jBNdy07jh7ZdvtX4h0gZ5yG0LJyMkPdsyQnoexKG4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F4EBC687ADA104C9B9686AB8D493767@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0896839b-412b-483f-07bc-08d9c9cdc2ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2021 06:46:22.2135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6lDF54ud0C6r82A/dN/Fyw2j4QVJyrWhLY8jo4QW3INqO6L8hKSJzPrScHrXsMjyihnzUQuRTv+quM7UI2axelcxm5CWUI80zGkcWBGAzac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4452
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIxLTEyLTI3IGF0IDE5OjU5IC0wNTAwLCBLZXZpbiBBbmRlcnNvbiB3cm90ZToN
Cj4gSGVsbG8sDQoNCkhpIEtldmluLA0KDQoNCj4gSSB3YW50ZWQgdG8gc2VlIGlmIEkgY291bGQg
aGF2ZSB0d28gcGF0Y2hlcyBiYWNrcG9ydGVkIHRvIDUuMTUgc3RhYmxlDQo+IHRoYXQgY29uY2Vy
biBJbnRlbCBpd2x3aWZpIEFYMlhYIHN0YWJpbGl0eS4NCj4gDQo+IFRoZSBwYXRjaGVzIGFyZSBh
dHRhY2hlZCB0byB0aGUga2VybmVsIGJ1Z3ppbGxhIHRoYXQgY2FuIGJlIGZvdW5kDQo+IGhlcmU6
IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE0NTQ5LiBJJ3Zl
IGFsc28NCj4gYXR0YWNoZWQgdGhlbSB0byB0aGlzIGVtYWlsLg0KPiANCj4gVGhlIHBhdGNoZXMg
Zml4IGFuIGlzc3VlIHdpdGggdGhlIEludGVsIEFYMjEwIHRoYXQgSSBoYXZlIHdoZXJlIGl0IGNh
bg0KPiBjYXVzZSBhIGZpcm13YXJlIHJlc2V0IHdoZW4gdGhlIGRldmljZSBpcyB1bmRlciBsb2Fk
IGNhdXNpbmcNCj4gcGVyZm9ybWFuY2UgdG8gZHJvcCB0byBhcm91bmQgfjUwMEtiL3MgdGlsbCB0
aGUgaW50ZXJmYWNlIGlzDQo+IHJlc3RhcnRlZC4gVGhpcyByZXNldCBpcyBlYXN5IHRvIHJlcHJv
ZHVjZSBkdXJpbmcgbm9ybWFsIHVzZSBzdWNoIGFzDQo+IHN0cmVhbWluZyB2aWRlb3MgYW5kIGlz
IHByb2JsZW1hdGljIGZvciBkZXZpY2VzIHN1Y2ggYXMgbGFwdG9wcyB0aGF0DQo+IHByaW1hcmls
eSB1c2Ugd2lmaSBmb3IgY29ubmVjdGl2aXR5Lg0KPiANCj4gVGhlIG1hYzgwMjExIGNoYW5nZSBp
cyBjdXJyZW50bHkgaW4gdGhlIDUuMTYgUkMgYW5kIHRoZSBzY2FuIHRpbWVvdXQNCj4gaXMgaW4g
bmV0ZGV2LW5leHQgYW5kIGlzIHN1cHBvc2VkIHRvIGJlIHNjaGVkdWxlZCBmb3IgNS4xNyBmcm9t
IHdoYXQgSQ0KPiBjYW4gdGVsbC4NCj4gDQo+IEkgYmVsaWV2ZSB0aGF0IHRoZSBwYXRjaGVzIG1l
ZXQgdGhlIHJlcXVpcmVtZW50cyBvZiB0aGUgLXN0YWJsZSB0cmVlDQo+IGFzIGl0IG1ha2VzIHRo
ZSBhZGFwdGVyIGZvciBtYW55IHVzZXJzIGluY2x1ZGluZyBteXNlbGYgZGlmZmljdWx0IHRvDQo+
IHVzZSByZWxpYWJseS4NCj4gDQo+IElmIHRoaXMgaXMgdGhlIGluY29ycmVjdCB2ZW51ZSBmb3Ig
dGhpcyBwbGVhc2UgbGV0IG1lIGtub3cuDQoNCllvdSBjYW4gc2VuZCB0aGUgcGF0Y2hlcyBkaXJl
Y3RseSB5b3Vyc2VsZiwgYnV0IG5vdCBhcyBhdHRhY2htZW50cyBhbmQNCndpdGggd2l0aCB0aGUg
Zm9sbG93aW5nIHRhZyBhZGRlZDoNCg0KY29tbWl0IDxTSEExIG9mIHRoZSBjb21taXQgaW4gTGlu
dXMnIHRyZWU+IHVwc3RyZWFtLg0KDQpZb3UgY2FuIGZpbmQgbW9yZSBpbmZvIG9uIGhvdyB0byBk
byBpdCBoZXJlOg0KDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9Eb2N1bWVudGF0aW9uL3Byb2Nlc3Mvc3RhYmxl
LWtlcm5lbC1ydWxlcy5yc3QNCg0KDQpUaGFua3MgZm9yIHlvdXIgaGVscCENCg0KLS0NCkNoZWVy
cywNCkx1Y2EuDQo=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32B92E7F5F
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 11:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgLaKX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 05:23:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:22374 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgLaKX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 05:23:56 -0500
IronPort-SDR: qr3kCos+VlG+gSr5CpmMCkgK1Yz1IU99B0D7kwBJQu35N6io86TqEVUhhjPejpKUKCmgl6Yf1L
 CHN2nbClAVpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9850"; a="195201788"
X-IronPort-AV: E=Sophos;i="5.78,463,1599548400"; 
   d="scan'208";a="195201788"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2020 02:23:16 -0800
IronPort-SDR: kM0y9rWrUeMPi/ePDV7E6gu2KBeCOdD3zP+wQOVagh6vkk24S9SzTqpM0W3p2FC+4jREG30in/
 RcWNAbTX/frA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,463,1599548400"; 
   d="scan'208";a="565683592"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 31 Dec 2020 02:23:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 31 Dec 2020 02:23:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 31 Dec 2020 02:23:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 31 Dec 2020 02:23:15 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.56) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 31 Dec 2020 02:23:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ4pzZ8tT+7FHayviapiJrdlMtQL7RWI/WGcH4dcgk8h2ohcBA4pOx4qIKl6uUrN96JcgJ29q8JbWiw/33ts28Kn0k8qGcfqaZm54m4KIEemvDUV2ijCe4jZS2da51PRpFEgWKkzdYlh6XwHMiTDYMpJuo08MNQQUSyMm7I8fXFMz21yAuDGy7wssFkZhK1RIX94k1zVD1LWJz/JXE9JdMxGRade70vfJoN+V0Ea+YJ1Z1P/oYjvHvbmQuW49cRPw5KJTO567EY4p0qbDVf+D+hwP6SH8ZIOcpp6Ei+XHS1x/krlfzW7+/mAvh3GU62CzSVxpt2nrdBMM/onf5H6iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OA6Bn5r5XtMD0A9I+8DXsvt7xKVI3D92Kf+zp9PIQI=;
 b=IFK8MY8mPFfohfQouHdsF7d5T4zyVuOHI41qrXl2kzaefCH31NOT10XrwOxvd+IQdryhoyxN34pJoVy5pY9X6PUaEqFZxr2vwLHkUqEpWI7yG7Raqi2Ff/SBR1+S7vtZUjPTXp7EUvPQ2lRbdreYZiOJEsqGA4jt9ptP6JRfCtZofXRlXz5pQvhVitkxVx4MAqLbttMcHymhrbjZSltb1hmXkXQ6+ibLgSQUIuSANkRuBbOZYOeb3tv0+rNO0z30Mz2r+Vk9g6S27w4RQ5+cYWBkXLOdJkKKJ76DkU5Q0Lymb65kwpNIt/KoKIXClOcwHvCZm7KEIjObVrTPoy/ATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OA6Bn5r5XtMD0A9I+8DXsvt7xKVI3D92Kf+zp9PIQI=;
 b=KRkX0WxrsJYibrZhttZOX7/aaxfukpW3FfiriwIwHq4NW1OTBXBNhVLzcEunyV2WOwuG0Ml1YGt00j3QZce9fRqtT4dYCnnj7jMC93nIDSnCVViN6SFZCzPS00mWYS2DErb5xvWYy+SSY00ny8X/L20rd15+k1jo/lzZsRTvRrY=
Received: from CO1PR11MB4833.namprd11.prod.outlook.com (2603:10b6:303:99::13)
 by MWHPR11MB1472.namprd11.prod.outlook.com (2603:10b6:301:d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Thu, 31 Dec
 2020 10:23:14 +0000
Received: from CO1PR11MB4833.namprd11.prod.outlook.com
 ([fe80::1cff:5474:441d:5dcf]) by CO1PR11MB4833.namprd11.prod.outlook.com
 ([fe80::1cff:5474:441d:5dcf%6]) with mapi id 15.20.3721.019; Thu, 31 Dec 2020
 10:23:14 +0000
From:   "Blum Shem-Tov, Ilil" <ilil.blum.shem-tov@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: patch "crypto: asym_tpm: correct zero out potential secrets"
 added to char-misc-linus
Thread-Topic: patch "crypto: asym_tpm: correct zero out potential secrets"
 added to char-misc-linus
Thread-Index: AQHW31oJqCZPp9plxEKDjrj++g2OM6oQ/eLQ
Date:   Thu, 31 Dec 2020 10:23:13 +0000
Message-ID: <CO1PR11MB48336B26B1222FD4C9FB0E788AD60@CO1PR11MB4833.namprd11.prod.outlook.com>
References: <1609408159201240@kroah.com>
In-Reply-To: <1609408159201240@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [85.64.89.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6c05bfb-fe4c-4378-9772-08d8ad7614e0
x-ms-traffictypediagnostic: MWHPR11MB1472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB147285078A998269E57201348AD60@MWHPR11MB1472.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yqwlTA8OfYzgzmiq0IWOTxPF6/JNQ/MkVvrYQiJe10CLgk7FBC/go2RLcw3TiBaayejTda2lbx9LS6PJ3IgEbqTTe07QaQA2BE0lyKSTSsx8L1x0SRSrIPYYtIYCS01hoMGcNKyu6PaVa4gacf+3lydrnpB2vbcz4gxd1EmMauWEra0fbSF7nTKs0F3s4dwqy7O55HcY1a6afVSKaWc5FDibRP+js4Py6m75loWNuBRF8iqGDIXI4YI60PVxRRu4CpuJDaKcrdo7zCUeMORVopF4M7zAlyaXYg4SXWR2YgAk0jGn1yY0pDwedcy0KxoQg4i0Cl/vPVrKC/O/NUOBRSUZJXoeM6z8CbR7GmHuSWQ+CVSIJ6F36fYHhPWAbPAZy4oquoVkgaVscULeVacGtEqvti5nLaI89X6EaU0lG/4KhEA2yJiBrfGNklyFA5Xo4lDHATuvc+V9MDylbyduSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4833.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(186003)(71200400001)(26005)(76116006)(2906002)(66446008)(7696005)(966005)(66946007)(53546011)(6506007)(8676002)(33656002)(66476007)(66556008)(478600001)(64756008)(8936002)(55016002)(86362001)(83380400001)(5660300002)(9686003)(52536014)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dmtIWnRxbS9xdTNTTTBnVmQwNnpOY2lEVS9Sa2pUS2g2M3hWbGNETzdweGVn?=
 =?utf-8?B?ZFQ3aHhMUVk4bEVmN3I3V2pTbzlVSVdzV3lHZEphYzNrRytla2R5NVM4V2Yz?=
 =?utf-8?B?Ry9oeXEzL2VUK3BjVGQ0akZ5ZHNnRUZTY2RWT3A3bUNZcmhucWMwRGpOYmNp?=
 =?utf-8?B?MCtwRWhNNjUzcUpaaFFsdmRsaU1GcThadVl6YlpqUGFneDQvZnZpT1ptOFMr?=
 =?utf-8?B?blRuU3FuVXNYZVpkL0R5c1Y2QWl1SWVRTGU5RHB3M1A5aUxZKzJNcHRZUzNB?=
 =?utf-8?B?cE51ZEhPeXFxcHdqL2VweWl4N1Fqb3I3alZrZHRrUmhGamxsVkN5QlZ3RmZw?=
 =?utf-8?B?dWJKZ2U1ZlVLcVVwTCsxUjJqQ3dkYnpDUy8yajNMSzlhTVYzQ29RRVh5bGhM?=
 =?utf-8?B?R0hQOHZzcnZMMmpVMHl2U2U1dWZuV1AyTU5hajdRL2hzeU9uTDNVRE9MSkhr?=
 =?utf-8?B?YTR3aVU2NXNUMHBFN1RIZnNZNFRNUlpkb05YSU9qMDM0VjVqMXpuUTJCM1d0?=
 =?utf-8?B?bDd4ME9FMlBPR1VENEtZYTNtOG5SdG5pcFk1VWkzNmE5UjU1VkFITnNXbnZD?=
 =?utf-8?B?YlhOT1RCSzdyVURnYi9EMUV1MnRkbGZwTUd1Ym82enBoSitTVnoxeVNsLzI4?=
 =?utf-8?B?eWo5VlcrRkdGVyt0blNVWWIyUXJaZHplN3Q4aGJMa3N5RzU0b0hXYnZxYUNa?=
 =?utf-8?B?a3dtTjV6STRtVkdGbGwwKzVwcFo5NmZHY2JVSGI5TGx4dy9mcUk5L281RUN3?=
 =?utf-8?B?dFduSngvcVFHbmI3OEdENUQ4YzE0RTY5Z0lwZEtHVmIvY1N0VTlSRnp4aVg3?=
 =?utf-8?B?SGpPVHJ5VUFNNXFoSEFEOU44M1NPZ1hBRDBjM2JucXdFdmk5MUdZUTlXRDQx?=
 =?utf-8?B?TW5xSC9nMDZTQkNnYVlLOTNyalVpeXVKVEQxRVdGS0lScDNqNGtzWlQ3cFZl?=
 =?utf-8?B?ZnQ5WUFaVXN6cmg5elFrMkF5TEg3NUQ2a0xQY0ZyZGEwYmNCOTYrNFdwQS9j?=
 =?utf-8?B?am51QzVTUHVSTHJyeGQ3Z1MrMHBzT0c5L045aVdIMWk3d3Rna0FtYUtyNElP?=
 =?utf-8?B?bElIZGh0ODFmZTIzQUpaeXp2SXhjQmRLR1dldy9HdWNvazR0NGErdnJZRDlI?=
 =?utf-8?B?Mi9tOHdnRis1QjNSZnNnWlRPVWZ6bDRSeHlFSStoTWtPUmI2VHdDU0RweHFv?=
 =?utf-8?B?L1ViMnY0ZWJtQXpHZlcrTVROY1FWRm9jWlhtVU5iZWxKMmNmb3FDaGMzM1Bs?=
 =?utf-8?B?OWppSjl5VXZDOFVYTnB5S3RIQUdMekovMVBOTEhMLzBmRldLSUNBMXl0aTJ6?=
 =?utf-8?Q?O84SEjx4mKgZo=3D?=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4833.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c05bfb-fe4c-4378-9772-08d8ad7614e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2020 10:23:13.9948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WtcyJTztRUIXDV+Vj132VHpDhHsQynElujhomtnMKfqfkDIlYg63z1b+BgAXjm46Fr+cRrNxneZOe/FWf9KFGtc2WfACrqmxP5ghF7/Dpek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1472
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhhbmsgeW91IGFuZCBIYXBweSBOZXctWWVhciENCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCkZyb206IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIDxncmVna2hAbGludXhmb3VuZGF0
aW9uLm9yZz4gDQpTZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgMzEsIDIwMjAgMTE6NDkNClRvOiBn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsgQmx1bSBTaGVtLVRvdiwgSWxpbCA8aWxpbC5ibHVt
LnNoZW0tdG92QGludGVsLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IHBh
dGNoICJjcnlwdG86IGFzeW1fdHBtOiBjb3JyZWN0IHplcm8gb3V0IHBvdGVudGlhbCBzZWNyZXRz
IiBhZGRlZCB0byBjaGFyLW1pc2MtbGludXMNCg0KDQpUaGlzIGlzIGEgbm90ZSB0byBsZXQgeW91
IGtub3cgdGhhdCBJJ3ZlIGp1c3QgYWRkZWQgdGhlIHBhdGNoIHRpdGxlZA0KDQogICAgY3J5cHRv
OiBhc3ltX3RwbTogY29ycmVjdCB6ZXJvIG91dCBwb3RlbnRpYWwgc2VjcmV0cw0KDQp0byBteSBj
aGFyLW1pc2MgZ2l0IHRyZWUgd2hpY2ggY2FuIGJlIGZvdW5kIGF0DQogICAgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC9jaGFyLW1pc2MuZ2l0DQpp
biB0aGUgY2hhci1taXNjLWxpbnVzIGJyYW5jaC4NCg0KVGhlIHBhdGNoIHdpbGwgc2hvdyB1cCBp
biB0aGUgbmV4dCByZWxlYXNlIG9mIHRoZSBsaW51eC1uZXh0IHRyZWUgKHVzdWFsbHkgc29tZXRp
bWUgd2l0aGluIHRoZSBuZXh0IDI0IGhvdXJzIGR1cmluZyB0aGUgd2Vlay4pDQoNClRoZSBwYXRj
aCB3aWxsIGhvcGVmdWxseSBhbHNvIGJlIG1lcmdlZCBpbiBMaW51cydzIHRyZWUgZm9yIHRoZSBu
ZXh0IC1yYyBrZXJuZWwgcmVsZWFzZS4NCg0KSWYgeW91IGhhdmUgYW55IHF1ZXN0aW9ucyBhYm91
dCB0aGlzIHByb2Nlc3MsIHBsZWFzZSBsZXQgbWUga25vdy4NCg0KDQpGcm9tIGY5MzI3NGVmMGZl
OTcyYzEyMGM5NmIzMjA3ZjhmY2UzNzYyMzFhNjAgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxDQpG
cm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KRGF0
ZTogRnJpLCA0IERlYyAyMDIwIDA5OjAxOjM2ICswMTAwDQpTdWJqZWN0OiBjcnlwdG86IGFzeW1f
dHBtOiBjb3JyZWN0IHplcm8gb3V0IHBvdGVudGlhbCBzZWNyZXRzDQoNClRoZSBmdW5jdGlvbiBk
ZXJpdmVfcHViX2tleSgpIHNob3VsZCBiZSBjYWxsaW5nIG1lbXplcm9fZXhwbGljaXQoKSBpbnN0
ZWFkIG9mIG1lbXNldCgpIGluIGNhc2UgdGhlIGNvbXBsaWVyIGRlY2lkZXMgdG8gb3B0aW1pemUg
YXdheSB0aGUgY2FsbCB0byBtZW1zZXQoKSBiZWNhdXNlIGl0ICJrbm93cyIgbm8gb25lIGlzIGdv
aW5nIHRvIHRvdWNoIHRoZSBtZW1vcnkgYW55bW9yZS4NCg0KQ2M6IHN0YWJsZSA8c3RhYmxlQHZn
ZXIua2VybmVsLm9yZz4NClJlcG9ydGVkLWJ5OiBJbGlsIEJsdW0gU2hlbS1Ub3YgPGlsaWwuYmx1
bS5zaGVtLXRvdkBpbnRlbC5jb20+DQpUZXN0ZWQtYnk6IElsaWwgQmx1bSBTaGVtLVRvdiA8aWxp
bC5ibHVtLnNoZW0tdG92QGludGVsLmNvbT4NClNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFy
dG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQpMaW5rOiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9yL1g4bnM0QWZ3akt1ZHB5ZmVAa3JvYWguY29tDQpTaWduZWQtb2ZmLWJ5OiBHcmVn
IEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KLS0tDQogY3J5cHRv
L2FzeW1tZXRyaWNfa2V5cy9hc3ltX3RwbS5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvY3J5cHRvL2FzeW1tZXRy
aWNfa2V5cy9hc3ltX3RwbS5jIGIvY3J5cHRvL2FzeW1tZXRyaWNfa2V5cy9hc3ltX3RwbS5jDQpp
bmRleCA1MTE5MzJhYTk0YTYuLjA5NTk2MTM1NjBiOSAxMDA2NDQNCi0tLSBhL2NyeXB0by9hc3lt
bWV0cmljX2tleXMvYXN5bV90cG0uYw0KKysrIGIvY3J5cHRvL2FzeW1tZXRyaWNfa2V5cy9hc3lt
X3RwbS5jDQpAQCAtMzU0LDcgKzM1NCw3IEBAIHN0YXRpYyB1aW50MzJfdCBkZXJpdmVfcHViX2tl
eShjb25zdCB2b2lkICpwdWJfa2V5LCB1aW50MzJfdCBsZW4sIHVpbnQ4X3QgKmJ1ZikNCiAJbWVt
Y3B5KGN1ciwgZSwgc2l6ZW9mKGUpKTsNCiAJY3VyICs9IHNpemVvZihlKTsNCiAJLyogWmVybyBw
YXJhbWV0ZXJzIHRvIHNhdGlzZnkgc2V0X3B1Yl9rZXkgQUJJLiAqLw0KLQltZW1zZXQoY3VyLCAw
LCBTRVRLRVlfUEFSQU1TX1NJWkUpOw0KKwltZW16ZXJvX2V4cGxpY2l0KGN1ciwgU0VUS0VZX1BB
UkFNU19TSVpFKTsNCiANCiAJcmV0dXJuIGN1ciAtIGJ1ZjsNCiB9DQotLQ0KMi4zMC4wDQoNCg0K
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCkludGVsIElzcmFlbCAoNzQpIExpbWl0ZWQKClRoaXMgZS1tYWlsIGFuZCBh
bnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4gY29uZmlkZW50aWFsIG1hdGVyaWFsIGZvcgp0aGUg
c29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0
cmlidXRpb24KYnkgb3RoZXJzIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuIElmIHlvdSBhcmUgbm90
IHRoZSBpbnRlbmRlZApyZWNpcGllbnQsIHBsZWFzZSBjb250YWN0IHRoZSBzZW5kZXIgYW5kIGRl
bGV0ZSBhbGwgY29waWVzLgo=


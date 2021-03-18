Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08034102B
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 23:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhCRWF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 18:05:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:11408 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhCRWE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 18:04:58 -0400
IronPort-SDR: DlD9gFvh+HRm3msZVp/npTfCGjs93cD0kd0dlX1z97N3aXn9XEkHZf6qO5TmorPfbVp1RLSlsh
 UwcYSp5VNUaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189872376"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="189872376"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 15:04:57 -0700
IronPort-SDR: 8ML5AMPHVtzdNO/Hrmw9B6giDd9P0X5WXWGP6aDEyRQgCS6iKjEK6d4CIoW6ftA1rVovpd4PFs
 OZrOE44zLNcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="412070077"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 18 Mar 2021 15:04:57 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 15:04:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Mar 2021 15:04:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Mar 2021 15:04:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nArPHMpgsvxPt31VkohlPHEVIsZSSxPdJs9KLfzMgtfka3bSsNntN9mdFafFG5I1gtSIbZi8nYKwPd3pdW+IBnJHBP9s/eWcTZoartbUPUO0qmpO58IbjZ5rVa1RT2/+jlqa/JgHT+vyDplUmxFX56YfwietGBBBLf011V3PrcB8dgWBQmALObGEFngkqCgYYQ6W2GH29daUY22/dgCMPjrY8B8PlVpsFTz3x3zpAIhXwWW31pepsVfKQ2hn9QNsxGxCaxKTEjgPf4IOvo20G7FRjGBd+OCRh/CdNRhuOoUmfanfUytltFx9OUShTG3fKeXBvhHW/infeKNhPt2E0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv7Tg2M/5yZ2Tewxl5duGpeHLyRpWKyK5StD359yWuM=;
 b=gB2/5dVldx0quTbNVSdUt7QY5w2auTc83jAVbo8OlHy7Gknug3d7fBM1JIe7fbenNCQackj/4r4rSoKiv1KOn9TLc+gJiARXHiqjwXZIVPokerAsbkwABpRCXEZ4r9o+fkcQTA1o0MNypsUzwip2x+gxSE9fcBQKMWIm4LmSm1ZWN55vgn0+lITgOLeUveBD0F8rGIW2u8jtcom1Iy2YjbhvTYdzzCmguNd/Y6/Ae1hgNnpUrm7c1dDvm+rx1C40NlNz8n40VGUxU28DV91vAZ7PaHHZYKyB5BdA/+J8XMuBVv49Z29xoRLSCcx5Gxw4V+CZr/laBcRtpAX+Np/aYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv7Tg2M/5yZ2Tewxl5duGpeHLyRpWKyK5StD359yWuM=;
 b=n8BvzlFNqGB6syU4LvrT96l36W7FfJ3Y5Hiagjs7L7L7gPoCFCaMJtDUAPLbr2FrIhu4UDV+FYLXN34Xmxb0droq1a6O+FPeIvobu4CGYZcEzy8JH38bfNOveUa6a7iIPPGxQlOzfM4NZjJccyXTbkXRz/Vq2DbwrVQNoYUM8vY=
Received: from MW3PR11MB4620.namprd11.prod.outlook.com (2603:10b6:303:54::14)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 18 Mar
 2021 22:04:54 +0000
Received: from MW3PR11MB4620.namprd11.prod.outlook.com
 ([fe80::892b:fb80:1a4:796f]) by MW3PR11MB4620.namprd11.prod.outlook.com
 ([fe80::892b:fb80:1a4:796f%5]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 22:04:54 +0000
From:   "Almahallawy, Khaled" <khaled.almahallawy@intel.com>
To:     "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "Deak, Imre" <imre.deak@intel.com>
CC:     "lyude@redhat.com" <lyude@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mail@bodograumann.de" <mail@bodograumann.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "santiago.zarate@suse.com" <santiago.zarate@suse.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: Re: [PATCH v2 1/3] drm/i915/ilk-glk: Fix link training on links with
 LTTPRs
Thread-Topic: [PATCH v2 1/3] drm/i915/ilk-glk: Fix link training on links with
 LTTPRs
Thread-Index: AQHXHB8LerGz6u5fyk+pz7GNts4rLaqKCquAgABCjAA=
Date:   Thu, 18 Mar 2021 22:04:54 +0000
Message-ID: <e1e9f9ea76071af914b37352fc201d09f378a55b.camel@intel.com>
References: <20210317184901.4029798-1-imre.deak@intel.com>
         <20210317184901.4029798-2-imre.deak@intel.com> <YFOO4FOmOB8yp3me@intel.com>
         <20210318174907.GE4128033@ideak-desk.fi.intel.com>
         <20210318180645.GG4128033@ideak-desk.fi.intel.com>
In-Reply-To: <20210318180645.GG4128033@ideak-desk.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4-0ubuntu1 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 974fafbc-5155-46cb-5035-08d8ea59dc54
x-ms-traffictypediagnostic: MW3PR11MB4763:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4763CC0E1538DB305BCA9E6889699@MW3PR11MB4763.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +wp7lmJyG3Xr8qwEBrNKUp9pPpC4QahpHAQrYID+bX51ZeFPSzrAGHoeewEh6+Lhou0tCLfLAugf5tAQ7jZ2AiLw4S9epjs0YbhW9n+N7VlfrPDUGaX56BiOXqOvCCDZNf5JRXNwH2GlGiU/wZcSbibRpl2+l71UMnmxWIiDYVqmzGNHHSbk1gC8vbgmVMyHXtZ2F27dVj4n3ip9V0aJCWOsPk4h0nojjDSKImLU/NDnAypOYYIeAB1DaT91SvQoQxL6POYYLD2QDQf4ztly4121yZF2Hu0eYbhehpzet/Dm8th7lu6oRySvmEySPkUVOUi4WZyFZSCY5UeNVf7jt/VYqpc+q4K/un7vdduDO3IFf2LmmVXkW4JXhf+t+OpcxH3EOZD6MgXMgoYNPrZP8ny7L+L83miDjkpeOn0mhqkhrXHDSQGLRnCZQTcdgXPYe7uGbOUU2mXPilCm4wX2PI0lnhBPxjLtmhbwN/9DAJHgJr4jraHfHaivVQ9QwuXbtvxprVGH01zCQmCQUBc6e5Y7txeUubmm6JhvQhNN3+o1bHMYeoIpgt1wPiqCfuCAqjyWfPhDrCyqYFOGak3uNklohIGWgzSrt66E9baFcC6mUz+S64ETAq6oT8g4sdOo97TurVfBwfKiDNbaU9cE3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4620.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(346002)(136003)(8676002)(36756003)(66446008)(71200400001)(76116006)(186003)(66476007)(54906003)(478600001)(8936002)(26005)(6506007)(38100700001)(66556008)(966005)(86362001)(6512007)(91956017)(4326008)(64756008)(66574015)(316002)(110136005)(2616005)(83380400001)(2906002)(5660300002)(66946007)(6636002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M2ppWUVJenBsMFVFNk4wUmxBYStxaiszRktHYytyN1ZLeElUdU1ac29hL1Bj?=
 =?utf-8?B?Q3B0UUJ3UlhsbExFcGhMTVVHZmhjNTFRWnBabUtnOWptdmpnT29CNXhxRnZj?=
 =?utf-8?B?TmpqVjlsSS95b0V5cTZ2QTJNcnBDRzZDQ1pKdlhrUkg0VlZCNW9CWHk4SDNR?=
 =?utf-8?B?Nmg2MFdCT1Bmd3VxS3JqS01ZUWMzQWk3TWJjOUVuSmZGTkNvbDZiUm1uRmNX?=
 =?utf-8?B?VWVSci9hTGg2L2NHRDVkQ1VBNHdaSm14V1hmMDFLdmcrMGpRU2dQMFZnczhD?=
 =?utf-8?B?dGpXMlE0TDFncTB2V3pzTDJWNW4wYWtLd1krRE9iSC85aFNlN1RzSHVIcHhH?=
 =?utf-8?B?bHcrMTZvYUtTNjhBRkVZcjhtZFVIZXg4VmZpLzNxVVpsbGZnSXIyaTlnbEJv?=
 =?utf-8?B?LzlrdUIvWS9EVmwvK1c3MjRwMG5rMnlYMVgzTVd0SFN5Y09IWmFaOSt0TVcv?=
 =?utf-8?B?U0h3bi9MQ1JlTXI3Rnc5TWxkYUJjT2hqbGpJTW1zWWRoc2xhMTZNenZpa1NO?=
 =?utf-8?B?UDVFRlppbEV3RTNEdktDMU9KR0MvbENzSzJzRVFBeFh3T1hHQnE0NXhLVDNN?=
 =?utf-8?B?UWh1bEVpTDNVZ2Z5UWFsMUxjOHZoWGxFNzVxWnhYM015dXBzMzA1Q3RKcGlh?=
 =?utf-8?B?WUlHZXFkUlZ2Yk9sd1ZYOUdsTlQvdEVVYXdjaW82aElrMk1lNHBQSGlxcm5C?=
 =?utf-8?B?aVJad3gySW1WSHZNVERyNHRhQnpYMHhMVSt0TzlKbDNmeWgrelp1MkJmTUI4?=
 =?utf-8?B?YmlZc0NQZlBkbkhjSHhoV3pzcGMxRHRSYUdFMmdsWG0xblBURzR5cXZFbERh?=
 =?utf-8?B?bUFCL0J1N05XQnZjNUkwWlFYYXVKKzBwZ0g0WHllZVdSckpEdDBhcXpxNkJD?=
 =?utf-8?B?akRGbU9DcWRaa21tTzljbjh5Ni83eXNtblFmVmNEZTFoamFEMGY3ZGNFaXkw?=
 =?utf-8?B?M25VTDNNWDlpTXZHQUdyMlcxOVZZUXk2bHZNZGhmeHl4WG13aW5FVTRlR21x?=
 =?utf-8?B?S2x5cHRUUitmNDQxVXZsRmRuL2hFSGl5UWlZY01uUHNPeEtSQnV1TEdPaUFx?=
 =?utf-8?B?NVVzSFNXOEVNcUh6NzFXSmhlYnJtNUxvVDNjSTlrbTVJYTIwelM3SnVqclh3?=
 =?utf-8?B?VTlhL3pydi9oN1RvQWYrNmJkK0JmZ3M3WUxkZXNoWWZ5OEJPTU5FOFp5dVdu?=
 =?utf-8?B?QThkSWI1a0d3NVdhZW1MLzNKRVpqaE0rN0NGT1dMRFdlYnRZN1p1RlBzMEVI?=
 =?utf-8?B?RGdNMzU1ck0xeTF6MVVveGtVOUNHaVZFV0d3MUhzTWx5dldheTVNVE56c0Fq?=
 =?utf-8?B?V3VBVzNDTW4zMkJLVWUzWEh3L0tuUEdadkd1OXNaN2J1cWFFcENwbm5iZ2pv?=
 =?utf-8?B?dDdJKzh1Ui9QUVpleDNCL1JoVm1DRlNvM3dBYTVzc0FyR0tXQnJsaXVQUEx3?=
 =?utf-8?B?M3ROVEhZV3Q4SEhveDZIU201Y1RLanRIWFI0ZVNuZXEraGJCT2Q0Ymh3blZo?=
 =?utf-8?B?ZnU0MG9WOUlOUGRKaC9PaXpBQmR3cUNVck5YdnhFZm5NSDgzVi9JU0J0ZFAx?=
 =?utf-8?B?TDhjTzdQMDZYQXIzMlpxQlI2dEFXSWFsMTRxQnBDSEF3b2lmU2RVb0tCUFZJ?=
 =?utf-8?B?SzZPcm4xNU1FSWZ4MERrK240OWFVOFUvZnN3S3ZkWDZZRmxmWndyNWxpVUdU?=
 =?utf-8?B?WmEwTnV4MUxZSGVGNXl5a09SRmYrNHY1VWJjbkVtbFR6cXhlTGlQb0FJc1Jy?=
 =?utf-8?B?bzBxNU9ZNy85MGU0QU8ycVFMRXJESCtibVRZdUM0Q09ucmJsYjZhYTBtaThJ?=
 =?utf-8?B?UkVlWnpqdlBHUHEvdlVKZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <039CBBDC3CF8E5479EDAC177EFF199B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4620.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974fafbc-5155-46cb-5035-08d8ea59dc54
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 22:04:54.1152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Td9zfAzDdgrjYPuz8cMQQ0lA+QWSjoDc13ooaG40QdFFpP/9Z/r3+fJA03wV4JrPMZAEfWowLQ0f3ftU6aRLpL1MlVdJ0IiqWRUmRSNqxpY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTE4IGF0IDIwOjA2ICswMjAwLCBJbXJlIERlYWsgd3JvdGU6DQo+IE9u
IFRodSwgTWFyIDE4LCAyMDIxIGF0IDA3OjQ5OjEzUE0gKzAyMDAsIEltcmUgRGVhayB3cm90ZToN
Cj4gPiBPbiBUaHUsIE1hciAxOCwgMjAyMSBhdCAwNzozMzoyMFBNICswMjAwLCBWaWxsZSBTeXJq
w6Rsw6Qgd3JvdGU6DQo+ID4gPiBPbiBXZWQsIE1hciAxNywgMjAyMSBhdCAwODo0ODo1OVBNICsw
MjAwLCBJbXJlIERlYWsgd3JvdGU6DQo+ID4gPiA+IFRoZSBzcGVjIHJlcXVpcmVzIHRvIHVzZSBh
dCBsZWFzdCAzLjJtcyBmb3IgdGhlIEFVWCB0aW1lb3V0DQo+ID4gPiA+IHBlcmlvZCBpZg0KPiA+
ID4gPiB0aGVyZSBhcmUgTFQtdHVuYWJsZSBQSFkgUmVwZWF0ZXJzIG9uIHRoZSBsaW5rICgyLjEx
LjIpLiBBbg0KPiA+ID4gPiB1cGNvbWluZw0KPiA+ID4gPiBzcGVjIHVwZGF0ZSBtYWtlcyB0aGlz
IG1vcmUgc3BlY2lmaWMsIGJ5IHJlcXVpcmluZyBhIDMuMm1zDQo+ID4gPiA+IG1pbmltdW0NCj4g
PiA+ID4gdGltZW91dCBwZXJpb2QgZm9yIHRoZSBMVFRQUiBkZXRlY3Rpb24gcmVhZGluZyB0aGUg
MHhGMDAwMC0NCj4gPiA+ID4gMHhGMDAwNw0KPiA+ID4gPiByYW5nZSAoMy42LjUuMSkuDQo+ID4g
PiANCj4gPiA+IEknbSBwb25kZXJpbmcgaWYgd2UgY291bGQgcmVkdWNlIHRoZSB0aW1lb3V0IGFm
dGVyIGhhdmluZw0KPiA+ID4gZGV0ZXJtaW5lZA0KPiA+ID4gd2hlcnRoZXIgTFRUUFJzIGFyZSBw
cmVzZW50IG9yIG5vdD8gQnV0IG1heWJlIHRoYXQgd291bGRuJ3QNCj4gPiA+IHJlYWxseSBzcGVl
ZA0KPiA+ID4gdXAgYW55dGhpbmcgc2luY2Ugd2UgY2FuJ3QgcmVkdWNlIHRoZSB0aW1lb3V0IHVu
dGlsIGFmdGVyDQo+ID4gPiBkZXRlY3RpbmcNCj4gPiA+ICpzb21ldGhpbmcqLiBBbmQgb25jZSB0
aGVyZSBpcyBzb21ldGhpbmcgdGhlcmUgd2Ugc2hvdWxkbid0DQo+ID4gPiByZWFsbHkgZ2V0DQo+
ID4gPiBhbnkgbW9yZSB0aW1lb3V0cyBJIGd1ZXNzLiBTbyBwcm9iYWJseSBhIHRvdGFsbHkgc3R1
cGlkIGlkZWEuDQo+ID4gDQo+ID4gUmlnaHQsIGlmIHNvbWV0aGluZyBpcyBjb25uZWN0ZWQgaXQg
d291bGQgdGFrZSBhbnl3YXkgYXMgbXVjaCB0aW1lDQo+ID4gYXMgaXQNCj4gPiB0YWtlcyBmb3Ig
dGhlIHNpbmsgdG8gcmVwbHkgd2hldGhlciBvciBub3Qgd2UgZGVjcmVhc2VkIHRoZQ0KPiA+IHRp
bWVvdXQuDQo+ID4gDQo+ID4gSG93ZXZlciBpZiBub3RoaW5nIGlzIGNvbm5lY3RlZCwgd2UgaGF2
ZSB0aGUgZXhjZXNzaXZlIHRpbWVvdXQNCj4gPiBLaGFsZWQNCj4gPiBhbHJlYWR5IG5vdGljZWQg
KDE2MCAqIDRtcyA9IDYuNCBzZWMgb24gSUNMKykuIEkgdGhpbmsgdG8gaW1wcm92ZQ0KPiA+IHRo
YXQNCj4gPiB3ZSBjb3VsZCBzY2FsZSB0aGUgdG90YWwgbnVtYmVyIG9mIHJldHJpZXMgYnkgbWFr
aW5nIGl0DQo+ID4gdG90YWxfdGltZW91dC9wbGF0Zm9ybV9zcGVjaWZpY190aW1lb3V0IChsZXR0
aW5nIHRvdGFsX3RpbWVvdXQ9MnNlYw0KPiA+IGZvcg0KPiA+IGluc3RhbmNlKSBvciBqdXN0IGNo
YW5naW5nIHRoZSBkcm0gcmV0cnkgbG9naWMgdG8gYmUgdGltZSBiYXNlZA0KPiA+IGluc3RlYWQN
Cj4gPiBvZiB0aGUgbnVtYmVyIG9mIHJldHJpZXMgd2UgdXNlIGF0bS4gDQo+IA0KPiBEb2gsIHJl
ZHVjaW5nIHNpbXBseSB0aGUgSFcgdGltZW91dHMgd291bGQgYmUgZW5vdWdoIHRvIGZpeCB0aGlz
Lg0KDQpXaGF0IGFib3V0IEx5dWRlJ3Mgc3VnZ2VzdGlvbiAoIA0KaHR0cHM6Ly9wYXRjaHdvcmsu
ZnJlZWRlc2t0b3Aub3JnL3BhdGNoLzQyMDM2OS8jY29tbWVudF83NTY1NzIpIA0KdG8gZHJvcCB0
aGUgcmV0cmllcyBpbiBpbnRlbF9kcF9hdXhfeGZlcigpDQoJCS8qIE11c3QgdHJ5IGF0IGxlYXN0
IDMgdGltZXMgYWNjb3JkaW5nIHRvIERQIHNwZWMgKi8NCgkJZm9yICh0cnkgPSAwOyB0cnkgPCA1
OyB0cnkrKykgew0KIA0KIA0KQW5kIHVzZSBvbmx5IHRoZSByZXRyaWVzIGluIGRybV9kcGNkX2Fj
Y2Vzcz8NCg0KVGhhbmtzDQpLaGFsZWQNCg0KPiANCj4gPiA+IEFueXdheXMsIHRoaXMgc2VlbXMg
YWJvdXQgdGhlIG9ubHkgdGhpbmcgd2UgY2FuIGRvIGdpdmVuIHRoZQ0KPiA+ID4gbGltaXRlZA0K
PiA+ID4gaHcgY2FwYWJpbGl0aWVzLg0KPiA+ID4gUmV2aWV3ZWQtYnk6IFZpbGxlIFN5cmrDpGzD
pCA8dmlsbGUuc3lyamFsYUBsaW51eC5pbnRlbC5jb20+DQo+ID4gPiANCj4gPiA+ID4gQWNjb3Jk
aW5nbHkgZGlzYWJsZSBMVFRQUiBkZXRlY3Rpb24gdW50aWwgR0xLLCB3aGVyZSB0aGUNCj4gPiA+
ID4gbWF4aW11bSB0aW1lb3V0DQo+ID4gPiA+IHdlIGNhbiBzZXQgaXMgb25seSAxLjZtcy4NCj4g
PiA+ID4gDQo+ID4gPiA+IExpbmsgdHJhaW5pbmcgaW4gdGhlIG5vbi10cmFuc3BhcmVudCBtb2Rl
IGlzIGtub3duIHRvIGZhaWwgYXQNCj4gPiA+ID4gbGVhc3Qgb24NCj4gPiA+ID4gc29tZSBTS0wg
c3lzdGVtcyB3aXRoIGEgV0QxOSBkb2NrIG9uIHRoZSBsaW5rLCB3aGljaCBleHBvc2VzIGFuDQo+
ID4gPiA+IExUVFBSDQo+ID4gPiA+IChzZWUgdGhlIFJlZmVyZW5jZXMgYmVsb3cpLiBXaGlsZSB0
aGlzIGNvdWxkIGhhdmUgZGlmZmVyZW50DQo+ID4gPiA+IHJlYXNvbnMNCj4gPiA+ID4gYmVzaWRl
cyB0aGUgdG9vIHNob3J0IEFVWCB0aW1lb3V0IHVzZWQsIG5vdCBkZXRlY3RpbmcgTFRUUFJzDQo+
ID4gPiA+IChhbmQgc28gbm90DQo+ID4gPiA+IHVzaW5nIHRoZSBub24tdHJhbnNwYXJlbnQgTFQg
bW9kZSkgZml4ZXMgbGluayB0cmFpbmluZyBvbiB0aGVzZQ0KPiA+ID4gPiBzeXN0ZW1zLg0KPiA+
ID4gPiANCj4gPiA+ID4gV2hpbGUgYXQgaXQgYWRkIGEgY29kZSBjb21tZW50IGFib3V0IHRoZSBw
bGF0Zm9ybSBzcGVjaWZpYw0KPiA+ID4gPiBtYXhpbXVtDQo+ID4gPiA+IHRpbWVvdXQgdmFsdWVz
Lg0KPiA+ID4gPiANCj4gPiA+ID4gdjI6IEFkZCBhIGNvbW1lbnQgYWJvdXQgdGhlIGc0eCBtYXhp
bXVtIHRpbWVvdXQgYXMgd2VsbC4NCj4gPiA+ID4gKFZpbGxlKQ0KPiA+ID4gPiANCj4gPiA+ID4g
UmVwb3J0ZWQtYnk6IFRha2FzaGkgSXdhaSA8dGl3YWlAc3VzZS5kZT4NCj4gPiA+ID4gUmVwb3J0
ZWQtYW5kLXRlc3RlZC1ieTogU2FudGlhZ28gWmFyYXRlIDwNCj4gPiA+ID4gc2FudGlhZ28uemFy
YXRlQHN1c2UuY29tPg0KPiA+ID4gPiBSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBCb2RvIEdyYXVt
YW5uIDxtYWlsQGJvZG9ncmF1bWFubi5kZT4NCj4gPiA+ID4gUmVmZXJlbmNlczogDQo+ID4gPiA+
IGh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNrdG9wLm9yZy9kcm0vaW50ZWwvLS9pc3N1ZXMvMzE2Ng0K
PiA+ID4gPiBGaXhlczogYjMwZWRmZDhkMGI0ICgiZHJtL2k5MTU6IFN3aXRjaCB0byBMVFRQUiBu
b24tdHJhbnNwYXJlbnQgDQo+ID4gPiA+IG1vZGUgbGluayB0cmFpbmluZyIpDQo+ID4gPiA+IENj
OiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS4xMQ0KPiA+ID4gPiBDYzogVGFrYXNoaSBJ
d2FpIDx0aXdhaUBzdXNlLmRlPg0KPiA+ID4gPiBDYzogVmlsbGUgU3lyasOkbMOkIDx2aWxsZS5z
eXJqYWxhQGxpbnV4LmludGVsLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogSW1yZSBEZWFr
IDxpbXJlLmRlYWtAaW50ZWwuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIGRyaXZlcnMvZ3B1
L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfYXV4LmMgICAgICAgfCAgNyArKysrKysrDQo+ID4g
PiA+ICAuLi4vZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfbGlua190cmFpbmluZy5jIHwg
MTUNCj4gPiA+ID4gKysrKysrKysrKysrLS0tDQo+ID4gPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE5
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPiA+IA0KPiA+ID4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kcF9hdXguYw0KPiA+ID4g
PiBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfYXV4LmMNCj4gPiA+ID4g
aW5kZXggZWFlYmYxMjMzMTBhLi4xMGZlMTdiNzI4MGQgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfYXV4LmMNCj4gPiA+ID4gKysrIGIv
ZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kcF9hdXguYw0KPiA+ID4gPiBAQCAt
MTMzLDYgKzEzMyw3IEBAIHN0YXRpYyB1MzIgZzR4X2dldF9hdXhfc2VuZF9jdGwoc3RydWN0DQo+
ID4gPiA+IGludGVsX2RwICppbnRlbF9kcCwNCj4gPiA+ID4gIAllbHNlDQo+ID4gPiA+ICAJCXBy
ZWNoYXJnZSA9IDU7DQo+ID4gPiA+ICANCj4gPiA+ID4gKwkvKiBNYXggdGltZW91dCB2YWx1ZSBv
biBHNHgtQkRXOiAxLjZtcyAqLw0KPiA+ID4gPiAgCWlmIChJU19CUk9BRFdFTEwoZGV2X3ByaXYp
KQ0KPiA+ID4gPiAgCQl0aW1lb3V0ID0gRFBfQVVYX0NIX0NUTF9USU1FX09VVF82MDB1czsNCj4g
PiA+ID4gIAllbHNlDQo+ID4gPiA+IEBAIC0xNTksNiArMTYwLDEyIEBAIHN0YXRpYyB1MzIgc2ts
X2dldF9hdXhfc2VuZF9jdGwoc3RydWN0DQo+ID4gPiA+IGludGVsX2RwICppbnRlbF9kcCwNCj4g
PiA+ID4gIAllbnVtIHBoeSBwaHkgPSBpbnRlbF9wb3J0X3RvX3BoeShpOTE1LCBkaWdfcG9ydC0N
Cj4gPiA+ID4gPmJhc2UucG9ydCk7DQo+ID4gPiA+ICAJdTMyIHJldDsNCj4gPiA+ID4gIA0KPiA+
ID4gPiArCS8qDQo+ID4gPiA+ICsJICogTWF4IHRpbWVvdXQgdmFsdWVzOg0KPiA+ID4gPiArCSAq
IFNLTC1HTEs6IDEuNm1zDQo+ID4gPiA+ICsJICogQ05MOiAzLjJtcw0KPiA+ID4gPiArCSAqIElD
TCs6IDRtcw0KPiA+ID4gPiArCSAqLw0KPiA+ID4gPiAgCXJldCA9IERQX0FVWF9DSF9DVExfU0VO
RF9CVVNZIHwNCj4gPiA+ID4gIAkgICAgICBEUF9BVVhfQ0hfQ1RMX0RPTkUgfA0KPiA+ID4gPiAg
CSAgICAgIERQX0FVWF9DSF9DVExfSU5URVJSVVBUIHwNCj4gPiA+ID4gZGlmZiAtLWdpdA0KPiA+
ID4gPiBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfbGlua190cmFpbmlu
Zy5jDQo+ID4gPiA+IGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kcF9saW5r
X3RyYWluaW5nLmMNCj4gPiA+ID4gaW5kZXggMTliYTdjN2NiYWFiLi5jMGUyNWM3NWMxMDUgMTAw
NjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBf
bGlua190cmFpbmluZy5jDQo+ID4gPiA+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3Bs
YXkvaW50ZWxfZHBfbGlua190cmFpbmluZy5jDQo+ID4gPiA+IEBAIC04Miw2ICs4MiwxOCBAQCBz
dGF0aWMgdm9pZA0KPiA+ID4gPiBpbnRlbF9kcF9yZWFkX2x0dHByX3BoeV9jYXBzKHN0cnVjdCBp
bnRlbF9kcCAqaW50ZWxfZHAsDQo+ID4gPiA+ICANCj4gPiA+ID4gIHN0YXRpYyBib29sIGludGVs
X2RwX3JlYWRfbHR0cHJfY29tbW9uX2NhcHMoc3RydWN0IGludGVsX2RwDQo+ID4gPiA+ICppbnRl
bF9kcCkNCj4gPiA+ID4gIHsNCj4gPiA+ID4gKwlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqaTkx
NSA9IGRwX3RvX2k5MTUoaW50ZWxfZHApOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJaWYgKGludGVs
X2RwX2lzX2VkcChpbnRlbF9kcCkpDQo+ID4gPiA+ICsJCXJldHVybiBmYWxzZTsNCj4gPiA+ID4g
Kw0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICogRGV0ZWN0aW5nIExUVFBScyBtdXN0IGJlIGF2
b2lkZWQgb24gcGxhdGZvcm1zIHdpdGgNCj4gPiA+ID4gYW4gQVVYIHRpbWVvdXQNCj4gPiA+ID4g
KwkgKiBwZXJpb2QgPCAzLjJtcy4gKHNlZSBEUCBTdGFuZGFyZCB2Mi4wLCAyLjExLjIsDQo+ID4g
PiA+IDMuNi42LjEpLg0KPiA+ID4gPiArCSAqLw0KPiA+ID4gPiArCWlmIChJTlRFTF9HRU4oaTkx
NSkgPCAxMCkNCj4gPiA+ID4gKwkJcmV0dXJuIGZhbHNlOw0KPiA+ID4gPiArDQo+ID4gPiA+ICAJ
aWYgKGRybV9kcF9yZWFkX2x0dHByX2NvbW1vbl9jYXBzKCZpbnRlbF9kcC0+YXV4LA0KPiA+ID4g
PiAgCQkJCQkgIGludGVsX2RwLQ0KPiA+ID4gPiA+bHR0cHJfY29tbW9uX2NhcHMpIDwgMCkgew0K
PiA+ID4gPiAgCQltZW1zZXQoaW50ZWxfZHAtPmx0dHByX2NvbW1vbl9jYXBzLCAwLA0KPiA+ID4g
PiBAQCAtMTI3LDkgKzEzOSw2IEBAIGludCBpbnRlbF9kcF9sdHRwcl9pbml0KHN0cnVjdCBpbnRl
bF9kcA0KPiA+ID4gPiAqaW50ZWxfZHApDQo+ID4gPiA+ICAJYm9vbCByZXQ7DQo+ID4gPiA+ICAJ
aW50IGk7DQo+ID4gPiA+ICANCj4gPiA+ID4gLQlpZiAoaW50ZWxfZHBfaXNfZWRwKGludGVsX2Rw
KSkNCj4gPiA+ID4gLQkJcmV0dXJuIDA7DQo+ID4gPiA+IC0NCj4gPiA+ID4gIAlyZXQgPSBpbnRl
bF9kcF9yZWFkX2x0dHByX2NvbW1vbl9jYXBzKGludGVsX2RwKTsNCj4gPiA+ID4gIAlpZiAoIXJl
dCkNCj4gPiA+ID4gIAkJcmV0dXJuIDA7DQo+ID4gPiA+IC0tIA0KPiA+ID4gPiAyLjI1LjENCj4g
PiA+IA0KPiA+ID4gLS0gDQo+ID4gPiBWaWxsZSBTeXJqw6Rsw6QNCj4gPiA+IEludGVsDQo=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231B32FD617
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 17:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391323AbhATQm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 11:42:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:60176 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391700AbhATQmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 11:42:07 -0500
IronPort-SDR: cYWbECLY6an8+o9OLepbjEl/V6nHX0INR4GbFJO99TehdSS/pA4tWKVseiiZxov1TdxCWC6/Ds
 GAdf2KAMey9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="158316274"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="158316274"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 08:41:19 -0800
IronPort-SDR: xIusPTD4ddCpvVbKIfN2IuQwDXNhZ4A+eQn8J09Terc4hJI2jqYDOAk9LMbX5yREEBOK43JfhL
 kwtHA+9NT2Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="356108538"
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137])
  by fmsmga008.fm.intel.com with ESMTP; 20 Jan 2021 08:41:17 -0800
Received: from irsmsx601.ger.corp.intel.com (163.33.146.7) by
 IRSMSX604.ger.corp.intel.com (163.33.146.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Jan 2021 16:41:16 +0000
Received: from irsmsx601.ger.corp.intel.com ([163.33.146.7]) by
 irsmsx601.ger.corp.intel.com ([163.33.146.7]) with mapi id 15.01.1713.004;
 Wed, 20 Jan 2021 16:41:16 +0000
From:   "Rojewski, Cezary" <cezary.rojewski@intel.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?utf-8?B?xYF1a2FzeiBNYWpjemFr?= <lma@semihalf.com>
CC:     Marcin Wojtas <mw@semihalf.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        "Alex Levin" <levinale@google.com>,
        Guenter Roeck <groeck@google.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?QW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>
Subject: RE: [PATCH v2] ASoC: Intel: Skylake: Check the kcontrol against NULL
Thread-Topic: [PATCH v2] ASoC: Intel: Skylake: Check the kcontrol against NULL
Thread-Index: AQHW1HWlBDRR5udg2US7JjUHUSX5h6okBMqAgAzZ2oCAAAxcgIAAAbqw
Date:   Wed, 20 Jan 2021 16:41:16 +0000
Message-ID: <371e612ac59c458cad1bafb82ca09c9f@intel.com>
References: <20201210121438.7718-1-lma@semihalf.com>
 <20201217130439.141943-1-lma@semihalf.com>
 <CAFJ_xbprw7UKREWgRAq3dDAA9oC_3cWoozn5pCY8w9By4dASag@mail.gmail.com>
 <CAFJ_xbrvr7jcCB57MPwzXf=oC5OYT5KUBkcqHYyOYH=a5njfSA@mail.gmail.com>
 <8c22c415-1807-b673-20e3-bc8d7f4c05b7@linux.intel.com>
In-Reply-To: <8c22c415-1807-b673-20e3-bc8d7f4c05b7@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjAyMS0wMS0yMCA1OjMzIFBNLCBQaWVycmUtTG91aXMgQm9zc2FydCB3cm90ZToNCj4gT24g
MS8yMC8yMSA5OjQ5IEFNLCDFgXVrYXN6IE1hamN6YWsgd3JvdGU6DQo+PiBIaSBQaWVycmUsDQo+
Pg0KPj4gSXMgdGhlcmUgYW55dGhpbmcgbW9yZSB0byBkbyB0byBnZXQgdGhlIEFDSyBmb3IgdGhp
cyBwYXRjaD8NCj4gDQo+IEFkZGluZyBDZXphcnkgYW5kIEFtYWRldXN6IGZvciBmZWVkYmFjaywg
SSBjYW4ndCBwcmV0ZW5kIGhhdmluZyBhbnkgc29ydCANCj4gb2Yga25vd2xlZGdlIG9uIHRoZSBT
a3lsYWtlIGRyaXZlciBpbnRlcm5hbHMgYW5kIHRvcG9sb2d5IHVzYWdlLg0KPiANCg0KVGhhbmtz
IGZvciB0aGUgQ0MsIFBpZXJyZS4NCg0KLi4uDQoNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL3Nv
dW5kL3NvYy9pbnRlbC9za3lsYWtlL3NrbC10b3BvbG9neS5jIA0KPj4+PiBiL3NvdW5kL3NvYy9p
bnRlbC9za3lsYWtlL3NrbC10b3BvbG9neS5jDQo+Pj4+IGluZGV4IGFlNDY2Y2Q1OTI5MjIuLjhm
MGJmZGE3MDk2YTkgMTAwNjQ0DQo+Pj4+IC0tLSBhL3NvdW5kL3NvYy9pbnRlbC9za3lsYWtlL3Nr
bC10b3BvbG9neS5jDQo+Pj4+ICsrKyBiL3NvdW5kL3NvYy9pbnRlbC9za3lsYWtlL3NrbC10b3Bv
bG9neS5jDQo+Pj4+IEBAIC0zNjE4LDEyICszNjE4LDE4IEBAIHN0YXRpYyB2b2lkIHNrbF90cGxn
X2NvbXBsZXRlKHN0cnVjdCANCj4+Pj4gc25kX3NvY19jb21wb25lbnQgKmNvbXBvbmVudCkNCj4+
Pj4gICAgICAgICAgaW50IGk7DQo+Pj4+DQo+Pj4+ICAgICAgICAgIGxpc3RfZm9yX2VhY2hfZW50
cnkoZG9iaiwgJmNvbXBvbmVudC0+ZG9ial9saXN0LCBsaXN0KSB7DQo+Pj4+IC0gICAgICAgICAg
ICAgICBzdHJ1Y3Qgc25kX2tjb250cm9sICprY29udHJvbCA9IGRvYmotPmNvbnRyb2wua2NvbnRy
b2w7DQo+Pj4+IC0gICAgICAgICAgICAgICBzdHJ1Y3Qgc29jX2VudW0gKnNlID0NCj4+Pj4gLSAg
ICAgICAgICAgICAgICAgICAgICAgKHN0cnVjdCBzb2NfZW51bSAqKWtjb250cm9sLT5wcml2YXRl
X3ZhbHVlOw0KPj4+PiAtICAgICAgICAgICAgICAgY2hhciAqKnRleHRzID0gZG9iai0+Y29udHJv
bC5kdGV4dHM7DQo+Pj4+ICsgICAgICAgICAgICAgICBzdHJ1Y3Qgc25kX2tjb250cm9sICprY29u
dHJvbDsNCj4+Pj4gKyAgICAgICAgICAgICAgIHN0cnVjdCBzb2NfZW51bSAqc2U7DQo+Pj4+ICsg
ICAgICAgICAgICAgICBjaGFyICoqdGV4dHM7DQo+Pj4+ICAgICAgICAgICAgICAgICAgY2hhciBj
aGFuX3RleHRbNF07DQo+Pj4+DQo+Pj4+ICsgICAgICAgICAgICAgICBrY29udHJvbCA9IGRvYmot
PmNvbnRyb2wua2NvbnRyb2w7DQo+Pj4+ICsgICAgICAgICAgICAgICBpZiAoIWtjb250cm9sKQ0K
Pj4+PiArICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4+Pj4gKw0KPj4+PiArICAg
ICAgICAgICAgICAgc2UgPSAoc3RydWN0IHNvY19lbnVtICopa2NvbnRyb2wtPnByaXZhdGVfdmFs
dWU7DQo+Pj4+ICsgICAgICAgICAgICAgICB0ZXh0cyA9IGRvYmotPmNvbnRyb2wuZHRleHRzOw0K
Pj4+PiArDQo+Pj4+ICAgICAgICAgICAgICAgICAgaWYgKGRvYmotPnR5cGUgIT0gU05EX1NPQ19E
T0JKX0VOVU0gfHwNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgZG9iai0+Y29udHJvbC5rY29u
dHJvbC0+cHV0ICE9DQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgIHNrbF90cGxnX211bHRpX2Nv
bmZpZ19zZXRfZG1pYykNCg0KSnVzdCBjaGVja2VkIHRoZSBoaXN0b3J5IGJlaGluZCB0aGlzLiBB
bmQgbXVzdCBzYXksIEkgbGlrZWQgUmljYXJkbydzDQp2ZXJzaW9uIGJldHRlci4gRXhjZXB0IGZv
ciB0aGUgIj0ge307IiBiaXQgd2hpY2ggTWFyayBhbHJlYWR5IHBvaW50ZWQNCm91dCAtIGl0IHNo
b3VsZCBiZSBhIHNlcGFyYXRlIGZpeCAtIGl0J3Mgc2ltcGx5IG1vcmUgb3B0aW9uYWwNCg0KZS5n
LjogJ2tjb250cm9sJyBnZXRzIGFzc2lnbmVkIHlldCAnaWYnIGFib3ZlIGlzIG5vdCB1cGRhdGVk
IGFjY29yZGluZ2x5Og0Kcy9kb2JqLT5jb250cm9sLmtjb250cm9sLT5wdXQva2NvbnRyb2wtPnB1
dA0KDQpDemFyZWsNCg0K

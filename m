Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98DE1728E2
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 20:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgB0Tmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 14:42:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:18044 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729921AbgB0Tmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 14:42:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 11:42:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238527588"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 11:42:51 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Feb 2020 11:42:51 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Feb 2020 11:42:51 -0800
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Feb 2020 11:42:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Feb 2020 11:42:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxm72PpjEyY9WDiZtvuVym+y0AGWhLJbNTEKQJJTponcKZOau97NBb8WMB0c0hyVDFG24RuityjmEH/st0erhi3oyHgp+nufFILB2Ci8FZIkV72klCdatQdA6N9IiFA9AjWKeymYdhiTmF0JVt5oq2TO8Ktvpl4RVozVhsc68YMEoE3ML4tP3/VQ56sRGmyAHrcFuilOejZqFH8MK6rfyYw/aahAGXXRDfoLHoXwqcerYAsI9ylncrCrZJUXin1Q2VBhPAEic5xBTfg30kZLviY2u2cCmotUBmYynsGrtUf8a2pFeOPfL6Z1QhHSrtzgJmMcqBq3BLEOdVBKtpa0kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tugKlYBSIEBR07uZyZe9ax2PIB2XxEea4aHktcsDxMw=;
 b=il+PlSEpNtejTsAA6/B3+3r6rrWjFGEcpbxr14HzEl3S/4hooYfGY4rFKPejFq3SjXs2nJdTj/nZHEckiKFs0PdUdzXOBItm8tmj59Ngpi4ZhfHgRF2UVK0AQeQFcpW1qbaiqRafL1DCF5dJxlW92zbI7S1dza2HCna+2cq5yv3vKguJ/LKdTLBnmtTfqrZMTKHLcXgG/90udV8XYXAsy2nYM0rm3GxY5RHEl4U6Peepv1M/ojYZGxIQgLDCvzjAIrQRJgc+q5lW2FwNry4O+KC6DOaed/s5jRiCZbYjS7QbrdvzTaFmWRlj4IWmOJGj/a5w+u/W+ZK3qovftMyDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tugKlYBSIEBR07uZyZe9ax2PIB2XxEea4aHktcsDxMw=;
 b=KQhGz3hlwbSBNMFHLXneLPMAz7yP5Ibpr4pBsBbbZA02CTwaBH2V7Wf3vXDB/Ehcjla1jyvPfNbxtpJ0PqJo49pcJkTt8XDoXE/cPAqODiMPGqbJuT+wXIzuNHLeTZeKqeoBWj1yXHb/ypAgGKXh7+vsj1WF/d0rOqsAHVX5AIE=
Received: from MW3PR11MB4570.namprd11.prod.outlook.com (2603:10b6:303:5f::22)
 by MW3PR11MB4603.namprd11.prod.outlook.com (2603:10b6:303:5e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Thu, 27 Feb
 2020 19:42:43 +0000
Received: from MW3PR11MB4570.namprd11.prod.outlook.com
 ([fe80::95ae:a984:9998:f2c8]) by MW3PR11MB4570.namprd11.prod.outlook.com
 ([fe80::95ae:a984:9998:f2c8%7]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 19:42:43 +0000
From:   "Nujella, Sathyanarayana" <sathyanarayana.nujella@intel.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rojewski, Cezary" <cezary.rojewski@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "Vehmanen, Kai" <kai.vehmanen@intel.com>
Subject: RE: 5.5.6 regression (stuck at boot) on devices using the sof_hda
 audio driver + fix
Thread-Topic: 5.5.6 regression (stuck at boot) on devices using the sof_hda
 audio driver + fix
Thread-Index: AQHV7aWufoSvbw0XCEaTx7/mbasemagvcLTQ
Date:   Thu, 27 Feb 2020 19:42:42 +0000
Message-ID: <MW3PR11MB457074EE2FB422E2962EE49C89EB0@MW3PR11MB4570.namprd11.prod.outlook.com>
References: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
In-Reply-To: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sathyanarayana.nujella@intel.com; 
x-originating-ip: [192.55.52.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5f6f821-d6c6-4449-8783-08d7bbbd3668
x-ms-traffictypediagnostic: MW3PR11MB4603:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4603C6552E2B806B8EF08B9A89EB0@MW3PR11MB4603.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(26005)(71200400001)(186003)(6636002)(53546011)(9686003)(478600001)(33656002)(5660300002)(2906002)(55016002)(966005)(316002)(110136005)(7696005)(52536014)(66476007)(66556008)(66446008)(76116006)(64756008)(66946007)(6506007)(8936002)(8676002)(81156014)(86362001)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4603;H:MW3PR11MB4570.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d8VTnb+BfdLUt7qDS3ykdvgySrWpM2IbYUIExF9e7uPb5OoScR7i/5W77CJf/tKV28Wd5p8R4wES1vw7L7OQlEs6XHrP/zFN0NBxd0cdeGjv66dyfAn9Cymbso4uvxB3I0aDI+QsBR+zgE4MUQLzpSdBNz8gEOF0VTC214r9J6IWjYtvEJADqMofAIwiTzg83mwetIpOO3zil6MXYth4LYSUQFPVG/RwTM4WCBenpHECX6sc0CpKmQqBQ89vBcRhZWaW/20lX/zgXYXCEiUse6M+ZRDRN2M4LKWnPAZr1BE218TQVbvHx7bFRKL75LWBcM8pTiA+93NSShujgPpgM/8zxKDRNOQqr7u0umz34UAjG34WCPliGvQ6LfoHwgzggWd4LnsybNg/8Oz7DtaS1ipMXVXhD7yS69qxI/zmQ+ikatCY/3XhJKCmWU4fdHd4VCvI7P/FkVX7uD0G6gGsCnK45lTzLhUa8nutUvRkm+UkDLX5kgqttilwlP5T8U8gadl0jDDeN/lWXQkoW2mlTA==
x-ms-exchange-antispam-messagedata: qbbLKt1ni2qgv/9VAxJldnSMiax1Ipe0G0JxBf0H2CmIALLhOGKlRl/a8FGU6ed7XHhZjiyUIlLMtI/lXaBE58tWZPM6ipIXY0ouK8H8o1dhVIblAHaDpzaY6Nm/WTSQ2WcTLg6uEdApe1Hzdcx6Tw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f6f821-d6c6-4449-8783-08d7bbbd3668
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 19:42:42.9997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E/2fL2zkaVEHd5j+zyzw9Zo+sY8hWRFNrxbXMe6ttjc1F6dElvDTRWsEelv1Z/APDqeBcZemhZPBt8GyAaQM89GmMXqSuOYOmTfhlnTnJ+vUJVEgcFqZ981KQAsgOWGt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4603
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

K0thaQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhhbnMgZGUgR29l
ZGUgPGhkZWdvZWRlQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAyNywg
MjAyMCAxMTozOSBBTQ0KPiBUbzogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgTnVqZWxsYSwgU2F0
aHlhbmFyYXlhbmENCj4gPHNhdGh5YW5hcmF5YW5hLm51amVsbGFAaW50ZWwuY29tPjsgUm9qZXdz
a2ksIENlemFyeQ0KPiA8Y2V6YXJ5LnJvamV3c2tpQGludGVsLmNvbT47IEphcm9zbGF2IEt5c2Vs
YSA8cGVyZXhAcGVyZXguY3o+DQo+IFN1YmplY3Q6IDUuNS42IHJlZ3Jlc3Npb24gKHN0dWNrIGF0
IGJvb3QpIG9uIGRldmljZXMgdXNpbmcgdGhlIHNvZl9oZGEgYXVkaW8NCj4gZHJpdmVyICsgZml4
DQo+IA0KPiBIaSBBbGwsDQo+IA0KPiBJIGFuZCB2YXJpb3VzIG90aGVyIEZlZG9yYSB1c2VycyBo
YXZlIG5vdGljZWQgdGhhdCBGZWRvcmEncyA1LjUuNiBidWlsZCBnZXRzDQo+IHN0dWNrIGF0IGJv
b3Qgb24gYSBMZW5vdm8gWDEgN3RoIGdlbiwgc2VlOg0KPiBodHRwczovL2J1Z3ppbGxhLnJlZGhh
dC5jb20vc2hvd19idWcuY2dpP2lkPTE3NzI0OTgNCj4gDQo+IFRoaXMgaXMgY2F1c2VkIGJ5IHRo
ZSBhZGRpdGlvbiBvZiB0aGlzIGNvbW1pdCB0byA1LjUuNjoNCj4gDQo+IDI0YzI1OTU1N2M0NSAo
IkFTb0M6IFNPRjogSW50ZWw6IGhkYTogRml4IFNLTCBkYWkgY291bnQiKQ0KPiBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2Nv
bW1pdC8/aD1saQ0KPiBudXgtNS41LnkmaWQ9MjRjMjU5NTU3YzQ1ZTgxNzk0MWQzODQzZjgyMzMx
YTQ3N2M4NmE3ZQ0KPiANCj4gIyMjDQo+IEFTb0M6IFNPRjogSW50ZWw6IGhkYTogRml4IFNLTCBk
YWkgY291bnQgWyBVcHN0cmVhbSBjb21taXQNCj4gYTY5NDdjOWQ4NmJjZmQ2MWI3NThiNTY5M2Vi
YTU4ZGVmZTdmZDJhZSBdDQo+IA0KPiBXaXRoIGZvdXJ0aCBwaW4gYWRkZWQgZm9yIGlEaXNwIGZv
ciBza2xfZGFpLCB1cGRhdGUgU09GX1NLTF9EQUlfTlVNIHRvDQo+IGFjY291bnQgZm9yIHRoZSBj
aGFuZ2UuIFdpdGhvdXQgdGhpcywgZGFpcyBmcm9tIHRoZSBib3R0b20gb2YgdGhlIGxpc3QgYXJl
DQo+IHNraXBwZWQuIEluIGN1cnJlbnQgc3RhdGUgdGhhdCdzIHRoZSBjYXNlIGZvciAnQWx0IEFu
YWxvZyBDUFUgREFJJy4NCj4gDQo+IEZpeGVzOiBhYzQyYjE0MmNkNzYgKCJBU29DOiBTT0Y6IElu
dGVsOiBoZGE6IEFkZCBpRGlzcDQgREFJIikNCj4gU2lnbmVkLW9mZi1ieTogQ2V6YXJ5IFJvamV3
c2tpIDxjZXphcnkucm9qZXdza2lAaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogUGllcnJlLUxv
dWlzIEJvc3NhcnQgPHBpZXJyZS1sb3Vpcy5ib3NzYXJ0QGxpbnV4LmludGVsLmNvbT4NCj4gTGlu
azogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIwMDExMzExNDA1NC45NzE2LTEtDQo+IGNl
emFyeS5yb2pld3NraUBpbnRlbC5jb20NCj4gU2lnbmVkLW9mZi1ieTogTWFyayBCcm93biA8YnJv
b25pZUBrZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtl
cm5lbC5vcmc+ICMjIw0KPiANCj4gTm90aWNlIHRoZSAiRml4ZXM6IGFjNDJiMTQyY2Q3NiAoLi4u
KSIsIHRoYXQgY29tbWl0LWlkIGFjdHVhbGx5IGRvZXMgbm90IGV4aXN0LA0KPiB0aGUgY29ycmVj
dCBjb21taXQtaWQgd2hpY2ggdGhpcyBmaXhlcyBpczoNCj4gDQo+IGU2OGQ2Njk2NTc1ZSAoIkFT
b0M6IFNPRjogSW50ZWw6IGhkYTogQWRkIGlEaXNwNCBEQUkiKSBhbmQgdGhhdCBjb21taXQgaXMN
Cj4gbm90IGluIDUuNS42LCB3aGljaCBpcyBjYXVzaW5nIHRoZSBwcm9ibGVtLCB0aGUgbWlzc2lu
ZyBjb21taXQgbWFrZXMgYW4NCj4gYXJyYXkgb25lIGxhcmdlciBhbmQgdGhlIGZpeCBmb3IgdGhl
IG1pc3NpbmcgZml4IHdoaWNoIGRpZCBlbmQgdXAgaW4gNS41LjYgYW5kDQo+IGJ1bXBzIGEgZGVm
aW5lIHdoaWNoIGlzIHVzZWQgdG8gd2FsayBvdmVyIHRoZSBhcnJheSBpbiBzb21lIHBsYWNlcyBi
eSBvbmUgc28NCj4gbm93IHRoZSB3YWxraW5nIGlzIGdvaW5nIG92ZXIgdGhlIGFycmF5IGJvdW5k
YXJ5Lg0KPiANCj4gRm9yIHRoZSBGZWRvcmEga2VybmVscyBJJ3ZlIGZpeGVkIHRoaXMgYnkgYWRk
aW5nIHRoZQ0KPiAiQVNvQzogU09GOiBJbnRlbDogaGRhOiBBZGQgaURpc3A0IERBSSIgY29tbWl0
IGFzIGEgZG93bnN0cmVhbSBwYXRjaCBmb3INCj4gb3VyIGtlcm5lbHMuIEkgYmVsaWV2ZSB0aGF0
IHRoaXMgaXMgcHJvYmFibHkgdGhlIGJlc3QgZml4IGZvciA1LjUueiB0b28uDQo+IA0KPiBSZWdh
cmRzLA0KPiANCj4gSGFucw0KPiANCj4gDQo+IHAucy4NCj4gDQo+IEkga25vdyB0aGF0IHRoZSBz
dGFibGUgc2VyaWVzIGFyZSBwYXJ0bHkgYmFzZWQgb24gYXV0b21hdGljYWxseSBwaWNraW5nDQo+
IHBhdGNoZXMgbm93LiBJIHdvbmRlciBpZiB0aGUgc2NyaXB0cyBkb2luZyB0aGF0IGNvdWxkIGJl
IG1hZGUgc21hcnRlciB3cnQNCj4gcmVqZWN0aW5nIHBhdGNoZXMgd2l0aCBhIEZpeGVzIHRhZyB3
aGVyZSB0aGUgZml4ZWQgcGF0Y2ggaXMgbm90IHByZXNlbnQsIHNvDQo+IHdoZXJlIGluIGVzc2Vu
Y2UgYSBwcmUtcmVxdWlzaXRlIG9mIHRoZSBwYXRjaCBiZWluZyBhZGRlZCBpcyBtaXNzaW5nID8N
Cg0K

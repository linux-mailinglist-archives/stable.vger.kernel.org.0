Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90A911C075
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLKXQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:16:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:11770 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfLKXQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 18:16:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 15:16:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,303,1571727600"; 
   d="scan'208";a="265035973"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Dec 2019 15:16:43 -0800
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 11 Dec 2019 15:16:42 -0800
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX154.amr.corp.intel.com (10.22.226.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 11 Dec 2019 15:16:42 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.54) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 11 Dec 2019 15:16:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKBEHUByGKhay8KbDfASAxBFk6XFsx4xL+jWQ5gOoQ4Nn8mzxq/7yg6Lc5iA30u2PahP/FPqSMtf9YRnPULSvKAXt10xqlS2tvQopvkoBH5YzWpM4/inspHX+7qnE8wB6byJa42/JyDrzfmdyH4aixy96tJ1bkIbWLGVom3+xeJMc/qHKIQFyRkO5ju32/qdzbPIAlL3amlVEXgKXy3ny90zq/Z6+6jMTnvjstphP5ApAh1DWuqtrhtuVioKoJn+bu9raWL1ER5EQ6X2phW7AUGln4JN8fdzmimtsuHRcuscNV1RXZiuZ3SuPZjNILX4s/B31zBNTPRvO6DNjVhK0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny6bMwq+ynSGfdWaos5ieYsRDvt/KF366ftVV/JMNXE=;
 b=BMNgWYjcGTG+g+Mydn+IezITwC5RWmxlceTfsIcBbighKr5+NoJNtY9J3bRXEaTJLVPX9RSpeDj7DA1RormKlajHRgd/1DlOHCQ6YvycaOcwG5PvJA6SyRURRcNXPmGsQJGsgmto/2G3jia+rCp8dIXXpaZ1ywpMSLe/dxcaim9Jvjz8PNVYzmuHQtq/aZz0nAd7XoBxerogjLbktqIhlmXVIh4DHXldlvRQNOTZ2Pi4TLTfA+9m3LVjoc/UM0InaJMX1DldNmiFvSvs8P71NXwtrRAyTxsJzJ0cR7eOPQ2u27/jK8hLxkoNFssRvfKTr8SyWRkOWhzloMoHk2fNHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny6bMwq+ynSGfdWaos5ieYsRDvt/KF366ftVV/JMNXE=;
 b=oU5edUI2BOTM95+Pb85Wgmge+KSKY1UBOkBpHq/60WRYFLjvcCtQwpLaIrqZ7InRF6VK7g3o9ghCh0FzL5gTXi/yW/y8ttSILqBGtCu/PMXMr/nR1zVhVdjlaLDmLEa3MxCaxYq+BLq9e7kjUlgB1nrSlBWNes2h5xHza8ma1Vc=
Received: from CY4PR1101MB2198.namprd11.prod.outlook.com (10.172.78.149) by
 CY4PR1101MB2197.namprd11.prod.outlook.com (10.172.76.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 11 Dec 2019 23:16:41 +0000
Received: from CY4PR1101MB2198.namprd11.prod.outlook.com
 ([fe80::1d41:a622:82f0:201b]) by CY4PR1101MB2198.namprd11.prod.outlook.com
 ([fe80::1d41:a622:82f0:201b%7]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 23:16:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
Thread-Topic: [PATCH v2] KVM: x86: use CPUID to locate host page table
 reserved bits
Thread-Index: AQHVqrlhvKAEwPvqBUOb/a6h3IUJt6eqIY0AgAj+agCAAPmDAIAAlgWAgADDvYCAAClkAA==
Date:   Wed, 11 Dec 2019 23:16:41 +0000
Message-ID: <86bb95b84a0006fbce49201d5c37f997714884ed.camel@intel.com>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
         <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
         <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
         <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
         <62438ac9-e186-32a7-d12f-5806054d56b2@redhat.com>
         <4faef0e9-72aa-9328-9110-fc67b2580f91@amd.com>
In-Reply-To: <4faef0e9-72aa-9328-9110-fc67b2580f91@amd.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kai.huang@intel.com; 
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f9d3b95-9e8c-4c1b-86c1-08d77e902e39
x-ms-traffictypediagnostic: CY4PR1101MB2197:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2197E4F8277947A75C1BCD4AF75A0@CY4PR1101MB2197.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(346002)(366004)(136003)(189003)(199004)(26005)(54906003)(71200400001)(91956017)(64756008)(76116006)(36756003)(66446008)(66476007)(66946007)(66556008)(6486002)(110136005)(478600001)(81156014)(6512007)(81166006)(186003)(4326008)(316002)(2616005)(2906002)(53546011)(8676002)(5660300002)(6506007)(8936002)(86362001)(4001150100001)(60764002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1101MB2197;H:CY4PR1101MB2198.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2g7DzDLBKoUrsrbfaCb/FaPtcbHaJj8qYZelM4v7iX717U8WTk9idB+/Uy0wahmnW/yKp6Nq8KB3ZTX/8mZ0FvpniVZNFF+h7pzjNCnsQcy5ZQf3Oa5GreYKgI0wyzVcKVP9JAnEVNAeIOBagh3SP5SGS4OXbnW9kN5CajxhdzDeeeDL28T6J0ugcxHgQPgR+3JeCFEB3UVeOwdBi2k9slO0/q33U6DJZ5xKOihzUyi2/B3RNgj+0jeKJGIEGhXQ++lk2mhObmpmgU+QBmkmq6kGElZxO6yLkXMt9l362rNAUFbJEuwloCx8CRTghLevltsFlEf+NzAiEwyGSaAkz9TdzbtOUvUtU4jMmiZw+ouP0LAnAq1HZXayML73bS7qL6s5OSFQhpBY/hCLC/ZTpKpJOQPNL5rcaAWrf7t+/5Jgu6AJAi4wvoB8IDQG5lN/taN1bbptt7EYVnpTViYrWer3wAiiuB2VwAS264J09hM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9861527B257B11408BB452C452F1E0A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9d3b95-9e8c-4c1b-86c1-08d77e902e39
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 23:16:41.0717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2pqcPavu0x7yO4kvkBWBycFnFH4pP06OwVINFCWI3oVYEaMq7LT7e/Y651ePwoAKlk6AUXnmnM3QHLWWZieRNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2197
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDE0OjQ4IC0wNjAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDEyLzExLzE5IDM6MDcgQU0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+ID4gT24gMTEvMTIv
MTkgMDE6MTEsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+IGt2bV9nZXRfc2hhZG93X3BoeXNf
Yml0cygpIG11c3QgYmUgY29uc2VydmF0aXZlIGluIHRoYXQ6DQo+ID4gPiA+IA0KPiA+ID4gPiAx
KSBpZiBhIGJpdCBpcyByZXNlcnZlZCBpdCBfY2FuXyByZXR1cm4gYSB2YWx1ZSBoaWdoZXIgdGhh
biBpdHMgaW5kZXgNCj4gPiA+ID4gDQo+ID4gPiA+IDIpIGlmIGEgYml0IGlzIHVzZWQgYnkgdGhl
IHByb2Nlc3NvciAoZm9yIHBoeXNpY2FsIGFkZHJlc3Mgb3IgYW55dGhpbmcNCj4gPiA+ID4gZWxz
ZSkgaXQgX211c3RfIHJldHVybiBhIHZhbHVlIGhpZ2hlciB0aGFuIGl0cyBpbmRleC4NCj4gPiA+
ID4gDQo+ID4gPiA+IEluIHRoZSBTRVYgY2FzZSB3ZSdyZSBub3Qgb2JleWluZyAoMiksIGJlY2F1
c2UgdGhlIGZ1bmN0aW9uIHJldHVybnMgNDMNCj4gPiA+ID4gd2hlbiB0aGUgQyBiaXQgaXMgYml0
IDQ3LiAgVGhlIHBhdGNoIGZpeGVzIHRoYXQuDQo+ID4gPiBDb3VsZCB3ZSBndWFyYW50ZWUgdGhh
dCBDLWJpdCBpcyBhbHdheXMgYmVsb3cgYml0cyByZXBvcnRlZCBieSBDUFVJRD8NCj4gPiANCj4g
PiBUaGF0J3MgYSBxdWVzdGlvbiBmb3IgQU1ELiA6KSAgVGhlIEMgYml0IGNhbiBtb3ZlIChhbmQg
cHJvYmFibHkgd2lsbCwNCj4gPiBvdGhlcndpc2UgdGhleSB3b3VsZG4ndCBoYXZlIGJvdGhlcmVk
IGFkZGluZyBpdCB0byBDUFVJRCkgaW4gZnV0dXJlDQo+ID4gZ2VuZXJhdGlvbnMgb2YgdGhlIHBy
b2Nlc3Nvci4NCj4gDQo+IFJpZ2h0LCB0aGVyZSdzIG5vIHdheSB0byBndWFyYW50ZWUgdGhhdCBp
dCBpcyBhbHdheXMgYmVsb3cgYml0cyByZXBvcnRlZA0KPiBieSBDUFVJRC4gQXMgUGFvbG8gc3Rh
dGVkLCB0aGUgcG9zaXRpb24gaXMgcmVwb3J0ZWQgYnkgQ1BVSUQgc28gdGhhdCBpdA0KPiBjYW4g
ZWFzaWx5IG1vdmUgYW5kIGJlIGFjY291bnRlZCBmb3IgcHJvZ3JhbW1hdGljYWxseS4NCg0KVGhl
biBJIGRvbid0IHRoaW5rIHRoaXMgcGF0Y2ggY291bGQgZml4IHRoZSBpc3N1ZSBQYW9sbyBkaXNj
cmliZWQ/DQoNClRoYW5rcywNCi1LYWkNCg0K

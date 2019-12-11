Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6852119FCD
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 01:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLKAMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 19:12:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:2416 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfLKAMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 19:12:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 16:12:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="413299970"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 10 Dec 2019 16:12:01 -0800
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Dec 2019 16:12:01 -0800
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Dec 2019 16:12:01 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 10 Dec 2019 16:12:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRzgt72GBvTwQw17GA9ovq92U/xerNN9VJi2K6vGst8y/hrvrsX+DZHXywIVyMOD9Jbsk5ebzEzUwNXmntBtWDrsdgNhro+GGLHnEXdHhITX3MSu8NtS6sdAlYfk+oDnoCdLeLR5tB5sbPrIF8PWcLUKcrcGTBW97Fe00x+j8ZWjNhP+REc2xf+IhwcJQdz2w1Kg/feOAY83ZK1t3aGtt8H5gAzS/3xbSHyzJlUzMfZM88ncMX3goGajRL8OuthNF6fgiuUUQCoBO4LDv3Wvqyi4kRrD54AfeYhSZL5Kmbi2+B5WTNQndDhx+QUl3cWAE7EobDKyxMcPzZdUSRtrmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UpIN9rcKkbnex2spnlhT1+WDG9C5tJ+pkEUzdMOjuU=;
 b=Ios4a9bsKRjK1p2G9v/SoQX9uRkXNnhP043YCc3OmfxF492aQpiFYdDF2pt+mABjRbi2eTUvoLPo6XvBW9fu5R3udM6d9ro0AHDwz7qZ6eHUhSMLfT+FoHUhiTO8vn8j7cFp+KdqRs5mKZG4DrpYmfLys19AJrHaDKt2C4GEEN2DmQ3U8M+9MeI9H8N40qT6GupozLPmzK6hW5RO5cI6KLIXYspeZgbfcZb+1mQoqlGIAgFVnVzoeyjDs78kddKFha0r7Ajn2gblAA3xge1Chnx+1rM4kXHyQW0X59fCTkWi2PCpfyq/E41B2/CnIGHk52gUY7vK45Nt0n9VQrexDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UpIN9rcKkbnex2spnlhT1+WDG9C5tJ+pkEUzdMOjuU=;
 b=fIMq6ydEh6arbSgYLAgUG5Wqk/EvWApxc8Ml/dmIqG90I84kqYxFvqg6n4O/zqErpQEKl/Fixn0/F8yu4TqL+qNBUTp1Mm4I4rv/w6P/blgDG4n4gGzt3sIItwCGOx7kaV7fWDtW7Z14fEkLdQA6utFJz4gFnEG+mHHSDnlEA/4=
Received: from CY4PR1101MB2198.namprd11.prod.outlook.com (10.172.78.149) by
 CY4PR1101MB2327.namprd11.prod.outlook.com (10.173.194.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 11 Dec 2019 00:11:59 +0000
Received: from CY4PR1101MB2198.namprd11.prod.outlook.com
 ([fe80::1d41:a622:82f0:201b]) by CY4PR1101MB2198.namprd11.prod.outlook.com
 ([fe80::1d41:a622:82f0:201b%7]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 00:11:59 +0000
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
Thread-Index: AQHVqrlhvKAEwPvqBUOb/a6h3IUJt6eqIY0AgAj+agCAAPmDAA==
Date:   Wed, 11 Dec 2019 00:11:59 +0000
Message-ID: <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
         <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
         <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
In-Reply-To: <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kai.huang@intel.com; 
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c13b8419-0a3a-45fc-0cef-08d77dcebd8a
x-ms-traffictypediagnostic: CY4PR1101MB2327:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2327255D33BD3033EDAEB16FF75A0@CY4PR1101MB2327.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(376002)(346002)(366004)(199004)(189003)(5660300002)(6506007)(71200400001)(66476007)(2906002)(2616005)(26005)(110136005)(6512007)(316002)(6486002)(186003)(54906003)(53546011)(76116006)(91956017)(66446008)(66556008)(64756008)(81156014)(478600001)(8676002)(36756003)(66946007)(81166006)(4001150100001)(8936002)(86362001)(4326008)(60764002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1101MB2327;H:CY4PR1101MB2198.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 439O3ZTFYz/5KylJ6AlLZ+EL0eC1oY/eY71HAJUDp3426DcmxLOm9HfveqxQJyhrbxUhJy1hV5SB4p6b4lwwsZ754O+MnMDmk7LfF/88jL4nbLn6tZryvP7zdB9ghxnJo1xWX/Cr6r1YaI3m2TwzIp38QbulLlQhRxPgY1GQMkFW2SyDDnUtkOlmSjA3Heuwi5+4ZmRGBm3hhfFmtgXRaAKMB55wSNAPBh0omC9lcltdU/P/t78rIvlkSDsg1eGdaJ4Nh3g8Mj3T6KZCIHYDQ6sk0mvaDHdREbcXbL3IW3aMP9XPJK+v6oZ17XcBkUE6zqDH7sMb3VSmBvWk1kWiAOUuFRNqX0qKq4ZBrbeinOsA+ls20Mxfv6D+NFoHG4RJ/GW83IPwLaSXf/vlFrHh2U7q0hNxt8S2cAcZvP2VVYqS8dwVDqybS8FHsTUotrfA4BfgQK9dlFfPbhadwpVoUJ47KwwIVq4GBIK0AXH0xveDXP1GGqRqKca/8xItet+W
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4A63964CC2C1D4692AD3DC29C2C3DF4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c13b8419-0a3a-45fc-0cef-08d77dcebd8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 00:11:59.1061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uA3stECkWtfyESsznErVk8n78PYS1m5BYmqtHU0byi3ToxEP+4z09jgOjcl1yhIzRzw/wO8LT/ey/ppZAGNQmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2327
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDE5LTEyLTEwIGF0IDEwOjE3ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwNC8xMi8xOSAxNjo1NywgVG9tIExlbmRhY2t5IHdyb3RlOg0KPiA+IE9uIDEyLzQvMTkg
OTo0MCBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gPiA+IFRoZSBjb21tZW50IGluIGt2bV9n
ZXRfc2hhZG93X3BoeXNfYml0cyByZWZlcnMgdG8gTUtUTUUsIGJ1dCB0aGUgc2FtZSBpcw0KPiA+
ID4gYWN0dWFsbHkNCj4gPiA+IHRydWUgb2YgU01FIGFuZCBTRVYuICBKdXN0IHVzZSBDUFVJRFsw
eDgwMDBfMDAwOF0uRUFYWzc6MF0gdW5jb25kaXRpb25hbGx5DQo+ID4gPiBpZg0KPiA+ID4gYXZh
aWxhYmxlLCBpdCBpcyBzaW1wbGVzdCBhbmQgd29ya3MgZXZlbiBpZiBtZW1vcnkgaXMgbm90IGVu
Y3J5cHRlZC4NCj4gPiANCj4gPiBUaGlzIGlzbid0IGNvcnJlY3QgZm9yIEFNRC4gVGhlIHJlZHVj
dGlvbiBpbiBwaHlzaWNhbCBhZGRyZXNzaW5nIGlzDQo+ID4gY29ycmVjdC4gWW91IGNhbid0IHNl
dCwgZS5nLiBiaXQgNDUsIGluIHRoZSBuZXN0ZWQgcGFnZSB0YWJsZSwgYmVjYXVzZQ0KPiA+IHRo
YXQgd2lsbCBiZSBjb25zaWRlcmVkIGEgcmVzZXJ2ZWQgYml0IGFuZCBnZW5lcmF0ZSBhbiBOUEYu
IFdoZW4gbWVtb3J5DQo+ID4gZW5jcnlwdGlvbiBpcyBlbmFibGVkIHRvZGF5LCBiaXQgNDcgaXMg
dGhlIGVuY3J5cHRpb24gaW5kaWNhdG9yIGJpdCBhbmQNCj4gPiBiaXRzIDQ2OjQzIG11c3QgYmUg
emVybyBvciBlbHNlIGFuIE5QRiBpcyBnZW5lcmF0ZWQuIFRoZSBoYXJkd2FyZSB1c2VzDQo+ID4g
dGhlc2UgYml0cyBpbnRlcm5hbGx5IGJhc2VkIG9uIHRoZSB3aGV0aGVyIHJ1bm5pbmcgYXMgdGhl
IGh5cGVydmlzb3Igb3INCj4gPiBiYXNlZCBvbiB0aGUgQVNJRCBvZiB0aGUgZ3Vlc3QuDQo+IA0K
PiBrdm1fZ2V0X3NoYWRvd19waHlzX2JpdHMoKSBtdXN0IGJlIGNvbnNlcnZhdGl2ZSBpbiB0aGF0
Og0KPiANCj4gMSkgaWYgYSBiaXQgaXMgcmVzZXJ2ZWQgaXQgX2Nhbl8gcmV0dXJuIGEgdmFsdWUg
aGlnaGVyIHRoYW4gaXRzIGluZGV4DQo+IA0KPiAyKSBpZiBhIGJpdCBpcyB1c2VkIGJ5IHRoZSBw
cm9jZXNzb3IgKGZvciBwaHlzaWNhbCBhZGRyZXNzIG9yIGFueXRoaW5nDQo+IGVsc2UpIGl0IF9t
dXN0XyByZXR1cm4gYSB2YWx1ZSBoaWdoZXIgdGhhbiBpdHMgaW5kZXguDQo+IA0KPiBJbiB0aGUg
U0VWIGNhc2Ugd2UncmUgbm90IG9iZXlpbmcgKDIpLCBiZWNhdXNlIHRoZSBmdW5jdGlvbiByZXR1
cm5zIDQzDQo+IHdoZW4gdGhlIEMgYml0IGlzIGJpdCA0Ny4gIFRoZSBwYXRjaCBmaXhlcyB0aGF0
Lg0KDQpDb3VsZCB3ZSBndWFyYW50ZWUgdGhhdCBDLWJpdCBpcyBhbHdheXMgYmVsb3cgYml0cyBy
ZXBvcnRlZCBieSBDUFVJRD8NCg0KVGhhbmtzLA0KLUthaQ0KPiANCj4gUGFvbG8NCj4gDQo+ID4g
VGhhbmtzLA0KPiA+IFRvbQ0KPiA+IA0KPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiA+IFJlcG9ydGVkLWJ5OiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29t
Pg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNv
bT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gveDg2L2t2bS9tbXUvbW11LmMgfCAyMCArKysrKysr
KysrKystLS0tLS0tLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21t
dS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gPiA+IGluZGV4IDZmOTJiNDBkNzk4
Yy4uMWU0ZWU0ZjhkZTVmIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS9tbXUu
Yw0KPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiA+ID4gQEAgLTUzOCwxNiAr
NTM4LDIwIEBAIHZvaWQga3ZtX21tdV9zZXRfbWFza19wdGVzKHU2NCB1c2VyX21hc2ssIHU2NA0K
PiA+ID4gYWNjZXNzZWRfbWFzaywNCj4gPiA+ICBzdGF0aWMgdTgga3ZtX2dldF9zaGFkb3dfcGh5
c19iaXRzKHZvaWQpDQo+ID4gPiAgew0KPiA+ID4gIAkvKg0KPiA+ID4gLQkgKiBib290X2NwdV9k
YXRhLng4Nl9waHlzX2JpdHMgaXMgcmVkdWNlZCB3aGVuIE1LVE1FIGlzIGRldGVjdGVkDQo+ID4g
PiAtCSAqIGluIENQVSBkZXRlY3Rpb24gY29kZSwgYnV0IE1LVE1FIHRyZWF0cyB0aG9zZSByZWR1
Y2VkIGJpdHMgYXMNCj4gPiA+IC0JICogJ2tleUlEJyB0aHVzIHRoZXkgYXJlIG5vdCByZXNlcnZl
ZCBiaXRzLiBUaGVyZWZvcmUgZm9yIE1LVE1FDQo+ID4gPiAtCSAqIHdlIHNob3VsZCBzdGlsbCBy
ZXR1cm4gcGh5c2ljYWwgYWRkcmVzcyBiaXRzIHJlcG9ydGVkIGJ5IENQVUlELg0KPiA+ID4gKwkg
KiBib290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHMgaXMgcmVkdWNlZCB3aGVuIE1LVE1FIG9yIFNN
RSBhcmUgZGV0ZWN0ZWQNCj4gPiA+ICsJICogaW4gQ1BVIGRldGVjdGlvbiBjb2RlLCBidXQgdGhl
IHByb2Nlc3NvciB0cmVhdHMgdGhvc2UgcmVkdWNlZCBiaXRzIGFzDQo+ID4gPiArCSAqICdrZXlJ
RCcgdGh1cyB0aGV5IGFyZSBub3QgcmVzZXJ2ZWQgYml0cy4gVGhlcmVmb3JlIEtWTSBuZWVkcyB0
byBsb29rDQo+ID4gPiBhdA0KPiA+ID4gKwkgKiB0aGUgcGh5c2ljYWwgYWRkcmVzcyBiaXRzIHJl
cG9ydGVkIGJ5IENQVUlELg0KPiA+ID4gIAkgKi8NCj4gPiA+IC0JaWYgKCFib290X2NwdV9oYXMo
WDg2X0ZFQVRVUkVfVE1FKSB8fA0KPiA+ID4gLQkgICAgV0FSTl9PTl9PTkNFKGJvb3RfY3B1X2Rh
dGEuZXh0ZW5kZWRfY3B1aWRfbGV2ZWwgPCAweDgwMDAwMDA4KSkNCj4gPiA+IC0JCXJldHVybiBi
b290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHM7DQo+ID4gPiArCWlmIChsaWtlbHkoYm9vdF9jcHVf
ZGF0YS5leHRlbmRlZF9jcHVpZF9sZXZlbCA+PSAweDgwMDAwMDA4KSkNCj4gPiA+ICsJCXJldHVy
biBjcHVpZF9lYXgoMHg4MDAwMDAwOCkgJiAweGZmOw0KPiA+ID4gIA0KPiA+ID4gLQlyZXR1cm4g
Y3B1aWRfZWF4KDB4ODAwMDAwMDgpICYgMHhmZjsNCj4gPiA+ICsJLyoNCj4gPiA+ICsJICogUXVp
dGUgd2VpcmQgdG8gaGF2ZSBWTVggb3IgU1ZNIGJ1dCBub3QgTUFYUEhZQUREUjsgcHJvYmFibHkg
YSBWTSB3aXRoDQo+ID4gPiArCSAqIGN1c3RvbSBDUFVJRC4gIFByb2NlZWQgd2l0aCB3aGF0ZXZl
ciB0aGUga2VybmVsIGZvdW5kIHNpbmNlIHRoZXNlDQo+ID4gPiBmZWF0dXJlcw0KPiA+ID4gKwkg
KiBhcmVuJ3QgdmlydHVhbGl6YWJsZSAoU01FL1NFViBhbHNvIHJlcXVpcmUgQ1BVSURzIGhpZ2hl
ciB0aGFuDQo+ID4gPiAweDgwMDAwMDA4KS4NCj4gPiA+ICsJICovDQo+ID4gPiArCXJldHVybiBi
b290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHM7DQo+ID4gPiAgfQ0KPiA+ID4gIA0KPiA+ID4gIHN0
YXRpYyB2b2lkIGt2bV9tbXVfcmVzZXRfYWxsX3B0ZV9tYXNrcyh2b2lkKQ0KPiA+ID4gDQo=

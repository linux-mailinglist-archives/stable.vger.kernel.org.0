Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED13117E91
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 04:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLJDxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 22:53:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:65172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfLJDxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 22:53:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 19:53:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="387464574"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga005.jf.intel.com with ESMTP; 09 Dec 2019 19:53:13 -0800
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Dec 2019 19:53:12 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 9 Dec 2019 19:53:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/YOvnYcRCAGDlmGpRrAqybhXVAhk9J4UWm8eo5rowqDQbPe8bqVfiWaUrqYqOemmmd+3itbTdFRQuMbl9EZ3ytEKvQSG13UjosaYi3DW52CnOK7ti78/G2sIopH603C1QeEGuGRQApEHSgmp3f5V18IaMEEnmk7xMrVnv/zdrAgt4Md4KORvFQ+sVP9cnNmY15t9v4wvz8wY2vY7NW1+2x3edZzjepdzcDzjcKY8LXlC/J1agGP0zh8wTdOYstmA5+mQyd5FkisOxbbixj/UPtFkZd3a5NyrSxIBMZRhL1CArLTYtdnTfFHeO/KG/pbg/Y2HcoVsUBXKtqQeT+/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji83TMUSxuJgFyenbEiAza2DcYXoDMZJJjsJWycbD3g=;
 b=XOfGXjVQsxoCSeR02OEyCu8cwP09LQc7AZNYqkXqoa5uvlFEmYwuxt5a8XGPZ+eLpQQzC2/SYcyM1CzuFZIDd6vSS1jjhYzf9XSnlNZ7GPkUcCiq1qERNIwEIH6OqFbJKfrn10/lwZU87noLolaP5coTRM0r4hfXFAtejhUr2zajwbJBnKX26W6OAACu1okW5VK2ZhLKlyN42f01B5DMWgZTsskIP12vN0eXJ2tk7aMGINeWKTZ6EIELAhuuQ6fZZAqC8HFvE/3WdLxlwVtfcSAKWuzbN4pM+V+dZf6UDb1xkTQwPGgcbLVq5k1t+X3EgXbvsZ1xyz1/8qwRLprWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji83TMUSxuJgFyenbEiAza2DcYXoDMZJJjsJWycbD3g=;
 b=CeyU/+FX3P55kEg+H89efRNVzIcEGRvjWzPy/TW2OtotmjwU9TfnrOXVaxgtwk5mLHIV4ACXNet287lkVxcX3lmwn0vCn+/F/Fpv397aPzIbgMcPGwewYJf4YwDj3wHAJ4b5aPxBrMdqkg+L9DrjAirluZKGu/noWMoimUnBxeI=
Received: from CY4PR1101MB2198.namprd11.prod.outlook.com (10.172.78.149) by
 CY4PR1101MB2216.namprd11.prod.outlook.com (10.174.54.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Tue, 10 Dec 2019 03:53:11 +0000
Received: from CY4PR1101MB2198.namprd11.prod.outlook.com
 ([fe80::1d41:a622:82f0:201b]) by CY4PR1101MB2198.namprd11.prod.outlook.com
 ([fe80::1d41:a622:82f0:201b%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 03:53:10 +0000
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
Thread-Index: AQHVqrlhvKAEwPvqBUOb/a6h3IUJt6eqIY0AgAijqwA=
Date:   Tue, 10 Dec 2019 03:53:10 +0000
Message-ID: <2f3d8c9b146301183b891d8a441aa4a5c33b4c9d.camel@intel.com>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
         <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
In-Reply-To: <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kai.huang@intel.com; 
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5192c9e4-0c3a-47e8-5f70-08d77d247997
x-ms-traffictypediagnostic: CY4PR1101MB2216:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2216B240BB553E9167183499F75B0@CY4PR1101MB2216.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(346002)(39860400002)(366004)(199004)(189003)(54906003)(2906002)(305945005)(66946007)(8936002)(53546011)(6506007)(186003)(229853002)(110136005)(86362001)(5660300002)(118296001)(2616005)(316002)(36756003)(76116006)(26005)(91956017)(66556008)(71200400001)(66446008)(64756008)(71190400001)(66476007)(6512007)(8676002)(478600001)(6486002)(4326008)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1101MB2216;H:CY4PR1101MB2198.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d1Bad84i6eq+bZ6J25AR7D8q3teYiIWhpOYNSPS3u0L5xjScgHhE2XuuH+pHH+fi8/K/CN8P2uouwFA8Aipxlp0BT5Scttj6qcc5/g3T5M7LvWi3sj2JDoU3a/jJ8s4cVEqOn7907wJmnjUuztRKkR2GuY8dgOZAx+HREiUc+M+474xzeGQjSTFgycPWqLjRUmUs/B7Pl7n1oYMnPbDY3ut34pv9TqkKl3WVyii1I9it3oURjGuT9qa6HY4e/6rjyn+oCjGXTgwigOTC0S7EAt3g+fYLJPU5vUgHP1Oa6MbESzh7wpK2DVrIRlfx3etOkdOXPObV02XDCdzh+atc/CS6ItX0B4CG6EZFbZUJaYFjxmzd0ifW/YX2c2BaDarxxfqYeve2n7OPekQQcqtyIkH6LaQG5M6UHEp+4YYxl7qpc5F5t1bX/dKdQPCqsQko
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC133DA9D1FEF34FA39BB30D5E71860A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5192c9e4-0c3a-47e8-5f70-08d77d247997
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:53:10.6973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6wA0V36FZKxoeDdTu2KXfYF2mTLvL42fiDqEoaWY7xlrm7pWvh/2j0oQUUDqKIUs37vXQC9Gl9KpGln+D9EAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2216
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTA0IGF0IDA5OjU3IC0wNjAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDEyLzQvMTkgOTo0MCBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gPiBUaGUgY29tbWVu
dCBpbiBrdm1fZ2V0X3NoYWRvd19waHlzX2JpdHMgcmVmZXJzIHRvIE1LVE1FLCBidXQgdGhlIHNh
bWUgaXMNCj4gPiBhY3R1YWxseQ0KPiA+IHRydWUgb2YgU01FIGFuZCBTRVYuICBKdXN0IHVzZSBD
UFVJRFsweDgwMDBfMDAwOF0uRUFYWzc6MF0gdW5jb25kaXRpb25hbGx5DQo+ID4gaWYNCj4gPiBh
dmFpbGFibGUsIGl0IGlzIHNpbXBsZXN0IGFuZCB3b3JrcyBldmVuIGlmIG1lbW9yeSBpcyBub3Qg
ZW5jcnlwdGVkLg0KPiANCj4gVGhpcyBpc24ndCBjb3JyZWN0IGZvciBBTUQuIFRoZSByZWR1Y3Rp
b24gaW4gcGh5c2ljYWwgYWRkcmVzc2luZyBpcw0KPiBjb3JyZWN0LiBZb3UgY2FuJ3Qgc2V0LCBl
LmcuIGJpdCA0NSwgaW4gdGhlIG5lc3RlZCBwYWdlIHRhYmxlLCBiZWNhdXNlDQo+IHRoYXQgd2ls
bCBiZSBjb25zaWRlcmVkIGEgcmVzZXJ2ZWQgYml0IGFuZCBnZW5lcmF0ZSBhbiBOUEYuIFdoZW4g
bWVtb3J5DQo+IGVuY3J5cHRpb24gaXMgZW5hYmxlZCB0b2RheSwgYml0IDQ3IGlzIHRoZSBlbmNy
eXB0aW9uIGluZGljYXRvciBiaXQgYW5kDQo+IGJpdHMgNDY6NDMgbXVzdCBiZSB6ZXJvIG9yIGVs
c2UgYW4gTlBGIGlzIGdlbmVyYXRlZC4gVGhlIGhhcmR3YXJlIHVzZXMNCj4gdGhlc2UgYml0cyBp
bnRlcm5hbGx5IGJhc2VkIG9uIHRoZSB3aGV0aGVyIHJ1bm5pbmcgYXMgdGhlIGh5cGVydmlzb3Ig
b3INCj4gYmFzZWQgb24gdGhlIEFTSUQgb2YgdGhlIGd1ZXN0Lg0KDQpSaWdodC4gQWxnaG91dGgg
Ym90aCBNS1RNRSBhbmQgU01FL1NFViByZWR1Y2UgcGh5c2ljYWwgYml0cywgYnV0IHRoZXkgdHJl
YXQNCnRob3NlIHJlZHVjZWQgYml0cyBkaWZmZXJlbnRseTogTUtUTUUgdHJlYXRzIHRob3NlIGFz
IGtleUlEIHRodXMgdGhleSBjYW4gYmUNCnNldCwgYnV0IFNNRS9TRVYgdHJlYXRzIHRob3NlIGFz
IHJlc2VydmVkIGJpdHMgc28geW91IGNhbm5vdCBzZXQgYW55IG9mIHRoZW0uDQoNCk1heWJlIHRo
ZSBuYW1pbmcgb2Ygc2hhZG93X3BoeXNfYml0cyBpcyBhIGxpdHRsZSBiaXQgY29uZnVzaW5nIGhl
cmUuIFRoZSBwdXJwb3NlDQpvZiBpdCB3YXMgdG8gZGV0ZXJtaW5lIGZpcnN0IHJlc2VydmVkIGJp
dHMsIGJ1dCBub3QgYWN0dWFsIHBoeXNpY2FsIGFkZHJlc3MgYml0cw0KLiBUaGVyZWZvcmUgZm9y
IE1LVE1FIGl0IHNob3VsZCBpbmNsdWRlIHRoZSBrZXlJRCBiaXRzLCBidXQgZm9yIFNNRS9TRVYg
aXQNCnNob3VsZCBub3QuDQoNClRoYW5rcywNCi1LYWkNCj4gDQo+IFRoYW5rcywNCj4gVG9tDQo+
IA0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gUmVwb3J0ZWQtYnk6IFRvbSBM
ZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGFv
bG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYv
a3ZtL21tdS9tbXUuYyB8IDIwICsrKysrKysrKysrKy0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAxMiBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiA+
IGluZGV4IDZmOTJiNDBkNzk4Yy4uMWU0ZWU0ZjhkZTVmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gv
eDg2L2t2bS9tbXUvbW11LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ID4g
QEAgLTUzOCwxNiArNTM4LDIwIEBAIHZvaWQga3ZtX21tdV9zZXRfbWFza19wdGVzKHU2NCB1c2Vy
X21hc2ssIHU2NA0KPiA+IGFjY2Vzc2VkX21hc2ssDQo+ID4gIHN0YXRpYyB1OCBrdm1fZ2V0X3No
YWRvd19waHlzX2JpdHModm9pZCkNCj4gPiAgew0KPiA+ICAJLyoNCj4gPiAtCSAqIGJvb3RfY3B1
X2RhdGEueDg2X3BoeXNfYml0cyBpcyByZWR1Y2VkIHdoZW4gTUtUTUUgaXMgZGV0ZWN0ZWQNCj4g
PiAtCSAqIGluIENQVSBkZXRlY3Rpb24gY29kZSwgYnV0IE1LVE1FIHRyZWF0cyB0aG9zZSByZWR1
Y2VkIGJpdHMgYXMNCj4gPiAtCSAqICdrZXlJRCcgdGh1cyB0aGV5IGFyZSBub3QgcmVzZXJ2ZWQg
Yml0cy4gVGhlcmVmb3JlIGZvciBNS1RNRQ0KPiA+IC0JICogd2Ugc2hvdWxkIHN0aWxsIHJldHVy
biBwaHlzaWNhbCBhZGRyZXNzIGJpdHMgcmVwb3J0ZWQgYnkgQ1BVSUQuDQo+ID4gKwkgKiBib290
X2NwdV9kYXRhLng4Nl9waHlzX2JpdHMgaXMgcmVkdWNlZCB3aGVuIE1LVE1FIG9yIFNNRSBhcmUg
ZGV0ZWN0ZWQNCj4gPiArCSAqIGluIENQVSBkZXRlY3Rpb24gY29kZSwgYnV0IHRoZSBwcm9jZXNz
b3IgdHJlYXRzIHRob3NlIHJlZHVjZWQgYml0cyBhcw0KPiA+ICsJICogJ2tleUlEJyB0aHVzIHRo
ZXkgYXJlIG5vdCByZXNlcnZlZCBiaXRzLiBUaGVyZWZvcmUgS1ZNIG5lZWRzIHRvIGxvb2sNCj4g
PiBhdA0KPiA+ICsJICogdGhlIHBoeXNpY2FsIGFkZHJlc3MgYml0cyByZXBvcnRlZCBieSBDUFVJ
RC4NCj4gPiAgCSAqLw0KPiA+IC0JaWYgKCFib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfVE1FKSB8
fA0KPiA+IC0JICAgIFdBUk5fT05fT05DRShib290X2NwdV9kYXRhLmV4dGVuZGVkX2NwdWlkX2xl
dmVsIDwgMHg4MDAwMDAwOCkpDQo+ID4gLQkJcmV0dXJuIGJvb3RfY3B1X2RhdGEueDg2X3BoeXNf
Yml0czsNCj4gPiArCWlmIChsaWtlbHkoYm9vdF9jcHVfZGF0YS5leHRlbmRlZF9jcHVpZF9sZXZl
bCA+PSAweDgwMDAwMDA4KSkNCj4gPiArCQlyZXR1cm4gY3B1aWRfZWF4KDB4ODAwMDAwMDgpICYg
MHhmZjsNCj4gPiAgDQo+ID4gLQlyZXR1cm4gY3B1aWRfZWF4KDB4ODAwMDAwMDgpICYgMHhmZjsN
Cj4gPiArCS8qDQo+ID4gKwkgKiBRdWl0ZSB3ZWlyZCB0byBoYXZlIFZNWCBvciBTVk0gYnV0IG5v
dCBNQVhQSFlBRERSOyBwcm9iYWJseSBhIFZNIHdpdGgNCj4gPiArCSAqIGN1c3RvbSBDUFVJRC4g
IFByb2NlZWQgd2l0aCB3aGF0ZXZlciB0aGUga2VybmVsIGZvdW5kIHNpbmNlIHRoZXNlDQo+ID4g
ZmVhdHVyZXMNCj4gPiArCSAqIGFyZW4ndCB2aXJ0dWFsaXphYmxlIChTTUUvU0VWIGFsc28gcmVx
dWlyZSBDUFVJRHMgaGlnaGVyIHRoYW4NCj4gPiAweDgwMDAwMDA4KS4NCj4gPiArCSAqLw0KPiA+
ICsJcmV0dXJuIGJvb3RfY3B1X2RhdGEueDg2X3BoeXNfYml0czsNCj4gPiAgfQ0KPiA+ICANCj4g
PiAgc3RhdGljIHZvaWQga3ZtX21tdV9yZXNldF9hbGxfcHRlX21hc2tzKHZvaWQpDQo+ID4gDQo=

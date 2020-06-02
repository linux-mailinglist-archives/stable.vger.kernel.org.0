Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BAC1EB283
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 02:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgFBADL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 20:03:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:22397 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgFBADK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 20:03:10 -0400
IronPort-SDR: exe1MEBPHI/HpJqYNqsVZGL4pkYbxXPfCZzia4cmdPLhZNJ+u3KX1LcuQrdIZQSWW+K75MKNlI
 sSfziEcXV6eQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 17:03:00 -0700
IronPort-SDR: kMJ8HfHiybXRw+wB603vAZFzSUhgTJcrY7SX6r1wHG+aFebvM4sjQkk82vUW4LwBY72Ro0oLxZ
 MTD8TyT0VDdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,462,1583222400"; 
   d="scan'208";a="415977918"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 01 Jun 2020 17:03:00 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jun 2020 17:02:59 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jun 2020 17:02:59 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 1 Jun 2020 17:02:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MB8aWAMKnr4I8/noP790VGAEX4brFXSrwm4NtSJlbjv5Nk1tSEn3eBuDvEJMWvyyhAEdu48gKU41IR0x74U/S6zxOvNVYTWE2rvuX2AkpcHZNbP62OeauNus7t0o4eBz7gF7DMyhE8bijQhBC5Sk0rG0nD+hIq6jTiTGfTWtkPsyHule154/8kn9o095L4v6tyswzZYTsHRHX/WtcrZHexDGTjGl4MDr4KQsGTbqgovQ5ZhtD9COmcuyE725Je/UMln8IOvJKo5h3BNkWfPBcgWd8qShbYTwKTnTEn6lzTR4K1DUpjxNNm7Mhp+UqU/losNajZNnvrEZv4cZeMEAYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5vRugMpDMTGoy0NIlVHMgLtH2AWqcBSeCZbHE7LgiU=;
 b=hooL0OoLiuSVDo5bbIdzE9Yg2ivs8N15JEC4QBRN4UFqwJ0tpnTUGq8SUm1lEkS33FAIAlq399X3fmtTuIfxPb9xekndEV89ZLKM15A5Xn0ewMaUU2GXj8004Q0lZB4pgvHaYeFkBMPf9RxcxmmTGCzCCciLENe+z72xe6kCLiYkOrjRYEBmeDZT+uSNSBL0bj4LQ48oaQknHy+qhfdN1Je1ci2zEn3Z2IZ0xG1j7AhD7GKORbPhocYW7Glvq+GwJrNNbL1avyj4beV/PD11Wg0WG7LxVo/iZrpgcWRWlKyQQO6TWe9ZXVgIGaqsdrGZHRkmA4p8yCf5uIZxkMRDPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5vRugMpDMTGoy0NIlVHMgLtH2AWqcBSeCZbHE7LgiU=;
 b=PbqBSY5rG+7DDdvn45ftP/M2ywSm7ql6pczj4+c2cjlAwFKMvERPYkE1Plyda6RT8cXh3Qdib3jgR3ExT/R/k/gRAG8rcoZeqIQhn7CtKBVe4ylOvY3CjZHez/3ci51Sbj/iPr9VgCj2pmmLXnfd2UHxfKEyID29Ux27fODCd0w=
Received: from BYAPR11MB3096.namprd11.prod.outlook.com (2603:10b6:a03:8f::14)
 by BYAPR11MB3381.namprd11.prod.outlook.com (2603:10b6:a03:79::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Tue, 2 Jun
 2020 00:02:57 +0000
Received: from BYAPR11MB3096.namprd11.prod.outlook.com
 ([fe80::ad0c:c6a9:6f39:eb92]) by BYAPR11MB3096.namprd11.prod.outlook.com
 ([fe80::ad0c:c6a9:6f39:eb92%5]) with mapi id 15.20.3045.022; Tue, 2 Jun 2020
 00:02:57 +0000
From:   "Kaneda, Erik" <erik.kaneda@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "glider@google.com" <glider@google.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pcc@google.com" <pcc@google.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "will@kernel.org" <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
Thread-Topic: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
Thread-Index: AQHWOGr94BDOASQdIU6ZpTv243EHY6jEbrjQ
Date:   Tue, 2 Jun 2020 00:02:57 +0000
Message-ID: <BYAPR11MB30969737340044437013BF44F08B0@BYAPR11MB3096.namprd11.prod.outlook.com>
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com>
In-Reply-To: <20200601231805.207441-1-ndesaulniers@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fba82de-efd4-4a16-9294-08d806884e6c
x-ms-traffictypediagnostic: BYAPR11MB3381:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB33813357708918C5A06FB5B5F08B0@BYAPR11MB3381.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uO1EJd5Um2XyhnWCxxMWYR37XskB0N0MrnZZpB+XfkpXzqzt1z252hSbEGzo8HE20agxf9Hw9j0uWdHe7U+Y7JC8+k/HiYJOofDenYe4Pb9H70iiZRk0832jxU7e9kQ7oppFPrLhbDHy08LEgMdYJOIUL++MxTHaSKKeS3wHiiSH2pAKS1M3AAuRhk7ZrskTSZC9xq2QGwLAdwRDWlpgCriH/5yRytXHv6UYhGcHyEOtjAtAIZ1hnJPbF0GQFiQWBlbJYFnvJGhnMLEgMvj7DQ9c3SF3cPO5YpdJFu/jL+PCzr7UsC0em4ZVLVeg49GVjTCMPfPo+oKZoMrt0OlbwFBQm7ArBRsrtHeUpv/2dSyHuEB+ILwIS7/AWLwuQKlbByooXB94qAr/1kREqsUXsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3096.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(366004)(39860400002)(376002)(186003)(54906003)(52536014)(86362001)(110136005)(966005)(478600001)(7696005)(2906002)(55016002)(33656002)(26005)(7416002)(5660300002)(83380400001)(8676002)(66556008)(4326008)(8936002)(71200400001)(6506007)(66946007)(76116006)(64756008)(53546011)(66446008)(9686003)(66476007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2JA2M9A7W0OAj0VlJ0VilGJOddfjq1MZThC/8CNQgYw0jKnxOohSHQ3XeW6YPD3dQf0Lj0KSKPbJ5p4VakhfxhXhepR34b55eHUWeeDpNgyCtnJHd2xFbIVaruE6/PKFoNYykQhz0MDdarW5NJmIHzruokH/A9b3UcmUV0kto/hfwNk4b769sz5B9Z8A1ntybfrZ55Jjww9rAzZXqie43mP8/je7HTrm5uqQ0HLOnu70tYDvRO0LhSLuG4kff2v8cNap7LL8PzTrmcYWR8++fkKUnlGi+kwuu9O9USEMliYXD0CG9//Jg8aHOwaagFT0rghs+PZHW2BZmugUfN7QeLU1ubruuf0pCS1FWv4o+BJdMr2/1Cj1/ATOzYCckR3g0badf/cjsfMD3vMUqr3jlS3JfPub5vFb5y+eLdqDwPhhsPpI6OIxeTQfAhky++DsUv3vrNvAMOxI+J0uAuZ8Pt0KgiRqIHk8tlyY9JUE99LqfL2d/vAs0PF2yeYsWx0v
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fba82de-efd4-4a16-9294-08d806884e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 00:02:57.1903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JVfgzrLtx248ry6ls/AgwEY0LOY8SNLRxXSW6EuGVJKpxNrLqPn8fugYt6lkMeu4mt6XABWtU0vM7BtiN7UXkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3381
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTmljayBEZXNhdWxuaWVy
cyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSnVuZSAxLCAyMDIw
IDQ6MTggUE0NCj4gVG86IE1vb3JlLCBSb2JlcnQgPHJvYmVydC5tb29yZUBpbnRlbC5jb20+OyBL
YW5lZGEsIEVyaWsNCj4gPGVyaWsua2FuZWRhQGludGVsLmNvbT47IFd5c29ja2ksIFJhZmFlbCBK
IDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT47DQo+IExlbiBCcm93biA8bGVuYkBrZXJuZWwu
b3JnPg0KPiBDYzogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz47IGR2eXVrb3ZAZ29v
Z2xlLmNvbTsNCj4gZ2xpZGVyQGdvb2dsZS5jb207IGd1b2hhbmp1bkBodWF3ZWkuY29tOyBsaW51
eC1hcm0tDQo+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOw0KPiBsb3JlbnpvLnBpZXJhbGlzaUBhcm0uY29tOyBtYXJrLnJ1dGxhbmRAYXJt
LmNvbTsNCj4gbmRlc2F1bG5pZXJzQGdvb2dsZS5jb207IHBjY0Bnb29nbGUuY29tOyByandAcmp3
eXNvY2tpLm5ldDsNCj4gd2lsbEBrZXJuZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1hY3BpQHZnZXIua2VybmVsLm9yZzsNCj4gZGV2ZWxAYWNwaWNhLm9yZw0KPiBTdWJqZWN0
OiBbUEFUQ0hdIEFDUElDQTogZml4IFVCU0FOIHdhcm5pbmcgdXNpbmcgX19idWlsdGluX29mZnNl
dG9mDQo+DQpIaSwNCiANCj4gV2lsbCByZXBvcnRlZCBVQlNBTiB3YXJuaW5nczoNCj4gVUJTQU46
IG51bGwtcHRyLWRlcmVmIGluIGRyaXZlcnMvYWNwaS9hY3BpY2EvdGJmYWR0LmM6NDU5OjM3DQo+
IFVCU0FOOiBudWxsLXB0ci1kZXJlZiBpbiBhcmNoL2FybTY0L2tlcm5lbC9zbXAuYzo1OTY6Ng0K
PiANCj4gTG9va3MgbGlrZSB0aGUgZW11bGF0ZWQgb2Zmc2V0b2YgbWFjcm8gQUNQSV9PRkZTRVQg
aXMgY2F1c2luZyB0aGVzZS4gV2UNCj4gY2FuIGF2b2lkIHRoaXMgYnkgdXNpbmcgdGhlIGNvbXBp
bGVyIGJ1aWx0aW4sIF9fYnVpbHRpbl9vZmZzZXRvZi4NCg0KSSdsbCB0YWtlIGEgbG9vayBhdCB0
aGlzIHRvbW9ycm93DQo+IA0KPiBUaGUgbm9uLWtlcm5lbCBydW50aW1lIG9mIFVCU0FOIHdvdWxk
IHByaW50Og0KPiBydW50aW1lIGVycm9yOiBtZW1iZXIgYWNjZXNzIHdpdGhpbiBudWxsIHBvaW50
ZXIgb2YgdHlwZSBmb3IgdGhpcyBtYWNyby4NCg0KYWN0eXBlcy5oIGlzIG93bmVkIGJ5IEFDUElD
QSBzbyB3ZSB0eXBpY2FsbHkgZG8gbm90IGFsbG93IGNvbXBpbGVyLXNwZWNpZmljDQpleHRlbnNp
b25zIGJlY2F1c2UgdGhlIGNvZGUgaXMgaW50ZW5kZWQgdG8gYmUgY29tcGlsZWQgdXNpbmcgdGhl
IEM5OSBzdGFuZGFyZA0Kd2l0aG91dCBjb21waWxlciBleHRlbnNpb25zLiBXZSBjb3VsZCBhbGxv
dyB0aGlzIHNvcnQgb2YgdGhpbmcgaW4gYSBMaW51eC1zcGVjaWZpYw0KaGVhZGVyIGZpbGUgbGlr
ZSBpbmNsdWRlL2FjcGkvcGxhdGZvcm0vYWNsaW51eC5oIGJ1dCBJJ2xsIHRha2UgYSBsb29rIGF0
IHRoZSBlcnJvciBhcyB3ZWxsLi4NCg0KRXJpaw0KPiANCj4gTGluazogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC8yMDIwMDUyMTEwMDk1Mi5HQTUzNjBAd2lsbGllLXRoZS10cnVjay8NCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gUmVwb3J0ZWQtYnk6IFdpbGwgRGVhY29uIDx3
aWxsQGtlcm5lbC5vcmc+DQo+IFN1Z2dlc3RlZC1ieTogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2Vy
bmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJz
QGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS9hY3BpL2FjdHlwZXMuaCB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvYWNwaS9hY3R5cGVzLmggYi9pbmNsdWRlL2FjcGkvYWN0eXBlcy5o
IGluZGV4DQo+IDRkZWZlZDU4ZWEzMy4uMDQzNTljNzBiMTk4IDEwMDY0NA0KPiAtLS0gYS9pbmNs
dWRlL2FjcGkvYWN0eXBlcy5oDQo+ICsrKyBiL2luY2x1ZGUvYWNwaS9hY3R5cGVzLmgNCj4gQEAg
LTUwOCw3ICs1MDgsNyBAQCB0eXBlZGVmIHU2NCBhY3BpX2ludGVnZXI7DQo+IA0KPiAgI2RlZmlu
ZSBBQ1BJX1RPX1BPSU5URVIoaSkgICAgICAgICAgICAgIEFDUElfQ0FTVF9QVFIgKHZvaWQsIChh
Y3BpX3NpemUpIChpKSkNCj4gICNkZWZpbmUgQUNQSV9UT19JTlRFR0VSKHApICAgICAgICAgICAg
ICBBQ1BJX1BUUl9ESUZGIChwLCAodm9pZCAqKSAwKQ0KPiAtI2RlZmluZSBBQ1BJX09GRlNFVChk
LCBmKSAgICAgICAgICAgICAgIEFDUElfUFRSX0RJRkYgKCYoKChkICopIDApLT5mKSwgKHZvaWQg
KikNCj4gMCkNCj4gKyNkZWZpbmUgQUNQSV9PRkZTRVQoZCwgZikgICAgICAgICAgICAgICBfX2J1
aWx0aW5fb2Zmc2V0b2YoZCwgZikNCj4gICNkZWZpbmUgQUNQSV9QSFlTQUREUl9UT19QVFIoaSkg
ICAgICAgICBBQ1BJX1RPX1BPSU5URVIoaSkNCj4gICNkZWZpbmUgQUNQSV9QVFJfVE9fUEhZU0FE
RFIoaSkgICAgICAgICBBQ1BJX1RPX0lOVEVHRVIoaSkNCj4gDQo+IC0tDQo+IDIuMjcuMC5yYzIu
MjUxLmc5MDczN2JlYjgyNS1nb29nDQoNCg==

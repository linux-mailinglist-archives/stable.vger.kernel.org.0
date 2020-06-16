Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22DF1FC111
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 23:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFPVja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 17:39:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:57570 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgFPVja (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 17:39:30 -0400
IronPort-SDR: T4awciG1w0s6lVHwUlYU4Qh6QiY5/n7f4zBut9tiwAaKf7sh+zYX8pN56cYDswZSZPK2SOjU0F
 MT1uWGFebMpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 14:39:27 -0700
IronPort-SDR: XBRSy3osg+2PPiaQluZ+snIRz3oDMTqx+SMcd3CutmyuW6M3pcjJUQxKaO7D/KEWcJoX0hsDm3
 QTaiX2ODyQsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,519,1583222400"; 
   d="scan'208";a="308589653"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2020 14:39:27 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jun 2020 14:39:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 16 Jun 2020 14:39:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7uAcNSC5b0i9qwSUhHX6Lsp86QxFgRxC7Zz0mVuPx8IoX4NXCrud4tQnkYiwC5+MFgJPrQelVTbAXWvXTIqy0Dn5nb8G7nWT2QwpnDjkulSobKpuob3kumU2FkQRzTFrNtELFW0gPFRk0G9IKhZ22DHWzK+1/CpmO8nTndZRSJ0RjIzX6qpgikF1MGLogjeDWavf8V7xQNvUfBar/K90J15kjzG4/j4wgPudw2iNAWIiapgPFSQFGL7eyRCGNizHgzpL4ACldEEQzdDlWX5eyBWyPKKribIfjhCbNsQnTDlc/19yL9wuE568b1PGO8ap3v/ymFbr8G9coh/WcS9WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKhzYrH7L9Wp83NpiMD9toE2NmxOXgLSXKWyEXDxHCE=;
 b=W2FDhSO4DE7DN1ORwbMZGrC5zzcCB23EbG0u0gJA4mOLYM9YLwzrbtQYJmWg9xRRhXGkywGp7j++9zXE5ltweuTrVA1DAi3ieCFNIRprfxsrUYC4ltE1KpA77vOr8sgMjmj8ASkc6b5LNz+qnBZfoFw0guNMi+L5hUB9ihRlRw7rJTC3Fi+2Wk8fjUZ2QLhJvDJ08v2d3Mb9kYQcVtjpSdVB1qEq6rKl0N+0WfmjdspsQudZKU3jrPoo0/avggKu0Cy2rstjhoubfSKu+9Uw1tbyB7dnlyXH4JDW5NcN60H6cxuAcO+ylqL7n+l7n8A5SGFwIvxY1lw0g9aI4BT5iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKhzYrH7L9Wp83NpiMD9toE2NmxOXgLSXKWyEXDxHCE=;
 b=nkRWWMId7RAaP2QiVyKSaWVtjzZ7juLDWW9J3zG2gn92BQUCnii975RBwu+wUatltV9k2xaONvv4CM+gUELRG82lNKKcoTdYcTAgs1rn9CaU90Bx7u0FfTLEL3CsjnInnXKMXFkAk5xSrTNPmejNjCAwKjt8oRrlKvR1IH6jjgY=
Received: from MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16)
 by MW3PR11MB4684.namprd11.prod.outlook.com (2603:10b6:303:5d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Tue, 16 Jun
 2020 21:39:18 +0000
Received: from MWHPR11MB1599.namprd11.prod.outlook.com
 ([fe80::deb:2fe:1d84:a19f]) by MWHPR11MB1599.namprd11.prod.outlook.com
 ([fe80::deb:2fe:1d84:a19f%11]) with mapi id 15.20.3088.028; Tue, 16 Jun 2020
 21:39:18 +0000
From:   "Kaneda, Erik" <erik.kaneda@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
CC:     Jung-uk Kim <jkim@freebsd.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "glider@google.com" <glider@google.com>,
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
Subject: RE: [Devel] Re: [PATCH] ACPICA: fix UBSAN warning using
 __builtin_offsetof
Thread-Topic: [Devel] Re: [PATCH] ACPICA: fix UBSAN warning using
 __builtin_offsetof
Thread-Index: AQHWOGr94BDOASQdIU6ZpTv243EHY6jShAOAgAAI/wCAAATVgIABFD4QgAAOVICACCW1YA==
Date:   Tue, 16 Jun 2020 21:39:17 +0000
Message-ID: <MWHPR11MB15994AAFA4C5903DDB3C5861F09D0@MWHPR11MB1599.namprd11.prod.outlook.com>
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com>
 <BYAPR11MB3096A0EA2D03BCB76C91F80AF0830@BYAPR11MB3096.namprd11.prod.outlook.com>
 <CAKwvOdnh6Zh+P9SM_qFiy-9u7Y21fn=byTJtG4fTTRJqqU9bcQ@mail.gmail.com>
 <9f4322a5-eea6-fb65-449c-90f3d85f753e@FreeBSD.org>
 <BYAPR11MB3096904AD67CC83A67A38215F0800@BYAPR11MB3096.namprd11.prod.outlook.com>
 <CAKwvOdndPdAWVSJ530mgT5onG4zsHExqO79=QvvLvpz51D8LsQ@mail.gmail.com>
In-Reply-To: <CAKwvOdndPdAWVSJ530mgT5onG4zsHExqO79=QvvLvpz51D8LsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0487fc41-cd05-4e04-fda4-08d8123db91c
x-ms-traffictypediagnostic: MW3PR11MB4684:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB468479D764CD85EBB327A0EEF09D0@MW3PR11MB4684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 14i2li2BPovemeXPsaoir9t3X5vQLniDORQFffwbyY97urfvnNf6V5QavZVqx2WgJXFKF8WhbeefhT0irpvJSpNgIhiSyhdAk7r3od0SKmMB17JlpX9tN0vvfBUhnmwY2QWWGd3l4IOxymuV54UVXI4fwVc6JWL2hy1Du2vTGbzbXpZpq3CwdLWEJJD57KfPPEp20FoVQUh5WAjWkpD1ESBBsGXYiO0oPHN9TSLsn055CwshcIy/p+y7bS+4WOdMFwrKoo1dg9zbmmtrMOLHdbVvIrGn9cpeQCr3Cic0q7oVEpTxCaJ5pP4TOZHl70BoMUMuAIU9AkjY4GpHWeSn6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(6506007)(33656002)(76116006)(66476007)(66556008)(6916009)(64756008)(66446008)(66946007)(478600001)(53546011)(7696005)(9686003)(4326008)(55016002)(7416002)(2906002)(86362001)(5660300002)(54906003)(71200400001)(8936002)(83380400001)(52536014)(26005)(316002)(8676002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GUBuMDFKq7Hu7JnSnFunh/RWzd/DmhJcOYCUaT3H4+y14ZFzy+8jrMT8IXDc/M6xKs206Kppxw42XGnPsO6iR08HrNSR4fWR/pv2EBU43QQ+szvFemQ+7hBpvaEKbCJA8RzllACvYh6HD/v8w9M6gzQzqA9KzmME6+ohz7cBWLffWaGyWG55tFvRE6fuE0zVopRwjkwV2vH1nPTOOhW+x9JIjjDvE8dHeWlccUXMmWpZNSBW9N9W6RdWgg71e4ntmahG20kht1JefbJfe0D5y/i2vG+1H6ImaLdvQkXDMVNRmQMKKcNI6FXtEZMTMH7JKBMrMjs2L4ikRPnvaVtSEPPGzjIo1GlJz5CCTLFHBn0O6jtTbgFamOn6L2Z2PpS+gaeWktWUJq8nv50MQkIlceLo3yRCFpIFOowYngn5VfFClw2ox4d4qbHhcDj8io1wRgeIaytPSlT84B/pN1ksHM+wF5Wu1hqP9nUv/qBJ/Jw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0487fc41-cd05-4e04-fda4-08d8123db91c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 21:39:18.0385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0CjBNC2UkkQYJgnq6A+LaWQZ0lnXluVN0otvzB6SlmP2hH+z2TrbKmHqd2YHk3DqD6YeqWlt94HY6pf2nzY+qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4684
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTmljayBEZXNhdWxuaWVy
cyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDExLCAy
MDIwIDEwOjA2IEFNDQo+IFRvOiBLYW5lZGEsIEVyaWsgPGVyaWsua2FuZWRhQGludGVsLmNvbT4N
Cj4gQ2M6IEp1bmctdWsgS2ltIDxqa2ltQGZyZWVic2Qub3JnPjsgV3lzb2NraSwgUmFmYWVsIEoN
Cj4gPHJhZmFlbC5qLnd5c29ja2lAaW50ZWwuY29tPjsgQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2Vy
bmVsLm9yZz47DQo+IGR2eXVrb3ZAZ29vZ2xlLmNvbTsgZ2xpZGVyQGdvb2dsZS5jb207IGxpbnV4
LWFybS0NCj4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7DQo+IGxvcmVuem8ucGllcmFsaXNpQGFybS5jb207IG1hcmsucnV0bGFuZEBhcm0u
Y29tOyBwY2NAZ29vZ2xlLmNvbTsNCj4gcmp3QHJqd3lzb2NraS5uZXQ7IHdpbGxAa2VybmVsLm9y
Zzsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGFjcGlAdmdlci5rZXJuZWwub3Jn
OyBkZXZlbEBhY3BpY2Eub3JnDQo+IFN1YmplY3Q6IFJlOiBbRGV2ZWxdIFJlOiBbUEFUQ0hdIEFD
UElDQTogZml4IFVCU0FOIHdhcm5pbmcgdXNpbmcNCj4gX19idWlsdGluX29mZnNldG9mDQo+IA0K
PiBPbiBUaHUsIEp1biAxMSwgMjAyMCBhdCA5OjQ1IEFNIEthbmVkYSwgRXJpayA8ZXJpay5rYW5l
ZGFAaW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+ID4gRnJvbTogSnVuZy11ayBLaW0gPGpr
aW1ARnJlZUJTRC5vcmc+DQo+ID4gPg0KPiA+ID4gQWN0dWFsbHksIEkgdGhpbmsgd2Ugc2hvdWxk
IGxldCBwbGF0Zm9ybS1zcGVjaWZpYyBhY2Zvby5oIGRlY2lkZSB3aGF0IHRvDQo+ID4gPiBkbyBo
ZXJlLCBpLmUuLA0KPiA+DQo+ID4gVGhhdCdzIGEgYmV0dGVyIHNvbHV0aW9uLiBGb3IgTGludXgs
IGl0IHdvdWxkIGxvb2sgc29tZXRoaW5nIGxpa2UgdGhpczoNCj4gPg0KPiA+IC0tLSBhL2luY2x1
ZGUvYWNwaS9hY3R5cGVzLmgNCj4gPiArKysgYi9pbmNsdWRlL2FjcGkvYWN0eXBlcy5oDQo+ID4g
QEAgLTUwOCwxMCArNTA4LDE1IEBAIHR5cGVkZWYgdTY0IGFjcGlfaW50ZWdlcjsNCj4gPg0KPiA+
ICAjZGVmaW5lIEFDUElfVE9fUE9JTlRFUihpKSAgICAgICAgICAgICAgQUNQSV9DQVNUX1BUUiAo
dm9pZCwgKGFjcGlfc2l6ZSkgKGkpKQ0KPiA+ICAjZGVmaW5lIEFDUElfVE9fSU5URUdFUihwKSAg
ICAgICAgICAgICAgQUNQSV9QVFJfRElGRiAocCwgKHZvaWQgKikgMCkNCj4gPiAtI2RlZmluZSBB
Q1BJX09GRlNFVChkLCBmKSAgICAgICAgICAgICAgIEFDUElfUFRSX0RJRkYgKCYoKChkICopIDAp
LT5mKSwgKHZvaWQgKikNCj4gMCkNCj4gPiAgI2RlZmluZSBBQ1BJX1BIWVNBRERSX1RPX1BUUihp
KSAgICAgICAgIEFDUElfVE9fUE9JTlRFUihpKQ0KPiA+ICAjZGVmaW5lIEFDUElfUFRSX1RPX1BI
WVNBRERSKGkpICAgICAgICAgQUNQSV9UT19JTlRFR0VSKGkpDQo+ID4NCj4gPiArLyogUGxhdGZv
cm1zIG1heSB3YW50IHRvIGRlZmluZSB0aGVpciBvd24gQUNQSV9PRkZTRVQgKi8NCj4gPiArDQo+
ID4gKyNpZm5kZWYgQUNQSV9PRkZTRVQNCj4gPiArI2RlZmluZSBBQ1BJX09GRlNFVChkLCBmKSAg
ICAgICAgICAgICAgIEFDUElfUFRSX0RJRkYgKCYoKChkICopIDApLT5mKSwgKHZvaWQNCj4gKikg
MCkNCj4gPiArI2VuZGlmDQo+ID4gKw0KPiA+ICAvKiBPcHRpbWl6YXRpb25zIGZvciA0LWNoYXJh
Y3RlciAoMzItYml0KSBhY3BpX25hbWUgbWFuaXB1bGF0aW9uICovDQo+ID4NCj4gPiAgI2lmbmRl
ZiBBQ1BJX01JU0FMSUdOTUVOVF9OT1RfU1VQUE9SVEVEDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvYWNwaS9wbGF0Zm9ybS9hY2xpbnV4LmgNCj4gYi9pbmNsdWRlL2FjcGkvcGxhdGZvcm0vYWNs
aW51eC5oDQo+ID4gaW5kZXggOTg3ZTJhZjdjMzM1Li41ZDFjYTYwMTVmY2UgMTAwNjQ0DQo+ID4g
LS0tIGEvaW5jbHVkZS9hY3BpL3BsYXRmb3JtL2FjbGludXguaA0KPiA+ICsrKyBiL2luY2x1ZGUv
YWNwaS9wbGF0Zm9ybS9hY2xpbnV4LmgNCj4gPiBAQCAtNzEsNiArNzEsMTEgQEANCj4gPiAgI3Vu
ZGVmIEFDUElfREVCVUdfREVGQVVMVA0KPiA+ICAjZGVmaW5lIEFDUElfREVCVUdfREVGQVVMVCAg
ICAgICAgICAoQUNQSV9MVl9JTkZPIHwgQUNQSV9MVl9SRVBBSVIpDQo+ID4NCj4gPiArLyogVXNl
IGdjYydzIGJ1aWx0aW4gb2Zmc2V0IGluc3RlYWQgb2YgdGhlIGRlZmF1bHQgKi8NCj4gPiArDQo+
ID4gKyN1bmRlZiBBQ1BJX09GRlNFVA0KPiA+ICsjZGVmaW5lIEFDUElfT0ZGU0VUKGEsYikgICAg
ICAgICAgICBfX2J1aWx0aW5fb2Zmc2V0b2YoYSxiKQ0KPiA+ICsNCj4gPiAgI2lmbmRlZiBDT05G
SUdfQUNQSQ0KPiA+DQo+IA0KSGksDQoNClNvcnJ5IGFib3V0IHRoZSBkZWxheWVkIHJlc3BvbnNl
Lg0KDQo+IExvb2tzIGdvb2QgYXQgZmlyc3QgZ2xhbmNlLiAgV291bGRuJ3QgYWN0eXBlcy5oIG5l
ZWQgdG8gaW5jbHVkZQ0KPiBwbGF0Zm9ybS9hY2Vudi5oIGZpcnN0IHRob3VnaD8gIE90aGVyd2lz
ZSB5b3UgcHV0IHNvbWUgaGVhZGVyDQo+IGluY2x1c2lvbiBvcmRlciBkZXBlbmRlbmN5IG9uIGZv
bGtzIHdobyBpbmNsdWRlIGFjdHlwZXMuaCB0byBmaXJzdA0KPiBpbmNsdWRlIGFjZW52Lmggb3Ro
ZXJ3aXNlIHdlJ3JlIG5vdCBnZXR0aW5nIHRoZSBkZWZpbml0aW9uIGluIHRlcm1zIG9mDQo+IF9f
YnVpbHRpbl9vZmZzZXRvZi4NCg0KQWN0eXBlcy5oIGlzIGludGVuZGVkIGZvciBBQ1BJQ0EgdXNl
LiBGb3IgZmlsZXMgdXNpbmcgQUNQSV9PRkZTRVQsIHRoZXkgaW5jbHVkZSBoZWFkZXJzIGxpa2Ug
YWNwaS5oIHRoYXQgZW5kcyB1cCBpbmNsdWRpbmcgYWNsaW51eC5oIGJlZm9yZSBpbmNsdWRpbmcg
YWN0eXBlcy5oLiBGb3IgdGhvc2UgdXNpbmcgQUNQSV9PRkZTRVQsIHByZWNlZGVuY2Ugd2lsbCBi
ZSBnaXZlbiB0byB0aGUgZGVmaW5pdGlvbiBpbiBhY2xpbnV4LmggYmVmb3JlIGZhbGxpbmcgYmFj
ayB0byB0aGUgZGVmaW5pdGlvbiBpbiBhY3R5cGVzLg0KDQpFcmlrDQoNCj4gDQo+IC0tDQo+IFRo
YW5rcywNCj4gfk5pY2sgRGVzYXVsbmllcnMNCg==

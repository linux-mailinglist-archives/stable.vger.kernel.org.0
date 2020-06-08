Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6AD1F2A52
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbgFIAGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:06:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:2406 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbgFHXVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:01 -0400
IronPort-SDR: WBiv3I24bZurSAhkGpXGFiFrwIbiKstz0RGAcsWoCOEgd6w7FsEdiMjRcme4FHlV9leZhra7Oz
 Ks5fVE2M00kA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 16:20:56 -0700
IronPort-SDR: GVEKN+Sdzpyjph5He8dWFqU4792RyNmdgbHW6dezk+RIVHItTPaj/0e8G7ouifjCXLPaZfiiyw
 1z9/1ezyYMRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,489,1583222400"; 
   d="scan'208";a="472877250"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2020 16:20:56 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 8 Jun 2020 16:20:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Jun 2020 16:20:52 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 8 Jun 2020 16:20:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 8 Jun 2020 16:20:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGAAZYpk5bmrzlSboH+WX2LojCGPp3Ci2ISrptZGsBWMtBoFXuDlCe4lZIYkjj8YxXPxk+MG5S8nOSxxghkLyBDmyLbcIG+7xY5rgGe92J7QQNGOSKODJ6+QnNosJ16leyl/tcI+EDhuxoc00buiTvIbXQpaYGkHTae2mEjPsqRrn07XhRSztriwyIXDmjKQvqiFO64uTHmpZVaaoUoEjsQEfetRmnfveWbGHyAoXr/rf0ZMJKwW4w+SbaemXkxp91RYb66qaNCME9S0WGYBNl97Ue5Hzne+xaztVo4Q+w4mumKCyx6Lu6EQIdac21e9tQfk2NsAMLuEUUW9GaKPyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6aVbVROYJmQsF3MUYrpfaXpatbExk4/M5Bzum+K41c=;
 b=Cb6hUFcYwF47hpCQ8i40p63VzrTVEzRyPoxmcCiJs1KyXIVwtUFC1M/Ece/7DNpzbVa0LFwOdQPx+TAInaZ501awOoV2me6WIFYnvZoleRxKxGCznsTb+GftVhBoAJzB+ZWN28H8bxv6k8eQZfcpMWUJpSBKUkN+fWDkOgYV/l1BxaGSD/qPEHpi3nRirgoZwhMJJy2Fd5t0mA5qZC/jHKah7kySJPidIkpoJipVn22s/xfJ3InVwiVmLHrR3GwHZWMdwR3HObZ/KhQRuzQ93WDc49+7ruiWRYXGWPZifNTZ0BLPjCwY2+5/DzflMuUzMcJS1bVrnAReiccziYuQKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6aVbVROYJmQsF3MUYrpfaXpatbExk4/M5Bzum+K41c=;
 b=eZg+Hlz4v51BDG53O6IfrlrZXmcj1wZi6ti3BMWnZYCugXTsXh55dJhBxfe0JlJMAJXMFoSB1o9ywN6zdCxk2OVjQqioo8+DgJy/FKAXzx+WsrVMMsVOYVgGiRl6vh/Ovwp2fYMDIGgMHrsE40d0C3470qxMRaxB01aN0jsTgMc=
Received: from BYAPR11MB3096.namprd11.prod.outlook.com (2603:10b6:a03:8f::14)
 by BYAPR11MB3512.namprd11.prod.outlook.com (2603:10b6:a03:8f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Mon, 8 Jun
 2020 23:20:44 +0000
Received: from BYAPR11MB3096.namprd11.prod.outlook.com
 ([fe80::ad0c:c6a9:6f39:eb92]) by BYAPR11MB3096.namprd11.prod.outlook.com
 ([fe80::ad0c:c6a9:6f39:eb92%5]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 23:20:44 +0000
From:   "Kaneda, Erik" <erik.kaneda@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
CC:     "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
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
Thread-Index: AQHWOGr94BDOASQdIU6ZpTv243EHY6jEbrjQgAE8tYCACbloIA==
Date:   Mon, 8 Jun 2020 23:20:43 +0000
Message-ID: <BYAPR11MB309660952553AB3EA9A303B5F0850@BYAPR11MB3096.namprd11.prod.outlook.com>
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com>
 <BYAPR11MB30969737340044437013BF44F08B0@BYAPR11MB3096.namprd11.prod.outlook.com>
 <CAKwvOdmsCmPFiDOq7AYUyEx=60B=qo8u9yhnJDQ6nd6Ew7xDkQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmsCmPFiDOq7AYUyEx=60B=qo8u9yhnJDQ6nd6Ew7xDkQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f035c9f2-12f6-42b0-89bd-08d80c02915d
x-ms-traffictypediagnostic: BYAPR11MB3512:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB35129814DE957994DFC43656F0850@BYAPR11MB3512.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 042857DBB5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WqFK+UvF7i6eRfNr77zIL5DNUv+HZfiwAfdoVCoepnnFaomnlIoUeUY83/r3nMihO6bKaxtTky12cFEHljD8Bo7AoMo2FJ96+qrkatfnjztnsv/DuB3yk55U9J70PHRa5wovK8gnFTqRhPVnnkhzFhTPElpSlLM/HUlNAu6xgxJ7brBzK4FNk6WmNrhG0aDMrwGgYszi7NuoHgJxREVzAFzbHX876o+BhSIPJQUiPs11MePD72wJsNmWs0S6Vjq0lrS8HwI7I4eY60HDh4J9YEhI4mwFHNn+eQ6rIw/jJSWqaXmfR3aKflLqYdFq0fTJLgxjx5dgijzjp8AzwCMIsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3096.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(396003)(376002)(346002)(366004)(26005)(4326008)(8936002)(7696005)(186003)(6506007)(52536014)(6916009)(55016002)(9686003)(53546011)(5660300002)(86362001)(83380400001)(54906003)(478600001)(66946007)(76116006)(66446008)(66476007)(316002)(2906002)(66556008)(7416002)(71200400001)(8676002)(64756008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bZeWdsZSEwydr1UGhtRW9SfMujJW6tm6HY+L4NjaQ2AYCEHOZjJaumv1bed4sNjg6wJrU9HnlzJBmXKqyqb1L2ddx5qD+Ogejr3UCk2Iyw4SILSpuru1dN5cxc5DfCY2iZU2iOf6louyx3BJThnn/ysPinPxSvp8WHtlc3Yve31c+PMLNRpw9oTgHy4xVYRb+oq+7PJD9ic8uEoxA+O9wCV/9tgXjYX9NVhVYousLtwuX70BmUF4MgfurfHbmzwTKOV9zOLPLOWLLrvKwLXdTW4lnk18JB4/xsfGFx+kkqKlnMmai3JNMJzzpm/TDVtZIP/R1x3UnnclUiFSFxv2CiG3BD83V/fHt3KTBjxOtSxqSzXjEm1k7ohSxfr+TdX6EOoZTlBI3wcRB5kKwcpt20sq1cozeQRxzefJOchltdkQbdcjhRgylewbsnHOI8ao0ZsVXq2ZoMW+k5CexRk6WVviti2ddIOp51HAnmrtk9A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f035c9f2-12f6-42b0-89bd-08d80c02915d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2020 23:20:43.9990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lh1a80XnT7qUEBYXJe9c321NHddbM2J/3VHG42hATQqSuELaqb+g44bTJKMXQZzD/nw8qjRni1kQVCLyou92HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3512
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTmljayBEZXNhdWxuaWVy
cyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMiwgMjAy
MCAxMTo0NyBBTQ0KPiBUbzogS2FuZWRhLCBFcmlrIDxlcmlrLmthbmVkYUBpbnRlbC5jb20+DQo+
IENjOiBNb29yZSwgUm9iZXJ0IDxyb2JlcnQubW9vcmVAaW50ZWwuY29tPjsgV3lzb2NraSwgUmFm
YWVsIEoNCj4gPHJhZmFlbC5qLnd5c29ja2lAaW50ZWwuY29tPjsgTGVuIEJyb3duIDxsZW5iQGtl
cm5lbC5vcmc+OyBBcmQNCj4gQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPjsgZHZ5dWtvdkBn
b29nbGUuY29tOyBnbGlkZXJAZ29vZ2xlLmNvbTsNCj4gZ3VvaGFuanVuQGh1YXdlaS5jb207IGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxvcmVuem8ucGllcmFsaXNpQGFybS5jb207DQo+IG1hcmsucnV0bGFuZEBh
cm0uY29tOyBwY2NAZ29vZ2xlLmNvbTsgcmp3QHJqd3lzb2NraS5uZXQ7DQo+IHdpbGxAa2VybmVs
Lm9yZzsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgbGludXgtYWNwaUB2Z2VyLmtlcm5lbC5vcmc7
DQo+IGRldmVsQGFjcGljYS5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gQUNQSUNBOiBmaXgg
VUJTQU4gd2FybmluZyB1c2luZyBfX2J1aWx0aW5fb2Zmc2V0b2YNCj4gDQo+IE9uIE1vbiwgSnVu
IDEsIDIwMjAgYXQgNTowMyBQTSBLYW5lZGEsIEVyaWsgPGVyaWsua2FuZWRhQGludGVsLmNvbT4N
Cj4gd3JvdGU6DQo+ID4NCj4gPg0KPiA+IEhpLA0KPiA+DQo+ID4gPiBXaWxsIHJlcG9ydGVkIFVC
U0FOIHdhcm5pbmdzOg0KPiA+ID4gVUJTQU46IG51bGwtcHRyLWRlcmVmIGluIGRyaXZlcnMvYWNw
aS9hY3BpY2EvdGJmYWR0LmM6NDU5OjM3DQo+ID4gPiBVQlNBTjogbnVsbC1wdHItZGVyZWYgaW4g
YXJjaC9hcm02NC9rZXJuZWwvc21wLmM6NTk2OjYNCj4gPiA+DQo+ID4gPiBMb29rcyBsaWtlIHRo
ZSBlbXVsYXRlZCBvZmZzZXRvZiBtYWNybyBBQ1BJX09GRlNFVCBpcyBjYXVzaW5nIHRoZXNlLg0K
PiA+ID4gV2UgY2FuIGF2b2lkIHRoaXMgYnkgdXNpbmcgdGhlIGNvbXBpbGVyIGJ1aWx0aW4sIF9f
YnVpbHRpbl9vZmZzZXRvZi4NCj4gPg0KPiA+IEknbGwgdGFrZSBhIGxvb2sgYXQgdGhpcyB0b21v
cnJvdw0KPiA+ID4NCj4gPiA+IFRoZSBub24ta2VybmVsIHJ1bnRpbWUgb2YgVUJTQU4gd291bGQg
cHJpbnQ6DQo+ID4gPiBydW50aW1lIGVycm9yOiBtZW1iZXIgYWNjZXNzIHdpdGhpbiBudWxsIHBv
aW50ZXIgb2YgdHlwZSBmb3IgdGhpcyBtYWNyby4NCj4gPg0KPiA+IGFjdHlwZXMuaCBpcyBvd25l
ZCBieSBBQ1BJQ0Egc28gd2UgdHlwaWNhbGx5IGRvIG5vdCBhbGxvdw0KPiA+IGNvbXBpbGVyLXNw
ZWNpZmljIGV4dGVuc2lvbnMgYmVjYXVzZSB0aGUgY29kZSBpcyBpbnRlbmRlZCB0byBiZQ0KPiA+
IGNvbXBpbGVkIHVzaW5nIHRoZSBDOTkgc3RhbmRhcmQgd2l0aG91dCBjb21waWxlciBleHRlbnNp
b25zLiBXZSBjb3VsZA0KPiA+IGFsbG93IHRoaXMgc29ydCBvZiB0aGluZyBpbiBhIExpbnV4LXNw
ZWNpZmljIGhlYWRlciBmaWxlIGxpa2UNCj4gaW5jbHVkZS9hY3BpL3BsYXRmb3JtL2FjbGludXgu
aCBidXQgSSdsbCB0YWtlIGEgbG9vayBhdCB0aGUgZXJyb3IgYXMgd2VsbC4uDQo+IA0KSGksDQoN
Cj4gSWYgSSdtIG5vdCBhbGxvd2VkIHRvIHRvdWNoIHRoYXQgaGVhZGVyLCBpdCBsb29rcyBsaWtl
IEkgY2FuIGluY2x1ZGUNCj4gPGxpbnV4L3N0ZGRlZi5oPiAocmF0aGVyIHRoYW4gbXkgaG9zdCdz
IDxzdGRkZWYuaD4pIHRvIGdldCBhIGRlZmluaXRpb24gb2YNCg0KV2h5IG5vdCB1c2UgeW91ciBo
b3N0J3Mgc3RkZGVmLmg/DQoNCj4gYG9mZnNldG9mYCB0aGF0cyBpbXBsZW1lbnRlZCBpbiB0ZXJt
cyBvZiBgX19idWlsdGluX29mZnNldG9mYC4gIEkgc2hvdWxkIGJlDQo+IGFibGUgdG8gdXNlIHRo
YXQgdG8gcmVwbGFjZSB1c2VzIG9mIEFDUElfT0ZGU0VULiAgQXJlIGFueSBvZiB0aGVzZSBvZmYg
bGltaXRzPw0KDQpZZXMsIHRoZSBpZGVhIGlzIHRvIGRlZmluZSBBQ1BJX09GRlNFVCBpbiBhIHdh
eSB0aGF0IHlvdSB3YW50IHNvIHRoYXQgd2UgZG9uJ3QgdG91Y2ggdGhlIHVzZXMgYmVsb3cuDQoN
CkVyaWsNCj4gDQo+ICQgZ3JlcCAtcm4gQUNQSV9PRkZTRVQNCj4gYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9hY3BpLmg6MzQ6I2RlZmluZQ0KPiBBQ1BJX01BRFRfR0lDQ19NSU5fTEVOR1RIDQo+IEFD
UElfT0ZGU0VUKCAgXCBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2FjcGkuaDo0MTojZGVmaW5lDQo+
IEFDUElfTUFEVF9HSUNDX1NQRSAoQUNQSV9PRkZTRVQoc3RydWN0IGFjcGlfbWFkdF9nZW5lcmlj
X2ludGVycnVwdCwgXA0KPiBpbmNsdWRlL2FjcGkvYWN0YmwuaDozNzY6I2RlZmluZSBBQ1BJX0ZB
RFRfT0ZGU0VUKGYpICAgICAgICAgICAgICh1MTYpDQo+IEFDUElfT0ZGU0VUIChzdHJ1Y3QgYWNw
aV90YWJsZV9mYWR0LCBmKQ0KPiBkcml2ZXJzL2FjcGkvYWNwaWNhL2FjcmVzcmMuaDo4NDojZGVm
aW5lIEFDUElfUlNfT0ZGU0VUKGYpDQo+ICAgKHU4KSBBQ1BJX09GRlNFVCAoc3RydWN0IGFjcGlf
cmVzb3VyY2UsZikNCj4gZHJpdmVycy9hY3BpL2FjcGljYS9hY3Jlc3JjLmg6ODU6I2RlZmluZSBB
TUxfT0ZGU0VUKGYpDQo+ICAgKHU4KSBBQ1BJX09GRlNFVCAodW5pb24gYW1sX3Jlc291cmNlLGYp
DQo+IGRyaXZlcnMvYWNwaS9hY3BpY2EvYWNpbnRlcnAuaDoxNzojZGVmaW5lIEFDUElfRVhEX09G
RlNFVChmKQ0KPiAodTgpIEFDUElfT0ZGU0VUICh1bmlvbiBhY3BpX29wZXJhbmRfb2JqZWN0LGYp
DQo+IGRyaXZlcnMvYWNwaS9hY3BpY2EvYWNpbnRlcnAuaDoxODojZGVmaW5lIEFDUElfRVhEX05T
T0ZGU0VUKGYpDQo+ICh1OCkgQUNQSV9PRkZTRVQgKHN0cnVjdCBhY3BpX25hbWVzcGFjZV9ub2Rl
LGYpDQo+IGRyaXZlcnMvYWNwaS9hY3BpY2EvcnNkdW1waW5mby5jOjE2OiNkZWZpbmUgQUNQSV9S
U0RfT0ZGU0VUKGYpDQo+ICAodTgpIEFDUElfT0ZGU0VUICh1bmlvbiBhY3BpX3Jlc291cmNlX2Rh
dGEsZikNCj4gZHJpdmVycy9hY3BpL2FjcGljYS9yc2R1bXBpbmZvLmM6MTc6I2RlZmluZSBBQ1BJ
X1BSVF9PRkZTRVQoZikNCj4gICh1OCkgQUNQSV9PRkZTRVQgKHN0cnVjdCBhY3BpX3BjaV9yb3V0
aW5nX3RhYmxlLGYpDQo+IA0KPiAtLQ0KPiBUaGFua3MsDQo+IH5OaWNrIERlc2F1bG5pZXJzDQo=

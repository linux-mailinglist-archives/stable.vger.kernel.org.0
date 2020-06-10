Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF9D1F5E92
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 01:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgFJXHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 19:07:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:28066 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgFJXG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 19:06:59 -0400
IronPort-SDR: fOFck39/cUXhCkH5/svHxHWx6Ures3+Y38T0bYUHB5MeuQt9kKnn9qUwTOsiKnBQdL8MzxpR3b
 LYos2RTLpKUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 16:06:53 -0700
IronPort-SDR: udQk6HBzF9uxSLyKz9VNfiHCO+b3u3p3cIok7nGcPHNYcsr0swUKYLayP97HjieE+Oolyztnlh
 mdyQ7tDaelZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,497,1583222400"; 
   d="scan'208";a="473597281"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jun 2020 16:06:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jun 2020 16:06:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jun 2020 16:06:54 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 10 Jun 2020 16:06:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 10 Jun 2020 16:06:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDPbhXeDeU7SWXqz/AtR3FhcL/Hrij2jesX/R/blM0XWu8+qTA2UZdiRReO7o1Gh95BSOlYX9dkqhTLjF1hfUxIMsdxHk1NlcX6BiyAsA4V8BQ1WW4P3vkRNJazNlQS/m1YnkwTcETOYCH6W4BO9oL/gHSxzz5vBKwxZBRwNnLELHjs6+Kos6/aFVJfss0HsQWPQqtSHnIPi7aTWclf0inVvbIWMc5MQKMjKJm8f985sDaPN1JLbl1vcEktdMR5MtmhlKM1skpDRKeDvyp/CKg289jWY+ZVD8+zX7uTypPS6faYkIkP4WqV61D94varJUwhdnkUeXL98IPzB4Re5yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/t0yW+iU7qvLMyxaRCA19vx1L3bJ4zhNYqpL7j59jg=;
 b=WpG2ZUEKwprhLH0XXTcySJgRdDpZ3a5fWyT3BIOfB6Z3uG51YOCgu6Bbxdbs1bTrsQdRWB/U1iQdMqdBrsA14+lhCnhp7KVZrbvts8A65FnP2i8I3sBKIwXtTdCzlJws0wbrBQyLmAce2tjr/XdYPGbJU2wY+Ltaz+v3Z9a/sxA1TPyj6ruecvpOJ7IDPBosxqCSSJ0aror55IyT7PaJ8CdUOi4WUxR8kMIU7xQM9NTvp6icyaA4+9yYbwwNDDyUxx01PxXcU2qPwob8jk3jPYUwTj5/kQbBU6yrU+96KI96VXo1g/gKdNT12kfxIMEuWotT8ozoQTqatPqZjwzJqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/t0yW+iU7qvLMyxaRCA19vx1L3bJ4zhNYqpL7j59jg=;
 b=E+KNuU62Vnd2DSCO4N/yj3JGWe65lAEFfqPha8i+84e9WkLvCYcjJQuiGlU0DiAzRsJiOaMo2ojf/zdAHfcJwByID3zRDT8dOh6s4VeQCnyx+a1Pp0YQs+OdjhUcNBw5BTFNqM4++L5JT9Dciev0Aog/TWfJbWzp5Y/t2WD4slg=
Received: from BYAPR11MB3096.namprd11.prod.outlook.com (2603:10b6:a03:8f::14)
 by BYAPR11MB3688.namprd11.prod.outlook.com (2603:10b6:a03:f8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 10 Jun
 2020 23:06:39 +0000
Received: from BYAPR11MB3096.namprd11.prod.outlook.com
 ([fe80::ad0c:c6a9:6f39:eb92]) by BYAPR11MB3096.namprd11.prod.outlook.com
 ([fe80::ad0c:c6a9:6f39:eb92%5]) with mapi id 15.20.3088.019; Wed, 10 Jun 2020
 23:06:39 +0000
From:   "Kaneda, Erik" <erik.kaneda@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Jung-uk Kim <jkim@FreeBSD.org>
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
Thread-Index: AQHWOGr94BDOASQdIU6ZpTv243EHY6jShAOA
Date:   Wed, 10 Jun 2020 23:06:38 +0000
Message-ID: <BYAPR11MB3096A0EA2D03BCB76C91F80AF0830@BYAPR11MB3096.namprd11.prod.outlook.com>
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
x-originating-ip: [134.134.136.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d91b641c-8cfc-4b87-61b6-08d80d92eeaa
x-ms-traffictypediagnostic: BYAPR11MB3688:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3688BE441EE88269AF6A2B31F0830@BYAPR11MB3688.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7xcXok1vt3b8mPU7EEh3Gwt+HASx9t9etCtR7leoU2twfGEpDNJyl8UpbSi50zWAkcCAtT6m+CPTrfQe6VbFCQSPK97RtKF2L7u7WuGGadgSsHN5QwwP9FvRzo1tjA53lVdAy48++n9bPQO+d1FryTUxTANMDhLW5xIPNUysHlLc8b7qgQ93ogK24aseoPMVxYJVfpqEejZFUkaVzaV6RZYHZBlSsH+3va5Ztd/8nTULYkmc/2MzgLAPr18v4KB11GKErg35PF59eq3OWyEgWOq144ZPWXtv6ggq5elSegPPDCjcEgUGSHz8dAxHri4md43elTLEaLDdmaHFt8us84nqalVyzugn8SgbNAhgT9G1GiHRYYsqB1EDwc0mOJB0Zy41zUWeo38UauF1w0LVvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3096.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(366004)(376002)(396003)(136003)(83380400001)(33656002)(76116006)(186003)(478600001)(66946007)(66446008)(53546011)(6506007)(64756008)(71200400001)(66476007)(4326008)(7416002)(26005)(9686003)(55016002)(2906002)(66556008)(7696005)(316002)(54906003)(86362001)(5660300002)(52536014)(110136005)(8676002)(966005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: elckjCR9+TYJD/lC5JnAWva36ahASVKfGF5/yC1ghC5D35pwRy/Q5vMjApjEs1a4qfW7xe7Fc6AnYYJ9OrfNu8kb1rneqxveQyTJkJ2BYPnQkK4s4B8Qhm/NB06bNr+xRQLKRRupkXPkoTY4KQmGM0actdZhJ6ReacFev/0GCmWAh75F1wAclA30TIjrmw1gP4C1l+V4C/dV96qo/3TB9tjboAHIdJH67qp0gMTyprklBHsZP7ecs6Z1bUGWH4poLVJVnJ9iSOcPBUehDvJPst+QoZFwSscYt8VHZ9zY+f1q1j/jlC+d8ppDWAOoi7WnnwY997SDmBYjgwvqEVdAn0pvvJ8z0ircJCDqUuDspEomzWZMBIUDG7ucEmQnpjoQDbe5rQJAyb8T6XUltMmhqoOnzgafA0vnTXA2NtLXcXBNLeyDhsufwnD1cML91z7ai5RW4q/nyY7sB0BQhmR1iymfoFBIC8bdXCC9XdhNu7sDUFmHvPKzUFG3an2xZUN3
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d91b641c-8cfc-4b87-61b6-08d80d92eeaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 23:06:38.5699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/LgcMGKzCObrsAtesLEH+g00ou3h4rPBnVLn4mF+Z25WWveyEcSu0y8gkvr4JJkGUnuT1rDbwfd4uwQMM8o6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3688
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

K0pLaW0gKGZvciBGcmVlQlNEJ3MgcGVyc3BlY3RpdmUpDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5j
b20+DQo+IFNlbnQ6IE1vbmRheSwgSnVuZSAxLCAyMDIwIDQ6MTggUE0NCj4gVG86IE1vb3JlLCBS
b2JlcnQgPHJvYmVydC5tb29yZUBpbnRlbC5jb20+OyBLYW5lZGEsIEVyaWsNCj4gPGVyaWsua2Fu
ZWRhQGludGVsLmNvbT47IFd5c29ja2ksIFJhZmFlbCBKIDxyYWZhZWwuai53eXNvY2tpQGludGVs
LmNvbT47DQo+IExlbiBCcm93biA8bGVuYkBrZXJuZWwub3JnPg0KPiBDYzogQXJkIEJpZXNoZXV2
ZWwgPGFyZGJAa2VybmVsLm9yZz47IGR2eXVrb3ZAZ29vZ2xlLmNvbTsNCj4gZ2xpZGVyQGdvb2ds
ZS5jb207IGd1b2hhbmp1bkBodWF3ZWkuY29tOyBsaW51eC1hcm0tDQo+IGtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsb3JlbnpvLnBp
ZXJhbGlzaUBhcm0uY29tOyBtYXJrLnJ1dGxhbmRAYXJtLmNvbTsNCj4gbmRlc2F1bG5pZXJzQGdv
b2dsZS5jb207IHBjY0Bnb29nbGUuY29tOyByandAcmp3eXNvY2tpLm5ldDsNCj4gd2lsbEBrZXJu
ZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9y
ZzsNCj4gZGV2ZWxAYWNwaWNhLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdIEFDUElDQTogZml4IFVC
U0FOIHdhcm5pbmcgdXNpbmcgX19idWlsdGluX29mZnNldG9mDQo+IA0KPiBXaWxsIHJlcG9ydGVk
IFVCU0FOIHdhcm5pbmdzOg0KPiBVQlNBTjogbnVsbC1wdHItZGVyZWYgaW4gZHJpdmVycy9hY3Bp
L2FjcGljYS90YmZhZHQuYzo0NTk6MzcNCj4gVUJTQU46IG51bGwtcHRyLWRlcmVmIGluIGFyY2gv
YXJtNjQva2VybmVsL3NtcC5jOjU5Njo2DQo+IA0KSGksDQoNCj4gTG9va3MgbGlrZSB0aGUgZW11
bGF0ZWQgb2Zmc2V0b2YgbWFjcm8gQUNQSV9PRkZTRVQgaXMgY2F1c2luZyB0aGVzZS4gV2UNCj4g
Y2FuIGF2b2lkIHRoaXMgYnkgdXNpbmcgdGhlIGNvbXBpbGVyIGJ1aWx0aW4sIF9fYnVpbHRpbl9v
ZmZzZXRvZi4NCj4gDQpUaGlzIGRvZXNuJ3QgcmVhbGx5IGZseSBiZWNhdXNlIF9fYnVpbHRpbl9v
ZmZzZXRvZiBpcyBhIGNvbXBpbGVyIGV4dGVuc2lvbi4NCg0KSXQgbG9va3MgbGlrZSBhIGxvdCBv
ZiBzdGRkZWYuaCBmaWxlcyBkbyB0aGlzOg0KDQojZGVmaW5lIG9mZnNldG9mKGEsYikgX19idWls
dGluX29mZnNldChhLGIpDQoNClNvIGRvZXMgYW55b25lIGhhdmUgb2JqZWN0aW9ucyB0byBBQ1BJ
X09GRlNFVCBiZWluZyBkZWZpbmVkIHRvIG9mZnNldG9mKCk/DQoNClRoaXMgd2lsbCBhbGxvdyBh
IGhvc3QgT1MgcHJvamVjdCBwcm9qZWN0IHRvIHVzZSB0aGVpciBvd24gZGVmaW5pdGlvbnMgb2Yg
b2Zmc2V0b2YgaW4gcGxhY2Ugb2YgQUNQSUNBJ3MuDQpJZiB0aGV5IGRvbid0IGhhdmUgYSBkZWZp
bml0aW9uIGZvciBvZmZzZXRvZiwgd2UgY2FuIHN1cHBseSB0aGUgb2xkIG9uZSBhcyBhIGZhbGxi
YWNrLg0KDQpIZXJlJ3MgYSBwYXRjaDoNCg0KLS0tIGEvaW5jbHVkZS9hY3BpL2FjdHlwZXMuaA0K
KysrIGIvaW5jbHVkZS9hY3BpL2FjdHlwZXMuaA0KQEAgLTUwNCwxMSArNTA0LDE3IEBAIHR5cGVk
ZWYgdTY0IGFjcGlfaW50ZWdlcjsNCiAjZGVmaW5lIEFDUElfU1VCX1BUUih0LCBhLCBiKSAgICAg
ICAgICAgQUNQSV9DQVNUX1BUUiAodCwgKEFDUElfQ0FTVF9QVFIgKHU4LCAoYSkpIC0gKGFjcGlf
c2l6ZSkoYikpKQ0KICNkZWZpbmUgQUNQSV9QVFJfRElGRihhLCBiKSAgICAgICAgICAgICAoKGFj
cGlfc2l6ZSkgKEFDUElfQ0FTVF9QVFIgKHU4LCAoYSkpIC0gQUNQSV9DQVNUX1BUUiAodTgsIChi
KSkpKQ0KDQorLyogVXNlIGFuIGV4aXN0aW5nIGRlZmluaXRvbiBmb3Igb2Zmc2V0b2YgKi8NCisN
CisjaWZuZGVmIG9mZnNldG9mDQorI2RlZmluZSBvZmZzZXRvZihkLGYpICAgICAgICAgICAgICAg
ICAgIEFDUElfUFRSX0RJRkYgKCYoKChkICopIDApLT5mKSwgKHZvaWQgKikgMCkNCisjZW5kaWYN
CisNCiAvKiBQb2ludGVyL0ludGVnZXIgdHlwZSBjb252ZXJzaW9ucyAqLw0KDQogI2RlZmluZSBB
Q1BJX1RPX1BPSU5URVIoaSkgICAgICAgICAgICAgIEFDUElfQ0FTVF9QVFIgKHZvaWQsIChhY3Bp
X3NpemUpIChpKSkNCiAjZGVmaW5lIEFDUElfVE9fSU5URUdFUihwKSAgICAgICAgICAgICAgQUNQ
SV9QVFJfRElGRiAocCwgKHZvaWQgKikgMCkNCi0jZGVmaW5lIEFDUElfT0ZGU0VUKGQsIGYpICAg
ICAgICAgICAgICAgQUNQSV9QVFJfRElGRiAoJigoKGQgKikgMCktPmYpLCAodm9pZCAqKSAwKQ0K
KyNkZWZpbmUgQUNQSV9PRkZTRVQoZCwgZikgICAgICAgICAgICAgICBvZmZzZXRvZiAoZCxmKQ0K
ICNkZWZpbmUgQUNQSV9QSFlTQUREUl9UT19QVFIoaSkgICAgICAgICBBQ1BJX1RPX1BPSU5URVIo
aSkNCiAjZGVmaW5lIEFDUElfUFRSX1RPX1BIWVNBRERSKGkpICAgICAgICAgQUNQSV9UT19JTlRF
R0VSKGkpDQoNClRoYW5rcywNCkVyaWsNCg0KPiBUaGUgbm9uLWtlcm5lbCBydW50aW1lIG9mIFVC
U0FOIHdvdWxkIHByaW50Og0KPiBydW50aW1lIGVycm9yOiBtZW1iZXIgYWNjZXNzIHdpdGhpbiBu
dWxsIHBvaW50ZXIgb2YgdHlwZSBmb3IgdGhpcyBtYWNyby4NCj4gDQo+IExpbms6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDA1MjExMDA5NTIuR0E1MzYwQHdpbGxpZS10aGUtdHJ1
Y2svDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFJlcG9ydGVkLWJ5OiBXaWxsIERl
YWNvbiA8d2lsbEBrZXJuZWwub3JnPg0KPiBTdWdnZXN0ZWQtYnk6IEFyZCBCaWVzaGV1dmVsIDxh
cmRiQGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY2sgRGVzYXVsbmllcnMgPG5kZXNh
dWxuaWVyc0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvYWNwaS9hY3R5cGVzLmggfCAy
ICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2FjcGkvYWN0eXBlcy5oIGIvaW5jbHVkZS9hY3BpL2Fj
dHlwZXMuaCBpbmRleA0KPiA0ZGVmZWQ1OGVhMzMuLjA0MzU5YzcwYjE5OCAxMDA2NDQNCj4gLS0t
IGEvaW5jbHVkZS9hY3BpL2FjdHlwZXMuaA0KPiArKysgYi9pbmNsdWRlL2FjcGkvYWN0eXBlcy5o
DQo+IEBAIC01MDgsNyArNTA4LDcgQEAgdHlwZWRlZiB1NjQgYWNwaV9pbnRlZ2VyOw0KPiANCj4g
ICNkZWZpbmUgQUNQSV9UT19QT0lOVEVSKGkpICAgICAgICAgICAgICBBQ1BJX0NBU1RfUFRSICh2
b2lkLCAoYWNwaV9zaXplKSAoaSkpDQo+ICAjZGVmaW5lIEFDUElfVE9fSU5URUdFUihwKSAgICAg
ICAgICAgICAgQUNQSV9QVFJfRElGRiAocCwgKHZvaWQgKikgMCkNCj4gLSNkZWZpbmUgQUNQSV9P
RkZTRVQoZCwgZikgICAgICAgICAgICAgICBBQ1BJX1BUUl9ESUZGICgmKCgoZCAqKSAwKS0+Ziks
ICh2b2lkICopDQo+IDApDQo+ICsjZGVmaW5lIEFDUElfT0ZGU0VUKGQsIGYpICAgICAgICAgICAg
ICAgX19idWlsdGluX29mZnNldG9mKGQsIGYpDQo+ICAjZGVmaW5lIEFDUElfUEhZU0FERFJfVE9f
UFRSKGkpICAgICAgICAgQUNQSV9UT19QT0lOVEVSKGkpDQo+ICAjZGVmaW5lIEFDUElfUFRSX1RP
X1BIWVNBRERSKGkpICAgICAgICAgQUNQSV9UT19JTlRFR0VSKGkpDQo+IA0KPiAtLQ0KPiAyLjI3
LjAucmMyLjI1MS5nOTA3MzdiZWI4MjUtZ29vZw0KDQo=

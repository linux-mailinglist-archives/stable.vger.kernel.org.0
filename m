Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DD81E292D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 19:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389484AbgEZRhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 13:37:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:33528 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388767AbgEZRhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 13:37:05 -0400
IronPort-SDR: aEyHuJtU+0wVsMuLnuFCMOrIvwuLUozA0q5lh1s8cRjBkCQckG6EpcQ8CvfRcMcqefNw0DLlPh
 BWcOFYv2up7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 10:37:04 -0700
IronPort-SDR: MJKhGcrATuF0i0KihAqALeT6vQzlCUKnj4irifv+c5R2fkiG4jSSSvt3WU07w6sFGOrz0/LpiV
 +H1hu/8moy9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="310319561"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by FMSMGA003.fm.intel.com with ESMTP; 26 May 2020 10:37:04 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 10:37:03 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.3]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.205]) with mapi id 14.03.0439.000;
 Tue, 26 May 2020 10:37:03 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Borislav Petkov <bp@alien8.de>, Jue Wang <juew@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        x86 <x86@kernel.org>
Subject: RE: [tip: ras/core] x86/{mce,mm}: Change so poison pages are either
 unmapped or marked uncacheable
Thread-Topic: [tip: ras/core] x86/{mce,mm}: Change so poison pages are
 either unmapped or marked uncacheable
Thread-Index: AQHWMoOxAO03JBXooEyMNcBj14jCyqi5ua4AgADovGA=
Date:   Tue, 26 May 2020 17:37:03 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F64615F@ORSMSX115.amr.corp.intel.com>
References: <159040440370.17951.17560303737298768113.tip-bot2@tip-bot2>
 <20200525204010.GB25598@zn.tnic>
In-Reply-To: <20200525204010.GB25598@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPaywgSSBoYWQgdG8gY2hhbmdlIHRoaXMgb25lIGR1ZSB0byBvdGhlciBwZW5kaW5nIGNoYW5n
ZXMgaW4NCj4gdGlwOng4Ni9lbnRyeS4gVGhlIG5ldyB2ZXJzaW9uIGJlbG93Lg0KPg0KPiBDYW4g
eW91IGd1eXMgcnVuIHRoaXMgYnJhbmNoIHRvIG1ha2Ugc3VyZSBpdCBzdGlsbCB3b3JrcyBhcyBl
eHBlY3RlZD8NCj4NCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvYnAvYnAuZ2l0L2xvZy8/aD10aXAtcmFzLWNvcmUNCg0KVGVzdGVkIHRoZSBuYXRpdmUg
Y2FzZS4gV2UgY29ycmVjdGx5IHRyeSB0byBzZXQgdGhlIHBhZ2UgdW5jYWNoZWFibGUgYmVjYXVz
ZQ0KdGhlIHNjb3BlIG9mIHRoZSBlcnJvciBpcyBhIGNhY2hlIGxpbmUuDQoNCkkgZG9uJ3QgaGF2
ZSB0aGUgcmlnaHQgc2V0dXAgdG8gdGVzdCB0aGUgdmlydHVhbGl6YXRpb24gY2FzZS4gTWF5YmUg
SnVlIGNhbiB0ZXN0IGFnYWluPw0KDQotVG9ueQ0K

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA16C2FD5F5
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 17:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbhATQrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 11:47:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:45486 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbhATQqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 11:46:46 -0500
IronPort-SDR: ydsu3FJ0b2ESaWHM3Wo4p+XVCeZnscNelpdPoojXF3hOxfguxsHNBImQ9xhNxFwmiA85ivKr4G
 jqgv6AFtYUeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="243208040"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="243208040"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 08:45:42 -0800
IronPort-SDR: jOQpdhF77cakpHtUSgc9r40S1D8+/msWUO7+eagZo6MLNNrkJO1lYHyeeq0tJq2TWBOUDqlzE+
 M3XmMiIUTMWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="402798582"
Received: from irsmsx606.ger.corp.intel.com ([163.33.146.139])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jan 2021 08:45:39 -0800
Received: from irsmsx601.ger.corp.intel.com (163.33.146.7) by
 IRSMSX606.ger.corp.intel.com (163.33.146.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Jan 2021 16:45:38 +0000
Received: from irsmsx601.ger.corp.intel.com ([163.33.146.7]) by
 irsmsx601.ger.corp.intel.com ([163.33.146.7]) with mapi id 15.01.1713.004;
 Wed, 20 Jan 2021 16:45:38 +0000
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
Thread-Index: AQHW1HWlBDRR5udg2US7JjUHUSX5h6okBMqAgAzZ2oCAAAxcgIAAAbqwgAABYaA=
Date:   Wed, 20 Jan 2021 16:45:38 +0000
Message-ID: <4774f65a7f2f464781a45790c8934a62@intel.com>
References: <20201210121438.7718-1-lma@semihalf.com>
 <20201217130439.141943-1-lma@semihalf.com>
 <CAFJ_xbprw7UKREWgRAq3dDAA9oC_3cWoozn5pCY8w9By4dASag@mail.gmail.com>
 <CAFJ_xbrvr7jcCB57MPwzXf=oC5OYT5KUBkcqHYyOYH=a5njfSA@mail.gmail.com>
 <8c22c415-1807-b673-20e3-bc8d7f4c05b7@linux.intel.com>
 <371e612ac59c458cad1bafb82ca09c9f@intel.com>
In-Reply-To: <371e612ac59c458cad1bafb82ca09c9f@intel.com>
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

T24gMjAyMS0wMS0yMCA1OjQxIFBNLCBSb2pld3NraSwgQ2V6YXJ5IHdyb3RlOg0KPiANCj4gSnVz
dCBjaGVja2VkIHRoZSBoaXN0b3J5IGJlaGluZCB0aGlzLiBBbmQgbXVzdCBzYXksIEkgbGlrZWQg
UmljYXJkbydzDQo+IHZlcnNpb24gYmV0dGVyLiBFeGNlcHQgZm9yIHRoZSAiPSB7fTsiIGJpdCB3
aGljaCBNYXJrIGFscmVhZHkgcG9pbnRlZA0KPiBvdXQgLSBpdCBzaG91bGQgYmUgYSBzZXBhcmF0
ZSBmaXggLSBpdCdzIHNpbXBseSBtb3JlIG9wdGlvbmFsDQoNCk1lYW50IHRvIHNheTogb3B0aW1h
bC4NCg0K

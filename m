Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943AC2F1C69
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389435AbhAKRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:32:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:32052 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389244AbhAKRcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:32:45 -0500
IronPort-SDR: Rj893bq/5BnR3IbOubMGtqTvQo6M7dcAIxfgqQdCSD3TAgG/Z2awPSIiSryOsemIPjxlXaE1qu
 GQh9z9mWWvxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="157681598"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="157681598"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 09:32:05 -0800
IronPort-SDR: 7rbyUqc2rg+Zxz41GmbCyB3CGM1eprtX02pTl51qv9JzE9KaQ7PqY2x8uxWFPBMwbj5V3FePzo
 0iWbZnWTED4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="344951049"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jan 2021 09:32:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Jan 2021 09:32:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Jan 2021 09:32:04 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Mon, 11 Jan 2021 09:32:04 -0800
From:   "Bloomfield, Jon" <jon.bloomfield@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 03/11] drm/i915: Allow the sysadmin to override security
 mitigations
Thread-Topic: [PATCH 03/11] drm/i915: Allow the sysadmin to override security
 mitigations
Thread-Index: AQHW52H0KsO7cQ69u0GWC0XUKyZqaqoirrpg
Date:   Mon, 11 Jan 2021 17:31:48 +0000
Deferred-Delivery: Mon, 11 Jan 2021 17:31:03 +0000
Message-ID: <a2154cb4c5f7405fbc5551b750506fd8@intel.com>
References: <20210110150404.19535-1-chris@chris-wilson.co.uk>
 <20210110150404.19535-3-chris@chris-wilson.co.uk>
In-Reply-To: <20210110150404.19535-3-chris@chris-wilson.co.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDaHJpcyBXaWxzb24gPGNocmlz
QGNocmlzLXdpbHNvbi5jby51az4NCj4gU2VudDogU3VuZGF5LCBKYW51YXJ5IDEwLCAyMDIxIDc6
MDQgQU0NCj4gVG86IGludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gQ2M6IENocmlz
IFdpbHNvbiA8Y2hyaXNAY2hyaXMtd2lsc29uLmNvLnVrPjsgSm9vbmFzIExhaHRpbmVuDQo+IDxq
b29uYXMubGFodGluZW5AbGludXguaW50ZWwuY29tPjsgQmxvb21maWVsZCwgSm9uDQo+IDxqb24u
Ymxvb21maWVsZEBpbnRlbC5jb20+OyBWaXZpLCBSb2RyaWdvIDxyb2RyaWdvLnZpdmlAaW50ZWwu
Y29tPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggMDMvMTFd
IGRybS9pOTE1OiBBbGxvdyB0aGUgc3lzYWRtaW4gdG8gb3ZlcnJpZGUgc2VjdXJpdHkNCj4gbWl0
aWdhdGlvbnMNCj4gDQo+IFRoZSBjbGVhci1yZXNpZHVhbHMgbWl0aWdhdGlvbiBpcyBhIHJlbGF0
aXZlbHkgaGVhdnkgaGFtbWVyIGFuZCB1bmRlciBzb21lDQo+IGNpcmN1bXN0YW5jZXMgdGhlIHVz
ZXIgbWF5IHdpc2ggdG8gZm9yZ28gdGhlIGNvbnRleHQgaXNvbGF0aW9uIGluIG9yZGVyDQo+IHRv
IG1lZXQgc29tZSBwZXJmb3JtYW5jZSByZXF1aXJlbWVudC4gSW50cm9kdWNlIGEgZ2VuZXJpYyBt
b2R1bGUNCj4gcGFyYW1ldGVyIHRvIGFsbG93IHNlbGVjdGl2ZWx5IGVuYWJsaW5nL2Rpc2FibGlu
ZyBkaWZmZXJlbnQgbWl0aWdhdGlvbnMuDQo+IA0KPiBDbG9zZXM6IGh0dHBzOi8vZ2l0bGFiLmZy
ZWVkZXNrdG9wLm9yZy9kcm0vaW50ZWwvLS9pc3N1ZXMvMTg1OA0KPiBGaXhlczogNDdmODI1M2Qy
Yjg5ICgiZHJtL2k5MTUvZ2VuNzogQ2xlYXIgYWxsIEVVL0wzIHJlc2lkdWFsIGNvbnRleHRzIikN
Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJpcy13aWxzb24uY28udWs+
DQo+IENjOiBKb29uYXMgTGFodGluZW4gPGpvb25hcy5sYWh0aW5lbkBsaW51eC5pbnRlbC5jb20+
DQo+IENjOiBKb24gQmxvb21maWVsZCA8am9uLmJsb29tZmllbGRAaW50ZWwuY29tPg0KPiBDYzog
Um9kcmlnbyBWaXZpIDxyb2RyaWdvLnZpdmlAaW50ZWwuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZyAjIHY1LjcNCj4gLS0tDQoNClJldmlld2VkLWJ5OiBKb24gQmxvb21maWVsZCA8
am9uLmJsb29tZmllbGRAaW50ZWwuY29tPj8NCg==

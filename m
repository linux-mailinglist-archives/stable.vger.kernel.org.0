Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F30491EBF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 06:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiARFEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 00:04:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:4609 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbiARFEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 00:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642482284; x=1674018284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o0FWJnX4y2U4G+EH7yL2ssRjGfC0XguAFwx2X1MJLHc=;
  b=WPc+VnTl9zxjiHNpfHfRSTGb0cklRhXHuBgRVg4y2EwIqqlfLSSd9kUn
   /1Lb6btrekh3sAyr0s5eew0fxHVkLZ4VjbR9dNw4waTa8GrsLPz5LSrba
   etCIye5u91GyNtR9NDNBWUvPI50YrNdp+XR9lYSAprf8G5D0nYl3zGKv3
   PuVsS+jinkWurCy5rGGUMBrUkn0lA727LwXX+leDt+it2osUqDkzSRPe+
   HuSBHZL9lRVebRyFXbuPHLOVz4o9DjjMgKkJ6tKfCUuRFN5BkQFODpP4O
   g6ScsAnX2utvkCC5X9ncQoIO0e5AT2eU5wfW5GiHSm6liUveqN3No7Uyo
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244536817"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="244536817"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 21:04:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="474646105"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 17 Jan 2022 21:04:43 -0800
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 21:04:42 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX603.ccr.corp.intel.com (10.109.6.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 18 Jan 2022 13:04:41 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 18 Jan 2022 13:04:41 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Like Xu <like.xu.linux@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Thread-Topic: [PATCH] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Thread-Index: AQHX8076wK5RJuHA+UCCsx2l7kha3qxn0WmAgACZDMA=
Date:   Tue, 18 Jan 2022 05:04:41 +0000
Message-ID: <0c87c3e5e1dd4c03959c6c1b0e4fd05a@intel.com>
References: <20211217124934.32893-1-wei.w.wang@intel.com>
 <CALMp9eR18D6omo6kVTUXQ2enPpUBE=5oQWvQ5uiYu_0h6npE8A@mail.gmail.com>
In-Reply-To: <CALMp9eR18D6omo6kVTUXQ2enPpUBE=5oQWvQ5uiYu_0h6npE8A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlc2RheSwgSmFudWFyeSAxOCwgMjAyMiAxMTo1NCBBTSwgSmltIE1hdHRzb24gd3JvdGU6
DQo+IE9uIEZyaSwgRGVjIDE3LCAyMDIxIGF0IDY6MDUgQU0gV2VpIFdhbmcgPHdlaS53LndhbmdA
aW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IFRoZSBmaXhlZCBjb3VudGVyIDMgaXMgdXNlZCBm
b3IgdGhlIFRvcGRvd24gbWV0cmljcywgd2hpY2ggaGFzbid0IGJlZW4NCj4gPiBlbmFibGVkIGZv
ciBLVk0gZ3Vlc3RzLiBVc2Vyc3BhY2UgYWNjZXNzaW5nIHRvIGl0IHdpbGwgZmFpbCBhcyBpdCdz
DQo+ID4gbm90IGluY2x1ZGVkIGluIGdldF9maXhlZF9wbWMoKS4gVGhpcyBicmVha3MgS1ZNIHNl
bGZ0ZXN0cyBvbiBJQ1grDQo+ID4gbWFjaGluZXMsIHdoaWNoIGhhdmUgdGhpcyBjb3VudGVyLg0K
PiA+DQo+ID4gVG8gcmVwcm9kdWNlIGl0IG9uIElDWCsgbWFjaGluZXMsIC4vc3RhdGVfdGVzdCBy
ZXBvcnRzOg0KPiA+ID09PT0gVGVzdCBBc3NlcnRpb24gRmFpbHVyZSA9PT09DQo+ID4gbGliL3g4
Nl82NC9wcm9jZXNzb3IuYzoxMDc4OiByID09IG5tc3JzDQo+ID4gcGlkPTQ1NjQgdGlkPTQ1NjQg
LSBBcmd1bWVudCBsaXN0IHRvbyBsb25nDQo+ID4gMSAgMHgwMDAwMDAwMDAwNDBiMWI5OiB2Y3B1
X3NhdmVfc3RhdGUgYXQgcHJvY2Vzc29yLmM6MTA3Nw0KPiA+IDIgIDB4MDAwMDAwMDAwMDQwMjQ3
ODogbWFpbiBhdCBzdGF0ZV90ZXN0LmM6MjA5IChkaXNjcmltaW5hdG9yIDYpDQo+ID4gMyAgMHgw
MDAwN2ZiZTIxZWQ1ZjkyOiA/PyA/PzowDQo+ID4gNCAgMHgwMDAwMDAwMDAwNDAyNjRkOiBfc3Rh
cnQgYXQgPz86Pw0KPiA+ICBVbmV4cGVjdGVkIHJlc3VsdCBmcm9tIEtWTV9HRVRfTVNSUywgcjog
MTcgKGZhaWxlZCBNU1Igd2FzIDB4MzBjKQ0KPiA+DQo+ID4gV2l0aCB0aGlzIHBhdGNoLCBpdCB3
b3JrcyB3ZWxsLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogV2VpIFdhbmcgPHdlaS53LndhbmdA
aW50ZWwuY29tPg0KPiBSZXZpZXdlZC1hbmQtdGVzdGVkLWJ5OiBKaW0gTWF0dHNvbiA8am1hdHRz
b25AZ29vZ2xlLmNvbT4NCj4gDQo+IEkgYmVsaWV2ZSB0aGlzIGZpeGVzIGNvbW1pdCAyZThjZDdh
M2I4MjggKCJrdm06IHg4NjogbGltaXQgdGhlIG1heGltdW0NCj4gbnVtYmVyIG9mIHZQTVUgZml4
ZWQgY291bnRlcnMgdG8gMyIpIGZyb20gdjUuOS4gU2hvdWxkIHRoaXMgYmUgY2MnZWQgdG8NCj4g
c3RhYmxlPw0KDQpTb3VuZHMgZ29vZCB0byBtZS4NCg0KVGhhbmtzLA0KV2VpDQo=

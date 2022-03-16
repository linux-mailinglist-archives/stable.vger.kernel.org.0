Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08F4DB418
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356983AbiCPPI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356980AbiCPPIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:08:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD81673C3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647443210; x=1678979210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WLUNZTvvae9E4cmNo9iFZA9hcWRmLDmf0bVsBSaU3g4=;
  b=ZwXe5lGrM3zrgz0//WkKx7Dnm0qsRAjp6Lfjk4mmyhWPwxodRNQWbeeF
   4Sur64T60jPmW1AvqbOgUplu79yp1nID/rMx8dOD/zRDtnQhYxI5lX3UN
   aW9gasAWcucFM54T+0x+au3b+DIvbCziblqIbwR1XFl37Hc+F0t6Q8blE
   lvJShh20xWZI6pXBL6UHEDb0vxb+HIFDxj5NsuwPABk1xXv0I/TBo3+bq
   DagXGO71wjPfPD5/fvl9RavwWM6mQayLI3Tir2h01oym1q91VwIhBCFeE
   pCEMsbA5nJXMhfBFWd39akFpXh97t5XeOfVrK8plclBp7MFLY++aI45FJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238789548"
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="238789548"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 08:03:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="557488121"
Received: from irsmsx601.ger.corp.intel.com ([163.33.146.7])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2022 08:03:01 -0700
Received: from irsmsx605.ger.corp.intel.com (163.33.146.138) by
 irsmsx601.ger.corp.intel.com (163.33.146.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 15:03:00 +0000
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138]) by
 IRSMSX605.ger.corp.intel.com ([163.33.146.138]) with mapi id 15.01.2308.021;
 Wed, 16 Mar 2022 15:03:00 +0000
From:   "Kahola, Mika" <mika.kahola@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH] drm/i915: Reject unsupported TMDS rates on
 ICL+
Thread-Topic: [Intel-gfx] [PATCH] drm/i915: Reject unsupported TMDS rates on
 ICL+
Thread-Index: AQHYNY8Fh2A0I4S/IUmLgZnVQ0M4sqzCIpqw
Date:   Wed, 16 Mar 2022 15:03:00 +0000
Message-ID: <5ccc5eb4d3e648ecbc4c7fa511999309@intel.com>
References: <20220311212845.32358-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20220311212845.32358-1-ville.syrjala@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC1nZnggPGludGVsLWdm
eC1ib3VuY2VzQGxpc3RzLmZyZWVkZXNrdG9wLm9yZz4gT24gQmVoYWxmIE9mIFZpbGxlDQo+IFN5
cmphbGENCj4gU2VudDogRnJpZGF5LCBNYXJjaCAxMSwgMjAyMiAxMToyOSBQTQ0KPiBUbzogaW50
ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBbSW50ZWwtZ2Z4XSBbUEFUQ0hdIGRybS9pOTE1OiBSZWplY3QgdW5zdXBw
b3J0ZWQgVE1EUyByYXRlcyBvbiBJQ0wrDQo+IA0KPiBGcm9tOiBWaWxsZSBTeXJqw6Rsw6QgPHZp
bGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPg0KPiANCj4gSUNMKyBQTExzIGNhbid0IGdlbmVu
ZXJhdGUgY2VydGFpbiBmcmVxdWVuY2llcy4gUnVubmluZyB0aGUgUExMDQo+IGFsZ29yaXRobXMg
dGhyb3VnaCBmb3IgYWxsIGZyZXF1ZW5jaWVzIDI1LTU5NE1IeiB3ZSBzZWUgYSBnYXAganVzdCBh
Ym92ZSA1MDANCj4gTUh6LiBTcGVjaWZpY2FsbHkgNTAwLTUyMi44TUhaIGZvciBUQyBQTExzLCBh
bmQgNTAwLTUzMy4yIE1IeiBmb3IgY29tYm8gUEhZDQo+IFBMTHMuIFJlamVjdCB0aG9zZSBmcmVx
dWVuY2llcyBoZG1pX3BvcnRfY2xvY2tfdmFsaWQoKSBzbyB0aGF0IHdlIHByb3Blcmx5IGZpbHRl
cg0KPiBvdXQgdW5zdXBwb3J0ZWQgbW9kZXMgYW5kL29yIGNvbG9yIGRlcHRocyBmb3IgSERNSS4N
Cj4gDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENsb3NlczogaHR0cHM6Ly9naXRs
YWIuZnJlZWRlc2t0b3Aub3JnL2RybS9pbnRlbC8tL2lzc3Vlcy81MjQ3DQo+IFNpZ25lZC1vZmYt
Ynk6IFZpbGxlIFN5cmrDpGzDpCA8dmlsbGUuc3lyamFsYUBsaW51eC5pbnRlbC5jb20+DQoNClJl
dmlld2VkLWJ5OiBNaWthIEthaG9sYSA8bWlrYS5rYWhvbGFAaW50ZWwuY29tPg0KDQo+IC0tLQ0K
PiAgZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9oZG1pLmMgfCA5ICsrKysrKysr
Kw0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfaGRtaS5jDQo+IGIvZHJpdmVycy9n
cHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9oZG1pLmMNCj4gaW5kZXggZjNlNjg4ZjczOWYzLi5h
NGE2ZjhiZDI4NDEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkv
aW50ZWxfaGRtaS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxf
aGRtaS5jDQo+IEBAIC0xODM3LDYgKzE4MzcsNyBAQCBoZG1pX3BvcnRfY2xvY2tfdmFsaWQoc3Ry
dWN0IGludGVsX2hkbWkgKmhkbWksDQo+ICAJCSAgICAgIGJvb2wgaGFzX2hkbWlfc2luaykNCj4g
IHsNCj4gIAlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYgPSBpbnRlbF9oZG1pX3Rv
X2k5MTUoaGRtaSk7DQo+ICsJZW51bSBwaHkgcGh5ID0gaW50ZWxfcG9ydF90b19waHkoZGV2X3By
aXYsDQo+ICtoZG1pX3RvX2RpZ19wb3J0KGhkbWkpLT5iYXNlLnBvcnQpOw0KPiANCj4gIAlpZiAo
Y2xvY2sgPCAyNTAwMCkNCj4gIAkJcmV0dXJuIE1PREVfQ0xPQ0tfTE9XOw0KPiBAQCAtMTg1Nyw2
ICsxODU4LDE0IEBAIGhkbWlfcG9ydF9jbG9ja192YWxpZChzdHJ1Y3QgaW50ZWxfaGRtaSAqaGRt
aSwNCj4gIAlpZiAoSVNfQ0hFUlJZVklFVyhkZXZfcHJpdikgJiYgY2xvY2sgPiAyMTYwMDAgJiYg
Y2xvY2sgPCAyNDAwMDApDQo+ICAJCXJldHVybiBNT0RFX0NMT0NLX1JBTkdFOw0KPiANCj4gKwkv
KiBJQ0wrIGNvbWJvIFBIWSBQTEwgY2FuJ3QgZ2VuZXJhdGUgNTAwLTUzMy4yIE1IeiAqLw0KPiAr
CWlmIChpbnRlbF9waHlfaXNfY29tYm8oZGV2X3ByaXYsIHBoeSkgJiYgY2xvY2sgPiA1MDAwMDAg
JiYgY2xvY2sgPA0KPiA1MzMyMDApDQo+ICsJCXJldHVybiBNT0RFX0NMT0NLX1JBTkdFOw0KPiAr
DQo+ICsJLyogSUNMKyBUQyBQSFkgUExMIGNhbid0IGdlbmVyYXRlIDUwMC01MzIuOCBNSHogKi8N
Cj4gKwlpZiAoaW50ZWxfcGh5X2lzX3RjKGRldl9wcml2LCBwaHkpICYmIGNsb2NrID4gNTAwMDAw
ICYmIGNsb2NrIDwgNTMyODAwKQ0KPiArCQlyZXR1cm4gTU9ERV9DTE9DS19SQU5HRTsNCj4gKw0K
PiAgCS8qDQo+ICAJICogU05QUyBQSFlzJyBNUExMQiB0YWJsZS1iYXNlZCBwcm9ncmFtbWluZyBj
YW4gb25seSBoYW5kbGUgYSBmaXhlZA0KPiAgCSAqIHNldCBvZiBsaW5rIHJhdGVzLg0KPiAtLQ0K
PiAyLjM0LjENCg0K

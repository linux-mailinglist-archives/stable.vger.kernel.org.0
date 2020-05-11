Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC801CE24C
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 20:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgEKSKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 14:10:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:4569 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgEKSKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 14:10:14 -0400
IronPort-SDR: 98gKxz5/K9rTM6DFcAk8uyivC96ltEINY4oR+i5fIs7FzdpBwamb066GpVCEKzs1LXAdBAylnm
 iSAHU6Pu46Fg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 11:10:13 -0700
IronPort-SDR: UKlC9cmFBdK9gmyuH7aeggBnUzv3/qs6zavJdKM7bWc7rjtBCEjJZzekGTWdL/MzVxenycbIK3
 3OJK1CXmReFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="340631971"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2020 11:10:13 -0700
Received: from orsmsx160.amr.corp.intel.com (10.22.226.43) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 11 May 2020 11:10:13 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.83]) by
 ORSMSX160.amr.corp.intel.com ([169.254.13.187]) with mapi id 14.03.0439.000;
 Mon, 11 May 2020 11:10:12 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-drivers-review@eclists.intel.com" 
        <linux-drivers-review@eclists.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some
 memory above MAXMEM
Thread-Topic: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some
 memory above MAXMEM
Thread-Index: AQHWJ7Jv8WCvxf88Sku1+ELiZ2f0TqijjI4AgAAF0ICAAAFmgP//mw+w
Date:   Mon, 11 May 2020 18:10:12 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
 <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
 <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
In-Reply-To: <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiArCQlwcl9lcnIoIiVsbGRNQiBvZiBwaHlzaWNhbCBtZW1vcnkgaXMgbm90IGFkZHJlc3NhYmxl
IGluIHRoZSBwYWdpbmcgbW9kZVxuIiwNCj4gKwkJICAgICAgIG5vdF9hZGRyZXNzYWJsZSA+PiAy
MCk7DQoNCklzICJNQiIgdGhlIHJpZ2h0IHVuaXQgZm9yIHRoaXMuIFRoZSBwcm9ibGVtIHNlZW1z
IHRvIGhhcHBlbiBmb3Igc3lzdGVtcyB3aXRoID42NFRCIC4uLiBJIGRvdWJ0DQp0aGUgdW5hZGRy
ZXNzYWJsZSBtZW1vcnkgaXMganVzdCBhIGNvdXBsZSBvZiBNQmJ5dGVzDQoNCi1Ub255DQo=

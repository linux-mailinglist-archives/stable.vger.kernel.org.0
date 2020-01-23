Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962E6146E74
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 17:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAWQ30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 11:29:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:29228 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgAWQ30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 11:29:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 08:29:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="229902118"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga006.jf.intel.com with ESMTP; 23 Jan 2020 08:29:25 -0800
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jan 2020 08:29:25 -0800
Received: from orsmsx102.amr.corp.intel.com ([169.254.3.100]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.99]) with mapi id 14.03.0439.000;
 Thu, 23 Jan 2020 08:29:25 -0800
From:   "Yang, Fei" <fei.yang@intel.com>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
CC:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        "Jack Pham" <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using
 adb over f_fs
Thread-Topic: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when
 using adb over f_fs
Thread-Index: AQHV0XMMcRoryuKxgUWuu9vXC1fi/6f4daqA///7ALA=
Date:   Thu, 23 Jan 2020 16:29:24 +0000
Message-ID: <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
In-Reply-To: <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
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

Pj4gSGV5IGFsbCwNCj4+ICAgIEkgd2FudGVkIHRvIHNlbmQgdGhlc2Ugb3V0IGZvciBjb21tZW50
IGFuZCB0aG91Z2h0cy4NCj4+IA0KPj4gU2luY2UgfjQuMjAsIHdoZW4gdGhlIGZ1bmN0aW9uZnMg
Z2FkZ2V0IGVuYWJsZWQgc2NhdHRlci1nYXRoZXIgDQo+PiBzdXBwb3J0LCB3ZSBoYXZlIHNlZW4g
cHJvYmxlbXMgd2l0aCBhZGIgY29ubmVjdGlvbnMgc3RhbGxpbmcgYW5kIA0KPj4gc3RvcHBpbmcg
dG8gZnVuY3Rpb24gb24gaGFyZHdhcmUgd2l0aCBkd2MzIHVzYiBjb250cm9sbGVycy4NCj4+IFNw
ZWNpZmljYWxseSwgSGlLZXk5NjAsIERyYWdvbmJvYXJkIDg0NWMsIGFuZCBQaXhlbDMgZGV2aWNl
cy4NCj4NCj4gQW55IGNoYW5jZSB0aGlzOg0KPiANCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmFsYmkvdXNiLmdpdC9jb21taXQvP2g9dGVzdGluZy9u
ZXh0JmlkPWY2MzMzM2U4ZTRmZDYzZDhkOGFlODNiODlkMmMzOGNmMjFkNjQ4MDENClRoaXMgaXMg
YSBkaWZmZXJlbnQgaXNzdWUuIEkgaGF2ZSB0cmllZCBpbml0aWFsaXppbmcgbnVtX3NncyB3aGVu
IGRlYnVnZ2luZyB0aGlzIGFkYiBzdGFsbCBwcm9ibGVtLCBidXQgaXQgZGlkbid0IGhlbHAuDQoN
Cj4+IGhhcyBzb21ldGhpbmcgdG8gZG8gd2l0aCB0aGUgcHJvYmxlbSB5b3UgYXJlIHJlcG9ydGlu
Zz8NCj4NCj4+IEFuZHJ6ZWoNCg==

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675B9125C7B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLSIUQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 19 Dec 2019 03:20:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:13168 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfLSIUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 03:20:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 00:20:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="390447438"
Received: from pgsmsx114.gar.corp.intel.com ([10.108.55.203])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2019 00:20:14 -0800
Received: from pgsmsx108.gar.corp.intel.com ([169.254.8.26]) by
 pgsmsx114.gar.corp.intel.com ([10.108.55.203]) with mapi id 14.03.0439.000;
 Thu, 19 Dec 2019 16:20:13 +0800
From:   "Lee, Chiasheng" <chiasheng.lee@intel.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        "Lee, Hou-hsun" <hou-hsun.lee@intel.com>,
        "Pan, Harry" <harry.pan@intel.com>
Subject: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
 initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
Thread-Topic: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
 initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
Thread-Index: AdW2QnCZqdvVZy9RQlmMMpSte7B7Yg==
Date:   Thu, 19 Dec 2019 08:20:12 +0000
Message-ID: <DBAD849DB12B1B48BA1A6C7335FD47B540A2A63E@PGSMSX108.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWYwZjM0MDYtNGQxOS00NTcxLWJiZTItNzFkMDhkNmQwMmU4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN052SlJ3aGxtZkJpZ1VaMStKK3BhRHIza2lXRStlQXM5Y0IwTXQrTDBOcUdBZlJcL01KckpaTk9rOWlvOHI3VVcifQ==
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Commit 057d476fff778f1 ("xhci: fix USB3 device initiated resume race with roothub autosuspend")
fixes race conditions when we're dealing with a USB3 modem using v4.4 and USB3 hubs using 4.14.
Kindly apply the patch to v4.4.y and v4.14.y.


Thanks,
Chiasheng



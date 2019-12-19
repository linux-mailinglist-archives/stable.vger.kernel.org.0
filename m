Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FDA125D58
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 10:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfLSJMK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 19 Dec 2019 04:12:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:30939 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfLSJMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 04:12:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 01:12:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="222221962"
Received: from pgsmsx114.gar.corp.intel.com ([10.108.55.203])
  by fmsmga001.fm.intel.com with ESMTP; 19 Dec 2019 01:12:08 -0800
Received: from pgsmsx110.gar.corp.intel.com (10.221.44.111) by
 pgsmsx114.gar.corp.intel.com (10.108.55.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 19 Dec 2019 17:12:07 +0800
Received: from pgsmsx108.gar.corp.intel.com ([169.254.8.26]) by
 PGSMSX110.gar.corp.intel.com ([169.254.13.134]) with mapi id 14.03.0439.000;
 Thu, 19 Dec 2019 17:12:07 +0800
From:   "Lee, Chiasheng" <chiasheng.lee@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        "Lee, Hou-hsun" <hou-hsun.lee@intel.com>,
        "Pan, Harry" <harry.pan@intel.com>
Subject: RE: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
 initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
Thread-Topic: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
 initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
Thread-Index: AdW2QnCZqdvVZy9RQlmMMpSte7B7Yv//gbwA//9ycwA=
Date:   Thu, 19 Dec 2019 09:12:06 +0000
Message-ID: <DBAD849DB12B1B48BA1A6C7335FD47B540A2A6BC@PGSMSX108.gar.corp.intel.com>
References: <DBAD849DB12B1B48BA1A6C7335FD47B540A2A63E@PGSMSX108.gar.corp.intel.com>
 <20191219082900.GA1015381@kroah.com>
In-Reply-To: <20191219082900.GA1015381@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGQ2N2E3ZjktODlmZi00NjY1LWI1MGUtMWFmZDYxYTExYzE0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidG1MSTE3K2I1czBIZ29iY2hGZjIrNGJabExZZzRQWG5YRXAxK2l5Y3kyK3FpVzBrd2pDb0lxVDg1cFBETVwvaTkifQ==
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Greg,
Thanks for the promptly reply.

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Thursday, December 19, 2019 4:29 PM
> To: Lee, Chiasheng <chiasheng.lee@intel.com>
> Cc: stable@vger.kernel.org; Mathias Nyman <mathias.nyman@linux.intel.com>;
> Guenter Roeck <groeck@chromium.org>; Lee, Hou-hsun <hou-
> hsun.lee@intel.com>; Pan, Harry <harry.pan@intel.com>
> Subject: Re: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
> initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
> 
> On Thu, Dec 19, 2019 at 08:20:12AM +0000, Lee, Chiasheng wrote:
> > Hi,
> >
> > Commit 057d476fff778f1 ("xhci: fix USB3 device initiated resume race
> > with roothub autosuspend") fixes race conditions when we're dealing with a
> USB3 modem using v4.4 and USB3 hubs using 4.14.
> > Kindly apply the patch to v4.4.y and v4.14.y.
> 
> Why not 4.9.y and 4.19.y?  You can not just skip stable kernel trees, otherwise
> people upgrading will have a regression.
I (mistakenly?) thought it would be merged automagically to all the stable branches since stable@vger.kernel.org is in the CC list.
And we encountered, root-caused, and fixed/verified the issue only with v4.4 and v4.14 Chromium OS kernel.
> 
> Anyway, the reason I did not backport the patch to older kernels is that it does
> not apply at all.  If you have already done the backport (and I am guessing you
> have as otherwise how would you have tested this), please provide it to us so
> that we can apply it to all trees.
We did the backport to Chromium OS kernel v4.4 and v4.14 for test indeed. Will check with our colleagues and get back to you soon.

> 
> thanks,
> 
> greg k-h

Thanks,
Chiasheng



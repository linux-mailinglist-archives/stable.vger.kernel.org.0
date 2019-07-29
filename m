Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A37919F
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfG2Q7Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Jul 2019 12:59:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:63502 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfG2Q7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 12:59:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 09:59:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="173290566"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jul 2019 09:59:24 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 09:59:23 -0700
Received: from bgsmsx151.gar.corp.intel.com (10.224.48.42) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 09:59:23 -0700
Received: from bgsmsx104.gar.corp.intel.com ([169.254.5.156]) by
 BGSMSX151.gar.corp.intel.com ([169.254.3.157]) with mapi id 14.03.0439.000;
 Mon, 29 Jul 2019 22:29:20 +0530
From:   "Gopal, Saranya" <saranya.gopal@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Yang, Fei" <fei.yang@intel.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: RE: [PATCH 4.19.y 3/3] usb: dwc3: gadget: remove req->started flag
Thread-Topic: [PATCH 4.19.y 3/3] usb: dwc3: gadget: remove req->started flag
Thread-Index: AQHVRhOz/8sFuc4T2kaewl9H8HrlIabhdLGAgABcqjA=
Date:   Mon, 29 Jul 2019 16:59:19 +0000
Message-ID: <C672AA6DAAC36042A98BAD0B0B25BDA94CC82DB5@BGSMSX104.gar.corp.intel.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
 <1564407819-10746-4-git-send-email-saranya.gopal@intel.com>
 <20190729165611.GA14160@kroah.com>
In-Reply-To: <20190729165611.GA14160@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTM5ZTYxNDItYzFjNi00MjY2LWIwNTctOTAxNjU2NDFhMDYyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidFp3TytHV2dSbzJEUkF3dkl0NVFveTdocGhTVlJVSGpkMmFMcGJyNE05ajRhc2swNUl0dW1KWDAyeXhXNFNjYSJ9
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> >
> > [Upstream commit 7c3d7dc89e57a1d43acea935882dd8713c9e639f]
> >
> > Now that we have req->status, we don't need this extra flag
> > anymore. It's safe to remove it.
> >
> > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> > ---
> >  drivers/usb/dwc3/core.h   | 2 --
> >  drivers/usb/dwc3/gadget.c | 1 -
> >  drivers/usb/dwc3/gadget.h | 2 --
> >  3 files changed, 5 deletions(-)
> 
> Why is this patch needed for a stable tree?  It just cleans stuff up, it
> doesn't actually change any functionality.

Yes, this can be skipped.

Thanks,
Saranya

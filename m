Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2151055B0
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 16:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUPek convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 21 Nov 2019 10:34:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:54896 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfKUPej (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 10:34:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 07:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="216158521"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga001.fm.intel.com with ESMTP; 21 Nov 2019 07:34:39 -0800
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 21 Nov 2019 07:34:38 -0800
Received: from fmsmsx117.amr.corp.intel.com ([169.254.3.27]) by
 fmsmsx121.amr.corp.intel.com ([169.254.6.42]) with mapi id 14.03.0439.000;
 Thu, 21 Nov 2019 07:34:38 -0800
From:   "Williams, Mitch A" <mitch.a.williams@intel.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.19 079/422] i40e: use correct length for strncpy
Thread-Topic: [PATCH 4.19 079/422] i40e: use correct length for strncpy
Thread-Index: AQHVnpnuJAXG2g2RHUipXk6/Nek15KeV95QA///NAFA=
Date:   Thu, 21 Nov 2019 15:34:38 +0000
Message-ID: <AAEA33E297BCAC4B9BB20A7C2DF0AB8DEB1FA884@fmsmsx117.amr.corp.intel.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051404.622986351@linuxfoundation.org> <20191121103504.GC26882@amd>
In-Reply-To: <20191121103504.GC26882@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2NjZTMxNTYtMzJjZi00YTY5LWIzNWYtM2NkNWQwNGFmYTlmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiU0tYM0NFNm9xaXk2dWJFR2JoMmFsY3JNZWdHaFYxQWpTTlRNQVAxMm4wMHVvUnFnNk96TEZRbzlrSGpWK1RxXC8ifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Pavel Machek <pavel@denx.de>
> Sent: Thursday, November 21, 2019 2:35 AM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Williams, Mitch A
> <mitch.a.williams@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Sasha Levin
> <sashal@kernel.org>
> Subject: Re: [PATCH 4.19 079/422] i40e: use correct length for strncpy
> 
> Hi!
> 
> > From: Mitch Williams <mitch.a.williams@intel.com>
> >
> > [ Upstream commit 7eb74ff891b4e94b8bac48f648a21e4b94ddee64 ]
> >
> > Caught by GCC 8. When we provide a length for strncpy, we should not
> > include the terminating null. So we must tell it one less than the size
> > of the destination buffer.
> 
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
> > @@ -694,7 +694,8 @@ static long i40e_ptp_create_clock(struct i40e_pf *pf)
> >  	if (!IS_ERR_OR_NULL(pf->ptp_clock))
> >  		return 0;
> >
> > -	strncpy(pf->ptp_caps.name, i40e_driver_name, sizeof(pf->ptp_caps.name));
> > +	strncpy(pf->ptp_caps.name, i40e_driver_name,
> > +		sizeof(pf->ptp_caps.name) - 1);
> >  	pf->ptp_caps.owner = THIS_MODULE;
> >  	pf->ptp_caps.max_adj = 999999999;
> >  	pf->ptp_caps.n_ext_ts = 0;
> 
> So... pf is allocated with kzalloc, which will provide the null
> termination... so the code is okay.
> 
> On the other hand, the = 0 below is unneeded by the same logic, so
> this is a bit confusing.
> 
> Best regards,
> 								Pavel

Thanks for catching this, Pavel. Aleksandr Loktionov owns this driver now. He can get this taken care of.
-Mitch


> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

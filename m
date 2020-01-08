Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFBC134995
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgAHRmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 12:42:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:14891 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgAHRmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 12:42:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 09:42:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="217573630"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jan 2020 09:42:02 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ipFLH-00067i-HT; Wed, 08 Jan 2020 19:42:03 +0200
Date:   Wed, 8 Jan 2020 19:42:03 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Boyan Ding <boyan.j.ding@gmail.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: sunrisepoint: Add missing Interrupt Status
 register offset
Message-ID: <20200108174203.GE32742@smile.fi.intel.com>
References: <20200101204120.5873-1-boyan.j.ding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200101204120.5873-1-boyan.j.ding@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 12:41:20PM -0800, Boyan Ding wrote:
> Commit 179e5a6114cc ("pinctrl: intel: Remove default Interrupt Status
> offset") removes default interrupt status offset of GPIO controllers, 
> with previous commits explicitly providing the previously default
> offsets. However, the is_offset value in SPTH_COMMUNITY is missing,
> preventing related irq from being properly detected and handled.
> 

Pushed to my review and testing queue, thanks!

> Fixes: f702e0b93cdb ("pinctrl: sunrisepoint: Provide Interrupt Status register offset")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205745
> Cc: stable@vger.kernel.org
> Signed-off-by: Boyan Ding <boyan.j.ding@gmail.com>
> ---
>  drivers/pinctrl/intel/pinctrl-sunrisepoint.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
> index 44d7f50bbc82..d936e7aa74c4 100644
> --- a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
> +++ b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
> @@ -49,6 +49,7 @@
>  		.padown_offset = SPT_PAD_OWN,		\
>  		.padcfglock_offset = SPT_PADCFGLOCK,	\
>  		.hostown_offset = SPT_HOSTSW_OWN,	\
> +		.is_offset = SPT_GPI_IS,		\
>  		.ie_offset = SPT_GPI_IE,		\
>  		.pin_base = (s),			\
>  		.npins = ((e) - (s) + 1),		\
> -- 
> 2.24.0
> 

-- 
With Best Regards,
Andy Shevchenko



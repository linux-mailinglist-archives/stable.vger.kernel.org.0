Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7D1631B8D
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 09:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiKUIgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 03:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiKUIgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 03:36:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F861EEF1;
        Mon, 21 Nov 2022 00:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669019770; x=1700555770;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9XibHzlDtLMa4a3/w5lFbILntK28FGM/V+jykAvk+t8=;
  b=Jj9CIdgSNoD3Hk1hY/ri/vBUSCLisWZxHHDtHifEzqhU0nczid0zFtq0
   t1XQceb+qrFENep1nxZWmvhhJ5LV+Iy9RKWYUdiotbAijO2eSMCmb4pS4
   c/hPAMgGd09fdeQVm32V/uQNz+h6ch/4kf0Vk6g86AmwnIjMOy1GxdRp+
   beGDwGSlWrlAeFkC4vIpQY+ECXWlnrSSIPWXv+4pc5v60dHmZPhLzklcU
   aSoPZki7wXwGzizjydLs5THq9ziV+C8CavTm3zmPn71Sf/paDxxcyTzny
   /nDAwu0knsp46HMmyJKXXFyEOGMHvs0TrxSAAq1I1UGaEhAch9woWDoF3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="293894120"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="293894120"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 00:35:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="746815036"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="746815036"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2022 00:35:56 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ox2HS-00FBNo-2S;
        Mon, 21 Nov 2022 10:35:54 +0200
Date:   Mon, 21 Nov 2022 10:35:54 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Message-ID: <Y3s4ao9RrjyOjFfC@smile.fi.intel.com>
References: <20221120153704.9090-1-ftoth@exalondelft.nl>
 <20221120153704.9090-2-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221120153704.9090-2-ftoth@exalondelft.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, Ferry, but a few style issues in the commit message.

On Sun, Nov 20, 2022 at 04:37:03PM +0100, Ferry Toth wrote:
> Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")

It's fine to wrap this long line when it's in the commit message main body.

> Dual Role support on Intel Merrifield platform broke due to rearranging
> the call to dwc3_get_extcon().
> 
> It appears to be caused by ulpi_read_id() on the first test write failing
> with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
> DT when the test write fails and returns 0 in that case, even if DT does not
> provide the phy. As a result usb probe completes without phy.
> 
> On Intel Merrifield the issue is reproducible but difficult to find the
> root cause. Using an ordinary kernel and rootfs with buildroot ulpi_read_id()
> succeeds. As soon as adding ftrace / bootconfig to find out why,
> ulpi_read_id() fails and we can't analyze the flow. Using another rootfs
> ulpi_read_id() fails even without adding ftrace. Appearantly the issue is
> some kind of timing / race, but merely retrying ulpi_read_id() does not
> resolve the issue.

> This patch makes ulpi_read_id() return -ETIMEDOUT to its user if the first

s/This patch makes/Make/  (as per Submitting Patches: use imperative form)

> test write fails. The user should then handle it appropriately. A follow up
> patch will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.
> 
> Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
> Cc: stable@vger.kernel.org

> 

This line breaks the tag block, meaning that Fixes won't be recognized as a tag
by some scripts.

> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
> ---
>  drivers/usb/common/ulpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
> index d7c8461976ce..60e8174686a1 100644
> --- a/drivers/usb/common/ulpi.c
> +++ b/drivers/usb/common/ulpi.c
> @@ -207,7 +207,7 @@ static int ulpi_read_id(struct ulpi *ulpi)
>  	/* Test the interface */
>  	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
>  	if (ret < 0)
> -		goto err;
> +		return ret;
>  
>  	ret = ulpi_read(ulpi, ULPI_SCRATCH);
>  	if (ret < 0)
> -- 
> 2.37.2
> 

-- 
With Best Regards,
Andy Shevchenko



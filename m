Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D51338C8D
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCLMUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:20:46 -0500
Received: from mga12.intel.com ([192.55.52.136]:50734 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhCLMUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:20:22 -0500
IronPort-SDR: lGf5uX9aMqJPGD2BuXcF4TifuTR/awulL/3HdRkc5RY9U8yM0IL2MiOq+6zZRdENrYsoTrRCg1
 fN6jSo4xjZ9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="168097331"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="168097331"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:20:21 -0800
IronPort-SDR: z5VgSm8wagcN3kn4g3zc9axrQ3lFSi0woN/LqCPAM4rrwyZ7OsaOb3EUU17m/xqbuGNqOWEAp3
 lFh2tzltl4fg==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="404399361"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:20:20 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKgm9-00BqaI-PP; Fri, 12 Mar 2021 14:20:17 +0200
Date:   Fri, 12 Mar 2021 14:20:17 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpiolib: acpi: Add
 ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.10-stable tree
Message-ID: <YEtcgdYaH9lCTkpi@smile.fi.intel.com>
References: <161548637597119@kroah.com>
 <YEtaeHrJ7lS4p8HS@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEtaeHrJ7lS4p8HS@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 02:11:36PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2021 at 07:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I will send an updated version.

Here we are: https://lore.kernel.org/stable/20210312121542.67389-1-andriy.shevchenko@linux.intel.com/T/#u

-- 
With Best Regards,
Andy Shevchenko



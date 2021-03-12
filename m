Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8DA338CA8
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhCLMYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:24:33 -0500
Received: from mga12.intel.com ([192.55.52.136]:50952 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231540AbhCLMYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:24:17 -0500
IronPort-SDR: EcNo7jvpYgILljNFjfaGGzWwYtZ+49AR/1Qghwo5/8hxOhhsLwfoIu2o5vpO8oXSNosM+jtAsg
 7mOHw2Z8Zuwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="168097598"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="168097598"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:24:17 -0800
IronPort-SDR: rlBzfr+248zAE6F29B/7imuRAE1B1YJDzjAACq1Z0kgG+6huFbul9hp15Qf3CUrXgVz3LfP3An
 yqxyQQVIUmWA==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="431931372"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:24:16 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKgpx-00BqdE-Va; Fri, 12 Mar 2021 14:24:13 +0200
Date:   Fri, 12 Mar 2021 14:24:13 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpiolib: acpi: Add
 ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.4-stable tree
Message-ID: <YEtdbXkv1diR9vFd@smile.fi.intel.com>
References: <16154863759340@kroah.com>
 <YEtXnzyfm0Tbnu0e@smile.fi.intel.com>
 <YEtaIRHYvLreTKe2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEtaIRHYvLreTKe2@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 01:10:09PM +0100, Greg KH wrote:
> On Fri, Mar 12, 2021 at 01:59:27PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 11, 2021 at 07:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > No need for v5.4.
> > 
> > Please, also drop
> > gpio-pca953x-set-irq-type-when-handle-intel-galileo-gen-2.patch
> > gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch
> > 
> > from 5.4-stable queue, thanks!
> 
> Why?  If you look at the first commit above, it says:
> Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
> 
> which is in the 5.4.52 kernel release.  So why shouldn't it go there?
> 
> Same goes for the
> gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch
> patch.
> 
> Is your marking of the "Fixes:" tags incorrect somehow?
> 
> confused,

It has also Depends-on which points out that the regression only visible when
that commit is in the tree.

If you want to see them in v5.4, I can backport the series.

-- 
With Best Regards,
Andy Shevchenko



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A3E338D2B
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCLMgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:36:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:9458 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhCLMfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:35:30 -0500
IronPort-SDR: T4VUqzkqkkX7u08QCtchAiaREs1wkYG6jPJ/rrmaNuGJWYQh/c3t8gX/uoClMRZTH63gdbXSxX
 uj90C7huSQdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="208665196"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="208665196"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:35:30 -0800
IronPort-SDR: D7Ve69JA+T5ueOaCgS9gjHhEy9RctN8p88FQ9JP5qxmgYE96IUdSDE9jctMI67s0GnM2myqiHG
 zsgzXu19Bu7A==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="438411808"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:35:29 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKh0o-00Bqm5-Nz; Fri, 12 Mar 2021 14:35:26 +0200
Date:   Fri, 12 Mar 2021 14:35:26 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: pca953x: Set IRQ type when handle
 Intel Galileo Gen 2" failed to apply to 5.10-stable tree
Message-ID: <YEtgDorNvc67v+W2@smile.fi.intel.com>
References: <161548729112453@kroah.com>
 <YEta2IUohT5m28Oi@smile.fi.intel.com>
 <YEtd9ZAEbqu4Lssx@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEtd9ZAEbqu4Lssx@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 01:26:29PM +0100, Greg KH wrote:
> On Fri, Mar 12, 2021 at 02:13:12PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 11, 2021 at 07:28:11PM +0100, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > This is strange. I have just cherry-picked it clean on top of v5.10.23.
> 
> Did you build it:
> 
> drivers/gpio/gpio-pca953x.c:119:40: error: ‘ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER’ undeclared here (not in a function)
>   119 |  { "irq-gpios", &pca953x_irq_gpios, 1, ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
>       |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> :(

Because it was a series, and missed patch [1] is required as well.

[1]: https://lore.kernel.org/stable/20210312121542.67389-1-andriy.shevchenko@linux.intel.com/T/#u

-- 
With Best Regards,
Andy Shevchenko



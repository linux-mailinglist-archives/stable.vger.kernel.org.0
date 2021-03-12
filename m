Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2E338C1B
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCLL7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 06:59:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:7130 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230172AbhCLL7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 06:59:31 -0500
IronPort-SDR: q2vowQqknpht8iP5aE+3cqsZJbIt5GCxzA/VYEL5j2OJ82CFIBPZLzC+Di6dSbqPyKwl3GgDss
 zuQ0bJ8MhJjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="208661759"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="208661759"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 03:59:31 -0800
IronPort-SDR: NY/4vlf+ERxd9oVeeMzYovQcr9IgPDOb4ASSrOD11HPm2O1QXZtXu2gC1leUquzqvE1/0CutvO
 YRwvE81vSCsQ==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="510311267"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 03:59:30 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKgRz-00BqJo-EJ; Fri, 12 Mar 2021 13:59:27 +0200
Date:   Fri, 12 Mar 2021 13:59:27 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpiolib: acpi: Add
 ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.4-stable tree
Message-ID: <YEtXnzyfm0Tbnu0e@smile.fi.intel.com>
References: <16154863759340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16154863759340@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 07:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

No need for v5.4.

Please, also drop
gpio-pca953x-set-irq-type-when-handle-intel-galileo-gen-2.patch
gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch

from 5.4-stable queue, thanks!

-- 
With Best Regards,
Andy Shevchenko



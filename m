Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E520F2B0716
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 14:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKLN43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 08:56:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:2557 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgKLN42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 08:56:28 -0500
IronPort-SDR: o/XN4lwxmY5PodSn6/3rqMQwr2EvYafmI6BWJT5YjTeVwQHQOzT98UKH+q086NUoyCEW4wQyfo
 Nfo/ET30uohA==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="167725768"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="167725768"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 05:56:23 -0800
IronPort-SDR: /772Gfi4bOBF5iWdOMHv/qHLThGGvHo/kDcwAPBoz5azFBnKh3wFMQCdss4mxzor0f1XY718fG
 ZQDisV5eryKA==
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="323645261"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 05:56:20 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1kdD6I-006DYA-NR; Thu, 12 Nov 2020 15:57:22 +0200
Date:   Thu, 12 Nov 2020 15:57:22 +0200
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Evan Green <evgreen@chromium.org>,
        Andy Shevchenko <andy@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: intel: Fix Jasperlake HOSTSW_OWN offset
Message-ID: <20201112135722.GE4077@smile.fi.intel.com>
References: <20201111151650.v2.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
 <20201112091100.GZ2495@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112091100.GZ2495@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 11:11:00AM +0200, Mika Westerberg wrote:
> On Wed, Nov 11, 2020 at 03:17:28PM -0800, Evan Green wrote:
> > GPIOs that attempt to use interrupts get thwarted with a message like:
> > "pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
> > the HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
> > owned by ACPI.
> > 
> > Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin controller support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Evan Green <evgreen@chromium.org>
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Pushed to my review and testing queue, thanks!

-- 
With Best Regards,
Andy Shevchenko



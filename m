Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC2D2E94C9
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbhADMYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:24:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:53212 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbhADMY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 07:24:29 -0500
IronPort-SDR: 8JBYUxhD4F2/DZZ6fcKx0XpOulnEer3jQnMyB4paDaNNrWvkMAKyiKAhGARn2d4K6B6bMY7scE
 Xss2r+DXT20A==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="177099736"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="177099736"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 04:22:43 -0800
IronPort-SDR: U9CdSW3Q94B1mqKfQnByXYxpD/CtaH6Lcno5kdxHa9IjFTLJcCFfQ4rNNG7PDc8LLMTGlN6u9z
 j6caAS+HDCyQ==
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="397387626"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 04:22:41 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kwOtj-001Z8n-P0; Mon, 04 Jan 2021 14:23:43 +0200
Date:   Mon, 4 Jan 2021 14:23:43 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moody Salem <moody@uniswap.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ACPI / scan: Don't create platform device for INT3515
 ACPI nodes
Message-ID: <20210104122343.GT4077@smile.fi.intel.com>
References: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
 <ae94a191-4273-0000-deda-4859034343b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae94a191-4273-0000-deda-4859034343b8@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 12:59:39PM +0100, Hans de Goede wrote:
> On 12/23/20 3:36 PM, Heikki Krogerus wrote:
> > There are several reports about the tps6598x causing
> > interrupt flood on boards with the INT3515 ACPI node, which
> > then causes instability. There appears to be several
> > problems with the interrupt. One problem is that the
> > I2CSerialBus resources do not always map to the Interrupt
> > resource with the same index, but that is not the only
> > problem. We have not been able to come up with a solution
> > for all the issues, and because of that disabling the device
> > for now.
> > 
> > The PD controller on these platforms is autonomous, and the
> > purpose for the driver is primarily to supply status to the
> > userspace, so this will not affect any functionality.
> > 
> > Reported-by: Moody Salem <moody@uniswap.org>
> > Fixes: a3dd034a1707 ("ACPI / scan: Create platform device for INT3515 ACPI nodes")
> > Cc: stable@vger.kernel.org
> > Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1883511
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> Thank you for your patch, I've applied this patch to my review-hans 
> branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans
> 
> Note it will show up in my review-hans branch once I've pushed my
> local branch there, which might take a while.
> 
> Once I've run some tests on this branch the patches there will be
> added to the platform-drivers-x86/for-next branch and eventually
> will be included in the pdx86 pull-request to Linus for the next
> merge-window.

I'm wondering if my reply has been seen...

https://lore.kernel.org/platform-driver-x86/ae94a191-4273-0000-deda-4859034343b8@redhat.com/T/#m30308ca22cd0ce266aa6913ab7ef1fc56b3279de


-- 
With Best Regards,
Andy Shevchenko



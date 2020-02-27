Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5116E171490
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgB0J7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:59:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:33573 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgB0J7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 04:59:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 01:59:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,491,1574150400"; 
   d="scan'208";a="285280945"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Feb 2020 01:59:06 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1j7Fwi-005948-Gg; Thu, 27 Feb 2020 11:59:08 +0200
Date:   Thu, 27 Feb 2020 11:59:08 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, kurt@linutronix.de,
        lirongqing@baidu.com, stable@vger.kernel.org, vikram.pandita@ti.com
Subject: Re: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in
 advance" failed to apply to 4.14-stable tree
Message-ID: <20200227095908.GC1224808@smile.fi.intel.com>
References: <158271336456142@kroah.com>
 <20200226233949.GC22178@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226233949.GC22178@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 06:39:49PM -0500, Sasha Levin wrote:
> On Wed, Feb 26, 2020 at 11:36:04AM +0100, gregkh@linuxfoundation.org wrote:

...

> > Since this change we don't need to have custom solutions in 8250_aspeed_vuart
> > and 8250_of drivers, thus, drop them.
> > 
> > Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
> > Reported-by: Li RongQing <lirongqing@baidu.com>
> > Cc: Kurt Kanzenbach <kurt@linutronix.de>
> > Cc: Vikram Pandita <vikram.pandita@ti.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: stable <stable@vger.kernel.org>
> > Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
> > Link: https://lore.kernel.org/r/20200211135559.85960-1-andriy.shevchenko@linux.intel.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> For 4.14, I've worked around these missing commits:
> 
> 5909c0bf9c7a ("serial/aspeed-vuart: Implement quick throttle mechanism")
> 989983ea849d ("serial/aspeed-vuart: Implement rx throttling")
> 54e53b2e8081 ("tty: serial: 8250: pass IRQ shared flag to UART ports")

Thanks!

> And queued up a backport. Older kernels are a bit trickier than that.

Since it's quite old bug and not many reports so far I guess we are not in
hurry to fix that old kernels.

-- 
With Best Regards,
Andy Shevchenko



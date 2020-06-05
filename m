Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335A41F0004
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgFESpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 14:45:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:32603 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgFESpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 14:45:40 -0400
IronPort-SDR: ZY00p+HTqIiocQ9SQZjocLDKNE4akfyZwU0IkouQ9umJ+NclvzN3Jh8vJ8/+fHXDqsySu2ZoBw
 WLlBUCAu52lg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 11:45:40 -0700
IronPort-SDR: Em2SwIApaOChD8ivBSlj6BODCCRiddGWah0O4ySqgGsb0gCpqtOSQm38t0f2Hd2aZIN7CrVwp3
 Hr5AkR6fJpOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="273556712"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006.jf.intel.com with ESMTP; 05 Jun 2020 11:45:38 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jhHLZ-00B5tA-GI; Fri, 05 Jun 2020 21:45:41 +0300
Date:   Fri, 5 Jun 2020 21:45:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while
 on gpiod_get(..., GPIOD_OUT_HIGH)
Message-ID: <20200605184541.GU2428291@smile.fi.intel.com>
References: <20200602122130.45630-1-hdegoede@redhat.com>
 <20200602152317.GI2428291@smile.fi.intel.com>
 <ba931618-9259-aca0-142c-c1dfb67e737e@redhat.com>
 <20200605170931.GR2428291@smile.fi.intel.com>
 <1cf9b188-1e59-b321-6909-bf6afa93685d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cf9b188-1e59-b321-6909-bf6afa93685d@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 07:31:35PM +0200, Hans de Goede wrote:
> On 6/5/20 7:09 PM, Andy Shevchenko wrote:
> > On Fri, Jun 05, 2020 at 04:33:47PM +0200, Hans de Goede wrote:
> > > On 6/2/20 5:23 PM, Andy Shevchenko wrote:
> > > > On Tue, Jun 02, 2020 at 02:21:30PM +0200, Hans de Goede wrote:

...

> > > Sure, not sure if that is worth respinning the patch for though,
> > > either way let me know.
> > 
> > I think makes sense to respin. We still have time.
> 
> I wasn't talking about timing, more just that it creates extra
> work (for me) and if that was just for the capital 'B' thingie it
> would not be worth the extra work IMHO, but since we need a v2 for
> the fixes tag anyways I'll fix this as well.

I got your point, no problem, I would fix myself, if it is only the comment
to address.

...

> > Btw, can we for sake of consistency update direction_input() as well?
> 
> Sure, the change for that will be quite small, so shall I out it
> in this patch, or do you want a second patch for that?

I think we can do in one.

-- 
With Best Regards,
Andy Shevchenko



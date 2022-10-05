Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2C5F511A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 10:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJEIo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 04:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJEIo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 04:44:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35A21A828;
        Wed,  5 Oct 2022 01:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664959495; x=1696495495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=elwF0zRXApeooFfPNF0C1cxDBpdF/2kxdpqipgtP+uY=;
  b=ZabGbvYk4ukm7beiBg1KR7vX02IymTkkrULzf9fVP5DrJp1p9e0JleS5
   0bsy2tafxzW8jsLXJ1y0lOgWibQPtAN23t5KpEeWlzZIPH/LybU9+0rXV
   TGdr1QOdNwvAd3AtwLLcXQxzvWjO2ctM1wUD3HvB0Mn9Q1k5yNZMQMl89
   KDme7Roi5kyQZD64ZpST8KfT1d9Bgumr7VmjDuoonj4JwB14hXFG2gFiv
   PGOz1PMJV/I5hHA9/uIjol0v9oh5r1vScvl7o4fp24T6Wwk0ScA0WqF4Q
   4ypre/LSje8/n7j1xyWkvrBwbZoDFoHomzIlTumZZkfbQ+AdzNpJfH/8g
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="367229213"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="367229213"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 01:44:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="619404495"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="619404495"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2022 01:44:53 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1og01L-002ZDI-1T;
        Wed, 05 Oct 2022 11:44:51 +0300
Date:   Wed, 5 Oct 2022 11:44:51 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ferry Toth <fntoth@gmail.com>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Message-ID: <Yz1EA5g+2s7Bow3M@smile.fi.intel.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <CAHQ1cqG9-SDM4_zUfCvxP7XD-U+PPOWqWDBFKU73ecomDpt9Jw@mail.gmail.com>
 <25bc7dbe-f530-298f-f826-087606cf9491@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25bc7dbe-f530-298f-f826-087606cf9491@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 10:10:42AM +0200, Ferry Toth wrote:
> On 05-10-2022 04:39, Andrey Smirnov wrote:
> > On Tue, Oct 4, 2022 at 7:12 PM Thinh Nguyen<Thinh.Nguyen@synopsys.com>  wrote:

...

> > FWIW, I just got the same HW Ferry has last week and am planning to
> > work on this over the weekend.
> I can help you setup, we have binary images available on github as well as
> Yocto recipies to build them.

Also you can build all components (U-Boot, kernel, Buildroot initrd) separately
as explained here:
https://edison-fw.github.io/edison-wiki/u-boot-update
https://edison-fw.github.io/edison-wiki/vanilla
https://github.com/andy-shev/buildroot/tree/intel/board/intel/common


-- 
With Best Regards,
Andy Shevchenko



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC67528CD2B
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 13:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgJML53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 07:57:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:34936 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbgJMLys (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 07:54:48 -0400
IronPort-SDR: Scd0mm16A64LiqS+eh/1r45Ks+uPMg4iDIj6ll6VrSgdDmHP1qn3zi/o32A7o15W0FRGPMPBpQ
 q8RPUMgy8j5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="227534122"
X-IronPort-AV: E=Sophos;i="5.77,370,1596524400"; 
   d="scan'208";a="227534122"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 04:54:48 -0700
IronPort-SDR: F944B7h/7nzU6a6i3JexdZZDLrmZFFivxWDYZzRvDVoPCqI8W1H5uWlgmxy/W1luG63OD/pXOu
 8GdFE1RXTNJA==
X-IronPort-AV: E=Sophos;i="5.77,370,1596524400"; 
   d="scan'208";a="356131387"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 04:54:44 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kSIuA-005nGI-Dq; Tue, 13 Oct 2020 14:55:46 +0300
Date:   Tue, 13 Oct 2020 14:55:46 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Pratham Pratap <prathampratap@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        rafael.j.wysocki@intel.com, mathias.nyman@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sallenki@codeaurora.org, mgautam@codeaurora.org,
        jackp@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: Don't wait for completion of urbs
Message-ID: <20201013115546.GM4077@smile.fi.intel.com>
References: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 04:17:02PM +0530, Pratham Pratap wrote:

...

> Fixes: 3e35bf39e (USB: fix codingstyle issues in drivers/usb/core/message.c)

Two hints how to use Git with Linux kernel development.

First is about what Greg pointed out, i.e. proper Fixes line.

Add to your ~/.gitconfig the following:

	[core]
		abbrev = 12

	[alias]
		one = show -s --pretty='format:%h (\"%s\")'

In result you may run

	git one 3e35bf39e

and use the output.

Second one is about Cc list. I recommend to use

	scripts/get_maintainer.pl --git --git-min-percent=67

to retrieve it.


-- 
With Best Regards,
Andy Shevchenko



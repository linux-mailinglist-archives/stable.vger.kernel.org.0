Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A311514406D
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 16:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgAUPYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 10:24:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:50642 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgAUPYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 10:24:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 07:24:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,346,1574150400"; 
   d="scan'208";a="220949034"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jan 2020 07:24:37 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1itvOL-0007Xj-PW; Tue, 21 Jan 2020 17:24:33 +0200
Date:   Tue, 21 Jan 2020 17:24:33 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vipul Kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Bin Gao <bin.gao@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Message-ID: <20200121152433.GW32742@smile.fi.intel.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 08:11:57PM +0530, Vipul Kumar wrote:
> From: Vipul Kumar <vipul_kumar@mentor.com>
> 
> commit f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE
> flags on Intel Atom SoCs"), is setting TSC_KNOWN_FREQ and TSC_RELIABLE
> flags for Soc's which is causing time drift on Valleyview/Bay trail Soc.
> 
> This patch introduces a new macro to skip these flags.

I guess commit message still needs to provide the measurements
for the both with and without the option being selected.

-- 
With Best Regards,
Andy Shevchenko



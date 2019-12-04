Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF83113606
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 20:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDTzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 14:55:00 -0500
Received: from mga17.intel.com ([192.55.52.151]:2913 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbfLDTzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 14:55:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 11:54:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,278,1571727600"; 
   d="scan'208";a="385880304"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005.jf.intel.com with ESMTP; 04 Dec 2019 11:54:56 -0800
Received: from andy by smile with local (Exim 4.93-RC1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1icajg-0000lw-9Q; Wed, 04 Dec 2019 21:54:56 +0200
Date:   Wed, 4 Dec 2019 21:54:56 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Tuowen Zhao <ztuowen@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org, linux@roeck-us.net,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v5 2/4] lib: devres: add a helper function for ioremap_uc
Message-ID: <20191204195456.GR32742@smile.fi.intel.com>
References: <20191016210629.1005086-3-ztuowen@gmail.com>
 <20191017143144.9985421848@mail.kernel.org>
 <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
 <20191018164738.GY31224@sasha-vm>
 <7eb0ed7d51b53f7d720a78d9b959c462adb850d4.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb0ed7d51b53f7d720a78d9b959c462adb850d4.camel@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 08:51:30AM -0700, Tuowen Zhao wrote:
> Hi Sasha,
> 
> Sorry to bother. Can I ask for patches in this series to NOT be applied
> to stable?
> 
> They causes build failure on Hexagon.
> 
> Relevant patches include
> 
> sparc64: implement ioremap_uc
> lib: devres: add a helper function for ioremap_uc
> mfd: intel-lpss: Use devm_ioremap_uc for MMIO

Since Guenter submitted a fix, we can leave with these ones and fix applied together.

-- 
With Best Regards,
Andy Shevchenko



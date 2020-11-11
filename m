Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF52AFB25
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 23:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKKWNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 17:13:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:47570 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgKKWNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Nov 2020 17:13:02 -0500
IronPort-SDR: mQQkc7YFjt0ykhIKax5+VyNr5Q+tC5xo7IZ5Xx71gFI903S3gau9ac+j+ru5jBw2VEREtiC5dQ
 OHe4oO2QpPtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="254934223"
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="254934223"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 14:13:01 -0800
IronPort-SDR: oc+ody3g8xZ/L2AxXe4jREsKbIgl3VLQlwX9uSzn6jJV1BRL+bGe1qNFmW4q0i4qrzv8PCTuFd
 3voHy987I57w==
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="474015871"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 14:12:59 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1kcyNM-0064C2-T8; Thu, 12 Nov 2020 00:14:00 +0200
Date:   Thu, 12 Nov 2020 00:14:00 +0200
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     Andy Shevchenko <andy@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: intel: Fix Jasperlake hostown offset
Message-ID: <20201111221400.GT4077@smile.fi.intel.com>
References: <20201110144932.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110144932.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 02:49:49PM -0800, Evan Green wrote:
> GPIOs that attempt to use interrupts get thwarted with a message like:
> "pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
> the JSL_HOSTSW_OWN offset is incorrect, so every GPIO looks like it's

Simply HOSTSW_OWN, and same spelling in the subject, please.

> owned by ACPI.


> Signed-off-by: Evan Green <evgreen@chromium.org>

> Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin
> controller support")

It must be one line, and put it first in the tag block


> Cc: stable@vger.kernel.org

This is second one...

 Fixes: ...
 Cc: ...
 SoB: ...


-- 
With Best Regards,
Andy Shevchenko



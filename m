Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF8915411F
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 10:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgBFJZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 04:25:26 -0500
Received: from mga18.intel.com ([134.134.136.126]:40871 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgBFJZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 04:25:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 01:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,409,1574150400"; 
   d="scan'208";a="225204860"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 06 Feb 2020 01:25:20 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1izdPV-0005xv-8a; Thu, 06 Feb 2020 11:25:21 +0200
Date:   Thu, 6 Feb 2020 11:25:21 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Michal Stanek <mst@semihalf.com>
Cc:     linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stanekm@google.com,
        stable@vger.kernel.org, mw@semihalf.com, levinale@chromium.org,
        mika.westerberg@linux.intel.com, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, rafael.j.wysocki@intel.com
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation
 of ACPI GPIO numbers
Message-ID: <20200206092521.GM10400@smile.fi.intel.com>
References: <20200205194804.1647-1-mst@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205194804.1647-1-mst@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 08:48:04PM +0100, Michal Stanek wrote:
> Dropping custom Linux GPIO translation caused some Intel_Strago based Chromebooks
> with old firmware to detect GPIOs incorrectly. Add quirk which restores some code removed by
> commit 03c4749dd6c7ff94 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation").

And on top what Mika asked already, is it a real problem to update firmware?

-- 
With Best Regards,
Andy Shevchenko



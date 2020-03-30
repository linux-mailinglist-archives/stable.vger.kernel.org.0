Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16EB19823B
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 19:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgC3RYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 13:24:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:9708 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgC3RYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 13:24:42 -0400
IronPort-SDR: LZW4YUZWP6x5AjKPuSwUbf7rMS8XjYbfEUiK1x5bN/atnFHIOKvCQWxcl8POnPoYczOyAgu8UG
 ohc+hXShLsEA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 10:24:41 -0700
IronPort-SDR: khEsAdfQ04GnUcVnWdSUII4a7icC2ARyfKpe9a3E8IN6sFpeiSQJS8QR5d6IU4j8PAaPonk3FW
 wTm72Hn1eCIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="242091499"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2020 10:24:37 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jIy9P-00EGgo-L6; Mon, 30 Mar 2020 20:24:39 +0300
Date:   Mon, 30 Mar 2020 20:24:39 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Gayatri Kammela <gayatri.kammela@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Alex Hung <alex.hung@canonical.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Prestopine, Charles D" <charles.d.prestopine@intel.com>,
        "5 . 6+" <stable@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
Message-ID: <20200330172439.GB1922688@smile.fi.intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
 <9359b8e261d69983b1eed2b8e53ef9eabfdfdd51.1585343507.git.gayatri.kammela@intel.com>
 <CAJZ5v0j8OaqM6k52Ar9sYn0Ea_u9+MBB0rcMWv6vGBt5jXCQBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0j8OaqM6k52Ar9sYn0Ea_u9+MBB0rcMWv6vGBt5jXCQBQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 06:43:35PM +0200, Rafael J. Wysocki wrote:
> On Fri, Mar 27, 2020 at 10:34 PM Gayatri Kammela
> <gayatri.kammela@intel.com> wrote:

> > -       {"INT1044"},
> > -       {"INT1047"},
> > +       {"INTC1040"},
> > +       {"INTC1043"},
> > +       {"INTC1044"},
> > +       {"INTC1047"},
> >         {"INT3400"},
> >         {"INT3401", INT3401_DEVICE},
> >         {"INT3402"},
> > --
> 
> I can take this along with the other two patches in the series if that
> is fine by Andy and Rui.

One nit is to fix the ordering to be alphanumeric or close enough
(I admit in some cases it might require unneeded churn) to that.

Otherwise,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko



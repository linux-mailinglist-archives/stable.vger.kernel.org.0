Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC037248694
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgHRN7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 09:59:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:6235 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgHRN7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 09:59:15 -0400
IronPort-SDR: ECTFD+Vy/AiinvVFxYnyWe4OMVlGSGVDu14AoQjef55R9k5RHOvt+R8aghpU6DjeIzQjdcFqWE
 EeVb8KqZx7HA==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="142727642"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="142727642"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 06:59:14 -0700
IronPort-SDR: ZzBhsuvjm3xU3UhDw15q+h5fMIAQ25tpgRXhCD0E0mzNYgNdnf9rD+zGRHDuzLRRN2CdyO2wqU
 wq6JWNqzHKGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="326735454"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2020 06:59:11 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1k828r-009f0z-Mx; Tue, 18 Aug 2020 16:59:09 +0300
Date:   Tue, 18 Aug 2020 16:59:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stanekm@google.com, stable <stable@vger.kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, levinale@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        bgolaszewski@baylibre.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation
 of ACPI GPIO numbers
Message-ID: <20200818135909.GS1891694@smile.fi.intel.com>
References: <20200206083149.GK2667@lahna.fi.intel.com>
 <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com>
 <20200207075654.GB2667@lahna.fi.intel.com>
 <CAMiGqYjmd2edUezEXsX4JBSyOozzks1Pu8miPEviGsx=x59nZQ@mail.gmail.com>
 <20200210101414.GN2667@lahna.fi.intel.com>
 <CAMiGqYiYp=aSgW-4ro5ceUEaB7g0XhepFg+HZgfPvtvQL9Z1jA@mail.gmail.com>
 <20200310144913.GY2540@lahna.fi.intel.com>
 <20200417020641.GA145784@google.com>
 <20200417090500.GM2586@lahna.fi.intel.com>
 <CA+ASDXM9mrkGfxtVVNWkqnDNzcok2LAqdfVbQL2RV7yWE0tMWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXM9mrkGfxtVVNWkqnDNzcok2LAqdfVbQL2RV7yWE0tMWw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 05:55:44PM -0700, Brian Norris wrote:
> - Michal (bouncing)
> 
> On Fri, Apr 17, 2020 at 2:05 AM Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > I wonder if we can add back the previous GPIO base like this?
> 
> Thanks for the patch! At first glance, it looks like the right kind of
> thing. Unfortunately, it doesn't appear to work quite right for me.
> I'm out of time for today to look any further, but I (or perhaps
> someone else on this email) will try to follow up next week sometime.

Just in case you are going to do something about this, take into consideration
that Cherryview driver got several cleanups in the past, it may require to
rework this on top of the made changes.

P.S. Currently they are in my branch, but within couple of days it will be in
Linux Next if nothing prevents it.

-- 
With Best Regards,
Andy Shevchenko



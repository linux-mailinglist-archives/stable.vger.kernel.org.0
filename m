Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6EC2AF062
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 13:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgKKMSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 07:18:00 -0500
Received: from mga17.intel.com ([192.55.52.151]:6097 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgKKMQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Nov 2020 07:16:05 -0500
IronPort-SDR: if+ilNbfvERO7DguXrCdYqWD3FXFIIZEYXRld43cPevjgRsfLe7rAEjJpAmKotthxieCZOrRRu
 m6Pd56CqeiXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149984855"
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="149984855"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 04:15:29 -0800
IronPort-SDR: P0pxOyGYOJXKe5WjlCj0CoXCOjRax99APokYTyNSKuPFTrHrvLEVn0MYLxrN2Co+5fOKc4Am2B
 nM6KIiM7rTug==
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="541768713"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 04:15:27 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1kcp37-005u0W-C7; Wed, 11 Nov 2020 14:16:29 +0200
Date:   Wed, 11 Nov 2020 14:16:29 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     Andy Shevchenko <andy@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: intel: Fix Jasperlake hostown offset
Message-ID: <20201111121629.GL4077@smile.fi.intel.com>
References: <20201110144932.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
 <CAHp75VcfmJ6-cqCsZ6BjbghGDt+w-AbxGxLoWG61VVF2Knor-Q@mail.gmail.com>
 <CAE=gft4vdBytT2=tCbv2aE3RRoDut5CiHdBODjXJamGM5yB3Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE=gft4vdBytT2=tCbv2aE3RRoDut5CiHdBODjXJamGM5yB3Bw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 04:03:57PM -0800, Evan Green wrote:
> On Tue, Nov 10, 2020 at 3:48 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Wednesday, November 11, 2020, Evan Green <evgreen@chromium.org> wrote:
> >>
> >> GPIOs that attempt to use interrupts get thwarted with a message like:
> >> "pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
> >> the JSL_HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
> >> owned by ACPI.
> >
> >
> > Funny, I have created a similar patch few hours ago. Are you sure this is enough? In mine I have also padcfglock updated. But I have to confirm that, that’s why I didn’t send it out.
> 
> Oh weird! I didn't check padcfglock since it didn't happen to be
> involved in the bug I was tracking down. I was trying to clean out
> some skeletons in my kernel closet [1] and debugged it down to this.
> 
> If you want to smash the two patches together I'm fine with that. Let
> me know, and CC me if you do post something.

Can you test that 0x90 is correct value for padcfglock offset?

> [1] https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master/overlay-dedede/sys-kernel/chromeos-kernel-5_4/files/0001-CHROMIUM-pinctrl-intel-Allow-pin-as-IRQ-even-in-ACPI.patch

-- 
With Best Regards,
Andy Shevchenko



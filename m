Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767374379A0
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhJVPMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:12:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:51532 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233086AbhJVPMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 11:12:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="216486644"
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="216486644"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 08:09:37 -0700
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="445321281"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 08:09:35 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mdwAT-0008kI-9n;
        Fri, 22 Oct 2021 18:09:13 +0300
Date:   Fri, 22 Oct 2021 18:09:13 +0300
From:   "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Message-ID: <YXLUGCC9GdY4SeH6@smile.fi.intel.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
 <YWV4bnbn7VXjYWWy@google.com>
 <FC366D8C-0360-49B2-B641-5A3FD50E3398@live.com>
 <YWg/1zcfMN2+vuiJ@smile.fi.intel.com>
 <YXFL05vXfoCV/Go/@google.com>
 <054143A2-888C-42DF-947A-8CEAFF155292@live.com>
 <YXJvMscD129bLvGN@google.com>
 <PNZPR01MB44151488C970DB48157D5AFCB8809@PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PNZPR01MB44151488C970DB48157D5AFCB8809@PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 22, 2021 at 12:43:33PM +0000, Aditya Garg wrote:
> I am really sorry. I don’t have any experience regarding submitting patches upstream. I copied and pasted the diff generated using git. My email client doesn’t seem to support git send email. I would be happy if I could get some guidance.

First and very important guidance: do not top-post!

Next, as Lee pointed out there are available documents on how to submit patches
properly. Please, read them (they are available inside kernel source tree as
well).

TL;DR: again as Lee said, `git format-patch` (produces a file in mbox format)
followed by `git send-email` will suffice.

> From: Lee Jones <lee.jones@linaro.org>
> Sent: Friday, October 22, 2021 1:28:42 PM
> To: Aditya Garg <gargaditya08@live.com>
> Cc: andriy.shevchenko@linux.intel.com <andriy.shevchenko@linux.intel.com>; stable@vger.kernel.org <stable@vger.kernel.org>; Orlando Chamberlain <redecorating@protonmail.com>
> Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N UART
> 
> On Fri, 22 Oct 2021, Aditya Garg wrote:
> 
> >
> > From 76d8253d90233b2c2d3fbc82355c603bf0eb9964 Mon Sep 17 00:00:00 2001
> > From: Orlando Chamberlain <redecorating@protonmail.com>
> > Date: Fri, 1 Oct 2021 13:30:19 +0530
> > Subject: [PATCH] Add support for MacBookPro16,2 UART
> > Cc: stable@vger.kernel.org
> 
> What is this?
> 
> These headers should not be part of the patch.
> 
> How are you submitting this?
> What tools are you using?
> Did you read the documents I sent you (see below)?
> 
> > Added 8086:38a8 to the intel_lpss_pci driver. It is an Intel Ice Lake PCH-N UART controller present on the MacBookPro16,2.
> 
> This line is too long.
> 
> > Signed-off-by: Aditya Garg <gargaditya08@live.com>
> > ---
> >  drivers/mfd/intel-lpss-pci.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> This diff looks better.
> 
> > diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
> > index c54d19fb1..33d5043fd 100644
> > --- a/drivers/mfd/intel-lpss-pci.c
> > +++ b/drivers/mfd/intel-lpss-pci.c
> > @@ -253,6 +253,8 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
> >        { PCI_VDEVICE(INTEL, 0x34ea), (kernel_ulong_t)&bxt_i2c_info },
> >        { PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
> >        { PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },
> > +     /* ICL-N*/
> > +     { PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },
> >        /* TGL-H */
> >        { PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
> >        { PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },
> >
> > > On 21-Oct-2021, at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Thu, 14 Oct 2021, andriy.shevchenko@linux.intel.com wrote:
> > >
> > >> On Thu, Oct 14, 2021 at 04:15:05AM +0000, Aditya Garg wrote:
> > >>
> > >> Entire message looks like a mess. Are you sure you are using proper tools
> > >> for sending it?
> > >
> > > Agreed.
> > >
> > > I can't apply this until it's submitted properly.
> > >
> > > - Please read Documentation/process/submitting-patches.rst
> > > - Please read Documentation/process/coding-style.rst
> > >
> > > If you have any questions, please reach out.  We're happy to help.
> > >
> 
> This quoted text can't be part of a submitted patch.
> 
> Please submit the patch on its own, as a new thread, using the correct
> tooling (provided mostly by the Git package (i.e. `git format-patch`
> and `git send-email`).
> 
> If you're stuck, or there is something you do not understand, please
> ask.

-- 
With Best Regards,
Andy Shevchenko



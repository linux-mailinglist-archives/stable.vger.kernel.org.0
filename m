Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B2F38A09B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhETJLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:11:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:1951 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhETJLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:11:18 -0400
IronPort-SDR: oZwntUpz1n5qps2akWKAOO9Vo1+DjqgX9DmXBsInAovJcPkZBEJxNaNY1QG0tK6aOKleeOiWqf
 sgOPMvUSoAIQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="188310055"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="188310055"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 02:09:57 -0700
IronPort-SDR: 36flDbMelT1FAQcSXcjMe/L6FNkDnp1SQbWF/xEPMQ+eje3TPRz6dX5xf5XXYXfMpDYrKfls2Z
 oJQjwid8625A==
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="412113558"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 02:09:55 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ljegi-00DRVG-Tc; Thu, 20 May 2021 12:09:52 +0300
Date:   Thu, 20 May 2021 12:09:52 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sachi King <nakato@nakato.io>
Subject: Re: [PATCH] pinctrl/amd: Add device HID for new AMD GPIO controller
Message-ID: <YKYnYCaoUDwjS1gL@smile.fi.intel.com>
References: <20210512210316.1982416-1-luzmaximilian@gmail.com>
 <CACRpkdZpm4w6Ym2p9xTsYpkU7CR531aLUUxXj54tssoqd6c9=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZpm4w6Ym2p9xTsYpkU7CR531aLUUxXj54tssoqd6c9=Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 01:50:50AM +0200, Linus Walleij wrote:
> On Wed, May 12, 2021 at 11:03 PM Maximilian Luz <luzmaximilian@gmail.com> wrote:
> 
> > Add device HID AMDI0031 to the AMD GPIO controller driver match table.
> > This controller can be found on Microsoft Surface Laptop 4 devices and
> > seems similar enough that we can just copy the existing AMDI0030 entry.
> >
> > Cc: <stable@vger.kernel.org> # 5.10+
> 
> Why? It's hardly a regression?

IIRC the stable policy allows to backport new IDs.

> > Tested-by: Sachi King <nakato@nakato.io>
> > Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> 
> I've applied the patch for next without the stable tag for now.

It can be pulled to stable afterwards anyway :-)

-- 
With Best Regards,
Andy Shevchenko



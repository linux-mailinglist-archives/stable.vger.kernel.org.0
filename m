Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7118BB31
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 16:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCSPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 11:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgCSPd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 11:33:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452032071C;
        Thu, 19 Mar 2020 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584632036;
        bh=jd+G1ZXXV6Rkt+GeOtGC574lN8RiNuBcxcec4Go/w9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RYBhvYmU0QMgqTdV3Y5Uze1eZpOjJ4fx0clF9xAlLu2XJH8gT4s9DSb7EJ7RWJ1WB
         DVjZSmcvVbl/Kpp7n3wR8SDL3OWWZ2gi0QJzj1yalGvvKQjMU4YATVzlHXVSOIe4Tr
         PASt4nDgbvk4f1tACPVNsn4VnjRLskPnJ2DnsS5Q=
Date:   Thu, 19 Mar 2020 16:33:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH 5.5 00/65] 5.5.11-rc1 review
Message-ID: <20200319153354.GA133412@kroah.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <fcf6db4c-cebe-9ad3-9f19-00d49a7b1043@roeck-us.net>
 <20200319145900.GC92193@kroah.com>
 <32c627bf-0e6b-8bc4-88d3-032a69484aa6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32c627bf-0e6b-8bc4-88d3-032a69484aa6@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 08:15:40AM -0700, Guenter Roeck wrote:
> On 3/19/20 7:59 AM, Greg Kroah-Hartman wrote:
> > On Thu, Mar 19, 2020 at 07:44:33AM -0700, Guenter Roeck wrote:
> >> On 3/19/20 6:03 AM, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.5.11 release.
> >>> There are 65 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>
> >> arm:davinci_all_defconfig fails to build.
> >>
> >> include/linux/gpio/driver.h: In function 'gpiochip_populate_parent_fwspec_twocell':
> >> include/linux/gpio/driver.h:552:1: error: no return statement in function returning non-void [-Werror=return-type]
> >>   552 | }
> >>
> >> The problem is caused by commit 8db6a5905e98 ("gpiolib: Add support for the
> >> irqdomain which doesn't use irq_fwspec as arg") which is missing its fix,
> >> commit 9c6722d85e922 ("gpio: Fix the no return statement warning"). That one
> >> is missing a Fixes: tag, providing a good example why such tags are desirable.
> > 
> > Thanks for letting me know, I've now dropped that patch (others
> > complained about it for other reasons) and will push out a -rc2 with
> > that fix.
> > 
> 
> I did wonder why the offending patch was included, but then I figured that
> I lost the "we apply too many patches to stable releases" battle, and I didn't
> want to re-litigate it.

It wasn't that, it was a pre-requisite for patch #2.  patch #2 was
reworked so we could drop this one.

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37302A0793
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJ3ON1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:13:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:45230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgJ3ON1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 10:13:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604067205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nwOnvIz4I7qfcrU1oQnSgUqWuk7WsnNmbrQgR3aBHS0=;
        b=QUqZR0wMEh0dSO6MjjDAFA++uU4ZaXtL/5xNBLvRjzFE3nsxB6QwTLCCBYn5rSW2U1jwzi
        opi27EKULmXHTkOy8gt579jzZvBDz4VzGz4jjJba1pf1Ti0tijJcLVj5yDeLh19bP0x5dZ
        tIqssSZ5AwLXtOrl8G6QE6NSBU4RAiw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5FD6CAE2B;
        Fri, 30 Oct 2020 14:13:25 +0000 (UTC)
Date:   Fri, 30 Oct 2020 15:13:24 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] reboot: fix overflow parsing reboot cpu number
Message-ID: <20201030141324.GD1602@alley>
References: <20201027133545.58625-1-mcroce@linux.microsoft.com>
 <20201027133545.58625-2-mcroce@linux.microsoft.com>
 <20201027134243.GC991306@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027134243.GC991306@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2020-10-27 14:42:43, Greg KH wrote:
> On Tue, Oct 27, 2020 at 02:35:44PM +0100, Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> > 
> > Limit the CPU number to num_possible_cpus(), because setting it
> > to a value lower than INT_MAX but higher than NR_CPUS produces the
> > following error on reboot and shutdown:
> > 
> > Fixes: 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
> > Signed-off-by: Matteo Croce <mcroce@microsoft.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

The best way is to add the following line before Signed-off-by line:

Cc: stable@vger.kernel.org

Best Regards,
Petr

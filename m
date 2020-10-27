Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C5E29AD94
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752397AbgJ0Nlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752389AbgJ0Nlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:41:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44E1F218AC;
        Tue, 27 Oct 2020 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603806101;
        bh=5kiN68s+oA2+/lGYUImSBswROvtagOeM1QaDKdkTXpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JC22Cxn+BMHjZuITrSLBY1oOer3X8cHiHeUK2QFI+yp48n4R51iPDk81BAOID3FMa
         bd6VLg80HQEvtta2fEn+IQ2RL4YBn0oXgeH0Tel770K0t7YiZIRYrYFur3Mjvsu2aR
         6P4T7FVHIDiJMEgZfc0wFvb6ww5alzije0Ulpzfk=
Date:   Tue, 27 Oct 2020 14:42:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Petr Mladek <pmladek@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] fix parsing of reboot= cmdline
Message-ID: <20201027134224.GA991306@kroah.com>
References: <20201027133545.58625-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027133545.58625-1-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 02:35:43PM +0100, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The parsing of the reboot= cmdline has two major errors:
> - a missing bound check can crash the system on reboot
> - parsing of the cpu number only works if specified last
> 
> Fix both, along with a small code refactor.
> 
> v1->v2:
> As Petr suggested, don't force base 10 in simple_strtoul(),
> so hex values are accepted as well.
> 
> Matteo Croce (2):
>   reboot: fix overflow parsing reboot cpu number
>   reboot: fix parsing of reboot cpu number
> 
>  kernel/reboot.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> -- 
> 2.28.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

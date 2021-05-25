Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511A138FB4A
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhEYG5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 02:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhEYG5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 02:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6665D61417;
        Tue, 25 May 2021 06:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621925732;
        bh=KzcD+yyJhkvHnIKmLFZm/MBQqaSxeCJHv8NOc/JudtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ohnjmdXLA/KsYRM1o+7vsidxmvBMohyR9midcR3+y2YOue8P7rNapRzyqpgzER/l/
         juGhVVxLGBARgWJFrfxFugREzK5W5zN+HpFeSDscsa7RYnzPTi2WKCYRsSFxm3lGBO
         5vszHs89trg7jaDzhNKV7ab2lbfzb2HweASYQIrc=
Date:   Tue, 25 May 2021 08:55:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH 4.19 49/49] x86/Xen: swap NX determination and GDT setup
 on BSP
Message-ID: <YKyfYm4en8RZNZtL@kroah.com>
References: <20210524152324.382084875@linuxfoundation.org>
 <20210524152325.958181984@linuxfoundation.org>
 <bdadfa45-0496-9d47-cca0-b0839b811ae9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdadfa45-0496-9d47-cca0-b0839b811ae9@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 07:11:21AM +0200, Juergen Gross wrote:
> On 24.05.21 17:26, Greg Kroah-Hartman wrote:
> > From: Jan Beulich <jbeulich@suse.com>
> > 
> > commit ae897fda4f507e4b239f0bdfd578b3688ca96fb4 upstream.
> > 
> > xen_setup_gdt(), via xen_load_gdt_boot(), wants to adjust page tables.
> > For this to work when NX is not available, x86_configure_nx() needs to
> > be called first.
> > 
> > [jgross] Note that this is a revert of 36104cb9012a82e73 ("x86/xen:
> > Delay get_cpu_cap until stack canary is established"), which is possible
> > now that we no longer support running as PV guest in 32-bit mode.
> > 
> > Cc: <stable.vger.kernel.org> # 5.9
> 
> Sorry for messing up the stable link, but please don't include this
> patch in stable kernels before 5.9

Now dropped, thanks for reminding me.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB52F7588
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbhAOJdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbhAOJdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 04:33:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D3723436;
        Fri, 15 Jan 2021 09:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610703194;
        bh=jdDSlQzcN256HkCzv1rUypiOfBQkxV+eM9ugfAGfrHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a28NGhTAnl0I3wlJFcLbh0+vZsef7MI0hA/vt1UhbiCx9r5TOB5JxVlwinHj8VRyK
         GLVxLEvujU9XOVK92kgryp1HCcAClK6KIFUz4rGdOucD2vHCYoT4THvDFtOdugiHwv
         bPqyYFwz7PZ1/ZPWYQf1db0WEpGWeLcjg1Y6cC4g=
Date:   Fri, 15 Jan 2021 10:33:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alistair Delva <adelva@google.com>
Subject: Re: 78762b0e79bc for linux-5.4.y
Message-ID: <YAFhV8w2Ynl8oYBz@kroah.com>
References: <CAKwvOd=F_wWLxhnV3J8jx1L3SXPd8NFYyOKzAh7rL0iRb_aNyA@mail.gmail.com>
 <20210113175107.GT4035784@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113175107.GT4035784@sasha-vm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 12:51:07PM -0500, Sasha Levin wrote:
> On Mon, Jan 11, 2021 at 03:41:37PM -0800, Nick Desaulniers wrote:
> > Please consider applying the following patch for LLVM_IAS=1 support
> > for Android's i386 cuttlefish virtual device:
> > commit 78762b0e79bc ("x86/asm/32: Add ENDs to some functions and
> > relabel with SYM_CODE_*")
> > which first landed in v5.5-rc1.
> > 
> > There was a small conflict in arch/x86/xen/xen-asm_32.S due to the
> > order of backports that was trivial to resolve.  You can see the list
> > of commits to it in linux-5.7.y:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/arch/x86/xen/xen-asm_32.S?h=linux-5.7.y
> > as arch/x86/xen/xen-asm_32.S was removed in
> > commit a13f2ef168cb ("x86/xen: remove 32-bit Xen PV guest support") in v5.9-rc1.
> 
> Queued up, thanks!

You stripped out the "commit XXX upstream" line from the patch :(

I've fixed that up now.

thanks,

greg k-h

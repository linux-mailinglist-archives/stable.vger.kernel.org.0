Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB81156C45
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 20:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgBITtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 14:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbgBITtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 14:49:05 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5273B20726;
        Sun,  9 Feb 2020 19:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581277744;
        bh=Cke+Rn/7SaxejkI8kqfTvWx+51yG5ERlhj4QoRsZ9cA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gZ1CeOgM/9wyjEHLxIpam/NoYEk/2nIinipoz84InGFayhFAN6Jvox368nC2KCK2K
         6/gfPx3atekBZok3xSpQCTU557Uv+U/O9FU502QSGy8hODzEOuunrAvCLJlsNuXOoL
         4K1dTSCbs0thb1VpyPeRl3P9wVBXDaJCoGcXMNkk=
Date:   Sun, 9 Feb 2020 14:49:03 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Apply max PA check for MMIO
 sptes to 32-bit KVM" failed to apply to 5.4-stable tree
Message-ID: <20200209194903.GV3584@sasha-vm>
References: <15812512030168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15812512030168@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:26:43PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From e30a7d623dccdb3f880fbcad980b0cb589a1da45 Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Tue, 7 Jan 2020 16:12:10 -0800
>Subject: [PATCH] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
>
>Remove the bogus 64-bit only condition from the check that disables MMIO
>spte optimization when the system supports the max PA, i.e. doesn't have
>any reserved PA bits.  32-bit KVM always uses PAE paging for the shadow
>MMU, and per Intel's SDM:
>
>  PAE paging translates 32-bit linear addresses to 52-bit physical
>  addresses.
>
>The kernel's restrictions on max physical addresses are limits on how
>much memory the kernel can reasonably use, not what physical addresses
>are supported by hardware.
>
>Fixes: ce88decffd17 ("KVM: MMU: mmio page fault support")
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Conflicts when rebasing back are mostly due to file or variable renames.
I've fixed it and queued for 5.4-4.4.

-- 
Thanks,
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D21D3132A7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhBHMo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhBHMoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 07:44:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A0DD64E37;
        Mon,  8 Feb 2021 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612788206;
        bh=6ZZEHquHbOgeFmvzGp7IcPASoLP4fSRHVWRa3YLH6d4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7k3WOezpLz+CwRr1I/UVB8rivSVr3ZTm50UocBHGec7aoxHeKz5D8fFO+IPqui1G
         dZPZSjMMPPpd9hOiSChzcUaGqoeP0AjTAUWQuZsIWin7QOupplpUaMMugD3k/yrPbm
         2dcCvGnDBRRjkwjtd5v5Ya/tG8MSnu3/IC8Cfy48=
Date:   Mon, 8 Feb 2021 13:43:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "jroedel@suse.de" <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
Message-ID: <YCEx614XHUA8oaUr@kroah.com>
References: <1612104088214157@kroah.com>
 <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
 <YB0HrznvibyfVBpu@kroah.com>
 <803F8779-E4A5-43D9-9AAB-A64C763731B7@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803F8779-E4A5-43D9-9AAB-A64C763731B7@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 06:29:27PM +0000, Nadav Amit wrote:
> > On Feb 5, 2021, at 12:54 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > On Thu, Feb 04, 2021 at 06:04:13PM +0000, Nadav Amit wrote:
> >> Backporting requires to disable strict during initialization. Lu, can
> >> you ack this patch?
> >> 
> > This works for 5.10, thanks!  But what about 4.9, 4.14, 4.19, and 5.4?
> > Those also need this change, right?
> 
> Thanks for taking the patch.
> 
> Yes, older kernels need to be patched too. I wanted Lu to ack the 5.10 patch
> first.
> 
> For 5.4 and older kernels, the patch is fundamentally the same as the one
> for 5.10. Yet the patch that I sent for 5.10 does not apply cleanly, so
> please use the following patch.
> 
> Please let me know if there is any problem. 
> 

That worked, thanks.

greg k-h

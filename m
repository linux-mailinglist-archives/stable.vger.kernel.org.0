Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EADEAD2ABB
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387977AbfJJNQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387975AbfJJNQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 09:16:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430472064A;
        Thu, 10 Oct 2019 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570713377;
        bh=xh+EReLGfdsskxTMZ7/BthgoffJ0cZf67pQ4tR0/oGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1yA1g6cjKkfM1aaNhQSHecf9IRXaKF+kPlN34I+m+FvfDsE0UJQXzCgr6I8KS0OG
         WF2Acy6TQ464Rb/uWZEQp5vQYLBh/l/LoQqNp+M+ht8qs6E6l6BydUaHOgzrhe3Smm
         kdwi2sxWQ14heVKKPX3Vh+2ETZwgpw8ywy6apZKo=
Date:   Thu, 10 Oct 2019 15:16:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: cpufeature: Fix truncating a feature value
Message-ID: <20191010131615.GA807662@kroah.com>
References: <20191010110856.4376-1-suzuki.poulose@arm.com>
 <ca77dec7-b29b-5a3b-0c01-047a06d1854d@arm.com>
 <20191010122922.GA720144@kroah.com>
 <295cfb9e-ac7b-73e7-bc80-8b9150f4a626@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <295cfb9e-ac7b-73e7-bc80-8b9150f4a626@arm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 01:46:21PM +0100, Suzuki K Poulose wrote:
> 
> 
> On 10/10/2019 13:29, Greg KH wrote:
> > On Thu, Oct 10, 2019 at 12:12:01PM +0100, Suzuki K Poulose wrote:
> > > All,
> > > 
> > > On 10/10/2019 12:08, Suzuki K Poulose wrote:
> > > > A signed feature value is truncated to turn to an unsigned value
> > > > causing bad state in the system wide infrastructure. This affects
> > > > the discovery of FP/ASIMD support on arm64. Fix this by making sure
> > > > we cast it properly.
> > > > 
> > > > Fixes: 4f0a606bce5ec ("arm64: cpufeature: Track unsigned fields")
> > > > Cc: stable@vger.kernel.org # v4.4
> > > 
> > > Please note that this patch is only applicable for stable 4.4 tree.
> > > I should have removed the Fixes tag.
> > 
> > Why is it only for 4.4?  That needs to be documented really really
> 
> This was fixed later in v4.6 onwards with commit 28c5dcb22f90113dea
> ("arm64: Rename cpuid_feature field extract routines") rather inadvertently.
> 
> > really well in the changelog as to why this is a one-off patch, and why
> > we can't just take the relevant patches that are in Linus's tree
> > instead.
> > 
> > Please fix up and resend.
> 
> I can resend the patch with the above information included if you like.

As I said, please do, I can not take it otherwise.

greg k-h

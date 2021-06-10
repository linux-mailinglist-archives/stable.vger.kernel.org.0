Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DE93A36EF
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFJWTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFJWTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6B8613C8;
        Thu, 10 Jun 2021 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623363420;
        bh=g+xyPPY07mlIFnO3GJ8dZ5myTtFEXIr65bI/NupVBMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7hsK30urdSfnfEDzXfy17tBps+1yK9WtPBu19Z4jPLKAfPU3G/M/ynPqQRX8DTyb
         /5Le9f6D+EQdvkZFz24FJw22fGxtBBOW8uInsTsIAxB9vHCea67VOk2rb+46RhtvFZ
         BAiaG+aRJhRF+vQrit/hRfiLEs42+ka+2zwFghwg=
Date:   Fri, 11 Jun 2021 00:16:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 1/2] perf/cgroups: Don't rotate events for cgroups
 unnecessarily
Message-ID: <YMKPWd8CW/4erduS@kroah.com>
References: <20210607075938.8840-1-wenyang@linux.alibaba.com>
 <27b1368f-400e-6345-245d-a956e18b3752@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27b1368f-400e-6345-245d-a956e18b3752@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 02:28:52PM +0800, Wen Yang wrote:
> 
> Hi,
> 
> except for the following two patches:
> 
> fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")
> 
> 7fa343b7fdc4 ("perf/core: Fix corner case in perf_rotate_context()")
> 
> And this patch is also needed:
> 
> 90c91dfb86d0 ("perf/core: Fix endless multiplex timer")
> 
> 
> Would you please merge them into the 4.19 stable branch?

Last one now queued up, thanks.

greg k-h

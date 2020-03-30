Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E5197700
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 10:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgC3IvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 04:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgC3IvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 04:51:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BD8920732;
        Mon, 30 Mar 2020 08:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585558267;
        bh=FVHzHrXlESDS3qTchboL4ddfFFme9vL57LQPCVxGQow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lP3UVsAdGPsbVMRv+s5LwgdoNdSkBVN04dmJ9xTHDdl6sgXwQeU5gdDC4xZzn0P8R
         1U5Sx28BmPS6wsPElvbJ4yXsHq4bg+ygTw7cWPCPTcAoqqtdrh07O4y4hdQyp8rm1N
         Lp83xmmT4/aJfyh3II5SDrTSbNgrEhJW7rU6ONkE=
Date:   Mon, 30 Mar 2020 10:51:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915: Disable Panel Self Refresh (PSR) by default
Message-ID: <20200330085104.GB239298@kroah.com>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
 <20200330033057.2629052-2-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330033057.2629052-2-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 08:30:56PM -0700, Sultan Alsawaf wrote:
> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> On all Dell laptops with panels and chipsets that support PSR (an
> esoteric power-saving mechanism), both PSR1 and PSR2 cause flickering
> and graphical glitches, sometimes to the point of making the laptop
> unusable. Many laptops don't support PSR so it isn't known if PSR works
> correctly on any consumer hardware as of 5.4. PSR was enabled by default
> in 5.0 for capable hardware, so this patch just restores the previous
> functionality of PSR being disabled by default.
> 
> More info is available on the freedesktop bug:
> https://gitlab.freedesktop.org/drm/intel/issues/425
> 
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
>  drivers/gpu/drm/i915/i915_params.c | 3 +--
>  drivers/gpu/drm/i915/i915_params.h | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h

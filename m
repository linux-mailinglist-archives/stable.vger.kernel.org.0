Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5B39F998
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhFHOw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233587AbhFHOwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 10:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE0861185;
        Tue,  8 Jun 2021 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623163829;
        bh=dnXrgan2+S/qQtoS0qmMhi3CxL/34lxd4pJc5rFYUQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vf15+A/xvtIMGDiEGmOgfCcJJuLyjeq1gG2XCuZRIQoVBzMavl6UBPRLTJGqhb8mb
         sUvzouWVk3uuUBu/+5UNaG5HNgiWdhPiQ1MVvJ5pcgFk6jeHzrDAjWNBzaKhp5n/tS
         TpQxTmB/2hLypaHZTZn1Tx7//xdrbEyFruByfS0s=
Date:   Tue, 8 Jun 2021 16:50:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: Re: [PATCH for-5.10.y+] drm/msm/dpu: always use mdp device to scale
 bandwidth
Message-ID: <YL+DswTMtO1YIqRc@kroah.com>
References: <20210601185137.2558489-1-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601185137.2558489-1-amit.pundir@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 12:21:37AM +0530, Amit Pundir wrote:
> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> 
> [ Upstream commit a670ff578f1fb855fedc7931fa5bbc06b567af22 ]
> 
> Currently DPU driver scales bandwidth and core clock for sc7180 only,
> while the rest of chips get static bandwidth votes. Make all chipsets
> scale bandwidth and clock per composition requirements like sc7180 does.
> Drop old voting path completely.
> 
> Tested on RB3 (SDM845) and RB5 (SM8250).
> 
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Link: https://lore.kernel.org/r/20210401020533.3956787-2-dmitry.baryshkov@linaro.org
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Fixes dpu_runtime_resume() WARN_ON, on db845c/RB3 (sdm845),
> introduced by the backport of upstream commit 627dc55c273d
> ("drm/msm/disp/dpu1: icc path needs to be set before dpu
> runtime resume") on v5.10.y.
> 
> Verified and smoke tested this fix on v5.12.y as well.

Now queued up to both, thanks

greg k-h

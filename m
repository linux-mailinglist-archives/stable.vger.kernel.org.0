Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5723DFDFC
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 11:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhHDJ3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 05:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235427AbhHDJ3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 05:29:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8479A60EB9;
        Wed,  4 Aug 2021 09:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628069359;
        bh=F+pN4N1gCpcgAacPjKXnlhSvfsbduWSEH5hSqYGQZho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUqwhSgOHz5aASIUVzmFjsN4XW6wWo/6hB1iKEtbR1O83smCX+Jtkv/WclRRQFI/O
         0WDCWtQBmV8zTOfhyzuPgqcQdvu7SDFE9As4eXWNKu5HaB8nuuoDsJteva510sQIXR
         RYPw/u1iE225cq1l47QW6rnCrNXarVMbRokKmAJA=
Date:   Wed, 4 Aug 2021 11:29:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kalyan Thota <kalyan_t@codeaurora.org>
Cc:     dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com,
        dianders@chromium.org, mkrishn@codeaurora.org,
        saiprakash.ranjan@codeaurora.org, rnayak@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [Resend v3] drm/msm/disp/dpu1: add safe lut config in dpu driver
Message-ID: <YQpd7P7xYaaf45OS@kroah.com>
References: <1628066313-9717-1-git-send-email-kalyan_t@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628066313-9717-1-git-send-email-kalyan_t@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 01:38:33AM -0700, Kalyan Thota wrote:
> Add safe lut configuration for all the targets in dpu
> driver as per QOS recommendation.
> 
> Issue reported on SC7280:
> 
> With wait-for-safe feature in smmu enabled, RT client
> buffer levels are checked to be safe before smmu invalidation.
> Since display was always set to unsafe it was delaying the
> invalidaiton process thus impacting the performance on NRT clients
> such as eMMC and NVMe.
> 
> Validated this change on SC7280, With this change eMMC performance
> has improved significantly.
> 
> Changes in v2:
> - Add fixes tag (Sai)
> - CC stable kernel (Dimtry)
> 
> Changes in v3:
> - Correct fixes tag with appropriate hash (stephen)
> - Resend patch adding reviewed by tag
> 
> Fixes: 591e34a091d1 ("drm/msm/disp/dpu1: add support for display for SC7280 target")
> Signed-off-by: Kalyan Thota <kalyan_t@codeaurora.org>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org> (sc7280, sc7180)
> ---
>  drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 5 +++++
>  1 file changed, 5 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

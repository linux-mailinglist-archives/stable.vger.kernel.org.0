Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B94F3DFDB3
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 11:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhHDJKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 05:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236979AbhHDJKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 05:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5787E60240;
        Wed,  4 Aug 2021 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628068209;
        bh=9X4hL8TfLuspjEJ70He/hj+tn4fH/H3eNlS2f2ndoxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rXGa+WHPnySCeMTNtLIsO/kdHKYiEZq1T6/faJZEnj+zhHUAyq7pWT+Z3fJxMBEtM
         IHh+amcv6TJagOcUhRdnb2Uz3kx5ZH2lH8zztQF3hk1Xi0VHDkrHV5aa+GXCn++0KC
         /9DlvY0Uw7IBsSwlM8FwcztWIceVscmOQU/BtPJE=
Date:   Wed, 4 Aug 2021 11:10:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kalyan Thota <kalyan_t@codeaurora.org>
Cc:     dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com,
        dianders@chromium.org, mkrishn@codeaurora.org,
        saiprakash.ranjan@codeaurora.org, rnayak@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [v3] drm/msm/disp/dpu1: add safe lut config in dpu driver
Message-ID: <YQpZbosqlBo9EkG6@kroah.com>
References: <1628064990-6990-1-git-send-email-kalyan_t@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628064990-6990-1-git-send-email-kalyan_t@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 01:16:30AM -0700, Kalyan Thota wrote:
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
> Changes in v1:
> - Add fixes tag (Sai)
> - CC stable kernel (Dimtry)
> 
> Changes in v2:
> - Correct fixes tag with appropriate hash (stephen)
> 
> Fixes: 591e34a091d1 (drm/msm/disp/dpu1: add support for display
> for SC7280 target)
> Signed-off-by: Kalyan Thota <kalyan_t@codeaurora.org>
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

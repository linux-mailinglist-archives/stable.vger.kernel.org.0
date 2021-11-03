Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52154447AC
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhKCRue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhKCRuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FFCC60F90;
        Wed,  3 Nov 2021 17:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635961645;
        bh=hp4Nv8aCAbJCYSngn2dFOMMmN/twax+U9sK0oAlLbX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lATBMiqSAKLL301w6HMJlnbRG7Jo/aAGf7g2YvvQBL1/rf18jSTnogj11A+f5NAAR
         bB/RJMZ4t/q2WLLtX44PaEtHm8TPoW9pLYO0gaq69jzfw8J8m1IkPVy4XV/7aJlUNb
         VLjB4DZpVx307t00kvgknTXswz0aTjQMMr0ACR+0=
Date:   Wed, 3 Nov 2021 18:47:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        youling <youling257@gmail.com>, James Zhu <James.Zhu@amd.com>
Subject: Re: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled in
 Picasso.
Message-ID: <YYLLKqAxsgg+dCGU@kroah.com>
References: <20211103145256.1359520-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103145256.1359520-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 10:52:56AM -0400, Alex Deucher wrote:
> From: Yifan Zhang <yifan1.zhang@amd.com>
> 
> When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
> init will fail. But this failure should not block amdgpu driver init.
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214859
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1770
> Reported-by: youling <youling257@gmail.com>
> Tested-by: youling <youling257@gmail.com>
> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
> Reviewed-by: James Zhu <James.Zhu@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit afd18180c07026f94a80ff024acef5f4159084a4)
> Cc: stable@vger.kernel.org # 5.14.x
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
>  2 files changed, 3 insertions(+), 4 deletions(-)

Now queued up, thanks.

greg k-h

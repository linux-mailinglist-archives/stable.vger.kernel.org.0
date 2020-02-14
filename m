Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A40415F906
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgBNVya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgBNVya (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:30 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E892187F;
        Fri, 14 Feb 2020 21:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717269;
        bh=8Ebtq9A+AtuBJOntDicY0rR/lJZViC+UEAZu9rPpKl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bfTkxxCddELi/TRjJNFHtsLoMFRKSS2M5KOPK0vmRFNwlLhU3dVWR5NktoePPI9G7
         mCzQaKFCMTzVTLG4oWgN7FjE3mXEmB8ddwhuQzoT2uWOoeTVopyUfEY6DuWmCkPhKC
         Hl5wVH0o+iSLC12EnoniR4le08s+RvzlN06NvtDs=
Date:   Fri, 14 Feb 2020 16:44:29 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.5 155/542] drm/amdkfd: remove set but not used
 variable 'top_dev'
Message-ID: <20200214214429.GA4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-155-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-155-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:42:27AM -0500, Sasha Levin wrote:
> From: zhengbin <zhengbin13@huawei.com>
> 
> [ Upstream commit d191bd678153307573d615bb42da4fcca19fe477 ]
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/gpu/drm/amd/amdkfd/kfd_iommu.c: In function kfd_iommu_device_init:
> drivers/gpu/drm/amd/amdkfd/kfd_iommu.c:65:30: warning: variable top_dev set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 1ae99eab34f9 ("drm/amdkfd: Initialize HSA_CAP_ATS_PRESENT capability in topology codes")
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_iommu.c | 3 ---
>  1 file changed, 3 deletions(-)

Unless all of these "unused bt set variable" patches are needed for
"real" fixes, there's no need to add them here as we are NOT building
the kernel with that option enabled any time soon from what I can tell.

So you can drop a ton of these patches from all of these AUTOSEL
branches please.

thanks,

greg kh

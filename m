Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6C46B515
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhLGII3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:08:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60122 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhLGII3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:08:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1267B80E8C
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 08:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67123C341C1;
        Tue,  7 Dec 2021 08:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638864297;
        bh=JPMYeYoJI2kpJyjQiFHWDSWT565vgovckBGEvvKfIUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfQBJflfMY/Gi+VvPlIY+iKYsU2fq7H7neG5l7yDd5tqOWIK5G8TvBRw1beoE4s7Q
         RouEnx8jw2IaS7RTYgNH6N3yorRUC6Ojc1RsVxmL7jk10I4pNyNfavkivcQgT0AAD1
         rru00j5m5OxocdOshzT4yfPG1F0kiGliP2+BebIE=
Date:   Tue, 7 Dec 2021 09:04:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Zhu <James.Zhu@amd.com>
Cc:     stable@vger.kernel.org, jzhums@gmail.com,
        alexander.deucher@amd.com, kolAflash@kolahilft.de
Subject: Re: [PATCH 0/5] Bug:211277 fix backport for 5.10, 5.12 stable
Message-ID: <Ya8Vpxedi5PEA7F1@kroah.com>
References: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 03, 2021 at 12:27:27PM -0500, James Zhu wrote:
> These patches are back port for 5.10 and 5.12 stable.
> They are cherry-picked from 5.14 stable and has some conflict fix.
> 
> BugFix: https://bugzilla.kernel.org/show_bug.cgi?id=211277
> 
> James Zhu (3):
>   drm/amdkfd: separate kfd_iommu_resume from kfd_resume
>   drm/amdgpu: add amdgpu_amdkfd_resume_iommu
>   drm/amdgpu: move iommu_resume before ip init/resume
> 
> Yifan Zhang (2):
>   drm/amdgpu: init iommu after amdkfd device init
>   drm/amdkfd: fix boot failure when iommu is disabled in Picasso.
> 
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 10 ++++++++++
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  2 ++
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  8 ++++++++
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 15 +++++++++++----
>  4 files changed, 31 insertions(+), 4 deletions(-)
> 
> -- 
> 2.7.4
> 

This patch series is causing build errors as reported in numerous
places:
	https://lore.kernel.org/r/4a881261-ba90-2095-58df-13dcffe6bcf2@roeck-us.net
	https://lore.kernel.org/r/bd0bddb3-8fa7-dc8e-d205-5c266e98d8b9@huawei.com
	https://lore.kernel.org/r/CA+G9fYtYmZY-m1ZCaF3qJeGtn=8CJR_4K8EB_T4W+wuh31CNjg@mail.gmail.com
so I am going to drop them all from the tree now.

Please fix up and resend if you want them in the 5.10.y kernel tree.

thanks,

greg k-h

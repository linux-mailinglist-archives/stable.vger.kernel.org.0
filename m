Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A161C9637
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 18:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgEGQSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 12:18:02 -0400
Received: from mail.netline.ch ([148.251.143.178]:33051 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgEGQSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 12:18:02 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2020 12:18:00 EDT
Received: from localhost (localhost [127.0.0.1])
        by netline-mail3.netline.ch (Postfix) with ESMTP id B4E2B2A6176;
        Thu,  7 May 2020 18:11:18 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at netline-mail3.netline.ch
Received: from netline-mail3.netline.ch ([127.0.0.1])
        by localhost (netline-mail3.netline.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id ahgL4LOqw5AX; Thu,  7 May 2020 18:11:18 +0200 (CEST)
Received: from thor (252.80.76.83.dynamic.wline.res.cust.swisscom.ch [83.76.80.252])
        by netline-mail3.netline.ch (Postfix) with ESMTPSA id 380502A60F7;
        Thu,  7 May 2020 18:11:18 +0200 (CEST)
Received: from localhost ([::1])
        by thor with esmtp (Exim 4.93)
        (envelope-from <michel@daenzer.net>)
        id 1jWj7F-001f40-F2; Thu, 07 May 2020 18:11:17 +0200
Subject: Re: [PATCH AUTOSEL 5.6 33/50] drm/amdgpu: bump version for invalidate
 L2 before SDMA IBs
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
        =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <marek.olsak@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20200507142726.25751-1-sashal@kernel.org>
 <20200507142726.25751-33-sashal@kernel.org>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <349b2cb9-71f9-a0cd-aceb-308512d7501a@daenzer.net>
Date:   Thu, 7 May 2020 18:11:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507142726.25751-33-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-07 4:27 p.m., Sasha Levin wrote:
> From: Marek Olšák <marek.olsak@amd.com>
> 
> [ Upstream commit 9017a4897a20658f010bebea825262963c10afa6 ]
> 
> This fixes GPU hangs due to cache coherency issues.
> Bump the driver version. Split out from the original patch.
> 
> Signed-off-by: Marek Olšák <marek.olsak@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Tested-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> index 42f4febe24c6d..8d45a2b662aeb 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -85,9 +85,10 @@
>   * - 3.34.0 - Non-DC can flip correctly between buffers with different pitches
>   * - 3.35.0 - Add drm_amdgpu_info_device::tcc_disabled_mask
>   * - 3.36.0 - Allow reading more status registers on si/cik
> + * - 3.37.0 - L2 is invalidated before SDMA IBs, needed for correctness
>   */
>  #define KMS_DRIVER_MAJOR	3
> -#define KMS_DRIVER_MINOR	36
> +#define KMS_DRIVER_MINOR	37
>  #define KMS_DRIVER_PATCHLEVEL	0
>  
>  int amdgpu_vram_limit = 0;
> 

This requires the parent commit fdf83646c0542ecfb9adc4db8f741a1f43dca058
"drm/amdgpu: invalidate L2 before SDMA IBs (v2)". KMS_DRIVER_MINOR is
bumped to signal to userspace the fix in that commit is present.


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer

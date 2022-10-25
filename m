Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABAB60C723
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiJYJCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJYJCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:02:39 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA0A15788F;
        Tue, 25 Oct 2022 02:02:38 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o4so11467436wrq.6;
        Tue, 25 Oct 2022 02:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHwoErdE0BzPcZlSSCfCdE2navlz+j0aFnjeKGm+sZ4=;
        b=oRgrckP3SjOfzoc2HUybm2IgGKg8NwVh1HXRRYnEyd9Z08DwN2ik7rJrBnLZ8pOkPS
         eyS3v46w+3Tgaserk6QVnbha5Aj+Z3Lr5h4wN5IT09Z5exmwCdg6YIBynxNACrRBZCyP
         Yw0Q87uMOyKq746orAfD3NdctHDLcAhZRNpCe+Zeh5PYBPG37LzPOo7eFmKE2uPoDiyd
         8sh3LLrdMT8uAIcD2OP4Q24hNhcLI3uRNsdpa5An+v9lMG6uZwFUunu0+qDTY+0nM8/h
         cZ+0iKCcL8EIuFT/N0DqKw+Wwk8GCtpvXH7neR/cp6fKOL0h1vtXiWg21uoL4y1YOoVn
         NX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHwoErdE0BzPcZlSSCfCdE2navlz+j0aFnjeKGm+sZ4=;
        b=cFXjXBVOOmEMv60L0nUZTBlqAMJxgURohq/qB7rL6iW/s3NKX5nAfBuJvzWV0LmKdG
         Rhcr7XwnNrkQ5zQb5igWNXAnZwrNs8KxDeH+twaA0qpRYzmfWPVSUp46al39zKVEUgaA
         HBcNtne7TlS0tFMNPvyef5UBITy5CBlwYY2lUa2AUFgrpGkPf9svTJx44BIFWcaJRfe1
         qMl4nBJi+reWvdqQvYgHdu85Li0IC92AVfA6VvYgV6i/PddlRAx3ELbxhjViwwYRNr5r
         nNFHJwX/k3cyUSspFae4m3QTvH5O/XK9eR7sTuFwj8r4HVcYignQ4Y4PdBhjSXErkT7a
         dKqg==
X-Gm-Message-State: ACrzQf2I3VttmPnJXUNI2zKiAGskZxo64JOx0hgrGrqHj2Xo+/WOQge4
        d++NNIvgxRdG5NBmprSpbSU=
X-Google-Smtp-Source: AMsMyM5rGCodm1RVK98EgVYDjzfoJiAJrrXHjY+aIwEvOUVlFPiSuPxs1YlUcmWqevdzE7tTPBQsvw==
X-Received: by 2002:a05:6000:1f04:b0:22e:5e0b:e1fb with SMTP id bv4-20020a0560001f0400b0022e5e0be1fbmr23517847wrb.222.1666688556556;
        Tue, 25 Oct 2022 02:02:36 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id u14-20020a5d514e000000b00228cbac7a25sm1899182wrt.64.2022.10.25.02.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 02:02:34 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 5479DBE2DE0; Tue, 25 Oct 2022 11:02:33 +0200 (CEST)
Date:   Tue, 25 Oct 2022 11:02:33 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH 5.10 384/390] Revert "drm/amdgpu: move nbio
 sdma_doorbell_range() into sdma code for vega"
Message-ID: <Y1emKRzhii9qK+cN@eldamar.lan>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113039.334437223@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113039.334437223@linuxfoundation.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 24, 2022 at 01:33:01PM +0200, Greg Kroah-Hartman wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> 
> This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341 which is
> commit e3163bc8ffdfdb405e10530b140135b2ee487f89 upstream.
> 
> This commit causes repeated WARN_ONs from
> 
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amd
> gpu_dm.c:7391 amdgpu_dm_atomic_commit_tail+0x23b9/0x2430 [amdgpu]
> 
> dmesg fills up with the following messages and drm initialization takes
> a very long time.
> 
> Cc: <stable@vger.kernel.org>    # 5.10
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    5 -----
>  drivers/gpu/drm/amd/amdgpu/soc15.c     |   25 +++++++++++++++++++++++++
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> --- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> @@ -1475,11 +1475,6 @@ static int sdma_v4_0_start(struct amdgpu
>  		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
>  
>  		if (!amdgpu_sriov_vf(adev)) {
> -			ring = &adev->sdma.instance[i].ring;
> -			adev->nbio.funcs->sdma_doorbell_range(adev, i,
> -				ring->use_doorbell, ring->doorbell_index,
> -				adev->doorbell_index.sdma_doorbell_range);
> -
>  			/* unhalt engine */
>  			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
>  			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> @@ -1332,6 +1332,25 @@ static int soc15_common_sw_fini(void *ha
>  	return 0;
>  }
>  
> +static void soc15_doorbell_range_init(struct amdgpu_device *adev)
> +{
> +	int i;
> +	struct amdgpu_ring *ring;
> +
> +	/* sdma/ih doorbell range are programed by hypervisor */
> +	if (!amdgpu_sriov_vf(adev)) {
> +		for (i = 0; i < adev->sdma.num_instances; i++) {
> +			ring = &adev->sdma.instance[i].ring;
> +			adev->nbio.funcs->sdma_doorbell_range(adev, i,
> +				ring->use_doorbell, ring->doorbell_index,
> +				adev->doorbell_index.sdma_doorbell_range);
> +		}
> +
> +		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
> +						adev->irq.ih.doorbell_index);
> +	}
> +}
> +
>  static int soc15_common_hw_init(void *handle)
>  {
>  	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
> @@ -1351,6 +1370,12 @@ static int soc15_common_hw_init(void *ha
>  
>  	/* enable the doorbell aperture */
>  	soc15_enable_doorbell_aperture(adev, true);
> +	/* HW doorbell routing policy: doorbell writing not
> +	 * in SDMA/IH/MM/ACV range will be routed to CP. So
> +	 * we need to init SDMA/IH/MM/ACV doorbell range prior
> +	 * to CP ip block init and ring test.
> +	 */
> +	soc15_doorbell_range_init(adev);
>  
>  	return 0;
>  }

Can you please as well revert 7b0db849ea030a70b8fb9c9afec67c81f955482e
on top?

See https://lore.kernel.org/stable/BL1PR12MB5144F3CC640A18DF0C36E414F72E9@BL1PR12MB5144.namprd12.prod.outlook.com/

Both of these reverts need to be applied to fix regressions which were
reported in https://gitlab.freedesktop.org/drm/amd/-/issues/2216 and
downstream in Debian (https://bugs.debian.org/1022025).

If it is now not anymore possible for 5.10.150 can you pick the revert
for 5.10.151?

Regards,
Salvatore

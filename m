Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55F26909BE
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBINUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 08:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBINUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 08:20:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973BA2D7B
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 05:20:02 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id n13so1397272wmr.4
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 05:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H9EkPoW6N8QFwKUo2RmpcLzlk05kBq+9kkcDaFAwwCo=;
        b=Phnee0/OgMasNvGCEvW+j96zRClFoI3nkRVt+Vi8pZKfCmFBhBCtvE/Hu5Aifv0PUv
         i6WmgAhowYXO+5FRPwb6yDASCj+3fWHx3RyRIF7omvGwhr9jYCIDM7ZhQD+QadzCVR7i
         mQQHvDsj2qDawtYqbD7M0JpNC5mLwR0bKNTa4XLpSYAkZDAyb84ALN7P0v2lEQKRJiYh
         YA2Ua8bqfTNnxIhJjvOKdvmiB5QiXP6PcrUwAluYYPFcTSwoMTbCt8sFBGxxZVZuAZHW
         sFN9lEYwzyg00ej/HaCFqz/ZNN3BjiM4oxPRgZaMQLj/BGphn6VV/jEjMZyFIcEZjXBI
         XZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H9EkPoW6N8QFwKUo2RmpcLzlk05kBq+9kkcDaFAwwCo=;
        b=RwtAlYafvbg0zRUgvZTTbbu9lr4w8cOhRC4vcwslxRnB4wezee4DWtHO/XRIvTOONV
         dec5+oX9F7Qnk1Dl4rwJDKaWN5BPM3i40oB/RAJkHWsQDwdgjRdCvUEI8DmVIsGqctth
         XMwT6ZRAZE8xr/RIKijAJo5Jvnfuymu8EBUs46v4n4IrebPXXW0HOweBxS2D2TNIEYgk
         p+w3MDX202cqmm7fI9TCVdO0Ul0+ASYDpgqW6LxI+oECpEypyQTdLcndN+2gAFsbvVvU
         Vz0Ltigb5pzflVvSKUP50kyCd7ZqsVa9N+qGqotSi14/Ignfy2+eIbyTaTeQl5ooJ+zY
         80kw==
X-Gm-Message-State: AO0yUKXf20rANTAqm/L/EtRg/LvONZtJnCCHjJ06lcqxuiBiAAaR2dv7
        Dgv+Oj3tmL3F+af/Q6Bd9YCptG9EsAI=
X-Google-Smtp-Source: AK7set/6LHyGg/tZruXhN1SVEMxcysg/K7/RRT3FEb23bs5wE79LoB4MuTEB4bVP0HlwwIFnuQhndg==
X-Received: by 2002:a05:600c:3093:b0:3df:fbd5:690 with SMTP id g19-20020a05600c309300b003dffbd50690mr9937838wmn.17.1675948801238;
        Thu, 09 Feb 2023 05:20:01 -0800 (PST)
Received: from [192.168.2.181] (46-10-148-90.ip.btc-net.bg. [46.10.148.90])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c4eca00b003dec22de1b1sm2174950wmq.10.2023.02.09.05.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 05:20:00 -0800 (PST)
Message-ID: <c706d756-d2ee-ff74-d7c8-9ede6669e4e8@gmail.com>
Date:   Thu, 9 Feb 2023 15:19:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2] drm/vmwgfx: Do not drop the reference to the handle
 too soon
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org, banackm@vmware.com,
        mombasawalam@vmware.com
References: <20230209123731.2137787-1-zack@kde.org>
From:   "Martin Krastev (VMware)" <martinkrastev768@gmail.com>
In-Reply-To: <20230209123731.2137787-1-zack@kde.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Krastev <krastevm@vmware.com>


LGTM
Reviewed-by: Martin Krastev <krastevm@vmware.com>


Regards,
Martin

On 9.02.23 г. 14:37 ч., Zack Rusin wrote:
> From: Zack Rusin <zackr@vmware.com>
>
> v2: Update the commit message to include note describing why the second
> usag of vmw_gem_object_create_with_handle in vmwgfx_surface.c wasn't
> changed
>
> It is possible for userspace to predict the next buffer handle and
> to destroy the buffer while it's still used by the kernel. Delay
> dropping the internal reference on the buffers until kernel is done
> with them.
>
> Also fixes the second usage of vmw_gem_object_create_with_handle in
> vmwgfx_surface.c which wasn't grabbing an explicit reference
> to the gem object which could have been destroyed by the userspace
> on the owning surface at any point.
>
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
> Cc: <stable@vger.kernel.org> # v5.17+
> ---
>   drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      | 3 ++-
>   drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     | 4 ++--
>   drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 1 -
>   3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> index 43ffa5c7acbd..65bd88c8fef9 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> @@ -708,7 +708,8 @@ int vmw_dumb_create(struct drm_file *file_priv,
>   	ret = vmw_gem_object_create_with_handle(dev_priv, file_priv,
>   						args->size, &args->handle,
>   						&vbo);
> -
> +	/* drop reference from allocate - handle holds it now */
> +	drm_gem_object_put(&vbo->tbo.base);
>   	return ret;
>   }
>   
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> index 51bd1f8c5cc4..d6baf73a6458 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> @@ -133,8 +133,6 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
>   	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
>   
>   	ret = drm_gem_handle_create(filp, &(*p_vbo)->tbo.base, handle);
> -	/* drop reference from allocate - handle holds it now */
> -	drm_gem_object_put(&(*p_vbo)->tbo.base);
>   out_no_bo:
>   	return ret;
>   }
> @@ -161,6 +159,8 @@ int vmw_gem_object_create_ioctl(struct drm_device *dev, void *data,
>   	rep->map_handle = drm_vma_node_offset_addr(&vbo->tbo.base.vma_node);
>   	rep->cur_gmr_id = handle;
>   	rep->cur_gmr_offset = 0;
> +	/* drop reference from allocate - handle holds it now */
> +	drm_gem_object_put(&vbo->tbo.base);
>   out_no_bo:
>   	return ret;
>   }
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
> index 9d4ae9623a00..d18fec953fa7 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
> @@ -867,7 +867,6 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
>   			goto out_unlock;
>   		}
>   		vmw_bo_reference(res->guest_memory_bo);
> -		drm_gem_object_get(&res->guest_memory_bo->tbo.base);
>   	}
>   
>   	tmp = vmw_resource_reference(&srf->res);

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260596905A2
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBIKtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBIKsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:48:36 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940696F233
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 02:46:21 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h16so1285460wrz.12
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 02:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6vCcZKIbCf5nxQIZegRS63EM/jfTgwbwqB48H2p5lw=;
        b=YolBCpVOKw3RdkmGIvS6TkDoXc8A/up9kzXS8OsOY7+lnFCdcg6qqJ9bmeqJJC2Utb
         E9BC8n10c2A24yQwW4zF5sAiWicMsq517hOZd5l9jTvX++vvn3Pq9XbqIyHCUIBaM2kr
         aBEdc6HVNeO7PEfcTamkXkFXgWDhPU+YSOMaDTa+p8akz8NOTUzlBvzerKlBiBhteo/6
         5azWtwuQAPWm9wuGPltuSxZo58EfkriUv88RlAHVp+wWqzbZ7jKZzPdYhcZ/a9a2ZKFO
         j3pxpw5L+9uHj/D6+LjrimPo7pOmC1xG77zu1CXdHCeOu6MJWKvOsuQkmitjLn67Adif
         srjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6vCcZKIbCf5nxQIZegRS63EM/jfTgwbwqB48H2p5lw=;
        b=iXm1ibzPEgxGChGwO5QtgcWnLiugfdANu7OJvYskRnFToKdwZcZfB3Nd8dJZnyLbPm
         fey6AGhsKGmq+3/BAc8fY0MHFzFO1IoyLkzHIRWQ2kegJk4u3XAAFDmmOqEzxt0rE72Z
         KR5ibGzQ2D2oVRtB1JdReTl0avqahx54IM5o6mh+NqoB/udSHriHz3DrsdQ7hVP1q2Lv
         03AeYn+tK/p2wD7s63wWOL6b6vCj1UGpHANnQ/+17TLdPGsEKJ3/pvEsCDbVkrff+ej9
         LQG3WsnQFtGKAlHL0ahogjp9AiHEWDMaOrYgiKyYN8aQ23SzSkpAosEwL72JeLXWd3fn
         jPRA==
X-Gm-Message-State: AO0yUKXLpYT5bft4152N45llNrbNlArxT5TIsZcqwB5QvQTyFETdd2RU
        UsG41JGYf97mg4mgh5Wi5C4=
X-Google-Smtp-Source: AK7set+FDFE2u+uSIzy24xdfCR37FA+0vVDHaHkS3X1n8UQ16LJHO02mzL9dXutxjSF3MsEsSAsXRA==
X-Received: by 2002:adf:e5cb:0:b0:2c4:626:acd4 with SMTP id a11-20020adfe5cb000000b002c40626acd4mr4111367wrn.13.1675939580091;
        Thu, 09 Feb 2023 02:46:20 -0800 (PST)
Received: from [192.168.2.181] (46-10-148-90.ip.btc-net.bg. [46.10.148.90])
        by smtp.gmail.com with ESMTPSA id n10-20020adffe0a000000b002c3ec35f360sm904126wrr.56.2023.02.09.02.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 02:46:19 -0800 (PST)
Message-ID: <b0a2486b-3dbb-a7f3-4079-7ff3b8208c09@gmail.com>
Date:   Thu, 9 Feb 2023 12:46:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] drm/vmwgfx: Do not drop the reference to the handle too
 soon
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org, banackm@vmware.com,
        mombasawalam@vmware.com
References: <20230208215340.2103955-1-zack@kde.org>
Content-Language: en-US
From:   "Martin Krastev (VMware)" <martinkrastev768@gmail.com>
In-Reply-To: <20230208215340.2103955-1-zack@kde.org>
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


Looks good to me.
Reviewed-by: Martin Krastev <krastevm@vmware.com>


Regards,
Martin


On 8.02.23 г. 23:53 ч., Zack Rusin wrote:
> From: Zack Rusin <zackr@vmware.com>
>
> It is possible for userspace to predict the next buffer handle and
> to destroy the buffer while it's still used by the kernel. Delay
> dropping the internal reference on the buffers until kernel is done
> with them.
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

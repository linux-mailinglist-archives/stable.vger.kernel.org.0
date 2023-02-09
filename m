Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74096909C3
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 14:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBINWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 08:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBINWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 08:22:52 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566E15357B
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 05:22:51 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg26so1455074wmb.0
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 05:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ya/Lza+YtJyLFI6B2w2Hs3lwrR09cwKynSHqyFXIapw=;
        b=GDNt7RvafCrOAaamrLBzZGXXrAeE0L/MYmPsFvUJxgyKVbHOuDuc+4URTcd1lhphuX
         m2Z2dvuY0dX6f5Tcctx0cSNMRKWGKO/emQXk1thTT1u43UndWKldRFC/EdT3jKKtAp2T
         b3VqxqewxNs2j2YU/vMCoON5eGRtCBU5wSsuOlibR1KkfH6bhDslU4A57bBcWvPGfL5P
         sNwYt0To2ZbOJupaTnFyQ71LfU9tOB/lmS1UpBRRqY22ySS+KPOPQylUclDRXoEe6oG+
         SUadUy77euhw44RsoLPUDTIN2MJFYzqfmvKBN92dCAgKXHrh1SLtIEzn8iNBChKnmQij
         FjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya/Lza+YtJyLFI6B2w2Hs3lwrR09cwKynSHqyFXIapw=;
        b=xru4nofBoY4vc9W48qyrPpE8Mvk/MrypT02bUQHmtAr3lZRXmQ2kxMC66MztdORWO0
         rmaR6+pxptE86u99tUJPxLcJIjP49DfRo1BRznywsBwf7nVPBaIu0QjDXN9ktee11mQ/
         /56BMzFgv5hph6m6tnKXN+0MaTp3KpAlAElUXfU+2sZsk1ett8FLS10KGiIrRcN4RMgb
         wiw12fND79hU32lWEqzDqEZBS7LEhuQpt782ier/xZDLf4GHxghnX4kpOglPCzYt4asv
         YsUVKfloLPl9ikoDwY0TTnS2qGo3q+XBnJ6FrDJumhGSTWOBCyDxBkLl064soT5fV7vl
         7SHQ==
X-Gm-Message-State: AO0yUKUZn48ZlVF24/uR8d1Sf0mhGrVo3Y9o+4I9JFFg0ByeQHJ0+uAA
        q2VN2T/dFogie5yr19XRPFc=
X-Google-Smtp-Source: AK7set+eC4yVnyuJBhgBQcG/quYSi/tXd7UNmU2fkDHNOF8wuDIO8brMQLLgYX4LEYZ60AlGm0ivtg==
X-Received: by 2002:a05:600c:810:b0:3df:f7e7:5f01 with SMTP id k16-20020a05600c081000b003dff7e75f01mr9723026wmp.15.1675948969894;
        Thu, 09 Feb 2023 05:22:49 -0800 (PST)
Received: from [192.168.2.181] (46-10-148-90.ip.btc-net.bg. [46.10.148.90])
        by smtp.gmail.com with ESMTPSA id s21-20020a1cf215000000b003e001119927sm4815757wmc.24.2023.02.09.05.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 05:22:49 -0800 (PST)
Message-ID: <c6720432-102a-4d9d-f835-e919d35931c5@gmail.com>
Date:   Thu, 9 Feb 2023 15:22:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] drm/vmwgfx: Stop accessing buffer objects which failed
 init
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org, banackm@vmware.com,
        mombasawalam@vmware.com
References: <20230208180050.2093426-1-zack@kde.org>
From:   "Martin Krastev (VMware)" <martinkrastev768@gmail.com>
In-Reply-To: <20230208180050.2093426-1-zack@kde.org>
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

Much nicer now.
Reviewed-by: Martin Krastev <krastevm@vmware.com>


Regards,
Martin

On 8.02.23 г. 20:00 ч., Zack Rusin wrote:
> From: Zack Rusin <zackr@vmware.com>
>
> ttm_bo_init_reserved on failure puts the buffer object back which
> causes it to be deleted, but kfree was still being called on the same
> buffer in vmw_bo_create leading to a double free.
>
> After the double free the vmw_gem_object_create_with_handle was
> setting the gem function objects before checking the return status
> of vmw_bo_create leading to null pointer access.
>
> Fix the entire path by relaying on ttm_bo_init_reserved to delete the
> buffer objects on failure and making sure the return status is checked
> before setting the gem function objects on the buffer object.
>
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
> Cc: <stable@vger.kernel.org> # v5.17+
> ---
>   drivers/gpu/drm/vmwgfx/vmwgfx_bo.c  | 4 +++-
>   drivers/gpu/drm/vmwgfx/vmwgfx_gem.c | 4 ++--
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> index 63486802c8fd..43ffa5c7acbd 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> @@ -431,13 +431,15 @@ int vmw_bo_create(struct vmw_private *vmw,
>   		return -ENOMEM;
>   	}
>   
> +	/*
> +	 * vmw_bo_init will delete the *p_bo object if it fails
> +	 */
>   	ret = vmw_bo_init(vmw, *p_bo, params, vmw_bo_free);
>   	if (unlikely(ret != 0))
>   		goto out_error;
>   
>   	return ret;
>   out_error:
> -	kfree(*p_bo);
>   	*p_bo = NULL;
>   	return ret;
>   }
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> index f042e22b8b59..51bd1f8c5cc4 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> @@ -127,11 +127,11 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
>   	};
>   
>   	ret = vmw_bo_create(dev_priv, &params, p_vbo);
> -
> -	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
>   	if (ret != 0)
>   		goto out_no_bo;
>   
> +	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
> +
>   	ret = drm_gem_handle_create(filp, &(*p_vbo)->tbo.base, handle);
>   	/* drop reference from allocate - handle holds it now */
>   	drm_gem_object_put(&(*p_vbo)->tbo.base);

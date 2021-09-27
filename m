Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4857A4190FC
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 10:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhI0IlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 04:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbhI0IlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 04:41:01 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B124C061575;
        Mon, 27 Sep 2021 01:39:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v10so61525142edj.10;
        Mon, 27 Sep 2021 01:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n1CHzUBWfd1oowAfBnotzDhtPKlYdHbp+csmEaNyepw=;
        b=bGUx3YrVdydSCuFxwh0azwQa/bf6Uj/HelZuQaWianGiq6oskyEd1zgv5qwGIGJy0x
         fsSN/tv2QHWTEktZFekg8Q/d4DDmqmUUANFiC0qyqainXhWELmZQ6oDGaH2UV190I0Mx
         XSCADlS+v67Mk8DYjXrEkPrNkZ4j6DBQb53flABr1suKE8yZLPRi60ZuomXe0kyKrN3h
         VlM6VaKHW75SyaV5Kbfp1zbYP0vDqC3vINK4u7iiliGkRfuRuUeCobu10vmwbW87NY+j
         hLF0gqIyY3q+F7JF63d6ILrK802LpFha5JWE4WjyZbFVbbeebmZ/KtasfNiu+AhXEnm+
         1rsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n1CHzUBWfd1oowAfBnotzDhtPKlYdHbp+csmEaNyepw=;
        b=R/4RHVS+EhT0IsYdzQzHFiQDBjEVE5VM+VIJwC6aNWmS9e2uYoHLjqc8WIwptDcsdB
         sW1xLjh+bPdKIOlkUmRk/C/7kLwBtM/hXMCShUPpN7KZHHFR6R3KsYMlwnOoup0D2sMh
         swrioX2izKtzdYxd3fImnFhRlQZxUhtj8SMraq2ZsvASnqChWtB14lY9m9onw9WcYr6N
         QroFoqChFSWXuEKOQlQv1zXJmn+ztxGeHF4yUhNIMCHkrHT3tz82ZMGFDppfEzfMXA9R
         1OrZkdo0vP5TRIzKqrqwLICz1QA+rPEoxyDBj2xNAsSAVk04JsKOc6C/2P2xMGfXGKAw
         QMUA==
X-Gm-Message-State: AOAM532vNOOIaZHbzK5AiAa9fB7UsEsQpERqksD/pYtvk/jhsbCG0gNx
        X9OlvIQNn1JMJH3s5bwaeRyNuZjK2LI=
X-Google-Smtp-Source: ABdhPJyfRPUa1kpgxGk7vL5411uh4xOOL+ZXkRP9xOhkk9ZG9et3ZE6/xSRgTXDnkPifeqyuXBDxIg==
X-Received: by 2002:a17:906:165a:: with SMTP id n26mr25039652ejd.236.1632731962150;
        Mon, 27 Sep 2021 01:39:22 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id s15sm10186810edr.6.2021.09.27.01.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 01:39:21 -0700 (PDT)
Subject: Re: [PATCH 5.10 10/63] [PATCH] Revert "net/mlx5: Register to devlink
 ingress VLAN filter trap"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Patrick.Mclean@sony.com,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
References: <20210924124334.228235870@linuxfoundation.org>
 <20210924124334.598145185@linuxfoundation.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <3279469d-f980-386f-9110-c44144711608@gmail.com>
Date:   Mon, 27 Sep 2021 11:39:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210924124334.598145185@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/24/2021 3:44 PM, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This reverts commit fe6322774ca28669868a7e231e173e09f7422118 which was
> commit 82e6c96f04e13c72d91777455836ffd012853caa upstream.
> 
> It has been reported to cause regressions so should be dropped.
> 
> Reported-by: <Patrick.Mclean@sony.com>
> Link: https://lore.kernel.org/r/BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com
> Cc: Aya Levin <ayal@nvidia.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Hi Greg,

This issue is solved within the same upstream series, by upstream patch:
[1] 241dc159391f net/mlx5: Notify on trap action by blocking event

We didn't spot the issue back then, the two patches should've been 
submitted in a reversed order in the original series to avoid this 
temporary degradation.

This patch "net/mlx5: Register to devlink ingress VLAN filter trap" is 
not a bug fix, not really needed in 5.10 stable.
I believe you cherry-picked it into 5.10 to handle some code context 
problem?

In summary, if the revert works for you w/o further degradation then we 
are fine with it. The alternative is to import the whole original 
series, especially the patch mentioned above [1].

Thanks,
Tariq

>   drivers/net/ethernet/mellanox/mlx5/core/devlink.c |   51 ----------------------
>   1 file changed, 51 deletions(-)
> 
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -376,48 +376,6 @@ static void mlx5_devlink_set_params_init
>   #endif
>   }
>   
> -#define MLX5_TRAP_DROP(_id, _group_id)					\
> -	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
> -			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
> -			     DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT)
> -
> -static const struct devlink_trap mlx5_traps_arr[] = {
> -	MLX5_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
> -};
> -
> -static const struct devlink_trap_group mlx5_trap_groups_arr[] = {
> -	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
> -};
> -
> -static int mlx5_devlink_traps_register(struct devlink *devlink)
> -{
> -	struct mlx5_core_dev *core_dev = devlink_priv(devlink);
> -	int err;
> -
> -	err = devlink_trap_groups_register(devlink, mlx5_trap_groups_arr,
> -					   ARRAY_SIZE(mlx5_trap_groups_arr));
> -	if (err)
> -		return err;
> -
> -	err = devlink_traps_register(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr),
> -				     &core_dev->priv);
> -	if (err)
> -		goto err_trap_group;
> -	return 0;
> -
> -err_trap_group:
> -	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
> -				       ARRAY_SIZE(mlx5_trap_groups_arr));
> -	return err;
> -}
> -
> -static void mlx5_devlink_traps_unregister(struct devlink *devlink)
> -{
> -	devlink_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr));
> -	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
> -				       ARRAY_SIZE(mlx5_trap_groups_arr));
> -}
> -
>   int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
>   {
>   	int err;
> @@ -432,16 +390,8 @@ int mlx5_devlink_register(struct devlink
>   		goto params_reg_err;
>   	mlx5_devlink_set_params_init_values(devlink);
>   	devlink_params_publish(devlink);
> -
> -	err = mlx5_devlink_traps_register(devlink);
> -	if (err)
> -		goto traps_reg_err;
> -
>   	return 0;
>   
> -traps_reg_err:
> -	devlink_params_unregister(devlink, mlx5_devlink_params,
> -				  ARRAY_SIZE(mlx5_devlink_params));
>   params_reg_err:
>   	devlink_unregister(devlink);
>   	return err;
> @@ -449,7 +399,6 @@ params_reg_err:
>   
>   void mlx5_devlink_unregister(struct devlink *devlink)
>   {
> -	mlx5_devlink_traps_unregister(devlink);
>   	devlink_params_unpublish(devlink);
>   	devlink_params_unregister(devlink, mlx5_devlink_params,
>   				  ARRAY_SIZE(mlx5_devlink_params));
> 
> 

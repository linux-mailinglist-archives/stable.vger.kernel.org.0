Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33F2E7325
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgL2TC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgL2TC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 14:02:27 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1727DC0613D6;
        Tue, 29 Dec 2020 11:01:47 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id 7so9573235qtp.1;
        Tue, 29 Dec 2020 11:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrEhMwpNQAl7xOzRkKY3szVtyXF/rjqGEHYOMOmVWY4=;
        b=c0E56/DicuMgMV5OmWE7GDXsWJPOv+pAQgIGunVJR155bJ+pe6ockBIB/4HUfra9q8
         7RYRzjoBpx7BlOnLNtw0JFbQyX8shaWhGx2f8hd3/ckjrXpIW1BYZoKcbAMmyD3NPngI
         mzjk2F1Vtj0LtFWRi4hi59PFRXt80MO7wjLruPKO4JZHdyUEQrg9Rnxuli6XQesC0uuJ
         aY+wFPPtXw5oc1qFGW4Nzzh3t1s3R/A2OEzZM7p2mj3CsT8ZynAvV9YYA7Zc7TaX/ji2
         5pT19g4KWQJZhCJLFu4qVB31uhrLRq/gPVt4v8DzeUmJvSkvp3xpNANWtrTGrLxfwKxL
         8V4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrEhMwpNQAl7xOzRkKY3szVtyXF/rjqGEHYOMOmVWY4=;
        b=eFPU6lbpjBUnopgTAGmoGDjoBjycxaufX+OrsaVw9TiSG/WS/p5vfj3y4hqu8RJsD1
         kTmgA+F55LZrikheSmCcsELLK3vKw+l2JYnr2YPvHDwG3sZmFPespMulsdCnCwyaPAnC
         or2EYXjhvQeICRpEIfbQEAdbwLWXJPdp/kg8r7p1/Bpxi3peBNKz83PL2ZkGJHWzW+FI
         s9xtxFRG3Kww90kMTOr6IgJaPkLJ1+Rcc7HTjvm/hVJKYbLxnzru4wkz5RxUb6d1wIR9
         qwjTvGZn1ORyrSDrB/4xkr/jm1/QfXbGB7hGINpJVhqtRXeffz9OgV0CWWabFgEZkd4Y
         /yLw==
X-Gm-Message-State: AOAM531vBFBEyce+PejmWVy8AYNDQasycEIh/IULcKXz+8ZOqDnSQfzO
        8ksty7r3mJsHo2dfKSF+uIA=
X-Google-Smtp-Source: ABdhPJyBskNL1rUdVXYnduk2x5H+1tiRizLhshoDwJPTZl/+trGuhUNoQMeXm85TDUGh1/RgmK9VAg==
X-Received: by 2002:ac8:6b14:: with SMTP id w20mr49742203qts.320.1609268506169;
        Tue, 29 Dec 2020 11:01:46 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id k7sm26400601qtg.65.2020.12.29.11.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 11:01:45 -0800 (PST)
Date:   Tue, 29 Dec 2020 12:01:44 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 212/717] platform/x86: mlx-platform: Remove PSU
 EEPROM from MSN274x platform configuration
Message-ID: <20201229190144.GA1515901@ubuntu-m3-large-x86>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125031.129265421@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228125031.129265421@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:43:30PM +0100, Greg Kroah-Hartman wrote:
> From: Vadim Pasternak <vadimp@nvidia.com>
> 
> [ Upstream commit 912b341585e302ee44fc5a2733f7bcf505e2c86f ]
> 
> Remove PSU EEPROM configuration for systems class equipped with
> Mellanox chip Spectrum and ATOM CPU - system types MSN274x. Till now
> all the systems from this class used few types of power units, all
> equipped with EEPROM device with address space two bytes. Thus, all
> these devices have been handled by EEPROM driver "24c02".
> 
> There is a new requirement is to support power unit replacement by "off
> the shelf" device, matching electrical required parameters. Such device
> can be equipped with different EEPROM type, which could be one byte
> address space addressing or even could be not equipped with EEPROM.
> In such case "24c02" will not work.
> 
> Fixes: ef08e14a3 ("platform/x86: mlx-platform: Add support for new msn274x system type")
> Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
> Link: https://lore.kernel.org/r/20201125101056.174708-3-vadimp@nvidia.com
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/platform/x86/mlx-platform.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
> index 623e7f737d4ab..598f445587649 100644
> --- a/drivers/platform/x86/mlx-platform.c
> +++ b/drivers/platform/x86/mlx-platform.c
> @@ -601,15 +601,13 @@ static struct mlxreg_core_data mlxplat_mlxcpld_msn274x_psu_items_data[] = {
>  		.label = "psu1",
>  		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
>  		.mask = BIT(0),
> -		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[0],
> -		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
> +		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
>  	},
>  	{
>  		.label = "psu2",
>  		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
>  		.mask = BIT(1),
> -		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[1],
> -		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
> +		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
>  	},
>  };
>  
> -- 
> 2.27.0
> 
> 
> 

Please pick up eca6ba20f38c ("platform/x86: mlx-platform: remove an
unused variable") everywhere that this patch was applied to avoid
introducing a new clang warning.

Cheers,
Nathan

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F644B373
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 20:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243860AbhKITqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 14:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbhKITqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 14:46:30 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE01C061764;
        Tue,  9 Nov 2021 11:43:44 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id v40-20020a056830092800b0055591caa9c6so335492ott.4;
        Tue, 09 Nov 2021 11:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Hn1N4S+EOUFMYFm5rM50RY8TSGpVs4TLCixBeC9QDjs=;
        b=C199LwFa+kMPYkHTv+iloNSgczkEpRhH4WphKQX/xcrngTFoXndmt4ZgBxTIECHr7G
         JBwN42XTTP2qjNSNL++ITZjGGlQMzV4xil0X/P/1D7Aw9oz0uQE31yT/5hvToKzeDcFU
         a59z5RBfzXtzpqAF+AtBcxZ1C+2qptZ+iiXkslvhizS7hnGebS0sxL7Sx2MDn9e8+C62
         jQZLZVbZhxO0Stn34u9o4ZupEYO4toPbrBRMZVkDuJxhmFyw0qYB96d1WwbkOsDlR9r6
         ivVdjPYDmN/uHFStFsEWjvmyCjV25M4iza4swXc3Lmn6EMHyOcYL85qfCD3cAup6NvLp
         AOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=Hn1N4S+EOUFMYFm5rM50RY8TSGpVs4TLCixBeC9QDjs=;
        b=u3O8If/Fr75Lu9mr1e0bf8MIUqy9Gsa5Y5wqMF/9THiYSqwdA2OZ1Z4DxSEWrerago
         001g6UvhtnznprG/TaF4CGnwzLBu3coZDoQhHFZthsg3ir0hrzp6SairknoT9Bzx8uJO
         iYB8EJlxQQjs18LWyJ1oeMIVNQYZMMC6I8lx/Ywm94qo1jgbmymU5s6vNbkF4UuYu31O
         aiMpZPkafAfm35KCDVw9dj1LAQ24Ar2LiAERbVOm0zFRMnRDAiHDgidEi3OUYKXf/Hlj
         xckoyVRMHt12eVBHykxI+b1Aowbd8X75CqRy21L8UV4nLQZBGjAPn/LlbccErsalEpci
         9Thw==
X-Gm-Message-State: AOAM533GsTUVCqzy4Z8amvx7WDdroSLFk1HbkM1vXUnu7vTcXhz81dhN
        fklp+JiLa1MU7zC5CBPAa6o=
X-Google-Smtp-Source: ABdhPJx3+rPyg7q/ZQLHOXOcuB1lPuFMF9z3rf7bbuzpwG1UfPSr7pVuXCafh/+AVhZEyERZ6CxIrQ==
X-Received: by 2002:a05:6830:1cc:: with SMTP id r12mr8159931ota.76.1636487023958;
        Tue, 09 Nov 2021 11:43:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s20sm8311620oiw.53.2021.11.09.11.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 11:43:43 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Nov 2021 11:43:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Rob Herring <robh@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] clk: versatile: clk-icst: Ensure clock names are
 unique
Message-ID: <20211109194342.GA3689749@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 10:46:50AM -0600, Rob Herring wrote:
> Commit 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and
> node names") moved to using generic node names. That results in trying
> to register multiple clocks with the same name. Fix this by including
> the unit-address in the clock name.
> 
> Fixes: 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and node names")
> Cc: stable@vger.kernel.org
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-clk@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
> This should be applied to stable to minimize DT ABI breakage.
> ---
>  drivers/clk/versatile/clk-icst.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
> index 77fd0ecaf155..d52f976dc875 100644
> --- a/drivers/clk/versatile/clk-icst.c
> +++ b/drivers/clk/versatile/clk-icst.c
> @@ -484,7 +484,7 @@ static void __init of_syscon_icst_setup(struct device_node *np)
>  	struct device_node *parent;
>  	struct regmap *map;
>  	struct clk_icst_desc icst_desc;
> -	const char *name = np->name;
> +	const char *name;
>  	const char *parent_name;
>  	struct clk *regclk;
>  	enum icst_control_type ctype;
> @@ -533,15 +533,17 @@ static void __init of_syscon_icst_setup(struct device_node *np)
>  		icst_desc.params = &icst525_apcp_cm_params;
>  		ctype = ICST_INTEGRATOR_CP_CM_MEM;
>  	} else {
> -		pr_err("unknown ICST clock %s\n", name);
> +		pr_err("unknown ICST clock %pOF\n", np);
>  		return;
>  	}
>  
>  	/* Parent clock name is not the same as node parent */
>  	parent_name = of_clk_get_parent_name(np, 0);
> +	name = kasprintf(GFP_KERNEL, "%pOFP", np);
>  
>  	regclk = icst_clk_setup(NULL, &icst_desc, name, parent_name, map, ctype);
>  	if (IS_ERR(regclk)) {
> +		kfree(name);
>  		pr_err("error setting up syscon ICST clock %s\n", name);
>  		return;
>  	}
> -- 
> 2.32.0
> 

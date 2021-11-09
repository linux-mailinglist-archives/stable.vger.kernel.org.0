Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF21F44B36F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 20:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhKITqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 14:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbhKITqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 14:46:01 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F70C061764;
        Tue,  9 Nov 2021 11:43:15 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id bf8so680185oib.6;
        Tue, 09 Nov 2021 11:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Ol6YU08Qdjmwx5fOKWeOOJ8XAGNaT3y6VzCpQbMqm7o=;
        b=hREn74YmgwaTUfBT8VA7kzGM5BjBZ2OqlIEehn3hCTBKM9C+Nmb9XfOz2JvPLKJidY
         czqPPh8/4loG1l9OjuNZIeKYAjgUf+RmvKPxqdJr56anLLgsFNkt/XeoBgIErrYbNHZm
         +JwDWIbbjA0s44j2kny56cSgKenj1c/nIi1cxP1a6/qaPSiAaL0YV9SaVcJZA9HDO7yy
         mWfDics263WhLGgua3yeQxjLDLbgv/72HeqFZo4/QfSIuUSBaWn1kmyTO7ouzO80dX+/
         yXI5gq2Dr9UnHCQ9v5gfptSf915yndJ+NZu7jJETtHGMWpSQvAfHtJV65n737E95HPvz
         8sQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=Ol6YU08Qdjmwx5fOKWeOOJ8XAGNaT3y6VzCpQbMqm7o=;
        b=b1NNGh/IUsSd5BCc3H3YEpfAx6YlZHtNe5hr3wmCdnuA2OxI4jBT04pOAhwjn9e3Lg
         1bMo7wCNYCIBJ0G4RASgFbFXu2ey8evXp8kaSAGyCfrOd4DJXPuB5cvTD8Te9W/mOs/P
         6CUqpJMgG6+ysrCfzveAS253IH7E9fEmBK7x816zgM+fmcUngywOPYK+xGM+/yIpnybQ
         Vi/LHBAV5ZjfSBGmzt7QvQ/OeBTejq4CjNih0hCz8zbOOIIfhlvxRh3D5/BFiC4KPi4m
         OEmqig6LVWX18APyMmZ7os5PaDcoJvftskewM+TjzgusEUiIdQkJfUNfwqtucdMrWPYY
         RikA==
X-Gm-Message-State: AOAM530r1ZtSiROs2zTrZLCMvhpMWImY8eFdSx4Ex/FSdhxuDcmu9pdZ
        d/kK8LQMvqKuOa/MIGpXU5I=
X-Google-Smtp-Source: ABdhPJyyVVG72zZDt68cPZkfqxn5rk6W/FZzMiOgLP/Sh+HsY/rxbLZ2jmNHxZt7GFKk89lOBDsjUw==
X-Received: by 2002:a05:6808:1a02:: with SMTP id bk2mr8202779oib.52.1636486994585;
        Tue, 09 Nov 2021 11:43:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n23sm4156917oig.4.2021.11.09.11.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 11:43:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Nov 2021 11:43:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Rob Herring <robh@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 1/2] of: Support using 'mask' in making device bus id
Message-ID: <20211109194308.GA3689721@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 10:46:49AM -0600, Rob Herring wrote:
> Commit 25b892b583cc ("ARM: dts: arm: Update register-bit-led nodes
> 'reg' and node names") added a 'reg' property to nodes. This change has
> the side effect of changing how the kernel generates the device name.
> The assumption was a translatable 'reg' address is unique. However, in
> the case of the register-bit-led binding (and a few others) that is not
> the case. The 'mask' property must also be used in this case to make a
> unique device name.
> 
> Fixes: 25b892b583cc ("ARM: dts: arm: Update register-bit-led nodes 'reg' and node names")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: stable@vger.kernel.org
> Cc: Frank Rowand <frowand.list@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rob Herring <robh@kernel.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
> This should be applied to stable to minimize DT ABI breakage.
> ---
>  drivers/of/platform.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 07813fb1ef37..b3faf89744aa 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -76,6 +76,7 @@ static void of_device_make_bus_id(struct device *dev)
>  	struct device_node *node = dev->of_node;
>  	const __be32 *reg;
>  	u64 addr;
> +	u32 mask;
>  
>  	/* Construct the name, using parent nodes if necessary to ensure uniqueness */
>  	while (node->parent) {
> @@ -85,8 +86,13 @@ static void of_device_make_bus_id(struct device *dev)
>  		 */
>  		reg = of_get_property(node, "reg", NULL);
>  		if (reg && (addr = of_translate_address(node, reg)) != OF_BAD_ADDR) {
> -			dev_set_name(dev, dev_name(dev) ? "%llx.%pOFn:%s" : "%llx.%pOFn",
> -				     addr, node, dev_name(dev));
> +			if (!of_property_read_u32(node, "mask", &mask))
> +				dev_set_name(dev, dev_name(dev) ? "%llx.%x.%pOFn:%s" : "%llx.%x.%pOFn",
> +					     addr, ffs(mask) - 1, node, dev_name(dev));
> +
> +			else
> +				dev_set_name(dev, dev_name(dev) ? "%llx.%pOFn:%s" : "%llx.%pOFn",
> +					     addr, node, dev_name(dev));
>  			return;
>  		}
>  
> -- 
> 2.32.0
> 

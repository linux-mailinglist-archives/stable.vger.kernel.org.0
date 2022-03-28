Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0A24E8C83
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 05:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbiC1DTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 23:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiC1DTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 23:19:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30F34FC51
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 20:17:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id o8so11189990pgf.9
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 20:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iRywC2fXGTLu3XcU+kOv95CJI0/k5YKaCHVvR7OvlV0=;
        b=Nfd9upElHAEIafOt6kM6Nan2028B+2XJaXGyzMy2vndOjHxTyrwfDWAzbrS2gqhlfC
         5FdbSHzvm62LfGlh6yNDR1CAHwZRuTeHqoKsr/3vY2jQctjGySYCpv4NaGmIPuAJ6iHl
         X1ZXEhwIOP73ziWzVm3aZhZiFYAhNKz4Du/yyP8333MOVQraMF+m9JPzhG+8n26SvzNT
         SeQJJowvS7p8zgy0UprHttmaQg9nB+vMvJyrRtxJIgIYUeDyFku8iDgsO6ucq+cKkkwi
         7qmYpCvhL2BiCF4uerLvA3b4SnF/bhFnCIX5dvb5eXElUc59kC3LXCbt9Y8PTj+iMlVT
         5bnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iRywC2fXGTLu3XcU+kOv95CJI0/k5YKaCHVvR7OvlV0=;
        b=sJ39SetSJ/iqZmB/jHrDI2SlN9R8pNYnf2FKSu0SenQUVuchkWysV64M+oxRP8q9Al
         aNSL8JnQtY2SGhzGijaxb4Xcqw5B1ILJD5uLxTRFdnsSCbU/DBHPhrNM86m9GwI3KtBg
         SeSWEbr6ovONhhqm2coa5vZO6dw5bd96BmvXRKEpzbyeGQkGHPaVNwgodcNyFqdujJk9
         ioBJstd0U0RAa8F9goMQm1EQM+qIMeCpI24k4F9HboWsYGx5NBVBxsPx3260SN4QteFY
         9jllGyATGgvWW1yFGCRPVW0b+m6iBHkWBazSWmlIkZIinQ7bxLCk19al4obyIZyQeNi0
         zxCw==
X-Gm-Message-State: AOAM531qfURktYj2Lnn3byinjxzeHv3ytXDuhzhrvj0HQM9dl5PlwCyQ
        7Ab6h+/k9K8MyaFB9Aj6GTGUxg==
X-Google-Smtp-Source: ABdhPJwNlEup1sWc1qRG3ghM8ZUBSwqj/5AovEGBEAHE4mZq8u1uojTon7EChtSm992YTThF/H9YqQ==
X-Received: by 2002:a63:1620:0:b0:375:948e:65bf with SMTP id w32-20020a631620000000b00375948e65bfmr8880013pgl.49.1648437462221;
        Sun, 27 Mar 2022 20:17:42 -0700 (PDT)
Received: from localhost ([223.184.83.228])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00230c00b004faf2563bcasm12787512pfh.114.2022.03.27.20.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 20:17:41 -0700 (PDT)
Date:   Mon, 28 Mar 2022 08:47:39 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        rafael.j.wysocki@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] opp: fix a missing check on list iterator
Message-ID: <20220328031739.72togwws2u2rlluo@vireshk-i7>
References: <20220327053943.3071-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327053943.3071-1-xiam0nd.tong@gmail.com>
User-Agent: NeoMutt/20180716-391-311a52
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27-03-22, 13:39, Xiaomeng Tong wrote:
> The bug is here:
>     dev = new_dev->dev;
> 
> The list iterator 'new_dev' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will lead
> to a invalid memory access.
> 
> To fix this bug, add an check. Use a new variable 'iter' as the
> list iterator, while use the old variable 'new_dev' as a dedicated
> pointer to point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: deaa51465105a ("PM / OPP: Add debugfs support")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/opp/debugfs.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
> index 596c185b5dda..a4476985e4ce 100644
> --- a/drivers/opp/debugfs.c
> +++ b/drivers/opp/debugfs.c
> @@ -187,14 +187,19 @@ void opp_debug_register(struct opp_device *opp_dev, struct opp_table *opp_table)
>  static void opp_migrate_dentry(struct opp_device *opp_dev,
>  			       struct opp_table *opp_table)
>  {
> -	struct opp_device *new_dev;
> +	struct opp_device *new_dev = NULL, *iter;
>  	const struct device *dev;
>  	struct dentry *dentry;
>  
>  	/* Look for next opp-dev */
> -	list_for_each_entry(new_dev, &opp_table->dev_list, node)
> -		if (new_dev != opp_dev)
> +	list_for_each_entry(iter, &opp_table->dev_list, node)
> +		if (iter != opp_dev) {
> +			new_dev = iter;
>  			break;
> +		}
> +
> +	if (!new_dev)
> +		return;

I think you missed this check in the parent function ?

		if (!list_is_singular(&opp_table->dev_list)) {


i.e. this bug can never happen.

-- 
viresh

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C374FB376
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 08:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbiDKGLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 02:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiDKGLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 02:11:43 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AF517E02
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 23:09:26 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t13so13289488pgn.8
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 23:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eYsU7WRE93drZwpg2UmtM51iMD33Wv0zBhClOLennSo=;
        b=Mz07erur6e2ikl+2ye9ThqP56D56aL72/pPMeastiEBlqU4fJyPFvkRjb5Ew2ZCwiF
         J17RUCBM/7MlDhjHmG9G12MSoK4Q1DocMN5JgwCa5l3072EJYGNnxo3iZCM4FOf5gsFt
         vPaeCMClSHwzjxsXkS8N59UPxIjK591oLxDwZIJI7Peb6LemPbXkmLfQbyDGwvUxikoD
         Z2RUH93uZCPrD/P0LS5y9qm7o4RcYbLr+q6WESmSpdqdY4sNo4bcRTxyVVLFIez/EI04
         CGpS5+58uIUX3zjCuIYzhkcvDGKpOLd9Ne6LC+qebGgDbnLoTE9+S19kFfjCtfBAxl+Z
         x9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eYsU7WRE93drZwpg2UmtM51iMD33Wv0zBhClOLennSo=;
        b=bfShJXZ4VKzOBCzBoTWdEV3GhgXyaI1xYDrZ+5+EUnWt6S3eL+TDKMzs4I7W+/DV9n
         iYs4Gxtt7rDTtjrO6nM6SSqZStn+h6lmsrjdz7QUr6U3PDJ+x9PWq0IJYZF1DCjyoziF
         FeMVLefTIGZqBwghbMoHvOS7M/S6sT+RVNUcUpb35DMVZNpBQXRQHFNUaEs4NFtDtihX
         +ZCN9GkVLsHrPIjstoMqb+22ZAbn2G+W8RrgV2z+AHWaxnvc4wLI2R2Zq7pQNI9O1WCo
         ytMWR3GFeUY9+sgBfqW4JvNsxepIMj01Epf33rqwenGBe1d1Hk07jJiIn9qVgg3Pm0YO
         Pdtw==
X-Gm-Message-State: AOAM531MUh6RnoM16Ld4QjWZGriD82Eo+Q23SiYnS4GK/ZbHKqRCXwqo
        x2yp45humbi2ipsNyLDkLriw
X-Google-Smtp-Source: ABdhPJwvcNOCbDiYurnD9wBA0ICQ8RITifSEinUCTPZXqdyKm+Kk7yV2hvDKolvn9dV8HelyuRRzAA==
X-Received: by 2002:a63:f642:0:b0:386:53e:9cd4 with SMTP id u2-20020a63f642000000b00386053e9cd4mr24814896pgj.265.1649657366381;
        Sun, 10 Apr 2022 23:09:26 -0700 (PDT)
Received: from thinkpad ([117.217.182.106])
        by smtp.gmail.com with ESMTPSA id a9-20020a056a000c8900b004fb37ecc6bbsm34922659pfv.65.2022.04.10.23.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 23:09:25 -0700 (PDT)
Date:   Mon, 11 Apr 2022 11:39:21 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: mhi: host: pci_generic: Flush recovery worker
 during freeze
Message-ID: <20220411060921.GC16845@thinkpad>
References: <20220408150039.17297-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408150039.17297-1-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 08, 2022 at 08:30:39PM +0530, Manivannan Sadhasivam wrote:
> It is possible that the recovery work might be running while the freeze
> gets executed (during hibernation etc.,). Currently, we don't powerdown
> the stack if it is not up but if the recovery work completes after freeze,
> then the device will be up afterwards. This will not be a sane situation.
> 
> So let's flush the recovery worker before trying to powerdown the device.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
> Reported-by: Bhaumik Vasav Bhatt <quic_bbhatt@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied to mhi-next!

Thanks,
Mani

> ---
> 
> Changes in v2:
> 
> * Switched to flush_work() as the workqueue used is global one.
> 
>  drivers/bus/mhi/host/pci_generic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
> index ef85dbfb3216..541ced27d941 100644
> --- a/drivers/bus/mhi/host/pci_generic.c
> +++ b/drivers/bus/mhi/host/pci_generic.c
> @@ -1060,6 +1060,7 @@ static int __maybe_unused mhi_pci_freeze(struct device *dev)
>  	 * the intermediate restore kernel reinitializes MHI device with new
>  	 * context.
>  	 */
> +	flush_work(&mhi_pdev->recovery_work);
>  	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
>  		mhi_power_down(mhi_cntrl, true);
>  		mhi_unprepare_after_power_down(mhi_cntrl);
> -- 
> 2.25.1
> 

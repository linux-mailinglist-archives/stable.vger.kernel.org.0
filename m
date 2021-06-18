Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D724A3AC1E4
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 06:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFREUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 00:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbhFREUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 00:20:47 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D409DC06175F
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 21:18:37 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g6so6727849pfq.1
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 21:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A7veP2+rvJhREGxZ7bA2MKokj7fOMWmnWBdu22Gjixs=;
        b=plDYr7URR38B4jGYMsxSURthpcFrTWdDpgkJZiOYCuF4iliXpJ56Mn3TIhtq6Hj3Ko
         DcJqLB0QmDx+XU5q97EHRY8Z+3l44WgV8KsrWl60QLCgykxwjoenpSzt8r2PsJABEnbV
         jnUqsGTAemSR2cNPF1fsD5PWJxUjOSGKN7tNFoyi8QHGOfI8Oe9DhyP6lplAOsox9rYM
         ToHvttUNsT80qTybhX19aohlNodJS1Z9II5W3Ul1On1PDhnZ8W8YRoo7Uz+uitlVLP7s
         NQ8zh9QQXrgGvYeR/5Vu3hiRaPODOYGYDR6en/M34Md65klj78jhxoKpPolvM3Pjk9BT
         KtZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A7veP2+rvJhREGxZ7bA2MKokj7fOMWmnWBdu22Gjixs=;
        b=Hpn790uZnyqX8kSi71RIitG9BWIpOXcaS+Dj4LUmZWNLGA0tum6o/jRTjbOV+2hHUR
         iLhjJidoGOrtBkQMReLyAMQZXT6PW92JJwJu99FHsOsMTx3pliMZed1Gu06O4BbVeAUZ
         RA4utuz59ggabbpnlkbgSMbXqjnZA1+YR9UhfNsNXUMwfo4N2byVUXGaUctc7BOgHoVt
         KuliHW4skWNvpAR2K/Ylx3php07C8aG+O1ebTHHtu08KX/Z3S7ZphH9VQzyzR2SKRo1+
         4MTag/XG8cwPLZOpjHb4xVini6IP6s/3YrXYhT7pJffxdQSONktHU+70Ju1zzzGkOcX+
         Xi/A==
X-Gm-Message-State: AOAM532/p23V1/dAgymcTyJiO/mnijN3os6tXdN0LY0clmZhrxAB4Hux
        dfkV2dPb/xK5TbqNbg2id/bp
X-Google-Smtp-Source: ABdhPJz5nIO0obUzGfQWU2OY7LlyNmGKp7Hy07h54AzlLuFHm3eedis+rYyTYKWqhR+BwvY3pYmALw==
X-Received: by 2002:a63:3246:: with SMTP id y67mr8193050pgy.244.1623989917247;
        Thu, 17 Jun 2021 21:18:37 -0700 (PDT)
Received: from workstation ([120.138.13.238])
        by smtp.gmail.com with ESMTPSA id s13sm6431308pjm.34.2021.06.17.21.18.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jun 2021 21:18:35 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:48:31 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, jassisinghbrar@gmail.com,
        agross@kernel.org, rananta@codeaurora.org, vnkgutta@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion
Message-ID: <20210618041831.GA3682@workstation>
References: <1623865378-1943-1-git-send-email-sibis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623865378-1943-1-git-send-email-sibis@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 11:12:58PM +0530, Sibi Sankar wrote:
> Fix IPCC (Inter-Processor Communication Controller) channel exhaustion by
> setting the channel private data to NULL on mbox shutdown.
> 
> Err Logs:
> remoteproc: MBA booted without debug policy, loading mpss
> remoteproc: glink-edge: failed to acquire IPC channel
> remoteproc: failed to probe subdevices for remoteproc: -16
> 
> Fixes: fa74a0257f45 ("mailbox: Add support for Qualcomm IPCC")
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> Cc: stable@vger.kernel.org
> ---
>  drivers/mailbox/qcom-ipcc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
> index 2d13c72944c6..584700cd1585 100644
> --- a/drivers/mailbox/qcom-ipcc.c
> +++ b/drivers/mailbox/qcom-ipcc.c
> @@ -155,6 +155,11 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
>  	return 0;
>  }
>  
> +static void qcom_ipcc_mbox_shutdown(struct mbox_chan *chan)
> +{
> +	chan->con_priv = NULL;
> +}
> +
>  static struct mbox_chan *qcom_ipcc_mbox_xlate(struct mbox_controller *mbox,
>  					const struct of_phandle_args *ph)
>  {
> @@ -184,6 +189,7 @@ static struct mbox_chan *qcom_ipcc_mbox_xlate(struct mbox_controller *mbox,
>  
>  static const struct mbox_chan_ops ipcc_mbox_chan_ops = {
>  	.send_data = qcom_ipcc_mbox_send_data,
> +	.shutdown = qcom_ipcc_mbox_shutdown,
>  };
>  
>  static int qcom_ipcc_setup_mbox(struct qcom_ipcc *ipcc)
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 

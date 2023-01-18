Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994CC67256C
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 18:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjARRsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 12:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjARRrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 12:47:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9E05CFD7;
        Wed, 18 Jan 2023 09:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB46ACE1B53;
        Wed, 18 Jan 2023 17:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58C4C433F0;
        Wed, 18 Jan 2023 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674063988;
        bh=MWdNzb1aQw4NJSMQBvu2jSlHNAYyl/IhJuxAJiXZHWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ol5PtcjeQNn+GhJ8Y0tkDbOmz6I1a6MuIpO0o+ECwx+qtLepmgkkSFN+XzFPUwF9Y
         OE5kcKAHreizCqXe5hiHEYN9PeZ4EY2nc4KOlhgGVBOQGRldjGyqH9GoCZhOwCx4I7
         MgBU2EoMBvhaT8NiDcHbQthWohhLpmWAiQQHwTh+zprkwvS/UkZP29uOKyVUEUSll2
         QcFFgOmjmi6qKEup3A3yCn19kDiLCgwqUxa2qb9y36Yq8P9d1IWTb8G0rlQQoUcuoH
         YFhNldU8FD01eYT0tq+Tn2YrCluJAZQFgz3B1DhQ2DuiqiW8U+6eWTMDFbsDvr6lIF
         U6qc/sXrcfLJw==
Date:   Wed, 18 Jan 2023 11:46:25 -0600
From:   Bjorn Andersson <andersson@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        bp@alien8.de, tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        ahalaney@redhat.com, steev@kali.org, stable@vger.kernel.org
Subject: Re: [PATCH v6 01/17] EDAC/device: Respect any driver-supplied
 workqueue polling value
Message-ID: <20230118174625.oo5gi36q45kfbgoq@builder.lan>
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118150904.26913-2-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 08:38:48PM +0530, Manivannan Sadhasivam wrote:
> The EDAC drivers may optionally pass the poll_msec value. Use that value
> if available, else fall back to 1000ms.
> 
>   [ bp: Touchups. ]
> 
> Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Your S-o-b should be the last one to indicate that you are the  one
certifying the origin of this patch.

> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>

If the two of you wrote the patch, please add a Co-developed-by.

Thanks,
Bjorn

> Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
> Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
> Cc: <stable@vger.kernel.org> # 4.9
> Link: https://lore.kernel.org/r/COZYL8MWN97H.MROQ391BGA09@otso
> ---
>  drivers/edac/edac_device.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
> index 19522c568aa5..a50b7bcfb731 100644
> --- a/drivers/edac/edac_device.c
> +++ b/drivers/edac/edac_device.c
> @@ -34,6 +34,9 @@
>  static DEFINE_MUTEX(device_ctls_mutex);
>  static LIST_HEAD(edac_device_list);
>  
> +/* Default workqueue processing interval on this instance, in msecs */
> +#define DEFAULT_POLL_INTERVAL 1000
> +
>  #ifdef CONFIG_EDAC_DEBUG
>  static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
>  {
> @@ -336,7 +339,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
>  	 * whole one second to save timers firing all over the period
>  	 * between integral seconds
>  	 */
> -	if (edac_dev->poll_msec == 1000)
> +	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
>  		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
>  	else
>  		edac_queue_work(&edac_dev->work, edac_dev->delay);
> @@ -366,7 +369,7 @@ static void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
>  	 * timers firing on sub-second basis, while they are happy
>  	 * to fire together on the 1 second exactly
>  	 */
> -	if (edac_dev->poll_msec == 1000)
> +	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
>  		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
>  	else
>  		edac_queue_work(&edac_dev->work, edac_dev->delay);
> @@ -398,7 +401,7 @@ void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
>  {
>  	unsigned long jiffs = msecs_to_jiffies(value);
>  
> -	if (value == 1000)
> +	if (value == DEFAULT_POLL_INTERVAL)
>  		jiffs = round_jiffies_relative(value);
>  
>  	edac_dev->poll_msec = value;
> @@ -443,11 +446,7 @@ int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
>  		/* This instance is NOW RUNNING */
>  		edac_dev->op_state = OP_RUNNING_POLL;
>  
> -		/*
> -		 * enable workq processing on this instance,
> -		 * default = 1000 msec
> -		 */
> -		edac_device_workq_setup(edac_dev, 1000);
> +		edac_device_workq_setup(edac_dev, edac_dev->poll_msec ?: DEFAULT_POLL_INTERVAL);
>  	} else {
>  		edac_dev->op_state = OP_RUNNING_INTERRUPT;
>  	}
> -- 
> 2.25.1
> 

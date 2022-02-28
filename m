Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E194C4C709F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 16:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiB1PbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 10:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiB1PbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 10:31:09 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B657EB0A
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:30:29 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id w4so10239847ilj.5
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7xuq/jHgOUriIm1O/BV7S1L7sNlV9+5iBX6aT2AWV0s=;
        b=Ckmgyi0L1ORPLOIs0I59pJKj3U54sFM9eXt7zVW3L8Zz3vVWcUMuDhm4H5a0vH4P0r
         dMwwxS0/KGseXwyf0kqph5aogznMPR27U5WJtAkF1tTLkwgui7KkoFSBuNke67NYvHBn
         zo4bt5FdK9LoYJx8RqwfwmVSextkRSxiTUfjgQUMI9y2NzVE8v6DcZBQfMygp4HF3c3/
         K5PTTu5KC2uqpcwucSwCDYMzKUpA6YfJVXHgHqiEmkBagcqLNDZvufFiD6k4WPgOiNkq
         vJu3UipP5TDqjLSQGIhc0SdYb16UTannauH9vGQH08ptV/XB1MlfgAQrD7j0WeyrBVEg
         SBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7xuq/jHgOUriIm1O/BV7S1L7sNlV9+5iBX6aT2AWV0s=;
        b=v5iMYg1pYMEbjIFyq+JNMZZSA4F4MQjkcZAIbJxebv5gR3GdnRm+RRNPK6N8PIv+Yz
         t49esqwtQ3HfuK2CT5IfT/FG8YNsDIQGjdDBEs1pSfB744y0E1JOK58J0PjfLMQPF9VX
         MJwRniUYvo3l87GE7BMA80Qj1k3cIgtywMdkbTQNZQDsdk1YzhfS+QS+lnBXQyUSy65+
         A34JzZaSPjGXtfatlzy7GQ80BzsoOIRsfIeavjRxFlFUqKEKKmPlCT7I6VAA6uVvdiBU
         bCBXeGnGIhmq8lqvYTvufT8QO6wEZcHD0adrgOd+0yaqKPU0aDnXG3Eu4PAzfI2opvsa
         c1jw==
X-Gm-Message-State: AOAM5338+uWV+TfKlvrKqi8vpXizogrPE9edobrZqBKlVldhvCRi/7Je
        qJNtqRDnUCE//GLjJ/ZuOqQhcw==
X-Google-Smtp-Source: ABdhPJzwxFhKVHGQFdEn09+VOKy0nPF9+3HOs0WuXGTDKn+rgLpe2qPij7SospjNJcbvkVBrxkUuow==
X-Received: by 2002:a05:6e02:1587:b0:2c2:5c48:a695 with SMTP id m7-20020a056e02158700b002c25c48a695mr19306744ilu.169.1646062229191;
        Mon, 28 Feb 2022 07:30:29 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id u17-20020a056e02111100b002c2a943034esm5952850ilk.5.2022.02.28.07.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 07:30:28 -0800 (PST)
Message-ID: <6fc89860-9eea-630c-f193-272bf436ad81@linaro.org>
Date:   Mon, 28 Feb 2022 09:30:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 01/27] bus: mhi: Fix pm_state conversion to string
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        quic_jhugo@quicinc.com, vinod.koul@linaro.org,
        bjorn.andersson@linaro.org, dmitry.baryshkov@linaro.org,
        quic_vbadigan@quicinc.com, quic_cang@quicinc.com,
        quic_skananth@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
References: <20220228124344.77359-1-manivannan.sadhasivam@linaro.org>
 <20220228124344.77359-2-manivannan.sadhasivam@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220228124344.77359-2-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/28/22 6:43 AM, Manivannan Sadhasivam wrote:
> From: Paul Davey <paul.davey@alliedtelesis.co.nz>
> 
> On big endian architectures the mhi debugfs files which report pm state
> give "Invalid State" for all states.  This is caused by using
> find_last_bit which takes an unsigned long* while the state is passed in
> as an enum mhi_pm_state which will be of int size.
> 
> Fix by using __fls to pass the value of state instead of find_last_bit.
> 
> Also the current API expects "mhi_pm_state" enumerator as the function
> argument but the function only works with bitmasks. So as Alex suggested,
> let's change the argument to u32 to avoid confusion.

(Grumble grumble too much static data in header file.)

Reviewed-by: Alex Elder <elder@linaro.org>

> Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
> Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> Cc: stable@vger.kernel.org
> [mani: changed the function argument to u32]
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/bus/mhi/core/init.c     | 10 ++++++----
>   drivers/bus/mhi/core/internal.h |  2 +-
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> index 046f407dc5d6..09394a1c29ec 100644
> --- a/drivers/bus/mhi/core/init.c
> +++ b/drivers/bus/mhi/core/init.c
> @@ -77,12 +77,14 @@ static const char * const mhi_pm_state_str[] = {
>   	[MHI_PM_STATE_LD_ERR_FATAL_DETECT] = "Linkdown or Error Fatal Detect",
>   };
>   
> -const char *to_mhi_pm_state_str(enum mhi_pm_state state)
> +const char *to_mhi_pm_state_str(u32 state)
>   {
> -	unsigned long pm_state = state;
> -	int index = find_last_bit(&pm_state, 32);
> +	int index;
>   
> -	if (index >= ARRAY_SIZE(mhi_pm_state_str))
> +	if (state)
> +		index = __fls(state);
> +
> +	if (!state || index >= ARRAY_SIZE(mhi_pm_state_str))
>   		return "Invalid State";
>   
>   	return mhi_pm_state_str[index];
> diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
> index e2e10474a9d9..3508cbbf555d 100644
> --- a/drivers/bus/mhi/core/internal.h
> +++ b/drivers/bus/mhi/core/internal.h
> @@ -622,7 +622,7 @@ void mhi_free_bhie_table(struct mhi_controller *mhi_cntrl,
>   enum mhi_pm_state __must_check mhi_tryset_pm_state(
>   					struct mhi_controller *mhi_cntrl,
>   					enum mhi_pm_state state);
> -const char *to_mhi_pm_state_str(enum mhi_pm_state state);
> +const char *to_mhi_pm_state_str(u32 state);
>   int mhi_queue_state_transition(struct mhi_controller *mhi_cntrl,
>   			       enum dev_st_transition state);
>   void mhi_pm_st_worker(struct work_struct *work);


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024BF6267D1
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 08:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbiKLHvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Nov 2022 02:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKLHvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Nov 2022 02:51:23 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707831B9CD
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 23:51:22 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id h12so6861486ljg.9
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 23:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2jNNa94XG+j4AtxhXDtMD9Ngnwggz8hGYOvam5X+ciw=;
        b=NjkuAZRBWfA3wfFKN5kvJXUiiW0S6Juci9RpQhW1qrAzggM08v6THBTevlA3u/gA4/
         9hLEuNmalCFSGQkOmu49aZ2S3G9nCGDdT61HipSqJwwOY/frWO8Rz8pWpOBhVXevVEg5
         EwgevE2r6pFhZ7MWWUtUqFrzZu8CaDyMDa1Cgn4qCByojs/RKc3ZOg9TZs4VJNLCSoOK
         /jt8YfJONydYAfWytZFiiK14N6+6yuOa3dMLZWfLmUCHghxbY3Zrpe9JeLL2qNIOqVHd
         xisIAS8Huznwp/MmUQWWOwzfKj2YcKMvnYNOp5Pv0gwLtzWYkV955SwKPXn/Uy56Jktj
         wXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2jNNa94XG+j4AtxhXDtMD9Ngnwggz8hGYOvam5X+ciw=;
        b=R/p2wCUcyoh1+piFKtBhY0NDXO9LwozGC8P6erI3kO5NMjFxytUfowLuCEn9mHIwga
         xpjA7GDjgYLWwrGaFSB/FTcLekCxqjjwLSHdFG+7rT2F33NuS14d2VHYk9PsU5xWWJi6
         BjrPLI9pw7Yd/b7gbIgmyjLb3VDY3XsXQvEFUWg8BREhExDpwTMO9xqP4n+JWDyQemiD
         nwSR9duHrnqPM/AeIranuKK+OPPaEK6sICyRCyKICBLNdoRf1KeFIRLc8Sfyr/w74+6G
         bJynz655anP4VQDUnX8wcMyt+Bmgvmo6LwwssxNglfNgspOHQbN0HkW5X3fRag9pfgQz
         HMKg==
X-Gm-Message-State: ANoB5pmfht8ZLLHzoASZC0EyZDKUV5VDfyE2rHa8pKbympDJ2IysvwGY
        lFv30D6ZZCqjFR100bYXu2fYbQ==
X-Google-Smtp-Source: AA0mqf6EHlOlvN/k6hEFHAcfnf5RkjvFZ8rEaoPR0BCNMYrjcn5zy9XzRrNXZVQUeagBRS7ViuTyyg==
X-Received: by 2002:a2e:9ec2:0:b0:26e:768c:11ed with SMTP id h2-20020a2e9ec2000000b0026e768c11edmr1730265ljk.436.1668239480882;
        Fri, 11 Nov 2022 23:51:20 -0800 (PST)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id b24-20020a056512071800b004b15bc0ff63sm736003lfs.277.2022.11.11.23.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 23:51:20 -0800 (PST)
Message-ID: <ad6343e1-7734-2ecf-6cbf-0081931da97d@linaro.org>
Date:   Sat, 12 Nov 2022 10:51:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 3/6] phy: qcom-qmp-combo: fix sc8180x reset
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221111084255.8963-1-johan+linaro@kernel.org>
 <20221111084255.8963-4-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20221111084255.8963-4-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/2022 11:42, Johan Hovold wrote:
> The SC8180X has two resets but the DP configuration erroneously
> described only one.
> 
> In case the DP part of the PHY is initialised before the USB part (e.g.
> depending on probe order), then only the first reset would be asserted.
> 
> Fixes: 1633802cd4ac ("phy: qcom: qmp: Add SC8180x USB/DP combo")
> Cc: stable@vger.kernel.org	# 5.15
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>   drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry


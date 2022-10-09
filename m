Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF87F5F8C01
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJIPZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 11:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJIPZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 11:25:20 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FFA1D678
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 08:25:19 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id a17so518827qtw.10
        for <stable@vger.kernel.org>; Sun, 09 Oct 2022 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMWBP42bcqYR/9/IcRRsvCkgoPBmDNpE4tq769Q64oI=;
        b=hzPt6d3JeW0Footcf5s588X/R44BO81hmMDQLXWaFZJY5KbRKNCumivhg/rE96IjH2
         Kw0XoDHKhAOlIOhvgoIrD7k8SILH88ecSk16n/o8Wg6aV25QILm+OGF1vXYxAT3e77FQ
         Ew7GlZ/QGNq7w36LYmKwZFNscIEGwPkYA1qgHpBf1koWgvgZeM03ZIm1rqptWbZIAsE/
         X1tYIXazKHgCvi13Dvhr3XD2f/0oLPr2loqEQJOBzPUwJ1svmyqKy6wL1eE8l80zrIPj
         lN6u8JkgPlyu1zkDaYukKKjsJ1xvIbxYYq+bQhQ91CFCjJmBB5gE+lKOgF7WYjGjPIDX
         0Atg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMWBP42bcqYR/9/IcRRsvCkgoPBmDNpE4tq769Q64oI=;
        b=VPjyyCmJWY6wqh9KGqLX6XnlZILSh1d+c4mrMlguvpW8LXBfZHPdhFFPKiQ+9dFLP0
         Ja1Vbg1D8628mig/1ZNFoV1HZOtHkNCmWzua1k5jLM5EDpq2x2SV29gkOzBYXgyv/NuE
         ITC/NtEzVjyZz06dky3AiM/YuFCq0R6MsMz3h6TzoLZpZGFoo0WTAUNvdZjNgUSeSfdS
         ZGX+DtzUnq0uSD56RzBbWIgIV5kahLVl6+AIsXZiCXhbOs9rNa7pRbupchP0VvT3PAHy
         TUiE444pGnR9cVO1N1wT5Afzq3Y9SR0dcqg2mvC2Azn95z9K4wJs2Y/LqpWKNU/c8t+r
         OH9g==
X-Gm-Message-State: ACrzQf2Go8rlaHnvHFpXnFPPzDJ0YbL8NTzPjQsa5Wl3K6/LX6NdhHlv
        s2bp13NTrMJml8utn9F4ztMBSw==
X-Google-Smtp-Source: AMsMyM6WOzEKoFOz4nRaUQLwSDLVPIGwcjJ8aEcuHay/BBUrycXh6QCMWv6+memfJTEi64NCDRE5Tw==
X-Received: by 2002:ac8:7e94:0:b0:38e:2bea:9dd9 with SMTP id w20-20020ac87e94000000b0038e2bea9dd9mr11825064qtj.67.1665329118301;
        Sun, 09 Oct 2022 08:25:18 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id fp25-20020a05622a509900b0034305a91aaesm6549834qtb.83.2022.10.09.08.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 08:25:17 -0700 (PDT)
Message-ID: <e829329e-ac55-e04a-c8ab-4eeeec6217ab@linaro.org>
Date:   Sun, 9 Oct 2022 17:23:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 5.10 1/1] rpmsg: qcom: glink: replace strncpy() with
 strscpy_pad()
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        Andrew Chernyakov <acherniakov@astralinux.ru>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20221007132931.123755-1-acherniakov@astralinux.ru>
 <20221007132931.123755-2-acherniakov@astralinux.ru>
 <Y0BWc6A8C++M9TWP@kroah.com>
 <36f776cbc16f4e988d96b7bcb77cd559@AcuMS.aculab.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <36f776cbc16f4e988d96b7bcb77cd559@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/10/2022 23:11, David Laight wrote:
>>> ---
>>>  drivers/rpmsg/qcom_glink_native.c | 2 +-
>>>  drivers/rpmsg/qcom_smd.c          | 4 ++--
>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> Why just this specific kernel branch?  We can't add patches to an older
>> tree and have someone upgrade to a newer one and hit the same issue.
>>
>> So please provide backports for all active versions.  In this case that
>> would be 5.15.y and 5.19.y.
> 
> If it is only fixing a compile warning is it even stable material?
> The generic commit message doesn't say whether the old code was
> actually right or wrong.
> 
> At least one of these 'replace strncpy()' changes was definitely
> broken (the copy needed to be equivalent to memcpy()).
> 
> So applying ANY of them to stable unless they actually fix
> a real bug seems dubious.

Except the warning from GCC, there was no bug to fix. The warning is
about discouraged and risky practice, but no actual real risk was
identified, so for me it matches stable rules poorly.

It's basically backporting to silence automated code checkers...

Best regards,
Krzysztof


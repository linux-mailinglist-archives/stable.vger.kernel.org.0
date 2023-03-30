Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E610F6CF9E5
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 06:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjC3EAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 00:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3EAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 00:00:36 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17718468A
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 21:00:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h14so10560653pgj.7
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 21:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680148833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6Joh1yyjlzUhXvO/lz/fYfCYrQA+xYzttBmRPJ2FSk=;
        b=RShaB8Ewrhpzb/NXunnI5Y//ZTfY/lFlID0e9yAbQXiKPlnxIKR2V3YBzFxBuW/3WW
         8CBML0hMJwhf/F8PWtYX+PNK+P/Lzv0moVcN43zBG4mIzv91WPtGxNVrxQPDsLTKOL7e
         Y7Jkb9JMNMS9EwmxEVvzB1vMGtrTIy1SAlbZWtWV/DS3YJ1OJS37JTVMFKlDK/V6THvq
         6TaWh45pAIut3CST+OaLLm5r2wMpy10zOXqtkACNoLwKkkcp7y6OBYY6u92UUeE+2e/Y
         FUHMIrWEJeC9nhHHAMwwTzPH7wK6zpkRNKXp6SRbZnMO9QdIef20+CmVG+2s1+FRfuty
         BE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680148833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6Joh1yyjlzUhXvO/lz/fYfCYrQA+xYzttBmRPJ2FSk=;
        b=STfRIPBWaj/14Fz2EpU4r8184OvqEG7MHSvjqTrCM73XT/Ih6RrjthQygs+QDa7raz
         luEUYFERyjkF4BXxwpKeMfG425dZtH9xKQDqXcuObptkUyvJv4slSNXMoNUnJbf9/Iau
         Zice4bLOvx8gS7MABtYr88xRhIMLTuYloRlwIWXFOD8Kvb2hY/bcRRqeAlD6xJpPiz3r
         U6HYVo6wqxSPeJG7+HRtkMItDgMzp8FtsjBK7yQ44PttQ1bm6XahtGS3UOTN5VUWAV8G
         ufp8RZr+F9pfMlqjCootC2a9tmPOGVEa1dAwlebuov5JDjWjlDqWzwybzpErHltm/TsI
         T4VQ==
X-Gm-Message-State: AAQBX9f8/3X0NhgGWFfUNbB45I7qgVYGgDiNcY1lBKnSqK332KdxvHSZ
        Rp11RgcjQyD/WtFPvy8s5Dqzqw==
X-Google-Smtp-Source: AKy350bstz70jNqKs7AiPJmYPZ+FFPt8xMW1yNR+PuRu02je+smc1Prw/DUlJM2bjcYaLnsnw1KNbA==
X-Received: by 2002:a62:640e:0:b0:624:cfbe:bbfa with SMTP id y14-20020a62640e000000b00624cfbebbfamr20274534pfb.15.1680148833482;
        Wed, 29 Mar 2023 21:00:33 -0700 (PDT)
Received: from localhost ([122.172.85.168])
        by smtp.gmail.com with ESMTPSA id p14-20020a62ab0e000000b0062505afff9fsm23773417pff.126.2023.03.29.21.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 21:00:32 -0700 (PDT)
Date:   Thu, 30 Mar 2023 09:30:30 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Bjorn Andersson <quic_bjorande@quicinc.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Xuewen Yan <xuewen.yan@unisoc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpufreq: qcom-cpufreq-hw: Revert adding cpufreq qos
Message-ID: <20230330040030.bal3eqrq22xluxca@vireshk-i7>
References: <20230323223343.587210-1-quic_bjorande@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323223343.587210-1-quic_bjorande@quicinc.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-03-23, 15:33, Bjorn Andersson wrote:
> The OSM/EPSS hardware controls the frequency of each CPU cluster based
> on requests from the OS and various throttling events in the system.
> While throttling is in effect the related dcvs interrupt will be kept
> high. The purpose of the code handling this interrupt is to
> continuously report the thermal pressure based on the throttled
> frequency.
> 
> The reasoning for adding QoS control to this mechanism is not entirely
> clear, but the introduction of commit 'c4c0efb06f17 ("cpufreq:
> qcom-cpufreq-hw: Add cpufreq qos for LMh")' causes the
> scaling_max_frequncy to be set to the throttled frequency. On the next
> iteration of polling, the throttled frequency is above or equal to the
> newly requested frequency, so the polling is stopped.
> 
> With cpufreq limiting the max frequency, the hardware no longer report a
> throttling state and no further updates to thermal pressure or qos
> state are made.
> 
> The result of this is that scaling_max_frequency can only go down, and
> the system becomes slower and slower every time a thermal throttling
> event is reported by the hardware.
> 
> Even if the logic could be improved, there is no reason for software to
> limit the max freqency in response to the hardware limiting the max
> frequency. At best software will follow the reported hardware state, but
> typically it will cause slower backoff of the throttling.
> 
> This reverts commit c4c0efb06f17fa4a37ad99e7752b18a5405c76dc.
> 
> Fixes: c4c0efb06f17 ("cpufreq: qcom-cpufreq-hw: Add cpufreq qos for LMh")
> Cc: stable@vger.kernel.org
> Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
> ---
>  drivers/cpufreq/qcom-cpufreq-hw.c | 14 --------------
>  1 file changed, 14 deletions(-)

Applied. Thanks.

-- 
viresh

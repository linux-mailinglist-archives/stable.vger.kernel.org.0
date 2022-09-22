Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0865E6C36
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 21:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiIVTzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 15:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiIVTy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 15:54:58 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F6450738
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 12:54:54 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a3so16408493lfk.9
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 12:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=lgBFTMVMXCZBAFp0oMr/KQtqKqlUry12+72uOs2o5A0=;
        b=gSuteSplG8PxA49wHgjUw1l+i4kCCFrGl4lWahQKdlgu+JZaE4fiOWlEQzX7g4xqgy
         wrtBDvfRLRV8AweCZ6WU3wvh+jHN+g/sFqlQWZCi6KqGKKE2rrGWTqIdzeTXBpG8fTj3
         khnOpoLjT0PTdn98YaEk6J1EVqLuA7AwZ0TTzqOSLTRzgJZFaUWo4FRqMY1Rn/zOB2Yl
         jF2IGGbDkpjLMYyp6it3c9Vcct8liYd78+UVr+5cXt9bYkBCobdPOwpWxAL1s5VxhGnJ
         cixDkto0Rm1H3pmavVasqrRLFbpiYOCBL2zhCZHtcKMuM+ntXZq/51jD4I73Jkv9MUw1
         SiUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=lgBFTMVMXCZBAFp0oMr/KQtqKqlUry12+72uOs2o5A0=;
        b=NAgPKyB+Dzy4XjJOceCLeKtiq0cNAoc8uKs//HdwlXLPfcToFxhb4UIW2uUpDCvMAM
         6EAuSOPCT2HSOCzeHtivw0+DfC1WNORZn39DMdXXiDkx7gPIu1aNKB0EgN2B7sjQZQhF
         MXVeWa17EuzJTrS+h+KPf0SYHcbuXgzKGb1Wda6C4mWzVl+SM9YDRi1aktIH0BJl+EUt
         YaZUohZroXW7FS4bwwQPNf9kKQRO8UDELpZfZvQDc03xe0DsoMda6gQC8e5EfPkVyrJE
         3IK9b+wyXKhY8714tMta1ux2aDvcl1+8L1ScN9ayGjGcT7/RkUXTbkwJkvSeXajRCT2v
         egYQ==
X-Gm-Message-State: ACrzQf1dTI/Tf1gQDI8WkX6WCJR5mhf45IO2ophrgTOt0t9MVlJyk1rw
        7WJHAu1UELu6aXqIzBp3QpRhDw==
X-Google-Smtp-Source: AMsMyM5x3xQZZsL6AGUzGPXrbBo4Ibfz8nqXqjAm+Dm7MKd8knG6P7UyBb3rGXUpNlKV3qXe4/G2Dw==
X-Received: by 2002:a19:f716:0:b0:498:aa7f:32f7 with SMTP id z22-20020a19f716000000b00498aa7f32f7mr1984433lfe.3.1663876492136;
        Thu, 22 Sep 2022 12:54:52 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z13-20020a056512370d00b00497a3e2a191sm1083605lfr.112.2022.09.22.12.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 12:54:51 -0700 (PDT)
Message-ID: <8964f7c1-817d-fbd0-69c2-329a442ae5e7@linaro.org>
Date:   Thu, 22 Sep 2022 22:54:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 04/10] drm/msm/hdmi: fix memory corruption with too
 many bridges
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Steev Klimaszewski <steev@kali.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220913085320.8577-1-johan+linaro@kernel.org>
 <20220913085320.8577-5-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220913085320.8577-5-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/09/2022 11:53, Johan Hovold wrote:
> Add the missing sanity check on the bridge counter to avoid corrupting
> data beyond the fixed-sized bridge array in case there are ever more
> than eight bridges.
> 
> Fixes: a3376e3ec81c ("drm/msm: convert to drm_bridge")
> Cc: stable@vger.kernel.org	# 3.12
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>   drivers/gpu/drm/msm/hdmi/hdmi.c | 5 +++++
>   1 file changed, 5 insertions(+)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry


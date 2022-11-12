Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2909E626755
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 07:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiKLGL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Nov 2022 01:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbiKLGL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Nov 2022 01:11:56 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE15F26570
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 22:11:54 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t10so6745432ljj.0
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 22:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3ejbUlFun9OEgk/KT8vHWfd5C3xhdILnxWcphsdzjE=;
        b=CdeddQVF1TO9jEQYCpMwrZcdEGwrnTwcDH2RMAAXZKXtvijrn2fLc6JiCwQ1W8qzVO
         DMbPBg3GqqvxSzr7Rz5s2oI8OmSJ8RqJvRKEdtNETbxquW8F0YP3AthAPMLnYCirGcX5
         d72ejQSJ9WJG95SyN05164TZ9AqtEeeZVzcmPszY94diOxvooVFRFMsp1bxSQqTFFE2b
         gaVWmrjCNDOhBZFOcSbMwKTz7HYIFNg8HosXowWSF9BPRJaJIQ9Logt9jr/ISXhxBq8x
         l4oiqMrDXnk5bMaEkiZbit3G3JaWbDWLkJoOL9hoMoYQRr8YJN9WA9ZqtUzIoaTCUnNe
         AtxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3ejbUlFun9OEgk/KT8vHWfd5C3xhdILnxWcphsdzjE=;
        b=3nhNnx6OiSnkWltWjc5W/3OQJ4FzknUFrghUPKwJAZKoWjPkLVDVRqesMJDvE1haNa
         kMcC3R9suz19/A5W83tWXssCc2KmB1fyXZH+4Dg/G7quFcb74k71Ma5zkQNCzfw78VWd
         DJbpFkKEZ86F94M/St0wOiAJxlgGWMB8b3s8ARHUOkH2Ckj707HoIXS8z+erbzKjR5Tb
         wrZcm7EK+hCa4bDE02rgooa809zpZFAvCyRvFRdMV97y8sfX54/yXzJzqnunV2rbOaP2
         KRN6cKf/qbiCdiPE09TmEd4HjkMj17QnBuvhGAyiZTrfKw5dbTqpJckE8Gf7KEkynvIg
         g3KA==
X-Gm-Message-State: ANoB5pkheK+kRPVOnqlb42jCRPLO53gQzYC9A0QOo2BQsIkCu1PDyoxi
        GxmQr8VDyUl95Ba03uUBzdteiw==
X-Google-Smtp-Source: AA0mqf6XAXIkgfNs1O58usH4KLMuIJnBykFNQGvvGHPaohPzz/O/3cpZ5coGzCG+NB5SBy5Yb0s5Xg==
X-Received: by 2002:a2e:b117:0:b0:277:96a:5c32 with SMTP id p23-20020a2eb117000000b00277096a5c32mr1449233ljl.415.1668233513135;
        Fri, 11 Nov 2022 22:11:53 -0800 (PST)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id m18-20020a194352000000b0049d3614463dsm705066lfj.77.2022.11.11.22.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 22:11:52 -0800 (PST)
Message-ID: <b9951e2f-b958-ec4c-331d-dd50ffc6d31e@linaro.org>
Date:   Sat, 12 Nov 2022 09:11:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 2/6] phy: qcom-qmp-combo: fix sdm845 reset
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221111084255.8963-1-johan+linaro@kernel.org>
 <20221111084255.8963-3-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20221111084255.8963-3-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/2022 11:42, Johan Hovold wrote:
> The SDM845 has two resets but the DP configuration erroneously described
> only one.
> 
> In case the DP part of the PHY is initialised before the USB part (e.g.
> depending on probe order), then only the first reset would be asserted.
> 
> Add a dedicated configuration for SDM845 rather than reuse the
> incompatible SC7180 configuration.
> 
> Fixes: d88497fb6bbd ("phy: qualcomm: phy-qcom-qmp: add support for combo USB3+DP phy on SDM845")
> Cc: stable@vger.kernel.org	# 6.1
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 39 ++++++++++++++++++++++-
>   1 file changed, 38 insertions(+), 1 deletion(-)

-- 
With best wishes
Dmitry


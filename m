Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A2B6CBFC0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjC1Mu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjC1Muh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:50:37 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4916DA247
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:50:08 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y15so15667503lfa.7
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680007805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5aKpkNh/8xXK99VFZwk3PtzVkWaagAJQbPThES4qo4c=;
        b=aDlmW+3M03gsIwxLOi7jI/MjPJRefPCoqxUEHPPvw+Bj6hdtAn6oDZjDN4Rv9QfIuC
         HrMnmJmHdBVQ3USLkYxXH0RuoKAG9ewagvA2THN+WbuR/5mX/jEU+tcn0olCh5S4uT50
         tmNyYhRqrGSNSo5hStO/WvtMuLcLgPDRaeha5V1cFolm5PPvScWNyGjswToTRzW/cyA3
         cbQQDUdQC8CBNzoexTWDqhVv+Rpi7y/kbhgoPRKUzvdYxEtd2ct2NyyAorAbKIRLvl40
         jFYNJpdKqfUaItIyX42pH0+BZnvGOrjgENJIPCZDYlJ3XdZliIE5tT/2tAeBav/H9C6E
         f6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680007805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aKpkNh/8xXK99VFZwk3PtzVkWaagAJQbPThES4qo4c=;
        b=i4cC93zjXp615RC87San5nGschvTO1yQdkU/kDte6UKSBgZr4MYEnkvJKP/FfYryPd
         5nmQBzissZYLE7v3/vkKE+jRTEro7FaJBtCeVLbbRye4nzEJ6Nqn+yra/ipdKeRSpF4J
         e5GDwl8UvaxPJr/liDcTDkcODj/VMS7cykcMrAANi6CoWYurl4a3TT64M9eIVEN/4eZj
         4BdoB99W1BL/ZaDGl0tI03X/ytwcUvXVuaRq5UeGIDwFltPK8bPA2abg70xpU+PYBC/S
         poZbYDFf6JdP3f3Ng9vxHTEEOm8vG2g47o1kRtrRGUCO5MoR1lTTEQFNTg9E2jEhGZ3L
         q/8A==
X-Gm-Message-State: AAQBX9eAHk6uy6dpstL1kI1+YOoL1UQYVhUIJgNdhydObgxZsSBljHDx
        UewEp1zHeQl8xqHcfXGqNX0VxQ==
X-Google-Smtp-Source: AKy350YB19ZNZUdZmlZrfVEq4gizIOk+KuH+83cH+JiVYmIQT1UXUtff0FtR/clzr94IT76z/SEGBQ==
X-Received: by 2002:ac2:531b:0:b0:4e1:8309:1db5 with SMTP id c27-20020ac2531b000000b004e183091db5mr4650842lfh.2.1680007805502;
        Tue, 28 Mar 2023 05:50:05 -0700 (PDT)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id e18-20020a056512091200b004cb08757441sm5031213lft.199.2023.03.28.05.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 05:50:05 -0700 (PDT)
Message-ID: <f1a7f057-0b96-473d-d5fd-5fc2d1352642@linaro.org>
Date:   Tue, 28 Mar 2023 15:50:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 07/10] drm/msm: fix missing wq allocation error handling
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc:     Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230306100722.28485-1-johan+linaro@kernel.org>
 <20230306100722.28485-8-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230306100722.28485-8-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/03/2023 12:07, Johan Hovold wrote:
> Add the missing sanity check to handle workqueue allocation failures.
> 
> Fixes: c8afe684c95c ("drm/msm: basic KMS driver for snapdragon")
> Cc: stable@vger.kernel.org      # 3.12
> Cc: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>   drivers/gpu/drm/msm/msm_drv.c | 4 ++++
>   1 file changed, 4 insertions(+)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry


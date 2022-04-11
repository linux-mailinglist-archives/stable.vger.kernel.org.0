Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6304FB135
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 02:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiDKA6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 20:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbiDKA6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 20:58:46 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFC31CB2E
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 17:56:33 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id bu29so24043044lfb.0
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 17:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9nnU/hlsgDy+lppU4ToxpqXZCXzo/JN9tONmD8z7t0M=;
        b=s+acL3GufGKRuADS3DU+Tl535oN0NiRYHOaSbwAGp1nnqf4i2AelYYSwf2pC0rcdQo
         CetSVGmAhbEgKZAjlpABCeudEqT6qApYSA2mgKmkWtQgBNLag2Z+Y0014IxV42g8J6TS
         KQm0uUNjx/+IW74QYTlE1lnhuoGVi4f//EXt65PPRH0phWmuy2xpf7PF5VsvRcHV9dHv
         SZj3130pFZZF8vy97v1FWFW2BoSCbHr3WH+L6m0IBPc7I0sq19w79edI8xd+M8lHbwI3
         9aVMwMV/4QWr5k8UZmZbGHEvu6MiFwG7xyiBgiW6aFZY44XLnmZtk8U2DdNHDzLWjg7U
         d/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9nnU/hlsgDy+lppU4ToxpqXZCXzo/JN9tONmD8z7t0M=;
        b=hgWr28/3VD6RVsWCYFp4blpkrQrGRkl7Qe1CZc/ZidLQeAypVL011Qe/qZOgXgj63e
         62pIzd5/kOuuD01V09sMYrbKMjoSS+aVN4HDfO2B7DypjuG4Hv/p1O+U2xtMVGhX16ln
         f1O3yFZ+E2dv+7ML1eJINXZ5/wjJ8WwbgVOAkCp8yhgebe/GKGZsJtVqYYEvVMbql2wg
         jWsXeYFWzukEQUpzvnuNKhJRth5nDFJuCoh73VMq01rWW83x+ib6ewQ0yjIEUPQBLbwQ
         L2H9lOPKt/zzuzSVO1MOez8NIS5FXNF0oQCVV/kEZ2wJe0d27lW069mPQSM4JnkHPZpZ
         dbWQ==
X-Gm-Message-State: AOAM532/zro610oYf5JZvoEMquqdpR0NVv95TyjgT/jSPXC1Vw5+hqpw
        GnM9JLVjVJNZpuBWrXsQrKEUxg==
X-Google-Smtp-Source: ABdhPJygHoGGMiS/MT7i5dOZ69wDIbP52cTh/NAz+MNb4CGrKLMnej89s7ZZh3bJGQAToKEYaASHdQ==
X-Received: by 2002:a05:6512:3050:b0:44b:111:be72 with SMTP id b16-20020a056512305000b0044b0111be72mr19981248lfb.138.1649638592169;
        Sun, 10 Apr 2022 17:56:32 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id j29-20020a056512029d00b0046ba6e0cc32sm125926lfp.300.2022.04.10.17.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 17:56:31 -0700 (PDT)
Message-ID: <0788b245-ee8f-25de-dde3-7ff10f6c688c@linaro.org>
Date:   Mon, 11 Apr 2022 03:56:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dpu1: dpu_encoder: fix a missing check on list iterator
Content-Language: en-GB
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch
Cc:     quic_abhinavk@quicinc.com, swboyd@chromium.org,
        bjorn.andersson@linaro.org, quic_khsieh@quicinc.com,
        quic_kalyant@quicinc.com, markyacoub@google.com,
        jsanka@codeaurora.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220327073252.10871-1-xiam0nd.tong@gmail.com>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220327073252.10871-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/03/2022 10:32, Xiaomeng Tong wrote:
> The bug is here:
> 	 cstate = to_dpu_crtc_state(drm_crtc->state);
> 
> For the drm_for_each_crtc(), just like list_for_each_entry(),
> the list iterator 'drm_crtc' will point to a bogus position
> containing HEAD if the list is empty or no element is found.
> This case must be checked before any use of the iterator,
> otherwise it will lead to a invalid memory access.
> 
> To fix this bug, use a new variable 'iter' as the list iterator,
> while use the origin variable 'drm_crtc' as a dedicated pointer
> to point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: b107603b4ad0f ("drm/msm/dpu: map mixer/ctl hw blocks in encoder modeset")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
> index 1e648db439f9..d3fdb18e96f9 100644
> --- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
> +++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
> @@ -965,7 +965,7 @@ static void dpu_encoder_virt_mode_set(struct drm_encoder *drm_enc,
>   	struct dpu_kms *dpu_kms;
>   	struct list_head *connector_list;
>   	struct drm_connector *conn = NULL, *conn_iter;
> -	struct drm_crtc *drm_crtc;
> +	struct drm_crtc *drm_crtc = NULL, *iter;
>   	struct dpu_crtc_state *cstate;
>   	struct dpu_global_state *global_state;
>   	struct dpu_hw_blk *hw_pp[MAX_CHANNELS_PER_ENC];
> @@ -1007,9 +1007,14 @@ static void dpu_encoder_virt_mode_set(struct drm_encoder *drm_enc,
>   		return;
>   	}
>   
> -	drm_for_each_crtc(drm_crtc, drm_enc->dev)
> -		if (drm_crtc->state->encoder_mask & drm_encoder_mask(drm_enc))
> +	drm_for_each_crtc(iter, drm_enc->dev)
> +		if (iter->state->encoder_mask & drm_encoder_mask(drm_enc)) {
> +			drm_crtc = iter;
>   			break;
> +		}
> +
> +	if (!drm_crtc)
> +		return;
>   
>   	/* Query resource that have been reserved in atomic check step. */
>   	num_pp = dpu_rm_get_assigned_resources(&dpu_kms->rm, global_state,


-- 
With best wishes
Dmitry

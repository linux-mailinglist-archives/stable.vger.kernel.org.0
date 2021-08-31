Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B13FC061
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 03:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbhHaBOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 21:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239185AbhHaBOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 21:14:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D5CC06175F
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 18:13:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id x2-20020a1c7c02000000b002e6f1f69a1eso689069wmc.5
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 18:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gwwwp57SwTctaxgmYl1l1IkxPrnIEbuUNvTFbHbB9zc=;
        b=vMd0I0p2hOKKFZxYUoERF54PuuNoTJUde3qs+Pa3YDYFNp6k5M2NnQDvqLn0KcHOjs
         o+8KMezp6dCJWTFlx3VPrLlpVpNOq3d/9jcDXIC1B7B3TTMczZBYwVqpPY826FozQ4eH
         bqVK9eFMoDWQDtoeFU12wCApsE34Hk98JedRcaCRq3j2gECbkAea9T3MK1BvrrOd1q7e
         zNBTwAETKHs5yzuEvpSOcbw1NqT72KNpuRWcdd2gO+tyqeSJvegNp2w7UO5sd0yHXp4o
         if3YzkvKngaC4C1iUZUH4/DjDaK+wQQUUoIzXQTpU8iCmL2U2Zv9ayvxzsQP15wCC1Jb
         +wmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gwwwp57SwTctaxgmYl1l1IkxPrnIEbuUNvTFbHbB9zc=;
        b=ST0R70R7XshQ67YJ3OKXKPLbSAPew8mnODyzxifdNgKuegICPyGvNC1utDHfcJIIs6
         hEep1djbxtjEG9qeTBymt78cYy8F1Nrfe8k9z9WO1lQAYsNThVIR5bSR9GESmhhCokBC
         qdJ6s/G0W9Bk50Jqh0BMmsO13jbRcJCEbNzklRXHp3GWmb8pw5k2Z6w5ggvH80GgCWHp
         YUm1Aw+jsaxzugLGZKj5C9yvt4/aRI17H7quzbkyhu5dkO3GzHEXztlpKqZELm88sbps
         foajD9U5H8qVTv7YcWmDHed8nroJHe+tIcSsPG4hlfNiClGe/gwaReZJg6xeGhO+syH0
         RNXA==
X-Gm-Message-State: AOAM532dE/VK6+VpKjswsLhBgPey3gAwiz68CRavRfJni6aFcZ5fy/4j
        R20GjPFivwKe/vYoHQFU6lYTU8xjlIVrnE26
X-Google-Smtp-Source: ABdhPJxXav9cQB1UonIcAAQZNeVtr+uDjJsNuLpeUs+J0NLE0isqWdOGNYRrnoaj4TmwxJ0e2uKdMQ==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr1495166wml.70.1630372416053;
        Mon, 30 Aug 2021 18:13:36 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id c14sm976066wme.6.2021.08.30.18.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 18:13:34 -0700 (PDT)
Subject: Re: [PATCH] Revert "wcn36xx: Enable firmware link monitoring"
To:     Loic Poulain <loic.poulain@linaro.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
References: <1630343360-5942-1-git-send-email-loic.poulain@linaro.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <401fd67a-4965-d4ae-8b6c-8c81a179a8c7@linaro.org>
Date:   Tue, 31 Aug 2021 02:15:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1630343360-5942-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/08/2021 18:09, Loic Poulain wrote:
> This reverts commit 8def9ec46a5fafc0abcf34489a9e8a787bca984d.
> 
> The firmware keep-alive does not cause any event in case of error
> such as non acked. It's just a basic keep alive to prevent the AP
> to kick-off the station due to inactivity. So let mac80211 submit
> its own monitoring packet (probe/null) and disconnect on timeout.
> 
> Note: We want to keep firmware keep alive to prevent kick-off
> when host is in suspend-to-mem (no mac80211 monitor packet).
> Ideally fw keep alive should be enabled in suspend path and disabled
> in resume path to prevent having both firmware and mac80211 submitting
> periodic null packets.
> 
> This fixes non detected AP leaving issues in active mode (nothing
> monitors beacon or connection).
> 
> Cc: stable@vger.kernel.org
> Fixes: 8def9ec46a5f ("wcn36xx: Enable firmware link monitoring")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>   drivers/net/wireless/ath/wcn36xx/main.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index 216bc34..128d25d 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1362,7 +1362,6 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
>   	ieee80211_hw_set(wcn->hw, HAS_RATE_CONTROL);
>   	ieee80211_hw_set(wcn->hw, SINGLE_SCAN_ON_ALL_BANDS);
>   	ieee80211_hw_set(wcn->hw, REPORTS_TX_ACK_STATUS);
> -	ieee80211_hw_set(wcn->hw, CONNECTION_MONITOR);
>   
>   	wcn->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
>   		BIT(NL80211_IFTYPE_AP) |
> 

But why is BSS heartbeat offload not running, it should be.

I agree we should switch this bit off for now since its obviously not 
working as intended.

But we need to root cause _why_

In suspend absent a working heartbeat monitor - if the AP goes away we 
stay in suspend indefinitely.

Given we don't have roam offload enabled either, in this reference, it 
also means we won't roam to a new AP until Linux resumes, which is 
certainly not the way we want this to work.

In any case, for now until we solve this bug

Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>



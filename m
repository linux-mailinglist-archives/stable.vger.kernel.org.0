Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C673C403BC6
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349482AbhIHOwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349384AbhIHOwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 10:52:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED963C061757
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 07:51:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i28so3753860wrb.2
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 07:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iCptGHIr4yOo9jmgBHruQRL65b7qc9ZYb50YuwH+tDI=;
        b=jaYJJWAqBXG23YiUD930ob6F8/DuGdPuUryLdHZWjTtwrQB7ykp2ec9oBDewIZJdpD
         AWVU72gt0OimQfsE1UBR+a1GeJswp0TsyxJJWr6S3N2hdHR9O32b/zf+aBadO8FCqFq6
         Lh88fw9klAslfPnO6t6Ertr0I2Kqp/WQ5ye1CizXy6s/hnfnUqPEj+70/AP8rgfy85W3
         aOCr1FXVBilsLH7fASi55LFicBMtADm/DPaWF8eS/rJJd4nKpdjxRF2FIbBOquqWwHDD
         O3iLFWS4RvYXQKxZBrjzhvWY8ZLN6b12Vg1G4Sya1SgwYeH8P4erXTw8v/kaxmkvgTAV
         3LtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCptGHIr4yOo9jmgBHruQRL65b7qc9ZYb50YuwH+tDI=;
        b=sR8cJDyquJroIpb/+woIH3vhEoixAcydtmonYlwypezDK8k3M4wOuKEeP8Psbkk74q
         1bkRXQSEG1yW8nAek5ESlBnzoVA/4fQk+bLhN4D5ldNqhAQDsDyEy9tBfX2zA/ZWd2Bz
         JgkDa8/81ZvuGYr2D5SkLZM/UBlFbwPPnbPO3X/LjcRMbssp+sbgjBzQuRbmIwFdLh+n
         468Tz07ayy4BkC0OHH8xyg16V+Zq/Zy0HAbYpwtIKppxAmUndtFjRYNrVonz9uzLSrcL
         3PuiIaW0hKJIbaG65/bDbPcVb8/XLhyhPR7G/A3m+YH1ZDqTVTkQIMJ2hc0SfmnoD4lJ
         /b8g==
X-Gm-Message-State: AOAM530hk1CZyLZHyahX34jnqPUHQg0G3fVy89Fj7Gw6Saz+wmzOpz2o
        nU+wRPFw6cVkgt81yiCi1Ese1zOpKzMlyg==
X-Google-Smtp-Source: ABdhPJznVODf0WQvmu3E/ocU5tfbFXjh8UnQofVXfrtPNLqJdAhATIUIepHIfNwMTD91144P0lWTxQ==
X-Received: by 2002:adf:cd07:: with SMTP id w7mr3633438wrm.232.1631112672182;
        Wed, 08 Sep 2021 07:51:12 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id s205sm2367229wme.4.2021.09.08.07.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 07:51:11 -0700 (PDT)
Subject: Re: [PATCH] Revert "wcn36xx: Enable firmware link monitoring"
To:     Loic Poulain <loic.poulain@linaro.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
References: <1630343360-5942-1-git-send-email-loic.poulain@linaro.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <266e31ea-ec74-1ab7-e5ac-4eafc7db0983@linaro.org>
Date:   Wed, 8 Sep 2021 15:53:07 +0100
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

OK.

We've made a good effort to resolve offloaded link monitoring but, it 
feels like spaghetti code and isn't as reliable as letting Linux do the 
link monitoring.

Let's go ahead with the reversion.

Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

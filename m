Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E863FD009
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 01:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbhHaXu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 19:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbhHaXu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 19:50:28 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B19C061760
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 16:49:32 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o39-20020a05600c512700b002e74638b567so667805wms.2
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 16:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TgKOSSdJ82R57LtpOBvtLOSFqLJv1lNqhXrrq1hzCT8=;
        b=SyPCIRMtoxXfrQ3EemvBm8q/kN1MhwnuRV1Wzt01L8GkkfFWjqTZv6qOBaM7DvakTr
         K6aCPIX9RGduXoqq2DoGhmuW/bo7IVWSpyyWB1Qmd3aMOVDqkqJDbyCmvRjkpInzLrHm
         xit8P8+gBnfpBbM0E4jCHlVxJgE3/tZF81RcMlTCvxIeIZhCD3SVp06ZsqXqjTrE0zW1
         zlKPpkDS12r0u0g2MQ7/JbXrgf6xleE9z58vxjFjX26UQkpDwqZ1zv1gi7iEVqphVzml
         gg/QHy3/ohCesfDYvgrC1vO/BsLhEWqNe4Wo1XzCdphQ7lmrUcc3c+N2VBpiWekBHgPo
         2ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TgKOSSdJ82R57LtpOBvtLOSFqLJv1lNqhXrrq1hzCT8=;
        b=fxF44ypIxj8i8AKOljnSkiFoY6sfhOr8oKxgPawXpnB3D4HKaKCi0ipXTpzvx2OsB6
         noG6sBaqSCDqjlPsd8+alCh3ZcZg03muQZAyz+UM4Ey5ruo7TIqMH4sFGVhnk1XVQh6Y
         Uzr8C71a84x7G07ZcGgJMk2mlD16mx+GfXKklqu4+2kIzBj97idmU0yanzsBVgHCe+JO
         iubbKtqIVwpBXsVv+ivptYsdtK0SdQUwxf1xJ13ax1J9hKh2Y4ZzBf5OjGCWZB5mLWej
         oJPcuNRaTWaVe8D/flXa4TBvgp4/M9t4vZUynrs2wT9/spObHNaIC+tIMFERjU3TpUBR
         DIgw==
X-Gm-Message-State: AOAM5307gcMMoRr76mJk0ePt75wIzCvQSWy4qFmOlR/ZuxbSZYmQx0mn
        SdDeJMoBIvwcNOZHQBMFketL0rVPwWLuJ9jW
X-Google-Smtp-Source: ABdhPJxtU2+0Bq+Teq3S1UvKLvRQE/0V011U6swrYAAvpji1jZjMsrY3Lwo9czDm/5e0+tepYG0Wwg==
X-Received: by 2002:a1c:f30b:: with SMTP id q11mr6631423wmq.91.1630453771305;
        Tue, 31 Aug 2021 16:49:31 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id g76sm3667767wme.16.2021.08.31.16.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 16:49:30 -0700 (PDT)
Subject: Re: [PATCH] Revert "wcn36xx: Enable firmware link monitoring"
To:     Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Li <benl@squareup.com>
References: <1630343360-5942-1-git-send-email-loic.poulain@linaro.org>
 <878s0i3yfq.fsf@codeaurora.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <40edf308-d12c-2116-0e5f-22cab413ea71@linaro.org>
Date:   Wed, 1 Sep 2021 00:51:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <878s0i3yfq.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/08/2021 07:44, Kalle Valo wrote:
> Loic Poulain <loic.poulain@linaro.org> writes:
> 
>> This reverts commit wcn->hw, CONNECTION_MONITOR.
>>
>> The firmware keep-alive does not cause any event in case of error
>> such as non acked. It's just a basic keep alive to prevent the AP
>> to kick-off the station due to inactivity. So let mac80211 submit
>> its own monitoring packet (probe/null) and disconnect on timeout.
>>
>> Note: We want to keep firmware keep alive to prevent kick-off
>> when host is in suspend-to-mem (no mac80211 monitor packet).
>> Ideally fw keep alive should be enabled in suspend path and disabled
>> in resume path to prevent having both firmware and mac80211 submitting
>> periodic null packets.
>>
>> This fixes non detected AP leaving issues in active mode (nothing
>> monitors beacon or connection).
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 8def9ec46a5f ("wcn36xx: Enable firmware link monitoring")
>> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> I'll queue this to v5.15.
> 

Might want to hold off on that.

Its been reported by testing that wcn36xx_smd_delete_sta_context_ind() 
actually _is_ firing.

But if you look at wcn36xx_smd_delete_sta_context_ind() it doesn't seem 
to do ieee80211_connection_loss() like it presumably should.

I think the right fix here might be to call ieee80211_connection_loss() 
in wcn36xx_smd_delete_sta_context_ind() if (wcn->hw & CONNECTION_MONITOR)

---
bod

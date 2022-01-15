Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281BA48F37A
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 01:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiAOA0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 19:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiAOA0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 19:26:23 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11664C06161C
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:26:23 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id h23so14262924iol.11
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nnn6TgbEatXba1qMqMpIFTzJjUEOM6DXsCEXS6nFHmE=;
        b=FxVnvey7Eet1ab80FcuPZfwDVxn5H2v0ZIRgLD9ZXul3iVXfZwPY5wgQdnIwv2jAqG
         igxt+ClWx1l1WITfulHYOxxaX6FBBsxKb0gyoSAnmvqZAMdWpycW78KfQ5u1oUE73ptF
         lCwJnuFSkSZpzpIQ0rdUebdau4tf4DW1fTouw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nnn6TgbEatXba1qMqMpIFTzJjUEOM6DXsCEXS6nFHmE=;
        b=ZJ5ltzR1xnD+PVSwLM7L0EtSmtbJ8F9hf1afnT1lO4nHgguGXdJ5FrNTEulSojt+97
         DQGh8bi5AHqiZZ6muCwX+dSl2vBV20CyKKV/PQkNb7pHTW0JTBlBI/mZh8uCm6ZF2n4S
         BFwRHYJFmityMZt73mSGOaM8adJePd6OXtVsvO5ZROmBHUpyUodS0HI37daCiGhZkTvy
         gu6a/1SXhCDyVO4RtxT0VKwZpLi0icUPDCxatng/jvOAcYga/9KYwRuGhTeHnpLaOQIS
         hNBzxeDyekZ9C3pVz2TVv/r5plNZjivguspiegRvWiIIP95so7hykAesyhdCBFAS1Qcg
         zfZA==
X-Gm-Message-State: AOAM530D1QNXhGbLxHDW3ZS78MXPhCCu3Ts+F87/L6dB06MnKQbBrdRS
        P81c60+aZoWUdKDd/yFIXJ+b5Q==
X-Google-Smtp-Source: ABdhPJy2rTnL8+f85ezuzw8CkOTq2U6mFOjYthQYNn28RrDW0EVAxKzGQXezmSDceB0QPn0vK3Oewg==
X-Received: by 2002:a02:9508:: with SMTP id y8mr2922570jah.295.1642206382413;
        Fri, 14 Jan 2022 16:26:22 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a7sm4670869ioo.5.2022.01.14.16.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 16:26:22 -0800 (PST)
Subject: Re: [PATCH 5.4 00/18] 5.4.172-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f33d717e-9fdc-76bd-f3fe-144e29e1e62a@linuxfoundation.org>
Date:   Fri, 14 Jan 2022 17:26:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 1:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.172 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.172-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah


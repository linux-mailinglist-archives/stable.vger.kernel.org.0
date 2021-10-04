Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE34217E2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhJDTtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbhJDTtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 15:49:03 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F04C061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 12:47:12 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so23060822ota.6
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 12:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sq3OEOBQ9Aa9wq4P9SuI1xrzqA0OykM/3/KU5+ESv0o=;
        b=hhaJ5Quq/ycTKhxcWatDKR40BZG5tQAofuTxmiBxPWww+jA2RAD9O3ZXPvktVkJBMq
         Ye5UtJdQnstfuOFUWSBbWk84kKHOrYpgmYoTRJ+iAIw1YiyQQSjGwLop0gtg19N1neH+
         A3WUJ3ffyQc+Opa/vdwv1YGh6MQMiHzYIbh6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sq3OEOBQ9Aa9wq4P9SuI1xrzqA0OykM/3/KU5+ESv0o=;
        b=XCnysVinaUt8TMIw0kttQckl5sopL73Ht9qa31PJxX5HLAX3JTTbbtQYmgWsYFxWSP
         N3guCF/3PylcBQTUwPCD3RkyP9RRB74pBNTx/axBPyRkYrcYFmgf+Q+95n5ai2/rqbha
         0nmQ/s2/JsAd3JFxf0XUSWPEQL0ZYaiuapSat4/jPdOkniH6GprNqpNcQ1StU5VXMlaL
         57yWTVRRgFRjN9tRht1GxPq6s5FUWutlQKEhJxMv+PCZZeAfPlmzJUMSuEzb6qWHXHEy
         YtZsbsIQ84q0P3DB5nK8S6+J5mDHvO8heBh8Pr7Yej1y6XX7J6453ovZnQnSuUSOCOE4
         E7xw==
X-Gm-Message-State: AOAM533B5ZpHokBm6bVXI/jCEcuUUcQOgtLu0kpnUTG+ujOwnld6VQV2
        DqLgS1N9+9cMfY21pbDv8HVlMg==
X-Google-Smtp-Source: ABdhPJzM3xbMrgAoZwoiekNKn4UmQbKx5w7v2Lh75MBJIVsDkdByBC1pq03Ed8WipGxAQWd71HZO4Q==
X-Received: by 2002:a9d:71c5:: with SMTP id z5mr3978981otj.375.1633376832237;
        Mon, 04 Oct 2021 12:47:12 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q20sm3016056ooc.29.2021.10.04.12.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 12:47:11 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/56] 5.4.151-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3ef62560-6e9f-d2a6-6221-c12d1dd15bda@linuxfoundation.org>
Date:   Mon, 4 Oct 2021 13:47:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 6:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.151-rc1.gz
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

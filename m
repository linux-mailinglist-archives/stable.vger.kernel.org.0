Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171B1442292
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhKAVZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhKAVZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:25:28 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1EEC061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:22:55 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i12so13687857ila.12
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5UczJ5cPsBUNmZ39JdlZ2zCexG7vaUHD9ua6j59cLvc=;
        b=ZtpivkdUt8cjVtM/ZF7fES9VUvnooqFI9yu8ZVfhhSWIxXtPlwgDSKSel+vpYvKXjb
         WDFvWG7w2suH1JrdZGVCnkao3ks0jg9Tm0Xblmcj7eTSNt7erma5ceeQhAnlvIs/tTOJ
         9NUmG9U3IP+3bv9Jt6d1IrhYnKol7mViDWBQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5UczJ5cPsBUNmZ39JdlZ2zCexG7vaUHD9ua6j59cLvc=;
        b=erJbm34EKmyP1o5LMBD3PMTpiFu9tkaF2xfiavPPVJWYVkNoGYw+RO38YE+doujwPf
         QIu/zqp6IZ2QsP+h6XioqVocJNt/4mqVg6hXg1kRwSXykj5hy2UGFUrKmW1g7bqpTOJA
         9OcSvY1ejNeA2x1ZuaLW0HlJTQh2ukk2Q6LGSpGE45Ak0zUgDNQLP4L7x79fy4XgVTfN
         IzHqKXkRSMlf3t06cAqX+UwfqsR6puPpBdzdGJXJ2MxGMFI/8kVVp+Wl6y9HkLgj+YaX
         8lScaxmJGFGFeltGLKYzKZxFk63sBBwpY7jJiSRHisZq3BpTU7Bq+z6exo3suddfng2R
         HhsQ==
X-Gm-Message-State: AOAM530OmK816kIK+J6sBzezxOYQczs8fMPNDxo1e2GdPeAkQB8d8mrf
        tChaMg3CIxUwTCbOwPCdZowcBA==
X-Google-Smtp-Source: ABdhPJzyyZCOzWhG9y+2/XfJtDw+u39R9nMwUwdwxKQWEhU9COy19cum3Cdycw0ydNxZIjpQFVLt9w==
X-Received: by 2002:a05:6e02:1bed:: with SMTP id y13mr3215202ilv.279.1635801774440;
        Mon, 01 Nov 2021 14:22:54 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a20sm8689527ila.22.2021.11.01.14.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:22:54 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/20] 4.9.289-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d274a5f9-3077-11e9-8b76-5ba118f32085@linuxfoundation.org>
Date:   Mon, 1 Nov 2021 15:22:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 3:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.289 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.289-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

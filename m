Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4312A32331A
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhBWVPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbhBWVNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:13:47 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097C8C061221
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:12:20 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id i8so18722222iog.7
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2xgPRzVoBB6HI7q4Qz3s2OggyE42bRNFyUfSPwCShcU=;
        b=e/QWarPYl88Q2zukIokuNNzRuuCsxp6sXvuUSIgyqWUBAd1c6evjJf90IUsDgU7SPs
         SQxPj0wOn/tU0MaGiGyEz7LxMdJW8frniG+efgvhADzmn0RFNqzin9b/BZ/JwoUzkvo6
         L5pCEFlx+MvIBK4dL5+SdhHDEuOYsXHRwgDm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2xgPRzVoBB6HI7q4Qz3s2OggyE42bRNFyUfSPwCShcU=;
        b=ll2RxzzPI7BfGaXp2YRKSwelq9x02n9HQg+l8Y3WuDbkpX78Z31OyHmqpsWxrBBCnA
         LcDMxjMH9dtR6o11re16XS27S0voMU48WNO50r+sLGgkWrWrvUWOUoXQy9vPtBmv1Qsv
         LOQK5DduQ/rHEkGcS1UARt3Iyj8ZEAGGzxoz3/5LxS156/kCPBfzFlZQusov4GBIAK3l
         YwRvsEJk+Ntlrot8lBRMsbary95UTetpIgYzCYlhO1lIIj2odmhfM425VLndGO9ywHH/
         ShvUnAj/f/YsEv4fA4hvQJ+1LQEcis5WK6MbScfkvACkYIl8mNCUrQnHU5ld1gomcb0o
         xiKg==
X-Gm-Message-State: AOAM53290jauYNgkbC8bspFPRgDjCDfpQilZgsGHoau8r2VsLM+GmRgB
        bZ7gUHvXgY5a3Xh+SjVsOmztfQ==
X-Google-Smtp-Source: ABdhPJyhjwklcswaS8lU4MMmPhHLt8YW9RtY/jgkeHzab0/SGmAuQBRiUFBRU4YB7+UWGiXhaTLpEA==
X-Received: by 2002:a5e:8615:: with SMTP id z21mr13952396ioj.132.1614114739525;
        Tue, 23 Feb 2021 13:12:19 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n7sm15754009ili.79.2021.02.23.13.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 13:12:19 -0800 (PST)
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121013.583922436@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c51cbda2-c055-3072-73d4-7900a2fb16f3@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 14:12:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 5:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.100 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.100-rc1.gz
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

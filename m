Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66244528FB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbhKPEJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241969AbhKPEJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:09:08 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61721C1F753B
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:54:09 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id f9so23676213ioo.11
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y9FQ2hZ+w+1y7lhp1163QXztrOKPULqm5EMkcR09uzE=;
        b=bIIrL0WHyGGui7ifNwl0wGkD1v6lInMejnpX8+6fWZykvd+CHUccTNH6JuO1pNJjQi
         vQg4qekT7Dxn7sSOE59Ly8617FZOjmsoERkHLn0LaR6amKYeKQ1H+JvCQAgXOu1C9v7D
         ezqIHrific36zMSc855+J5SWsoAWQSmtLucX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y9FQ2hZ+w+1y7lhp1163QXztrOKPULqm5EMkcR09uzE=;
        b=voegS22i6o8OnMz29yWOXiM3HAW5HJfxuQipqIBxPg32WYwQwG0jhedm1QbuZpkBEN
         JMcB6tXdrVLuq56JjsZnWS6dZ7qm2jpj+CnVoypaS1z5UbKLpyYaZ3OGbYwkduDxknHx
         0vZelwAlknTiPNMshX1fSx0VenhI+C4QCPx+easLdyix+1PgQBzNF+Amgs8ctFqPc9gn
         QckcH0xZElpgfo8GylMvm1MaH4r3jSnohBtt4Vn1D0ao9dX39frGN6824Dy7gQeH94zf
         uUhlirL942se3lg166MEMVpuat9X9rmjnpQf0QjDLGRnzNaGZwhBaLsc/DGhtkRF3H//
         iIKA==
X-Gm-Message-State: AOAM5317yytVQQTZya0FD47BTDLlVJ9MSUasz761WobHWgcInrOnf7Qy
        JCDqaxbRzLF6KMNiEXHmGdD8Hg==
X-Google-Smtp-Source: ABdhPJxBuzweTGbgJRRHqMperJX9Zx5BtklaVw1n+C2044pn5QynBoQuLtJwoTLNvJexfmuNF6drHA==
X-Received: by 2002:a05:6638:35a0:: with SMTP id v32mr2255603jal.61.1637024048853;
        Mon, 15 Nov 2021 16:54:08 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c3sm9511625ilj.70.2021.11.15.16.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 16:54:08 -0800 (PST)
Subject: Re: [PATCH 5.4 000/355] 5.4.160-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3f253bba-a102-d41f-0dec-3f4056ffc0b9@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 17:54:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 9:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc1.gz
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

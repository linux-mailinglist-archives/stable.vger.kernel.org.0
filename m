Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0703F417D49
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343508AbhIXVyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245708AbhIXVyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:54:19 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF8FC061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:52:45 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w1so12021418ilv.1
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/6ArZpTsrLDrh6XO37lt5RplIOb7A0rU8JiEj3EUCmg=;
        b=Ch2+LOSQabF5NgyjGxM95FloZO+LZaEuDwO4esyC4NyKS4TG+s72p/LVYsZj1umqjm
         YO0M+JCw+5cNlYit6V7kfzZC3piHuxXZPj7rlQMuBApmI2Z+efCjJCTl4YGG9NxzRUKd
         m8oxotiOrAw5O8ICHjQniQpSjoq9Aab089nqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/6ArZpTsrLDrh6XO37lt5RplIOb7A0rU8JiEj3EUCmg=;
        b=vIJ/Syt5azXYsjWawHKUmQoi/XVVWLTx3QtCAqJ4glUg0lAAM3wCY4VNyQS4XTiR0x
         8rcf+/nfCfgopc0FLy9OOUeiCXupPNMTlgp02wN1ZuJz1+IoK1bNriiZZVZUO579MmLv
         eL+4vzrNg4+0dabm/9Zgh3O3XlVlKw16SuGnZ5vTNSK1rzyhGU3d6XItcx+prT7rISYM
         bPZFLvpm/G45yL4Q/rrJOwawkXwG/FkuwutF+dvNwWwFyF/NS8WjOiYkRYJM4X6S3rA0
         xakKgBhncA5xnbvj0zW0Rb7AUF1JIuZOHw/0wDwKWrr3UFOt4kQ4lPulfQMe9rxaNAsa
         FCvQ==
X-Gm-Message-State: AOAM530VqMUTv6yeU9hQqt5yu4AQa5+wyOvdhwSrNGD3ft9nNXyU57HK
        3z3zib7+MOx29Bse3bYr7qz+9A==
X-Google-Smtp-Source: ABdhPJxZQhFlsVBQJX9/vqWOlqaurr1wS7Sr9FcbqhB5bJKKG30PmoJsdSxf4cMAb0mp61dDtRFYYA==
X-Received: by 2002:a05:6e02:1ba4:: with SMTP id n4mr9745301ili.225.1632520365336;
        Fri, 24 Sep 2021 14:52:45 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j14sm1566177ilu.74.2021.09.24.14.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:52:44 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/63] 5.10.69-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9805653a-f44e-116c-24da-f344c58d5cb5@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 15:52:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 6:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

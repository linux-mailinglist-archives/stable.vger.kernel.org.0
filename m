Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0487E429AE8
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 03:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhJLBUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 21:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbhJLBUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 21:20:46 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE908C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:18:45 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 5so21850279iov.9
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gerANuMYIsa1VDfjanaYaMHDBj8H/vN7JkwYlt5oGRI=;
        b=dQ4WeV9RBxJ26B0U6pJNRM7lK/rYP8CwgcYKgTYLoNVFQYPPBUqXvKPctoq2+zHihu
         jmtE2hssI15+tNpCMD+ct3UpNNGyFVDTZUXiszUCYcwMYMDl24QJAEWZhOSBm14w6US2
         GfTbHcBk32ZM7AdLZKZ8vHddJxHjNXX9VlKOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gerANuMYIsa1VDfjanaYaMHDBj8H/vN7JkwYlt5oGRI=;
        b=DhP2DgxeX+kXCBfj9Rv427YdjIZFgLpTzUjRGxvggh9nvlCwBITmHAsQLpaNqHWTg4
         Xs8MUssZhSaa2h3llMV+vQfr9x7rQLMaUynKlKTMT38dHcjZvi3c6bTRVzZ0PTcYpRMa
         zt/qBm0/P8ERLpcJTJdOQFT71Yy/Co9Yguj86pxNykkNKHIt5K4lbuaougogxLeSBzEE
         su1Bk4N5l6BHKBMMwziKFFhakDuja3aOOIfBnWUCSG8V67HhIZ1xBUMR5CJ36cs858dy
         ioPeB4HmJ/2vnev9tiNB3qnqOUqF4CiuBlM7bwP8rZI4xmpDiZz8Ll/4nkkdv1qv5sEs
         yKZA==
X-Gm-Message-State: AOAM531mgfLkzBemaRysQS4SrX+0uDH7ratFCSdcFvgB2S763S0+dvHK
        Iys+IO7GpbCq50H2YDj3xcRibg==
X-Google-Smtp-Source: ABdhPJzvjNb9lJ0xniiiUt8+ZCb97bobFC5kON354fKdFcf1I9RmAN2YsG+CGFHX5/gDlmRFvxFvlQ==
X-Received: by 2002:a02:270c:: with SMTP id g12mr20789755jaa.75.1634001524866;
        Mon, 11 Oct 2021 18:18:44 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m2sm1330340ilg.72.2021.10.11.18.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 18:18:44 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/28] 4.19.211-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f70e42ea-2fcf-ac92-2e33-3b787ffde4f4@linuxfoundation.org>
Date:   Mon, 11 Oct 2021 19:18:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 7:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:46:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.211-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

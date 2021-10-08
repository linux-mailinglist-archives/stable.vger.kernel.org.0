Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB3F427279
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhJHUsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242708AbhJHUsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:48:21 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767ABC061755
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:46:25 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id w10-20020a056830280a00b0054e4e6c85a6so4111753otu.5
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vp3sMAl0sQBNBIIRJ2no6SoD60WmO9rLt8aANKXsIjc=;
        b=AS87OZoQuVdZ1Hs1B3ow+P/Tfiyydt2jmFWvzcmPQIfEYXk7fK3c20kv07b831yBrg
         cuTrRQwRPbatWrWEe29oj9Zzfqq9BZmNJS5cGBco5a67HAeUMQeyNx/CQi7zhcbV3BEd
         QGzG5/+BzN/FLJDVso2KQxEHJKt1lFRBfK6eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vp3sMAl0sQBNBIIRJ2no6SoD60WmO9rLt8aANKXsIjc=;
        b=yVCL3W5I36IZfc2GUEejX30BlWqtpHECOLCGEuUBYfA8zAoWumMJhoO/zlRBooX6IU
         PfGH6Chvd4XspMzInqM+nYRiIxV8h4G6vrMobvluu6ppvR27Hte9w28pLnJv1lZsiQXY
         2zLJfGYEXRjp3CD2YOCvxDg17TK1zYpnyGY1E1/UdL6SShdWHF0Vbn8dMl4ZnvpMWlTV
         SSaRVKG1oBQ+kpYNehUNTOC6wTdRoOCUModslL1MbjzoXL/7qZkCUrDPXI5ZY99m1FMN
         F4bvVTsXvi5gIRxnkVyWEz4ocusYmmBgnLBcasVe+jCp26q+liYD/czZiJyO8KFFgd/h
         p6Zw==
X-Gm-Message-State: AOAM531iWPhrQUz6QrHLVVmiG4f0yNw/ZpFQ9NPfD3zQjh/H6/lJUyQd
        P4GfnYRM6VLBkS6x8/WF3o/x0Ne4sTMtGA==
X-Google-Smtp-Source: ABdhPJy1EInIbRPxCA2K3VeuHtjX6SZZRhAEDsezIKu5QWPuIFIR/6x5tWkdPxQBtiIs6mTNAYhK2g==
X-Received: by 2002:a05:6830:30a4:: with SMTP id g4mr1073257ots.312.1633725984847;
        Fri, 08 Oct 2021 13:46:24 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a13sm109614oiy.9.2021.10.08.13.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:46:24 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/29] 5.10.72-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <002ecd06-0247-a7de-fe1a-ab6c5e779871@linuxfoundation.org>
Date:   Fri, 8 Oct 2021 14:46:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.72 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.72-rc1.gz
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35EE3CBFFA
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 02:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhGQALE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 20:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhGQALD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 20:11:03 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31345C06175F
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:08:08 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id y6so9851612ilj.13
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VcC3oONSUrV5VkSlzbR7hqa12XgRPzsdq9AS4pFij38=;
        b=CdVgdXPO3xe6ObVXoCaNkpfFO8H+L72xVTmr5cvDQEnTd5WMPqUg3kRDolxCpFhWEQ
         GiVGPys4y++q382QlC+Jn1YT7X0gHhowsecWgCrBZGdx0qjlOHvmxI64dXmFixT4yYN8
         QbfIQtskkSRWunS8MYEhvTVeH2hqtZlJhoCGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VcC3oONSUrV5VkSlzbR7hqa12XgRPzsdq9AS4pFij38=;
        b=i/i4lGQtME1NijHZgE8i6ATlA7mlzw4nx2lwuzWSEhirmFiC7pPTWIrQvb/EOmBrfR
         Gvhg5YHl+EL6yfxiW3i6zk6CJSCGPe6iT4GXN4YXU1USlDIC1x0xVW5uw97gXn+kORo/
         4jHtNx4rY7BrHIx6GSZ75XRCp0uDbJT7HoQ1XyXtPz0sJN4KU6oMtmZI9bR7zhNFCiJi
         dvTnF4xAkT3zA0kF4hr+bxq6bJkVNhSNBEA/a3eIMjr6C0M6ZTtxFB0O9WM/KedOiBKi
         zel0BC9YPN/nhtlkkVX77qB74ThGKHy9d1qoDk0Y4Sqc+jF1VDR3OJf38Oq0+gPbV2TY
         pUKw==
X-Gm-Message-State: AOAM5319mB+as1QOewmVF69YqW+1mItHCHQvnO3VHYG0lK2hLcst/yNN
        dlWVik+7dyGwgV91EmxsAU5ySQ==
X-Google-Smtp-Source: ABdhPJxV/1ZZAwHGGQwwdDZa/5RDC6UPrk1gcWyY9ADs2DcK7f2CP1H/QxuoEKvPorsCBahFXW1Ksw==
X-Received: by 2002:a05:6e02:1c88:: with SMTP id w8mr8199623ill.154.1626480487686;
        Fri, 16 Jul 2021 17:08:07 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z11sm5917593ioh.14.2021.07.16.17.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 17:08:07 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/235] 5.12.18-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210716182137.994236340@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <09ecd4a8-f998-a10c-ede1-9d11f793be31@linuxfoundation.org>
Date:   Fri, 16 Jul 2021 18:08:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210716182137.994236340@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/21 12:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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


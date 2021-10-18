Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23334328BA
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 23:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhJRVDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhJRVDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:03:22 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461ABC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 14:01:11 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y67so17838672iof.10
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 14:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bRxvY13BaQDrIpCoIzVkm1t6Rick4MWC+glJt8uRjOQ=;
        b=NuKECKwVSveNAI49Vke6aZiNOsAmU8Oki14wSAsdnplYusloNVLkcTGNaSllMV9Zpq
         EzMmctztw5AAG22d3qsB5kLpt5urWWntzMYPc5LoE8wwStvH9eAADsC+pARte3QJbx3E
         0/c2rbtI3/ZyHnlkDudAVDzEv3okNvDjTIGCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRxvY13BaQDrIpCoIzVkm1t6Rick4MWC+glJt8uRjOQ=;
        b=a8ETCSqGHW+GfqQ4IZvFhlObpS1tFYtULCeHSqwJrgkKx0dlm8A+Aqyw2PIIYo79Vz
         u21rKFNtKfbOzF5fItUfdx1dPRD4rszNg/z1RYwhnNF8qHmz5ibRyAwOcTf1nRBRNGQj
         B+Jf3XqQtsFpYpiVzgpknyp/FZSqi/Iw6TFwBXwFoJmidhRSENZKMq9M1SiYZw1hmFDd
         EUJCIQ7piZi/q3fv2mAI3WhICENjuyDxINLFyr6x/X0U9MHdmKOvjEo7+3zY5MQiRtIc
         HE5aiKslqiWglXIfj2b2vGM84H7BQrZfBl/oPOIIed4Yrido9HxRwYgMaPiT0ME/Zo9k
         Gvvg==
X-Gm-Message-State: AOAM5323uwV9ATkqEc5/hGsudfBqu7N7bFxixtF125rfDSHPSplp8fHr
        aGEVRjarbLkRkOq9ztyKusCgYg==
X-Google-Smtp-Source: ABdhPJynjyytBbjrfjV2SukNgQXi/pfvhWQupabqgaqf8lQxwA8eNXnvALI80wXIr/9uuaK68JHuRQ==
X-Received: by 2002:a6b:5814:: with SMTP id m20mr16077148iob.188.1634590870245;
        Mon, 18 Oct 2021 14:01:10 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g9sm4196011ila.20.2021.10.18.14.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 14:01:09 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/49] 4.19.213-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211018143033.725101193@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <32f8fce9-bcd0-1b8e-5ec4-c1a6ea811b5d@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 15:01:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211018143033.725101193@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 8:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.213 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.213-rc2.gz
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

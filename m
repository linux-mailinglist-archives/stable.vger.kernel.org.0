Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2C23DAF76
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 00:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhG2WuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 18:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbhG2WuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 18:50:02 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EF0C0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:49:59 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id y11-20020a4ade0b0000b029024b4146e2f5so1977586oot.1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=coqqh1HtwJ/0woMOSfdFJGiKJ6Iw6bw2q49PyznX8X8=;
        b=LN08uaf4UOXwU7GQTUpyjocXdqKGPQ6XhuUrkloS4K6DJ2X810wAdz4EOVRUS2uMAa
         gCVMhEtWxkbLATENV4DUtya1uvHeevCVqhlGoCg0kClWGs8xD9BDdyzBXHq9eQWaq5OO
         nEPhFXVQT14w9PSBxO0/oOQkBTFht/APDWA6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=coqqh1HtwJ/0woMOSfdFJGiKJ6Iw6bw2q49PyznX8X8=;
        b=ugtek8d0Uk+zZtYgAED4AnRkZe+MJNwFzwvMTlvgYjP7KxjsolcpO23RzOZKbC1kiT
         fkbOPSvbrMd+UVaxgBWrWuPjywuZywwrh59WN6MXoqLe8I0QhgevbNUgcDn+n2Ox73V3
         1MNBQwwMKTsCRnnID4M148v3DPAWKuTxhwKFTLDkpLnqii/BJrA+jHiZx0MILSJznbnO
         fm1DzAJG2ilUKkZxXpyWMgXoEeQpuC6J+Yk1GMXFD+6bOnsZjGroa6iQLQmsSBRZhw+s
         DqbWY/mCKjOuurr1vfEb7jYvnzPGXhPYFDUtRt0aF5FeiKgx1PNcve9JJRQA8T1gNSQx
         dKaQ==
X-Gm-Message-State: AOAM531j+kT2loP43dP1qhPQTua5o1c/0SxtEbyXoh6VgUanJbR0yKd9
        oOZ1Byl2cr4DcNBWPP7KQ8o+gQ==
X-Google-Smtp-Source: ABdhPJzlzuO6hfXW/AOrSaqM1CsqndGoLEiG0x1Bihv1+OYB2gJtC/6Oz86ZJ98Sw8ib3N4vxdea8A==
X-Received: by 2002:a05:6820:620:: with SMTP id e32mr3082153oow.47.1627598998625;
        Thu, 29 Jul 2021 15:49:58 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q15sm780122otf.70.2021.07.29.15.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 15:49:58 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/21] 5.4.137-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ec0500e4-3af6-da25-83c3-4dd2dfc2ce1d@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 16:49:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.137 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.137-rc1.gz
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


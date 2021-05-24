Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D6B38F54E
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhEXWE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbhEXWE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:04:56 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8AFC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:03:26 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id d21so28407092oic.11
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mLzTaP/Qdg8yKY/klp6azdC/ttGHpr9eJshEzO54FMQ=;
        b=gFPJXdswjRViP1iIC5FjLLaFZwmS0I2ZB6LGuBs3wDkipS/mEEmch59fTFDuEtSP05
         VHhZ9YdyoDYlliXP/E7zzUvl1En3fi1RQGBNCxYZIvBTA+rHZBH7ZrQU+G2wtwPFF0dN
         bScIspmx8CVYSFa/cHs87vY1nWpMgzu7PlV3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mLzTaP/Qdg8yKY/klp6azdC/ttGHpr9eJshEzO54FMQ=;
        b=M6RED1cuAXqZ7CCU1nhy/0tyjvvGTnSBX/WZUOgin2Rf6HoR7FijDXnVhwXqOp2bPZ
         hfiUxZW5gFAPr0L2mZBJ3v4kXFpekUwbfMBu75+OOEL5uxZnUdrQ8DkczOLV8nSIUkxS
         bcEFrXdvbap4DtNq8Ksy4pQBmembP2gSOfqcHq8JyyZKZzw7Yg7TbfacZRD4vV0kMyny
         tiJMzglHMq/JXlkG6Y17rPY5M0T+3ZEe2smc/0tQWQ1tze/cqMem+WMAgx+nL/GTdFDA
         zDKbJExcaZVhwJSLllaQJCftaDpWq9fBXWKunODQ1ffMVkHn1SDGl7hockhy/vS+7mKe
         Xc7A==
X-Gm-Message-State: AOAM530uaArqYpgrPJhVpn312782ZSH6GgfzcFMr54aUrmjZfypQObc8
        9S+7q61c5w6DKsIfWIbTEfzUog==
X-Google-Smtp-Source: ABdhPJwR19bRGCwkRqQ2fIyUB7wC/eALCXFVMJz+W94WrmyWrWvhiQT+Ch9A6Cand29aifD8xISlLA==
X-Received: by 2002:aca:4758:: with SMTP id u85mr12225166oia.71.1621893806237;
        Mon, 24 May 2021 15:03:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i2sm3334418oto.66.2021.05.24.15.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 15:03:25 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e0997efa-b62a-5b13-858d-ad89eb6ce024@linuxfoundation.org>
Date:   Mon, 24 May 2021 16:03:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 9:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.7-rc1.gz
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

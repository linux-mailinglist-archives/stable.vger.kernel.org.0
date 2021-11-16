Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2378B4528E5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbhKPEEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240717AbhKPED7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:03:59 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100F3C04E23B
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:51:34 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id i9so18562146ilu.8
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TSclHLrBNCF8VIuFqDxcZ5UEW2NzjIPFuKLGSBG18YU=;
        b=GLSXZtD5heqG5ktceM06gqQ/SYsPFaCcHBhkkdkC2+o9U6RhF5veqIgy2lSLc7f1u+
         gFwopBlMkhF3yxWXJxVfLzUL8KosFj/neq+x1O+F7+aEr/H/ogyTMuCNp+MFK6lciblg
         eiDj6hXoEZVUhOkOV/Adjou2RIi2Nx19DfngU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TSclHLrBNCF8VIuFqDxcZ5UEW2NzjIPFuKLGSBG18YU=;
        b=v77QgGaFIFl8k4UrsQg5wK1AWwI7wMhzLnVwj0yjPgydCGPVU5XzxnvNqjHiWhT2Ck
         AjIsqcWdvJUtV//vlbXSS9H2NxbPu9IEBDjt+x1GGlUwZQhduWmHtBNrJaQEDf4qOSUd
         Q8JSDBnDDpMuVhVygz11O1DrbzAwGLoB+k6Aem/RT6qhFShJRH/8+w7e39kXRrDem94Y
         pi2Bdtwl7Y6TEojrNWLk1jtL3oGZQ0Iz15hxlYtN/reIxHQL6bntn3TjIa88C3ZdmyhC
         CmJNnmX7zB3ltssUTwl1UmR/Ja2mudr8aeImtqWHV9aCyg3lTD8SStdu/aTMzpmF7+1U
         1Mqg==
X-Gm-Message-State: AOAM533WE4yuHEkHjgItyrh+ONAiLZ80f5V4zkdU5tHxQn2DLjfGfU1d
        exsLIGMJR1bpv0VNPhLnbH9rBQ==
X-Google-Smtp-Source: ABdhPJxBCZfhEPjyXW3ftiplmfF2h4dZbzU+e1V1uZ3ZbLxdF92ea2IDCN+eTWCoUSMYRj3QWgVxXw==
X-Received: by 2002:a05:6e02:180b:: with SMTP id a11mr1960614ilv.82.1637023893373;
        Mon, 15 Nov 2021 16:51:33 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h14sm9739413ils.75.2021.11.15.16.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 16:51:33 -0800 (PST)
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <04199ba2-ec4a-5bf8-0a99-3f00cc4fe7db@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 17:51:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 9:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 917 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

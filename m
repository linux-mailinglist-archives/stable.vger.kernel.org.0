Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635F7480D5E
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 22:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhL1V3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 16:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhL1V3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 16:29:50 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31C5C06173E
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:29:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id p65so24023273iof.3
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fN90F5loVZGNJtT4sOvwQTnlbIQ6xFDd3t+EThY49hw=;
        b=Yi/dD8VmYymDE2+tRQZkou3VUPB7+X7fA9pgE9mAeKnXhsMtMzh+pSEQi/9qMc40oi
         WAN91bmdZ69s1ML0T2GNKMR0uIt7PR/z9HY6DktlazuOm+Y+WI4SbyIw64c507c04pO5
         xodHGgt63SP/D6kUwOgpmy8p+mTktMXHl0kbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fN90F5loVZGNJtT4sOvwQTnlbIQ6xFDd3t+EThY49hw=;
        b=7pLM82Oo22hUfDjjNL4p60f9QHEeY09qAHzIda5hB9dAUiJCJmjDB4vAcxqrPPidCB
         SCCOeMa84yQqLFGCAAJefNGYsHX2x7E3aif/dl8AP4ozlelaCCsJM+XPyAPTHNwIqeCO
         5uHvF7DOI/yYdWwwFXthQ9+Wcd04jkUbAt5IVcVGDVYW+ulhgIhI19kbpMTFMwvYpkwD
         +32YWV8bQIzTYWc8TFTooZvqUF0lONIDe5TmbMEKms3wMYqpKoyqGbKwVBldQNOZFlZz
         KtTKN0JVZtqC9S+ZLFcFSpl/AR/+Mvo6axskAESLBcsT7wcHfJhkFIBfbnUgNRH1r26r
         LAhQ==
X-Gm-Message-State: AOAM532vY1agfZdxuo4ci+eSjc3DBp+4vZtOJY3mMZWC/0ktYAXFHLbf
        eOAQqKuXd0WpPk5KT9GxEPT2tA==
X-Google-Smtp-Source: ABdhPJzVnYJEVGGLTlFgClGdgMEhrpaQgU2u6xaee/JQh1xvaPgkOxaLKKZmzFr8sDyhBzZEb5W+Rg==
X-Received: by 2002:a6b:6a13:: with SMTP id x19mr10291455iog.178.1640726989138;
        Tue, 28 Dec 2021 13:29:49 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s9sm7691486ilu.3.2021.12.28.13.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 13:29:48 -0800 (PST)
Subject: Re: [PATCH 4.19 00/38] 4.19.223-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <39b13680-9b40-f4d5-4740-0cd2b0fbb565@linuxfoundation.org>
Date:   Tue, 28 Dec 2021 14:29:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/27/21 8:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.223 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.223-rc1.gz
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

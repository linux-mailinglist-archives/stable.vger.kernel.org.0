Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232FD3B10DA
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 01:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFWAA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 20:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhFWAAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 20:00:22 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D27C061756
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 16:58:05 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id m137so1327942oig.6
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 16:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RmipAmOn4dFo13X7TIOaez3PL8Zy1f7IqUA+zl075H8=;
        b=hCXPbwDO3S4aC9We9uHHPlDq1mx31D5964KHXiMB1MpGg2RjxqCfmDG0aFKSxscdnr
         8tQpPDWfSP9NhIpjXEnv26T3Gn91OtGCV9lYmv5jSPHibG3fFLuJpYhJMiAX/Z/kLIOL
         NoO3cV4P4pp4g69tcr8+d9Zpi2e3n9uUncFZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RmipAmOn4dFo13X7TIOaez3PL8Zy1f7IqUA+zl075H8=;
        b=On9wWpmAOAMch8FwTmUDp5waK8+LyFyPdIU53g/jJHQInGppGmeT3sXgPhc9pCR0sN
         2UCgKCeI/1g+tblD+jZheg6gXOGNNvZVgXvT/XC/sz/z0ZTB6/WQ+UzLHPb25e6uIPLP
         rZVhvjplvGAt7QTDkJGXK6UxFEW34nrFprW36R71bjIFbPrBsHNTbcRynXr30/GB04qI
         +2MzsvvsWCjy8G5aVAxJ1BbJ6P+jL+0dBoe5PArxEMlshbBY3z3I9oeOQYRXmgChCyH7
         rPu/lpvtXpwwVrTvZ5+fBuiKinHyi+Wejj0w1kIv3BYTGyYD09n6P9IJmlI199js3jNE
         jqSA==
X-Gm-Message-State: AOAM533vO3Ouu3vY0fB754c1h1VLMF7PpDawWBbGUk/rB7iMENd58MaU
        KuWpTTNNNQJZaIyJA8l0TJcNFg==
X-Google-Smtp-Source: ABdhPJycSGNgB5ca7a/uXeFM9eKo8FIDGqkLipas8fxfng3/5bBRc3QzEot4tZm1XU1qEFOQK3HKRA==
X-Received: by 2002:aca:170a:: with SMTP id j10mr1048263oii.23.1624406284938;
        Tue, 22 Jun 2021 16:58:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 59sm188281oto.3.2021.06.22.16.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 16:58:04 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/178] 5.12.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e1e2114f-f5ef-4441-ce82-a0c2fa1a89df@linuxfoundation.org>
Date:   Tue, 22 Jun 2021 17:58:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 10:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.13-rc1.gz
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

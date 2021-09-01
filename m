Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B023FE4D2
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 23:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343742AbhIAVWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 17:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343833AbhIAVWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 17:22:20 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038DFC061757
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 14:21:23 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b7so989847iob.4
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 14:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WjMX3sAefCe80N+qSokMg9lBnvOOtzWIhXf3B5Jmf1E=;
        b=eftIRH+hiZut0uWcQsBQe29E/pYdL0jYkDqrAN5VdIRkxdd3lEIdT27PQ0iNiuj3yX
         vkBzyAf63axGWKgPG1w1/YEowpPZakc3+qTk7ipAIfH50CZatEfuWmCSU743RrEr18y+
         CAbxyTeZjaWxTrjYO7R/XEFd4Utlwu5tzPofs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WjMX3sAefCe80N+qSokMg9lBnvOOtzWIhXf3B5Jmf1E=;
        b=Cxz3ihmDuPf3b5NekMe9zlORapOiKIGB/1gUxK9EadMXm+h37LpRS5JmJ8M1Lfpc+R
         w+O6/lqhb5IhQjTwnQUDMIXv660tTX99d0MMVG+8n9WtFhWvaMpD9mt14IqqWaA4T8ra
         S/HG1XTst3A9MmsSF/yTlEI/IU9DWLG60tnd1MlMQYOi9iquAnMNJ47tgb/dQe6XpVVm
         Cr9CyBQRu/gXKIlaIfrecAADqhZ4njZ8PBCnp6Wwdz/APkFAvVBS/5CwMS+9IgFSEvim
         JG2gLzfvgTzEMmiWW40EjUdY6yADYVhzsCnmcloxVHyhfqPjGvYvCNEaO7nNzzR2Z0e6
         Nzxw==
X-Gm-Message-State: AOAM530loIhtb7KdWKx4R2kHWcyGKGq3YL8hSzTchr+cOk6AuaO5w4sP
        z/uEvGG73cIu4XHk0IouwGSKGg==
X-Google-Smtp-Source: ABdhPJym2W9A6J7JN7hbKQ4BzmF0DNvKG6cvtaXd+61I6Vjb3sGHguaoQjJydDyeF/UWyjzzXDh2cg==
X-Received: by 2002:a5e:8e04:: with SMTP id a4mr1349288ion.56.1630531282427;
        Wed, 01 Sep 2021 14:21:22 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x12sm401646ilm.56.2021.09.01.14.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 14:21:22 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.62-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a8f5c6ed-256c-9dde-a0a9-df1b80691d7b@linuxfoundation.org>
Date:   Wed, 1 Sep 2021 15:21:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/21 6:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

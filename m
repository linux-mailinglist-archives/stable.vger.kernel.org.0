Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E7540EC53
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 23:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhIPVU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 17:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238848AbhIPVUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 17:20:09 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CF3C061767
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 14:18:47 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id m11so9621217ioo.6
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 14:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=23av2RsDxVsTdcjbqWTIADtubLaRLLB9MuBeHkSa4CE=;
        b=fHnlBv91dRfsxKIAZn94WkcufRAa5NVK6eHA8jUpLIGSWESrnjhDbT+cOa2C6GCgiU
         GtYt50fUITCgP+6eqwAATxzx0HyhMjjS8+EXBmd5mEmLJDJSz91aVBqSiDPMO9Dsg4nA
         0ZXDWc2WYWlZZ5CPNPl60TodF0oc9QeGymYho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=23av2RsDxVsTdcjbqWTIADtubLaRLLB9MuBeHkSa4CE=;
        b=4YE/r2eQTXvAOhZIwPL8Zqf8EzS9+4LQikvR3k8SUiaW39xRcotrwUq452WN9LdTXW
         X+Y6hMfQMhP0phu6pIlIXAyvGa6xJBYAOxySK6RUqnqveEmfao6avJCPcu3kMSbPYyLS
         VOoZSCTTj5Q7fR21HbvoDTm44mP/DnXffzvcgatQHRm8g7a7zl+/aMycg7airMOq4Pqv
         rV0RzzLiL0ypKLA3VeTF1EeXhYJLtePzKs44m3KGrs5FaJJn/cK6deSmpTzFQl8y6Dzf
         VQ/zIHHW2//dVbWNjxGU+HkwwhnwoRGBNq1uIC6R1AnBDnYXGz3TfHnKftlkiYwqm1ij
         2tXA==
X-Gm-Message-State: AOAM531avT8fHKw7hhuMbQ7+8z3Dpzz2gVqCNIGpQZpqSV7zhqTfDJdd
        CwsvkpzR418VBUN2aCMO8dkD+A==
X-Google-Smtp-Source: ABdhPJyMCF4xAQqoJbazuBFjXrScpYBswluZ2KWgDqtovafbxDzWrvxyjPCaNsRiCXpK9Lyy89gT5w==
X-Received: by 2002:a5d:8b59:: with SMTP id c25mr5931908iot.190.1631827126674;
        Thu, 16 Sep 2021 14:18:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f17sm2384953ilq.44.2021.09.16.14.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:18:45 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/306] 5.10.67-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4dd04f95-f383-e16c-e50f-f00a54649dc7@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:18:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/21 9:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.67-rc1.gz
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

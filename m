Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DDB24C8DB
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHTX4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgHTX4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:56:15 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757FAC061342
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:48:31 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id u63so98249oie.5
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9uGyMrw33yyhGegWP6BmwqpFM8yRbxnIVbZ2SWMKUmE=;
        b=ZNnMHRgebTN450UsDfLkrghESFEw+aARdiKwrAd75mE34IyhxAPeQ6kjShKImqpJXC
         CtccYsB9jMJxjxKD0eqDan4QJA1qBlAxlGOxCkqwZ7UqgTk7WINtDDY6Tg+GaNEocqhC
         bpFr/mPOmIqMjS5074u0piR6K09002Ka/0ftU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9uGyMrw33yyhGegWP6BmwqpFM8yRbxnIVbZ2SWMKUmE=;
        b=DS1nVB2A7t6eVtUTli6St+E4h1c6a8DzLNRJCeH6vUr6kF1SnB664PGl5NmymvFMlu
         s3yhEWggNkxMSc3jaQIHh/zuhM6mnS2z9UJNOX1IPkOQy2Z/CIk5/U8CwaHuELZCDsKo
         n7mhFvNKG/+1SzhUMlq6TyPaFm6hLwmwjE+g35sBdpaOQUecloKL3SN1i7+04AWpn7il
         gnjiMJpiCkm2bUKlnrX6pB0vzwNIdzSdsdtYh12QPYC7zU2VnlfB4TfbtSelxsX9F1Mv
         EsfCrGlZti0SViHw6JBDmJpgSG5nCEnU158St5lVshwEIIAT64e2upwpYYzNvJExizuD
         R8kQ==
X-Gm-Message-State: AOAM533rwzc6kWSxugiC0LkGfaie2xWvHEQdcHvy7UskEgoDTfqi7Hv2
        RIe3lLAa0TaAKLRtjJ5ooLFITA==
X-Google-Smtp-Source: ABdhPJzU8rD3OU7sHs/RuDxl1HsFpLL/ld1LkoijEsv1ja1A3ZhwfzkBId87G/6Ywa9lx3pCYK1CVw==
X-Received: by 2002:aca:504f:: with SMTP id e76mr157677oib.87.1597967310932;
        Thu, 20 Aug 2020 16:48:30 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h68sm30460otb.50.2020.08.20.16.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:48:30 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/204] 5.7.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f8a27d7e-c326-8ee5-12e9-c04f4ec2771f@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:48:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 3:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.17 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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

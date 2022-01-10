Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9A348A358
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345589AbiAJXA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbiAJXA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:00:26 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADDCC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 15:00:26 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 19so19844984ioz.4
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 15:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VPlgaH8RSmMz+j/Iej8qezGlqpIWaIdsG1ptpmEBxJA=;
        b=F6irRvqO9uUhmUrsz95rKJPytggE0VlcENzHu4ks2w4wf0X0W3YrdzzxaN/3BCmFv3
         4grg2th/Nw/q1CE05uXpeyrkYWhmw17jTDPR2saQBPbGal1UOhDftfp21Jh8tGQYWsX7
         xPbOnVZCHNtjW5tbML7rz7DHBVw4f/uROwUc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VPlgaH8RSmMz+j/Iej8qezGlqpIWaIdsG1ptpmEBxJA=;
        b=QtN1/2sbdhaehnhDTpgFFDc5jBz+k+2MFDnYxEn262favQejuhJTO7zlcFP7QEzerc
         1/0ewfc/rDA2qNp/Vwy7KaOvP7o3pUkFetpLgvsLuRFglRgNfeRauOrmbK+i5p//rKKQ
         zFybiAdrEsPXnJyh7DfJH25ksPmqEPEgJpcp8cVBRSEMKdXLXsi8S/WLl8tTZqRV7+vV
         310M7NuWP32WSZNivVRilq+rI5bJEigNj7jo7oDB2ofBaK1tRa3mMfnQBdHPSaYo6XnQ
         88yrPpSp43eEdvA387Zg8u9Sw10ECOK7dtGiWInZnr4IA+rj9gTEksufc5lKMbXn1aPH
         LB5w==
X-Gm-Message-State: AOAM530gp1R2o91VD6PMeO64ATaNVjxTvnAYmzsrTJqK94uVmBCS+MPl
        3Q0FinR1b264wWHBeBqn6mOjKlzT5RGo+w==
X-Google-Smtp-Source: ABdhPJxbRm9Pzyfd1/F9WvTsP5t1h9WZQd0Nw2IihdNxgugj+Nn5j3fSmCsxgQevKix2LcNN8z9a+Q==
X-Received: by 2002:a02:cdd0:: with SMTP id m16mr1063521jap.158.1641855625589;
        Mon, 10 Jan 2022 15:00:25 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z9sm4968282ilu.82.2022.01.10.15.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 15:00:25 -0800 (PST)
Subject: Re: [PATCH 4.4 00/14] 4.4.299-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220110071811.779189823@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <eecff82c-5e2c-330c-e290-1146d62b72ed@linuxfoundation.org>
Date:   Mon, 10 Jan 2022 16:00:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/22 12:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.299 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.299-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCAB42727E
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbhJHUs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbhJHUs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:48:59 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F16C061755
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:47:03 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id u20-20020a9d7214000000b0054e170300adso13050145otj.13
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GtwT1rQHEgYwqcxPi6l15m6JEL8j0ymwX20loHsrAro=;
        b=BcNfBWW6w/6axkRZ6N4p/VYwjw3KzF4Z0BjGDoKPudQWJ0dCZAnIxj9PQ6/PR1Ptzd
         gUP0z1Cb+cb7hRbnK8MT74f9ZWW3ncKr3XucEvcXy1WkuiHfjv+Ulgi+WmbDR4V6rluT
         QNOSO1xXogM3TX9UmTAD51k93CYWVORSEoAoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GtwT1rQHEgYwqcxPi6l15m6JEL8j0ymwX20loHsrAro=;
        b=kji7hZkFcBCa7/QGv663SiPOgTmDipvE63xtNqS65odH6+IfFtuj4Nila51rlndr5M
         trFMYViaiOuCLix/XYCSRNfPtYVaodYavu47JwjwHST1lfoQ4v4JMW3qzTJqNe1UBk9F
         Kmu4BKtBCyBFWTxs6ARVvr1cdlrzeY2rV672CfhF7dnHAWYrTb+zFAz7qi2QzrQf+m/O
         vWgg01Aspt/TRt46Ia0rXETsJvscYKvGeG/q9KbmwjrnXqxZzBwy8sOmi7EEgAuKjA44
         jzKLD5osHJWTBfjb9hUlyPA6glc+8zDkAtFQP8V6rY2yHEIVMSIFxWceLcEVELOaRC/z
         BucQ==
X-Gm-Message-State: AOAM532pAWM5iWLxIWxLPqxsXXg4PHzj4/FZFPHWxp9h0yB8mULnldj2
        CRd8tv8RMC55DQVXKFdWMvsB+Q==
X-Google-Smtp-Source: ABdhPJwPyi1EybllDohqeUYV6Ct9y56TXdmjcY6gockaxzyt3vW4WWZRj8JsIbkaLlVlpv6f/E5WVQ==
X-Received: by 2002:a05:6830:1514:: with SMTP id k20mr10199633otp.44.1633726022999;
        Fri, 08 Oct 2021 13:47:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c9sm106191ots.30.2021.10.08.13.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:47:02 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.152-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1f7b6df2-4559-9a16-f367-b57beddb057d@linuxfoundation.org>
Date:   Fri, 8 Oct 2021 14:47:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.152 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.152-rc1.gz
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

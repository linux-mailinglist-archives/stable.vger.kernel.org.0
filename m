Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93293615B0
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhDOWsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbhDOWsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:48:00 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE897C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:47:35 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i22so16844530ila.11
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pn220cerfCbXUEgP8xwN65Bb5Bk2GTtUPKKnK3A4WMI=;
        b=CIOco4bDolOwXJzk6aOYGB+fvo1tji00v/bBZyftoTelfsg/UryYP3byZ0YnnQVYSQ
         QagcseECBtaAUzv8ehsIM/cA5g/NFzy0aWNnUV1FwHTSn/H/4HSPYVUJYyDDCnuuuemv
         drM9W4dhQhXxwy8ME/Zl+i16x15DKWpFL2ZrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pn220cerfCbXUEgP8xwN65Bb5Bk2GTtUPKKnK3A4WMI=;
        b=sgJX6ZMSmZXvTHJIHVMzI8QFvj/38/m2Cv7vZipQfHoMgHaUbQW3/brQSHFPEI3J9R
         5pTbZ5jR+gGyGZenqP7bJ/YmKMmSl+eLOXu0ZR6cJoE+rvbCF3i8YoFGV1vfPrIvFiSx
         AAQBIF0zgM2JEUrN8KYqc0iEguIffpiDqlkdoJdk5JNMzfhNjyGCfxCtoZmEHVQRo46Q
         IFdowqM4HS8bXpSjz6sPOvvwYHXNE8jsJapHYkRwHUT3woocLRQIIJ5xZeXgHA13iZwq
         PZ5uabiDm3gG2ybsgu/ipUQXlQGRzGM0b0Yg39q2bdhu/gCCWgw4E2P5uuTRZNsUwyWr
         g5Zg==
X-Gm-Message-State: AOAM530iFrkteR3ch+EofBhCjHJPjyC5iGkgTy2wwFe9r8ZdbL5OMw/l
        qrDg6zTop7iE2UtpHL9JuQ9L4Q==
X-Google-Smtp-Source: ABdhPJwLPQj7pt7dqaloCvEsgRm6ta50aKaY6AyRXQzor/qy3zqhOgk7RBvHl5otIKXTED7vifCzAg==
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr4653393ili.157.1618526855363;
        Thu, 15 Apr 2021 15:47:35 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l5sm1844741ils.61.2021.04.15.15.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:47:35 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/38] 4.4.267-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4e84da31-03a6-1007-962a-e968b2c1dd8a@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:47:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.267 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.267-rc1.gz
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



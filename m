Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF7135A7EF
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhDIUif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhDIUie (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:38:34 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D828C061762
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 13:38:21 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x17so7230793iog.2
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 13:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TV9hYYa/SWm52PedD7fYlgzBW6+Sl+4bCCasfGQo52Y=;
        b=fQAp1iZFETj/xcolcfvqGV6ZgFjnrjwnJE/wsWDQYIa56GpF61KqcpwSM7wJbPnxjr
         kkj20pKf7RQSARQ7lnddClK4qXqCyV1SbNqhqfmLFShp4kwQjR51t9mZy1xK12lbl3bz
         vtTdJ/AlULyzFuf7fpfjWOxrhTvgE4PnFDKOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TV9hYYa/SWm52PedD7fYlgzBW6+Sl+4bCCasfGQo52Y=;
        b=Afl6p4TQPd91aNxph5jTv55tWVSsCh9O5A7Dw8d73hxV3SmkrkcnDOvqc1msrPq61X
         yS1qUMjXBqSiEcbRSrqTdpRw8qyVTJvX34LjWEc/ar/MFuJfl3pX+TZsqJRF4BthTrW+
         FS5Q1URxGeptAXJFPBm9PzTXUtlH50HkpLKyVCskR7V4QKo2S+VTEztX2PwdzmcVtD5z
         Ze1ITOvwImM/mO0P8D9CzEURIiz4jpWRvmU5uMVi6/ubkRiOPj4eSsOEX3lfGKuCjBoM
         bgIqovJtbtyRHzGPmhwbyMGtAjdC0RMzMR22lJGVm/9/3D9ylfcD2pAAthVtTRvShm33
         wP+g==
X-Gm-Message-State: AOAM5333T8BXPgB6zmFZqbAcegf02pgNFmhKuJEv4TbZ6lFBJgG2YfuC
        8vV6chNQshJN02QekYbFEO8W5A==
X-Google-Smtp-Source: ABdhPJzAa8XBmyvB/+xY7vHlEze44MyZA1300uEFpjGlD8E5uKr79OB0uhFeqhIKRLo5O/L/6OQexw==
X-Received: by 2002:a6b:e20a:: with SMTP id z10mr12692988ioc.99.1618000700635;
        Fri, 09 Apr 2021 13:38:20 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x8sm1573950iov.7.2021.04.09.13.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:38:20 -0700 (PDT)
Subject: Re: [PATCH 5.11 00/45] 5.11.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <be206414-473e-9501-ada3-aeab63fd26cb@linuxfoundation.org>
Date:   Fri, 9 Apr 2021 14:38:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 3:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.13 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

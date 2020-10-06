Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395B0284345
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 02:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgJFATB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 20:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgJFAS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 20:18:59 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96667C0613A7
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 17:18:58 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id m7so10729549oie.0
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 17:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iCNS2Mt7RYa/vQIW1MgM7dt2+SlfEcRtrJHzkHPD78E=;
        b=BEb24k9fKVTYev/Kp8u/prxqYADD3/O4fgpmhFwNY/aexp+3mte7L2rXaWxWytw+9E
         fD4tn6u761/Zqjmog+h1LAP/eG9HkDGdcgvatftwyXgKhWPxqpHbP/46YhzDMMzQuxy8
         FU5QltJ7M4F5FWpp6wTtPxlJDSaG5c0Npfm40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCNS2Mt7RYa/vQIW1MgM7dt2+SlfEcRtrJHzkHPD78E=;
        b=dVEuZANSU4qGPww7p+JEa8ZxTBEFItKsskBGBW4oNufFHaprphbCgFF/CC7LMZiQ/B
         OsoykMnfxFiGV5u0xk19UesYOH1d2iv1bK0b03t/DDa14L2v74KVG4nOBq6ihnordiOj
         VNXP4MZ/jpaB9E9t+49U5V6/5SESFcSvNI81T2/PMoDNfCpsKpKuzBO0OV8S/AyfSUk+
         nmOCC7mPfWSEaEGWCNLd7G/8aWvhP5blgO6qmG0lZfsbWsKxYHRh0RqbND0vR07UW8Lc
         5j5mdi98S3ExqIC9+hMh5BtDPaVftnpUWCc+n822YjfbdCVDyqS03w9U9B7zRqZ0ZogO
         Gjjw==
X-Gm-Message-State: AOAM533OTzypV3Q/M+limm1cOTWyQidmtOXi5A3SWfr4BpeTWe1FtHnm
        VkNGm3lD7H65YKlKZhArseX8+g==
X-Google-Smtp-Source: ABdhPJwMZCFpEf4HT4YvHBdN+JfpItjBRX6d5IetZVjAU46i/+HFWKHv8Mdve7RDGkgHhQR2sU9nCQ==
X-Received: by 2002:aca:c546:: with SMTP id v67mr1211518oif.24.1601943537954;
        Mon, 05 Oct 2020 17:18:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u2sm402757oig.48.2020.10.05.17.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 17:18:57 -0700 (PDT)
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <796191d0-b72a-296d-1fa9-ea9384597024@linuxfoundation.org>
Date:   Mon, 5 Oct 2020 18:18:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/20 9:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.14 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

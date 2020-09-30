Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2187827EB20
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 16:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgI3Ok5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 10:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgI3Ok4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 10:40:56 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661F2C061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:40:56 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id r10so549508oor.5
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6b9hnX2G64nHYkcKgImBn4GO3JVZ67n72WKYlTb2dHo=;
        b=TI1JCTbQ3khiLx83bo4E/5ZO+zmnG0wY9cboKI1lf75VgdrzTXY96vLxA69hrZ6YkD
         btjzbbfcRpU7EEenzLRF4NFLTUk5D5qp63ht+XtjpOlWYzW0ExesLAuLyxA+kigYmit4
         f+mLpKXVVuT6GlWU5eYa9BaLldgNTLMgq0h4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6b9hnX2G64nHYkcKgImBn4GO3JVZ67n72WKYlTb2dHo=;
        b=UMbErJ5NO5OijGEWKBKym6Q7oadc59VHmCVO1q4NIVA8OxKlw1X7IVCAMxf0jpGHnt
         zTYON9z1l+0FZr0sbApwyb1tS9+NIaQ593RG+yDzfbCxQW5xDE/NeSpftqT4FW+/1pgs
         oDvbQknCwdqKrgauedTYZAq7tQliCFD0S0SJPyFO9Tvvugyy0O/3s+vebQlXY54c+ezD
         y6bMUUPwxWcRNhXCCuA5mpvbQ8rMkLH3hMyc1ubcEvfFtgLsxLZj9BRykLI/ayV//ASZ
         j/YW7p9fqIoRXg1vwi/BLJhlKfpZaeKp+WqF+QC8NLkKjtJuWAxElk5ENSdyZIK04dPm
         6zOg==
X-Gm-Message-State: AOAM532fmneDtRxg1SmCABAjGr9MWQgqCIiM434yT3M0CHpeG41bOiml
        +qAhmxQOVT35N82Qh1qVLU2bdg==
X-Google-Smtp-Source: ABdhPJw1xZpxdN63OUNapjBcs1g5g2FNUEnh07FiIh26wCC6X0cPU9sAHQAFTeWbOgF+o5DoLObLFA==
X-Received: by 2002:a4a:91db:: with SMTP id e27mr2177639ooh.59.1601476855757;
        Wed, 30 Sep 2020 07:40:55 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w7sm438188oon.2.2020.09.30.07.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 07:40:55 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/121] 4.9.238-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6e6c8d4a-2d21-294a-38d3-0f97f9986387@linuxfoundation.org>
Date:   Wed, 30 Sep 2020 08:40:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/20 4:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.238 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15528218AB5
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgGHPEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730019AbgGHPEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:04:50 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC90C08C5CE
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 08:04:50 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 18so37126132otv.6
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qAxRhOVTsHpW8y+9qH3bw+T9CM43zkyDmvr5lDcILZg=;
        b=Q0PaE52LKHUSyakI1IMAGkOYy77ckAvd47pas+mtZs0+gJYxQm8Bme/8rp6wvaKYhg
         /Ie4EanJit7+tCWnWHHXTX6q+28io2zNYlrzPFHDLPFRvMCc+M7KU68CtxE7Xv0F+C7D
         cIacLbLGu71ef+aPHkOao4RLriE6cmdr93PHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qAxRhOVTsHpW8y+9qH3bw+T9CM43zkyDmvr5lDcILZg=;
        b=Mqwi7+isNboB2acTUGjy+iB0QVZAGBGN9eGB11NvlszGK7nYddAgcwBDgH6twBhBCz
         +KEu32O/sxqNN6K2P9AGBc/bxubL/vSEbXrZhsAvY5YZAnlYr2nvu+DYeYsgREzryqSC
         9wsGPqEtsClgnpaCc6iKBgtejwoAXCqfT1vW8jg0VqFvaJtLVWRCWDdZCRsWC3mFEB5f
         03MATDHGrlaV34P5E/7QqiLGTdzvohq5YdYQehHDSNILzUZBausZpy2Kvak1S47BoJEZ
         Yr6qgGS/3vB2eYAwIep1hQNXI1o4Ml00qTjCrIkzkTjUKK0LWNQNrbUPjyh7BqCpjKeu
         8/EA==
X-Gm-Message-State: AOAM532VTj3+3IWGYrUW6yvhozZsmn4bWm4ucBX3fhYuccYbks+DRgTR
        Lj96b4+dFQnHKjwTMjQQuhjTbjZhwhE=
X-Google-Smtp-Source: ABdhPJx5BOOY4zlhbKbICdwG2WXtcJnsE3cai+2+f8I5p5GtkBQnSYmo49sufjqBR0L6PyWQJVAV6Q==
X-Received: by 2002:a9d:2f0a:: with SMTP id h10mr16227167otb.314.1594220690094;
        Wed, 08 Jul 2020 08:04:50 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y7sm20360oov.26.2020.07.08.08.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:04:49 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/36] 4.19.132-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200707145749.130272978@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <43dbed05-5481-1ca7-6f1b-2354e166d474@linuxfoundation.org>
Date:   Wed, 8 Jul 2020 09:04:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/7/20 9:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.132 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E925D2AC93B
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgKIXWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgKIXWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:22:14 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31CEC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 15:22:14 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id n12so11686402ioc.2
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 15:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dIDKK5avmAIYO1TU73iZKWcfPJP3vxUvkk4uRTGvp5k=;
        b=Nv33gF0JCvzJoMCYb+fppXhu0RxkvHPC38IK2QrimyjQwExqvQZgY/mPrvR1zffxCf
         78EkZpqZRuoV9wCOJYKWmOXRQ8KrFQCL4FvnI8IBKDSJZ4SXjGjfOAWvWpjhpKFlvDkf
         KGh/AMgwRWTZG6RNGb7f66F0xzDMQmgzsMeHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIDKK5avmAIYO1TU73iZKWcfPJP3vxUvkk4uRTGvp5k=;
        b=QLhWvSab07YAaszHZUHzRt3nZhcUNklCS/0VUSXGVcBkHcgt3CP+HxHTF1542RkJhN
         WjPEHf+4F8ehMC8JykNWbPc8PU7sCJjGiyrxY1rTFS244KDmEC8BHIi5hWgSFrUpDMFC
         152zyo6Z1SJ6XOsaejN9Wulh2L1I2wBuOQbBPsi2hT+7MG7HFWhs5JW56H5duUeqs8xk
         iwBgN9pe1aDQe4Smm54kSmXIIAv+cnk1pqHVKcWyoZVyxsJhwz50AEhtxMYkAJMkmCMR
         7/bKx3S/d63DLiRUpK/Fl/LEwkjSI7iDjDxTKauvtdmEaUI1tyXoYKQd4vu5jR0nYIPy
         eIwg==
X-Gm-Message-State: AOAM532ur6EfG5gvvWRlwaEeVf+2H797p9wyHj/s2utKMCL2vVSxNxqj
        YIcPAEeOioPiceoR13laqwiJiFOIUJlsmw==
X-Google-Smtp-Source: ABdhPJyq+RaVSisC5PEiCAJEeY1T6z+2e2imJCEIuSOhw1BxTnzPtDsZRrE6rDTBBWz9baKjmkdAUQ==
X-Received: by 2002:a5d:8151:: with SMTP id f17mr8268605ioo.129.1604964134095;
        Mon, 09 Nov 2020 15:22:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i8sm8003592ilj.1.2020.11.09.15.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 15:22:13 -0800 (PST)
Subject: Re: [PATCH 5.4 00/85] 5.4.76-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ae1eb0f7-003d-6c65-5f8e-890b955f6d12@linuxfoundation.org>
Date:   Mon, 9 Nov 2020 16:22:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/20 5:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.76 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my new AMD Ryzen 7 4700G test system. No major
errors/warns to report. This is the baseline for this release.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

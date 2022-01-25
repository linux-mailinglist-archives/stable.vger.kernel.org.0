Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5278C49BF96
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 00:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiAYXer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 18:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiAYXeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 18:34:25 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F9CC06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:34:25 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e79so25628435iof.13
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0kXA/e8L9Y+oJO37MyYuPgNlBx6kowqFqn4nultLvt4=;
        b=gnjs4rJ0sXHvVnLhDifo/ZYbePOLfFE8ai+6HXomviqqUm7ztGlzjI+ccuMF7AyOmC
         d4Bcle4IrHjggMb9rALTD5c21Tei9+VPIVUPcybJ9gT9coZj+x/A52lyJmNDAlRqNXS3
         hwU3EBENXQgvDzmRWmIV1e0UA8Qi+YPWwhQkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0kXA/e8L9Y+oJO37MyYuPgNlBx6kowqFqn4nultLvt4=;
        b=cniCV6XXR3uThzotlYXrupFaj3sFmUkTczYYa5yAB9AVfV8fgkU1voE/kiBO9oQsAT
         hKxALtSUKz3VjGM+TeMUc00cGTOW+OT6cBRbcAfqOH2iSzZmi7I/YXidlNTw9V/VJQ8P
         mM2AmbYkF/C81IYoBSHl/g8cFh4KMwL5/+5MV4GhhP1KGsDrayWnYRCPn78hUiBNHIoC
         6C3wLZX9L94l6fe9Xj4bdfQiR9Pio3ZlueLqPUSjAhGdAolf1LHlMA5Ed/Yti2ZRoRR0
         +z/PuPnRlspHbXXR/B/leoRxDu3Q0URrg41cbbY9UdGlMnI8t9izrHanlSBBuvJKJz9m
         IcYw==
X-Gm-Message-State: AOAM532hecxqj+QNsRJVsPfRgoFLJyPfexwvyTcTNrUDlLcWrwPL5CuY
        uH5KtquKQvi4zX4e3+XAHo/ZbA==
X-Google-Smtp-Source: ABdhPJwBQrWdQKFMGfxLTqkzmyoniSQr+ukE6ygNOAj4MCLCh/SfRPW2KQEH/OUEdGbExr9g/0PWZw==
X-Received: by 2002:a02:81c3:: with SMTP id r3mr9971362jag.53.1643153664454;
        Tue, 25 Jan 2022 15:34:24 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:4ef8:d404:554b:9671? ([2601:282:8200:4c:4ef8:d404:554b:9671])
        by smtp.gmail.com with ESMTPSA id l12sm9393588ios.32.2022.01.25.15.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 15:34:24 -0800 (PST)
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220125155348.141138434@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <be6a4281-a7df-5310-b4e2-7f2b7a8c26a5@linuxfoundation.org>
Date:   Tue, 25 Jan 2022 16:34:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 9:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc2.gz
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

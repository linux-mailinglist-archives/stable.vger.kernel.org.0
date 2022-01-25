Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E558749BF94
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 00:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiAYXdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 18:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiAYXdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 18:33:45 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A0DC06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:33:44 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id h7so7718885iof.3
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qHkFughDBf0FBMUHjc4ZJouBUWWgobh9kL/7pUwZvJI=;
        b=UExyO2nZxZRduWr7J+WSTtgRJTIb0sdCGl6JxEaZ1bPd6E5O1iPHIQoRxFYzHB1URC
         FIswx+GjXdt1wAqBngXKZvTKXn6pcmUccVmsGRJ48uqB1vVryA3kj2wxKYwwclOCREcQ
         nyIkFaggIhMrY5zWn+1eG0hlRkTg1omW0IPt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qHkFughDBf0FBMUHjc4ZJouBUWWgobh9kL/7pUwZvJI=;
        b=xTuFHFTS2k0lOV2aThlSEIKc7CUx23p6UfdNzoL9T0k9WE2bFu358iIKGhgNZiMLNB
         AX2vhwekATXRGLRt8vofUqqqTBO2sK1r5zEPyUPDAAwnAGLQ/d/dDXJ7mrIbdSFzaOpI
         xbvF/2ueV7SRwxlZcavbN5l9PtYtQajghfp2OYBmTJYCVefkSVXoyN6HBMGUFLnsf6kK
         C1q8gAnB4yyUbH1mn4lnS63pEpzgz/J2stZ5dAyLcjrfsvkvMYN0EQyvo+WTZfbQRlwU
         ZvLfPk7v1JpcMHtJ8acmQQlq8XQUJItdMkz1B9tRPSHztINvkk9vZyJrD7iu66WiCuj8
         avGA==
X-Gm-Message-State: AOAM532GVt4yeWd+1qJs9n7DsKjQ1aO2kNhN4gz7RiIpwGI5lsVg1etF
        +unyOvBhUAiB5l93UE849HLY6Q==
X-Google-Smtp-Source: ABdhPJz4uBeY7WKuPTSN/Xm1Lc+tnY6klNSMc3QUyW8zz87GdS44xu6W33U9aemdMlOWzqJtyHC2gg==
X-Received: by 2002:a02:c724:: with SMTP id h4mr7128059jao.260.1643153624162;
        Tue, 25 Jan 2022 15:33:44 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:4ef8:d404:554b:9671? ([2601:282:8200:4c:4ef8:d404:554b:9671])
        by smtp.gmail.com with ESMTPSA id d16sm2402612ioi.51.2022.01.25.15.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 15:33:43 -0800 (PST)
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220125155423.959812122@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d29f1b74-cfc4-d735-e2c3-a90c98063a3b@linuxfoundation.org>
Date:   Tue, 25 Jan 2022 16:33:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 9:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

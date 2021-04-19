Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34320364CD0
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhDSVIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhDSVIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:08:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6EC06174A;
        Mon, 19 Apr 2021 14:07:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso14114703pjg.2;
        Mon, 19 Apr 2021 14:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y8JIYaQXesJ/FSlE2RZj4qiVby5imoQPp64AtT50fD4=;
        b=CRk0h/csD26RwKwKeA5HSOJekF+hylcD5yMMtU2NbFWTQvOaKVBvEU6m18uZ/ccdYE
         Ga44+kWZWt8JOLWV0ach/f89Oe4JH76Q8w/jkYoLdiQM3k9unVhNJoqQJGo7gxXOcDn4
         tn1oHYOtDLUjLj9O9wZL/HIXU9OJ8A38TA7V+G/3vQkNa/dDJkk3xRY567y1tShYvOiM
         EzpuzstFVbgPdyQx+mcrOIRb/1IlU6pLhr4l/Zehva2pcD8DEsM9ycigb9/xTJgO0cTt
         M+DvyPLrpyMk5tGsmO4Sg7j/Ca9T0zRdusnzxRJCybpHVRudU2R5V2n0nT0MsifbihMA
         5c9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y8JIYaQXesJ/FSlE2RZj4qiVby5imoQPp64AtT50fD4=;
        b=EADq2mvVgL+TTHgGQjRbMRKcPF7ts8zo5HinfPKGZ2WhdZUf72lo8EEU8z/VRITi2n
         Ub9N2E0li69ixsRGfK+vj6ue4R0wFQpFfEFzj/Ago/USt8nHnBXEZcz/WK+b9u5ABUFA
         MTWbfMZ61NQ42JGl/o9VyWM6/E8t7BVH0NG9caxsZiMFZNzOU2MSgm+EMOl6xzFhtlSw
         BO4SM6r/2p+0hkgkTEn8mTnIrVh7ZDLB6JR8Blp5FlhKbGuVLOjCxCMnyD58keOrRSi6
         8rBnpdOtHPtiK99TXJ0+fQKZrWAlT8wYsrD0YK3+QCCyk0q7o10RbgQgWs316vZNRAWr
         qC+A==
X-Gm-Message-State: AOAM531dsG/5xjj3IbfcdLengLzHDl8MqYXHm4VXvtT6oGrQVP/PfTFK
        aRaDd9f8j7gFcVCEuyv6NlF+W+zlDHE=
X-Google-Smtp-Source: ABdhPJxStt5AiMvqBuYNGbjsh8Idvcawv1saDuzFD9NavXzqi8mLWNSIYtMYi2LntvsZk+vlS0aHOw==
X-Received: by 2002:a17:90a:c984:: with SMTP id w4mr1091371pjt.110.1618866460942;
        Mon, 19 Apr 2021 14:07:40 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f135sm13235266pfa.102.2021.04.19.14.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 14:07:40 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210419130527.791982064@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dcf6134c-9a67-cc1d-c8bc-75178557296b@gmail.com>
Date:   Mon, 19 Apr 2021 14:07:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/19/2021 6:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

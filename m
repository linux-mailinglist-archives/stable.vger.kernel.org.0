Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC76E396B12
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 04:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhFAC3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 22:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbhFAC3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 22:29:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED8C061574;
        Mon, 31 May 2021 19:27:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso757844pjx.1;
        Mon, 31 May 2021 19:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQ4P9FscM2xS+3s8N72P5JnKL4Z+4yVDK/cfXqGlmzI=;
        b=JoI/AORaIl4tKG0FpgFNKRQ7TO/Xv21bg7vNkXjYaWpt1OzyPHfj5hELWchvuzf6TP
         ugYm4mIh29Yb/OS6kCSIfc6ToFpW8ZeifbZOBWyW+my1ytYysI8XqJfB+IiZilnK8eeB
         xgvtWyNx6vKIlCv381EtE0+n+WFkVFXqQ/SSw4bnpvZHBcxZIdtnOKz8e8ncIv85i/YZ
         Jf7aklkxCA1ZgaywXzjIHSXuks9wYjrdwXJo6rbKshTOrA5C+D9S6r01AK2E18UfvacM
         BcMqFpqq/lbwacgtXQk4ksg8LEFVg40Nn8Dr6zvy3/svfXSplQhxjDCTesiipGm3uIik
         ArEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQ4P9FscM2xS+3s8N72P5JnKL4Z+4yVDK/cfXqGlmzI=;
        b=nFm2roZcQEtPV8jKB4LDlUXBDsJ0G5iHJT3sPd6kNBl5N2Zz9ap+JS92DByzlIpzAk
         1NjK27x66uWTjfHQxNtp80OiGlHCSE86hqkJ+VOZ5L8u0fV2Dx3ATTzKtbtDVgdpQNbY
         vGUiXiFfml5xMlvTeUgUiveGLZXg9U+0nmeaGJW28UTd0NoZt7xfR1ehWmh09SGR7Pjl
         dWwhPlOgvrRmGMVgMHdJQAukhWKuRA/JH3NaBUpvBmKorstbB7oPJBAAxeTUmTcQFo3E
         FVpWwngJDL7+/mqShaWM3xB5hAJ80YRBSSZ2S/cPPd0HHV8GFjy5oSW+Mh37bwaNlciT
         QsuA==
X-Gm-Message-State: AOAM532oZQZDc5HFxjX9SjikryKQrV/mgv8oQmuBj7Dxr7RZ8yVcsYF8
        MPJiAgnvJSjSl+A3o0fVe9s9TDA2MqzLXg==
X-Google-Smtp-Source: ABdhPJzuiHGVPhhil88cTotW4VL+ZHMHhPSfFp6sFcaPyKzNNfkLnVNdvEKueLRcs7cz9mNQTqMmJQ==
X-Received: by 2002:a17:902:e748:b029:f7:af18:2bd8 with SMTP id p8-20020a170902e748b02900f7af182bd8mr23534465plf.66.1622514444829;
        Mon, 31 May 2021 19:27:24 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p4sm6209389pjl.21.2021.05.31.19.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 19:27:24 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/252] 5.10.42-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210531130657.971257589@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f3127ec7-23dc-65f4-b30c-05173ac9ef70@gmail.com>
Date:   Mon, 31 May 2021 19:27:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/31/2021 6:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.42 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.42-rc1.gz
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

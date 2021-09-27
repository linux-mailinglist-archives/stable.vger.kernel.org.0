Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CDF419E64
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 20:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhI0Shv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 14:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbhI0Shu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 14:37:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E60C061575;
        Mon, 27 Sep 2021 11:36:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id n18so18579101pgm.12;
        Mon, 27 Sep 2021 11:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mB4LROKIVsFUsKgQXRlTlT/Cpfz94CXiUcS6oRbhjeE=;
        b=p0r6k3usuz3FMsXYowqbYn9tQZAgNh5TA9pMvH4Pop5ce15PwNniEr9PZQm4QMly00
         +HbL7EnWS/vevGPyI3IA7+2pvoeI6BbvauiVLyQ+IAhmn6VKSsI+ZZV15ZBLjm/XSEcl
         IMgAn/bUMmrSD2+MRtwRb5mwEI176AVzCPA9Jwy/J/lx25z8PdqtTwupjWSDqGZgffkO
         N2DR/8dXTnTCz7ZvRwbc828BXn90X/bVH5hJYiNX4y8JFCdgk6UOPGszKy5JJn4AQISP
         I5WNowtJvqJcGNpyFWG5RoQQFQLsmCWHfkFfyBRUj/cjzhftnmamb41sJ5oNbppmDDSY
         phSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mB4LROKIVsFUsKgQXRlTlT/Cpfz94CXiUcS6oRbhjeE=;
        b=ipa9NH99hBhNFfye5vxJyQJO0MFMPeDlawoRTyVJU0UcuFeIiMiSireIiK4avJ1ND2
         33epp57TBvoKdQ2o7xi+KVaRLD0aFWZQjk/OFKcV/vMd3AvFlEtL1GpzaivgBYmqymkl
         a+6aEmGILHL0gYIpuUWch0RoWVgiCOwt9oHqiHqZk9cKjUMLhMuZnnAaRATN4n29MDpG
         ZOPBiz9w9nXp2DdMO5okNnHsgikGeIxrqvD31dXHmp5PzevA6mXVX76sPva9/3PLq3GM
         4W5sqp+4KqM+BNymxtto779n/XtEK/FJU8xus1k2Apr8rA6HxDnu7BEclUn3ire/0Vbm
         KT3w==
X-Gm-Message-State: AOAM532s2vq/daf/7gINMklnpdQpCDhg4awh7LggiT/E+nb79gXIs3S/
        LGcHFjUiXQpJ03jW2PiBjtvNHWxpEuU=
X-Google-Smtp-Source: ABdhPJzc2xTGjDlB5cYuAw5q28yBONPp5sxSAAAGfpQTQh66onPi+XwxNV70Q0QEF70ui+CPr84/rg==
X-Received: by 2002:a05:6a00:2410:b0:409:5fbd:cb40 with SMTP id z16-20020a056a00241000b004095fbdcb40mr1405603pfh.8.1632767771204;
        Mon, 27 Sep 2021 11:36:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u16sm17709135pfn.68.2021.09.27.11.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 11:36:10 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/162] 5.14.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210927170233.453060397@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bcdbbc2b-9b59-6a92-79a9-570dd7efc1cd@gmail.com>
Date:   Mon, 27 Sep 2021 11:36:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/21 10:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

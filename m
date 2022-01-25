Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8998149ABBB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 06:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390989AbiAYFVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 00:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiAYFAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:00:42 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFDCC055A93;
        Mon, 24 Jan 2022 19:35:05 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h23so17164422pgk.11;
        Mon, 24 Jan 2022 19:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VBOELJ1zRONBSau+sIuTYIeelOPgLsdP5jEm9cvBgCA=;
        b=OJWjZXgmAsumun7Fb/tjIirZgN2ylWKjTiTimJwH0peLb/J3e3kMBkAe3KarPBRHJb
         QzQzQyjuj+5flE6h/JLfUNdX2syw4PcuRZnNfz7eoI5DrOhwhi0oPAvGxVLl7NNr8wkr
         sw3MxyrxBGy/TKxpmHHC6AYX6Hk2vmYl/q4eeVyRiU7OOi2y7Rban048UXAnXCodCJjr
         7x2eC/w82nFHa39INqWCtZKTKjkQbBNvrmAMprdsCNH3eDCfWf21t77Tov5mDajelfxj
         I5RF4b7h3zB8MPHJ/eNe+AJtAty0smHUamFMMoWML8TGdBUHJ4DS9Ia6xdEywfvBkv1t
         b8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VBOELJ1zRONBSau+sIuTYIeelOPgLsdP5jEm9cvBgCA=;
        b=6EO9eqokHzA5JQ0rYmIQgvUjOSashrzAkHMGHMMQIKJjkTvxYqc/biiiIuGUTbfuPT
         01LrwJ0DdUBAuPyp8yjkEiYHERvHDgsQt/11o261nG+5jPviCtjcP92H/pYBh6+MEjGo
         y8buNwjORuOlvtJao/f1F8JDI6HTcqGEZaeUiQrqdTV+g68Xp/R+NmZFyHvPqFrwgb7z
         gyzv1SPkdEiZC7kGQwDYM7HTn3ZyYwLKJd/07UUeqwdeiq3Ua0Jl6ltLkCZRYaRkrCgL
         WMM1L4nURjVONuJ+Osmv2AgUw1BlUiLp8OQeUb7j7owRbgx0KYyoKsmCXzuNxNl/+HWp
         z5dw==
X-Gm-Message-State: AOAM532tFGmsho9tY6MNiHh/r6lQ84BNFVpeRMj9lJ2J9YWUIlv3tfNU
        LFTrvPmOJK28Fj/lQvxMjJE=
X-Google-Smtp-Source: ABdhPJyNOomdFRdNveYz6/Fw27Is3tx0bbDezyPtbNf81Tnm8eUtohU49Pzh47o40mmcz3OdjxGe+g==
X-Received: by 2002:a62:1bd3:0:b0:4c7:4dfb:a604 with SMTP id b202-20020a621bd3000000b004c74dfba604mr15081878pfb.45.1643081704261;
        Mon, 24 Jan 2022 19:35:04 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u12sm2227201pfk.220.2022.01.24.19.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 19:35:03 -0800 (PST)
Message-ID: <2558e0c6-d310-7a6b-1a3e-4c09ced07214@gmail.com>
Date:   Mon, 24 Jan 2022 19:35:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 000/157] 4.9.298-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220124183932.787526760@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/2022 10:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

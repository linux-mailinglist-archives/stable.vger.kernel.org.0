Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7F49BA87
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383417AbiAYRlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383334AbiAYRkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:40:13 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11F0C06173B;
        Tue, 25 Jan 2022 09:40:12 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id v74so17201667pfc.1;
        Tue, 25 Jan 2022 09:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A4i9D5idz/4RqGlidUA5oO1C77kyiF14iIIXmZ6Fhck=;
        b=SkfW5quf1m7ZKWjE8OnUg+WWDrIBB3Xtiz/5zw6hRPTwTZ+ldd1ubl5n+k59hanx8H
         VPaD68bDkPZ2iP+VTa4DF+AJB+hF++N3heyGboRSCidjdq3Kgg+YJ4AftWpKuaHmDZp/
         a11cDsoT6sGE0u5Us7NEWPocmrgJimOHdZRf/u0sL1rsZNrDQr3A5IaDJvB8UjfxHF8P
         ckOLeHfDbKiMikVvYD1YEwxQK7Jvyza/K50mlHVASbPxIemcckigzGrHP7BZjQgOHNC5
         mRQOQb5h7aqSb8DEYCg7qCIKOiJEa4eHQcUszkYihPBDHL/nLLCL0fVVTEAOERrFccfe
         yXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A4i9D5idz/4RqGlidUA5oO1C77kyiF14iIIXmZ6Fhck=;
        b=2ccMyBBu8fjTsazEAfRXppOLZjhZdcp5XOqW8GaDVsNXmVfMJEKupLHI/2ygwAQ3xq
         +IU0P3ivMcN/n+URgrPXFKBcbQv9aI/agflR+Vy8xyXd0x96N9Zz2JAoCPecVNpa+1f+
         7F4FjF/41QWpe3Cy57e69Fe9tu9doe5aUQ3jnse7/p8gkdG43LSqZJzqBAeHCDoerDib
         9qBoCq538eueZMnem5OEwvXnmJbmU33aCTZ5Cj7L7AF2/myNmVuJ2FIVVI3M4uHDn1m4
         sqS4TTKdVrqEj1TuMPMKEK4mN4+PgTJ8miRpsX8MCMFPUYLqP8oIL7I7osw+yJGsD69b
         OKGg==
X-Gm-Message-State: AOAM530SD/np7cWeU/yeHqqaiJJGRQ9x+BckkFWwRtVj334TKAph91Ls
        GvI2hOvg9dehk7tqd2d1yKA=
X-Google-Smtp-Source: ABdhPJxXiMogpmdw9Mu0RlCbeyE+HxHOn5FjP1a1lFw0PxvrBu/QBnkzpceM16E3rjhjR/GPzkfGmQ==
X-Received: by 2002:a63:6e45:: with SMTP id j66mr8959707pgc.81.1643132412466;
        Tue, 25 Jan 2022 09:40:12 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k16sm6486194pgh.45.2022.01.25.09.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 09:40:11 -0800 (PST)
Message-ID: <4076304d-19ef-4eb8-f4e3-5bbc218e1d62@gmail.com>
Date:   Tue, 25 Jan 2022 09:40:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 000/316] 5.4.174-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220125155315.237374794@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220125155315.237374794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/25/2022 8:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

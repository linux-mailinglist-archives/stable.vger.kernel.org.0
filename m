Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891974A9E45
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377074AbiBDRsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiBDRsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:48:06 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67F0C061714;
        Fri,  4 Feb 2022 09:48:06 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x11so5767143plg.6;
        Fri, 04 Feb 2022 09:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4Y2bzdSGviXq60UAJUwPl6VNHemh5FsztTQ19e+AzIM=;
        b=gWlIZuD5AXuFcp67d+7phWRqrAVSGOkXgZObWSfD+qThKjUPbQCZgZqKSUrZk4qkLT
         cuMo7HHFyngVG5l5Z8QRHupNW3YbI57o5HiVyDL/jW7yWl18hobBfYuFxHCU8rTQOR/L
         BShL98Gd/fQg6pAn+BOauj1Qfh+IjDASyc3smt7p0T9eTw0z2WZCaSDqFmHhscKXRvIc
         D8PIVwfZajnvN4R5jDhM8bhSZ1yWHBsyVuXgZ6Y3/VqM1TYsF+kXssNNGc8pMhC6o78r
         STwm0Pqq+45z0QpyCWZJcWRcTcLaosjdu50X7ToLbb6oV4gjUIJw11j88MUgExjjHdFD
         HLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4Y2bzdSGviXq60UAJUwPl6VNHemh5FsztTQ19e+AzIM=;
        b=NBPWvlx2HfklgsSy8H5hYyRqHeSJpWTGBvyHiPiJNBHG0oGHxMdGPHZ01ri9RBjR2u
         7X7BXtviIXvATpVcW/360bJvxrHvg46iXrfc1/7stiK7qaOClA0PRthLJ+84vXxtRxO0
         pkcuKfgvpV2q41Jtg56VL+OVk5tY8xsQ57QLV32HdSKaUok12Uh2Tg1FkDaLEroUTaVv
         pvtPynVtGMwLc8LkUxD6qpMsRsLifoxZtbFes0hOxEYXiCCZ9BGOgeMO5/WwGKZjszME
         8FZ3AVcKWMdXR4Xmcjl5Eys+tdk1yLMYHxLgUTUmataSRirLQbFbDZcyLFilfcuSm3MU
         DuAw==
X-Gm-Message-State: AOAM533MjMn4ugZK4Ohgl8iSII7GaKBwY1S9+Au7WYIeGKe3siHsZHry
        80BXRYUmlm3aC1snD0IxER0=
X-Google-Smtp-Source: ABdhPJwOkW1NsAfaZTcVsoKEZ1fDF+2WkGefCHlRQDhTYvBLTKlohSZxwn8rGxcK+OlsZqzGyRS1HA==
X-Received: by 2002:a17:902:6b83:: with SMTP id p3mr4113682plk.55.1643996886147;
        Fri, 04 Feb 2022 09:48:06 -0800 (PST)
Received: from [10.230.2.160] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id j8sm3546451pfc.48.2022.02.04.09.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:48:05 -0800 (PST)
Message-ID: <f4a3aac7-169f-0089-26e7-eef193bd5d29@gmail.com>
Date:   Fri, 4 Feb 2022 09:48:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220204091915.247906930@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/4/2022 1:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

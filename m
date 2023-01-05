Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821CC65F485
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 20:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbjAETcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 14:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbjAETcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 14:32:13 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77D26420;
        Thu,  5 Jan 2023 11:28:16 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id k137so21295064pfd.8;
        Thu, 05 Jan 2023 11:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GwfcSIICsOIyK5Yw2ufNNP2O+AzOBcTMp/lG61+JBDM=;
        b=kh374SFBr/3Zjd6AVfCclwb07M1Y9OhlvHUZXz/JTPe396pLR36qbmRS4S6dDAokjd
         Kx/TjJbAvjnZjiAo0rS1yD3scvKER93iL7YtElOSs8lvhKOzToQlL7TDBjdz0db+ZfJa
         hioWBBtEopPNoObjv9InHYftYSmbrP34O2KqBVVw64z0sVLI6uac4OdQBWXPkcbqGaVP
         ainjapKOvtabVGFESe8N1SGQHt39JqIiNc1l6XHIzNiC/CHdF5KXctwtU0KcVMAo/gfn
         CmE9UtLKThBjAIPUoYCI616Aq5Wwcc30NNfOh6zqQSatmR0O+whcKED8PVqQ0ckp+2hK
         GJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwfcSIICsOIyK5Yw2ufNNP2O+AzOBcTMp/lG61+JBDM=;
        b=IYkX9UjvjdRkWp9gbyLDI+KgVBheFmqoTV7z2zrVb3le9ApAp4mTUerGGRzvHB55ku
         nxjyhtJeetMdvtk7pcdk2XEkECHAsMnvLJYeX5X+B8udrQUvl4Vgb9Q6EWzg/t/Sm3vL
         STLmfTfrSnmdvm7c8fprlZnxeWtTcX54BzYiGrcXMw0KEgHOg4YQGs1dVpB+sUh0S5cO
         Lzs/UFzJlHeGRUluyRBToyXRAm5flK3hS5bxrVG2R9AjY7QtltgMFdE/dW+I4jmJB2b6
         a2D7eML0BRD8KX7xQQiwEfrEQ0d0eH3ITAqLZuJFIUgutCZKnpGccJXwO47HO8X7T9t0
         RvLg==
X-Gm-Message-State: AFqh2kqUuJFfq3kQdW9zVQdN7qbPo2bF7USoT+MJVLVc5pINK9lyOB06
        Cps2JxqFJeWnqdKwr9IFU/U=
X-Google-Smtp-Source: AMrXdXvxCAuKZtTYP7Ag3tfLxofAPlnM5XZCWWfwt0GC+1TZDtbXTZHCnH5UWdYKErDd68T0m+Sh6g==
X-Received: by 2002:a05:6a00:a1d:b0:581:73c4:f0bb with SMTP id p29-20020a056a000a1d00b0058173c4f0bbmr42876719pfh.2.1672946896252;
        Thu, 05 Jan 2023 11:28:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x24-20020aa78f18000000b0058134d2df41sm19977629pfr.146.2023.01.05.11.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 11:28:15 -0800 (PST)
Message-ID: <4e46ff8f-c990-192c-7e20-d4ff819f846d@gmail.com>
Date:   Thu, 5 Jan 2023 11:28:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230105125334.727282894@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/23 04:52, Greg Kroah-Hartman wrote:
> -------------------------------------------
> NOTE:
> 
> This is going to be the LAST 4.9.y release to be made by the stable/LTS
> kernel maintainers.  After this release, it will be end-of-life and you
> should not use it at all.  You should have moved to a newer kernel
> branch by now (as seen on the https://kernel.org/category/releases.html
> page), but if NOT, and this is going to be a real hardship, please
> contact me directly.
> -------------------------------------------
> 
> This is the start of the stable review cycle for the 4.9.337 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Jan 2023 12:52:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.337-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


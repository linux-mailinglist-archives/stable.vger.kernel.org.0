Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF54E7C0C
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiCYVdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 17:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiCYVdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 17:33:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF243615C;
        Fri, 25 Mar 2022 14:32:03 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id q11so9497997pln.11;
        Fri, 25 Mar 2022 14:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SJpCuQQmEV2SAoMittH2JJQh8KxyIjkNxtG+z5GWdKo=;
        b=U9ABznzW1nW5/RMOJE/y66cg5xMG3Xp+dipB/khfIOxxmjD8JYcNFO4Mp95i73nOJf
         R+HXyLJaXeAvt4F+YXUYpxhi4s4sJJYvGLyT6wtVCjMkQYyAup0ZXKJziRvjTqeELRJp
         9lv/aGijYhjJBkExcbKsJHwlbO2V+ibz4BFNwemc5+9emApVdM2VN8eK6efKxmBDpg+I
         EPTOkZCTU+GaIGYXjE6qS2NWawUF9s4n6J8Qd9wodtIxZ+E9ly/HjWLjAbKaiTGVJm+y
         16yM1ms45xqABLu2mMfgZEo/ZinYBxZiBwKAsxARl7gzBtsZMBCk5pDdHQEk+HFHRgjx
         lG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SJpCuQQmEV2SAoMittH2JJQh8KxyIjkNxtG+z5GWdKo=;
        b=KdplqN6zH2TDjcoLV7A38j0OwEN5BFMg+b8ruHXh3sl0NgajiZJqjc6QwEp2eAq0o6
         oRm5rbRwHNspoAFvH4It4LcR+8QGFvaH5VLl/bRU7lltwc8SMZA7ZJK5y1ZiDUEjIzio
         eQOvp3FxDlAL3VWdi6KLqgB2FR52F+Tjll1BuQOoTgKCD0Im6AAV0mEDcGQlswNbMK8u
         1aKkDh64dLXd5F9Gf9mnK0C83zlg4rtkTgwsI0v5eS9/Z7LdW7G9aKUxij6oQKpd/ZKf
         bMh8argpR/9iX/Drbqgt3YEBlMpL9ULxYf6L+yUPooDoKAH0hzlxV//5eUFAZ/eSGiDm
         VjNA==
X-Gm-Message-State: AOAM531IWbVhC8pZ9OUkOhFATK2YTI/8Qe5BWlAhvNKhC3f0M2mkxzsP
        O5xqa9gpJgxkPVXaS0DucUFJ72fxcRc=
X-Google-Smtp-Source: ABdhPJwsXL92fONz/dEfjQ4rEaK4/GNOyEJWWHXCdOdgpdxxZSP0ANna7W3IU35JOL2t5zgBT3itkQ==
X-Received: by 2002:a17:90b:3b81:b0:1c6:f22c:60f3 with SMTP id pc1-20020a17090b3b8100b001c6f22c60f3mr15082866pjb.109.1648243922717;
        Fri, 25 Mar 2022 14:32:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mu1-20020a17090b388100b001c77e79531bsm10786563pjb.50.2022.03.25.14.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 14:32:02 -0700 (PDT)
Message-ID: <15268a27-5386-45d8-5c55-1095251331f7@gmail.com>
Date:   Fri, 25 Mar 2022 14:31:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 00/14] 4.9.309-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150415.694544076@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220325150415.694544076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.309 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.309-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

PS: is there any reason why the Spectre BHB patches from here are not 
part of linux-stable/linux-4.9.y?
-- 
Florian

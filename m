Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A84DD013
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 22:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiCQVUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 17:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiCQVUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 17:20:49 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF14BC43;
        Thu, 17 Mar 2022 14:19:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t2so7831162pfj.10;
        Thu, 17 Mar 2022 14:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E0FghEjS/Rw5fgY3QFgY5tO8sn18k23p8upmZjRX6VQ=;
        b=YKg1Cy6p/GmNp3eJGkiFcNW3+VsuSs1HOoCHGW2tmG3+7L6cZALRLH5RG3Nuy9mDxO
         XkX/eOKowUqrtX1ifkThqh9IXD08cC9GzVZJQYF8/w8gpsROPA6mUp4GYLdJXcGZGNLq
         TXBfIKevQWgyXX8t3lxw/dusfVsNXAb1HtGXMNdrxEfECWjrQuoV2lSgdMwxzfs81zbD
         LlyJttNivr1Vx7v+mXae5ipct1aRegQIit5fJsA5FzQarkDTipqKpnEzeng+48K5Gbn8
         1vU8vf8oqu6unXFqILFt2wmWUl0GN1x5u2oJtf9yTnVX+grtbiDmgUuuPa1F0D5AkNDh
         UCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E0FghEjS/Rw5fgY3QFgY5tO8sn18k23p8upmZjRX6VQ=;
        b=oLdG05mg6k9nCFi7nbCGcNEn9ypndNdXZPzKOpLDUSa9yFNCz6BfqohlAF7FIYo2pC
         9Rb/OE/FayBhflqKjVh/FgSrMWcAK3LL12A6Z3Mp5qZdGfE0HWLbFdCdrfSStNUwwe01
         cNTA84Wubt+dVIdjUTgrNvJ7nkg6xYEr2oDf0Js9A3zE0mTafW24HK7YGIltYODC5hdv
         c3mCZoc94vhkLNV3OTGoPCykgG7hJ/pPLL9fz4XbX3jKhREFPamTmSnplvpP1skuOW/Y
         wQpKzWNgVnHAfDKgAfx//ioEiW0x1lhwOBKHBN4F+MxP11VdFIpXHY7cXUtKUTz76C3I
         p5Yg==
X-Gm-Message-State: AOAM530Hn4qeSKN7jBul7MWuaFnbInGJ4pvopwOPur0zgIu5OzNLJo13
        bsCa/yG8mAY3eTaelQHQLA9FcURuY/o=
X-Google-Smtp-Source: ABdhPJxS6AsPEzJcAbDKaR6kjQG9O2clYK2m18uZSi9kl8/+pxS1sI7lKq9kHdBRrTkMDVHktVXGKQ==
X-Received: by 2002:a63:dc53:0:b0:381:7f41:3a2d with SMTP id f19-20020a63dc53000000b003817f413a2dmr5333223pgj.126.1647551969420;
        Thu, 17 Mar 2022 14:19:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id om17-20020a17090b3a9100b001bf0fffee9bsm11285688pjb.52.2022.03.17.14.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 14:19:28 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/23] 5.10.107-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220317124525.955110315@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84699378-88db-f3fe-25fa-cea7c9af2ba4@gmail.com>
Date:   Thu, 17 Mar 2022 14:19:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.107 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.107-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

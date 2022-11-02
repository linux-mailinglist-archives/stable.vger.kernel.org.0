Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC224616C0C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 19:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiKBSZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 14:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiKBSY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 14:24:56 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4125221278;
        Wed,  2 Nov 2022 11:24:55 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id i12so13071600qvs.2;
        Wed, 02 Nov 2022 11:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bAxK6YFmky/qIZ4/dsMrrkPwupDe2/XOhrW+jM9nuZo=;
        b=Q4TGWjjmvsV0i++UUxIoGn0BfuMSVO5ZQHAjHRTHywLrr2e/k1iovtSR3RjaM+OHmM
         bvfSrGC/0MESeNXlHe7EHVB4/SnNWwSJTU8IWzDbII0F/mlrXkoWZXlTmFav4jkQwpel
         YV0fRrR0Zo/VZHUr7aLAKLrfu3jjE1yiVMVWIv4JMTw0O8593f0SR1P5w4GfUeqXprpt
         W/2/R/+tjdxG6VSoWkivEVCvsdI9XN2Pj8EpCXnuus405Gsxs1VFy8yj0J2XXhRc0CgH
         5xpnIMA9Xs9YKrIR7Aizo7IR0wzUj7QDTZjxOCYnHARPqQ8Bgd3N3bVutG/KYzzS9q1o
         5y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAxK6YFmky/qIZ4/dsMrrkPwupDe2/XOhrW+jM9nuZo=;
        b=r4fImUC8qMYDe5E4FgjruOnvcJVavo9r0kEKfZr2JerTdB9fvQwU21d0b/Mr0Kku+s
         QwHFsTUNmtWXZofxIjS/X2eSWWnzML9HI0nqVEBwvnzLHwYNn5nWHvYQafHZS11GYbRc
         oNOohh+g26xXyfO641z3Wg/gTy31TgUaIgeEJ/WInA/ZhBGTi0d08mmq2WdiBNqpn/sJ
         qoZXObirHcy2lftylEmPe4CT+Z9dHvIkCJvIV8GYWlo2d+nDKH7+IIWWDamCZgGxL2oI
         XjQrN9H+8IyKtyyICOCwXjkgZ+yM1MsKKw85gU/YuHccMA2zhdHrLCD0CQjouS3pDjEj
         1plQ==
X-Gm-Message-State: ACrzQf3xJo4FTwbhfUj5d050utcHGxZGnDl39hTtmvNgv/BgO1y7pRxs
        il0dquBGLhELiY6mWWBGwyw=
X-Google-Smtp-Source: AMsMyM7KX6sJPc7+0Yi6Aq0zfSZke1j1ZMjz81yEFb/qRLnMce6k9XhYzoHSlwpSoVCrTej1JBu3fQ==
X-Received: by 2002:ad4:5d6a:0:b0:4bb:d900:ff56 with SMTP id fn10-20020ad45d6a000000b004bbd900ff56mr19873181qvb.74.1667413494342;
        Wed, 02 Nov 2022 11:24:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b15-20020ac8540f000000b0039cc22a2c49sm6904548qtq.47.2022.11.02.11.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:24:53 -0700 (PDT)
Message-ID: <725be691-2209-72c0-8ccd-5ffae920943c@gmail.com>
Date:   Wed, 2 Nov 2022 11:24:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022059.593236470@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/22 19:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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


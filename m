Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E715B552299
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 19:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiFTRKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 13:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiFTRKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 13:10:21 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C92B1C91F;
        Mon, 20 Jun 2022 10:10:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a14so1191570pgh.11;
        Mon, 20 Jun 2022 10:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/HZzGoz+YzPFdcyQPOEuFTCPlsryUs88U+UNLCFlnd0=;
        b=pM3awV2G9ThnicP24IpXi/ArbqCCmBg6aZ6oQFaOi/ADNtcPhrtPL7rreqxYoqbzs1
         w2U0rn7HOdGZirxnqEuXTvETpMiEvNpyLcYrGDSIoefrhGZ9bBv7eIyOLyeWLp4CJVm0
         0GYj9E1yK8I2+OQ/2Fz2RQxWYvTaDxcJprXAsgbRGbttJ4vi2T4RoMICkyeUzD46m6kc
         SHFycq90G8LIFsNZ//6x2Y8HlhQCXZEM0JbkwEDzygVTgPtCETHpvP3sUg+V6OkUY3An
         nHubiP8lDe28XQkH/Ghguxhsory8Z1jGkFaSZGcutRLdyHyzB+8WxPUVnSmIQd0/jdA2
         LK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/HZzGoz+YzPFdcyQPOEuFTCPlsryUs88U+UNLCFlnd0=;
        b=xn5oufheeTevfuDiZrU4b1O62a+t40Q790F1dRj/IhX9AngozKlMRcHWyMqET+yAm7
         UA21IN3LOj1JPjRAFQwSSG8Q3SSAQQphxcvTUhe5OT7aHvnCK2tPwzfkzgaxpnuMQCXm
         4XRkjx5vZdxJ1/wsXGZX/Mj/hpy8hQIj/nUxTQw/l4F//ISjn7z1bckpEQWHNNl6gURI
         nhooEunADf1p9+5N08/IgEObeFt2KxRT+jINpeMEsjweGJJ6lxrRQmBhbIPWJaZ6q6QT
         b1cnSQPBmiciQ9Fcn3CelNrxCUlKxVw+NuO39iM7gP5dgYFwZiUVEWeH3G4gcLoQIyAT
         8oug==
X-Gm-Message-State: AJIora/S5ziL8RSYrpgoMpmW6zH9mqXwR8KQwf3lr1LS5JTBNYw2mmU3
        VyNICtAUt3a8lFViSr4+FN0=
X-Google-Smtp-Source: AGRyM1uI1NHPx35Rhv2kdpxMWQ+PKd1y10jo1mKLbORI0hX0E1sjeAOhL7XfFwAS9D3aZhiIaOKirA==
X-Received: by 2002:a63:5a13:0:b0:3c6:3d28:87e5 with SMTP id o19-20020a635a13000000b003c63d2887e5mr23155477pgb.452.1655745019804;
        Mon, 20 Jun 2022 10:10:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x6-20020a637c06000000b003fbfd5e4ddcsm4484626pgc.75.2022.06.20.10.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 10:10:19 -0700 (PDT)
Message-ID: <305123f3-2098-2dc5-f042-1142b14477e4@gmail.com>
Date:   Mon, 20 Jun 2022 10:10:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220620124737.799371052@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
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

On 6/20/22 05:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

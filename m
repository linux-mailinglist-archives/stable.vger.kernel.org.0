Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043FC570A37
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 20:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiGKS6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 14:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiGKS6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 14:58:39 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66115F74;
        Mon, 11 Jul 2022 11:58:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s27so5474223pga.13;
        Mon, 11 Jul 2022 11:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pXX16zqMZ21Xtym4SCeJoGfTd6FvLAtGuHb0Wc+2xVA=;
        b=fXSVFS76kQzdYPhlEkz2WR8jl9DRkR6qf/KO+SiMyHvhKDQ7FH1dw5pcJRCsGnw42M
         SgOvIX1R8gaX218xibtzBGu4D6mbx+zCQ9ubus7FN0sAFJwC9RBTO8uv2SQbbgwKy4vU
         vdbJ4UGoHo1YrNyLIJBdJ92/mQkAeuOEtWkhVyBJFNph62a2S7JU77/qCYbpo095Mh+h
         KvBbUS1F5iWKBhiOWwdCmkF2snuYAh8jN59m71fUmZiZLz5mDObVnM3rh9ZhHxOogVtA
         g9PlIdDbghhSssAt4IJyjtlL5yZMyA4ng4rWQy8Vz/p/JCo9XUFmocC6AnA4BA21m10Y
         6XOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pXX16zqMZ21Xtym4SCeJoGfTd6FvLAtGuHb0Wc+2xVA=;
        b=PzWHv1SdXgCbOuPu4F2LNuH6XgEdmqjYsFL24aMsAKptIcFkfzBpHF1+2WqdmeFlcP
         hqvm+cruFh0X4tAwXGfCQR4JR2GUemyqycIqIX52GAaT8yAIZAq6jdKEpSrKA2qKaTa8
         Uj9yaf7r2DbAap4BnoCYORLsgkAqOOAHf4gaBhl9buI4DpKgVEBipdmyV5zSro+0xOwx
         yz5Sabm0/tJDiPfrdDsy46BA/Wq0ZlJhZZ6sf6XKDFvgAopHIYED/4pItRbEY0LnS+hI
         8Yo/CFfvKtgSABBBJHLNQKOAAI54+tP5YAQwhsI5RrhE2ivf+8WOIK788vhArcP0x/Sk
         AnKg==
X-Gm-Message-State: AJIora8Ma8xr+R0eWwqp4WNtvsBJCUAYMuajcRlUDPGKveCxhIv91dE9
        2fpEwm3Gv41Sqr2YPXtdQ/IYSggivJc=
X-Google-Smtp-Source: AGRyM1vVAWYdcExpXi1U9BZQmsySr0inBXLH+XNCJcF2zpBepQ2/FY7pF/tHIQyC/CV16/XMr/TxnQ==
X-Received: by 2002:a63:eb03:0:b0:412:b1d6:94ca with SMTP id t3-20020a63eb03000000b00412b1d694camr17095871pgh.468.1657565916971;
        Mon, 11 Jul 2022 11:58:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m12-20020a63710c000000b0040d287f1378sm4547570pgc.7.2022.07.11.11.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:58:36 -0700 (PDT)
Message-ID: <98186d7f-42e6-2f85-29eb-a0a37b639e58@gmail.com>
Date:   Mon, 11 Jul 2022 11:58:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220711090549.543317027@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
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

On 7/11/22 02:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

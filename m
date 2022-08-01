Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF75873C2
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiHAWKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiHAWKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:10:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E31942ADD;
        Mon,  1 Aug 2022 15:09:48 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d20so4441764pfq.5;
        Mon, 01 Aug 2022 15:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Pg/d+ZbLIR1AQ3tLJpUlTyiPpVGPYoJxM+XP2JX1cmE=;
        b=hixdpIinvOqKiulane+VHtiVvSqRczAqyO5hdB0epe6yRvBqtchS/KSpmqqyvw+kN0
         /k6HvBS60FlHNjCO2TjCCJnVFs/+mqOHqPDyjenUjOSFcyNENTe6muRYwpNWD3Z81yWB
         VQFMuzVsHXofVOPxiwN0HoMld6/1JjaZrfPjyAYUgjJXgUb22mY281lJn92Bkj4P5Obe
         ERGaDEhFjvsgbASvOWsH/RJfqKMGMy/gSfPbbxnineLx+iriwM0UJojSl7qknXh13ZwV
         IoYQxRv4j4yKhRwMu1W0C6cgZbVani9EyxZrzmpOBTSOBkjfkyg32YI8Qi8p8A4uC0mn
         yo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Pg/d+ZbLIR1AQ3tLJpUlTyiPpVGPYoJxM+XP2JX1cmE=;
        b=ZCTJslU3NsC7GRouuvqyOfmAqbPNaePqextmBAyLdAbkDWC4D4lkleEg4887R3jpkK
         MGgm6nQeGJsQYL/EIsjXnSPiMaPuf6XtjrrAT47X37kCwBwYw/1wtxhszSObCBmMIuZz
         1ncZ3yYlqCf5LPD8iIjpLAWzpdH9keYVZlly/FBIxcgbtmVY06DEIG9rqlTAsd7TMYL2
         TwDT9Q2ZuEWZVIPcXDrREXQiuwEfeB3VSXbd762i3bc+ISk6d4t1xsG4osx9okiY+Kb3
         eEvpn3O990JOtL/C+ZJoPOBJOg8gNHoaz9XOUlHzAfgsXUyzMdwewvvLDxCytIr2Q5C2
         mdVg==
X-Gm-Message-State: AJIora+eWm/OmEUf/5wRqMpmZLWfiEoiVj8/TB1v5d4xXV7LfBk4j7/Q
        Q+gg6iohula0FC2yuO0g4OQ=
X-Google-Smtp-Source: AGRyM1u+7zSIqJqhszGRJyysCnRBAEA7/jRhIt6nHGwE/pfd7PoHBf9QjsHu1p1kERY6iaNIU2pGHw==
X-Received: by 2002:a63:4711:0:b0:415:ff46:ba5 with SMTP id u17-20020a634711000000b00415ff460ba5mr15032778pga.133.1659391786749;
        Mon, 01 Aug 2022 15:09:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a7-20020a1709027e4700b0016b865ea2ddsm9977990pln.85.2022.08.01.15.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 15:09:46 -0700 (PDT)
Message-ID: <77abae27-5ce8-9f79-6c4a-b19c8ede8dfb@gmail.com>
Date:   Mon, 1 Aug 2022 15:09:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220801114138.041018499@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
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

On 8/1/22 04:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

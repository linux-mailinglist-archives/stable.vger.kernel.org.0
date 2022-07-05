Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3DE5674DB
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 18:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiGEQxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 12:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGEQxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 12:53:46 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756D33BF;
        Tue,  5 Jul 2022 09:53:45 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id v6so9160491qkh.2;
        Tue, 05 Jul 2022 09:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Lq4C3lgBb4tVK1r3gMPlQP1ZB+PVm+FPgR6q4DpS5Ps=;
        b=E6oMW3fCcrKNrCVHSxbo4QZKPwP1woMz+j3zhuxXfjyUOD/1ANWSzS8grcDGe4/Prh
         kagkue0MJsmF0pnbBAos9+mm7RLdTbWa3Tkwe4oxENZTWl2gRkoKRLZux6hCye88mRUQ
         eqXHvFqranvkhzFjEgyPwKhCdYwhHPam6nsCcchHm7YjvDMOUKsKFBgBsjZmoWwjamCK
         S9s8mf8o+FHThRFvF4kQbYtOdOnsQkr2Bgi5tW+B3xcRUrtIQ85Bi7Yt+id2tRBqWZSY
         vQBjYWzvdfwFSvz1YTlVwRHpwd/GbOgVIYVKlqwnynfspqwxKTQlsdwAt68CJHD9qXIY
         RgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lq4C3lgBb4tVK1r3gMPlQP1ZB+PVm+FPgR6q4DpS5Ps=;
        b=XJCcAi3lHqxPe7nVZmygqh4uuw3+Id92Wm2IF6B2M6GY3NH3wg3Lxif5JmsmOgynpA
         1Vq7B7yKwygXZxpU75rxrFovfdVLdyYLpEMSQHDk7m370yVj5Fkk4b9M1u74SYOnK2KR
         52ux8bJfAd/ju0ooE09uwSl3LSxhUAKfcOn2AQ356QgSBUhgCaHgl0lEg+jGEb3Tsp8u
         Qc1xxy1p+dHwqBMO4/CVIHvlnL+8Y3EF23PMfzuNizEbQaSpnRrHXfxMQhfKwiEZAS+Z
         va3CpKd6iJX79K/UE44DfBUJTknoNr45eVx/gIwazPn/ejg3nhxeUCWR+J4Z/iT3G33L
         WTzA==
X-Gm-Message-State: AJIora99v/gg2lC310J5Q6M92eVeOolBuGRFT8gON6qayCnktEFRHL65
        Xe/NaJtS+1fX8opwQMdW/v89xhpzoyg=
X-Google-Smtp-Source: AGRyM1uYs2K46qAjt5KFYhdIRbfxJLTNOrAbmKohlOlKrLZQjsgnzH+WoiqnBDiRLDicvvS9uxFV7A==
X-Received: by 2002:a05:620a:284b:b0:6b4:8685:2aa6 with SMTP id h11-20020a05620a284b00b006b486852aa6mr2470148qkp.780.1657040024567;
        Tue, 05 Jul 2022 09:53:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05620a454c00b006afd667535asm18196211qkp.83.2022.07.05.09.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 09:53:44 -0700 (PDT)
Message-ID: <811a7622-09f5-70c3-0de8-597e778d1836@gmail.com>
Date:   Tue, 5 Jul 2022 09:53:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 00/29] 4.9.322-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220705115605.742248854@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
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

On 7/5/22 04:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.322 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.322-rc1.gz
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

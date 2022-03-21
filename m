Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC324E302E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 19:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352262AbiCUSns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 14:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349327AbiCUSnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 14:43:47 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64C8B18B2;
        Mon, 21 Mar 2022 11:42:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n18so13521425plg.5;
        Mon, 21 Mar 2022 11:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=ZWJKX3sC754fQlPop2Gy+xs+nwPirdhaFvZuW3eMcac=;
        b=oSv6ZTLTToeQDXZWH6tx7n5Jpg3kXY735EgL6J+aoolGh6fY76KACyhl97/UIR1JsZ
         nL8FzhaVKuL2iVR1XkfG5fJcr/6Pnbj9hr8BwGguoCdSKyA79T3KKj6lG1TzRQpzisAu
         Vj8V46Qd5IhxSzmMX/N+4Cgufs6/e9nqn4dkaVR+mx7ZeGkgk/o68DOkudaxCvK/nKGm
         5uTF3q738QaLFrhefiIUPKXKIDajYLhmDyEVRkCM0sCyN4Iipfpg9YYHuDZ/GYs3L/ip
         4ANKF09+NJ5yly40U0gRI1smiOxNLsva1YyYpTOSVbcI8G+9kD5ZOFGAhXdoSqQAKPX2
         4XRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=ZWJKX3sC754fQlPop2Gy+xs+nwPirdhaFvZuW3eMcac=;
        b=k08yUKFsdHTjfA91XW5I/Q+/bY4E8uzWjAX3grXiN1IIrCjexjBil4HSOO9DMTH29L
         yuB0Nfrf+tV8Zz8kzswiFwSf3LnzcvPrTepTPWlvnROEYtNY6Ga1piYmXLHaRV8BbZZM
         A9MijyQ7FQFfod9v/MQeDmaHglfAH8EY+9Bf00Vn8mcRSGt2TSBSiqRyGXDrQTIjGca8
         CsnM5LyM1IKFyiyGQY36XDjEJIZHbkoVCacBy6cZ9M383X/duCXk6jxE4YgZkSuMYL/z
         pQuDmEQDnXjLGAoMeLlNOYjEn3VpZ+D4+nGopqRNEK1/FPvGhlxs+hZGeDX8quUqp1Q5
         Uc0A==
X-Gm-Message-State: AOAM5334Xg+DThj5DVIzmEpdlo4hVXIx9wEyaDZ/aPu92gsna5kE6pL8
        TFF9kQNnu1cgxaR5ehwxabY=
X-Google-Smtp-Source: ABdhPJz9ibM2Lbqfx0718jDYIzi7Vlus6/iwnKbPnq8BrVhzCsDiL039eZ2ErjP582zv3X6P144QDQ==
X-Received: by 2002:a17:902:e9cd:b0:153:f7db:138 with SMTP id 13-20020a170902e9cd00b00153f7db0138mr13998357plk.174.1647888140327;
        Mon, 21 Mar 2022 11:42:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h6-20020a056a00218600b004f65315bb37sm21326117pfi.13.2022.03.21.11.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 11:42:19 -0700 (PDT)
Message-ID: <3dee3fb2-899d-4324-81e4-c97c43af53f2@gmail.com>
Date:   Mon, 21 Mar 2022 11:42:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/32] 5.15.31-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220321133220.559554263@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
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

On 3/21/22 06:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.31 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.31-rc1.gz
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

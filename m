Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6677F65C791
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbjACTdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbjACTdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:33:11 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6109513D0A;
        Tue,  3 Jan 2023 11:33:10 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id l184so4146739vsc.0;
        Tue, 03 Jan 2023 11:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lFKwihPvKMpcXpSVULfJwtDOJkGorAbMoBn7I+sY6j0=;
        b=MLghucnahrx3YDWgHuWWZd07q404MGwEweT67Hhwy9Mse2bTbTBCkpUXIGdA/8v4ec
         1hLzjsajdPoFMOu7MD1rpCaxUjgAp8lmDbA3j7e+3r5LODLJS/qoZk3HQzy+W+HgCshI
         8M8J/lENYW1k1SYb3WcIMgEq7jUhqxJInLlswtvwhko2f2RfCeTL4kxXSMheydlhYgSX
         utYi0EpyEzcOL4rtiTN7AS/3pDkkWcRBI0lmepL/N/B7V0T2RGGkseHHxF7Cm/zB3obg
         QY73jJJw3dRCHR5lij5STBkKFY0/D2STodTRITvFeAD+Cg0yuuMBNRHZmRQd5TsaxOzz
         emUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFKwihPvKMpcXpSVULfJwtDOJkGorAbMoBn7I+sY6j0=;
        b=mi4+K47zT/kYlzK/ijlRDx20IAmlHa6WftkTjKuy0Pe1KsDGB7910OPD9AAi3AFFKe
         84UdT6tIB3PvPxmgBLiSh3nGpyWgdXBbapGhT5BtM2KRPsyQysrj944anRwmzM165w1Y
         VtofPSYPvu4CJo3Yp5Snw6Euov5gh9MCmRx0ktS5d10NxpZl57cTA9o6NStAjF7tbIcu
         edqGHLvqtjCyqG4Y0mX2CQw//NKnqBvgjVpy8XFd8he4blzvKbG7h1ezLh92kXUBxkFY
         DCzp2SGZVjLsc9F/0+4b2C4Inz14ZAbja4cQW/iTlsFkhgBIdaXClikmZ3huRuW37Xqi
         4WXA==
X-Gm-Message-State: AFqh2kp+GU5a9q5du3iAgj9mgjMXiDiWSOq6adbVrMPFi4al6nhdvzVS
        Yx6W9qwD0fxXFrQ6lwYtCzc=
X-Google-Smtp-Source: AMrXdXtaT5qDQkHma3K3lFnkjH3J81z2ePBPS7emp/cK7CZwix+GhyYG9AWUw3u6dD6vVMYvL062Nw==
X-Received: by 2002:a05:6102:185:b0:3b5:1edd:79fe with SMTP id r5-20020a056102018500b003b51edd79femr18416073vsq.21.1672774389337;
        Tue, 03 Jan 2023 11:33:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r17-20020ae9d611000000b00704c62638f4sm22439767qkk.89.2023.01.03.11.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:33:08 -0800 (PST)
Message-ID: <26f54e70-0453-9a0d-b032-5a97fc4fb6c8@gmail.com>
Date:   Tue, 3 Jan 2023 11:33:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230102110551.509937186@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/23 03:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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


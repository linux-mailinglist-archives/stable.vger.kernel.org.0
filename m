Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D4A69515C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 21:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBMUHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 15:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBMUHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 15:07:16 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F171DB98;
        Mon, 13 Feb 2023 12:07:10 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id h7so3650904pfc.11;
        Mon, 13 Feb 2023 12:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUlLPxnydlbsCnEsOBCMLuxerluJh+TD51PKhmBbyBo=;
        b=OdYWl6WiWHYOKoRjuhdVdnodyVWZz0PAiTLiPhGC43aYFL1GsfkQCp7SmUQeLTiuPL
         dWF/CODn6Sjj6j6vhRk/XdmR1Cu+sXeNDk6VpU1bQPTxp7PCmKVzcp0jAXcOBnZhD/ab
         E6/asf4JFZYZCDXGWInrYZN3TXgt1J1K4xOei28IzaHfI2dM0ssZ8GmJyoHuLxN8jSTn
         SY+jfBUc/mcB9NGGijeogxYuOX4llnuTQTBz0Vn9g5CS22MY3woA6w+gAN/IWSlDmn8f
         vIrODZd8tUVXfc3l3hpFQv6kvS3UeiJBW7fMip0qQMksSC/mQ/3b/CIDZ0HEcFVK66Q1
         IsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUlLPxnydlbsCnEsOBCMLuxerluJh+TD51PKhmBbyBo=;
        b=WF3gMBtoItqLscnccEeDlhqzPII6s16WoTcrlmk831W70aQLjG7sMY7FfdviK21q7L
         ljaZJO8TaKUvQLeZtLWp4DxCaPFYhr4/X6Ulyjt8615SUxyyHR25KfD58KpiDfqbnLQg
         3ZapDuJOLjGs/FuYN3v19poQHecWerwb+7gIdEFKTWlymIDGP0izO8NOmianP0qRTzjX
         BcMzDGT9Cg+MBw/eaJQCCt2dxc6KENou8jwFZotzIS5cA0Jwyf7T99G/AIJI1aoiWti6
         3t2PmMwbWAGBzYzsB417cnW6IDYwdFtsuQAb8D4y8CzNAOy0liy87VBL3ZMxEafjTpPD
         jNqw==
X-Gm-Message-State: AO0yUKW/Eea1H1Tyb6AeXOo424e9OVH9jHzxvBnl9O4LPcJqZblLeuaA
        11eHWUkeRHUAVir6LMGpy1s=
X-Google-Smtp-Source: AK7set/Ih0MR7DO60kpkQvKkq9+m+/wyU3kGHFmz6J/ZGAvvEBVgtlCAEISqcdNJ2oi6JyGFGfs3Xg==
X-Received: by 2002:a05:6a00:5e:b0:5a8:bd95:6575 with SMTP id i30-20020a056a00005e00b005a8bd956575mr3493345pfk.23.1676318829435;
        Mon, 13 Feb 2023 12:07:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x27-20020aa793bb000000b005a8b4dcd21asm2739336pff.15.2023.02.13.12.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 12:07:08 -0800 (PST)
Message-ID: <b5a8e85a-28a1-f59c-9bdd-377cadd9d11e@gmail.com>
Date:   Mon, 13 Feb 2023 12:07:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144732.336342050@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 06:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795CA510570
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345545AbiDZRdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 13:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244815AbiDZRdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 13:33:31 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC38C2C65F;
        Tue, 26 Apr 2022 10:30:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so30905362plg.5;
        Tue, 26 Apr 2022 10:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bjJluOSvyEn5IIXDLb4yRtBrE/4kW0WHbTzjbx0F7/o=;
        b=APB8LtTGIwHemO16knetKjVKno19p39+igRhlUzPh9b9O/1twhItBlsp4WX4QCKlyD
         GpT0IkrgyR2UzERAlV5oqWflG7q64i/gEqe+e6gNv0e1t54HjpYBrtdX2I5Xv2MzRdX1
         7eQcTSznVM9sU6qON5jjPxPN8EVQEP9IpNqDxD0cZja4vza4oi+P5siUVyEnY788rIvl
         gaTlD27QEcMmxU75SWQjd4Qsz9oQBNYYYYVwoNPe9ySuIxJ6MR1Ig8BhzvLEh6CWdI6U
         O7v/IcksMRDlBcTGeluzdLr53BO0wYwMiyb13V5tESsR6Ttx7Nbb6ZX1V6sH5AeEargE
         EajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bjJluOSvyEn5IIXDLb4yRtBrE/4kW0WHbTzjbx0F7/o=;
        b=wfgFkaqOHfMOL0TsqG7EgBfyHbLvyvwfp5WHsGFEvbnYJUi5LbQO8EcGBY5jy/NygV
         nbXh+qUYuJWWfvh26dYtjEcx+nvL7dJ/nqDqrAzAfzwra5JQX9gqioKNsJ1770Bq3Zzq
         HzkQrRYii2q2gF1aAMwYvGSXwAVoFc9gn/O0nWv47VkEg1uHWzesUbbS9uvF1NMe9jgE
         wiurG5whcsJOgwot8ZW54XJwfvQHyIynCPM+iCY39zM6IbEDVbTlc3qd2ZDtdxl8rTIR
         G+gesq1eMNnKIggfzD477rAzLn/nynIK97Llh3MrjNbidIrU6cWZHGR4biXkxu6xl6HL
         plvw==
X-Gm-Message-State: AOAM533QmqO2atN6CeNVKlrx+u+zEJQ4GmyIvmKUTwbSgHwMny4l1RjA
        52/Oh77pK9Sq2Ou/JuH/id8=
X-Google-Smtp-Source: ABdhPJyuduaYFnRA8deM9G5ToM2CuHgGQXF18xtJPwzdZjNrKnjMuQdo+cEUwskS8bp9GVvfjSOuFQ==
X-Received: by 2002:a17:90a:9308:b0:1cb:a048:c140 with SMTP id p8-20020a17090a930800b001cba048c140mr28345981pjo.221.1650994221726;
        Tue, 26 Apr 2022 10:30:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y3-20020a056a00190300b004fa2411bb92sm17419535pfi.93.2022.04.26.10.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:30:20 -0700 (PDT)
Message-ID: <4340f4cd-7c3b-a294-5fac-9b08fbbac70e@gmail.com>
Date:   Tue, 26 Apr 2022 10:30:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220426081747.286685339@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 01:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.36-rc1.gz
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

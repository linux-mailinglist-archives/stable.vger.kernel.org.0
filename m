Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE1168A35B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 21:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjBCUDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 15:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCUDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 15:03:54 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E1A9D5AD;
        Fri,  3 Feb 2023 12:03:53 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id m12so6812829qth.4;
        Fri, 03 Feb 2023 12:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AX8rN/nRejIs/f3fT9vWTY+nHDhK8VwQ9KCiwj1/p/w=;
        b=VeIQDjXwnnyeRxOt8XBfLLh6qaN9VTOVvYb/ZOXjO5hYqwqjXfGJehRmCR0sQdz780
         BYbRWpJoKp/NgXmoy7R+5NHXRnIRvTRI5cq6iGX299SeiPQtmB6M+EORhs0qxkmX6+Ft
         JBSFLOEQrM/e/ECu/xwKh69SvSONqrHL8iHv3bmK2c2KYHzhhh2UslrCX8PYhdYDBuRP
         GCGfSfKBP3WoVLBGhekbbSjXWNwMPeFPg4AUl0+WczYA0UTrZac3Pkg7tmzzVanNNo1i
         eugKJLaR/fvmi8Xs0GPLad9MbejVQH0PwzrJcRPSj7hg+40TJLVkzDhs7BF79TL+o9eJ
         ujQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AX8rN/nRejIs/f3fT9vWTY+nHDhK8VwQ9KCiwj1/p/w=;
        b=H9qlA7MjL9z6Y2kH1sdhjgOma0oVKWACNkp0lUA5UQd+b7NbXSVHxci9iu5S411gzl
         Ng+kpl5TTvuyYjDzBuxajkjKQHKgUs9+pcfr4yIO5l7HaQvm7l0iOX9NvfwuoPEhC358
         oA5Tbvkemj2LpPk1m/erFDhARnLH0zPP5VMnes9fPFndOKGsWu8Tas/FsoWZnJYVewo2
         7EgoNvtV2N8cmiKPLqL1ihZj3ARJF8i9q1cqi8puP+VKp013wtPGLjaFiqvpX5I46VZo
         HvbbOzCaNTX6BcS//T/jWSA4IxPJ0ahAwVR2cHYzDhweSz+3AI1GmSJ7G1FE/RW+Lgpj
         Fzvg==
X-Gm-Message-State: AO0yUKVu2zLfIdfm8JbzaT+SHbH//ofCp/uIFgGP9/CCJpB6KKm4pvKv
        A2r7yMSgY+DxW3QsK3xyTQ8=
X-Google-Smtp-Source: AK7set+SMCkfnKnwa2jTlPNVxI3n2/ZNzOCSyLdbf8EJ+RJnLnPObAMjeo+9lyyUwQR/ZBqby+7zmQ==
X-Received: by 2002:a05:622a:120a:b0:3b9:bf2a:1364 with SMTP id y10-20020a05622a120a00b003b9bf2a1364mr19177520qtx.55.1675454632008;
        Fri, 03 Feb 2023 12:03:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm2421840qkb.16.2023.02.03.12.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 12:03:50 -0800 (PST)
Message-ID: <3d4042de-6178-2fab-3bba-5e08b25a93d6@gmail.com>
Date:   Fri, 3 Feb 2023 12:03:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101007.985835823@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 02:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC87957E622
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiGVR66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 13:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiGVR64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 13:58:56 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3635B071;
        Fri, 22 Jul 2022 10:58:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r186so5034268pgr.2;
        Fri, 22 Jul 2022 10:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yP80Ap9BO4X3h6F0p74Cv/fRgqrRBzkiyWfZkBD9ml4=;
        b=RvTeccMPfqy5hAjof5arU3LPVuiy0myuTSR4IIVGIcllh8kR6S9rpNk43TQkaDIe5D
         8Ywv1SrIQBDiS5EHLGLX/jHhLpOpVeTqI05ZYj74EVPQH4JJm250eEXgMzV3Uv3/STHD
         AkJGnM2T+DRgo194HyzsTmxzozIpuMwsO0VQq7vn05Pgh5IHBOxcvfJjXkcwkICE85EF
         s4q5oVCr99ey1MTNlI8AtD151yJ/6fvETP6d9BA3RC0q2aSALtuRoNvc9DlFwCxriJJX
         uZdGAuwMeudTeDpgvcWKq3vn00l5oTqfpu/77YeCZHTd4Gq90Njiq/F80PBvX9dSLEPR
         xSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yP80Ap9BO4X3h6F0p74Cv/fRgqrRBzkiyWfZkBD9ml4=;
        b=roIVfjpkaRaSfVq3RUZCDTBDAv+IT3T38gshJ7pJMKa+Jer6iU7Yypg8CtC2B283PY
         46npu0pZbeV7qpBKwAWmJIeYZbpVe/vBK/ehDloSfeSFHzfwi3Qt3SCVZrvEefTbKDSW
         FG8dQi/IF0hU8P1K/D1vmQhYQ36JDdJpY1U4yJc5nN/DMf3ZbzlgDZL/aVdGTNx5AYeB
         40dtJbVFBCJr9whHRWhKtBaV+5Bb0HlY/eSF1E32JI3PWdrmyshbzwb5L305ERywDvv9
         uyotvd8vFStWtfFE6pgKpzY1EYQBfyPGwVMMGVhju6eKWzM7qS+Bl5LK/fWjDkovSC/r
         AXPA==
X-Gm-Message-State: AJIora8plAHv2DtWXdyoThxry5u6MITvdLDFV0UdbY6r1ZMXGV7Lw7fq
        Jm8qiI1C7dtKUbEoVzIRsUktFMcW4E4=
X-Google-Smtp-Source: AGRyM1tl3NuZQzsYQYMvQ0yl9RKeNoje0dURon+lm8/wwfm8alVxurwlVCnNwbUFjFIGKmIL2FpFlQ==
X-Received: by 2002:a05:6a00:2312:b0:52b:928:99dd with SMTP id h18-20020a056a00231200b0052b092899ddmr880292pfh.77.1658512735564;
        Fri, 22 Jul 2022 10:58:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k19-20020a63f013000000b00416018b5bbbsm3771898pgh.76.2022.07.22.10.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 10:58:54 -0700 (PDT)
Message-ID: <8b1aca43-df8b-381e-b3ed-36726496a70c@gmail.com>
Date:   Fri, 22 Jul 2022 10:58:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/89] 5.15.57-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220722091133.320803732@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
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

On 7/22/22 02:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.57 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:10:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, and built tested with BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

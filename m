Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4785B8FD2
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 22:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiINU6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 16:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiINU6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 16:58:08 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F8C72EEA;
        Wed, 14 Sep 2022 13:58:05 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id ay9so1458351qtb.0;
        Wed, 14 Sep 2022 13:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=QNU3ln1m6W6H+Eth7e7mlIos1/sGM3C0dnTwuXYoTvA=;
        b=FMH/cvvebYsqhplKsDTk3ABRuiJDLcdC4LCeCCnWPhgF+b+OhuH4Fo4pJ1TPMSC2Z0
         lByXtMtJ0PK59wzS1Nio5utKs52mVdLMyD3Fq2sME9BryQzm3yQOR1Pdls93IEhQJbYR
         tqJGKh+UbWX4JuWfNP1oX4mcXFHaT9lV18CzcsVgFuRV4Lw8N5Khyz3hDuO2tYe6Ob/a
         VDuiOJGPDijVyvdXYQegJRTs7mZ+dsSCXe9x6dvm1OZDeSdXCfQU4/ZuC1ALpZP0o0ON
         pIGDuicIJGpFIq7OKNKKs3JkgfYQOt4TUrRNtpUKBdAEKO5+jOXCi9I4a8qyw/zaijrV
         C7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QNU3ln1m6W6H+Eth7e7mlIos1/sGM3C0dnTwuXYoTvA=;
        b=qdZa1yAMmq241b5GWBQBvLjmnbzK90Hkx/w4WUAHqZ0uyyzJHn7MsuynDBo7NAn0BQ
         hpIe21vBa5i7GehozyPoLlO2ZlAMhil1dKf6HBTxadgO0nrJ8FlflWgfeQqSBWHf1hSy
         8AMYvs2twErgdjZlknZtNrp0rj8tTiOXrEmHUlJ1cPqA4YZdsXdMVCjHDQMQLqpPnNUw
         aaPwNo3uMSR8lh20Q4L9HoWuMqvpeXqBzT2bAkdSfRtQNHmu6Sg0uq1LZ+Br5j94BxbH
         a1wlBnIlgXieKJNzSthH3qCV8AwO8wf3JammzvZWJjn0kSQs5HCM4TUVkunB8Ns82biF
         r3SQ==
X-Gm-Message-State: ACgBeo2V6MILYNNpfyjC2hMarBAFze+ZGj77yYII/+U7F29PaGqiNktj
        9fEiRNsTEJM2xrLIjy1mpSs=
X-Google-Smtp-Source: AA6agR7wzPt99NL4xF4nkAnkokatcyi+wG8yU0lDcJTGpYhkxA16atdfLImZN2sojQX0wSx1InkrxA==
X-Received: by 2002:ac8:7f0c:0:b0:35b:b013:3913 with SMTP id f12-20020ac87f0c000000b0035bb0133913mr17478887qtk.39.1663189084978;
        Wed, 14 Sep 2022 13:58:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bn29-20020a05620a2add00b006bb2cd2f6d1sm2388308qkb.127.2022.09.14.13.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 13:58:04 -0700 (PDT)
Message-ID: <567c5034-2ca9-b57d-ba28-c4ddedde3f0e@gmail.com>
Date:   Wed, 14 Sep 2022 13:58:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/79] 5.10.143-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220913140350.291927556@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/22 07:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.143 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

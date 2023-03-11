Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C036B5FF7
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjCKTE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 14:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjCKTE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 14:04:27 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D75138B4D;
        Sat, 11 Mar 2023 11:04:26 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id s12so9319092qtq.11;
        Sat, 11 Mar 2023 11:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678561465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qE0OcNZaMEXby/ysblshEvseorXKx079Qg+DU1Nr8zQ=;
        b=keJUH41NJmmu8PGPmrslVCBBRyiiDrTtdCiJsKMtY9lalrOtdptUgDKdhFtmoTWjca
         MTkslRZRCjbv5JjeQKvv9NMxsMfkX8RpH7uCAIoOUQSmlJEyUAGLj0mxBTSy+NszNG/R
         955GcGS1uAeStSnlztgwpiojqL3x+ERifENXdo+PkKkCkLnsAbxxzzjfExi/cDr+CSOz
         CzC2r60I7zyImGyoPzcMBsxN0QbgZpWeQxMuEfdNWTXW7NFKuKKn8EYPw0pNitu1SAZR
         NOAJ1lQ6/SIw061axTq1zRrIxbeoihBed/MEA+RKQsVgxPmfjqvNTdQz7QFXCDe0bwYW
         xK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678561465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qE0OcNZaMEXby/ysblshEvseorXKx079Qg+DU1Nr8zQ=;
        b=5vrP98nlN/sfh1F/4vT+21aSO6FNs4hEbZ2LpENa9YGL+ZENdaI2HNwyr9F5bMKSm0
         JMZMWhOClImjXcS3EsQof6bAceSjxuUWUIoJd2bteEepn2PP+M5LLWKy5eTxTWCEhGgb
         68AiSQ+NSsmdQ4SkkwMFt54V9zzkGdpBMIVAEHLPTq9LnQY0kOwBJ95TSEIkczcqctvV
         Qht3dMDHrVC1IYjKS446u3JHshPtFs7aT/Gt1ryKGSyP9MGIwhSZpqRKpQER1VeeLWyN
         z5Juz5qAWAcBp976T5X4qZL8usM8hnoNKj5WmT/Ro6IDth+Us2x+KlXlJxZHKbDPlnQU
         ZlcA==
X-Gm-Message-State: AO0yUKWRCP73zYnokSYmWdXpavKiTf4eDt3qu5qehOhD7eyf2HzkSPRj
        M9YbAA1RJJ9aJ5mqMgBuJEg=
X-Google-Smtp-Source: AK7set/d4L7vjLFMlOnUEbiUnoegZg98ozf+vnvbAnAV3hai2jR2SkkuiB58i1WP/wWrtAOtO3uEgw==
X-Received: by 2002:ac8:5e0c:0:b0:3bf:b1d6:359e with SMTP id h12-20020ac85e0c000000b003bfb1d6359emr17101800qtx.7.1678561465525;
        Sat, 11 Mar 2023 11:04:25 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8524c000000b003b643951117sm2310575qtn.38.2023.03.11.11.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 11:04:25 -0800 (PST)
Message-ID: <dd822d2d-2a17-57ac-8fb2-b572d2be5296@gmail.com>
Date:   Sat, 11 Mar 2023 11:04:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 000/356] 5.4.235-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230311091806.500513126@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230311091806.500513126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 3/11/2023 1:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55497531C2E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242488AbiEWR7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244923AbiEWR6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:58:25 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8546BC967C;
        Mon, 23 May 2022 10:43:48 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i1so13747251plg.7;
        Mon, 23 May 2022 10:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ivib7VFlqEFV3T6yOLSuIMwOJhz9nKccU2CcQ8jtcQw=;
        b=g9OEMUvo8OUmjc5Ds50SsbhUo8Rnvy1iLUnH+CnMJwf80LtJAaoHtYdMGvq2dC62Dj
         4xGRWWYnkBJu89PYejPPVHM9lhsuUJvgieMqSdcuSOR8rhUhNZw1Y7AoK7ofbyhkLfRk
         mT74gIQPA5d56ga7dbzwsROs47j7y97Yl3kMe2z0Sji/Uy3poLLL7wXsAy2Yh7nth85C
         eVLj65RPku/OfQslWAeJJME4ijz9SHL69lDniv32fLUSjGb3AHk/A+TaZblJ8VhWEqeU
         ym/EPQ//ibn6V+yrHr/KCRwR+Imu84iAmtZQInzv7ExMselfmG7HlUsRyLDKeufNdlNz
         gFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ivib7VFlqEFV3T6yOLSuIMwOJhz9nKccU2CcQ8jtcQw=;
        b=WDumduW0EDBkMLeWzsLICcEsl8PQk4qMX1Hmy8Ea17hb+9rCpDILbiSgLJ4eD2qFa5
         aWeeYy7+Ny7Sn4EB/PwsVtH0nWo46X3yYKti4ho4DiYS7gSR1PdLFcOco/Xex3rVPCIH
         EaMWDL4k7DPTdFtAohM7vG8MPCWWQmgfAexEKtdvwO9Fz8KPJhRZbRBzavSW5JZvSxia
         VSaPuwC9SeRW9L7LZ687ECT16WtS0OUwUYkly8f4dniyGm42dYQLV5m5CWNg2c4oKT4R
         tVlSW4O13rdmvoByFXwSfswrqlugmJxru5Fb7Qv84+P8BS/ECPP1TSge0wCUnSMaeslP
         ON3A==
X-Gm-Message-State: AOAM530T46tRIuysUHtqPgdp28BWAb+8F07GpgDasY88LhFcX9S5V59r
        ZlnXU06QLvwohk1OPVzai9o=
X-Google-Smtp-Source: ABdhPJxry+vi7tKDKvYx5IzGTdMtYy0svSYmvgvtBEb52cUT0Zkqz6+eEKalPNwS00U4U521JrJ3Kw==
X-Received: by 2002:a17:902:ea04:b0:161:c283:8c0b with SMTP id s4-20020a170902ea0400b00161c2838c0bmr23789737plg.52.1653327825252;
        Mon, 23 May 2022 10:43:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o13-20020a17090a4b4d00b001df264610c4sm324299pjl.0.2022.05.23.10.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:43:44 -0700 (PDT)
Message-ID: <7f7c58c2-68a8-7f73-58cb-1d2c229e055d@gmail.com>
Date:   Mon, 23 May 2022 10:43:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220523165743.398280407@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 10:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.316 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.316-rc1.gz
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

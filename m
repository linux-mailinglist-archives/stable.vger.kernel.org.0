Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0705A4F47E6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347075AbiDEVWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456020AbiDEQBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:01:01 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9086310EC47;
        Tue,  5 Apr 2022 08:21:01 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t13so11254501pgn.8;
        Tue, 05 Apr 2022 08:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SHjhT11QJLGtZsbv7qutvvrQlP9cOU0JDI8HIlLfHA8=;
        b=BImjb/zPCWU/GtQJpRV/yqeubbJF5ypno1NeNwhTEXo8vPmqYMz6DvBlPk/zUBBw5c
         T5IITVFyGQ+MDKrGLLwVHQNSq/E0SPhVukYnTrQNOPqPnUvyXG6QOP5xMrtl8WUCYtRx
         z45tfIo7bHNHHm4Vk1Go3amIyrg8xaipzA4DFXJGirfc+Zr6nWp+Wt1Qu1w4AYHBK/xT
         J02TVcf9mtsbzLmWznVQO5ubfTxkWSQnUefkTjuJVVH7zaxlBitXzaQSPOoB5TM4fJD4
         qSU71L8XLWLKLDhcc92wDkUmv858NfrhuM4n1XRY25ETjuvFmZocrTSri8bBYLUYROMv
         1DLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SHjhT11QJLGtZsbv7qutvvrQlP9cOU0JDI8HIlLfHA8=;
        b=IY21whEiPtFmFUAIFCagiLyheSqZ+/M7uUBozskibr/xu4Hh4xROzX8b1W5DEkgKh1
         N9wB8uIzyYk7Iq9HhJRY2cWc7WjBnoFR5f5C5NprxA0WrOiFJiV5QcTxW3PbkxbNGoSS
         zVu4eyBSuWiMhrlFeGOpK0Fiw3mb7eV+T3y/Ed56cTHkIRhcBiCg3JSZaSPdAen4YyAg
         UwaqWJdZVG4bvpKBeBGCJygGX6I+xHyfuAjBqnfKYgdlC0DRuDggD1jGK8Aa6X4UFVFW
         I5DopghFW5KmA+DsmZffcuFxXTNJ7YUkUXOI9RZDROkLUBAtIztYV9VL3t7coGmBSZAx
         au5Q==
X-Gm-Message-State: AOAM532lFoa212xLn99m6xPcgR6Z8D1icfuTBV3L+BpxBFkcdaDvSeTP
        rQUbPrhlw7cP9iYbx5rQZVE=
X-Google-Smtp-Source: ABdhPJz10LK9mWNyLvcbGinG5G8znu+dSHzDYS9oaSkAHLnI/2WzAA5N6RpcWr6EzDHfBf7CzL3d9A==
X-Received: by 2002:a65:410a:0:b0:399:38b9:8ba with SMTP id w10-20020a65410a000000b0039938b908bamr3263236pgp.526.1649172060727;
        Tue, 05 Apr 2022 08:21:00 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q9-20020a638c49000000b00398677b6f25sm13859264pgn.70.2022.04.05.08.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:20:59 -0700 (PDT)
Message-ID: <3820a75e-95d7-b6d4-73a0-159eec69ea13@gmail.com>
Date:   Tue, 5 Apr 2022 08:20:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220405070339.801210740@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2022 12:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc1.gz
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

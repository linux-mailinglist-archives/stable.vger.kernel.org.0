Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452BB6050CE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJSTxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 15:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJSTxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 15:53:23 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C401B94C0
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 12:53:22 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id 137so15424233iou.9
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 12:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BCibXGM8BjaTX8h8C5G0AVWFfWXcZVSN1fPhuLtRFnQ=;
        b=Ub9K2irnUDoE9mYoaAfxSNqMh3deb8WiYwMgR9KH7Gp+v1+QIlbVFyG8oJ9zNZHs2+
         gtFw93jRWib6moWCejJJVug+ZTdwf/PixWdid5dnwB5hJXUMnui4rH35gXk0u7Os1hHi
         KKPfcgWk6V2DlGtxWv6dDEjLoAGBngO4B2Rbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BCibXGM8BjaTX8h8C5G0AVWFfWXcZVSN1fPhuLtRFnQ=;
        b=pu/UemLKnakutJCDjRn3pDxml9Kh2TNvWdb0gvV2NQMDb9Iwepfv6oqEllTe5TRuke
         QJ27rDVXhX0htGiPqXy/b/HupTJAFsZKqPXYorSh9TwUj5W98HK5C+NEagn3PMmE2x1B
         JTBky0/hZSDTRoBuXOp7m5CzJnDxpj7IxFCqmrKghHSwiTQ9kwo22dBvO/FKeJ1vaxoZ
         L4ROBmspKH3VlFPgS+9S4MB22nrAgY0zFdj2Cl/PxaHPKQLV5sFUBrQ9XJjV5gM0M5+y
         vhcBDrsTrTMnBcBxZtLpFh3b7fuCZuwxZKzzQ0axtM3/sX/F3pJAYsKbbpxbbvghBGET
         N+sg==
X-Gm-Message-State: ACrzQf0YeAFhWJ7wniGFHSWxFMUrPkhkVXSV6Y+rJ8FxqlT1cKYpleHu
        nhAetzIelcjc8y/vmwx+ky5sig==
X-Google-Smtp-Source: AMsMyM5lY+OxrCuHoED1L6CgPdpvjcpOYENUeUfX39IOn/sFskzbklkYmaJrJRLUY0kbKtFhusZiTQ==
X-Received: by 2002:a05:6602:3409:b0:6bc:698c:cfca with SMTP id n9-20020a056602340900b006bc698ccfcamr6162818ioz.98.1666209201548;
        Wed, 19 Oct 2022 12:53:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m25-20020a026a59000000b0035a498d222asm2383475jaf.35.2022.10.19.12.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 12:53:20 -0700 (PDT)
Message-ID: <7a429f62-c836-c657-3e1e-e76f81011598@linuxfoundation.org>
Date:   Wed, 19 Oct 2022 13:53:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 02:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

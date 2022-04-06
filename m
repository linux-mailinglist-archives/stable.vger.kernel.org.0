Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C04A4F6E74
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 01:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiDFXVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 19:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiDFXVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 19:21:45 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25288B1E8;
        Wed,  6 Apr 2022 16:19:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d185so3429540pgc.13;
        Wed, 06 Apr 2022 16:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=scb+EFv0O9L5AHSjwn/ieVHXGI/pTMCAdAUTx3Lib80=;
        b=VuX8J3/0J6Rk6mOLxMDQwfoC32kv6sL2zFLfbtBHOMAGb8Oj2W4lJhBlXNj0nAmKtX
         cbvgV2Su4Vt8JVEUb5MYPwyEC0ojmDGnGnsbtS0fM65FJ5W8rAoHXeKHTeLxE6nm5Dcd
         xxvpLh3r1/UiJv805tz4FoEOiTMMBPMSovP+z5rEq4oDMPy2s97md/6rvRrBhpeItz3B
         +cP8VUaR4M23LwNFckVCxlTpiYQQeXqDmRkY+DAluFLC0v7PLwqqjVFFbRXj3aOqkZlN
         Iwyk6ZQm8ImiS4nnwEsldNzNcYKngiDNi058rpioDGV0gKd2N24A0WTKg+EjlxaB2kaY
         AhOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=scb+EFv0O9L5AHSjwn/ieVHXGI/pTMCAdAUTx3Lib80=;
        b=HLi6t93aapqXhpPtf7aItOetOiiBZdz5+B+m2kroS8ylxvkLNuybvR9E+RPGb/0NJi
         ZcKnOyyl75uDjhQDslJbvm1GEaqjRnNpN1TZV7E/JqhtLV40DclsuSaE1d7cf6xYgSVe
         kV2/irKYENHE28C466/lRxOv759CSGhV+xt8kmdh9wIcdGWleVY2WajOhWkjwbwIq8uc
         2HS6rIGMI6fu+P7NHobk5Oa0eLjnwSqiExNHaiOWDOM/Ix2geUUeJD6Bctf/zBmyL4bX
         8Xr0FTrPXSPBrQiX43vnJy7xnDeM0zu2IqOcf7MSEQKUCIALwm5Zmor7ctBABeIjYIaF
         3gKw==
X-Gm-Message-State: AOAM532n1SFZyE4Px2jwQs3wtxXDl2QDl2mthZmKtS8zWiInoxG1gA18
        srjci8KYDy2h/9hRwwdWHjg=
X-Google-Smtp-Source: ABdhPJwKeX45kiX4wqdYVcw8s2O8Ut4aVXCh4roP/1Uykz0oxXcTU5KU84XrbzSAbza+c/oWpUDK0g==
X-Received: by 2002:a65:524b:0:b0:383:1b87:2d21 with SMTP id q11-20020a65524b000000b003831b872d21mr8914334pgp.482.1649287187589;
        Wed, 06 Apr 2022 16:19:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9-20020aa78009000000b004fde2dd78b0sm15518822pfi.109.2022.04.06.16.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:19:47 -0700 (PDT)
Message-ID: <15aef752-b9b2-22b2-d52e-51cdc829ffef@gmail.com>
Date:   Wed, 6 Apr 2022 16:19:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/911] 5.15.33-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406133055.820319940@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc2.gz
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

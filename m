Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AF74F6EDA
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 01:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiDFXy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 19:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbiDFXy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 19:54:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BEB8985;
        Wed,  6 Apr 2022 16:52:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m16so3397638plx.3;
        Wed, 06 Apr 2022 16:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r+AJnZmtL/94cnhZUExYGxNPY9M3GNuqxYk1e1LNnmo=;
        b=S/PvjKFn3am+HFflZlvhxXtHpPUGFOTQDojYthhKLSjHy1R2eycZaZtcXXiAfYjoXb
         +SZjs14eVZqA1R+V66FnA0JWsPHWJWi6ny1aNAN/PihFM38594o+ytxWN9uSsD3hTxyV
         q+gOli0lzESvV8hGmrDy+TOIbghE4plYH3724fgCt2VCfLqnyfenNXee13e41q+0JfzM
         8pYj0b6jcEYZ53ctkpp/kbw6l8ZIXY2PxxlPArmQgbw3mcIPH1vsHuGgx7PLwOWqjF0H
         9ym7PCIo2s3Zl0F9KooPkHXmaKFE7VRv7kHzhSN9ic0kus7bYnpD9uc16sZLVh9rVY3A
         4BHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r+AJnZmtL/94cnhZUExYGxNPY9M3GNuqxYk1e1LNnmo=;
        b=Y0ifR8gEc9FteJv/BEO6q8AmkCguGriPiCXR/RfgyURIjNs33HWAl0di4K/8pyqiez
         S/pHwXio+RI9lv+NUdrBwQxPlJZQ4cix60ChFslE4hs9clZj/uk8xLs0pr/ZITYD1/zM
         SbJVRTZg6qtMW0RqbWI5Ir/1tZIPlezX/gC9IlVuRsFzu3qGS5dAm7uWTWD6jYLR4YMn
         i9s6QStZUKyOu2TPWbAVyV4c98EgXRp82poEjfQGe9Kkw6CrVrrm37TZfn+aUGraw8Ep
         0nxjCDNjD6uTgb89fElfgxJ8UtZwlmxHDud4RHv8cvv08duVdYlvgrHNDQ4TVEX9czRo
         BXOQ==
X-Gm-Message-State: AOAM533WAlkBBoZY7W+P3xH7Yb19wSrH+cNm/GOhwLi2Gy0Fw60zhpMK
        J6LX5xa5VdTN/TwxY8l+dEk=
X-Google-Smtp-Source: ABdhPJyU5D9/QfIPg5BvIqZ8u+Q7nzo+4n5rMdjoqBKH+MXB2EBvqc6tNEdf4dmec3CAYTRQyPiQZQ==
X-Received: by 2002:a17:90a:d082:b0:1ca:be58:c692 with SMTP id k2-20020a17090ad08200b001cabe58c692mr12682136pju.238.1649289148749;
        Wed, 06 Apr 2022 16:52:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm20607467pfc.182.2022.04.06.16.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:52:28 -0700 (PDT)
Message-ID: <e31661a6-da81-e121-e353-fb3749616742@gmail.com>
Date:   Wed, 6 Apr 2022 16:52:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406133122.897434068@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

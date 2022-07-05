Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5749567698
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiGESf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 14:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGESf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 14:35:26 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27E81B788;
        Tue,  5 Jul 2022 11:35:25 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id he28so14979887qtb.13;
        Tue, 05 Jul 2022 11:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K3ANGA9COA4MMtJSmut/YkX0sUWRxxgBhif9VA2suTA=;
        b=dRjpV3OGUyInIAavU/wGrYhLBGs15X4rwm6uaD3AoPly8lK7lOnIIxz7QiNx5NL2vJ
         iOFbIfAn098JKl4I/eGvSaByIJWE6zkzmTEFEkO8hTB8hu4e0pE6tfXVyS0/guqDKjcI
         wj4L6djr7V7O/f6bl0FQ9oBNmK6tV+A3waPeI19ijckjrVL8QGSXEwDJ0Zo4FHVfo8dM
         3jnCpKOMekykUp6T+zI6g+b7gG5BMiHWtb3REntdMYmRmYFAOU7FebQ4SR3hZzxkaT1n
         DV671cAFoG3AuCdCN4SzirgG5p5zoNc6pljSbg0vI2+wNQYy4rpkG/cM5kljWRd1rTOW
         fyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K3ANGA9COA4MMtJSmut/YkX0sUWRxxgBhif9VA2suTA=;
        b=gO+/dtGiLuxhaEYq4WOZtBGl1Aq8y1JCW1QvMEi3zNKUoRMzZffHUMmL+GWO4nGsUn
         pVklRPfXf6HFYGj3NuRQ3uBfrz9OnZLOQYKyrGSJClNo3ZQipEgYvanPPoGUUpRqy5cu
         +VAW0gMIhXkFYezmqo1EZGbth4cWddvhhomT20tSe6eMp3FS7I9VQT388+LMN3TkX5hl
         51/cldBXWsKZKERduHJPnd6mpqpCsxkXAvZ6Utt9AVRdzeEWWoZmv7OZqNXRNVjccHt1
         oYLCQ2q1ByfoAyq5UlRf+pjv1BaLf9BxrBH5diTTSFRKcUWKU6xFzCtTw2IdNuhGP1eC
         gpJg==
X-Gm-Message-State: AJIora+rhkXQDEqbzZbJrWNFDd/XUmYu08sP5OeGqeHjY2Vx3f+VSm2i
        hf3bSMudo6WdTTh2D7R/xVk=
X-Google-Smtp-Source: AGRyM1tWkSs0rL0x/2uCgQ99Rqyx8vX1BGmRGeQy1e5CHMrlNDKCgYSIvhwgtbzSsM6kp6TdwRQQVg==
X-Received: by 2002:a05:6214:62c:b0:470:76ae:2c17 with SMTP id a12-20020a056214062c00b0047076ae2c17mr33773323qvx.65.1657046124751;
        Tue, 05 Jul 2022 11:35:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c21-20020ac87d95000000b003172da668desm24738257qtd.50.2022.07.05.11.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 11:35:24 -0700 (PDT)
Message-ID: <e5467cb1-f7aa-7c19-d8ba-a1cb928e38a4@gmail.com>
Date:   Tue, 5 Jul 2022 11:35:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220705115617.568350164@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/22 04:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.53-rc1.gz
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

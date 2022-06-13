Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6568B549DF9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiFMTqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343577AbiFMTq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:46:28 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8208BD12;
        Mon, 13 Jun 2022 11:17:09 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x18so4485847qtj.3;
        Mon, 13 Jun 2022 11:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vKBTWT2t0pRElLYCpXCdoYFIpCu/cvvhJq5EFQeXmYo=;
        b=AeYlsMDOC/rXLlvvbKJWTbmacAYzsVAqk6QuG6dnu0TjLGUuuZV3z4uus7hC8ZmHqY
         D5Mnq3kngAJhauKXekYLKS4FBK/9tq07O2Q56ZZ1IznMgLxaS36DhQOak89VubxZ2G7z
         X/IgzJ77xgk47hJ9GIknS9gyeOt2NsjrPBRtJzu6shJ9q1Pv5uxdkoz32xwVs49EbYYx
         9Y4l68zumwrwdLpJ15S5bN+/CitR+LuNoZv3Z8DOP0DeoRz2yipxAfgXgyVP1veJdYXa
         DalmJBuvFY7V47ZK2cUaERmPPLvfxESalFXJ4liT7GbNio/dNijEJ6dKQtzqN2hnTgP7
         k3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vKBTWT2t0pRElLYCpXCdoYFIpCu/cvvhJq5EFQeXmYo=;
        b=DNlSg//c+Juy84cNAaXXu+2RF2/UgruDQBWQy0IwyZSrf0WHg1EC5jBaHDguQRBabb
         qsuwHf1kd6KURzrlpPuHgk5KeAFNVV924elUpyYJZfqqxdhe6VhckBzxw6PRqkRD2dWp
         LuP/TqnG0FGg+lQGU78tkbHJvIRjbfm6I1J1YqQmuGrSvrcljzo/AXCz+iwAZJkNVOTM
         QOJ6E7Bt9zHMxu4dT5iNBQxH1TRS9t7J+ye1LD9ktau51SJ0tdv6lyqas1ajG/02kpHv
         d0rKN2I2BdALxlX2wRtNH1/5ywlXzkTbap/jnqh9WCbqJPSvWQQZ6sxX+9Mggyw0WGKn
         3d5A==
X-Gm-Message-State: AOAM530uiPfJ2+9CJVUFxK2GrZItqArupUKn1inZVVRxEjlzqp5gIsAm
        /BIdSZk9XCUV/V25vAUIet8=
X-Google-Smtp-Source: ABdhPJzmxiV3tVotroIf02RFbp8479CyXPytnqJJZqOWYCML4qno8rrqPrIxfD8qCIclKBCVZwgoKA==
X-Received: by 2002:a05:622a:514:b0:305:21a3:fe12 with SMTP id l20-20020a05622a051400b0030521a3fe12mr940301qtx.107.1655144228632;
        Mon, 13 Jun 2022 11:17:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q129-20020a378e87000000b006a6b564e9b8sm7026449qkd.4.2022.06.13.11.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 11:17:07 -0700 (PDT)
Message-ID: <0966f3ab-1f19-962d-deab-dbadf83f6971@gmail.com>
Date:   Mon, 13 Jun 2022 11:17:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 000/411] 5.4.198-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613094928.482772422@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 03:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.198 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

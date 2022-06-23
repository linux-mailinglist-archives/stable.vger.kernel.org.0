Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7BA558984
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiFWTry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiFWTrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:47:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C15D2D1FE;
        Thu, 23 Jun 2022 12:43:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so634909pjz.1;
        Thu, 23 Jun 2022 12:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kiYpj+ZmshcIx8l1p+ChIrAmf+XyoyuQuTtPGBevYh0=;
        b=pu4Mlx9Sw+h0H9905BmZ61ZB58JvBLjq1uyG6wTqWSJUDzN0S458J3VzrRFU4ubgKZ
         ZwzLes4NxNCNqg9zXCWJoVBuYNnFoj3t24QUU3n99DZX4znyWHqAin993+zJaE3sWLBm
         auydsjkWa6P9U9QfbDGRO0eRCAhQAk3p5W0DL1QlQphUwOLQgTFuvhyE4wyrIZnAg50q
         9xTVe9DTp64BFnSjNHQxHKclTO53aiUh/sytZecnI9WeW4V+S5XyiNaKotba3aBLLj6a
         14BN7h2+omoZf+9RdaQ+EXPpf7ZVJF/KOrQeXTaDY05V+BXGgGdgR67wpULuEsxbpTVC
         YaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kiYpj+ZmshcIx8l1p+ChIrAmf+XyoyuQuTtPGBevYh0=;
        b=nd4oBn23Ultov6n0hSLSkB0IdXpTjFo6Jxi/wSuvDdcG2Y/ZeHizUP5nh02PPY6Vcc
         GPLzTwg8mPsOa2VygAQQKC5Ms2vhBdz7oBSsu1toSURa+BQBAFQJbQukpVoUnBMS78Ae
         gAj7P6UVpBy4egjl9TT3YjDmM4hdSt719g2/9EmYIGSKqikt2R2X5XvbpmqDk9ZUyCi6
         vetKpgwF7O4m8CdRGExd6k7YRcHzbKZUpjnHDFwEjYSaNGGoD+GLd04cFS0Gp3sU7jTB
         eZQZyMmhNgYDB2N0MgBqWgvNy9R2qq7IlfTIoiIE2yBjsBlmU36PVrkDqRXiX715t+d4
         gmEA==
X-Gm-Message-State: AJIora9AwvshuwSSDGfaHxyineZfFDHX1prM0Gvbcz2fymWeAMEdq+9e
        v/Pl98xm2Svne6YiDkgDeQw=
X-Google-Smtp-Source: AGRyM1uBD4XC6bBzhJZ2XNLjYvRFGOqzmQbKTOFT0wTrUvjbdL2cfeTlHahxydKfvkTjqBoenW3MqA==
X-Received: by 2002:a17:90b:3e86:b0:1ec:fc46:9e1b with SMTP id rj6-20020a17090b3e8600b001ecfc469e1bmr5622365pjb.155.1656013400989;
        Thu, 23 Jun 2022 12:43:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id rm10-20020a17090b3eca00b001df264610c4sm8710764pjb.0.2022.06.23.12.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 12:43:20 -0700 (PDT)
Message-ID: <6b090250-85f8-fda4-2726-2f0a222286d5@gmail.com>
Date:   Thu, 23 Jun 2022 12:43:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 00/11] 5.4.201-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220623164321.195163701@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
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

On 6/23/22 09:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.201 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.201-rc1.gz
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

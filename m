Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EE85B1470
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 08:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiIHGLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 02:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiIHGLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 02:11:44 -0400
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7AFB2DA3;
        Wed,  7 Sep 2022 23:11:34 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id e18so22769296edj.3;
        Wed, 07 Sep 2022 23:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dtLo+6b6tvUN1+LUDynEVVO3E1g7B3qjho0q3cn31jY=;
        b=WEt9iAbdnAKq6lKhTrJzkuhXFhq0NYS2ULt0XVvrznXvUwntQIBeYpZcl0G39OYcUr
         fY4scKRzipNQj/nrhJsWBedxnbNW/CjdrRW5NAsvqqwIDvp2yqdsJBERDmpdftT1YWLz
         urOepMCRtCNwKBwK/s6JE9RRCjuqvFZtLQHQIMokmKH1hP7+u5U+iMCrytth/f0WGtLa
         G3v6o6h/HFIVz3nTvXI7zrWgfy+LUqc8B9O28h6oVbmYoZrbwvP0NB6CNzP2J7HsNyHg
         dq4eyIkj7kA9cfa+7KX6QkcLsZ3xuZ6R6vGSEANHk0II2OG8AYAeS3xIkVCho4JW3Bxb
         9I0Q==
X-Gm-Message-State: ACgBeo3N7oBfWm2uhqy/vY1HpdAE3IUtfJrY40MQ6PULagQ/V2ix4q4J
        I1/qhIsXCShEMO0Apv5zWngGYqhRuBU=
X-Google-Smtp-Source: AA6agR5bDVKr6cRwiGnL1sOT1VKCx8uVDLNhLhT3P3jt7FG2Srell/AnCnzFhlAlAwh37ZhH01/RdA==
X-Received: by 2002:a05:6402:538a:b0:43a:298e:bc2b with SMTP id ew10-20020a056402538a00b0043a298ebc2bmr5660239edb.125.1662617493031;
        Wed, 07 Sep 2022 23:11:33 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906394f00b00734bfab4d59sm795966eje.170.2022.09.07.23.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 23:11:32 -0700 (PDT)
Message-ID: <5d274f95-ddd2-9283-534a-6036c14541cd@kernel.org>
Date:   Thu, 8 Sep 2022 08:11:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220906132829.417117002@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06. 09. 22, 15:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
-- 
js
suse labs


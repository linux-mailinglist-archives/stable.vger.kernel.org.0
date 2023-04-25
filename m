Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A26EE9B3
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 23:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbjDYVbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 17:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjDYVbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 17:31:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574573AAB;
        Tue, 25 Apr 2023 14:31:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-247122e9845so4396166a91.0;
        Tue, 25 Apr 2023 14:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682458308; x=1685050308;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U0vA8QVHgUjZYF8qTpB5oq5FSKH9ueIB5qfKOzgv5Xc=;
        b=hPY2LO37GIbtiYPRXa/2siJxIqWLgMyESBN62oAnpjqtLNRYrJhLccrxSIq1UNWjN0
         zD4ViPkefQJtFDxeQuErNIr0xHM6xsgH8jua+VhE6+4mxXH0YJr+kFfqVw8qfA0mi58n
         RVBrR+enrU82OADVik+hyEX2F+slS8ol1A294IGsQSdgsuCd/yjcTwPoX/3k3jnRyM+Z
         gN28H0vr2PTC0F5y1SjH3mT93IkRlkJ8eJVcEcaPyP/EMLWysqxUGv0fyBbqUyMcRvGg
         0UhMM2zdRhHPfSDyHkE+mT6Ma2N2c7+FREBxo2OsxuXZn8UFnw5X5wl8IFH13nX7qUmn
         y9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682458308; x=1685050308;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0vA8QVHgUjZYF8qTpB5oq5FSKH9ueIB5qfKOzgv5Xc=;
        b=LPHXAQeRs85Hf6Q9B0GgcFuUkLCxPY4mpsorZt/V9Lw2Pa2aB3NJjxy4wmaVWKSFn3
         MvnqMJy7e5Yd9BRCEI04vqdsupRceIUJFCK0r6EOjC3pLVrdFURdHg7HBi2LSXdOlwxI
         o3CV+8vQ5iiqKyK3yst3wnwwyOlX/VazXEdLBdboXOK+GT5+LSPl/3U2N3qR0Ku0NuX/
         bxtd6gsJXvNSfnvOopZ+BiN9iA96fxMFxJOHaoEhE4AqHw/Ph3Lq0j2bXTNDNSrQlQ/Z
         gDMQo8H4BVdrWFLvqRhOZNsXt78PY8vabRKkM7q0D5bvxYRFAUll6KESgkJXWb2Qj3cw
         y0GA==
X-Gm-Message-State: AAQBX9d4AjywHjLM7T63av4XCahYeXGVZ0J2pQzSM8t9R0P5iPzlxLQd
        Q3CfiKuCZGAN2A5GVsk7Pnu8XxAAEGVm2A==
X-Google-Smtp-Source: AKy350bF25AEWPOXQ+bACbox4eVWJ40M5EawJIvGlxlrMteGmyzBOuqlmqCY+G4YxLtvcRS0w0WdQg==
X-Received: by 2002:a17:90a:9747:b0:23f:b369:c159 with SMTP id i7-20020a17090a974700b0023fb369c159mr16787769pjw.49.1682458307691;
        Tue, 25 Apr 2023 14:31:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y18-20020a17090aa41200b00244991b3f7asm12704831pjp.1.2023.04.25.14.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 14:31:46 -0700 (PDT)
Message-ID: <2d1346ca-a82e-d297-92a8-1fa0e5ff786c@gmail.com>
Date:   Tue, 25 Apr 2023 14:31:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131133.829259077@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/24/2023 6:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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


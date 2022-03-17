Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236914DCFA7
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 21:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiCQUuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiCQUuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 16:50:16 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83671C392B;
        Thu, 17 Mar 2022 13:48:59 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t14so3566295pgr.3;
        Thu, 17 Mar 2022 13:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8yBDL7EAakc//ezwXk8ah3NmVfo+0zdt06qvmpelSDg=;
        b=iilkIs/Y7o04ZzCcRkJVRH/+ZswTHqd30N2tbeX2C+Fol9ygACjINvzrqVrtKvthQl
         sPRCQHpqaxFPkeYYX0U/XZcWgMEw6W7ysWdRV6cyLQRxiS/qJ89jmbvmbP+Q4WfhTCG+
         4zWDRwUGG0ZNP0ZvdlYIHg1HuL9lykpvsAcDw1CzOgh0trFTAVX7NFZck2d4UwKVMhlh
         gzyuqlkdM+CJzzJiq6FJcMRRna8JIaifsHksFkR9oHj6NMG7pdrU81PRqNt+Xw34Y9JD
         8Ko221dU74kymQyK9USFEHNYNncGlII/1t6Ea6QXPtGNuZyqUmvS9/L2OpbrycMhF+hx
         9r+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8yBDL7EAakc//ezwXk8ah3NmVfo+0zdt06qvmpelSDg=;
        b=yFjk9zPj+C8M8oaRYzQHJosYJStup3O0t2HNzWriXUsdhRaUVEhVw+xmNEhkKExAU/
         kp2gVC/+cfEjNom1ftcp74CaRqnaR+xFZuVO1V6OF1EDrAobDcfKfw9gZV7syeDI8Epd
         Rryw/hOCMfbw2fpUAFpp6Gll/c3oRZNZMkUBp9VBxTLrlG08z3Dt1EDtIphlzAiptexx
         vmxK/DqzbGCn/ZA1aGrp3JpgmkUUnHFFizjNuYflPO1zgn4KKumZbbjCBIAtSgbGUW2z
         KQkHmY5SssIQDCnD9xwdhkRyG24ZRjLyibtA/EBE+blVNIh8L9hJpYO5zlThBBNNtUJp
         mcsg==
X-Gm-Message-State: AOAM532jp+Z9ZDpbwCyhrmJK6ho/3YLfHpbUoXZpxo7TZpmZbZbr+fRQ
        Yaazkgaoj937RtdzI6x8DW0=
X-Google-Smtp-Source: ABdhPJzo5YSyqe9WF2d0eKkDmU8zffhV7MydaDoz+/2U1IEwfZ7HaNuC8AnAiiiWW7cKRv5S4CgO0g==
X-Received: by 2002:a63:f1d:0:b0:381:8478:e9e4 with SMTP id e29-20020a630f1d000000b003818478e9e4mr5239646pgl.240.1647550139178;
        Thu, 17 Mar 2022 13:48:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g7-20020a656cc7000000b00375948e63d6sm5749235pgw.91.2022.03.17.13.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 13:48:58 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/43] 5.4.186-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220317124527.672236844@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9cc0730a-5a29-6e3c-1087-ec9c94fedd02@gmail.com>
Date:   Thu, 17 Mar 2022 13:48:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.186 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

There is a build failure with SDEI enable that was reported to the patch
author in response to patch #18 in this series:

/local/users/fainelli/buildroot/output/arm64/host/bin/aarch64-linux-ld:
arch/arm64/kernel/entry.o: in function `__sdei_asm_exit_trampoline':
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/arch/arm64/kernel/entry.S:1352:
undefined reference to `__sdei_asm_trampoline_next_handler'
make[2]: *** [Makefile:1100: vmlinux] Error 1

-- 
Florian

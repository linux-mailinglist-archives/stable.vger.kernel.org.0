Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40D860BC0C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiJXVYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbiJXVXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:23:55 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A860C10EE70;
        Mon, 24 Oct 2022 12:30:25 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id g11so6246802qts.1;
        Mon, 24 Oct 2022 12:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mQ5BLyq/Wh5Af2rFK+o7OkOAy0M8fFmgplOhU8zXlss=;
        b=qj2I3qzsZW5PHcuNfqSdA/dkKeLdJxE9Z4hO11ZlvlR/ANGtBrMfoB+7rLJmsT3nf0
         81vXUxVoz2f/qkPpZCaFFHPkgoeOqRyyPR7GOm2WA+zeUOi+i3zNrNMMerZSubs5ywby
         DEQm4pf+zD1WNFAJr6+1yRqAfzaMLhK2lCPva2p7/w7Ehf0cZGZGGMl7sqviypM/8cLy
         6S/nBiSmJK6dtaWnIYRQq/+7WPTr7E75cPUJJOfcnvWf49bnfDjzr8d/6cqYctXzjv/f
         r1vf2Qb+rzZm5CUcn4w+uKj3CsFQy8yVJ6pMumBBQ+5wusFbImlTNJQmJELScCmMdGZW
         Nleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQ5BLyq/Wh5Af2rFK+o7OkOAy0M8fFmgplOhU8zXlss=;
        b=rYu4Cq1R+VNg/t5xRleWjytTbXdpyGp6bRS8+NIAVGXciQQmpr7bxD/nA7IdZ8Afnp
         7upTtE3g83aYavja0k3614UpixY5+qSbHpAwCxVDc7ZS9tCF0oL7hKmKqOpW7O7dsREY
         H4LTgU29jaD4lr9kkfPQNHKkYf4UKePruy/sLULJZqvGxaI2ebBtk7+N7YlqBM8uQRWz
         Sp+WgTcwUhbuto9LpRBjMy2yV0jfNiOhAn/OnwNILoz+IFqrmuYu4WZHhmfdzJ+q14LH
         Pg1p/qD4bNXEVnMcQIFBmFZ0BOxMmuZhfIr2NwVyE6yC52mwt3x7glE0dSEEclZetzSL
         lZ1g==
X-Gm-Message-State: ACrzQf2H8LUr2QCsqfL20806hRXE5G7quUk1mtAjaZhJhI12N6slBOAp
        Iq5sYjGZDdSfxXKd2YO7LVk=
X-Google-Smtp-Source: AMsMyM494rI73ivC7+owwV0guCX3kMWgTdVjtzJW5IC5tzephuhjGYeaWlCtpmd1BB+3Iv/9Lokzjg==
X-Received: by 2002:a05:622a:209:b0:39c:d88f:20ed with SMTP id b9-20020a05622a020900b0039cd88f20edmr28279111qtx.131.1666639718759;
        Mon, 24 Oct 2022 12:28:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bn6-20020a05620a2ac600b006bbc3724affsm523322qkb.45.2022.10.24.12.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 12:28:38 -0700 (PDT)
Message-ID: <ed444438-8a97-60a6-fa40-954c81ef4de1@gmail.com>
Date:   Mon, 24 Oct 2022 12:28:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221024112934.415391158@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 04:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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


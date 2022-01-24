Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E884749AA22
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiAYDeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1323784AbiAYD3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:29:41 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F223C03463E
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:00:49 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id g15-20020a9d6b0f000000b005a062b0dc12so2962053otp.4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eTJQQ6MsX5Ff+bIQxYo4yiY9UnTvAPhZS922wxBLIWs=;
        b=h6BIQ1pcW7rPc8/weadr6vCqLFeRDLjdrhOUSLh7XrSPq/jMDafrMY/HirVc+W/RDZ
         MXF2olW97HltisTcta1a143cKvHiklq3Aj1LH5S3JxKFBDjwRV1ebgBBTbTvdfXV1abd
         GNMccz9OHR9pUgC9/fJc5a9vlP4RRRZ4ZBO1SOy3IUKoIvQ6f1WIzxljHEnrH5jkj0XY
         Y0c/iihEtQXqZA6tnnTIHm+VVsg2YV1EEoBrmmw/s/ve0YiSm6UU59wHip7acpwn5+aN
         t0T3YMTSclGHaU1r231pMnkqHXoGtF4khPMbmiIGjPMtayZLaRcTqr5psf8pRYj3GNJs
         klfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eTJQQ6MsX5Ff+bIQxYo4yiY9UnTvAPhZS922wxBLIWs=;
        b=kecmBfntHdDPkX7CoVL0cA163sGGxiPvHvM3H/E8UiDIF/L2dXmQaxSjlENz5GwOod
         4RRYLmBOsD5FbeRBUhxptjPNFzSFKoW5YdrvLb6gcnRDqrXCRKTYm/z3xidA9Tl9UXLk
         V1CMorD4h/5I8Z7LL1AkZkw8twzRR8D49ePGHnAVj4TUeXi6irNWmK/iRURX/3JhKrLs
         QMxgyvFwmC1ozSheFdH7UnhyW9hkxU0hCVu+cRLY49/YS14imC989u0RGmPB7NEtuy1M
         n1x0/COUgrE3+1lhkK6TuuzuRfoVw9A9xNKjs/6SttswRc81mut0C91I8Xe+USPpLsZO
         u6eg==
X-Gm-Message-State: AOAM532tnNIr34Ou644lTd5O2fZr7RsTvRUtISyBT3MiC3ICLhCQsa3C
        u9YQqxnZ0ZBGdZgFoqGWiXuCSA==
X-Google-Smtp-Source: ABdhPJxkcSpap1VhLGQAw/l13hEXVNq4heAfIa2fMfb+0SaQZSgk40Jcw0IUMg6wCQsfoHGmsdM/Wg==
X-Received: by 2002:a05:6830:1e99:: with SMTP id n25mr12847268otr.344.1643065248584;
        Mon, 24 Jan 2022 15:00:48 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id n4sm2075103otr.76.2022.01.24.15.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 15:00:48 -0800 (PST)
Message-ID: <12c8fd1e-431e-9a59-9e7a-e8d856c088b9@linaro.org>
Date:   Mon, 24 Jan 2022 17:00:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
References: <20220124184024.407936072@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/24/22 12:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected on arm, arm64, i386, x86.

This is from arm64:
   /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
   /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
      17 |         if (in_bpf_jit(regs))
         |             ^~~~~~~~~~
   cc1: some warnings being treated as errors
   make[3]: *** [/builds/linux/scripts/Makefile.build:280: arch/arm64/mm/extable.o] Error 1

And from Perf on arm, arm64, i386, x86:
   libbpf.c: In function 'bpf_object__elf_collect':
   libbpf.c:2873:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
    2873 |                         if (sh->sh_type != SHT_PROGBITS)
         |                               ^~
   libbpf.c:2877:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
    2877 |                         if (sh->sh_type != SHT_PROGBITS)
         |                               ^~
   make[4]: *** [/builds/linux/tools/build/Makefile.build:97: /home/tuxbuild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

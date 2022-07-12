Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5015729C4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 01:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiGLXQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 19:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiGLXPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 19:15:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45974CDA12;
        Tue, 12 Jul 2022 16:15:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a15so9565970pjs.0;
        Tue, 12 Jul 2022 16:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ztXFYPGh7YY5+DNJJYJue/095116F+yh2f6Belg/x8M=;
        b=lyR6YxCanKNt3stonvx11gA1slmL5idfCyo7V7/ipFJ1Ra3sJJA2r9R8awakuM/zOg
         vXO2akT5kebEUsutJYFFe0SethNangUeJuBMKs/kDrYebJekopZigTl/TeRFAxAYl4IB
         VQPhSlA7ZCtEfKQJISydicltNOOYR/dJLfgG5RuF9IfU4J2rUsIK2UkXIJhLbJJeedO+
         qNR++LTPx3B+zsjs8ArIeUAZjDvh2gxGR5xDLxlXErZO89XNxORcGCOG+Wvj77phje6F
         63Za+ShVamdR7oddsh0fDdvb5DDD2ZrIsrmY7290lqsatBNSpbg2m9MGP1Wvqi5+HlMa
         65RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ztXFYPGh7YY5+DNJJYJue/095116F+yh2f6Belg/x8M=;
        b=r9zlbX+MLWZYXDVYXgnt5bb9skx0GvveKx5DVeBqX7yS7LxiqaEkTyD0qJ48nk808o
         JbRIcVCmHZPPWuPlEpm7nyzVle59FbTXx0qMoirGtJsXOS56oYMJdJftPf4jyvnD0iv5
         C12u4rONz/b1u80LZUojXngGGeY8otncfk8EK9co+31aZqq2QZnyuwkR+r+QrYu5IM7Z
         hwp9TDb1S6CPCU5ARVVrlYRu5O+58Y6AJxl4essu2uE2dU7+xQIzgY5TxX36guSKP0iy
         VvBwLmD6GJdEYrU3hkDhj3NAVxDe+ZI41IqLqTdZrM6fxFp3dyYF10J0MjqJ0Z+l10YX
         cY9Q==
X-Gm-Message-State: AJIora9RszkOCslvTJS8x+J8/1IU/jdZtEaPa7GY+JDJNGq1XBNW76rb
        ac0gkBssXRhC1/9sfacfXBMNo5Ms0Oo=
X-Google-Smtp-Source: AGRyM1umdpHXd0PaZwzJ8rvDg1loDmEke8Bfq1zThwNNsKOjWdCEfg+iccVyaSRpL8uxTvD17LipwQ==
X-Received: by 2002:a17:902:e888:b0:16c:33f7:89cb with SMTP id w8-20020a170902e88800b0016c33f789cbmr392816plg.2.1657667711388;
        Tue, 12 Jul 2022 16:15:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pi4-20020a17090b1e4400b001df264610c4sm4509075pjb.0.2022.07.12.16.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 16:15:10 -0700 (PDT)
Message-ID: <6acd1cd0-25aa-eb9c-4176-49f623f79301@gmail.com>
Date:   Tue, 12 Jul 2022 16:15:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 000/130] 5.10.131-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220712183246.394947160@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
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

On 7/12/22 11:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

   CC 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.o
In file included from util/intel-pt-decoder/intel-pt-insn-decoder.c:15:
util/intel-pt-decoder/../../../arch/x86/lib/insn.c:13:10: fatal error: 
asm/inat.h: No such file or directory
  #include <asm/inat.h> /* __ignore_sync_check__ */
           ^~~~~~~~~~~~
compilation terminated.
make[7]: *** [util/intel-pt-decoder/Build:14: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.o] 
Error 1
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/build/Makefile.build:139: 
intel-pt-decoder] Error 2
make[5]: *** 
[/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/build/Makefile.build:139: 
util] Error 2
make[4]: *** [Makefile.perf:643: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf-in.o] 
Error 2
make[3]: *** [Makefile.perf:229: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:294: 
/local/users/fainelli/buildroot/output/arm64/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:27: _all] Error 2

you will need to pick this patch as well:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0705ef64d1ff52b817e278ca6e28095585ff31e1

With that one applied:

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

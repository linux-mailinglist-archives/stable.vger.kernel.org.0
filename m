Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017506AFDDA
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 05:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCHE3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 23:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCHE3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 23:29:49 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1082D9477C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 20:29:45 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-17683b570b8so14788882fac.13
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 20:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678249784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jhAOE71Ompgdm0ng6gusjFFxPb/vUHlh3eJ25cLU//w=;
        b=IOviJkpeBA6AfHMftrqOMYww5gkDtKQ4vL6tCHkCi6DblrdgUjvd+wQi0O+wsCYLlB
         m9yOwTPmqn88KqybOsSC+MrpyemRI7MFKZP4hk01GSj7g0ZJvqP1HcndlzNe7EZN3SIA
         Uf4HGSX8spu4vPsDOiM9WixhWcEXyOR2MmMhl2b2n48hPF9shCSJHMwJ0fmm5lxJgaZX
         9Fjfsv9NIKU1WWErD9sJiWAAs8ST3sCV+KtrWVLXOqlrZxRUiUSoFWp81tbhW2nYBu6O
         mN0S1vQeR6XZ6Z2AlLSSwaobXCfltLHEcHTuiAo4823nYB7S7RToLvOwuu2Vd4vYgLYS
         Y5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678249784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jhAOE71Ompgdm0ng6gusjFFxPb/vUHlh3eJ25cLU//w=;
        b=EJJRyfZjcxM7cn675SWXO6R3VoMMoq5FSPAw4BhsAGfkX0piQ3U2+EgixTEb5zTQAc
         1RU85KLPAHEdxtzz0gsVd5ggLOqYsxqrvAvo2n7DFE1HGnwyhLpvhdxrpeH6T7G5LJqt
         YuebOvQPJMVvsCyxAI4BjcWkBIRarpHjLtHeQUh/4P5OuxqvYIVkLfShtOdqx4Erp18h
         w59RLh+cL+boh0JzXznUbaY235BsR6JxokF5DgZzE7pVmu5ogwv+iABc8zEdLurRRlEu
         ZijLXlMGew+81DvBQSJ6HbuUxSxGr3g9m8tnV0/PJTq46XKUC9ZoFlXoOb2IsxjQyDvB
         BWUg==
X-Gm-Message-State: AO0yUKXTEEKdXiwJ/GJmVBIXQLUz/38dW4WVDf3Ikv4vV0zqlYGoWCKE
        cGQpO1XYfuszQB7wj08Hq/vHEg==
X-Google-Smtp-Source: AK7set9NNer1Dg+UCMTqbXRORLV+qQo1RfmIm2Hp52ZDRwRVj6VXTGsUCo8OhXInLU5tl4OuOwl+DA==
X-Received: by 2002:a05:6871:810:b0:16e:8b9f:93e1 with SMTP id q16-20020a056871081000b0016e8b9f93e1mr10643789oap.5.1678249784362;
        Tue, 07 Mar 2023 20:29:44 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id j2-20020a056870a48200b001723d62f997sm5844734oal.32.2023.03.07.20.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 20:29:43 -0800 (PST)
Message-ID: <29636c67-aab7-1235-27af-469bcec7ae66@linaro.org>
Date:   Tue, 7 Mar 2023 22:29:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/885] 6.1.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, pali@kernel.org,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au
References: <20230307170001.594919529@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 07/03/23 10:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 885 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same regression with PowerPC's ppc64e_defconfig, using GCC 8 and GCC 12, as reported with 6.2
-----8<-----
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
[...]
make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:242: __sub-make] Error 2
make: Target '__all' not remade because of errors.
----->8-----

Bisection points to "powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage" (upstream ff7c76f66d8bad4e694c264c789249e1d3a8205d).

Reproducer:
   tuxmake \
     --runtime podman \
     --target-arch powerpc \
     --toolchain gcc-8 \
     --kconfig ppc64e_defconfig \
     config debugkernel dtbs kernel modules xipkernel

Greetings!

Daniel Díaz
daniel.diaz@linaro.org



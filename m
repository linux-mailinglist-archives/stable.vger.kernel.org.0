Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB16BB852
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 16:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjCOPpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 11:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjCOPp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 11:45:27 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF89960435
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:45:02 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id bk32so14450319oib.10
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678895101;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E6sAgqQ4tUM3/2nNIAr1J1jXcot8viEl3eXcZAX7ehI=;
        b=n85Fo1qMrqx41Xp8nt8ry4U3yrXUumJ9e3tZ+BEFRjL83JtVYjqzacklbP3ObwzvKj
         mp1qGdrzBMHfLUZU4emgg6rlTZ1/h7scIgShP+kUfsxrsdI1O1r8CR2lbfjnd1ukJkoC
         07CWieSwn+x0gXDIUliJiYn71oFeq2Q6QlI/Ym6hmUSRO6XWLGdL8o3ac30HVbO499nD
         gigcMcfM1RI5AYNHDq1oI34YVazsOaN7eOzrymrY50PvU9LIFIQKv9GLRoH8N6iYL5Ti
         g/d4ETZONGyk18SehktZYlnmwFAoVXkziT+ZeGmkhlC4X3v0ZQIm1J+7VATAkLnthXF5
         Mr1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678895101;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6sAgqQ4tUM3/2nNIAr1J1jXcot8viEl3eXcZAX7ehI=;
        b=DFwqbMMN8KZ+Zi68NQQBv1K1ihOfCkAXVBlLKRBXeTdGoz0R2r0NAVei6Z8P76R5mK
         K0iC3wfUGIU9IGZWki57tHoD1iVbMDF7pnUrD70+hvq7QLMcAtz+QA3cmssnk6zq6m3V
         5g3cbgtmHn55UccpTGT90Spu8pA6FC6jW7NbbWdotURI7zBqIffL/Ev311OaW0oHDnj4
         GwWP/hFZRUmgK4wo0qkWUsU1T7FEGzxoYI4ITl4pHvc1R4zSqjhRJVNQeZ4fmNEQKSoe
         dpCqPDvCnc6vdi4n2WMtm7TQMpdMF2Td+Z/L62T6L81B9BLEx9O7bhLnhqPbloce0FLL
         553A==
X-Gm-Message-State: AO0yUKXTATcqDhYazXvDHR2p00In+jaq79F+IPIMo9OXDV5Bl6R3dqhk
        IVXcWfSmuxiWzTZuzMrVIUuhIQ==
X-Google-Smtp-Source: AK7set+3Fm8PLpXAgtycnefk9Q9haiAZeDCnBXcFHhOyJbtzZ7VUwtmV4DJAofUAskcOiLt5atHjMA==
X-Received: by 2002:a05:6808:486:b0:383:ce80:6c28 with SMTP id z6-20020a056808048600b00383ce806c28mr1384800oid.51.1678895100595;
        Wed, 15 Mar 2023 08:45:00 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id q15-20020a05683031af00b00690e6d56670sm2471107ots.25.2023.03.15.08.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:45:00 -0700 (PDT)
Message-ID: <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
Date:   Wed, 15 Mar 2023 09:44:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115721.234756306@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 15/03/23 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Lots and lots of failures, mostly Arm.

For Arm, Arm64, MIPS, with GCC-8, GCC-9, GCC-10, GCC-11, GCC-12, Clang-16, for some combinations with:
* axm55xx_defconfig
* davinci_all_defconfig
* defconfig
* defconfig-40bc7ee5
* lkftconfig-kasan
* multi_v5_defconfig
* s5pv210_defconfig
* sama5_defconfig

-----8<-----
/builds/linux/kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus' [-Werror,-Wimplicit-function-declaration]
         get_online_cpus();
         ^
/builds/linux/kernel/cgroup/cgroup.c:2237:2: note: did you mean 'get_online_mems'?
/builds/linux/include/linux/memory_hotplug.h:258:20: note: 'get_online_mems' declared here
static inline void get_online_mems(void) {}
                    ^
/builds/linux/kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus' [-Werror,-Wimplicit-function-declaration]
         put_online_cpus();
         ^
/builds/linux/kernel/cgroup/cgroup.c:2248:2: note: did you mean 'put_online_mems'?
/builds/linux/include/linux/memory_hotplug.h:259:20: note: 'put_online_mems' declared here
static inline void put_online_mems(void) {}
                    ^
2 errors generated.
make[3]: *** [/builds/linux/scripts/Makefile.build:303: kernel/cgroup/cgroup.o] Error 1
----->8-----


For Arm64, i386 x86, with GCC-11, Perf has a new error:

-----8<-----
In function 'ready',
     inlined from 'sender' at bench/sched-messaging.c:90:2:
bench/sched-messaging.c:76:13: error: 'dummy' is used uninitialized [-Werror=uninitialized]
    76 |         if (write(ready_out, &dummy, 1) != 1)
       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from bench/../perf-sys.h:5,
                  from bench/../perf.h:18,
                  from bench/sched-messaging.c:13:
----->8-----


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


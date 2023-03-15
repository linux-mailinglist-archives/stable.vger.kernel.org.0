Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB906BB8DD
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjCOQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjCOQAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:00:08 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6191ADE1;
        Wed, 15 Mar 2023 08:59:31 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id w4so10641550ilv.0;
        Wed, 15 Mar 2023 08:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678895956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=mwFEZMuMScsLlZA1DsDqm1/V+MycUBRzLGSOja/IOcQ=;
        b=V+LJijXRV9IGnqoktWLHNtDnhJMaOVMarwgYVaC7IHV+9KHjgw9Smm1o9GefaTjaiR
         DfU7hQkYi1JETYj4/5uNHDv1i/3uX2fzVmfatCadsD5MWr83/pAIrWWl4cLLxiLpTDQz
         eDsLOFM6DW3S/qheyyEth+nfUXU80HXkZuiQJNSVkqRQUT0n9wS+ss9y+fM925Q1Fvtk
         YRizGeXLAcZ2J5zy4JY10CMAeL4yPE6Nt1/g2+dtVdiIex3m6mugLFOxqqmlKxLNPDBn
         dvIRE5jXrnIILDwf5Awb9FJ8NULuGXCvDFHw4bcVO6yq2v1x1CaDNSeH/7ENOwdyqELO
         frFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678895956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwFEZMuMScsLlZA1DsDqm1/V+MycUBRzLGSOja/IOcQ=;
        b=wBP2CH6FOXxr+3c8T6HRrWkvW/YQURDR3YmWgRa0uQjXnJz+pAEn2kTXJmN/kAWEvy
         NLMotHQ+J5rqE/+a5ES5dlui4fZYMFmb4XhHNMeo5w7tTxXv3d9ahnJFRYEIcS7yPTzK
         6CYe4aS7cF6FOppROVIY5kzHlO3bo/VQ5zmfcrrmuJy+xs5HlHJ+5BPznGybezss9WKz
         lWY0zKst2z/eHx00lDQJEUFXxeXjaI3DzLV1d11tpCeTDbfDzQNnr9StuBb8AfmXhVlm
         wP0fGAPePDHefrLF4Pr3tsAhLFvHRRbgT73CizD+b1NsslCSyKxmSSxVJSGGSjN6NmFz
         RnEA==
X-Gm-Message-State: AO0yUKXUqf8r2Tj3L75w115LHV93EOS7NJonsOmHI+kF1t7kFvRrU9gl
        /GfCmN8xrxBkOMzcKueBkgI=
X-Google-Smtp-Source: AK7set8LadlfBIzS7eiLYiABvmbeEZEqP78tzHNUThoKyE/2SjzzdcVz0HdArT4sXxKmDjCqU5KQzQ==
X-Received: by 2002:a05:6e02:10d2:b0:316:4174:b065 with SMTP id s18-20020a056e0210d200b003164174b065mr4787739ilj.15.1678895956624;
        Wed, 15 Mar 2023 08:59:16 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2-20020a02c542000000b004054d7eede5sm1332429jaj.22.2023.03.15.08.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:59:16 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <166de5e6-3911-cbda-8b36-624e396decaa@roeck-us.net>
Date:   Wed, 15 Mar 2023 08:59:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115721.234756306@linuxfoundation.org>
 <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 08:44, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:12, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.278 release.
>> There are 39 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Lots and lots of failures, mostly Arm.
> 
> For Arm, Arm64, MIPS, with GCC-8, GCC-9, GCC-10, GCC-11, GCC-12, Clang-16, for some combinations with:
> * axm55xx_defconfig
> * davinci_all_defconfig
> * defconfig
> * defconfig-40bc7ee5
> * lkftconfig-kasan
> * multi_v5_defconfig
> * s5pv210_defconfig
> * sama5_defconfig
> 
> -----8<-----
> /builds/linux/kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus' [-Werror,-Wimplicit-function-declaration]
>          get_online_cpus();
>          ^
> /builds/linux/kernel/cgroup/cgroup.c:2237:2: note: did you mean 'get_online_mems'?
> /builds/linux/include/linux/memory_hotplug.h:258:20: note: 'get_online_mems' declared here
> static inline void get_online_mems(void) {}
>                     ^
> /builds/linux/kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus' [-Werror,-Wimplicit-function-declaration]
>          put_online_cpus();
>          ^
> /builds/linux/kernel/cgroup/cgroup.c:2248:2: note: did you mean 'put_online_mems'?
> /builds/linux/include/linux/memory_hotplug.h:259:20: note: 'put_online_mems' declared here
> static inline void put_online_mems(void) {}
>                     ^
> 2 errors generated.
> make[3]: *** [/builds/linux/scripts/Makefile.build:303: kernel/cgroup/cgroup.o] Error 1
> ----->8-----
> 
> 
> For Arm64, i386 x86, with GCC-11, Perf has a new error:
> 
> -----8<-----
> In function 'ready',
>      inlined from 'sender' at bench/sched-messaging.c:90:2:
> bench/sched-messaging.c:76:13: error: 'dummy' is used uninitialized [-Werror=uninitialized]
>     76 |         if (write(ready_out, &dummy, 1) != 1)
>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from bench/../perf-sys.h:5,
>                   from bench/../perf.h:18,
>                   from bench/sched-messaging.c:13:
> ----->8-----
> 
> 
> Greetings!
> 
> Daniel Díaz
> daniel.diaz@linaro.org
> 

Looks like this whole set of release candidates is a disaster. I have stopped
my testbed for the time being (no point in wasting energy), so there won't be
any further updates from me for the time being.

Guenter


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE02573778
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiGMNeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiGMNeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:34:21 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7512360E3;
        Wed, 13 Jul 2022 06:34:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id bh13so10453016pgb.4;
        Wed, 13 Jul 2022 06:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=TxhKMDV/z6CG2219uB85BiE9Ka0GFiJjBlxBizq8+LY=;
        b=BPVVh7hvzozlYd1Xyfvdm40v2ku9O5VfuFyMDNu252//ckV4EDHgDoV4LKPuvKPjX7
         wlm4oQb+/siE5nnvJXFXo8fKW/O81jHyFv8QafrYoY2jh95hTfii4euqvAYkH40O7LGr
         OF2ukL37ZWHnEX/4T0LfgywEmP2/aIRL/JkHrLZBkUhd1AwM0EpOM3SfUSz3ldhPZbLn
         woqQA7znCIqxohasyaCwKDeXW0UiivNNPC2ENpEm0sNS+nF4MYnTFCXfKTsCBqtK/3+W
         i9LHE8kvcCRQXzq8BdJJY8D0z0Zhnx8JqFuLox+LyWwn2Qa0t1wvcZJpuJXaPMDGDktu
         qvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=TxhKMDV/z6CG2219uB85BiE9Ka0GFiJjBlxBizq8+LY=;
        b=VkCUDA/8Zi1o86sDPr1pwd2RrR7CvN2OT2D5TBPOi6blE+JqLWXQBEsQEk7k1ZFkQL
         ZYIhx7MdvUu68Yjedz67zg6yjsIs2gz5DrgE82ZfnblL3NPE5l3KT2edclFNuHpSi3QH
         wU/aIKjfQDZR6Sex0qk1Is0yM0B3DU4ikcKOCf+3jRhT+nJOyWkiS4Ci74xHDzBxk/rf
         EqqyNpjCrj1ouipkLHnvP8+lrZFjNbVAdXy4IhfCwivrDRKzw/XmDwdqy+fSjc+90KkH
         fxmBuN8PiQvZOAWPL4//bqL64ny3sR2MeHU/60DTNXO2mh76SaX4N3EUEl4ycOABGkMN
         vKKA==
X-Gm-Message-State: AJIora84Fz/9IC56awuM2Vov/cpMqiqnZTqF6I2e4BLKuQ0dA82+X9Cd
        3Ueyy2ZZlSnHUtUIl4F6kulnSCYMq3Jn0Q==
X-Google-Smtp-Source: AGRyM1vV3WWhug2juiGiaEu118xuDEbUK27X0Bd+HWnrx5Rnvwa9uh1Nny/GhOIXBBa0ZE0CXA078w==
X-Received: by 2002:a63:b1e:0:b0:3fd:43d9:5354 with SMTP id 30-20020a630b1e000000b003fd43d95354mr3038181pgl.294.1657719259943;
        Wed, 13 Jul 2022 06:34:19 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e80200b0016b9b6d67a2sm8905465plg.155.2022.07.13.06.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 06:34:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
Date:   Wed, 13 Jul 2022 06:34:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
In-Reply-To: <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/13/22 05:52, Naresh Kamboju wrote:
> On Wed, 13 Jul 2022 at 00:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.55 release.
>> There are 78 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.55-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Results from Linaro’s test farm.
> Regressions on x86_64.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 1) Kernel panic noticed on device x86_6 while running kvm-unit-tests.
>     - APIC base relocation is unsupported by KVM
> 

Looking into the log, I don't think that message is related to the crash.

[   67.774572] APIC base relocation is unsupported by KVM
[  105.643057] kvm: emulating exchange as write  <--- warning
[  105.653717] int3: 0000 [#1] SMP PTI
[  105.653720] CPU: 3 PID: 3747 Comm: qemu-system-x86 Not tainted 5.15.55-rc1 #1
[  105.653721] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  105.653722] RIP: 0010:xaddw_ax_dx+0x9/0x10
...
[  105.653777] Modules linked in: x86_pkg_temp_thermal
[  105.902123] ---[ end trace cec99cae36bcbfd7 ]---
[  105.902124] RIP: 0010:xaddw_ax_dx+0x9/0x10    <--- crash
[  105.902126] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc

Guenter

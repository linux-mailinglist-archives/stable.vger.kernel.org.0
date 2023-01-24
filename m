Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DFA6798CE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjAXM6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjAXM6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:58:52 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9F222C3;
        Tue, 24 Jan 2023 04:58:23 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1631b928691so1211447fac.11;
        Tue, 24 Jan 2023 04:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=19Cl6GiHai15EHKqqL5MJsrC0SAK4DYngi9P4S3JRXk=;
        b=U8Usm78auw113UmivYoQMM23I5glJEnLHLoyduEbqXMuiAdiladsOszSiC6Q68AmoB
         B/jRT5Tyfu/lYYb9s7glroJ73a8073nbEF20HQAWm0IR5warkOsJN4eQT/qBmorQuvkS
         NdoQVaIhwt5SCX0FOwFWtFyQflzKclZrV0aCtvsm9WDsj6YDaWm6Ff3qlpX8M32cuYOg
         1GXkN1TuaBiKpTvziwYKp9oXLadDF6AxFfeWnuj9VNrH1ly5mffP1JsSDjA9ilev8INc
         8yWuvGuFwPceTpKV2a5216841n5WzwthIeax787dp5wPRhqTSX9yLvCDoqBBsQuoJQbg
         BOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=19Cl6GiHai15EHKqqL5MJsrC0SAK4DYngi9P4S3JRXk=;
        b=fbtlOBaHHFvs2LjneHNbab8OXKEmpoEuS0SV4SPQeum1Wk0DPwik41uu2e9t7j+Ul2
         jfeHeGf9HleM8rBWMA4pGwIQOH4ensy9Eh+cZq7QDFY8ydf1/ulXKYXa6b9FA7JARfR/
         go+5Yhh/qIFGZnHmEQyjd9N8ZuKG5/BdYPWL+hIczP1rv9YO+iNVXv4tNKtjScNbDHrS
         t4nyD/6gfnyuJ4WWHynqAVBxULoPxDg+B0/aJ/ifpEpHAE+yAttf4r9By+6Q8l6CxJo3
         tg4/MpUJCowwro10EvrGjNmwpAUAUtkSgKisaFt24OwD0QV6Djmh8+3gtxgy3TFhBPgB
         SQ+A==
X-Gm-Message-State: AFqh2kpcIcDdr/UeJsl3VfxWhC5th/q4VMdw4KjaQUHuWCazANW7JEy4
        S9GBLgIgr0jf9eFqSYQCFgI=
X-Google-Smtp-Source: AMrXdXvliegj7O+rvgOxjzAKA6LY4l9+aBGRXYocBkO1ydo/NIqQ4VpDYKVyc/0VpI/uGueGLbXvTg==
X-Received: by 2002:a05:6870:289a:b0:15e:9b5b:e2c9 with SMTP id gy26-20020a056870289a00b0015e9b5be2c9mr14560866oab.3.1674565102219;
        Tue, 24 Jan 2023 04:58:22 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j24-20020a056870051800b0013b9ee734dcsm679971oao.35.2023.01.24.04.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 04:58:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <433e41da-5965-ccf0-c3de-79bd696806f7@roeck-us.net>
Date:   Tue, 24 Jan 2023 04:58:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094918.977276664@linuxfoundation.org>
 <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/23 01:52, Naresh Kamboju wrote:
> On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.90 release.
>> There are 117 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Results from Linaro’s test farm.
> Regressions found on arm64 for both 5.15.90-rc2 and 5.10.165-rc2.
> 

Didn't you send an earlier e-mail suggesting no regressions ?

Guenter

> * qemu-arm64-mte, kselftest-arm64
>    - arm64_check_buffer_fill
>    - arm64_check_child_memory
>    - arm64_check_ksm_options
>    - arm64_check_mmap_options
>    - arm64_check_tags_inclusion
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> We are in a process to bisecting this problem and there are updates coming
> from kselftest rootfs.
> 
> Test logs,
> # selftests: arm64: check_buffer_fill
> # 1..20
> # ok 1 Check buffer correctness by byte with sync err mode and mmap memory
> # ok 2 Check buffer correctness by byte with async err mode and mmap memory
> # ok 3 Check buffer correctness by byte with sync err mode and
> mmap/mprotect memory
> # ok 4 Check buffer correctness by byte with async err mode and
> mmap/mprotect memory
> # not ok 5 Check buffer write underflow by byte with sync mode and mmap memory
> # not ok 6 Check buffer write underflow by byte with async mode and mmap memory
> # ok 7 Check buffer write underflow by byte with tag check fault
> ignore and mmap memory
> # ok 8 Check buffer write underflow by byte with sync mode and mmap memory
> # ok 9 Check buffer write underflow by byte with async mode and mmap memory
> # ok 10 Check buffer write underflow by byte with tag check fault
> ignore and mmap memory
> # not ok 11 Check buffer write overflow by byte with sync mode and mmap memory
> # not ok 12 Check buffer write overflow by byte with async mode and mmap memory
> # ok 13 Check buffer write overflow by byte with tag fault ignore mode
> and mmap memory
> # not ok 14 Check buffer write correctness by block with sync mode and
> mmap memory
> # not ok 15 Check buffer write correctness by block with async mode
> and mmap memory
> # ok 16 Check buffer write correctness by block with tag fault ignore
> and mmap memory
> # ok 17 Check initial tags with private mapping, sync error mode and mmap memory
> # ok 18 Check initial tags with private mapping, sync error mode and
> mmap/mprotect memory
> # ok 19 Check initial tags with shared mapping, sync error mode and mmap memory
> # ok 20 Check initial tags with shared mapping, sync error mode and
> mmap/mprotect memory
> # # Totals: pass:14 fail:6 xfail:0 xpass:0 skip:0 error:0
> not ok 34 selftests: arm64: check_buffer_fill # exit=1
> 
> 
> # selftests: arm64: check_child_memory
> # 1..12
> # not ok 1 Check child anonymous memory with private mapping, precise
> mode and mmap memory
> # not ok 2 Check child anonymous memory with shared mapping, precise
> mode and mmap memory
> # not ok 3 Check child anonymous memory with private mapping,
> imprecise mode and mmap memory
> # not ok 4 Check child anonymous memory with shared mapping, imprecise
> mode and mmap memory
> # not ok 5 Check child anonymous memory with private mapping, precise
> mode and mmap/mprotect memory
> # not ok 6 Check child anonymous memory with shared mapping, precise
> mode and mmap/mprotect memory
> # not ok 7 Check child file memory with private mapping, precise mode
> and mmap memory
> # not ok 8 Check child file memory with shared mapping, precise mode
> and mmap memory
> # not ok 9 Check child file memory with private mapping, imprecise
> mode and mmap memory
> # not ok 10 Check child file memory with shared mapping, imprecise
> mode and mmap memory
> # not ok 11 Check child file memory with private mapping, precise mode
> and mmap/mprotect memory
> # not ok 12 Check child file memory with shared mapping, precise mode
> and mmap/mprotect memory
> # # Totals: pass:0 fail:12 xfail:0 xpass:0 skip:0 error:0
> not ok 35 selftests: arm64: check_child_memory # exit=1
> 
> # selftests: arm64: check_ksm_options
> # 1..4
> # # Invalid MTE synchronous exception caught!
> not ok 37 selftests: arm64: check_ksm_options # exit=1
> 
> 
> # selftests: arm64: check_mmap_options
> # 1..22
> # ok 1 Check anonymous memory with private mapping, sync error mode,
> mmap memory and tag check off
> # ok 2 Check file memory with private mapping, sync error mode,
> mmap/mprotect memory and tag check off
> # ok 3 Check anonymous memory with private mapping, no error mode,
> mmap memory and tag check off
> # ok 4 Check file memory with private mapping, no error mode,
> mmap/mprotect memory and tag check off
> # not ok 5 Check anonymous memory with private mapping, sync error
> mode, mmap memory and tag check on
> # not ok 6 Check anonymous memory with private mapping, sync error
> mode, mmap/mprotect memory and tag check on
> # not ok 7 Check anonymous memory with shared mapping, sync error
> mode, mmap memory and tag check on
> # not ok 8 Check anonymous memory with shared mapping, sync error
> mode, mmap/mprotect memory and tag check on
> # not ok 9 Check anonymous memory with private mapping, async error
> mode, mmap memory and tag check on
> # not ok 10 Check anonymous memory with private mapping, async error
> mode, mmap/mprotect memory and tag check on
> # not ok 11 Check anonymous memory with shared mapping, async error
> mode, mmap memory and tag check on
> # not ok 12 Check anonymous memory with shared mapping, async error
> mode, mmap/mprotect memory and tag check on
> # not ok 13 Check file memory with private mapping, sync error mode,
> mmap memory and tag check on
> # not ok 14 Check file memory with private mapping, sync error mode,
> mmap/mprotect memory and tag check on
> # not ok 15 Check file memory with shared mapping, sync error mode,
> mmap memory and tag check on
> # not ok 16 Check file memory with shared mapping, sync error mode,
> mmap/mprotect memory and tag check on
> # not ok 17 Check file memory with private mapping, async error mode,
> mmap memory and tag check on
> # not ok 18 Check file memory with private mapping, async error mode,
> mmap/mprotect memory and tag check on
> # not ok 19 Check file memory with shared mapping, async error mode,
> mmap memory and tag check on
> # not ok 20 Check file memory with shared mapping, async error mode,
> mmap/mprotect memory and tag check on
> # not ok 21 Check clear PROT_MTE flags with private mapping, sync
> error mode and mmap memory
> # not ok 22 Check clear PROT_MTE flags with private mapping and sync
> error mode and mmap/mprotect memory
> # # Totals: pass:4 fail:18 xfail:0 xpass:0 skip:0 error:0
> not ok 38 selftests: arm64: check_mmap_options # exit=1
> 
> 
> # selftests: arm64: check_tags_inclusion
> # 1..4
> # # No valid fault recorded for 0x500ffffb8b27000 in mode 1
> # not ok 1 Check an included tag value with sync mode
> # # No valid fault recorded for 0x400ffffb8b27000 in mode 1
> # not ok 2 Check different included tags value with sync mode
> # ok 3 Check none included tags value with sync mode
> # # No valid fault recorded for 0xa00ffffb8b27000 in mode 1
> # not ok 4 Check all included tags value with sync mode
> # # Totals: pass:1 fail:3 xfail:0 xpass:0 skip:0 error:0
> not ok 40 selftests: arm64: check_tags_inclusion # exit=1
> 
> Test logs,
> https://lkft.validation.linaro.org/scheduler/job/6087664#L4865
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/test/arm64_check_tags_inclusion/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/tests/
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.87-219-g60931c95bb6d/testrun/14329656/suite/kselftest-arm64/tests/
> 
> --
> Linaro LKFT
> https://lkft.linaro.org


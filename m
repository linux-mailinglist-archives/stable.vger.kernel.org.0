Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDC3544DD7
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiFINiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbiFINiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:38:10 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FE01016;
        Thu,  9 Jun 2022 06:38:08 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id w19-20020a9d6393000000b0060aeb359ca8so17368046otk.6;
        Thu, 09 Jun 2022 06:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=HcPWLjNKeSLW/i1svoOPg26HSpUrJUafk75Nuxi7jnE=;
        b=a3LalNpGDnWpCAa+cZkBt85rY9q64Rb8Md1StD4YVcyA/+NOTYdtuhUE/AdRkYWryr
         7BZlcc+a90G5tSrxb2Fvjq4BYHgtSRSzgO6qAx7yTJ3r8PpZ5d5gbXDOEgg8ejIYR7zC
         0Nd2zQR39MAXROwPpCC+W22y+Log40Ww8LoWhCp+VyPLI2Lgt+92X3YbnoZouISvfWoM
         Vs11TkiKxq1Avi8rteAExnwtFcXl2EWDdY8CKxyxh6vm3c4J/6VTatv3ffO1yCWOWg+P
         ySqIhD2B3E3MdYj06yn2t9KQwnauQPebmx8yto4Vae+DzgyPCRclWtI7fGawIdrlr+0A
         pQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=HcPWLjNKeSLW/i1svoOPg26HSpUrJUafk75Nuxi7jnE=;
        b=v3qHfhVB7kr76z+VsufY3OdPtSR7Okqfqrg+aK+33vAiuaspF7KQRK/EyrGbUlSs2R
         3sVSB6qhuW9g705dRLNrcbbO53c+ebg4G5PI4uGbzUsGzRejh4ljf0XzaAddkfhpf+by
         857cIWSW+aaMiXQw2MwRff0SFBE80H2fWeaFPzyCjVkhO+wPjZlnwzZHa/GFLgx5nHLd
         ezlXfwAJuzY2JSU3T/HDTBvttjsWVv/pw3+4eOVNF+hXLWrozwkhMp23SyuUV/ZWHl47
         DW7bT7sICo7eXfIOWzUITTcHGZ2PziZZ78bGBBhytGcRItYbqoczW26ySqiDgLyV+qmE
         mxfg==
X-Gm-Message-State: AOAM5311terdI/iQi23kNuAjBWBe0VWj/Y3DdL1lB8Jz+NVF0I938el0
        r4TyNC6pV+wtNZRVfVMU/1s=
X-Google-Smtp-Source: ABdhPJzHRwh7un9RpiInZJR/C0odWKcL7VyPguqIc9WP04cRhMcweQ9UahbJOT1nQb71cNZWfhXmZA==
X-Received: by 2002:a9d:6f0d:0:b0:60c:ae:9319 with SMTP id n13-20020a9d6f0d000000b0060c00ae9319mr7713161otq.51.1654781887297;
        Thu, 09 Jun 2022 06:38:07 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k6-20020a9d1986000000b0060603221268sm12090504otk.56.2022.06.09.06.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 06:38:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <cb8d9226-5aea-00bc-2dbf-21db2cb8f176@roeck-us.net>
Date:   Thu, 9 Jun 2022 06:38:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20220607164948.980838585@linuxfoundation.org>
 <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
 <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
In-Reply-To: <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/22 05:51, Naresh Kamboju wrote:
> On Wed, 8 Jun 2022 at 19:24, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>
>> On Tue, 7 Jun 2022 at 23:41, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 5.17.14 release.
>>> There are 772 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Results from Linaro’s test farm.
>>
>> Regressions found on qemu_x86_64:
>>    - kunit/kasan [1]
>>
>> Regressions found on qemu_i386:
>>    - kunit/kfence [2]
>>    - kunit/test_out_of_bounds_read
>>
>> We will bisect and let you know more details about this reported problem.
> 
> The bisect script pointed me to this commit and  reverted and tested and
> confirmed.
> 

I see the same error messages after enabling CONFIG_KFENCE_KUNIT_TEST, but
it doesn't go away after removing the patch below. That patch also seems
to be completely unrelated to the error.

I also see the same problem in the mainline kernel. I suspect that something
is wrong with CONFIG_KFENCE_KUNIT_TEST.

Guenter

> commit 1883088ed4a0d5cc9cea500ca4e89a354ab32c11
> Author: Jia-Ju Bai <baijiaju1990@gmail.com>
> Date:   Fri May 27 23:28:18 2022 +0800
> 
>      md: bcache: check the return value of kzalloc() in detached_dev_do_request()
> 
>      commit 40f567bbb3b0639d2ec7d1c6ad4b1b018f80cf19 upstream.
> 
>      The function kzalloc() in detached_dev_do_request() can fail, so its
>      return value should be checked.
> 
>      Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached
> bcache devices")
>      Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>      Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>      Signed-off-by: Coly Li <colyli@suse.de>
>      Link: https://lore.kernel.org/r/20220527152818.27545-4-colyli@suse.de
>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index d15aae6c51c1..673a680240a9 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
> bcache_device *d, struct bio *bio,
>           * which would call closure_get(&dc->disk.cl)
>           */
>          ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> +       if (!ddip) {
> +               bio->bi_status = BLK_STS_RESOURCE;
> +               bio->bi_end_io(bio);
> +               return;
> +       }
> +
>          ddip->d = d;
>          /* Count on the bcache device */
>          ddip->orig_bdev = orig_bdev;
> 
> 
> 
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>> [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17.13-773-gd0f9b2818e1e/testrun/10038101/suite/kunit/test/kasan/details/
>> [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17.13-773-gd0f9b2818e1e/testrun/10038215/suite/kunit/test/kfence/details/
>>
>> ## Build
>> * kernel: 5.17.14-rc1
>> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>> * git branch: linux-5.17.y
>> * git commit: d0f9b2818e1e4d43847e10d6e5310a0c653cb18f
>> * git describe: v5.17.13-773-gd0f9b2818e1e
>> * test details:
>> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17.13-773-gd0f9b2818e1e
>>
>> ## Test Regressions (compared to v5.17.11-188-g8eb69e8f0d45)
>> Regressions found on qemu_x86_64:
>>    - kunit/kasan [1]
>>
>> Regressions found on qemu_i386:
>>    - kunit/kfence [2]
>>    - kunit/test_out_of_bounds_read
>>
>> ## Metric Regressions (compared to v5.17.11-188-g8eb69e8f0d45)
>> No metric regressions found.
>>
>> ## Test Fixes (compared to v5.17.11-188-g8eb69e8f0d45)
>> No test fixes found.
>>
>> ## Metric Fixes (compared to v5.17.11-188-g8eb69e8f0d45)
>> No metric fixes found.
>>
>> ## Test result summary
>> total: 134591, pass: 121555, fail: 447, skip: 11730, xfail: 859
>>
>> ## Build Summary
>> * arm: 17 total, 14 passed, 3 failed
>> * arm64: 20 total, 20 passed, 0 failed
>> * i386: 17 total, 12 passed, 5 failed
>> * mips: 4 total, 1 passed, 3 failed
>> * parisc: 2 total, 2 passed, 0 failed
>> * powerpc: 5 total, 2 passed, 3 failed
>> * riscv: 5 total, 5 passed, 0 failed
>> * s390: 5 total, 2 passed, 3 failed
>> * sh: 2 total, 0 passed, 2 failed
>> * sparc: 2 total, 2 passed, 0 failed
>> * x86_64: 20 total, 20 passed, 0 failed
>>
>> ## Test suites summary
>> * fwts
>> * kunit
>> * kvm-unit-tests
>> * libgpiod
>> * libhugetlbfs
>> * log-parser-boot
>> * log-parser-test
>> * ltp-cap_bounds
>> * ltp-cap_bounds-tests
>> * ltp-commands
>> * ltp-commands-tests
>> * ltp-containers
>> * ltp-containers-tests
>> * ltp-controllers-tests
>> * ltp-cpuhotplug-tests
>> * ltp-crypto
>> * ltp-crypto-tests
>> * ltp-cve-tests
>> * ltp-dio-tests
>> * ltp-fcntl-locktests
>> * ltp-fcntl-locktests-tests
>> * ltp-filecaps
>> * ltp-filecaps-tests
>> * ltp-fs
>> * ltp-fs-tests
>> * ltp-fs_bind
>> * ltp-fs_bind-tests
>> * ltp-fs_perms_simple
>> * ltp-fs_perms_simple-tests
>> * ltp-fsx
>> * ltp-fsx-tests
>> * ltp-hugetlb
>> * ltp-hugetlb-tests
>> * ltp-io
>> * ltp-io-tests
>> * ltp-ipc
>> * ltp-ipc-tests
>> * ltp-math-tests
>> * ltp-mm-tests
>> * ltp-nptl
>> * ltp-nptl-tests
>> * ltp-open-posix-tests
>> * ltp-pty
>> * ltp-pty-tests
>> * ltp-sched-tests
>> * ltp-securebits
>> * ltp-securebits-tests
>> * ltp-syscalls-tests
>> * ltp-tracing-tests
>> * network-basic-tests
>> * packetdrill
>> * perf
>> * rcutorture
>> * ssuite
>> * v4l2-compliance
>> * vdso
>>
>> --
>> Linaro LKFT
>> https://lkft.linaro.org


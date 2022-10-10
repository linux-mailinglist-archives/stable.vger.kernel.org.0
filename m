Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE1E5FA14F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJJPmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 11:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiJJPmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 11:42:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD40873314
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 08:42:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w10so16470427edd.4
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 08:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nk5wWmegP5wxx6rACsCsUdyEYRHXJDoimmUOVoM3zZQ=;
        b=I2JXumw7HQorGlHKvrKWRgKvWGXU0kocWmWkuMX2h9H5qsF64Qi1sTslpypZxte5++
         WnOgjTDhe9DLXmGiU/LQQlJ0qD3YdChBLgVMsMIde2IT1NPJaFWWSW/omcNbu0xFrTRT
         dGzj9cpJtFwG8BfRuqu3p+lqBw74V/iPFOlNO4ft0FBSULzcsi6UDbF9MOt36sPTM02y
         to3Yu6/YoZBiz4t47pzC8c/As9spleR4B3Cy0FMRKMZu0w4U+HnDtGBLGxV78Zv2rKUL
         vb5Q40Ldtd56/EvWTwjSjtVM6AygrmdYhWNSK0r/QpmKctvmZeD+0V1eiaIvrJahvw64
         1QzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nk5wWmegP5wxx6rACsCsUdyEYRHXJDoimmUOVoM3zZQ=;
        b=HfrjaBUV7aLBlufwQbxoG71uov7YXMHjwqEbKHUeCXXEO1EzC22aCEEeT+j/75d614
         OzmL8Qj4DDrE4nHZO4PQndv90ixX3RWJH2UbBJlIKGaPtSzUV+74D0555eNRRydBgTny
         cwhcyfGX4YPRswOgaWuS7ZLRkrnuJYA7NUaROGcs9S9jTzea0ruRznnMg3oLqidVbWEd
         wQdfnb0vX1ZxB1ZLpeENbqdnSK63kz7oOyvu+WzqHokmbYXPETXRAOO0oYPyAPRykcN1
         m7BA2re7Q/q0X35lIpOBfS8jODxdeIRHQ7JOOZi4rezwcvahvH6fgDeSymsG3pa5aoGr
         LEnw==
X-Gm-Message-State: ACrzQf1Me431+ADW6EgA8Rn4wno7rgdT4NoG/ap1JrGZB8Q8FuRUafOe
        z9ZxhwkOlMkLSCaA2m10SJ4qAG8iJwbZ+TzbaTj+GA==
X-Google-Smtp-Source: AMsMyM4LNYsD1X+jeQfAwmyYltxIJWpgRpcpQ5ebFzrFIuLa5ekWqirBMbGeoot2eahcLB4OPn4HntZeA7b+XJHJllQ=
X-Received: by 2002:aa7:d38f:0:b0:458:8d32:d642 with SMTP id
 x15-20020aa7d38f000000b004588d32d642mr18374819edq.208.1665416524234; Mon, 10
 Oct 2022 08:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221010070330.159911806@linuxfoundation.org>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Oct 2022 21:11:52 +0530
Message-ID: <CA+G9fYsd1sfffWH8imz=YYZkThs+05RucpZzcozztK1vp8LydA@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Oct 2022 at 12:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following kernel crash reported on arm64 db410c.
This reported [1] on Linux next-20220614 and not a new issue.
However, We will investigate this device's specific issues.

[   10.387800] Internal error: Oops: 8600000f [#1] PREEMPT SMP
[   10.492941] Internal error: Oops: 96000006 [#2] PREEMPT SMP
[   10.880744] Internal error: Oops: 96000006 [#3] PREEMPT SMP
[   11.575707] Internal error: Oops: 96000006 [#4] PREEMPT SMP

Crash log:
[   10.348663] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[   10.369488] Mem abort info:
[   10.369630]   ESR = 0x0000000096000006
[   10.371870]   EC = 0x25: DABT (current EL), IL = 32 bits
[   10.373514] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[   10.381921] Mem abort info:
[   10.382116]   SET = 0, FnV = 0
[   10.387666] Unable to handle kernel execute from non-executable
memory at virtual address ffff00000213afc8
[   10.387683] Mem abort info:
[   10.387690]   ESR = 0x000000008600000f
[   10.387699]   EC = 0x21: IABT (current EL), IL = 32 bits
[   10.387709]   SET = 0, FnV = 0
[   10.387718]   EA = 0, S1PTW = 0
[   10.387726]   FSC = 0x0f: level 3 permission fault
[   10.387735] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000081f4a000
[   10.387747] [ffff00000213afc8] pgd=18000000bfef7003,
p4d=18000000bfef7003, pud=18000000bfef6003, pmd=18000000bfef3003,
pte=006800008213af07
[   10.387800] Internal error: Oops: 8600000f [#1] PREEMPT SMP
[   10.387807] Modules linked in: venus_enc(+) videobuf2_dma_contig
qcom_wcnss_pil adv7511 cec snd_soc_lpass_apq8016 snd_soc_lpass_cpu
snd_soc_msm8916_digital snd_soc_lpass_platform qrtr qcom_q6v5_mss
snd_soc_apq8016_sbc qcom_pil_info snd_soc_qcom_common qcom_spmi_vadc
qcom_q6v5 snd_soc_msm8916_analog qcom_spmi_temp_alarm qcom_pon
qcom_sysmon rtc_pm8xxx msm qcom_vadc_common qcom_camss qcom_common
venus_core qcom_glink_smem qmi_helpers videobuf2_dma_sg v4l2_fwnode
gpu_sched i2c_qcom_cci v4l2_mem2mem qcom_rng v4l2_async qnoc_msm8916
drm_dp_aux_bus qcom_stats mdt_loader drm_display_helper
videobuf2_memops videobuf2_v4l2 videobuf2_common crct10dif_ce
icc_smd_rpm display_connector drm_kms_helper rmtfs_mem socinfo fuse
drm
[   10.387979] CPU: 1 PID: 278 Comm: systemd-udevd Not tainted 6.0.1-rc1 #1
[   10.387988] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[   10.387993] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   10.388003] pc : 0xffff00000213afc8
[   10.388013] lr : sysfs_kf_seq_show+0xb4/0x130

ref:
[1] https://lore.kernel.org/linux-arm-kernel/YqnfRyJkhPCVBmDz@FVFF77S0Q05N/T/
[2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0-18-g6556cadf037c/testrun/12319851/suite/log-parser-boot/tests/

## Build
* kernel: 6.0.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 6556cadf037c53a554c4eadd80a3bd652f38b208
* git describe: v6.0-18-g6556cadf037c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0-18-g6556cadf037c

## No Test Regressions (compared to v6.0)

## No Metric Regressions (compared to v6.0)

## No Test Fixes (compared to v6.0)

## No Metric Fixes (compared to v6.0)

## Test result summary
total: 114438, pass: 102109, fail: 1135, skip: 11045, xfail: 149

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 329 passed, 4 failed
* arm64: 65 total, 65 passed, 0 failed
* i386: 55 total, 55 passed, 0 failed
* mips: 56 total, 55 passed, 1 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 58 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-net
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

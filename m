Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0871696488
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 14:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjBNNVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 08:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjBNNVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 08:21:50 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BC327D5A
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 05:21:19 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id k6so16481156vsk.1
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 05:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676380873;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EmsTFYMpVQ0UZlUAV3mNl4dHsMwWm8lE6OUikZcSOmM=;
        b=kSOXmsCVmYmCcuSrXE/wwiUEkDxHGX/UE+iBd7yTgqnkguLfKUPg+qn/dtrvTnp6kI
         RZBDAaiWi1mrQrNq7tWSO9G7M12dU63i5yMx2WBkNoY/ARWGreflnjQVNDgBedHAqhPV
         mXWLHR74OAdwcQRKMwbrfem5ZXePNAMRZsBm8v40WuxGpp0h8/UU+r4EmZBjIKq/zkmo
         sYysI5sCz8INXivVA5THxzH4A2Ppb4+y0+5AmlElULORyf0fIF0JHfhnjmUAtyLcfDqV
         EUwT475BUrXe32WWvpJZevDts4H2KsiULJIua0Pu58uxfyovV1QTJ1FWfHIp4KQWowtp
         N1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676380873;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EmsTFYMpVQ0UZlUAV3mNl4dHsMwWm8lE6OUikZcSOmM=;
        b=lVRKGJpzpwTISZ+EJ0XmA7A2B4p09VAD79Vsf4HYuT1qZJlwz6SH3tPubdN65Z1cas
         5ITRjT00B8naJdqcdhUXsRwoH8vflV53pEOzk8/Vv4CvsXDxT+33ibih/h7eEY0ta1Jf
         QQoykvl7cSTd/qbHrSakn0/vTEPifnsIVWA201cwX9u/fdCcXMoRQRjlWzyPoI9/kHEr
         xZRoo/YOVayy8ABhUPz8U6YyYRjcpF2UpK7JOO5HMexr1cg/tBuwIB16Zwre6USNmxjX
         CQ2theJieAk/J5P3ot/KIL2+37Kd6K66TViemtWk3tINDRjwGMhfS4yn8dA3mmDrb5vc
         Q4/w==
X-Gm-Message-State: AO0yUKVrYNhXAeogK9BUlyKok8MHiNa9Gwvcd3+znel/7KJnLUwGKA2O
        a5Qr9gTS3K2CIHMPPpLn8CYbwmuC5wIlFi6FKAF0JQ==
X-Google-Smtp-Source: AK7set9cdoywccEgw20B1asvJX2xthwXPZ+9tykC1LIzVkIQQRSKmZhJz8+N/PUqJIAejaLqhnL46JX8HySJtHsZ2Ts=
X-Received: by 2002:a05:6102:7d6:b0:412:23d9:be84 with SMTP id
 y22-20020a05610207d600b0041223d9be84mr419951vsg.29.1676380872731; Tue, 14 Feb
 2023 05:21:12 -0800 (PST)
MIME-Version: 1.0
References: <20230213144745.696901179@linuxfoundation.org> <cc3f4cfb-adbc-c3b7-1c21-bb28e98499d8@gmail.com>
 <CA+G9fYvz7_C8ugBPkx5uf_2LBhsGytXnhG3JC4EYb0CEkFb+Jg@mail.gmail.com>
In-Reply-To: <CA+G9fYvz7_C8ugBPkx5uf_2LBhsGytXnhG3JC4EYb0CEkFb+Jg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Feb 2023 18:51:01 +0530
Message-ID: <CA+G9fYsTyg_kXBizEi+DOhKkkwm0fx9DdbHFmMy-rYx6Kg5Bhw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        rmk+kernel@armlinux.org.uk
Cc:     stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        christophe.kerello@foss.st.com, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Feb 2023 at 14:46, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Hi Greg and Florian,
>
> On Tue, 14 Feb 2023 at 01:20, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.168 release.
> > > There are 139 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > There is a regression coming from:
> >
> > nvmem: core: fix registration vs use race
> >
> > which causes the following to happen for MTD devices:
> >
> > [    6.031640] kobject_add_internal failed for mtd0 with -EEXIST, don't
> > try to register things with the same name in the same directory.
> > [    7.846965] spi-nor: probe of spi0.0 failed with error -17
> >
> > attached is a full log with the call trace. This does not happen with
> > v6.2-rc8 where the MTD partitions are successfully registered.qfprom
>
> Like said above,
> [    5.965191] kobject_add_internal failed for qfprom0 with -EEXIST,
> don't try to register things with the same name in the same directory.
> [    5.969110] qcom,qfprom: probe of 5c000.qfprom failed with error -17
>
> Following kernel crash noticed on arm64 Qcom dragonboard 410c
> device.
>
> We will bisect this problem and get back to you soon.

Our bisection found this as the first bad commit and reverting this patch
solved the reported problem.

first bad commit: [a4aee79941de8559ce6e28d47fad22efc89bfe92]
       nvmem: core: fix registration vs use race


> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd030]
> [    0.000000] Linux version 5.10.168-rc1 (tuxmake@tuxmake)
> (aarch64-linux-gnu-gcc (Debian 11.3.0-11) 11.3.0, GNU ld (GNU Binutils
> for Debian) 2.40) #1 SMP PREEMPT @1676300748
> [    0.000000] Machine model: Qualcomm Technologies, Inc. APQ 8016 SBC
> ..
> [    5.808975] usbhid: USB HID core driver
> [    5.827592] genirq: irq_chip msmgpio did not update eff. affinity
> mask of irq 75
> [    5.845725] sysfs: cannot create duplicate filename
> '/devices/platform/soc/5c000.qfprom/qfprom0'
> [    5.845994] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.10.168-rc1 #1
> [    5.853735] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [    5.860077] Call trace:
> [    5.866760]  dump_backtrace+0x0/0x1f0
> [    5.868952]  show_stack+0x20/0x30
> [    5.872766]  dump_stack+0x110/0x160
> [    5.876068]  sysfs_warn_dup+0x6c/0x90
> [    5.879371]  sysfs_create_dir_ns+0xf0/0x110
> [    5.883201]  kobject_add_internal+0xa0/0x324
> [    5.887195]  kobject_add+0x94/0x10c
> [    5.891693]  device_add+0xfc/0x780
> [    5.894902]  nvmem_register+0x6fc/0x930
> [    5.898383]  devm_nvmem_register+0x4c/0x94
> [    5.902121]  qfprom_probe+0x1e0/0x29c
> [    5.906279]  platform_drv_probe+0x5c/0xb4
> [    5.910021]  really_probe+0xf8/0x52c
> [    5.914004]  driver_probe_device+0xfc/0x170
> [    5.917663]  device_driver_attach+0xd0/0xe0
> [    5.921567]  __driver_attach+0xd4/0x194
> [    5.925729]  bus_for_each_dev+0x78/0xdc
> [    5.929546]  driver_attach+0x2c/0x40
> [    5.933361]  bus_add_driver+0x154/0x254
> [    5.937183]  driver_register+0x80/0x13c
> [    5.940745]  __platform_driver_register+0x50/0x5c
> [    5.944583]  qfprom_driver_init+0x24/0x30
> [    5.949428]  do_one_initcall+0x8c/0x470
> [    5.953419]  kernel_init_freeable+0x320/0x38c
> [    5.957077]  kernel_init+0x1c/0x128
> [    5.961570]  ret_from_fork+0x10/0x30
> [    5.965191] kobject_add_internal failed for qfprom0 with -EEXIST,
> don't try to register things with the same name in the same directory.
> [    5.969110] qcom,qfprom: probe of 5c000.qfprom failed with error -17
> [    6.000014] netem: version 1.3
> [    6.000346] ipip: IPv4 and MPLS over IPv4 tunneling driver
> [    6.005040] gre: GRE over IPv4 demultiplexor driver
> [    6.007652] ip_gre: GRE over IPv4 tunneling driver
> [    6.018597] IPv4 over IPsec tunneling driver
> [    6.024506] NET: Registered protocol family 10
> [    6.031635] Segment Routing with IPv6
> [    6.036627] ip6_gre: GRE over IPv6 tunneling driver
> [    6.039047] NET: Registered protocol family 17
> [    6.042070] 8021q: 802.1Q VLAN Support v1.8
> [    6.045837] 9pnet: Installing 9P2000 support
> [    6.049608] Key type dns_resolver registered
> [    6.055585] registered taskstats version 1
> [    6.057828] Loading compiled-in X.509 certificates
> [    6.393191] debugfs: Directory '4a9000.thermal-sensor' with parent
> 'tsens' already present!
>
>
> please refer following link for more details on boot and test logs,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.167-140-g65fa84413c15/testrun/14762346/suite/log-parser-test/test/check-kernel-exception/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.167-140-g65fa84413c15/testrun/14762346/suite/log-parser-test/test/check-kernel-exception/details/
>
> metadata:
>   git_ref: linux-5.10.y
>   git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git_sha: 65fa84413c15ee131ad4b76077c48f0603d1d8ec
>   git_describe: v5.10.167-140-g65fa84413c15
>   kernel_version: 5.10.168-rc1
>   kernel-config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2LglWCZtZStAHvQWoY1YTAIT2ws/config
>   build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/776087062
>   artifact-location:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2LglWCZtZStAHvQWoY1YTAIT2ws
>   toolchain: gcc-11
>

- Naresh

> --
> Linaro LKFT
> https://lkft.linaro.org
>
> > --
> > Florian

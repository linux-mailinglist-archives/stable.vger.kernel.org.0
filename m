Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160333D6D3F
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 06:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhG0EXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 00:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhG0EXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 00:23:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B4FC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 21:23:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i1so14317465plr.9
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 21:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IPXnht1784Ewh6No1tXDtsgaasHBybk6H6OhpfZTVdk=;
        b=BD9jwQzWXJh3qzGh+dB2VRcrM+GSZdpqOs/6dC6oyNoEVM0pEk07zOtgF/KTB3toJg
         0iB7dRMuLnxFuG7mEccCxg7g17WKKaaS+DIFHrVWxtMU/rzy6n5OwAaE0HoW1bXr1Eqo
         qvHWvmQ6nBHc/ynkNwR/ni1uvUqMVQ0Bq925m5YVNRekdQu7kDs/JHg6JXWw0d2MVV13
         qFug8INq2g1dZXfmhvKhOWlqOSfuXsesUJa2R4EsF1M0oZF54hMVZ5/gTUByYQnWLLMt
         WlkLXKfbk8eLStQmMdFwTy3nAvXSprOlH+ZKwl/sEG7GNIQWydbdiBpasbGD9fj3jaBN
         yK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IPXnht1784Ewh6No1tXDtsgaasHBybk6H6OhpfZTVdk=;
        b=QMPYEm9eziTs+m4QdpJYO7K1eGD1aAIil7MaKS7DW/cLEuFAYiaVmlT+Fa575QZo5K
         7UtFn22Ua+wQuTUeVZuLRv8FOub1EFh09wH3PkpzSkOlW/V1+KvTLnjJUTrLRuepkt1d
         bTVXadcqaUwO39q/1K5buzjVmVbMgVb8Helnv0IZlPvI89hXyCSPTVdVgz9ORUoXlvns
         N/fYMcbTPkE4fsnwI/iuoKNyd2wIowRt/n1noKzWjit2z9gbMCK76bxIg91PKSApPNLV
         uk8bJv7YOTaGqXOHlrrPWcSlpoRLNs3tCl1zpHr6VRNo2bSUDkeiNpaghWCJtOdVfcE8
         NmEg==
X-Gm-Message-State: AOAM532Awd5my81WVHkUH/bNeKSNztm3juHGlCek5iV9bv5jt53K9NFX
        a9CE7Tu7R5fzt2s19qSSbh8Mbo7bZr9qCFdA
X-Google-Smtp-Source: ABdhPJxe70JeIlbCq4zYi4szXIkDn3DW8BpmMW15tBSiB+hBVkuW5z9U9xCCVG94qCg0YMA+1KiIrw==
X-Received: by 2002:aa7:8a07:0:b029:332:958b:7f07 with SMTP id m7-20020aa78a070000b0290332958b7f07mr21367958pfa.70.1627359831682;
        Mon, 26 Jul 2021 21:23:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm1532208pgb.43.2021.07.26.21.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 21:23:51 -0700 (PDT)
Message-ID: <60ff8a57.1c69fb81.2b059.6a3c@mx.google.com>
Date:   Mon, 26 Jul 2021 21:23:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.135
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 180 runs, 10 regressions (v5.4.135)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 180 runs, 10 regressions (v5.4.135)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
             | 1          =

hifive-unleashed-a00 | riscv  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

rk3288-veyron-jaq    | arm    | lab-collabora | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.135/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.135
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0a0beb1f9120cf49a429e12f4ea69ddd74471d68 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff53b4f7d0afe7d93a2f4b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff53b4f7d0afe7d93a2=
f4c
        failing since 7 days (last pass: v5.4.131, first fail: v5.4.133) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff65af9fb5f726213a2f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/x8=
6_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/x8=
6_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff65af9fb5f726213a2=
f27
        failing since 7 days (last pass: v5.4.131, first fail: v5.4.133) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hifive-unleashed-a00 | riscv  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff52e98d79b2856b3a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff52e98d79b2856b3a2=
f23
        failing since 250 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff5116871d0830e83a2f35

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff5116871d0830e83a2=
f36
        failing since 250 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff6b34ebcf6e47c03a2f3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff6b34ebcf6e47c03a2=
f40
        failing since 250 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff508102d70456c13a2f2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff508102d70456c13a2=
f30
        failing since 250 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff5031634553244d3a2f4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff5031634553244d3a2=
f50
        failing since 250 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
rk3288-veyron-jaq    | arm    | lab-collabora | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60ff87a03853c99ca53a2f23

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.135/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ff87a03853c99ca53a2f37
        failing since 40 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-27T04:12:10.995454  /lava-4251562/1/../bin/lava-test-case
    2021-07-27T04:12:11.014617  <8>[   15.255310] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-27T04:12:11.015051  /lava-4251562/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ff87a03853c99ca53a2f4f
        failing since 40 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-27T04:12:09.571598  /lava-4251562/1/../bin/lava-test-case
    2021-07-27T04:12:09.572279  <8>[   13.830017] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ff87a03853c99ca53a2f50
        failing since 40 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-27T04:12:08.555724  /lava-4251562/1/../bin/lava-test-case<8>[  =
 12.810577] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-27T04:12:08.556280     =

 =20

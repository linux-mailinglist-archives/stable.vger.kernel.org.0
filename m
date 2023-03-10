Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8876B55A2
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 00:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjCJXa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 18:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCJXa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 18:30:57 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21A013869E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:30:54 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so11427475pjg.4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678491054;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LjgyPf3J0Rld+HF6o9Yp1xnOffOgN2++aGG6qIzKuNE=;
        b=Fgm3pZPNKxcvDuXL6y48Cc+6BspjYznwtK9qGDIY9IRKLd7Y0F1vuw6PYpYA44YwvB
         uGiBfBeym9gPT0RQWdmoVO1hq06lzyYiHJPogTNWaBF/+T3Nk8aZb84gaBFwwYbyUi9X
         fNm3jZoemAJ9xuyCef/sfGelJcpUBJlQQs7We5WHOXekS9SbYOmMlnawxW+nfvMilE5X
         Eko3FcLLLS/gjCAAg5n18Qp3ozk6Cw+IzerEiBaD0tmdP9dqvQ+83Cqe72PvRvAPyBws
         J92OXIhsghHwo0iYCrQazA4JDdjbEk5hsT726UaPOsTJ1kizVWtkEeSlYsO1TGOx99XL
         nztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678491054;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjgyPf3J0Rld+HF6o9Yp1xnOffOgN2++aGG6qIzKuNE=;
        b=sDC9+wY/f3QW9fMHfi0xN3i4OMYUJxGytDIgkTK2d6TRLnbm4CMJRcGdXEZN1M6RS/
         HUuB/LtTDH8UieVpa8zSvCpAUzGWtY8cU6dQnKQ5xcavIM8OHyvpzdIHaFDPAz7u1jhS
         dpnBWgfdPi2IeG9Xqc8CUgJYFmOhZHf0YcSxm0b3ViX701wkxJoNg1i6TvhXVRbAtGTh
         gGb5aZjYDSNN1jphl9emW6NejgrJgATpuBjc3HqhVAt4dq5xX04OplqTKl53yA/8Vm9K
         jU+Vh/WoVgVJcXvpl62WG/6UTRxSzvThGhgYwXGZRoHixP5ZGxXqGDJhLxIax+25NNsW
         0nIw==
X-Gm-Message-State: AO0yUKV7ZNnA2yCmVVovxXR1twxpcMfT3HkeNeXakJY3z9Trt71hgRs4
        xvUpUXwy0FnDhUJ06PySUzg3mz1mH6OO2uKGk7D6sK+c
X-Google-Smtp-Source: AK7set9DB1n9zcazmpZVg3ecY6WaqkFGsb9GEqwynkplG9juHW0Q/WbD5xXYPcAbLt0ntp0cwRMENw==
X-Received: by 2002:a17:903:2441:b0:196:5bac:e319 with SMTP id l1-20020a170903244100b001965bace319mr33319308pls.35.1678491053936;
        Fri, 10 Mar 2023 15:30:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lh11-20020a170903290b00b0019b0b6a1d5bsm450564plb.273.2023.03.10.15.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 15:30:53 -0800 (PST)
Message-ID: <640bbdad.170a0220.695d.177e@mx.google.com>
Date:   Fri, 10 Mar 2023 15:30:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-530-g420427e5b0dd4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 182 runs,
 16 regressions (v5.10.172-530-g420427e5b0dd4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 182 runs, 16 regressions (v5.10.172-530-g4=
20427e5b0dd4)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
cubietruck             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =

qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.172-530-g420427e5b0dd4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.172-530-g420427e5b0dd4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      420427e5b0dd499d0e1ba2ccbd30717bb5b36335 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
cubietruck             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b27917e4d2a028c8643

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b8b27917e4d2a028c864c
        failing since 51 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-10T19:54:58.445057  + set +x<8>[   11.078897] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3403248_1.5.2.4.1>
    2023-03-10T19:54:58.445339  =

    2023-03-10T19:54:58.555880  / # #
    2023-03-10T19:54:58.658044  export SHELL=3D/bin/sh
    2023-03-10T19:54:58.658536  #
    2023-03-10T19:54:58.759943  / # export SHELL=3D/bin/sh. /lava-3403248/e=
nvironment
    2023-03-10T19:54:58.760588  =

    2023-03-10T19:54:58.865508  / # . /lava-3403248/environment/lava-340324=
8/bin/lava-test-runner /lava-3403248/1
    2023-03-10T19:54:58.870470  =

    2023-03-10T19:54:58.871558  / # <3>[   11.451885] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8a5396003f28598c86e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8a5396003f28598c8=
6e1
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8a361923de707e8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_=
i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_=
i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8a361923de707e8c8=
631
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8a25f6128cdf918c86dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qem=
u_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qem=
u_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8a25f6128cdf918c8=
6de
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b6c65895b531e8c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8b6c65895b531e8c8=
63d
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8da9a1b1ad25828c86d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8da9a1b1ad25828c8=
6d9
        failing since 24 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b7065895b531e8c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8b7065895b531e8c8=
64b
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8db6c9c728969a8c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8db6c9c728969a8c8=
660
        failing since 24 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b290bfd4424318c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8b290bfd4424318c8=
630
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8d31f5ee0f65268c865b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8d31f5ee0f65268c8=
65c
        failing since 24 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b6a0bfd4424318c8693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8b6a0bfd4424318c8=
694
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8dbe5bef8f0a4f8c864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8dbe5bef8f0a4f8c8=
64e
        failing since 24 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b48d7d86a7e2f8c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8b48d7d86a7e2f8c8=
655
        failing since 25 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8db85bef8f0a4f8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8db85bef8f0a4f8c8=
636
        failing since 24 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8d32f5ee0f65268c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8d32f5ee0f65268c8=
660
        failing since 24 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8bb4620ffc78098c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-530-g420427e5b0dd4/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8bb4620ffc78098c8=
656
        failing since 7 days (last pass: v5.10.170, first fail: v5.10.172) =

 =20

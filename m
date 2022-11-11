Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127556251C1
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 04:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiKKDiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 22:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKKDiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 22:38:13 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ADB5985A
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 19:38:12 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b62so3444088pgc.0
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 19:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9WzXvwqqnhUzwDBG5EXwN5XMdtNW6sMLbqrY+fWYkUo=;
        b=H/pIJmETF+QPSf+WLkfzMavR9xr+va1NdsZ/iHtAcIJhnfSBGTDwx03iUEBLvRkyaO
         0mvqLun9+XWDGMfTKrVRob6ODOYchen50gPclboaAWve1VGSIt9lWSFrXCN5nHlTmSs1
         cQdnlltL4J/Iq82ssO0iI6BOJVhizwxcFalFFg5PEVxjGOPgt5OnBsj884Yci4OlWQdt
         gkyqEV0z0pDN+7jBRaicjtXS8fGj2AXXVVu0YWcpHqkCMt2h9IdT8GRKHXMdUMrdPFOL
         VOhUTBQfkvECMhE//mvGn6bHee/rupA17Sd6/OAgwJOPxyYt7dKwr9BVu9zkGyugLRKs
         s9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9WzXvwqqnhUzwDBG5EXwN5XMdtNW6sMLbqrY+fWYkUo=;
        b=1ZyE2279tiqfTYkR3ZuAGvyvPGpNN51Dwo284GJj7T5qVcTNegDSLMVG2eMiZKUqNf
         quQDeO/KZOe+bSB27oeOnvy7428q8fG3K63xSCZ4MhcNcUOzy+9WnlskM/ksctMYVTIB
         eIhc2g2JSKbireu1KFOrTSjnO3ANSZ7IMxejxUNpWzT1uEzWsquSgl09k7EkDtnHKcbb
         Wcia/4pLy9NI6Wx+B8MH/TfdhguP75IES60RZCYclm8dAo9nR/7R0G0r79Aml+7ZhGFv
         guUuVONBCNyrBvpYVTb+TMR+jrdwNeoDtoq+Ayyw4IOD6NNaftWQ/wkpEJcOYAMWGTLO
         cMCA==
X-Gm-Message-State: ANoB5pneqTJGDVy2tp4r0yv1N88xy+mJUbIvZ5c7c7Ucb/2Cn0NYc7aU
        JciUpkMCy3s2ovo+maSsqxSHuPOQDB8rDSLU/Ic=
X-Google-Smtp-Source: AA0mqf5qr7hYr8hVCfz6FrOK6dkZHUwAPzsCPPXarGdKPbjms0J80RoUhbcFkvj52SDQxQn/UZeXnw==
X-Received: by 2002:a05:6a00:4489:b0:565:dc13:bb6b with SMTP id cu9-20020a056a00448900b00565dc13bb6bmr699068pfb.45.1668137891503;
        Thu, 10 Nov 2022 19:38:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2-20020a622702000000b0056bbeaa82b9sm425109pfn.113.2022.11.10.19.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 19:38:11 -0800 (PST)
Message-ID: <636dc3a3.620a0220.f8b54.1146@mx.google.com>
Date:   Thu, 10 Nov 2022 19:38:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.224
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 117 runs, 15 regressions (v5.4.224)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 117 runs, 15 regressions (v5.4.224)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =

hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-10   | defconfig=
                  | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.224/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.224
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      771a8acbb84145b943bd608ba376e104ebfa9664 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/636d9eca0f5956b833e7db53

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
636d9eca0f5956b833e7db57
        new failure (last pass: v5.4.223)

    2022-11-11T01:00:44.259529  /lava-5835575/1/../bin/lava-test-case
    2022-11-11T01:00:44.260400  <8>[   25.096055] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2022-11-11T01:00:44.260793  /lava-5835575/1/../bin/lava-test-case   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/636d9eca0f5956b8=
33e7db5a
        new failure (last pass: v5.4.223)
        1 lines

    2022-11-11T01:00:41.066314  / # =

    2022-11-11T01:00:41.072580  =

    2022-11-11T01:00:41.178720  / # #
    2022-11-11T01:00:41.184443  #
    2022-11-11T01:00:41.286645  / # export SHELL=3D/bin/sh
    2022-11-11T01:00:41.296341  export SHELL=3D/bin/sh
    2022-11-11T01:00:41.398177  / # . /lava-5835575/environment
    2022-11-11T01:00:41.408518  . /lava-5835575/environment
    2022-11-11T01:00:41.510395  / # /lava-5835575/bin/lava-test-runner /lav=
a-5835575/0
    2022-11-11T01:00:41.520560  /lava-5835575/bin/lava-test-runner /lava-58=
35575/0 =

    ... (8 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-10   | defconfig=
                  | 2          =


  Details:     https://kernelci.org/test/plan/id/636d915dedf4976c9ee7db4e

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/riscv/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
636d915dedf4976c9ee7db52
        failing since 15 days (last pass: v5.4.219, first fail: v5.4.220)

    2022-11-11T00:03:34.685016  sbin:/bin:/usr/bin'
    2022-11-11T00:03:34.685218  + cd /opt/bootrr
    2022-11-11T00:03:34.685374  + sh helpers/bootrr-auto
    2022-11-11T00:03:34.685532  /lava-2846543/1/../bin/lava-test-case
    2022-11-11T00:03:35.672086  /lava-2846543/1/../bin/lava-test-case
    2022-11-11T00:03:35.724473  <8>[   24.390501] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/636d915dedf4976c=
9ee7db57
        failing since 15 days (last pass: v5.4.219, first fail: v5.4.220)
        3 lines

    2022-11-11T00:03:21.424881  / # =

    2022-11-11T00:03:21.425808  =

    2022-11-11T00:03:23.490571  / # #
    2022-11-11T00:03:23.491176  #
    2022-11-11T00:03:25.504498  / # export SHELL=3D/bin/sh
    2022-11-11T00:03:25.504889  export SHELL=3D/bin/sh
    2022-11-11T00:03:27.520401  / # . /lava-2846543/environment
    2022-11-11T00:03:27.520817  . /lava-2846543/environment
    2022-11-11T00:03:29.536491  / # /lava-2846543/bin/lava-test-runner /lav=
a-2846543/0
    2022-11-11T00:03:29.537637  /lava-2846543/bin/lava-test-runner /lava-28=
46543/0 =

    ... (9 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d929dc020dd752fe7db79

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d929dc020dd752fe7d=
b7a
        failing since 43 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/636d933d657dc5ec4ee7db6a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d933d657dc5ec4ee7d=
b6b
        failing since 185 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d92791bf79e36e3e7db51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d92791bf79e36e3e7d=
b52
        failing since 43 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d929e9677b10ca3e7db52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d929e9677b10ca3e7d=
b53
        failing since 185 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/636d933a657dc5ec4ee7db66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d933a657dc5ec4ee7d=
b67
        failing since 185 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d92a0032dd9b748e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d92a0032dd9b748e7d=
b50
        failing since 91 days (last pass: v5.4.180, first fail: v5.4.210) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/636d933c9979d90b31e7db51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d933c9979d90b31e7d=
b52
        failing since 185 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d927aa54b8e57e7e7db9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d927aa54b8e57e7e7d=
b9b
        failing since 91 days (last pass: v5.4.180, first fail: v5.4.210) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d929f6574d0f8bbe7db86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d929f6574d0f8bbe7d=
b87
        failing since 185 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/636d9327c82c884796e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d9327c82c884796e7d=
b50
        failing since 185 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d9392b09c9b11bce7db68

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.224/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/636d9392b09c9b11bce7db8a
        failing since 247 days (last pass: v5.4.181, first fail: v5.4.183)

    2022-11-11T00:12:43.588756  <8>[   32.034730] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-11-11T00:12:43.589032  =

    2022-11-11T00:12:44.601259  /lava-7939228/1/../bin/lava-test-case
    2022-11-11T00:12:44.609666  <8>[   33.055822] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

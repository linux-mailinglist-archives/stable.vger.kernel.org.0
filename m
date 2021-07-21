Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199E23D0EA9
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 14:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhGULd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 07:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhGULdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 07:33:25 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE40C061574
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 05:14:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p36so2057819pfw.11
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 05:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OK43mmEvvEPIOUZAp5ApjKcXPSPjMaA4O0Laf3IVJO0=;
        b=NGTOhP3rl7vWWxTDJOSjOetn2UjYjbgRtrzj4EkE/7vg8zCIhDm4IfqdK8Is4V8JvS
         ey86oRyT2/YhUYocIpGEpYmqDW6vW2Uk1mS57ohHfEHEidG/2s1fnlJl0jUa4mBD5dxN
         FQ2zgCzXR858zyBB9xITyHAG2YRG7B84MDFZZrDN6pKcc87cFMyLnhTGr6kNk/McVzq3
         PrYz5v6FlTsD3PLezjmY5Kc9y9kKRgIkHWMgLhwC6TmYAGYbqzUyX73HHzPX5RHVJXb7
         BhP1z++BfCyzSvjneiFL/outyr/2A7MQa/ssnxngEJkCvrD2KE+rRNUrBpe6Zw1zGn2U
         A5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OK43mmEvvEPIOUZAp5ApjKcXPSPjMaA4O0Laf3IVJO0=;
        b=RWjgB16pvFmQNHHou3rftFgrabnd12ouycGf5oiqex8MlUkrgvbcdqlWQkNXNrI/EX
         sIbUGqHfvitLf8PXw/RiDxZFgFdRu88nc0UXERwiA1gtNptbCMsDXrHJd0XnxLLH9y6x
         ZlgKqYOpgM64YbLtslNj6JMMgiy1dMr/IXFPaWMSimpKgk1/k7tcOn6JNWkPMZNUiy2s
         Wfbg/WHBaxeUz+yOUrc6URHSsYb0jTmE1mGvAfXAMdDgvctFjE6VfDHzw98Sp//pgqcc
         M6vdfwA2GAVlK/V4MCJRNSgLRYT9hu6+0Oa7AvT2f4UXr7kBrFRD/cCzOCjOufpG10lw
         k0TA==
X-Gm-Message-State: AOAM532XN3zOYyoynSplhnNn78jt/anPTcyYlUol2mzSfqDNJyAvTqfT
        KJApoDpGghaoyZXOyVkvIvBYyOjsWpBJ1If5
X-Google-Smtp-Source: ABdhPJxg+NMie9KIm4C13XxGIaY4G7h9B2D+CP3s99gprnn3RRlLcraU0vihKCm3V2W+UgZTTtAJcg==
X-Received: by 2002:a63:b342:: with SMTP id x2mr35609304pgt.152.1626869641855;
        Wed, 21 Jul 2021 05:14:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e4sm31842499pgi.94.2021.07.21.05.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 05:14:01 -0700 (PDT)
Message-ID: <60f80f89.1c69fb81.143e7.cbf5@mx.google.com>
Date:   Wed, 21 Jul 2021 05:14:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.51-239-g1c3a4b93b5820
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 197 runs,
 7 regressions (v5.10.51-239-g1c3a4b93b5820)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 197 runs, 7 regressions (v5.10.51-239-g1c3a4=
b93b5820)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =

d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
nfig             | 1          =

imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-8    | multi_v7_def=
config           | 2          =

rk3288-veyron-jaq        | arm    | lab-collabora | gcc-8    | multi_v7_def=
config           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.51-239-g1c3a4b93b5820/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.51-239-g1c3a4b93b5820
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c3a4b93b58207c57a433b0da2af28649a83225a =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d4dd8843a8245a85c269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d4dd8843a8245a85c=
26a
        failing since 9 days (last pass: v5.10.48-6-gea5b7eca594d, first fa=
il: v5.10.49-580-g094fb99ca365) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d875c93ff0afc785c264

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d875c93ff0afc785c=
265
        failing since 9 days (last pass: v5.10.48-6-gea5b7eca594d, first fa=
il: v5.10.49-580-g094fb99ca365) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-8    | multi_v7_def=
config           | 2          =


  Details:     https://kernelci.org/test/plan/id/60f7db98cb5ded5e3085c27d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60f7db98cb5ded5=
e3085c284
        new failure (last pass: v5.10.51-239-g0625d8e48998)
        4 lines

    2021-07-21T08:32:05.137674  kern  :alert : 8<--- cut here ---
    2021-07-21T08:32:05.173657  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-07-21T08:32:05.174166  kern  :alert : pgd =3D 77cf30bc<8>[   11.83=
5497] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-07-21T08:32:05.174420     =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60f7db98cb5ded5=
e3085c285
        new failure (last pass: v5.10.51-239-g0625d8e48998)
        47 lines

    2021-07-21T08:32:05.175664  kern  :alert : [00000313] *pgd=3D00000000
    2021-07-21T08:32:05.224747  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-07-21T08:32:05.225014  kern  :emerg : Process kworker/0:2 (pid: 51=
, stack limit =3D 0x1c07c11a)
    2021-07-21T08:32:05.225493  kern  :emerg : Stack: (0xc23f9d58 to 0xc23f=
a000)
    2021-07-21T08:32:05.225732  kern  :emerg : 9d40:                       =
                                c3b5f1b0 c3b5f1b4
    2021-07-21T08:32:05.225955  kern  :emerg : 9d60: c3b5f000 c3b5f014 c144=
a908 c09c6a84 c23f8000 ef872c20 8010000f c3b5f000
    2021-07-21T08:32:05.226438  kern  :emerg : 9d80: 000002f3 408706ec c19c=
7874 c2001a80 c229dc00 ef83d380 c2001a80 c229dc00
    2021-07-21T08:32:05.267792  kern  :emerg : 9da0: ef83d380 408706ec c144=
a908 c3d61d80 c3aa5980 c3b5f000 c3b5f014 c144a908
    2021-07-21T08:32:05.268294  kern  :emerg : 9dc0: c19c7858 0000000c c19c=
7874 c09d41ac c1448630 00000000 c3b5f00c c3b5f000
    2021-07-21T08:32:05.268542  kern  :emerg : 9de0: fffffdfb c2298c10 c3b7=
a980 c09aa0cc c3b5f000 bf026000 fffffdfb bf022138 =

    ... (36 line(s) more)  =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
rk3288-veyron-jaq        | arm    | lab-collabora | gcc-8    | multi_v7_def=
config           | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7ff49a984dc997c85c27e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g1c3a4b93b5820/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7ff49a984dc997c85c292
        failing since 36 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-21T11:04:21.221371  /lava-4224605/1/../bin/lava-test-case
    2021-07-21T11:04:21.238871  <8>[   13.404381] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-21T11:04:21.239462  /lava-4224605/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7ff49a984dc997c85c2aa
        failing since 36 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-21T11:04:19.794525  /lava-4224605/1/../bin/lava-test-case
    2021-07-21T11:04:19.811551  <8>[   11.977382] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-21T11:04:19.812048  /lava-4224605/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7ff49a984dc997c85c2ab
        failing since 36 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-21T11:04:18.774645  /lava-4224605/1/../bin/lava-test-case
    2021-07-21T11:04:18.779928  <8>[   10.957598] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127D4407220
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 21:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhIJTvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 15:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJTvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 15:51:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4017DC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 12:50:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d5so2082174pjx.2
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 12:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KnpeqcqU9X8MGGJ+6v0BslEdmYhUXRK3wPVvrPNEz+E=;
        b=XJ44vt1t55MWh7CDoA21ZERrxtPg1ruQT4QB+7ZwnX8bJVIoZ9uCJr4E1prriDfLYl
         81bh8EQhemD3kIJoc0mcNxqubWb20KRjZHrHlSuTvah6FpdudD2MNPJ5p8L4J2xaHiUw
         CEXDmJyjJZtsNOzLy4/NiKi3mly7GWm69uz3gz8jIFNJWXZ+coXsssmjEQE7Fe6UQlMy
         C6TQfkRaOSYTL9/tfiae68xZPVz0hLSsmUqN5IiR1YBF3XcWW9tOrMtHS3O4627PnD/j
         bvjkkVpVp+VQqHq4oZWO3+iHJcEtDc+HWa8d6PaIENENh8FcOna6AZu1MQEZwZqGGvM0
         Pvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KnpeqcqU9X8MGGJ+6v0BslEdmYhUXRK3wPVvrPNEz+E=;
        b=wibHyd42/MYdU2E/Unk1DBsqzPA8Z10VVcrdcLQrcjYQWw53wXzNp+Ox5qwrca+pO1
         Iw+bFzJX+OHST7QUAIlpOIFrDMgPAxhIlJqzh6kKVv5F9O+E/iuSKICzJzotg/Jede+X
         hnwp7Lt6oClUcOXX6wtT1eJ0Vy6EJpwjEp6+DsbNGuajM/XkCeRBLw6QVxpCSqKmX6jS
         vhgUIC51PAMAynhrS5tgI+gRR76SBPkwq3C4mjw+CyZZcvi/wDWxWc6MUhnADcFLkHqn
         PD9UJEUPotR0gOTGJ8u1eSuIX5BaEmIAtYVtY+GNJNTn4HLP0KnBWqrSwmkQfBBxkBDa
         TbVA==
X-Gm-Message-State: AOAM532zf+nksQSzN3ogv/ghoYrisF/N7/zzcmz2c5Z/5Nj7L58Ztmxb
        eZ3s7YA5WUzdIh2nElnZvZJg69cdP2Bw7Rz8
X-Google-Smtp-Source: ABdhPJw8pMIOx1ATdZgzGrqrpodln3ugqFJ8cnWUUpu52mwibB//zTyBZN7cN2SCobXhhtUE3Fn07g==
X-Received: by 2002:a17:90a:7d03:: with SMTP id g3mr11180992pjl.242.1631303412565;
        Fri, 10 Sep 2021 12:50:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v8sm5607371pjh.24.2021.09.10.12.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 12:50:12 -0700 (PDT)
Message-ID: <613bb6f4.1c69fb81.bb039.0bec@mx.google.com>
Date:   Fri, 10 Sep 2021 12:50:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-28-g8026185ffccf
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 151 runs,
 4 regressions (v4.14.246-28-g8026185ffccf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 151 runs, 4 regressions (v4.14.246-28-g80261=
85ffccf)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-28-g8026185ffccf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-28-g8026185ffccf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8026185ffccf78e28a3340299dafeb7f73f15138 =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/613b833beb23cf992fd5968d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-28-g8026185ffccf/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-28-g8026185ffccf/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b833beb23cf992fd59=
68e
        new failure (last pass: v4.14.246-25-gcbd8eed5e1c3) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/613ba8ec5a2a31290ed59670

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-28-g8026185ffccf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-28-g8026185ffccf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613ba8ec5a2a31290ed59684
        failing since 87 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-10T18:50:04.852669  /lava-4492919/1/../bin/lava-test-case
    2021-09-10T18:50:04.870548  [   16.875425] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-10T18:50:04.870805  /lava-4492919/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613ba8ec5a2a31290ed5969d
        failing since 87 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-10T18:50:02.422698  /lava-4492919/1/../bin/lava-test-case
    2021-09-10T18:50:02.439904  [   14.444687] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-10T18:50:02.440349  /lava-4492919/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613ba8ec5a2a31290ed5969e
        failing since 87 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-10T18:50:01.403658  /lava-4492919/1/../bin/lava-test-case
    2021-09-10T18:50:01.409445  [   13.426002] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20

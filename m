Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5875425E6
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384262AbiFHBPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588742AbiFGXzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:55:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE8B1A45E4
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 16:35:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e24so17062400pjt.0
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 16:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z7aZb9DZxEWD6rTQ+lEoYWXYNT985GDWwZaqPHEe2vc=;
        b=WqmtxwvC8gvRIqIFhvUH0bvn8QgPLgdYvPKgRQLx4PwOzMfxeVSqOyiy4zesl7Lj9M
         ZyAUHA2nUf5vFfSev2obhFQxZVeeJchCy0pmz1Uq4bfw/xesXVdEqaPTxgXOKInJ93m+
         0TcXSkroU5958kWexWXx+mquNHm+dcjZZWAe6FeZezQ6QhGV2sR2VJl82T2eRi9yxWqf
         r7nK35gn06dzI8dJyqiFrnSrNol6/G9gf/fhEX3ADh/SG/BAOHh5n5w5RWqSZhuBqh3q
         8MqyibREjAWNSgSnuJE+gfAQFneOC2ns/YEOjPBjzhFFEAUFdo3szCwiCrUkLWfxdwjt
         esCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z7aZb9DZxEWD6rTQ+lEoYWXYNT985GDWwZaqPHEe2vc=;
        b=X7oEN6kHMTq2xqMvCJHgVTUdnxXolWQMubB0BN23Bks2cFj9oCIqHGdiJ4vBSxjzvt
         fp7W9NahOrr9UP3tj5rwzCEfwTk9VTZz/Chak++vkwLCQG/EoLUpGbKVXraFWthOEM+O
         DFBFN22BEjVdYnOw11j5fzu+lcP7vUY5bD/tINOMxBffQFkcSdYQ14DfoXb9HvRw7PO2
         S3zZRn93mpbEw9p7LC3J2tD4XIu5/Oo6aCV2vohhW2z4a1uOTsdA97OsljAVsh+Sv4N7
         Bn4vUje+qLCIfxrbmboMtrMzLMbHsRWYewQg3tBRUW6kKoacHmYoLkYTLPA43VGmAJZf
         thAQ==
X-Gm-Message-State: AOAM532Os5g/v4PFCxupWLj3Z6ukTP/PWVfAC1avrdDb/NnjgXurgBVw
        BcC2u3zMb5YiWLYJKjVSxEPmBS5cfOnN93h8YWI=
X-Google-Smtp-Source: ABdhPJxdZZIq/T0bHGQpdWonRE9By6DyrF8ReZamhiJq+PLzAbv/YG4w26uWmR1iPcUpjxGO69iG6Q==
X-Received: by 2002:a17:903:11cd:b0:167:90e6:5d83 with SMTP id q13-20020a17090311cd00b0016790e65d83mr6492779plh.136.1654644941615;
        Tue, 07 Jun 2022 16:35:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090a0e0900b001e2ebcce5d5sm12534675pje.37.2022.06.07.16.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:35:39 -0700 (PDT)
Message-ID: <629fe0cb.1c69fb81.acd04.b4f7@mx.google.com>
Date:   Tue, 07 Jun 2022 16:35:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.246-189-g2cd7aa360353e
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 112 runs,
 10 regressions (v4.19.246-189-g2cd7aa360353e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 112 runs, 10 regressions (v4.19.246-189-g2cd=
7aa360353e)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.246-189-g2cd7aa360353e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.246-189-g2cd7aa360353e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2cd7aa360353e497dfbae89426e6e27a75c13790 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629fa8a7d58a3f1c54a39bdb

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.thermal-device-probed: https://kernelci.org/test/case/i=
d/629fa8a7d58a3f1c54a39be0
        failing since 0 day (last pass: v4.19.245-30-g0625a97aa45db, first =
fail: v4.19.246-188-g0ca7a8ff35400)

    2022-06-07T19:36:02.861292  /lava-6566147/1/../bin/lava-test-case   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629fab5b1f1939ff0ea39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629fab5b1f1939ff0ea39=
bd7
        failing since 49 days (last pass: v4.19.238-22-gb215381f8cf05, firs=
t fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629faa9312c940e163a39bfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629faa9312c940e163a39=
bfd
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629faaf08fb3cd5adca39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629faaf08fb3cd5adca39=
bce
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629faacf5dc8d102fea39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629faacf5dc8d102fea39=
be8
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629fab191c45c1e403a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629fab191c45c1e403a39=
bdc
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629faabb9e1b10fb5ea39c3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629faabb9e1b10fb5ea39=
c3f
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629fab181c45c1e403a39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629fab181c45c1e403a39=
bd6
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629faad059186400e2a39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629faad059186400e2a39=
bd6
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/629fab40ea5ab0bd0aa39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-189-g2cd7aa360353e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629fab40ea5ab0bd0aa39=
be0
        failing since 28 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBECA4BCB9A
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 02:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243295AbiBTBvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Feb 2022 20:51:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242422AbiBTBvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Feb 2022 20:51:45 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089CA55BD7
        for <stable@vger.kernel.org>; Sat, 19 Feb 2022 17:51:24 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m1-20020a17090a668100b001bc023c6f34so1808481pjj.3
        for <stable@vger.kernel.org>; Sat, 19 Feb 2022 17:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9i+EyZGhZnlSo/KPDgBvTvLl71kHTGvcG0zwrppqmJ8=;
        b=cKkucrPt1DjcxWDf+Ic9V9yQZWQ7Yff4sU/bY6EDXXhH3k+/hSSk1O5bwjGIlapuej
         Bb3e8yO5mVdIqPYAWsamgZx34ugCHzWlN9PyE3M2gM2qpJ0JG/0BcIEs7BX5Cxyy1DsW
         GuEINixfKlPKAUspXromsQZ+WMcDp9e1mzZiAEbuUBcG57a7xkjnSgjS/hyr193/xsQp
         An5cjYiM4dPvZmwLcY1r+7cncPgVVACqL/XnSAfumzBVHmNz+9AKKqB6QdSVSKesScSI
         UGc09JseKhRJmYmZQfIOM+szGe7omrmaONvIYnp/y4oCSKLCuarOdxHV56KzRM8SzrqT
         Ibew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9i+EyZGhZnlSo/KPDgBvTvLl71kHTGvcG0zwrppqmJ8=;
        b=W4mu7hzAPTB6Nx7uMAswNDrvHkadDjg1d8QOSdpttJpdA7bacHWJ4ZHT3UkRZKNGA0
         W0zNXx6EWT8tEKRmqyAR5VtZNRy/ZsgFwx+Ja333ZJIkSpVjBYQsdLEWFANPuaxgLJSE
         sTWcv6JlPUA1wUXcJeWBFF5VjWuxSvqQCQ3/NdVf8Ettol700LfQgCaw7VD3XDF5nC4g
         VmU0am+OiK9TM5HC3KfvAzadqm2AZC9+5yxna6aghu6UGlNZsvNy/Lf4zwBktgA2u7gf
         IS8tQOJ/mRmUz/ehcXIWKpN1Etkz47Uxd1HdoEONV/IGxJ5isvnivraaWCM0u76pqok0
         fqJQ==
X-Gm-Message-State: AOAM531Yg/6PBdTxn6l5alIqTJtq5ME6ZGHq+OZDLd/h2bVaEeCXKBoD
        p0HmoH+556qP/7Qde3ytWyyBI0OH/rMEtmvZ
X-Google-Smtp-Source: ABdhPJxIlNAFeLwC65SS6Xv0ey62q2dO3/tX81kUExdgHz9N1FZj1L1juGAPLveyg1j4sKsnlMz6aQ==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id s11-20020a17090302cb00b0014f4fb62fb0mr13617963plk.172.1645321884240;
        Sat, 19 Feb 2022 17:51:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12sm7473535pfi.49.2022.02.19.17.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 17:51:23 -0800 (PST)
Message-ID: <62119e9b.1c69fb81.f5c6a.5357@mx.google.com>
Date:   Sat, 19 Feb 2022 17:51:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.302-21-g9074ca16ed49
Subject: stable-rc/queue/4.9 baseline: 83 runs,
 9 regressions (v4.9.302-21-g9074ca16ed49)
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

stable-rc/queue/4.9 baseline: 83 runs, 9 regressions (v4.9.302-21-g9074ca16=
ed49)

Regressions Summary
-------------------

platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
d2500cc                    | x86_64 | lab-clabbe   | gcc-10   | x86_64_defc=
onfig           | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.302-21-g9074ca16ed49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.302-21-g9074ca16ed49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9074ca16ed49c638b0083ec8a4c4bf1f8c650c88 =



Test Regressions
---------------- =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
d2500cc                    | x86_64 | lab-clabbe   | gcc-10   | x86_64_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62116213e0c7283c85c62970

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62116213e0c7283=
c85c62975
        new failure (last pass: v4.9.302-21-gf570492b1630)
        1 lines

    2022-02-19T21:32:52.648215  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-02-19T21:32:52.660688  [   11.921550] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2022-02-19T21:32:52.661706  + set +x   =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621165347600855306c6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621165347600855306c62=
970
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621165347eb1628651c62988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621165347eb1628651c62=
989
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62116598256ab1f38ec6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62116598256ab1f38ec62=
96b
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6211656fe7a5bb1182c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6211656fe7a5bb1182c62=
96c
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621165337600855306c62969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621165337600855306c62=
96a
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621165327eb1628651c62982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621165327eb1628651c62=
983
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621165367600855306c62977

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621165367600855306c62=
978
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621165357eb1628651c6298e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-2=
1-g9074ca16ed49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621165357eb1628651c62=
98f
        failing since 10 days (last pass: v4.9.299-48-gc8f4542c907b, first =
fail: v4.9.299-51-g1910142c7cca) =

 =20

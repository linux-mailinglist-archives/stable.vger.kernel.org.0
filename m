Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4D58575C
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 01:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbiG2Xd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 19:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiG2XdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 19:33:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FE131DCC
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 16:33:24 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso9745762pjr.2
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 16:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0s799Xb2epHT6X2ebXV+jvqmGum7ax6GJ0H0vYAvlSw=;
        b=2u4/HNG+94rU3Ifh7iYD83kNbIXQCrHQrdEsvRdT9COXgJjT7hJ5a4BLRwfUTchKm3
         ozN3mk/R/gTPMLKyOoR0ZaaipAxlGEsgkfZRIbeSPxUdEOXV3zbzVZarWiCkd+9Au2yR
         1f/u10cd/4jWTtUlg8+PX4Ov/HLFWHdUFA4EPI5f86o+OxAAfe8/FuEtrE6q1wHYVcmg
         dJl2NrZT7VgAaGcKba4oJ83ORH2mcYJSdEOusjOYqa2PWoGjut8G372woajkZDsUYctx
         qI0KAOFkHeeJJvauVgz1aVfnlggOBYR4kV3nQ+RU0ZEjOUWFPbAfX3H1/Ruyy7u0kggC
         +QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0s799Xb2epHT6X2ebXV+jvqmGum7ax6GJ0H0vYAvlSw=;
        b=LDoyQz9KImkndNfQ6sGxcK1G1WChzP9bZnPMnyO3ZpJjOoQnDe/45CwY1JXDQfu1ZU
         nu9AwIP2b1QyJJOvOVl5e9aInKa/NaTTjT5ZugwThu4G8ZOk6iS1xy825VIVw64A1e7G
         JZFoLE/do/gjwhBlQY9o5dAM+NT5hQvy95jI0eLT09h4Vpv13N9eK+qoia0aNlJgVJM/
         7rEZPWp0eM7JASFsNF9yd6MJACQGHaW0JpRyhDFQEEysJ9PoD0e9SN6QMqYjMO7g345H
         x14OTqPnLi/dVFqDuTrUK4Az9PHuoPU7hRRxD9BZ67QhL5oeZnygvgmkitmchLGOgVjK
         ChWA==
X-Gm-Message-State: ACgBeo3MEhomUQ9weK/NOaee6YbRYsmoXWJr6oQIlZtI5+Tok4bzL9sJ
        QeAuNLDdwjk/Tt6x+GO92M6TTOS0T/Tzrs/sf7s=
X-Google-Smtp-Source: AA6agR4nV3xmiru1B2BUgpn1aUNR/Aeu0jLWl/G/mSy0kgYEoOz2eO1XV0Gc92D/TFO+F5vOE0ScuA==
X-Received: by 2002:a17:902:e84f:b0:16d:cfed:fde0 with SMTP id t15-20020a170902e84f00b0016dcfedfde0mr6238926plg.119.1659137603531;
        Fri, 29 Jul 2022 16:33:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l17-20020a170903245100b0016dbe483f0dsm4201087pls.171.2022.07.29.16.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 16:33:23 -0700 (PDT)
Message-ID: <62e46e43.170a0220.2fd60.6a0b@mx.google.com>
Date:   Fri, 29 Jul 2022 16:33:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.133-101-gccebca1b5687
Subject: stable-rc/queue/5.10 baseline: 47 runs,
 6 regressions (v5.10.133-101-gccebca1b5687)
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

stable-rc/queue/5.10 baseline: 47 runs, 6 regressions (v5.10.133-101-gccebc=
a1b5687)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.133-101-gccebca1b5687/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.133-101-gccebca1b5687
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ccebca1b5687b26a215888e8fc7bb8be1b709baa =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e435759373fe6527daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e435759373fe6527daf=
05f
        failing since 3 days (last pass: v5.10.101-121-g37c714b8817b, first=
 fail: v5.10.133-85-gebd96107f6d2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e4356a0886d06364daf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e4356a0886d06364daf=
06d
        failing since 3 days (last pass: v5.10.101-121-g37c714b8817b, first=
 fail: v5.10.133-85-gebd96107f6d2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e43589a9f14f7e3fdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e43589a9f14f7e3fdaf=
057
        failing since 80 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e435739373fe6527daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e435739373fe6527daf=
059
        failing since 80 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e435749373fe6527daf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e435749373fe6527daf=
05c
        failing since 80 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e43592a9f14f7e3fdaf063

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-101-gccebca1b5687/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62e43592a9f14f7e3fdaf085
        failing since 143 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-07-29T19:31:11.168901  /lava-6917222/1/../bin/lava-test-case   =

 =20

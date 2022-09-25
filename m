Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404F85E95FD
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 22:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiIYUog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 16:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiIYUof (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 16:44:35 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E042EBAF
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 13:44:30 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id u69so4905971pgd.2
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 13:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=iD8ad7zcdIqnuTQB0pO80LXlUlz0um+tNnjH4V0hzuI=;
        b=nIo7nVI1fDd1P6XRu9+c5cu6B3WWJt1JVoklVFfqsQOO3hu2qA/z+iyfgYKLS9Mhkw
         vUghiPY0BQuwUCYnsfQfYcscfFeSzeeymtoa8GTO4xlG5VPJSK2t6ucffF44oSEHPVcz
         023qJZ/HUDKf3Cv7dAcZsFUxS/LDmu5G/jI1S6ddufp+w1b3iCBNDwlBo3xQSwcNfZeB
         9MZN042mDABQtBlyfmS+e8ROPAaQ4vUVdY5MLNov8BfTOGTL+hFPbVQp63SFcE8AeVby
         ShmwDFRdfT55jYCRF1YbeKNHvgghRpiL4J/+733HkDNtszbPnlSotObO/8EsTLOyrmCK
         EL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=iD8ad7zcdIqnuTQB0pO80LXlUlz0um+tNnjH4V0hzuI=;
        b=sSojYH1PtXlciywuZQWoRFTEGZLDkfot+IWD1pXEoUB+WMznU4cc1Hq8D9DWZaJukh
         UomFBYgLEnYFFsy4CEydE4OrT3cPQkvsRB5Tgy04/6kSFAEXEHmH60PAY4f4NJWyJhe/
         375jtaWjJwvCHUcqydxQbqWRsFJ0KFmcCWntX19VQmM+Td2o+5ZwmgeM5ycSLxCdpdf/
         2kQl0XbnhbvdAkraNB657ayHykpX/gDlXp5POBXUB/t7DcJ3yyXNDX+8M7rW+5ZGfqAv
         rc6wV18FrL0fphDUM0gFKTa8jy+XteYVr/ipByj1y/8UynfsfqiRRWglR9POLBUuijoM
         VAsA==
X-Gm-Message-State: ACrzQf3o02/Cy+COEjaaBD/Vh3zhFTSEBr0Ges27bCsJw8gUwD8lUr/l
        lbFrey3/7bcBUth+92kAhmX95Qx21wKWudsg
X-Google-Smtp-Source: AMsMyM7yO0K/KRXMTbzX4WzPq7SB949jqBQGTlO0rmqf/MayWYeDVWG/iOKoxHdW9i0sdOMAkSXPqA==
X-Received: by 2002:a05:6a00:1583:b0:543:448b:dbca with SMTP id u3-20020a056a00158300b00543448bdbcamr19958017pfk.38.1664138670149;
        Sun, 25 Sep 2022 13:44:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902c38a00b001750b31faabsm9554244plg.262.2022.09.25.13.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 13:44:29 -0700 (PDT)
Message-ID: <6330bdad.170a0220.bb57a.1f23@mx.google.com>
Date:   Sun, 25 Sep 2022 13:44:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.145-132-g19b6380f0603
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 11 regressions (v5.10.145-132-g19b6380f0603)
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

stable-rc/queue/5.10 baseline: 164 runs, 11 regressions (v5.10.145-132-g19b=
6380f0603)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | multi_v5_de=
fconfig  | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.145-132-g19b6380f0603/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.145-132-g19b6380f0603
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19b6380f0603b55e1d4a60a3dbf77645c481a87b =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | multi_v5_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63308aa5d91fef385f355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308aa5d91fef385f355=
655
        new failure (last pass: v5.10.145-122-g92166f67aa8a) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63308dccfdd41c60cc355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308dccfdd41c60cc355=
652
        failing since 33 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63308c1549a4db7a18355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308c1549a4db7a18355=
649
        failing since 33 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308dcca43dbdbc40355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308dcca43dbdbc40355=
655
        failing since 61 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308dabc56c5e31f0355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308dabc56c5e31f0355=
643
        failing since 61 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308de0a43dbdbc4035565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308de0a43dbdbc40355=
660
        failing since 138 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308de7a43dbdbc40355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308de7a43dbdbc40355=
666
        failing since 138 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308de2a43dbdbc40355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308de2a43dbdbc40355=
663
        failing since 138 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308f00218ab7cbdc355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308f00218ab7cbdc355=
664
        failing since 138 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308dcdc56c5e31f0355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308dcdc56c5e31f0355=
652
        failing since 61 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63308dc13081532fb535564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-132-g19b6380f0603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308dc13081532fb5355=
64f
        failing since 61 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =20

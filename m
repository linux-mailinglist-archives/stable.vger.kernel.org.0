Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCC9585E40
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 11:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGaJDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 05:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGaJDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 05:03:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD31AF59D
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 02:03:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so9053451pjf.5
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 02:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LyPUDPN7P7C6x0Rwwv7zFg9MFfujD/D3n+XcURd8csE=;
        b=0CxSPzFwl4YKCLQliqK1Q6kH/wRHSo1bU2WciPJ1LZZwc2eKK+TQ8yk75HxJiB9nWy
         JmutCduc05nVA4TYfPG8dyWdIWm+sI9h0xx5IPha0mMuNzHerTDiwvOkBjR0TI1gOtzW
         liNq1g5quWNA1ro0h6twJDJV4nj+K3sPPQeUz55g4XVw9IBRSr++YQ8Lyh32rhhWwolF
         C28llixXwN+dcUo8iBNxKtfsyYtR5BBteewwXtA1/EaRrAdO+uo6eNHcFeASesNyaj0A
         ghrZMibSsNgE55+8gkNER2I196eI5JhpUk+/v3Jor+1epdhKhX7+zgsFW7PQSTMQST0x
         C3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LyPUDPN7P7C6x0Rwwv7zFg9MFfujD/D3n+XcURd8csE=;
        b=0iS1Eof9JDfjCz45tgQSR42dX8jlGqsDS48x8z2wg/V4c0fvD+dpfUmhh9/hxLWko5
         FjSRkMm1G0GB443dYoKjYspRrYVbfoccSLcDEr0pZTj13qlpBFdgHEI6xsmNK9PYvKqT
         AYPcruHXMA5agSXoXdzW4wYIEQyvmr/g4IfK1it4yz4CBBlQbwDpJZSh02IwaJYFTIxt
         /gtK4mNaPxi6nicNTfXrWrJfRhhwZ0Z0h1sNq3El2TMk9P6M5S5pGSoQ+76MrriFQJ1F
         Tye/KAu+1dsO4+6lqSoBTan6eeH7jmQUNxKG1Np8OX3HYtRLc0EmH5c3zKxL2IT2FnrW
         2pvg==
X-Gm-Message-State: ACgBeo3N2XGe2Raam8rGFf4FEtyo2mM2CZpJdp6d/qkd4Tfx2Yol4iVo
        FgLmQfjCD+J6cNSd1DQ9v23qIQE01UynSimI
X-Google-Smtp-Source: AA6agR7e1Q5pKg54iZE4PxFECPLip8b55EpUSfPi70st77ARdTrndtHkJF8VkVv0us2HZBpP/uNbTw==
X-Received: by 2002:a17:90b:1a81:b0:1f4:f9ff:9028 with SMTP id ng1-20020a17090b1a8100b001f4f9ff9028mr636402pjb.44.1659258208070;
        Sun, 31 Jul 2022 02:03:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z10-20020aa7990a000000b0052d57ced9ccsm556005pff.98.2022.07.31.02.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 02:03:27 -0700 (PDT)
Message-ID: <62e6455f.a70a0220.19900.0b54@mx.google.com>
Date:   Sun, 31 Jul 2022 02:03:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.289-45-gb7367c72bbc5c
Subject: stable-rc/queue/4.14 baseline: 71 runs,
 5 regressions (v4.14.289-45-gb7367c72bbc5c)
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

stable-rc/queue/4.14 baseline: 71 runs, 5 regressions (v4.14.289-45-gb7367c=
72bbc5c)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.289-45-gb7367c72bbc5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.289-45-gb7367c72bbc5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7367c72bbc5c7ee2ef8c882c2cf51d2eb47c126 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e60ee98296755f5bdaf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e60ee98296755f5bdaf=
064
        failing since 103 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e60ef18296755f5bdaf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e60ef18296755f5bdaf=
06a
        failing since 81 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e60ede683ad77c7cdaf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e60ede683ad77c7cdaf=
066
        failing since 81 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e60f05f792d7f606daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e60f05f792d7f606daf=
05d
        failing since 81 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e60f2df792d7f606daf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-45-gb7367c72bbc5c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e60f2df792d7f606daf=
081
        failing since 81 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20

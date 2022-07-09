Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769C756C5F0
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 04:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiGICPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 22:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGICPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 22:15:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515816C113
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 19:15:39 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 23so380776pgc.8
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 19:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r6drTGlnQHxFXIF6YcTc33p6M3VJyM3Aabpt3Ipd0Co=;
        b=rj+vmIcStlTC/TxfeYkKqDYtHpgC4uLfe4xqslXgvOoXk+Xzgct5q1jfNE5gzvqIAX
         INpkKNzQQCQIYWuW6QyQojve7Jnu+lEcDwetWq2iyNwrOwtvY1ssGE/jSqN9Hghqw76F
         gIhNT9B7MVPmiQNyr/ieWKVnvQ/U/ZYk7OjVLvGPLmstGi/e8qJP7Og9l3eL+RwLc5tN
         dr6E9nxwCvivehe6d2Gg9X5x/wtOkT9SQ6w4K+TcJVgRcEsukVKqsv3xt/QN0fx3i4oE
         ZQ06JbFNQ30LWhGmtSx8v9D4t8yN4sMXmLaxEsenX28LE37DFShTJbv/bfopH1vsYh3w
         GnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r6drTGlnQHxFXIF6YcTc33p6M3VJyM3Aabpt3Ipd0Co=;
        b=sVjAB1uwA9WVArx1nAuR3NsY9VY8MwcjqGlw9LNJC0eCdhZIOnb3XRCrubg4fk8Xj+
         gCSXV6zk9h9VwPDPvLjJ8EVva/rviSafapb/Pt3qBz/z54/g3zGwDbfG9RtOCJWQ1X87
         A2wNDiv1ykWu4O4uE6PTyjyBsSWWDPIsLxasN+2Pq2m03q15IDxtqIX1ocDkI7hyJnij
         rVPbXQ1nTWKsMQEmnXBXEvHnd0ibi68dIPN9hOViNwaY2u5rP2cCPv8WJVJsVtiz9D5J
         Iu3s+VtHVRM9W877XvzP9gO+ZuEQ2eEC1sdB5IsMgS2w+xCh6U1wR4Y1TwDIsDCY/Q4U
         IihQ==
X-Gm-Message-State: AJIora/+R4lknSGid2BZI6HCxv1KrNCh3MRDWFkvGT3a9l6Qrp3QFoJF
        77E4BhnGJXkhv/H/ABWPAk0h0noxvEEwL9KP
X-Google-Smtp-Source: AGRyM1tGRAjrZp9NtWVe7wR26S9WoCVbMbRaK6UMalbR/45VTDGCSB0ybkKraO4C1ApXkCwM7OKmSQ==
X-Received: by 2002:a05:6a00:1941:b0:50d:807d:530b with SMTP id s1-20020a056a00194100b0050d807d530bmr6567303pfk.17.1657332938543;
        Fri, 08 Jul 2022 19:15:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h15-20020a170902680f00b0016bee668a62sm203242plk.108.2022.07.08.19.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 19:15:33 -0700 (PDT)
Message-ID: <62c8e4c5.1c69fb81.e3e9c.06e6@mx.google.com>
Date:   Fri, 08 Jul 2022 19:15:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.129
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 157 runs, 9 regressions (v5.10.129)
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

stable-rc/linux-5.10.y baseline: 157 runs, 9 regressions (v5.10.129)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.129/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.129
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7208d1236f72085a3290c41463ee3ee246d8afa5 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8ad6cf44f10be93a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8ad6cf44f10be93a39=
bcf
        failing since 32 days (last pass: v5.10.118-218-g22be67db7d53, firs=
t fail: v5.10.120) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8ae62e65a5eab41a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8ae62e65a5eab41a39=
bf0
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8b051551b222766a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8b051551b222766a39=
be9
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8ae4ade1309b818a39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8ae4ade1309b818a39=
c06
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8b00019cb5446eea39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8b00019cb5446eea39=
be8
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8ae605df626779ea39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8ae605df626779ea39=
be6
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8b03c7874c5da15a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8b03c7874c5da15a39=
bf7
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8ae72d706df1f94a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8ae72d706df1f94a39=
bf0
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8b050530baf57bda39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
29/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8b050530baf57bda39=
bdc
        failing since 60 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =20

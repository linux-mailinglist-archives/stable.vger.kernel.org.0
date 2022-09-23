Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EAE5E8450
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 22:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiIWUsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 16:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIWUst (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 16:48:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ACAD9A
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 13:48:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t190so1283721pgd.9
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 13:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=+y7rdcC3gpKlmfHosP8R0xVK902nvW6DHFaQ+v8DqU4=;
        b=fTdU5764nC8x29WKDiFWzE1BZbeNHS2vzccDtXF0Cn7WbEaeM1URTlV/ZTSKfUWI9M
         CvhJXzLG2DPeWrOfx14RQ7MBn5gAPWItf6YNK3bpvvQJlBqkzHKyEFrrVlWLShw/afdW
         mtOTcq+QewVxHWiGYCifp/egw9jvI/QSzixcBfguTYQIXyGZxMnilThsqp8BUkG72bMY
         geVrdqEb4j8ZU0BcqQOihj8x/7oSZhSoDFUb5AFU9QUe+1zau31xsIfeSMl5WLblbnUx
         vqDZnbv7EVGdEOU6WeCKvkAqtDwIgtQEikCYbZq+FnyA7OmAcpIBH4WIbdWoLFjFnmAS
         +NIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=+y7rdcC3gpKlmfHosP8R0xVK902nvW6DHFaQ+v8DqU4=;
        b=nUPsPQAREX8439vt9jb4iDQlKXsuZKrDIpizzQg2GmouVD7/ZVbdb58cJtSIen6RlL
         /+2Afmfs/+boQVxdUaaB4G8i3z6frumxp138j8jfFn/wBGZnZwq/vnl54RI6kswZXLyK
         PvkX1OaDSvtcRng8KOoJO8+0orFZ818DHigsDNQKCOYfPAUx2ufVDgqlb1mgnbU9ljaM
         NLtJnoEzlCesKW66aXKIqg6295DrV7da/bMifNExYEEo9RQRExsPtHfdZsmGAdisR3WV
         CUao9VtZ3B9CihZowmL5+Md68E/Vvn+wgTMTrgmuk/tnzA4dArxxk2fvIwxPM18EwzCy
         RwKg==
X-Gm-Message-State: ACrzQf2HLKoV0zu7jrWb/u6F6E53FXzVHoF54OpDMqJAys9YTrdf59oN
        qsWxwjC9mJvd0TzqmwQYNwU81Qy+ZW70pWyRe2U=
X-Google-Smtp-Source: AMsMyM7e4as4XCr51yF49Jb5UtRVvYYgdeCHVqAKJ2evFAkabc6dxCxunuYniu9+K0inYrNe4X5+1Q==
X-Received: by 2002:a63:24d:0:b0:439:3804:d0ff with SMTP id 74-20020a63024d000000b004393804d0ffmr9283398pgc.414.1663966127955;
        Fri, 23 Sep 2022 13:48:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b001785dddc703sm6377971plb.120.2022.09.23.13.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:48:47 -0700 (PDT)
Message-ID: <632e1baf.170a0220.42e16.d82c@mx.google.com>
Date:   Fri, 23 Sep 2022 13:48:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.145
Subject: stable-rc/linux-5.10.y baseline: 182 runs, 6 regressions (v5.10.145)
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

stable-rc/linux-5.10.y baseline: 182 runs, 6 regressions (v5.10.145)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
panda                      | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config  | 1          =

panda                      | arm   | lab-baylibre | gcc-10   | omap2plus_de=
fconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.145/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.145
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a77e6ef2057d9d4e2e1df3f7739622477e8738d =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
panda                      | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config  | 1          =


  Details:     https://kernelci.org/test/plan/id/632deb8795e1cfc5ca355669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632deb8795e1cfc5ca355=
66a
        failing since 25 days (last pass: v5.10.136, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
panda                      | arm   | lab-baylibre | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/632dea0befbbead501355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dea0befbbead501355=
656
        failing since 25 days (last pass: v5.10.137, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/632dea3a1012a624d5355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dea3a1012a624d5355=
65a
        failing since 137 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/632dea4e9ec034678e355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dea4e9ec034678e355=
658
        failing since 137 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/632dea4f9ec034678e35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dea4f9ec034678e355=
65b
        failing since 137 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/632dea622a81cf0d8a355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dea622a81cf0d8a355=
651
        failing since 137 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =20

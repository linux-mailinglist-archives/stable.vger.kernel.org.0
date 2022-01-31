Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CB44A52AB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 23:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiAaWyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 17:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiAaWyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 17:54:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC09BC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:54:53 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso680605pjv.1
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7ZAncO3ikgAIQoRCtL+Px8hSCRFFadABXX7tJaXMId4=;
        b=csHC9biZ1dI7BdRPsSYkRVs59WrOfJ3SbvkOnFb66YLm/t8Ow+XbEVmfRGcC+J1+Rc
         YEBY6Gx1wbjvohy/jotFDizy4435+PsjXdZ97JHh+IgDcTlvafKgwaojLBTJkpmq/JXE
         5gwPfivIJYd6vi5m/J+khxa45GWS5ug6gfEtyHuiRM8651m9M9iRUIElNg27YX5HukDN
         T8MjMXSWgdIe+4/qUhMvY3QbLgiPEtfkSZWW18on23/CBGnjuu6ZmZQTIoIuz89+dWua
         EVgIl+CL9CZKNe5DMvFpMaA0642oNx4vHWMn9+TrdPhn1O8uTaoDAq2kEdryyFT4zNoF
         gisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7ZAncO3ikgAIQoRCtL+Px8hSCRFFadABXX7tJaXMId4=;
        b=H59W5C/dGblfwxYkNICLmrEx1HWklE8BBwCApINMAN74mC3tMxzqHKMkPlb8ey9ZPJ
         YwnPaAxg/IFUIkVMr8jgawvWt8DHWQyWoyokxxcHvLZFAyIKohn5vX81idC2K42KUUk5
         yMDnUQyqLRJsrPNBnn6bZDunHgEmFrRDyBAmrNkwA0qJuxUx6IGgx0tLxCzvPNsktw4O
         2ColhK/vpycslmeQRhgggRF/7h6FnoFVXWbOutSVQCfowD2uCxlWCzBqCb/xerKN9b8e
         0ynXRLFawlLnNSCtaMiO91QIuYz6HUBAYMMzYE7rFVNbzUyLjx0D8PEhYcUcd87HIGtO
         RXpw==
X-Gm-Message-State: AOAM5316zDr+Ims7ZXlUOqOBiQze8bdtA9S7AkpiDtl4T2GaNJkXr7/C
        sV/ZNNvdUHfIhaUSP+AOyXMpFGH0YXhPk4GO
X-Google-Smtp-Source: ABdhPJwQYqgFn/fJ9BlfMlFz2yeF9UFjuffuAAytPxsvUP1bx8LpA39rR4xqXKw9c653s+qSw+nXGw==
X-Received: by 2002:a17:902:e746:: with SMTP id p6mr22328758plf.78.1643669693153;
        Mon, 31 Jan 2022 14:54:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm324899pjg.44.2022.01.31.14.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 14:54:52 -0800 (PST)
Message-ID: <61f868bc.1c69fb81.5625c.16c5@mx.google.com>
Date:   Mon, 31 Jan 2022 14:54:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.175-65-g67819ded87b7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 141 runs,
 4 regressions (v5.4.175-65-g67819ded87b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 141 runs, 4 regressions (v5.4.175-65-g67819=
ded87b7)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.175-65-g67819ded87b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.175-65-g67819ded87b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67819ded87b7d993487007bb528aa90c522a5671 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f831634ef7ec9e615d6f00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f831634ef7ec9e615d6=
f01
        failing since 46 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f831820effbfdf0d5d6f0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f831820effbfdf0d5d6=
f0e
        failing since 46 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f831647536ed1b005d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f831647536ed1b005d6=
ee9
        failing since 46 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f831970effbfdf0d5d6f2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.175=
-65-g67819ded87b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f831970effbfdf0d5d6=
f2b
        failing since 46 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20

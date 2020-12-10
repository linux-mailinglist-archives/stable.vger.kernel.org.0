Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C6B2D6789
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404488AbgLJTwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404434AbgLJTwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 14:52:00 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA7EC0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 11:51:20 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id j1so3329619pld.3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 11:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fjS6mlylV9PIWty+RJiVwUVMY6TM8hRvb+drSZQcAow=;
        b=xsAMKGryMVJWtJdhRigpiNnR+lxXhGjQy5frvv+YjT6eQdzEV0sXVRArwmHani0uBg
         n/jO+/nn5M7K46fXy/dNU1uDKp7NPx0Rrgzl1vBF5LBRuHYwobPQlBIqSbr16oQVUli3
         pkgirckDFTpU7KuNFPHpFw8o28poBa3aNnLzIw6upDKUa4jSEARRq3QP32u+4mBu6SAM
         ukKjtjd1AqXY983D4V/azm5ZtqHcOxsmmqZpCS3IYwHt9m7zfcxhGGNLrMh1EVgL2/wp
         DBYDd61R02WslaOHxI8FcWhkgrUKo6nkhf1Lowd+yDyUUIZi9BFnL+GksCqBzB8aiFhz
         x/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fjS6mlylV9PIWty+RJiVwUVMY6TM8hRvb+drSZQcAow=;
        b=AYeflWM/XtI9Rv/g+oL1ZnBD/U3BZ1za2Z4dK1+9y/baB95rINnfaqXhjP9uuVGCaJ
         Fi92RjM1w+2qgo5AFAqs72ye87Ba+OpBpbX2LSuBCUXS50AIOHzOuRUZOKbN9NLp/bJE
         zN6CSYSCLTX9igzMxVA596ZrsmYRvnyX7o938j7JqFOJKQL/IGefChALnwGqvvkkheYU
         5x2FIbRjJl7fkw4hgYraxYCLp8Z23p9W4gkCpD+0LCw53yKJ16QsiRvjcv6JF4w01RO7
         UZ0y3zibzGfnEnKMuP8LA/svMXmMelU/0SXdETz4mHaMvZMGNwq8iGTLCtU2+GutoIf3
         /VfA==
X-Gm-Message-State: AOAM533YIbN7ouUhPNQJhakV6ozyBfTqBEPp5ey1YDkYl7QbwBK+/wrx
        e5Y6oCTI9lniwp+3RrE39DtHPH+9gX7KvQ==
X-Google-Smtp-Source: ABdhPJz1xIpEapB6W4Cblf+FSQVFRr/6Zo7XpuCkYzFJzHDdkD2SeJzzQ2K29NjoJXp7a28u/C9apQ==
X-Received: by 2002:a17:902:6ac8:b029:da:d645:ab58 with SMTP id i8-20020a1709026ac8b02900dad645ab58mr7978175plt.25.1607629879296;
        Thu, 10 Dec 2020 11:51:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v126sm7114866pfb.137.2020.12.10.11.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 11:51:18 -0800 (PST)
Message-ID: <5fd27c36.1c69fb81.9327.d446@mx.google.com>
Date:   Thu, 10 Dec 2020 11:51:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-45-g2028d68d9bb54
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 6 regressions (v4.9.247-45-g2028d68d9bb54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 6 regressions (v4.9.247-45-g2028d68=
d9bb54)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig  | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

r8a7795-salvator-x         | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-45-g2028d68d9bb54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-45-g2028d68d9bb54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2028d68d9bb5469a569e652f607bea603c23cd50 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd242733d27649183c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx2=
7-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx2=
7-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd242733d27649183c94=
cba
        new failure (last pass: v4.9.247-35-g719d762369895) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd240a027611622cfc94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd240a027611622cfc94=
cbd
        failing since 26 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd240e695cc91c82cc94cf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd240e695cc91c82cc94=
cf7
        failing since 26 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd240b520aa288fcfc94d0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd240b520aa288fcfc94=
d0d
        failing since 26 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2405614d58f156fc94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2405614d58f156fc94=
ced
        failing since 26 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
r8a7795-salvator-x         | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23e7435b2268683c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
5-g2028d68d9bb54/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23e7435b2268683c94=
cba
        failing since 22 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20

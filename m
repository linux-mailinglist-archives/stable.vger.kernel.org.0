Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0343D4182
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhGWTsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:48:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA36C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:29:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d17so4365346plh.10
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PbGBvf4yxqgirRTy26z/8Ke00AIrxZ6Zk4OW6L6vt/g=;
        b=K7TEaWHTQ9bfYnaSsKp5ovk62WYhdWH1jlo1z6dD48A8XlGShopBx2rT+DQePf7n/Q
         q+E1XYS6Mah+MKF9sOdAr7sKqsIf9FGnzh0i7DESc1qlldVXYmLKFfVMjHmrbmDjSkK3
         WOsbU6JzXHr6Yy8j1L/8gPA1LmNq8sS43c9V197ek6dvXG+koz/gSYmH81rQLHVXM3mb
         jQyqVpk4K8a9VJm3q01dLTnRoORzyEmcoWg8aQQ1seHv0uOu49NIZtWhKGuyIHoFfeWG
         qCIOGp74c6fT1CEw15fYnl4PFMb0WeIbtWZZ/s9LPSwqALPBZ+6C8UL9uSPy6RlNGNNZ
         jrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PbGBvf4yxqgirRTy26z/8Ke00AIrxZ6Zk4OW6L6vt/g=;
        b=iLfCxK0r6TAt//FkG+md4czZAB15RHka9QRShEZVHObAAfxPtOdRcXsLGVdF69dz9H
         GvhgXPD6Bu/2TiCH/jnuXwW8j81TEGSg1K5jYsXfviaXfs/S/yJ5zOZYGEuFMsagIovl
         fa0vYys9MAh6wp3uHubfBIviORMmktxbA++qYasZhsZ5nw6S0NQ9wmZDlIR/pjjDddW8
         Hm++KAF0Ed2r95Qb0CvcQBx9X8QfXvifRn33ffKoK5zs+WPsLUCNlxflGYJc8gCweH7F
         PdQgDFpN+khaQ8KAEuHABg/1zuxVq0tQj8yF9kvhXEkcbCzCU6r3b1IQ8vNwn+keBqjo
         X57w==
X-Gm-Message-State: AOAM530Zjfsp9/sFP7x6D3aD9JpwYgjdACn6XBkm3xesoa9ueEMflKbH
        gro3a5onj5hq6DunGudi6vu+fIxrXJpOvPyi
X-Google-Smtp-Source: ABdhPJw1nmzsBlR26aGY5aXvhNY7J53WI/ZI+eIr5w6bL11sIQziBA5ALhauAeAjLYAQxg8lgBYyFg==
X-Received: by 2002:aa7:84c1:0:b029:32d:6bbf:b788 with SMTP id x1-20020aa784c10000b029032d6bbfb788mr6223820pfn.38.1627072157777;
        Fri, 23 Jul 2021 13:29:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm6717750pjn.11.2021.07.23.13.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 13:29:17 -0700 (PDT)
Message-ID: <60fb269d.1c69fb81.94c2b.5ef7@mx.google.com>
Date:   Fri, 23 Jul 2021 13:29:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.239-350-g8291ce1198d2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 104 runs,
 4 regressions (v4.14.239-350-g8291ce1198d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 104 runs, 4 regressions (v4.14.239-350-g8291=
ce1198d2)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig      | 1     =
     =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig      | 1     =
     =

qemu_i386       | i386  | lab-broonie  | gcc-8    | i386_defconfig | 1     =
     =

qemu_i386-uefi  | i386  | lab-broonie  | gcc-8    | i386_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-350-g8291ce1198d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-350-g8291ce1198d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8291ce1198d2f04349cb66e30dd8eca4f9ea1711 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig      | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60faee15629af74f723a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faee15629af74f723a2=
f23
        new failure (last pass: v4.14.239-350-g6cdb9f8bc2b2f) =

 =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig      | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60fafd4247fa01ab843a2f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fafd4247fa01ab843a2=
f27
        failing since 144 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
qemu_i386       | i386  | lab-broonie  | gcc-8    | i386_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60faefa62e6fcd713f3a2f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faefa62e6fcd713f3a2=
f24
        new failure (last pass: v4.14.239-350-g6cdb9f8bc2b2f) =

 =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
qemu_i386-uefi  | i386  | lab-broonie  | gcc-8    | i386_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60faefa54a2bfaf6bd3a2f84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g8291ce1198d2/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faefa54a2bfaf6bd3a2=
f85
        new failure (last pass: v4.14.239-350-g6cdb9f8bc2b2f) =

 =20

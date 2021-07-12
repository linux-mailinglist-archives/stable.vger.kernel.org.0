Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3666D3C4310
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 06:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbhGLEfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 00:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhGLEfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 00:35:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC35C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 21:32:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v18-20020a17090ac912b0290173b9578f1cso949090pjt.0
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 21:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MB5Ambe29GR0iQeDyZ6NPX68BWeujtB0X5GV2XXpg7c=;
        b=bFe/HPFr8s4f+tL1P47/XwqbWSBLNX/0iXtdVnBbjAUl5lYcdZYJpdQxFv2K6jF1UE
         w0ATonDADOtZ664EGR0MBy7JhhiHg7v7R5W0neW8taCWiIOjFC3JoLLAzCsYZXs95UA/
         0nO11vuVrwwY+eux3w3h68nLSPW1pFJmE8BklPgcm1sOaCSMhQ7IqJuPv7gbWd6TYBug
         104AD4HemoO+Dvm14DfPlood0skMU4YUvJOPKQV/sJpQ78hPS9AnbEhJzKPSA0RWqROh
         Z1+w4VBSfUo5ZfoEvf57J7E6xZPShHZHjU07AMX2kTLgsSQwKV9rWz1EDuXWhl0GLLpg
         pEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MB5Ambe29GR0iQeDyZ6NPX68BWeujtB0X5GV2XXpg7c=;
        b=M6pyGWckOlsAf0tbKt+Nh5npvFWH/GnvamYNZaGbhkNMJRiXP/T4s9E61wSwdlRe7o
         LM0X056ClL1VHkAKHj+fWDWGP9jO4eW/g81u4jsJJ0N3HmCV3QiEY6BY9M1QBOJwNdvU
         nHnbYyZyiqb1YSTNdpDw7sAgEpROv45fuT1SBrqNPZTsAp9n92OP5nYWMMcfMQPTMbm6
         l06u77TiX57PggWQBC4q5qTf0ZBjHd2So1TkVqtAiTd8n2nxlahg973xJHsgstA3uaTA
         Qc4rv54hDLr076vRiw/Y+LvE4XrZljW5Vzq720BnBUnpjAVAEa1JU4s8mXkm1wxeGSjq
         6FmQ==
X-Gm-Message-State: AOAM532ZUhhyGaf0/O6mcZ7k1bTrwYFnbpHKFr5u2eHyB2hqcH1GHIIN
        GxJ7tluMAa1buPZ4qmqDvhxwnWsQEONH5BPe
X-Google-Smtp-Source: ABdhPJxZ3d6R71vx83TtxmL4QhIq2V0v/3UYLekFEcQX3d/LzoBLOr7K4VA3FZ+PWA1IGGb5zGlDQg==
X-Received: by 2002:a17:90b:eca:: with SMTP id gz10mr12341061pjb.234.1626064372053;
        Sun, 11 Jul 2021 21:32:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k20sm19543926pji.3.2021.07.11.21.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 21:32:51 -0700 (PDT)
Message-ID: <60ebc5f3.1c69fb81.c55f3.b521@mx.google.com>
Date:   Sun, 11 Jul 2021 21:32:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.131-349-g11c6e4069b3c5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 145 runs,
 5 regressions (v5.4.131-349-g11c6e4069b3c5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 145 runs, 5 regressions (v5.4.131-349-g11c6=
e4069b3c5)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.131-349-g11c6e4069b3c5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.131-349-g11c6e4069b3c5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11c6e4069b3c507d21245d2cfcfe8b6c90b87974 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb930e24f6c97e2711799c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb930e24f6c97e27117=
99d
        failing since 233 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb9585856ee4e39c11798b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb9585856ee4e39c117=
98c
        new failure (last pass: v5.4.131) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb91c754102ba86e117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb91c754102ba86e117=
973
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb924c3bc452960a117980

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb924c3bc452960a117=
981
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb993c49eed1cf58117973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-g11c6e4069b3c5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb993c49eed1cf58117=
974
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20

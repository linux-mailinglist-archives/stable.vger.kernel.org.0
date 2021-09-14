Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE4940A2A6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 03:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhINBld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 21:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhINBlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 21:41:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8748BC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:40:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t1so11186940pgv.3
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9vPZBCSfAiXeyy0UeQn8ISbQamTU7jmwG9WtXJ8pM+4=;
        b=QnqErmTM2hFy8QfgjKdJEOp1mgYJF60Xm0jjvvy4JuCsIxFeIuHyxheQLWOdYUjltJ
         0G36dFIfojJEXdEB4SPdMQqV9U7M8bkB4bRcmN5wGokFNC7MSN/WHC3SEwLhZX/0B7VL
         WYPSir2sgrXBi+9oB3MNn7iTj/ZtUiUg7JWA5JrpsK1fx5+A5JJ7z7RNUCW/GGbnau7R
         p6pjTlfgEN0irs9FkHya4QhsHhdeoZiZsHBPMJIR3AQ9/ETrD4pzdlbkgFMgKt99DmnQ
         Wm56tVSWPJCQ1ohDlSW7DEtHBGVHe/hZaamNVQqRUNi2wJG+xzP1FaUERpMbV6g9S/EU
         Zo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9vPZBCSfAiXeyy0UeQn8ISbQamTU7jmwG9WtXJ8pM+4=;
        b=oPnktTVzxX1wrMHshR00NqS3M9h+9PscoICDdoFMtiIXscbx9iC/3XJxoQstVpSd/d
         G4APW6DA/LO4tEX3kZxtwgln1UND86vxMj3kIs9RIzgvMyacuAd7oBEc4icABuhX32el
         IToMCgGk8BOiS5QJDQr9EsRK5wGnWN4V0kKvl4WYO131ucB8Zf4NofHkRB8h7a154oAU
         GYplyJSMhKlTU2dBbtEh8b1Ys63f503Ptl2awdrC1h+KcVpbZH6YYv84uTGdR3Fm0xNc
         9/BKjRip7q75cidTTWGW3t70nl0KqRxpjc+6W48XpSDR8d7ewhbsrFhcNvVTCJmFQ/PB
         iPrA==
X-Gm-Message-State: AOAM5334MmTDyZXNSgo64QlJwYRxIUC6UrTl6+dQhniOOy+bD7IQwoqt
        HxcaD+/cy83gH9ZxPxoWxwWV5ImlrsZhEFgO
X-Google-Smtp-Source: ABdhPJzW24Hxz1/ccfXtCr65ii5bLiEioqM2iYgHq/bLmP9PY/7cBZ4hFP3ttxVc/+Hg2MLWH/kd/w==
X-Received: by 2002:aa7:93dc:0:b0:3f8:a765:a948 with SMTP id y28-20020aa793dc000000b003f8a765a948mr2299753pff.27.1631583615834;
        Mon, 13 Sep 2021 18:40:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mv1sm7820266pjb.29.2021.09.13.18.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 18:40:15 -0700 (PDT)
Message-ID: <613ffd7f.1c69fb81.139ad.77d3@mx.google.com>
Date:   Mon, 13 Sep 2021 18:40:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246-101-gd73a5c779001
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 113 runs,
 4 regressions (v4.14.246-101-gd73a5c779001)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 113 runs, 4 regressions (v4.14.246-101-gd7=
3a5c779001)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.246-101-gd73a5c779001/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.246-101-gd73a5c779001
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d73a5c7790019b70d9454ee9797c223198ad8ff0 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/613fca2c6510a152b899a363

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fca2c6510a152b899a=
364
        failing since 531 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613fcb2aeee44c22ad99a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fcb2aeee44c22ad99a=
303
        failing since 303 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613fcb2ceee44c22ad99a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fcb2ceee44c22ad99a=
308
        failing since 303 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613fcae2e635596e4c99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-101-gd73a5c779001/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fcae2e635596e4c99a=
2db
        failing since 303 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20

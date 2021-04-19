Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9296D363913
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 03:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhDSBZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 21:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbhDSBZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 21:25:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CF4C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 18:24:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q11so3738252plx.2
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 18:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XxD3ZoPB0uddW8OqmtShaeS+0VEQKU1ixn2aCZv7+tg=;
        b=G1iOFnSqKgVNt9iC2lIae1OY8wrEpnWPUfw1mFzJ5ApNYVmrbwokFOcCPz/GkxDDaL
         I8BT2ueW8xCYhsj5cZO4qZGFpeIs6LI+iIeMqFk29mYxORQN0s81QF+ermL4hK7YEtOp
         cdW//vs+0bbAVKoiPswli6eTdsS98lE+/hyx6VZTUXSWcfFYdhmBAozxtPX8LxhLAv/4
         Av572ZtVxr9gvYI6PVBk/AE2HhOv3de0Yyb8+gomNElwf8G1/5XxZlCrwVJKgOjfFa7N
         7qW1HQ3eZfPZxDu16esJX9eQ+nRJyqYHRLzBQE5EFzK97Ap2fIVrAZjRE4tQimNXmIgX
         /zpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XxD3ZoPB0uddW8OqmtShaeS+0VEQKU1ixn2aCZv7+tg=;
        b=rZMKlK2XxR+fvojx9VbzWhis03R5EgOvjqc1tzSn7BMk433WSD1ed5ZclrvgOWXbjq
         A2WD8lYp3UTQA900+4O1/ZhTzGYZ+KjA+xBbk0lXFMISbIOSpx1/SMWYkDgCPa89+1rM
         oKXgck88m+/QC6e/qvWtVoUkGOI5dmnwy9a/QB3sKBloHoivJJcNIP/QFwQvTvc9YBvr
         zNBFES0rEp/3VoUnAe8yeZx8PTy9o/0dq7x7polis+e6KF23rzjG4Bu1IUUNj/Ll89Er
         C3AQ3JUtvfeOKp2aserXu5GnbncH1aWTVGalYkDiNU0VsOSsqmQNdyjka4Gya3u0hAW0
         nuGA==
X-Gm-Message-State: AOAM530UKIdbHuM7RWtyQ2mAL56/iTRDhpkSf9KQ5zODqKFQuFFPj0R3
        shO746NdSVcx9lYVjzCQkISGLyeAqd/zaENA
X-Google-Smtp-Source: ABdhPJz+CuM2W5Yw3CqnytCgnV12O+BGtz6Sg3xh3ab9LYFVbwQM7aDe/3AJ9CRinGKBXlnMay2VHw==
X-Received: by 2002:a17:902:9b97:b029:eb:7a1b:5b88 with SMTP id y23-20020a1709029b97b02900eb7a1b5b88mr19578815plp.77.1618795494223;
        Sun, 18 Apr 2021 18:24:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g23sm7486950pfu.142.2021.04.18.18.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 18:24:53 -0700 (PDT)
Message-ID: <607cdbe5.1c69fb81.ed243.1e5c@mx.google.com>
Date:   Sun, 18 Apr 2021 18:24:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.231-35-gcc452f42be342
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 106 runs,
 5 regressions (v4.14.231-35-gcc452f42be342)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 106 runs, 5 regressions (v4.14.231-35-gcc4=
52f42be342)

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

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.231-35-gcc452f42be342/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.231-35-gcc452f42be342
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc452f42be3421a000cd76d57ebd739a034a4936 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/607ca63f7077fa608bdac6da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607ca63f7077fa608bdac=
6db
        failing since 383 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607ca4bb421d506c1cdac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607ca4bb421d506c1cdac=
6b7
        failing since 155 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607ca4c0f2e7a0a45edac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607ca4c0f2e7a0a45edac=
6b7
        failing since 155 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607ca4c82dea5ec56bdac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607ca4c82dea5ec56bdac=
6c6
        failing since 155 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607ca4664a903bf17fdac6c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
31-35-gcc452f42be342/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607ca4664a903bf17fdac=
6c9
        failing since 155 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20

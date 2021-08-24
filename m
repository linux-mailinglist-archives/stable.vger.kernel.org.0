Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9273F6B5C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 23:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhHXVwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 17:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbhHXVwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 17:52:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0206C0613D9
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 14:51:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so2838240pjq.1
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 14:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JNpPbQyRcfhbZypzkHkcyrdhqBOYG6SdLWbsY8PA2Mk=;
        b=VWjDPeT1zCXBzFX216fBsix98rTdCaCk5CCsdHCCH5J8VccDyG4zYdSz6eclWcll7a
         MkE4qYGEgHFXvbmTHrswwJwp25zs4aPFb4ObY4trb+oXJM5Y3ljhQZzazFIM71fpyxnl
         4Y48cSfcsJNOw/eu75xaOS/hLM16hJ1xT6jYykHh+xsMDxiO2YdNK3rk5PzrNsumoRg0
         Jki4m2hJmlv8Bi3KN61Rroa0eM6JJdqFwwyzXxVjHTt04epKNqn7xD7FR8zpNKLHEele
         bV0JdF31I3ecNeBVi8y7oxKXRrEhQtcfqqaBM8GWxz9sa99ppjo/2E9XAToIA7cyXPtt
         SylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JNpPbQyRcfhbZypzkHkcyrdhqBOYG6SdLWbsY8PA2Mk=;
        b=QZW/rrS+9lUZq6l5odC1Pd8ckbcl5BbNiQW6lLlRGeqiIOHSD1WM8dRZk8Q9L5BFz+
         YqCre2twRZr2uG9SAJ3B2HMNx3hpu5OJoVW6NnbnYb5sCbwQca+Wu7LHRqQrAv+QgYD2
         NZFgp6DYAJJm/ksAEk6N1Lc1vLhR7319SZFI2rUixickG5wvGrMwkwUPFm7hBPdNu0/h
         d4kO4xhEFTJ4omProGldqmJbl5GlUVwk4ML3BEYFv2SypyP5bKPt/i1DGqyCQg93BB4/
         yjnIwBFnlvlmV209iJpf9i1EVVP/EW+GYYGDlmOiDlDSTZ0R+rC3EdusmgRy5T/wqHVI
         xn1Q==
X-Gm-Message-State: AOAM533xrvg4WQKIweJS45hz/yK0m7BTLHy71UDg7ajaC3ZXorAbeFHh
        gLk4IXfxmzbBzbDgfTuXpuahfiCR5SP7D3UU
X-Google-Smtp-Source: ABdhPJy9NDy1CEe/qhhlYxXnlV1rb8zaYL7s8Eu8JLojPURrhw8y7inLYQ/gL+93z5k8NKE9AyJW2Q==
X-Received: by 2002:a17:902:cec5:b0:137:5852:c544 with SMTP id d5-20020a170902cec500b001375852c544mr1138148plg.36.1629841909973;
        Tue, 24 Aug 2021 14:51:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm806369pjs.11.2021.08.24.14.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:51:49 -0700 (PDT)
Message-ID: <612569f5.1c69fb81.6262.3005@mx.google.com>
Date:   Tue, 24 Aug 2021 14:51:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.280-43-g3d204357a2ed
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 138 runs,
 4 regressions (v4.9.280-43-g3d204357a2ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 138 runs, 4 regressions (v4.9.280-43-g3d204=
357a2ed)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.280-43-g3d204357a2ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.280-43-g3d204357a2ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3d204357a2ed1b927c75e0166f31aa67a5d99c4e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612534b76d225f3ce58e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612534b76d225f3ce58e2=
c78
        failing since 283 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612534b92973ca03548e2c86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612534b92973ca03548e2=
c87
        failing since 283 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612534b99f4659ccd48e2c83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612534b99f4659ccd48e2=
c84
        failing since 283 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61253459bbf43d7f918e2c99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.280=
-43-g3d204357a2ed/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61253459bbf43d7f918e2=
c9a
        failing since 283 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940E12DC348
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 16:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgLPPjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 10:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLPPjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 10:39:48 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EEAC061794
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 07:39:07 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s2so13130369plr.9
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 07:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g2a+yCD+dxwJQLCWtc43pU12NKaVcruFCe7ks6N+w58=;
        b=fVcUZOV4pXZKfD1LQtzhivJvUHAxs/TZPB0saZuLzJisNdKmK3v7CKwSg7oigg4lTf
         BGO/ufVo2rjnfRixUMnud9a2qHqin9jR0ChTz1UOxclWprQ1sLwuvaYNZtTiLEgRV+XJ
         lgBE/2wzaG+saEuKsvLYW54cbVWCqHbXTO61qhpPjNgDLtanvSskrjeiNmfWKAQO0bUK
         iNq4uKbb8HfkDIhWtSj6S6fTD58QZhX57gsXm3w/hIKniWb+M47PvcOdD9FflkFmyg8i
         JO59/qM1g9qCqNOyS/Bu3cybonWkfDeeW9RH3rYaHx5YTdHPbB9LDm6elD1M7JVJiiZv
         DGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g2a+yCD+dxwJQLCWtc43pU12NKaVcruFCe7ks6N+w58=;
        b=o5i/qceCeAt1UVEjwfRnlIuEapUgVgZjSmwdpG0heAtPD3KQsL1eckblT2+GM/bkQn
         hfd20gy5Zay1GAMLfhkXAAhFP+eEnjbw6Vm04VRd2dPe4/vPifylEsD6s4J5Q0dTzqHr
         Y+Pjv4erpdwiSe327mAy1qhm4EedQ2xAtGvKdq2TbVmtLxmgjjgZTNH0TOQT4P5jJuCx
         MR4WM0py5HhVrFoaKqI8kgmsSRnVzW/j/8SjqLZjBX2MEj7SFIhmtjkXqp24M+GqV8C5
         KV6kHpVVCMdvleyq+VZtwfuXiZYIRBgFSoHpm/AyAZznbcpVquaEmlNzDsSYiX0kaKcy
         t1Vw==
X-Gm-Message-State: AOAM531Ff8vMgMkb2Blc3KzP/bTqz1pn25fNMkFXez8uvAdYe+OuWAEu
        gGw2zrYyluAaUi+Is3dShi4qzBid6/BdaA==
X-Google-Smtp-Source: ABdhPJxt520HwmXRPdq9WRHC1fMzXG9qp4hgKnfucjb67c9rajuuW7UbhQ75tlRt18CpxrIhWDeoMQ==
X-Received: by 2002:a17:902:bf4a:b029:da:d0b8:6489 with SMTP id u10-20020a170902bf4ab02900dad0b86489mr32029445pls.58.1608133146916;
        Wed, 16 Dec 2020 07:39:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm3041878pfh.207.2020.12.16.07.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 07:39:06 -0800 (PST)
Message-ID: <5fda2a1a.1c69fb81.9bf20.6848@mx.google.com>
Date:   Wed, 16 Dec 2020 07:39:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.84
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 150 runs, 5 regressions (v5.4.84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 150 runs, 5 regressions (v5.4.84)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.84/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8a866bdbbac227a99b0b37e03679908642f58aec =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9ed9c877f5a0b6dc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9ed9c877f5a0b6dc94=
cba
        failing since 27 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9f0a3ed225eb7e5c94cf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9f0a3ed225eb7e5c94=
cf9
        new failure (last pass: v5.4.82) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9ee641dc554f21ac94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9ee641dc554f21ac94=
ce6
        failing since 27 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9ee62845955de11c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9ee62845955de11c94=
cc4
        failing since 27 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda172da1521ef445c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.84/arm=
/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda172da1521ef445c94=
ce4
        failing since 27 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20

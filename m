Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF85A48FE24
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 18:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiAPROn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 12:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiAPROm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 12:14:42 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13822C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 09:14:42 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso27126780pjo.5
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 09:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rUDB7ZNl33M7LEudOwpxM/sRnGkNveF259R2xwbHAbs=;
        b=6nZzkuXK+RNWrKkdWtarOlqR5k8Co8PVHsbjwBHMcaoIHTgv6+8KvKmvzrDJ5ObtPC
         NtEYKMqFfGuwjaC96cuQNEsKYH5tuBTdGSevFDFoyfmMHk9iIGCKe2DpN+9v0ffrrb/Q
         aRBChsQryo4srM6KdhwMV+nmoxm+ESrCiOQGMam+W+0JY2dFVTN+WtSv/FQ86EvizQlC
         Bp3x/LUIqRbrcX7i7huVXvz09DZ5gvLUTNu8pcqdVYJvdbJQy2NIadWwuVtVXjUvHaUT
         D1VO+MxPilpQCt/uPdg2Y9Ap8am5elWFlHkCmgTz5UFsi7YW5eiC2WV7WOO7fUuL7TIf
         ot5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rUDB7ZNl33M7LEudOwpxM/sRnGkNveF259R2xwbHAbs=;
        b=HdstwiwkYbKd7hsW42LALEiSP1MjghKHrH+7gRgXopESMnA4XWlE5MzmzzJzgdG1c3
         hLm1lLzMbUDrF/x2axt9McUoxOwVsXoyPRaGLCKtvCx/qYHrzX6STtuqPXgmSR+Jwsab
         klL/lu0rt2jzRuUMLJ3YyltkTAuivMDPvvrtzKOmnDGawagK9dhW6jEPcjeI+ZRJfw2w
         S5ZGxAN9DWtQLDcQD48VxOezsU2uM3Eg8YxZ8VqyM12UN8T1c/FUtbh5qQev+1GpgQos
         +f4WSDpbwJe3ii7/jQub3qEfBziNLQakTpRt8te/0btBAssNk+aB6NN93gbAnke4bOp4
         1Xdw==
X-Gm-Message-State: AOAM533X13nFbQox43RhNqgEcm6Mx4YpmU7HPukrS8p19rUHbysf7khW
        lPJdUw41ucjqf/x0knzmmg5Z6Nz1pxqv83MO
X-Google-Smtp-Source: ABdhPJyFXEB2frTYZTU5wAthChxMO+lz97DQmfNPVkP58/BuM0EhW4dm0HuXxzUJilsfiogr5JmOfw==
X-Received: by 2002:a17:90a:bd09:: with SMTP id y9mr6520025pjr.57.1642353281434;
        Sun, 16 Jan 2022 09:14:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng18sm17880306pjb.36.2022.01.16.09.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 09:14:41 -0800 (PST)
Message-ID: <61e45281.1c69fb81.a319e.e3d4@mx.google.com>
Date:   Sun, 16 Jan 2022 09:14:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-19-gb7f70762d158
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 153 runs,
 4 regressions (v5.4.171-19-gb7f70762d158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 153 runs, 4 regressions (v5.4.171-19-gb7f70=
762d158)

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
el/v5.4.171-19-gb7f70762d158/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.171-19-gb7f70762d158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7f70762d1584a2b66e056412fd39ad6f6344c89 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e419f276cd3c3867ef6740

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e419f276cd3c3867ef6=
741
        failing since 31 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e41a16b097d5fe48ef6741

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e41a16b097d5fe48ef6=
742
        failing since 31 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e419f4e864fbbb1bef6748

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e419f4e864fbbb1bef6=
749
        failing since 31 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e41a1728e1931b3aef6742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-gb7f70762d158/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e41a1728e1931b3aef6=
743
        failing since 31 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20

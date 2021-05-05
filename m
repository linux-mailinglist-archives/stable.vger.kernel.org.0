Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A90373470
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 06:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhEEEeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 00:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhEEEeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 00:34:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC04C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 21:33:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b15so1147982pfl.4
        for <stable@vger.kernel.org>; Tue, 04 May 2021 21:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dCbbZlShgZap6CjY9hqqf/SpDWtE1d6JzrscBr3h9Ks=;
        b=OkUY0U9Q5sxlabkbUEtR/p807dSztb3gabGHNzN11jGSb+mQ/h84UxZO9WeYCyuAJm
         dROklj+ZmiX/aD784242HaCrI8p1tuvLaM48jotca6EV7OSmJXp7EnXF8vDuAlJOJlj8
         +myT7ndLwZGveMemNZ1KJQmd2tapHv5Hl997Xvg1s0Fz6AUis0L3o62o4x1Z2E2tpPML
         KO8/m+2lTqjfPA5CXMa8+IDLD8RuaAPWDacXNbVfPo5vrwarSkuifPyDAMJxHWLfzSey
         MGddzoTw2MbYA7zp16cGuUm6J/BJLahCxhUKdVT3+ZX9Lnny/l+i/nUQ11JhRkqYwpkP
         dMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dCbbZlShgZap6CjY9hqqf/SpDWtE1d6JzrscBr3h9Ks=;
        b=paCIQwD/XD4TIRQWx+zbSkGE7eFhMfrFzfBg8o2wko+XkMYzYeCXwyhWjEJVG0/0bu
         ptyLh237gbxzwFdd6zWpkuaUxmO91UrLZH7kNsNNcPOvHWuRIrr2iWvpXUKjNTvsDMKc
         GLWgRM2wtbVVkRCgdzSHnhbZe6a0dA89Uc8UNOZq/KtUT0p4nunkkUpJ5w9csNcvkTAd
         6yWOCwOjcEY+/NzJLu01jQB01IRx2+3550Qqj9hBcpYoJVbbXWIpFv50KX1YSnux+xc4
         62JqzozkpawwH9RxK/JpTFz/u+viwrbOWapRhYdSweN1MMOjnRsfZkml4zbeRXUvnOQM
         QqbQ==
X-Gm-Message-State: AOAM53166MVlnWymguUKmRaWk44lCFobPHnwPcP9ASXZ0jAJf0JDZ0HK
        ZStD4i04/vrxwzJKodyMOhblI5ViNCCSfrmu
X-Google-Smtp-Source: ABdhPJzXgF1SxS5Wk2qRl7HDwLDbq7zjzth7iUA7i/HUJ1+pzX8Hfo1WhmbtldZN68DxLHGQ17RV2A==
X-Received: by 2002:a62:ea1a:0:b029:27a:bcea:5d3d with SMTP id t26-20020a62ea1a0000b029027abcea5d3dmr26818158pfh.69.1620189193358;
        Tue, 04 May 2021 21:33:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q194sm11305471pfc.62.2021.05.04.21.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 21:33:12 -0700 (PDT)
Message-ID: <60922008.1c69fb81.b8fb9.df4a@mx.google.com>
Date:   Tue, 04 May 2021 21:33:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.116-11-gd885c7ab9671
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 74 runs,
 4 regressions (v5.4.116-11-gd885c7ab9671)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 74 runs, 4 regressions (v5.4.116-11-gd885c7=
ab9671)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.116-11-gd885c7ab9671/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.116-11-gd885c7ab9671
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d885c7ab96717a7ab15d568af6a4ba86612dc78c =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6091e497a132f78a94843f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091e497a132f78a94843=
f1d
        failing since 165 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091e497ca3092b014843f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091e497ca3092b014843=
f24
        failing since 171 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091e49ba5f93fedcc843f2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091e49ba5f93fedcc843=
f2b
        failing since 171 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091e4a5a132f78a94843f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-11-gd885c7ab9671/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091e4a5a132f78a94843=
f2c
        failing since 171 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED93428B3
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 23:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCSW3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 18:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCSW3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 18:29:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26BBC061760
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 15:29:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h20so3597686plr.4
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 15:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q5is7m7/AcxROfSz3/W5xd8xU1xNoE4vT+mYPD+ef60=;
        b=OjNeM6/7Mb0PaATMafglXrwREKsG7Wi+Y4NDs9BcKAy+pY+61VOKb82Za3LxDX2P9v
         lM+jH/nhIbifcteMEVO4YuKehAAqFAWy+TSiNabwlcrUNoJtprMzNmCkRx78q3PmHG1a
         ej3kjaMSeJNAlpj9wTB3SUkvrPGeE9z0RpLcMA9W0SC99D/dcmZiLvB43+htvHUxbGbd
         VZVg0JA35pFzOanV7XD6viBrmRaLzT64C+6JzgqSCYJRYIjC0u2ZsF4vLgTDHgs7lFDd
         BamrQcppwFFG1S5BQFfUnkMTMeSvV2D+FboGrInvitpzVU6Ark/5Xr2YH1eGlEIHPJUQ
         yFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q5is7m7/AcxROfSz3/W5xd8xU1xNoE4vT+mYPD+ef60=;
        b=Pi64HaBNmFk6zL4Okqxpi3HWOP8zRYM4RCn9Rt00QTYGg8BCRAktZ/7kQgIu+3qeaX
         hXwfVQ0SSU961441sefdw3RDBlMe6BOLIX6Bxc3bPgpUMB4ZXlLn2vZI2ckBxEW3Gi91
         A7/nwjTgEXFQvqg037nNyYhyasfWjlkLMsVnW+iWPChwgT/WtXk7MQrrcppLOsiF3KyD
         C3pXDbtUSdYPL7RtTuOpE05OazuHrJDiHrLSyxIH+xeZYch5K/otWAidoYDdoVGD2is1
         Gh/fOTZz+edjUTBRt24M74v0e6Q+1HmR/H1YIr6Dhu2QvlMolJt9BQVAY2NADvNmvraX
         9qVA==
X-Gm-Message-State: AOAM533RJU+F6tnvzzUDXwS59lmOYu0gDJ469q7sOTSxPri5SWoB/+Es
        UEg6lywKk1V0gqDMdyzIqllWsW+RyRG5cg==
X-Google-Smtp-Source: ABdhPJxrv+txaCrC8Cmc18ErnAzHaQbpSGmAxc8W+VgmKUj03frTphIcpRIsMVe/WFW5tdiV+YDflw==
X-Received: by 2002:a17:90a:f184:: with SMTP id bv4mr653834pjb.43.1616192957284;
        Fri, 19 Mar 2021 15:29:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o62sm5722635pga.43.2021.03.19.15.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 15:29:17 -0700 (PDT)
Message-ID: <605525bd.1c69fb81.0b5c.e210@mx.google.com>
Date:   Fri, 19 Mar 2021 15:29:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.262-4-ga89e30071ec85
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 4 regressions (v4.9.262-4-ga89e30071ec85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 104 runs, 4 regressions (v4.9.262-4-ga89e3007=
1ec85)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.262-4-ga89e30071ec85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.262-4-ga89e30071ec85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a89e30071ec85562f99d809f72ecbfebf0de6ab4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054f321dc3432b3feaddccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054f321dc3432b3feadd=
cd0
        failing since 125 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054f314dc3432b3feaddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054f314dc3432b3feadd=
ccd
        failing since 125 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054f327dc3432b3feaddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054f327dc3432b3feadd=
cd3
        failing since 125 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054f2b7856f0716b3addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-4=
-ga89e30071ec85/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054f2b7856f0716b3add=
cc1
        failing since 125 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

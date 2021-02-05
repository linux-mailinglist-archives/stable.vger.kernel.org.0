Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D349310F9D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhBEQ3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhBEQ1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 11:27:07 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB59CC06174A
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 10:08:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id o16so5103503pgg.5
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 10:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8fq/nj0nI9m4gA0OxlKB0fWXPdWsh7LN7hb1LPHNkos=;
        b=qUULlUE5+HbonwLUsM/vL7A3J93znxXUHNFOzgSfb2ECQewoC34C7i0+FtaF03MH6X
         EqAfebzkF+LSKDsPLD8OGOzhc+votRSr/CoZrZtn2tF8x4NisbILDbGrc/EJSS/L1Cbm
         VeRZH+spYlmxWIqCbcaF/khUhlIvDwegl2Ktbi+uDfyIWpn+dZtl3/rwr3uoNneO+U1T
         H/P+3H4At8UzTZkUMa0+hEPR0/nAJ7KZ/aUC4HP8+di0M4S19YM+etFnWHpH45Lsswct
         FSYjQ3zRATHwy4yJYDQ4I/veyaWVvlhWtTJczW8yM/GvpM5tpn4lkoZSHdce8nhZd6qp
         idOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8fq/nj0nI9m4gA0OxlKB0fWXPdWsh7LN7hb1LPHNkos=;
        b=IsNCunTXZo5HCKW50Z1cpuYyNOrbrXHhxQGD/j5a0KcLaTUFn8esa88GqVp7s0YbtA
         KTBr2FCoyDWrsc7NOWW5bzKHN7F9DFjlMohN6B404w2YXgqCeAsY6jnVLH0yFvmvLwc8
         /GrjY1ZRbNRb0Fqlo5sslMkfEQXRhZ7fjiEUq+R4ZVerkQbb/ir/VnFq57zCeFmOKApE
         30A38N74XoshvLa0Z35BU+y6rWiNO9QuvmAzui0qTHt8qZccB3UsBXNr1MMh5qlbHReC
         9HZ2cUjtt3+ZEsTSgo9SdEok02IFt9WiGwTZmBQD/+UfTxYL8/BUiN9bOv+4RJQGiCrk
         HrcA==
X-Gm-Message-State: AOAM5304lm5LP8DJyEiSmLntVBUjRdqTfIAKBjyONW/jWoWLbBVjD1eg
        +/cSrQusMF1b54K6CjKHoo6CoZOwW3WBsw==
X-Google-Smtp-Source: ABdhPJw9Exw79XaPO0jUqQM/HxZqwRpRgzddtDFmI5ezud53DmBsyk+dxg28oz1CRPtAdfY+Okn/lg==
X-Received: by 2002:a62:8c85:0:b029:1bd:5441:6cb8 with SMTP id m127-20020a628c850000b02901bd54416cb8mr5841012pfd.29.1612548527974;
        Fri, 05 Feb 2021 10:08:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm10302849pfc.122.2021.02.05.10.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:08:47 -0800 (PST)
Message-ID: <601d89af.1c69fb81.8cac8.5e51@mx.google.com>
Date:   Fri, 05 Feb 2021 10:08:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.219-15-g69dc3c086f71
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 116 runs,
 4 regressions (v4.14.219-15-g69dc3c086f71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 116 runs, 4 regressions (v4.14.219-15-g69dc3=
c086f71)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.219-15-g69dc3c086f71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.219-15-g69dc3c086f71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69dc3c086f717d8b9e652dd7584502f3ad6032fd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d53dccd9631f4c03abe88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d53dccd9631f4c03ab=
e89
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d549330d711c24f3abe88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d549330d711c24f3ab=
e89
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d53f3c4e638fa723abe89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d53f3c4e638fa723ab=
e8a
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d53b13c36c6f0b53abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g69dc3c086f71/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d53b13c36c6f0b53ab=
e71
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20

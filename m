Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9412C3274E1
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 23:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhB1WiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 17:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhB1WiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 17:38:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9402DC06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 14:37:24 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e9so8723978plh.3
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 14:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pG409CJXgnzDPoMhu7d96soF2iYdPPKIA9VQEyDX0AE=;
        b=LjEwL2OcUpyDDPzT5OEbdEn1QpUXaNwpQHDOBBOTpuIZNgN42uNDUzkm26MiBzqpqA
         fGMGjtLzAFKgKHyTtA+KwGe1Kuta7z4a3yx7R+C4wOY+6vY/JF/XNjWodWrcu7NHqzWO
         +FqODdBrcBaqAiMj/mL6N8P1szE6FgzNud07jZckv7kYcB9akZzYq2lJCr9lG9BJwogF
         5HfU3GK0E6kBtixLgLEQ6LqJLEo4tglo8Ubl+vmEmbQKu2K1ic6pheBeMu7pBvz65qGO
         vAWIksi56Z+YqsVlow/K8NyWW2zTZGPT1V2BNZmNsuclklvIvJ97BQA+HjNtH99d8vgS
         M4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pG409CJXgnzDPoMhu7d96soF2iYdPPKIA9VQEyDX0AE=;
        b=h9qTt4eB/DFh2Dc+yKw5r0twK18RjANL2VCOd9kVmC6ovaNHt86GyE/RtzfTasqrPn
         fp57Y7DvgU/vnFNb+sbDqgDTE6GvN++k7V8ffG6ZJ0HInqIKNpvr6c6n20ZQ+dDrBQln
         Ic1FAD/rjOgbspCeMPEVDAFYeZU5DgOlf/Qs2CAclMvIJVNoeJSFpSFPJfk0E78LsPtJ
         iJe7ipgbehxFAT2ErkLkmg6F+Waer615D3ZdVraTf9h3VPWlTYyPttH7gHvT6Yzt1kBM
         qYf0zVMmg18xOCrt8MF8Y4TmEXwhtBdiFaDkTYmdvgQzLS4NZn/0QaLzMsL2RuNC0r/C
         jmnw==
X-Gm-Message-State: AOAM5334BF3ZkMXPZRIGvq9k6wUKsLcvpMqjJ0nP2vkjB5yw1GmpYBqV
        RbJ91oa/aN9DBE3kbJwnxbzLGE2djSimxg==
X-Google-Smtp-Source: ABdhPJy7EXaRgJyrAM8o/MU9VP+Y9hm1lTrIc6K5QaYgKvDvzDOoWC5D3L/E6AhCqDacjjQaWJP4KA==
X-Received: by 2002:a17:90b:4017:: with SMTP id ie23mr8655807pjb.118.1614551843871;
        Sun, 28 Feb 2021 14:37:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm13753014pgv.74.2021.02.28.14.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:37:23 -0800 (PST)
Message-ID: <603c1b23.1c69fb81.ee1b2.06f2@mx.google.com>
Date:   Sun, 28 Feb 2021 14:37:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-13-gfb2c1a9e8644
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 105 runs,
 2 regressions (v5.4.101-13-gfb2c1a9e8644)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 105 runs, 2 regressions (v5.4.101-13-gfb2c1=
a9e8644)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.101-13-gfb2c1a9e8644/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.101-13-gfb2c1a9e8644
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb2c1a9e8644e74c6c158407bc9841b7e531b01a =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/603be6368b37be55e2addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-13-gfb2c1a9e8644/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-13-gfb2c1a9e8644/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603be6368b37be55e2add=
cb2
        new failure (last pass: v5.4.101) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/603be9ae106cbf9bf8addcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-13-gfb2c1a9e8644/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-13-gfb2c1a9e8644/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603be9ae106cbf9bf8add=
cd7
        new failure (last pass: v5.4.101) =

 =20

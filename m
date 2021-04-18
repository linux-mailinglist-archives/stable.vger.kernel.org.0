Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C452836383E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 00:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhDRWcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 18:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhDRWcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 18:32:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E4BC06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 15:32:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q11so3598727plx.2
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 15:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3YZF7fv2mM0FVZdeiaSnHSAYeCvNXwU/Hn6tGwKxRxs=;
        b=hIH0qI2mohCHRlsy7VT5ziZhKW7DTId6TZp4RQPpi+rK4NNfV4mk8v/zWBOYKMgZWQ
         62pkWnGYOoRbFIyNC6yVCrK5VQ1pkTzSLqZV2jj3P1OBueDxKyCWVbCN8WI5LRHhZV2f
         fuWGJ0n10z8utnuZEmP6W3134S16mr9gguEfdX3fpylfGMpVtYpNz7BHh5WJM7XRfqUT
         GZpP9HeeBRq8FMIsBqO4baX/Ci4aHVa95skhNQUBJ0ze49vzvYkq5VlbNtBGmMpaXYt8
         9YMACNqyc2E7BZ3zsy3l/D4lGkhQ8gXcGL1/AWcCORexc3DL47DDACriaK6+dZtOCr3i
         MSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3YZF7fv2mM0FVZdeiaSnHSAYeCvNXwU/Hn6tGwKxRxs=;
        b=GYipRH4ODW53wY3UvcsRvsSfWzYO3s22jLO56ksj61+bxwEmoR8BJdpJYfXVUxCHVp
         uCmouvIi7I/jVnZzMC97jZxVK+6hKZy/X9FC360uO+o7t8T3iZZYIwjxP5p9IHWfL32p
         bPRTMY39r7CfG0hV3nvNIcwg8jwt1S/r87OM1aAMZUpEZGzSFW0Ou8P7CGVaH622sUUr
         JWE5i+r/RGfD0oMC+fzxG1dEhyyBci+FVbRBlVQ035aLkkITSjig6DzPmiRM3icx6JUC
         tPbctS2T0rvBeDB1y6RR+gt6E+X5GHAwr7xS/cLYZdBquICIGkGgg+N2KnlbFgBlwBzr
         jijQ==
X-Gm-Message-State: AOAM531AQWsaPblLlHuhERhvmYAJ52YNy6ZHx9HSZq8G8gtoNFj5jKDI
        dhCdGn4/dX2rN83PozNR7LFIb9WDnZ0o4Nkp
X-Google-Smtp-Source: ABdhPJyjkpy5FWUIBHsW33vHgJvquNkCyxjoIr1Iy5fkGzBT9tB5xp/mdu3zCq+bdsG0HCrQhx4vHg==
X-Received: by 2002:a17:902:70c5:b029:ec:9a57:9cc8 with SMTP id l5-20020a17090270c5b02900ec9a579cc8mr2126959plt.73.1618785140475;
        Sun, 18 Apr 2021 15:32:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q25sm1380531pfs.152.2021.04.18.15.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 15:32:20 -0700 (PDT)
Message-ID: <607cb374.1c69fb81.5c926.3847@mx.google.com>
Date:   Sun, 18 Apr 2021 15:32:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.231-34-g84afd00847f9c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 80 runs,
 4 regressions (v4.14.231-34-g84afd00847f9c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 80 runs, 4 regressions (v4.14.231-34-g84afd0=
0847f9c)

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
nel/v4.14.231-34-g84afd00847f9c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-34-g84afd00847f9c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84afd00847f9c9223e8dd0970f6e3fda6a8bbd98 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c7bfc651fc53226dac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c7bfc651fc53226dac=
6be
        failing since 155 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c7bef63ec31988ddac7be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c7bef63ec31988ddac=
7bf
        failing since 155 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c7bd8c07f983491dac6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c7bd8c07f983491dac=
6c8
        failing since 155 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c7b9dc93a7ed162dac6c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g84afd00847f9c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c7b9dc93a7ed162dac=
6c9
        failing since 155 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20

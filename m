Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41AA377423
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 23:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHVMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 17:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhEHVMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 17:12:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AF5C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 14:11:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so7987150pjn.5
        for <stable@vger.kernel.org>; Sat, 08 May 2021 14:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nz6iMcqUZmc6b4gA5ZND7eIRfsOqn3/5MxO6EJDpp+k=;
        b=QMgED1hTisFgXxYOJBBo+T8MdvR2W2KuMk6B9dpX+rfFKBmy+OD9C7lzAFgXKWGYbk
         RmY1yuKPz60nMEbd4XjHWXiKrvKK44zUNh3eCg9SnlH4YbrOoD2DSvCc90kMaN+tEazr
         PTzq47uReY/uhq8Jb0HthdZi+jjhukDjR5YSlJyptb4DjkFeSEBLu0nCjRUTLW17J0BX
         UNR3wY555zBn4JOgBg1U1i/2JnOIC3ZvSmWM9Frpr5orL0Svi6OVuu8xd/pAhdwT+mYq
         d3KDz2nH1+VAh0DoDZfGkfT0F1LrFpQDAQe0K5eXT1o6SHnaJiLUvDsl6bvLihwkNQAZ
         PvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nz6iMcqUZmc6b4gA5ZND7eIRfsOqn3/5MxO6EJDpp+k=;
        b=IEgHJqYY+niwfYKZ6o5Ps54JddekQLEaUuePMlpCeLOZkeFomlwevmIj4bnULNwaqf
         c724vJvc6ywSlwwHMaBU4UuSPcaPJb/JmMfHj8W7SNrZ/lOC6+iikTYRj7ALK+0m0iNL
         7CzoiduRwDiTVysMZlFy7/+0tL0Q/GN9X5kc9Xu9IwUfSBPWsEy00n4JpDOlKGxkGXA9
         MNy4fZodkl2R0hbHBdHM6Q9ThT95bNGH6uL9yMLtZp2sIT6vCgwUIwowsvCUekmIre2Q
         OwkKnwcpx9UxrvXuZeCbA/7sxxzlIKCDmZ+0A6pEgEKHWNm+jTC7C9mGMpxkom5scMFk
         qQLQ==
X-Gm-Message-State: AOAM532zXxWdessII0UpFCFQfZHJ5G82JhyR9pKoIxRDtidSYhjt0whN
        cfUo0o6ZuOQaHuf1nZID0H4oW/dS5DavCT7Y
X-Google-Smtp-Source: ABdhPJyzb2f74l0zbTnWDXy69i0vwSjXED/j3FgWyBQ3u1mCeFE3pwWGGGmxsLeVML5ny0oJXsihJw==
X-Received: by 2002:a17:90a:4593:: with SMTP id v19mr30768580pjg.207.1620508263683;
        Sat, 08 May 2021 14:11:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a16sm7722408pfa.95.2021.05.08.14.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 14:11:03 -0700 (PDT)
Message-ID: <6096fe67.1c69fb81.6678d.77b6@mx.google.com>
Date:   Sat, 08 May 2021 14:11:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-83-gc17ea00993366
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 126 runs,
 5 regressions (v4.19.190-83-gc17ea00993366)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 126 runs, 5 regressions (v4.19.190-83-gc17ea=
00993366)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-83-gc17ea00993366/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-83-gc17ea00993366
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c17ea00993366bb1ab9b9faac628f67a67e51843 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6096cc4e5558def9f66f5564

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6096cc4e5558def=
9f66f5569
        failing since 3 days (last pass: v4.19.189-7-ge7f760cab9781, first =
fail: v4.19.189-8-g29354ef37e26)
        2 lines

    2021-05-08 17:37:14.030000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6096cb9981cb7648126f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096cb9981cb7648126f5=
46b
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6096cb77f9aa5c18c96f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096cb77f9aa5c18c96f5=
46b
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6096cb8a7c5f08fa1b6f547a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096cb8a7c5f08fa1b6f5=
47b
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6096cb2086dd79b3da6f5485

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-gc17ea00993366/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096cb2086dd79b3da6f5=
486
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20

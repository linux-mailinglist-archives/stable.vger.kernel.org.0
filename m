Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0D429E4C
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 09:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhJLHKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 03:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhJLHKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 03:10:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D89C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 00:08:09 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id l6so12908004plh.9
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 00:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3fFn14BoyUMuF0143AFqk1g+zBRD/wLDOwrlzxrPveM=;
        b=t1MQiaXZXydq39z7fk7lJmXQq1fjT427a39OH80dM3EUyNkPi4tNWTFJvFayE1BRt4
         yHghIulb1HGyTAiG/EgdQmcxR1CeRgJfKMoxYJqHJ3YidZNlTEXTuAHvUTa9vfCPox2K
         ZbKLPWrG1wi+/iSm/zYrB5iymzbThLU3z0ybcOxPKHiJHYMPGzrqOjZEXm/f6ih+OjfD
         kDlyxXF++uH0AoFmboE4y+OgXZIkEOyBfavWKw1/cErxvCsFucRtA9fXBZMO/KxcpGfp
         Hv7ZGpulThExJ4DNeE9UsQVED/S/FnRuuy1i/EvoX8d6mf0GplrlPLFgu/lIb93XAYCH
         EJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3fFn14BoyUMuF0143AFqk1g+zBRD/wLDOwrlzxrPveM=;
        b=mqLVYO+8dR9MUpTpe1oGkMQ6IlbgN4I9ba2w7HNj082D8W0tkMFaL11FhhwED7r7TD
         mtrAF5r6UQRv5+m1Tt4qxghLofTcGz87BmIKL3dbQifYYeXKfN5azdCHAOoCtvpdkzIm
         xYz03eEe/gOK01xBEFPGgPmeFNcYlzDz+bgAqEiW2g2RmCQ4wMbINGglYohStproVdVN
         boHTEu+AySM876CZ7he03+fY5qCDQFmf2zU27GqBnB9dPN1QoaBD2n9ZiliOJMvTPwND
         NnWeQDWVxRrVXVdca9xD5LvqXYCx1WZlx8tVFjtG6q10WUH9cA1LRSaowtZythg5mSua
         7VLQ==
X-Gm-Message-State: AOAM5319HcdSEkrzfZ8l/GRLqVCtdNGZrj7sr193DckDsvGncAkfBDUK
        zXtTCJTRIvHwxlfosW+ny/1jaCvDgTaNmYXq
X-Google-Smtp-Source: ABdhPJypeY9za/EZPQ6tN5pntnQrwlOqQ5EaiwsOVjCLB3hyWGI/NAt0fiVnM9QiBr6XdQAT/Vea2A==
X-Received: by 2002:a17:902:da8f:b0:13e:fcb9:2371 with SMTP id j15-20020a170902da8f00b0013efcb92371mr28103045plx.72.1634022489073;
        Tue, 12 Oct 2021 00:08:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c27sm10460971pgb.89.2021.10.12.00.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 00:08:08 -0700 (PDT)
Message-ID: <61653458.1c69fb81.41f5d.ca7d@mx.google.com>
Date:   Tue, 12 Oct 2021 00:08:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.286-19-gbf4acca6207f
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 5 regressions (v4.9.286-19-gbf4acca6207f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 5 regressions (v4.9.286-19-gbf4acca6=
207f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-19-gbf4acca6207f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-19-gbf4acca6207f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf4acca6207f2f12a7608d015f540d64eeaa1720 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6164fa305389456bed08fadb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6164fa305389456=
bed08fade
        new failure (last pass: v4.9.286-19-gdc8e8487f027)
        2 lines

    2021-10-12T02:59:40.687271  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-10-12T02:59:40.695986  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6164f65a1e8d9f7d3b08fac5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164f65a1e8d9f7d3b08f=
ac6
        failing since 332 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6164f6818a9dcd0e5808fae5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164f6818a9dcd0e5808f=
ae6
        failing since 332 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6164f66d8a9dcd0e5808fac2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164f66d8a9dcd0e5808f=
ac3
        failing since 332 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61652d7532e6349d8408fac2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gbf4acca6207f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61652d7532e6349d8408f=
ac3
        failing since 332 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

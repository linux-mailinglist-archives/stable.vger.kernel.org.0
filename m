Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24FA44C8EA
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhKJTZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhKJTZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 14:25:53 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC62C061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 11:23:05 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so2683834pjc.4
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 11:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vgkj2wr5sL4GX7xkOxfVJzdvUgbN0+zpvkhVgzE60R8=;
        b=STusoBpdndyjFVd8LcV+Decwxgpo/gvM+JOjpH5eozySRiy3ogOjTsGRg2J7lo3wvF
         44d2WQdBt0Rf9DrL9S8kybrp0UUM6bsyJ6vcckOc1efaulpZLf8r8xwBUOObSbDvNb09
         pAyXadmP1Ib1likB/Vqtp4euKocNflmSqkZMYr2MSPyMQN/bH5T/iFwE7SZ7ooN19gRZ
         OyOxmCp4p4TfIMETFeSG54h8CtbBlhb8CTyYlziSqfZODvVisSt2y2vsP3wo/2Ht36Rq
         vYKXsB9ZbreQbuCTIX/TbimDl2/LrQBDxJclwljfwInjW0Qca9zRgaVDdGyx4oiSoFLF
         8f/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vgkj2wr5sL4GX7xkOxfVJzdvUgbN0+zpvkhVgzE60R8=;
        b=N755Ja6ip96QCqCHePK8GzobDzdp2BgHiuir3cr0QjxHgyS83oSChlXzq3BCU3qzHP
         cdCiSF3WzRP5bPNblFe3OaMok52cV5AF+2lJqqv6Z8uQEnuakHB4OryshOgRsB4OMbBk
         QdYbw9U/zQbgtpvXZcXXhgeBP6RkiN7/0Rul9nCLfvwxf1M0y3iM448/Xlt8Rhq319Zw
         kJNylhnmEEex7JVSheWP5vmkcutbfvWLxIbwwVNJ4vHUgp3YBnS0MplBBZuWJ5PpI60A
         mUaht2THs7w1Xn8d3+mkbncW4lnqsU6T9yfP/vOVJcQSM6W+B1SCgQJ2xoBga0DeyE/p
         6vjw==
X-Gm-Message-State: AOAM5314fS/ty+71ewGWpp07osMli+FBAo8BAb5EEYSniyCq2TfOPBO5
        I+fz3oXBfK5e688fT1zCGZyBMc9G2FLhCiKtVfc=
X-Google-Smtp-Source: ABdhPJyfqxlypcDSlVYL0NlksSFyDfzcdm15LXgZLnzwET5/V1oR/kThNE6/MyZ/LsBz6xI6WCv7LA==
X-Received: by 2002:a17:903:185:b0:141:f5f3:dae with SMTP id z5-20020a170903018500b00141f5f30daemr1486500plg.56.1636572185138;
        Wed, 10 Nov 2021 11:23:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h36sm325496pgb.9.2021.11.10.11.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:23:04 -0800 (PST)
Message-ID: <618c1c18.1c69fb81.26654.1462@mx.google.com>
Date:   Wed, 10 Nov 2021 11:23:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-13-g00ac8f91bd56
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 3 regressions (v4.14.254-13-g00ac8f91bd56)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 3 regressions (v4.14.254-13-g00ac8=
f91bd56)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
fsl-ls2088a-rdb          | arm64  | lab-nxp       | gcc-10   | defconfig   =
                 | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-13-g00ac8f91bd56/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-13-g00ac8f91bd56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00ac8f91bd56f6fa78303eeb5bf2c8151d10d546 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
fsl-ls2088a-rdb          | arm64  | lab-nxp       | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/618be53359fcab02583358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-g00ac8f91bd56/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-g00ac8f91bd56/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618be53359fcab0258335=
8e2
        new failure (last pass: v4.14.254-13-gdd8f824c2f29) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618be24b9fd3615f793358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-g00ac8f91bd56/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-g00ac8f91bd56/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618be24b9fd3615f79335=
8f4
        new failure (last pass: v4.14.254-13-gdd8f824c2f29) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/618be66c0e2cb3bfa13358ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-g00ac8f91bd56/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-g00ac8f91bd56/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618be66c0e2cb3b=
fa13358f2
        failing since 0 day (last pass: v4.14.254-12-gd0fa8635586f, first f=
ail: v4.14.254-13-gf0ce35059c8b)
        2 lines

    2021-11-10T15:33:45.784286  [   20.112915] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-10T15:33:45.831577  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-11-10T15:33:45.841582  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

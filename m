Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7632DC7F
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 22:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhCDVqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 16:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241275AbhCDVqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 16:46:32 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D702C061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 13:45:52 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s7so9747881plg.5
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 13:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wy2M6SAPMmZSyTKZGodUOs4O5kayLQaPRlLL0P1CshI=;
        b=MBmYgwB2MmbsqrnV72gJuRP1mgvMhP5ynjMztRIRBy0/A6bZw5pR2jOGfawAjXdqrj
         MGXFggDDLNt9MPKQsxwr79Mbp6Rt/wKSWxaIM6pG+w1bPEOfyDwUYN7C0LbyjwNAyU+R
         bF/qflpuxRi0QaLg6Ga+vjV1B5tCMikiHGMyTcNurOVxr7TpcJ153m4NHqYXjsBod2rt
         3x4KGa5I4Pi0lVDekSin1mk56FGdRb7IS4Cf/AzYwD0uhCWMpaZRcxQF49L6oh/2OqrA
         RCZ/I+WAd2yjbjXzmGxEDFgWFwzjqyeGzJiSUU4TS/ePu0nTSQiSdAWj6gpvnY5isJDm
         wXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wy2M6SAPMmZSyTKZGodUOs4O5kayLQaPRlLL0P1CshI=;
        b=rCjtiCjESU7yc6lKcyvkcjGPeIQl6eLeeirC4+kGc1bECw72Shr7s/NUXMBdXvttpZ
         i0KTKh6SrZUee5xPPK676VdOpP8xzkCjIW8JmQIyoBCaAhp8TX3T9ftrm1LCKbWfhKzv
         YofaRRKtYzKWp3Ts7f5amBvNh5ItIaKXX7n4Y5CZwRAldMYlb/WeYjQI88ozPCIPAtF4
         Nq3ePQK5OGjnX90xwVId4sLrCfM6RiMqPzFG1eCyRa9eSu3eMRtZlPP8TKy4RTDTzjYK
         j2V3S6iUeLKUujAdl6SrdkkES/4qGwvhSvaA22h5XXBJZT/9rZuM/9t5BD6pdCgRaLem
         rqAg==
X-Gm-Message-State: AOAM533EilmyUIvvGv7RGWPw9khIZ8XsqwkR3vsVoYUcj6IiOXv10n9Q
        5b2LiAY+f4CWBjj0A+jaYpygHs/lJm9kNlHU
X-Google-Smtp-Source: ABdhPJyYYwAaAGIag3Ul19vHw25GFiyV9FQ0Xq0zXAQZVKArL5QA2/DZ+9pfzjcMig4tcFF+riDLxg==
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr6381104pjf.41.1614894351519;
        Thu, 04 Mar 2021 13:45:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm203547pju.34.2021.03.04.13.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 13:45:51 -0800 (PST)
Message-ID: <6041550f.1c69fb81.2ee95.0fde@mx.google.com>
Date:   Thu, 04 Mar 2021 13:45:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-18-gecabdc57e1e82
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 108 runs,
 5 regressions (v4.19.178-18-gecabdc57e1e82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 108 runs, 5 regressions (v4.19.178-18-gecabd=
c57e1e82)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.178-18-gecabdc57e1e82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-18-gecabdc57e1e82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecabdc57e1e8272ceb26765b95e0183d470e990e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041234a41bb09add5addcb7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6041234a41bb09a=
dd5addcbc
        new failure (last pass: v4.19.178-16-gdaaebef7f79c0)
        2 lines

    2021-03-04 18:13:25.329000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/99
    2021-03-04 18:13:25.338000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041470df2d5dc1e89addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041470df2d5dc1e89add=
cb9
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60412a1d740167ad89addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60412a1d740167ad89add=
cb7
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041212648756f0c97addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041212648756f0c97add=
cc8
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60412c33109894ee1fadddad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-18-gecabdc57e1e82/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60412c33109894ee1fadd=
dae
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20

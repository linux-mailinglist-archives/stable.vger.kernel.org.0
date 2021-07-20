Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C63CF526
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 09:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhGTGeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 02:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbhGTGd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 02:33:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15618C061767
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 00:14:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bt15so13165833pjb.2
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 00:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vvbnvAw6QLXL5rOsG1BsyRXfaIqz9RxH2037T0N50fE=;
        b=kBMXD6/41m5Xb4Nu8z0VZZVzcRLWKGsNSLQ1j/8bL7wG6yTDeZUcczdXz8XjoKGjva
         RWIUj47NSFdBFeiypU8WXheDtHM5RXhbzt9dmRwOm3itfYNMcSuaD5SevoPHJpGrP4vB
         kuol6Y1D2fGKPzDl0lnH0fGd38NWY4HhFkL6L9cdQC5TmC6t3dygjQeSbPWsl5FBbhln
         PQNLaKqK6A8pV1irr8Je3WO9XoKNZlnjyncb1CP1ASlJd+q8wBVcNHi6jKVJQxAHhxOZ
         Miih2mkpV4Stb3aJ0P+KcdKomWvTVVsZ8AA9eUB26xWXga+XlmiQxtY2YWBquK0rcPWf
         kJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vvbnvAw6QLXL5rOsG1BsyRXfaIqz9RxH2037T0N50fE=;
        b=gOyFP26qDLlJ8wbMtGTNFNSgx3S1xNdtdOaV4MlzCDoKgxDzrbEzu8jjjBjRZggj30
         Lw+MwnthAzKtYmYEfmKH859bRdn6NVUtyzSXbVZUjIclbTAjiqW00el9im2KD96YkMYN
         k4odbfyyoPF77HQk8nEcAiYcVoeSs1QZ0Vt+F4V3Y/Bgt6THw8prkdtNoEB1PVH4eXQM
         doK9q7YE3SeRs/jpHbXuTB78qomnhnQ0GkVbRkAFf/ENZD5I64aWBnfXjIbMJUz3cEPf
         VLY19OEoe29wjVF6dM2+jLDJ1b2Z+QvcBDThhTOlLw9fCh+eBMjc4r1dj3zP4h2qyiSc
         VYgA==
X-Gm-Message-State: AOAM533zsKOsnye9Daigp+6uilzfk0+uTvXdmFL6wqAEhHAucocTRZwE
        YlLou6wrS9Kd4/tJjc/2dRfOFjIl6vOmvQ==
X-Google-Smtp-Source: ABdhPJyl/Yqjutz56MRTZQt/49itPRLFp9UfJNPALLBEDfXHt4fRvn3a5Pq9VDw+OXkwVJXZDQhITQ==
X-Received: by 2002:a17:90a:f0d4:: with SMTP id fa20mr34814702pjb.22.1626765246433;
        Tue, 20 Jul 2021 00:14:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ca16sm18501397pjb.44.2021.07.20.00.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 00:14:06 -0700 (PDT)
Message-ID: <60f677be.1c69fb81.3532c.8609@mx.google.com>
Date:   Tue, 20 Jul 2021 00:14:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.18-289-g713b6ddbe96a8
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.12.y baseline: 191 runs,
 5 regressions (v5.12.18-289-g713b6ddbe96a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 191 runs, 5 regressions (v5.12.18-289-g713=
b6ddbe96a8)

Regressions Summary
-------------------

platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | omap2plus_defc=
onfig          | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =

imx8mp-evk              | arm64  | lab-nxp      | gcc-8    | defconfig     =
               | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.18-289-g713b6ddbe96a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.18-289-g713b6ddbe96a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      713b6ddbe96a80b93ca41029ce26e3a4530b840a =



Test Regressions
---------------- =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | omap2plus_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f642eee5b0ed10791160c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f642eee5b0ed1079116=
0c1
        new failure (last pass: v5.12.17) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f640956ff5da05ac11609b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f640956ff5da05ac116=
09c
        failing since 8 days (last pass: v5.12.15, first fail: v5.12.16) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f641e9fafaae18c71160f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f641e9fafaae18c7116=
0f2
        failing since 8 days (last pass: v5.12.16, first fail: v5.12.16-702=
-gd61ecea7819e8) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
imx8mp-evk              | arm64  | lab-nxp      | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60f64517d59969c66b1160bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f64518d59969c66b116=
0be
        new failure (last pass: v5.12.17) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60f644163ec06329d51160a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-289-g713b6ddbe96a8/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f644163ec06329d5116=
0a9
        new failure (last pass: v5.12.16-705-gfd3222df4dfe5) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71E2BABB5
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgKTOO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKTOO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 09:14:29 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE2CC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:14:29 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id m9so7401496pgb.4
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OTNA6Yd9xWnxNTUo3b0wCkxxllrT69h8RN3u2954SK4=;
        b=uP7DUf+R+QKVGE8f3la7l4eAiUA87slWI2+d14HaBufA7h1vOqvykusm2GAl00SM91
         hECyUv8P6iaUO1SpIwTUD6A11nu/7fIKK4iuA29QSAj8VIdXEuJvecsK8j6ZMg87zjFI
         LQtsMMaqU4qITctFa1QaTwRXJcaL1y8J/HPHNrpaBRsCNfvsVpL0+NKv0pik4zszxcuR
         6Q+cI3vvUv1OJmMQ94sLGVxFkEJYU1EE3cPkTt41JuDyn+Z5OYsiQ8UP27KJLQneuQxh
         K1t1GiFA278PTtlaQ/t9bhwiC9U/+/kLroGh7GIIhruSWmQUNWG5rMx4J3R06ArUgNEU
         croQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OTNA6Yd9xWnxNTUo3b0wCkxxllrT69h8RN3u2954SK4=;
        b=G+84TUZEzEfVqGUh9ofpFHmugJp4vuA6pmoYL2kQ1PlM1gNaUf4+jW2DlRv3zfY2N3
         PlMZrYkVCRcJXBKPoiC60crXNjeJ5J5fl1/AeLUxy061OzpEh8Tnlcu8U1JGZ+GsnwIN
         jtFA8bFVjnizx0I3s0AcxxBrIEa1kSkKxC7sMdszWlKvk5uwY3K79aoAF/DVuXa55nx0
         7AhL5Y7Ii0RhWRvg3rLNp1j8vDI6ouCkEU0nXjtl3L29PnU8OqBp3F724mcuiiELmo9x
         j9FVRdZVPM9a2KLvDtcp8h9/FNDPfvku+HIX2SZ/RUxZZ71rqElc5/VwIWSnNYuHKrQV
         zgXw==
X-Gm-Message-State: AOAM532tXU8o2tn7hqc8v+A/IwFDkrxo4bbyhNdU49cxtHJu7FYjOfmE
        1oSVReMIM9E31tqxk1Kk0P7dmaBuBh2VQQ==
X-Google-Smtp-Source: ABdhPJwnw1MC/QxELOcUdNbfm8D8PgoRq+ft/iwuwEA0AyfPMiJcWkmqMBqdB5e+KEEByrNoVAF5nw==
X-Received: by 2002:a17:90a:fa93:: with SMTP id cu19mr11103990pjb.117.1605881668565;
        Fri, 20 Nov 2020 06:14:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x24sm3233222pgh.17.2020.11.20.06.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 06:14:27 -0800 (PST)
Message-ID: <5fb7cf43.1c69fb81.6c650.5fea@mx.google.com>
Date:   Fri, 20 Nov 2020 06:14:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.207-13-g4a01d9703542
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 134 runs,
 4 regressions (v4.14.207-13-g4a01d9703542)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 134 runs, 4 regressions (v4.14.207-13-g4a01d=
9703542)

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

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.207-13-g4a01d9703542/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.207-13-g4a01d9703542
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a01d9703542516d4bd3661310ca487bdaddf950 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79b961bd12f41ead8d919

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb79b961bd12f4=
1ead8d91e
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79c09ed9d0afb28d8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79c09ed9d0afb28d8d=
92a
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79c1bdbdbab3fc3d8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79c1bdbdbab3fc3d8d=
914
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79bd44ee5f855f4d8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-13-g4a01d9703542/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79bd44ee5f855f4d8d=
91e
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =20

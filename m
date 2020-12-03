Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3557C2CCFD9
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 07:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgLCGwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 01:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgLCGwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 01:52:05 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1EFC061A4D
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 22:51:25 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id hk16so572177pjb.4
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 22:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MGVMjFKg1Y6TsxjirutAoXpGQqinZ2zL45Qq8dFkTbQ=;
        b=DUNDA9IzygYNus/02aBVvROkpkEZ5Qz/iunYw7WqUWPfOiKdWKaqJ3yfcb2ZC5rALq
         xYrax+D7Yhg1gQ/3II+tvaEYkDiPv+7TlYtxVQYhN48px2zGqJoPc9oZRvqwrLwWk+pF
         Ye11EioR+LTapQgClQvOhKOg3rieT7MvZ+Tkf1alXTPdsYM/J5B87mzGzJiZ5LNrCE5v
         zu4YUfTbqIESsxGZyzqZqy8soPu8/KUiFsUU2pILhpFWvJt2RBowt+dgpFuuddxzdHCO
         Mr0/tYFNPTYs4AWto7hwu0SgbmRFSYD3ds9Uj/CbGOSVG7XAudsmGSDK2QWWGmdfM5Y5
         yNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MGVMjFKg1Y6TsxjirutAoXpGQqinZ2zL45Qq8dFkTbQ=;
        b=nh/BqqVqOWTbGTkIopvv6NuzMselknIDq4oj3Ri1w36Q4CzuGvO+I6E4V08LCGLGkM
         1c9YUkR3iH7tgLDGEj2wCAsCFHU1z5tw0qRmf/DM4HE1WDqdrUQwVDMwUW6rHYKRK6fA
         xGeTaf372KpigOsjMQMppoDRB5+NgiNK/cGMyEyakQWLRh4ZQz/a9OiRA5/viRpsJUew
         KKfQiV+TCAeFdnavvk3juf0appfdRIYCgZgkhH4/5bKVk5bDs8Fw18SJ1CH2rTsR7QJB
         /4y1gkWq305cRBMJhwttGAo6reZyULIM2uy/wniYM6mAeisc7Fostg8N/tMLEYHPr2fk
         sd2Q==
X-Gm-Message-State: AOAM531AzXn9tmSkZkxVx5nj75ZTumg8itT1PP1McKdo9R6+YWVfUyRt
        LyzD0nc01r0njq0Vocq9CV2bZni6NaYf3w==
X-Google-Smtp-Source: ABdhPJyKLdZDG1YTv+3Lt9I6w6SaziD3htRkNPODzgWE0xaEEkSyPGTxW7lec7wbS2DNall2ovkLKA==
X-Received: by 2002:a17:90a:2d6:: with SMTP id d22mr1784888pjd.38.1606978284671;
        Wed, 02 Dec 2020 22:51:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y188sm561379pfy.98.2020.12.02.22.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 22:51:24 -0800 (PST)
Message-ID: <5fc88aec.1c69fb81.f0ec4.1381@mx.google.com>
Date:   Wed, 02 Dec 2020 22:51:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.210-7-g5c0c3ae0c166
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 129 runs,
 7 regressions (v4.14.210-7-g5c0c3ae0c166)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 129 runs, 7 regressions (v4.14.210-7-g5c0c3a=
e0c166)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =

qemu_i386-uefi       | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.210-7-g5c0c3ae0c166/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.210-7-g5c0c3ae0c166
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c0c3ae0c1666c705cd4ecef9fb48f35d623af11 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc855f3dc82d72d5dc94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc855f3dc82d72d5dc94=
cdd
        failing since 19 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc8566e2fb4588935c94d02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc8566e2fb4588935c94=
d03
        failing since 19 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc8560f0645cbf11cc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc8560f0645cbf11cc94=
cba
        failing since 19 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc858c638134c94dec94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc858c638134c94dec94=
cbb
        failing since 19 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc8570d416e83f398c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc8570d416e83f398c94=
cc8
        new failure (last pass: v4.14.210-7-gc5d4ef27476b9) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386-uefi       | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc856f61c938718c9c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc856f61c938718c9c94=
ce0
        new failure (last pass: v4.14.210-7-gc5d4ef27476b9) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc856c7b7532e9015c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c0c3ae0c166/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc856c7b7532e9015c94=
cce
        new failure (last pass: v4.14.210-7-gc5d4ef27476b9) =

 =20

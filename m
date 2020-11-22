Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2902BC600
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 15:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgKVOT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 09:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgKVOT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 09:19:26 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBF6C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:19:26 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t21so11784062pgl.3
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lVX1mCMTW6xa3+rFK5IIhPd6cqPxNV+5ATO7zuJwCms=;
        b=bhBwC6wsSTdzGvJBxGLtiZJJavrIqTl/jPsbh8BX2TB6joXS1j9JkHB/sfoXlqBl88
         Houxa2Lo1zQI45ErxVUl2/y8EaQeEoiGGLJWkTxzDLrTRRkq4HApGX+slvCQ6zIVK9DR
         imJIEJyDNBhiJ6TUhJDskOLm7XFQ1HZHT+JKU55iuWtdgQMBLGcPZrKAmGma7Ulj2HLj
         L7xzURudCKgqiQ6iPckh1z/BcM/x5Z9H37zWC67njf/pcBil7WSj/qYmLRQa/FDVbPwh
         C9xn3bgxAAdSvC1pxdunTwaCoSzPgyeGRRaoKdgyFaHL8WoepXEsF+ap1bhQCV7tfUr8
         5VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lVX1mCMTW6xa3+rFK5IIhPd6cqPxNV+5ATO7zuJwCms=;
        b=oU8ms9MsKWj2k56S4Jnn/fDY4DAifAhf4vczNJy7iGPM+KaaYY+ZJSTi7Is4czjP2e
         plfDSD/UtYGykaCWgRcOKcSgn/Jk7/RLKLPNiny7MrXtn/RUWBVXcC0zTPwC+CCVQ1di
         xAB7EhniWC7JHgA4VT6e3F/xOAhnil93W/sxeznmYPZwHSCXOHMScmo2nDiemWwr9tzf
         hpCDUciU/oV6Nr7h/DSHc1FhDoUYuvXyt0iOu/1wApiqWGgP9RJkR02IFBx0PinukCrg
         i5PRJBTyUKDX/5saXGwshPLKimd6J6z2ItMpAsub4F8I9i6TAnC4ineveJbD+UPUaTsf
         c54g==
X-Gm-Message-State: AOAM533QBQxic0Tobk96VdbmOFEenjosbjwEs4aV7/AqOairL42LHgP5
        pfPVTvsaOaJN7WsyRKF0fw4Fsz9oLszB8w==
X-Google-Smtp-Source: ABdhPJzBGEIiSBcDxAzCrfRcXMdjekl++adUyrjk4lW2+mEGU39l3e2Bbg7C5MkRIlA/t13IqF/PCA==
X-Received: by 2002:a17:90b:249:: with SMTP id fz9mr20144317pjb.233.1606054765333;
        Sun, 22 Nov 2020 06:19:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l20sm10307581pjq.33.2020.11.22.06.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 06:19:24 -0800 (PST)
Message-ID: <5fba736c.1c69fb81.ed2c5.5a09@mx.google.com>
Date:   Sun, 22 Nov 2020 06:19:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.244-16-gff6d0f3a0579f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 149 runs,
 9 regressions (v4.9.244-16-gff6d0f3a0579f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 149 runs, 9 regressions (v4.9.244-16-gff6d0f3=
a0579f)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

panda                 | arm   | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

rk3288-veyron-jaq     | arm   | lab-collabora   | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.244-16-gff6d0f3a0579f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.244-16-gff6d0f3a0579f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff6d0f3a0579fb4ce200df7c8c6caa61193dd7f2 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba400b7be28ce7dfd8d962

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba400b7be28ce7dfd8d=
963
        failing since 24 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
panda                 | arm   | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba407678bab77c94d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba407678bab77c94d8d=
90f
        new failure (last pass: v4.9.244-13-g7fb6fc1e8169) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3e4281cd108611d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3e4281cd108611d8d=
8fe
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3e4c81cd108611d8d90a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3e4c81cd108611d8d=
90b
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3edb9d8f2c5d66d8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3edb9d8f2c5d66d8d=
925
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3df57d1ac88654d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3df57d1ac88654d8d=
90f
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3e0bf113327356d8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3e0bf113327356d8d=
913
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
r8a7795-salvator-x    | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3efef09d02ffc0d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3efef09d02ffc0d8d=
908
        failing since 4 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
rk3288-veyron-jaq     | arm   | lab-collabora   | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba42e5a631137876d8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gff6d0f3a0579f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba42e5a631137876d8d=
92a
        new failure (last pass: v4.9.244-13-g7fb6fc1e8169) =

 =20

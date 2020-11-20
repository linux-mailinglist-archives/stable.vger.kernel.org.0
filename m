Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2A12BAFDB
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgKTQQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKTQQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:16:21 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1287EC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:16:21 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g7so8306927pfc.2
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MxeIOTl+AjSfsJQrkmTG0wIrqCpeCEbKrFGNqfbnaEc=;
        b=URvAf+60wpUr2zlA9yRAPYc1pJqvW7wICOMq5Z+NSI3Z7gNcDTZZmdwKRdRe9s/fRd
         Qev1jllmcHqse9gWTTJAjHj3fT+Ubbfcr/TDLaSvpILFf3DNuw9uw8oQbTZGce02zi9J
         ryHCD/IRGWDjoD0OaYx2rutaUtZM6bSEljzi0kte6lUNPPdfMocgSCqaAhTWGEUFMZWg
         LYe9ojuQdP0K6Aq0onitP1Cl/MlLLqDqwGkR9MfbfOmiVGxLlD9eiOHf/lxzA4cJ9WD5
         OsU4DuTulFYU2Z3o+dBrEZL5J3poo3RO52P62FcNxYje7cx6mdRpiwfrZ8USWe//FTgo
         EPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MxeIOTl+AjSfsJQrkmTG0wIrqCpeCEbKrFGNqfbnaEc=;
        b=IK2VXwxIPo25VFVQch1e22HnIZYgKZIIYUoz/A302tUFXZ/cC4tGTzFbI3swZLst4E
         QU9h+ZxI2hZo661AnD80a/qfzDR8CbNIzFTPwgtSAZavqQ9n0NUtBQyhwWnOQXrIeQGD
         HXKfXOunXjblkGq+852ODjzU5/lB5W2BbfMLQVs1gPXpY6XsJbyWPZ7iBREGRcQPo1DP
         zwBRn57ENVYjXBeJuup4WYZskpfsxVXLx9PuEiEhHUz4PWnqw2bD//R3ct8/kngoWGAB
         Tyi0NJS6iEOvc4QmBpduuKpdLuBDOnlRQgzC8jxQvct2fu2gHUIFkAt+jKEoSHXnQ3/z
         5eNg==
X-Gm-Message-State: AOAM531f1iWo8Fua3Ws4CzijbmwJU6zqyf2BmmcbN6VFKrqCpzOkeDiZ
        QrJFt9DwQ9kWJ44EYFzG0uHHyJiz9FA6sw==
X-Google-Smtp-Source: ABdhPJy9RkaDS6Xedh4S8UMuJRI18AUY32TYbZVprw3wyJSy7T8EjygVDrvG/+IdZwx9lrY4yivzkg==
X-Received: by 2002:a17:90a:9f8e:: with SMTP id o14mr9110833pjp.181.1605888979686;
        Fri, 20 Nov 2020 08:16:19 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d184sm3970478pfa.212.2020.11.20.08.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:16:18 -0800 (PST)
Message-ID: <5fb7ebd2.1c69fb81.665d0.74ef@mx.google.com>
Date:   Fri, 20 Nov 2020 08:16:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.244-16-gee3e628a6868
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 83 runs,
 5 regressions (v4.9.244-16-gee3e628a6868)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 83 runs, 5 regressions (v4.9.244-16-gee3e628a=
6868)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm   | lab-baylibre | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.244-16-gee3e628a6868/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.244-16-gee3e628a6868
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee3e628a68684e7b4024a86a3a45b55f1b48a78d =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b82c976ca93a24d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b82c976ca93a24d8d=
905
        failing since 22 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
panda                 | arm   | lab-baylibre | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7ba938207a6ff79d8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7ba938207a6ff79d8d=
919
        new failure (last pass: v4.9.244-13-g7fb6fc1e8169) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b6d1487df2f5f6d8d902

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b6d1487df2f5f6d8d=
903
        failing since 6 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b6dc20b652af6fd8d90d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b6dc20b652af6fd8d=
90e
        failing since 6 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
r8a7795-salvator-x    | arm64 | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b6b759ea8fdad2d8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
6-gee3e628a6868/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b6b759ea8fdad2d8d=
90d
        failing since 2 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =20

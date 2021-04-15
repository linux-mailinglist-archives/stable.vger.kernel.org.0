Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD03613B5
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbhDOUwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 16:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhDOUwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 16:52:40 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABD1C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 13:52:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u7so10962788plr.6
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 13:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LUovOHH1f+R6QXjsKT8SSlpsmja1AlpCYwZwtEh3Q5E=;
        b=WKNFivbD0gt2a+xJvVTSkB6QE0e6ycabLR4JbEflbqBYrEHsfe/zOZIOlu5E/7uHXJ
         lJPLHYJH+7knUK66D2gRBMtZGSv0hRgjIBkF8QOt9lJ6FZ4o9iv1xjbkxJbdKHsv0B78
         MWV/czVF77rBgdPL+hqPJlslDX2sYmdzKrImmxWqz405Wxztzzbcc36tMg93OoCIOLZK
         hgRi8Xsit3pYSYh7gD99ra7Rvp8G1ptcxhe8sjwOjBmxN0z0V4s935w4Do2ldFvXRK01
         AlJHyNfFjrjB/TMZuoRvCoqU8iQaQc7ncOP3yFV3ShLZj8yuWQxPmD4/fzT0S4tVgx/F
         /KOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LUovOHH1f+R6QXjsKT8SSlpsmja1AlpCYwZwtEh3Q5E=;
        b=pxx26ALs47EjlXMi/DVArEk8TKioj3Ui14EDtjiMk7ZYdEarYNLq0wXX35gktDpFoV
         6intB6h+Rx0d19bYGxFJrSarYsNGwioHvbU7ntgG8rCuzSy8AYnzUP+7FtB8KM+aC8M/
         X/RMFJlCmeuK2h+yiRPK87mw1jIvJe/5nLP2HXoCeBaFUi4PUJAMvVr4+zfJ6sODmssS
         EDn5YF+igIpVgjzSwzWbewMtDg4w0kkJ0TWs9RBhOe2T7YeLRkx/FFJW8XXFH0uIKRHc
         NSOnui+x3H8V0bfZxXvPJpGKdH2U78gi8bQTMZIfFfElCz3dh2WrNdVfnhabFv1UnRSP
         RlmQ==
X-Gm-Message-State: AOAM530oZjMbgeZ0KEg4bGNl65Ox3Jz+RSKp8Z2lCNxsm+a0f5Dbr7YB
        bK4q5ffxpCJislmIO3rENiKzsMFoaW/5diTx
X-Google-Smtp-Source: ABdhPJxsAjfeOo1KSDhOEYI2o4AhHYPhSJZYhEW4QCDM51zTYmwesQVwM7WBICL7oxIgQJRwKZDL+w==
X-Received: by 2002:a17:902:5608:b029:e7:32fd:ce99 with SMTP id h8-20020a1709025608b02900e732fdce99mr5838985pli.0.1618519935950;
        Thu, 15 Apr 2021 13:52:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm2898051pfl.121.2021.04.15.13.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 13:52:15 -0700 (PDT)
Message-ID: <6078a77f.1c69fb81.1db41.8544@mx.google.com>
Date:   Thu, 15 Apr 2021 13:52:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-68-ga3ce9b6cb3002
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 116 runs,
 4 regressions (v4.14.230-68-ga3ce9b6cb3002)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 116 runs, 4 regressions (v4.14.230-68-ga3ce9=
b6cb3002)

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
nel/v4.14.230-68-ga3ce9b6cb3002/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-68-ga3ce9b6cb3002
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3ce9b6cb300294883b75487f24c6f6dc0af53c2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60786f311c5b6267d1dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60786f311c5b6267d1dac=
6b5
        failing since 152 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60786f3092fda5fc74dac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60786f3192fda5fc74dac=
6bc
        failing since 152 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60786f235f6076b4b8dac6ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60786f235f6076b4b8dac=
6ed
        failing since 152 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60786ece3457133ec1dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-ga3ce9b6cb3002/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60786ece3457133ec1dac=
6bb
        failing since 152 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20

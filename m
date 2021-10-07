Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D94425712
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 17:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhJGPyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 11:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhJGPyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 11:54:04 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7D3C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 08:52:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso6740232pjb.4
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 08:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/4j9dGcB+M8Z0Y3XKi4ovXJVoi+h+4/Uu8I6KYS/pQc=;
        b=llPwiTi3qo71/ffMYEWDzSB6BYDn5idIHLkALhhKRuZzyWf3cUaRlAGvwXTZekRLQS
         alt+pzxl/I7A98z/R5CFEpca5MqalLeRpwdj+sEUpY6oW4l0xXtnzyt37+Rlahb9eWpH
         L+J6nuFxEp2GPz/voA0WNP/4wrOKVDw4iQVHe7w9KLvqNuM0H9WzL4UjIip+AbUC3S/7
         aBIURO1QCeASKlOtaVcvzYoYRnR9wJGktbcDC5/hpxPNCHS9KCZM3bV7h+sliyDCm6Av
         4gCHf4kgFTayCNU9bxzaWDcB616euaq+PtsIJs3QyCVwWDYRNx0inveBtKcLhz0L0kBG
         3wgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/4j9dGcB+M8Z0Y3XKi4ovXJVoi+h+4/Uu8I6KYS/pQc=;
        b=NfEL/xpoaJm98h8V0MsLekyKi0slhS3MwGCothHkn/HQq+FbV9fmP5UUjQelnnwyUE
         MHtWUgduwy051j2beQ+A8eaMrIMXFA8mP1CNb6ODl/Oo8sGrc07lO1eq2xdlj2pAk41K
         fw+lSlGsLR0CJxWTcgAjrYiOQtktO4z2ddxHCMnjyP9XlQJFCfHKPfB+wq1d2egonjOM
         P2gpJ1ahadKePjG4ycMMnqQSgyy1wZ6L/o1onCbcReOCmQJYSySCSLjiJregG0u3EVIT
         zsYsk/qpMla7AA6JF7kiTlwqGVOxFmIgeywEZTH5Iovb7lTPtXD4H+hhhzaSzheDjzh/
         VcaA==
X-Gm-Message-State: AOAM532HYAuMlWC8zeXEW3AkLrw++xMhBqKmM4W+WsNwYvtx3+QLtZ9z
        fm071kG6lN//vslfXzsUUNTLy6ebO5z5zYT/
X-Google-Smtp-Source: ABdhPJw72N0NriDzWLbzCDAvlWmqrhze7Xo54xP9T3GyN26tzAmulcWvR/fT6jrz8j7VAGTiB3Qgbw==
X-Received: by 2002:a17:902:9882:b0:13e:1749:daae with SMTP id s2-20020a170902988200b0013e1749daaemr4604576plp.60.1633621929849;
        Thu, 07 Oct 2021 08:52:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z23sm25173286pgv.45.2021.10.07.08.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:52:09 -0700 (PDT)
Message-ID: <615f17a9.1c69fb81.58063.d552@mx.google.com>
Date:   Thu, 07 Oct 2021 08:52:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.209
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 123 runs, 4 regressions (v4.19.209)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 123 runs, 4 regressions (v4.19.209)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.209/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.209
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6db10b4d5efdc38ff06dfdde28dc5477f754b0bd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee1b76549634ac799a2ed

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615ee1b86549634=
ac799a2f4
        new failure (last pass: v4.19.208-96-g88f9c3c825ad)
        2 lines

    2021-10-07T12:01:48.224492  <8>[   22.762695] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-07T12:01:48.274851  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-10-07T12:01:48.283655  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cf4 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee183b3c380cd5d99a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ee183b3c380cd5d99a=
2f9
        failing since 323 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee1abb4a9d394f499a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ee1abb4a9d394f499a=
2e7
        failing since 323 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ef84afbb92d7f4199a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ef84afbb92d7f4199a=
303
        failing since 323 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20

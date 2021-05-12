Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0466537ED9E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387851AbhELUkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359866AbhELT1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:27:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200F5C06138C
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:20:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b21so12249323pft.10
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JjWFWZ8SDZLiUNNW/rUB3PDqhea64A9SvMpyzaN6KC0=;
        b=yAddQC01bLcRo2O9GUJwptQ9WAg3pgQTo9eSw3Cv7x+3qfOdwITqH0fczpEjEOfNgM
         WhZT1YXoWc6fZjbkitJAvwrAse1ZRuXCWT8fUxgbPUPF4QjlAH2AL2O1/cIRls0+Gp9u
         9gLsOp3sLO4Ogwl4avOFRYuritOYJMXj5rFsLi5XPKO0jjd5VSSHfDhZ3tll49FPyoOw
         tnlkS5mhiHYifjzsquspzKEeLurY/TUwD54ZmjiPDf1PW+U0sjipZiFuxPUIp40ga6P+
         Q8XQlQEMhRN65qSJjzpRkizEH/K5eCd23Nvg56wG92Q+rmgHU1/UILQoDWgKBYOBmMSw
         maSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JjWFWZ8SDZLiUNNW/rUB3PDqhea64A9SvMpyzaN6KC0=;
        b=MBb76TX7MnmcrHWMzTg2qhEOaAi84ifAYymZKqST10QMJ4xqAWd4I/SNx0cq+EMisN
         VB2aLPmHsxRmaP2q85lTGykLpeAr5+V9p+VvxGhV6M7kz4ywe8pp/UAp6thHJ1s6Uvac
         fVxJ8G7SrI7uebKY9xp479x9mHqnhRCVbJ33f+3qATmVWuWV7b27uly0+oegpZrDUh+t
         ivkbrR6VSeoPHriz6J+SFC5XGD8vuuaHQE2lokgw1/OSLO6clAkUAH9GPQVPMzcQV8Kf
         Fxi7Ok9HQUrmKVcjx1mcZ/Dqcx9HYJ2UBJeVJrZhFPN0vi2OE3yJS+HBj4Jq3SsOMQSz
         ic9A==
X-Gm-Message-State: AOAM531nlFX8/CDMNWGdFbfGKstt1NCBDT1hxiexWI5oN/YV+8DzNIGi
        q56RFaSqxZnRLwFO7UK0+QdWrldekUrh2TNn
X-Google-Smtp-Source: ABdhPJwZct6fxSz6CxKWp9+KPo9/Lt7VDTKFVPiOb9pvvnIJWIM6a5mdIX+wzJ+zrmPjY+NQsiLCyg==
X-Received: by 2002:a17:90a:8c97:: with SMTP id b23mr40415065pjo.74.1620847241544;
        Wed, 12 May 2021 12:20:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n25sm494941pfo.92.2021.05.12.12.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 12:20:41 -0700 (PDT)
Message-ID: <609c2a89.1c69fb81.877e0.2304@mx.google.com>
Date:   Wed, 12 May 2021 12:20:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.268-170-g2e49751b51f5d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 107 runs,
 4 regressions (v4.9.268-170-g2e49751b51f5d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 107 runs, 4 regressions (v4.9.268-170-g2e4975=
1b51f5d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-170-g2e49751b51f5d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-170-g2e49751b51f5d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e49751b51f5d2f7ad0f0c8c7ab56b983ec2471a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bf35a71ad0cf54a19928e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bf35a71ad0cf54a199=
28f
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bf35c44042cc16419928e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bf35c44042cc164199=
28f
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bf34444042cc164199285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bf34444042cc164199=
286
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bf3145c81a04cae199289

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
70-g2e49751b51f5d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bf3145c81a04cae199=
28a
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

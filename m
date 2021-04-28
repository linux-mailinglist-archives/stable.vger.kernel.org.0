Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC836DB33
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 17:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhD1PIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhD1PIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 11:08:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8213EC061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:07:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lp8so2904017pjb.1
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XpuLR2wzxz6kbMjqDdkIVqIgGhR+TtjCFsaK3VRNlHw=;
        b=sjmdWuxtdIB4AdWN66q0sjAvUyBKf4Rm2rTFc2/jhYcUMdncFsOhXk2+uasjgb2R8r
         +AKyELl5eanormAICPCEwSCAA1HiyZCnohM1zdGC7mednfcs6uA+49l8NiSS7VOmWUCT
         OgBG+pW2lkXFr/OE4yc6wSqYTfxUrZUroSn6OhkDfOLMnRs3fSFSYKl6WqhhIdKWrT5u
         p7Z1DbLDgQK+E+c8UyHVemeq8M/LXBQ+5SxRqQu8C81Ieltra6Nj95xRXaofOeFjVZrR
         2qdrnmpeJNhW1vEG086sjK5duMn81jfXkGT6Xzt27w9niRDqiDTmRItK0quldd/7RRip
         rLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XpuLR2wzxz6kbMjqDdkIVqIgGhR+TtjCFsaK3VRNlHw=;
        b=FKIBrdh1WPpEu4hRhfqmvgqCilzHiq52klEm1I+8qJEJ4O2N9uHxVUTpI/etqNTex8
         I8yocj8Lw43YxVBl3L/RoJHKrjaO6lOkwAYh452ztlj7wdalodWnJZqpt0gk8GvsfuZi
         QYVCs8zL7jznQcEC4Xa8xsFIMdTdjO+L2T2e+HHflMlglZoCizXKZwN35nw2dQIo9YOc
         Iy/MTulMHU+Mu2NBN4oO8fiKcxzpE0dvWXDWX5kYw0PsiY5trbUg/L+yBs67rBxdBxoW
         bd8XOUYv7MkDRS9c5v8mEA3lm9x7m03CsCAhBcWHfdpwsheJYz5lCSb5UTrHWByDScaN
         oAvw==
X-Gm-Message-State: AOAM533LVnHhvQ7qW9a11aHXqZZLOVTH2N1xC9zCoF7PMJ6G9PouVOEY
        S6AcuiQeDFCuAvHPQhLipYVEFQB3lFivkvXb
X-Google-Smtp-Source: ABdhPJxtEPDMOTiyZYmSThtpcH4J4FCTz6XI2MfDAQGNGV6flab2SUwsQikqh/d4IDIklFrbyYjaTw==
X-Received: by 2002:a17:902:9347:b029:e8:c21c:f951 with SMTP id g7-20020a1709029347b02900e8c21cf951mr30300616plp.14.1619622440908;
        Wed, 28 Apr 2021 08:07:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1sm5104555pjs.12.2021.04.28.08.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:07:20 -0700 (PDT)
Message-ID: <60897a28.1c69fb81.1b36c.f136@mx.google.com>
Date:   Wed, 28 Apr 2021 08:07:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-38-g530d28a9e0e9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 85 runs,
 3 regressions (v4.9.267-38-g530d28a9e0e9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 85 runs, 3 regressions (v4.9.267-38-g530d28a9=
e0e9)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.267-38-g530d28a9e0e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-38-g530d28a9e0e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      530d28a9e0e96c26ae88f60cd97f9ff243504730 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6089461a97bb906e559b77a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g530d28a9e0e9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g530d28a9e0e9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089461a97bb906e559b7=
7a4
        failing since 165 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6089460d35e48433de9b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g530d28a9e0e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g530d28a9e0e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089460d35e48433de9b7=
796
        failing since 165 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6089460d6b6eacbecf9b77a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g530d28a9e0e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g530d28a9e0e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089460d6b6eacbecf9b7=
7a9
        failing since 165 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

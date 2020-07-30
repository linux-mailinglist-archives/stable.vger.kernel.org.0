Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A03E2336ED
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgG3QgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG3QgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:36:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE8FC061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 09:36:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e22so5023973pjt.3
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 09:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vffzy1xITSVCdwW6M1vZMJeRISYjXVDMDBEO0Uk/8GY=;
        b=SRnbktZpmKy5JoC+4iCU7nFG58sRt3A2KzgGll/UpNsPiLut23qUWTjxv6FQrv3REH
         icwk9dt6BD8rRHZJOudh2n38eUx/U2FEjtNcebfRZxYDgU+HN9eNOgAs/lCpZRM7dnq0
         X+MB8J3uo/bmDsl02eA06axGaNv/eAc9rZv9bTHy4c02QbIWASmL4WmEnMS9cMsWTlWz
         7BPqm+dm+M1+Hh4BXEVRf2iIjlZxQS97BowZeEX5RWyoFyHCulLdsFyhZWsIEX/7fQ+V
         QDa92a5UOAXYKgbfvnkjaB+JE55nSQeAjc1M7yTHaxG76Iz/yKnJEh2Dnz66A1o2h2NW
         kZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vffzy1xITSVCdwW6M1vZMJeRISYjXVDMDBEO0Uk/8GY=;
        b=Sj28+8XK550ODlf18MwUaJrYNlbrn5RxwzDZNUtqk7iybmS9mIOM7UElCOJA40BAz3
         1TlXHjd+x0XgexYjLoYjhmeyiTIvBb249eQHjjcOioJrT19dawvBYIhVm7v/ePABFQHM
         kyaslt4oxybazSLPQBrc/bY24Y4RbK/eLqAxNRydKJbmObqhp+zRNM78JKsTLtvE58k0
         jWrXZlSYoq70oN9kJMhUO+IlDNBC6IcOm/61W3/VXT0AWWQvlIi1M/yZYZQZeCg+Hwr5
         R9gy/7jnd9MiVSHUYiH2dsmVRqqVBzY/UCdCNEMH22sPjCEkTMNlfHgt0LMM7ixgu97h
         CqUA==
X-Gm-Message-State: AOAM530HtDFHI0MGEYDtB6FkyyWGqbczwq0/Z4SzIiBjtlWmilQGxegE
        gDQqyTNCj3eyc+4jXh+wGX0Rn2wYhsE=
X-Google-Smtp-Source: ABdhPJyCos4UuIefQgyhB6tElWcdXTaefLYMxAbUDjz0DDV0tXN5J3/fqorJRjtaFSMNq0AvyGV3Hw==
X-Received: by 2002:a63:4b1d:: with SMTP id y29mr36146345pga.264.1596126979975;
        Thu, 30 Jul 2020 09:36:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v28sm6852607pgc.44.2020.07.30.09.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 09:36:19 -0700 (PDT)
Message-ID: <5f22f703.1c69fb81.c6cc8.25e7@mx.google.com>
Date:   Thu, 30 Jul 2020 09:36:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.189-80-gf743b8ea46fb
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 162 runs,
 2 regressions (v4.14.189-80-gf743b8ea46fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 162 runs, 2 regressions (v4.14.189-80-gf74=
3b8ea46fb)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 0/1    =

omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.189-80-gf743b8ea46fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.189-80-gf743b8ea46fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f743b8ea46fbaa440f9ccf7a4da9fa4a874941b0 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f22c689a2999753e652c1c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-80-gf743b8ea46fb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-80-gf743b8ea46fb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f22c689a2999753e652c=
1c7
      failing since 6 days (last pass: v4.14.188-126-g5b1e982af0f8, first f=
ail: v4.14.189) =



platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f22c6743524bd5abf52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-80-gf743b8ea46fb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-oma=
p3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-80-gf743b8ea46fb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-oma=
p3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f22c6743524bd5abf52c=
1a7
      new failure (last pass: v4.14.189-65-gf238f865e754) =20

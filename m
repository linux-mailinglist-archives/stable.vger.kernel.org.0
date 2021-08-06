Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7733E2EAD
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhHFQ65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 12:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbhHFQ64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 12:58:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C93C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 09:58:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u16so7910997ple.2
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hQUiSnMv0GlbDgN6xGSZL/ztPx7Z159j3TOswWAf6Mc=;
        b=fGq5OUCwWIGfXfY4M6WKpKUvIoM2NS5PTql5wCs4cblT5+wlvi657Dv4ijmnRcFKyk
         I5vgG4SsfnMYPQip9VsBJQ5rkI+TInfOVf7aUbvZkiHYqAFnH/2JzxmGIkK1OfBm/Kn0
         rzc5HkDGvthXoREHrjV1NYfBOqy0kCpMyuSMshwE26OSl8CHzK2JTYCUXTkd4Pu/ftFy
         JX7AfKRSqxYubJyQeH4l6h5KWFpBjUUlC7xoF+dl2hfj5DZnmYvuWetCQpc9Y6oV6/o+
         xtW+S1oAwG0RTbTtP94JqGLq1ihJtRNgHer0enc1OU6d6M/CbBWcJudLiDNYOWL0HuCg
         HI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hQUiSnMv0GlbDgN6xGSZL/ztPx7Z159j3TOswWAf6Mc=;
        b=hXvXVw9laA1izRkG8Q7qMjlnbRKh0EziIh2oDTWmwxT/KnGyaz0Fq9Ln79FI6nMLMa
         aCjnfx3cEEZ2bhpFb6KqaIPLR0Ggt/J038l5R0k1ii87elgnMHsxKD8veNJZM9qNvRae
         qNyUovt8wfvQUg1/K/I4shMJIO63VOLdbDj6KWDirEKuhn2A3zHvm/x16YAJkq9H91qq
         nHRBWYEiQtDv3hksEdPB176iDStNppkKYdPY1mi7OpB56XBUayTAU5ytqBGup98A5Ds3
         1wHTqgwu/PWu7BiUWISJHBLgl2ehE8X/H0pUSlCD9Dj/vNOKyXEevcQctK84vPJLJZlE
         pjSg==
X-Gm-Message-State: AOAM531fsU2M8zLuRPF2Pjq/mgM6kIvqukXf9RzylVzoDtgsJnrv1/8M
        bB3Kw8kys3WlpYiO48WLBxtyUYnoR1yvZw==
X-Google-Smtp-Source: ABdhPJzIv5+FZUpUwtcuj6R1OgY7Y0+EQhpFQ+EjPnC3lsnuph9f9ZKgdZOI/zJD2OLaOA77pwc4nw==
X-Received: by 2002:a17:903:181:b029:12c:e578:5a4e with SMTP id z1-20020a1709030181b029012ce5785a4emr7509606plg.12.1628269120114;
        Fri, 06 Aug 2021 09:58:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm11115652pfu.109.2021.08.06.09.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 09:58:39 -0700 (PDT)
Message-ID: <610d6a3f.1c69fb81.bc93f.0f34@mx.google.com>
Date:   Fri, 06 Aug 2021 09:58:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.138-24-ge6d9a103071f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 115 runs,
 3 regressions (v5.4.138-24-ge6d9a103071f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 115 runs, 3 regressions (v5.4.138-24-ge6d9a=
103071f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.138-24-ge6d9a103071f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.138-24-ge6d9a103071f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6d9a103071fd29a034b969983747f48d429ce9b =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/610d2e004e24c3dffdb1367e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.138=
-24-ge6d9a103071f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.138=
-24-ge6d9a103071f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d2e004e24c3dffdb13=
67f
        failing since 259 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610d32df3ef45ff86cb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.138=
-24-ge6d9a103071f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.138=
-24-ge6d9a103071f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d32df3ef45ff86cb13=
662
        failing since 264 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610d300d9f0158745ab1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.138=
-24-ge6d9a103071f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.138=
-24-ge6d9a103071f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d300d9f0158745ab13=
66c
        failing since 264 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20

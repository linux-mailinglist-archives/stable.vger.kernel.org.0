Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69EC3E3CB4
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhHHUZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 16:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHUZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 16:25:13 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A6C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 13:24:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a20so14234915plm.0
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 13:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=06ZxvSmkXwT0OjzUhb+uVy+UHivtwmULmOod78WMWEM=;
        b=RktZ7AoyYKA/GmhPxTgREVBbRob/AshpqLsrv/YnPV6LrrENbeJDwCqQE2cnnXLnlh
         cXhawtV/mmFo+T9fKiVYUsf4ahnut04z8ScGh6mK06TfmROA+FdT5CVP1qVWxJlMG+mN
         8Pn+tsFjGGVJw+3MkSkLyR8/Siw2T44nJlSLNiPfcGghrpPGWutgjQniIHOmlkXJBKbP
         kJsdGlWLJlzKaFvS1aZhi3UmsG/zdQMWgqY4bucB5U8aloyc5yWZD30JhwXqocs9biCl
         /jTPHez0RsoYNsa7yN/gthfdQAaFeNQBZcfkgHJ23cL6wNTsI3sIQvxLOyd/3YR/FoG2
         je8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=06ZxvSmkXwT0OjzUhb+uVy+UHivtwmULmOod78WMWEM=;
        b=Ft0H1I2MYDl9xLthXw3Tjxxsap7VYF0YaVgTMRhSeVx6oZ+qGDNfA7t7V0j9A40r9X
         JgwQ0i+70yzMy2nKLBOSspPs7/TQQfIuFnB9ncYCDBRmfVILVc/jTWUOvFAysQq9dgmR
         P1cvONU/zzvVDETnSXTz4UfuzIYw7wysnmiwNOhy2B5aMT+NYPY2HPC1hAb7Lfe/GW5M
         XGw5c6cOxkCkWVLvsp1xwahuqdzZynF6fPLuxG8b2GWGKygizaA1WspkF7FsL50MnBWD
         o+4iP298YeiMCqAQpwUvUHf+jtGuqgNZjZf9GY0VXJ+o7C7tchD9dUvRJDL7oph589Jl
         imug==
X-Gm-Message-State: AOAM530yuI9RWSKw8wEA8jQim0nFbYfWd2PmT5KgfYk3KItyi5peMEMM
        j1iuBRsPJDyqdzaTsi+h+iQcFWQ3YuE30rGW
X-Google-Smtp-Source: ABdhPJyDWmkxEvKI6fq1OYghZeSBQSyLiFw6r+2qr3Hjz4pLkrnKogenr3mpMALWTmai/tzNrplC5g==
X-Received: by 2002:a63:4710:: with SMTP id u16mr284543pga.232.1628454292197;
        Sun, 08 Aug 2021 13:24:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l126sm20187294pgl.14.2021.08.08.13.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 13:24:51 -0700 (PDT)
Message-ID: <61103d93.1c69fb81.aa818.ba7e@mx.google.com>
Date:   Sun, 08 Aug 2021 13:24:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 74 runs, 2 regressions (v4.19.202)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 74 runs, 2 regressions (v4.19.202)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.202/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.202
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c66974a63046780925e5d99b6dc6631fe2f9a31 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61100d9d55659e4dbcb1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61100d9d55659e4dbcb13=
670
        failing since 263 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611006567b41360ee1b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611006567b41360ee1b13=
66f
        failing since 263 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20

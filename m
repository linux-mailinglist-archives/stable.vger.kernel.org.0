Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C231A22D847
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 16:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgGYO41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 10:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgGYO40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 10:56:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8346AC08C5C0
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 07:56:26 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s189so6975168pgc.13
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 07:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WUhX2D7rvs61vLBjO2Fj8NNhuAZeUXM8PT2uKglEvgg=;
        b=QgaiTcw40sRtdfO8h//Puj6uYkgWmmasdk7+auYH57PfskozlZVmvyeycgBzsmOcOv
         KB6eAncIClkdTwVLq0EW3t4ff5AtyLWmWVkXrDSfA5OozbqEt68pjX8BBM0J5FuZ6yKa
         rhTza5l9TjZ1vo69jl8uTb6bylifKseYCJ/+K662gvxv3JYkdBK28Va1jFIrEaA+0fLu
         yG1kz2r+obCqCssmyyEinGNSiUTXlw1X6RK4TifYvkNemjVWIEKG4S0E3XcOyLAtw5YC
         TJFh8Kf7pld0VNUgy4d0Bh7dReT7u0ljCMAoyrH4wyZY/rLCPXhl7MuOuAqV4+5UDxJm
         WTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WUhX2D7rvs61vLBjO2Fj8NNhuAZeUXM8PT2uKglEvgg=;
        b=gn5zZ7C5azQFi8QJgYj1D0uYyXqi0MT4AfRgAGAVydjdhHubVLQ2BAgUYaZoVTC4Q6
         WClXkGODY4ppiqa8K6y2jirzlcZyqoKGbyA5rbqObgLZsDFkGM9DWwINeTaLhp/vAQZu
         5Y3RqCcWn6PD5PKN4mD9JLz9pQsIKECRoHwktOhtyJYvI+l7D2qPgUIAZG1yjSXIgpI5
         2g6MoZ8oIERUuuhptHPTHg/rAJHXRQVstJwU52OFEblQudt+V704K+xDZA4yvJSRHKTf
         Ly/VDNF9VgzCFg3+2xfiyNtT5mC8E5JqCoH8ciRuo+RO4Na8WYltPVnhI5ogyl9ZP4rg
         +mNA==
X-Gm-Message-State: AOAM533vGa7aGv6jfZjDNqparzlGHo915rJap6kzEyx3/XpfmJSXmThH
        g52+miX8c9nileqN/LawndJIDWcW3Ic=
X-Google-Smtp-Source: ABdhPJxpbkHs+EDiuE2Hht4cDmAPUwUPYSFMYlFSFmSM5aECHyPa7drFBiqbCENZhIVA1bvuwwiRCQ==
X-Received: by 2002:a65:6246:: with SMTP id q6mr12712555pgv.133.1595688985630;
        Sat, 25 Jul 2020 07:56:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm9675177pjl.7.2020.07.25.07.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 07:56:24 -0700 (PDT)
Message-ID: <5f1c4818.1c69fb81.c82a8.e8d4@mx.google.com>
Date:   Sat, 25 Jul 2020 07:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.134
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 170 runs, 2 regressions (v4.19.134)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 170 runs, 2 regressions (v4.19.134)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 0/1    =

omap4-panda           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.134/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.134
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20b3a3dfdf6c55b50bbdc8e231a3dbf6bf965dc7 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1adf015329cfd0a485bb1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1adf015329cfd0a485b=
b20
      failing since 38 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
omap4-panda           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1ad8554f503f7b2d85bb1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap4-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap4-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1ad8554f503f7b2d85b=
b20
      new failure (last pass: v4.19.133-134-g9d319b54cc24) =20

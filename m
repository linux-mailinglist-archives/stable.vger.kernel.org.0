Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7290A403F38
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhIHSuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 14:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbhIHSuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 14:50:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507F2C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 11:49:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w6so1500200pll.3
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 11:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y7mGTdLKCrZnIt++B9RytoJDuvcKKMVUgkE36j2kn9E=;
        b=gyNSnnpM03DgIJby/0qtVNedKBYpZhtKljPBgEoB7u1mLROInd96HuNcfv2vPRQXKR
         1mU9UYRKz578P2lzx7Pr0u1jx5PRGw+qJibNGWAJh4ct64k75CEv9Qwtmi1cj22PuelU
         gO4L/QazDQelrPNugpNqcdeOnM4rZENHu2ZyHysptpQjZfQ3iAgfj2z+cfks2SqSkpmu
         cks4z+EivjieZRQKYVF2f35z0oo8rIQA3zmlDRo2ibP9/KCWoufGDTfZBMM+3aGxLzgX
         v0dUNxmubEQyKDwr3Y5s+xj5LEKfYTk9eNY1MEIHdUre0avrA+HVC+Vp7sd/uZXOYG4f
         3/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y7mGTdLKCrZnIt++B9RytoJDuvcKKMVUgkE36j2kn9E=;
        b=IyGHvFy7u2nZEYvrD4kNuOb/Eg9AVcRY/vALgWwU7GeVnWyiltbySO+FLGvBsUF32k
         JJLyJRS76esc+AHzskP7E2xX6f0mbOV7UKtKvfwAqSWG5CWepzUeGvV7zs69LEvISbdj
         ZjMEwuMPNt4ysIsiEcfCFBl79gTOGbQWwRz370TDnu9czk7t6Zc9xwQwaprQXJU98jPn
         pUvQQWUGZjQyt9hYML+4ygmIn/lMlIcDWhB8QaqeuIpfAGGYZQj9ijuwfbkT13Z4Iukp
         CCcO37RlkVcTrdgY19OFCUZjVUM5tEC0+a2h8RX1jME5MUIHUBtF4JOw633+RzRfSk12
         t0vQ==
X-Gm-Message-State: AOAM530WEgU9rYxxKbCzDAfV3zhR7YQepc+hrET9b9Nxw/IyuxEtc8kJ
        GkCVF4Ls71UKzFxP3d1EiaWx1p7Fyny0fJkd
X-Google-Smtp-Source: ABdhPJw94QG1+QtbAqj68YCSI0vzsZyNdE6gSK+Z2Y5112Ep1Rc+tDw4hOiFEG9BraHHn813G+urIw==
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr5666913pjb.43.1631126943546;
        Wed, 08 Sep 2021 11:49:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o3sm2747178pji.26.2021.09.08.11.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 11:49:03 -0700 (PDT)
Message-ID: <6139059f.1c69fb81.9b82a.872e@mx.google.com>
Date:   Wed, 08 Sep 2021 11:49:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-3-g247080319c1b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 202 runs,
 3 regressions (v5.13.15-3-g247080319c1b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 202 runs, 3 regressions (v5.13.15-3-g2470803=
19c1b)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
    | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-3-g247080319c1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-3-g247080319c1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      247080319c1b3ee94bdcfdd972277cf392bd6974 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138d2f78dd390bba8d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
3-g247080319c1b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
3-g247080319c1b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138d2f78dd390bba8d59=
668
        new failure (last pass: v5.13.14-26-g85969f8cfd76) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6138d40eb7aa64255bd59698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
3-g247080319c1b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
3-g247080319c1b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138d40eb7aa64255bd59=
699
        failing since 0 day (last pass: v5.13.14-24-gff358fe92fee, first fa=
il: v5.13.14-26-g85969f8cfd76) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6138d31d4a7e3f24cdd59685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
3-g247080319c1b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
3-g247080319c1b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138d31d4a7e3f24cdd59=
686
        new failure (last pass: v5.13.14-26-g85969f8cfd76) =

 =20

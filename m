Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53031397A75
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhFATKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 15:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbhFATKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 15:10:14 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE44CC061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 12:08:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d16so220197pfn.12
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 12:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zctj9L7VUH9IEmlHfRvVYmCfQA3uAODQ17lJMeOYx30=;
        b=cTDBb2XME1LGua2LzGmTUOlkm8K3TZ6w+XdqTlqWIl8uV8GECI/35V1h9QNNm7XrZb
         SXyJTh2opmTra/pPdkzUVU590iEIalxcM1pZO8U1JuQr2ndzvJhkYV+NOewLOZzmWsxT
         4yOg0s1ZI6EGuy/ladQ396t09g3D1kyyblapZ+5wVlwHGaZyebzw2R/OglC33ZphHmcX
         /NHZ5K5BFjB/NJcpzlv4P0zK4KuDehjOUCN5soH5+9EjUosuF7VKa3F0doaGkP5POSbD
         thz8BZZULSH6tdN+8NqRQnjIEsiabeGiCxsBRGc1syjQQ0R7iI3NYsSwq1Td5A7gilPv
         mDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zctj9L7VUH9IEmlHfRvVYmCfQA3uAODQ17lJMeOYx30=;
        b=uUIVDKPo/GYI0/uIo1QYCxewc2iZmnBv84TUfDUiKI6BxO+2lC6VPG543MR/CZCbOW
         vy7x1Ya7Trv8dUTO7RF4kmSt5Xdyc1G8arPQCd/Ct21kW0oJMpc8ApLWt2s2xdtiB3TS
         7mqmbbGYWdB8izDfIwkHflBqno1cz4QHt6x+zda1OM3NAbF7BgO5SK1DYfqiD1j7bw3h
         2IkZ+5JD8mLIPDFkgmMC4f/l/xXMvmAAnuY77zegva32ak2MXY6PaPuOi/ab4yD7XfJY
         nKkKqrtU3Hmk9dO4vzbZKLCFdrP0pUqBeMz3eKFqSZFm11WXQ6WHSXFIbK/BldJUE/Ee
         2OAg==
X-Gm-Message-State: AOAM532QK0yyvS+pJX6fV8P14Rm8i0EmbUhaUPiVgjih6LjI/LcZ5DxM
        rbePo4aTFHi2+M71fTN96GSWQuOoAkQf3ezO
X-Google-Smtp-Source: ABdhPJyzM+F1D8XuQ5Z+9TMAuUD67ejLLFRJvmBxQoQQPjtW5B9UTyAaFY6eAIHJG10V8dMmeivVew==
X-Received: by 2002:aa7:828f:0:b029:200:6e27:8c8f with SMTP id s15-20020aa7828f0000b02902006e278c8fmr23411236pfm.44.1622574510168;
        Tue, 01 Jun 2021 12:08:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w26sm15437674pgl.50.2021.06.01.12.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 12:08:29 -0700 (PDT)
Message-ID: <60b685ad.1c69fb81.55849.058d@mx.google.com>
Date:   Tue, 01 Jun 2021 12:08:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-261-g8e56f01eb8e7
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 184 runs,
 3 regressions (v5.10.40-261-g8e56f01eb8e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 184 runs, 3 regressions (v5.10.40-261-g8e56f=
01eb8e7)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig   =
| 1          =

beaglebone-black   | arm  | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-261-g8e56f01eb8e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-261-g8e56f01eb8e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8e56f01eb8e7566fa63ef846a07a6b8ca7a4d66e =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60b64cc09ca59a4b26b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
261-g8e56f01eb8e7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
261-g8e56f01eb8e7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b64cc09ca59a4b26b3a=
fb0
        new failure (last pass: v5.10.40-261-g6aad7ab9070f) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
beaglebone-black   | arm  | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60b68587d1db10935eb3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
261-g8e56f01eb8e7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
261-g8e56f01eb8e7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b68587d1db10935eb3a=
f9d
        new failure (last pass: v5.10.40-262-ge442e564efd9) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60b658fbaa5f3da4c5b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
261-g8e56f01eb8e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
261-g8e56f01eb8e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b658fbaa5f3da4c5b3a=
f9c
        new failure (last pass: v5.10.40-261-g6aad7ab9070f) =

 =20

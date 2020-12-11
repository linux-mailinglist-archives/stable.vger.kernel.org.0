Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FBC2D7DAF
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgLKSJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 13:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbgLKSIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 13:08:52 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58485C0613D6
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 10:08:12 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 11so7463204pfu.4
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 10:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=58hmY1NY/mJTij1Kkg7Pa8YU9cGz86Is9swzZ+BToUA=;
        b=k6uWr8UnMgOJd0V4iEzeuGeeHDfhg/wMdsyeXQ0Qg/eFi98ZBa0P6OMFukWyH6LNOs
         D6wJe8HrH8wX83i4kQfJ8bY10fn1TyCw/zvTc7OQE40vecJe7HMGoNW4G8eaI5UdLhgJ
         aJURc0G9Js7ov4OivtZlxojeIEBqT88gPjEqCWDI4BLwRqnaq6oyg/UUyoN+IRhFXiHT
         w3TLRDZ/hP0gmaZnnfTnMLlZ7o4mt5ZkRTS4pWj6cimSLhQMFBkj6Rk4sL5ncE90SHWu
         dHXFGvoRcEY+MhSLo3MGx8UDz9/isiI1mfH0rLEsezmXI8WZA3CqOzSFJMoVlBID3kh+
         feqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=58hmY1NY/mJTij1Kkg7Pa8YU9cGz86Is9swzZ+BToUA=;
        b=pCHOLQt22ijtOR/Yr3GinvarTRPvDC7arkX3BH7r4cIWNkflMF1sXHQqyHbRt7Q20C
         /vsn/8AY/3VNArVnnQAh4qfYmsmhNqCZ9NPnTLituYSTLvpTof+hdEg2xH1zkJAU2eAW
         7hwvLClT6Zii7QwsSkqHR1SxT6XkawO64paPx2xoKT8qvQ8s0whx/oLUsZfpDokjC2Ae
         dEkTMTD15IRQU9vPS7EbVxWE3pZJCWTQoerJQAargbUi8prFiy7HwZrXXGeCr1GEkMoL
         FV6ALV02F8LThbNLXEtyn6xcDiwGcIz2r7vjWK1rl+2DWEghkbPukQCZB5dbTugny7RL
         b5cw==
X-Gm-Message-State: AOAM533d/oqblkxJK6jkZsRcq7lq1QcDDYFHLHFpwcuhqbv51ga3Y+Es
        wWC+/JAp2t/Mw4s0ZIPAsFXcEGxDMP2l+g==
X-Google-Smtp-Source: ABdhPJyZHkMsy1gOFnKOuVE8cg2M+68jD/mKCH7G/K9wHrGkDoTfqCwIMtjabWN13YzbDZk90TeUBw==
X-Received: by 2002:a62:fb14:0:b029:19d:b497:738d with SMTP id x20-20020a62fb140000b029019db497738dmr13070712pfm.51.1607710091167;
        Fri, 11 Dec 2020 10:08:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g16sm10428860pfb.201.2020.12.11.10.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 10:08:10 -0800 (PST)
Message-ID: <5fd3b58a.1c69fb81.369c3.3643@mx.google.com>
Date:   Fri, 11 Dec 2020 10:08:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-54-g4b8dbe2f66af
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 124 runs,
 6 regressions (v5.4.82-54-g4b8dbe2f66af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 124 runs, 6 regressions (v5.4.82-54-g4b8dbe2f=
66af)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-54-g4b8dbe2f66af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-54-g4b8dbe2f66af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b8dbe2f66af62d9ebdd6abb363af2bd2178c4de =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd380918152ad9a6fc94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd380918152ad9a6fc94=
ce7
        failing since 21 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd37e882e46443da8c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd37e882e46443da8c94=
cc8
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd37e8cbc0d304ebec94cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd37e8cbc0d304ebec94=
cbc
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd38031050303e46fc94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd38031050303e46fc94=
cd8
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd37e41755b45f1fec94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd37e41755b45f1fec94=
ccf
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd37e513f1d01aedfc94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g4b8dbe2f66af/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd37e513f1d01aedfc94=
cca
        failing since 27 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20

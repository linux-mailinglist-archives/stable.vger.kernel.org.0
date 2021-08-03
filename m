Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD143DE3E2
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 03:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhHCBPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 21:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhHCBPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 21:15:10 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40716C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 18:15:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so1555971pja.5
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 18:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rWwBxWU2EoS0//VooQ7L/gbV5CYc4/tvHmIZ68UlTxE=;
        b=oJ1oukHavvWc0ZfPxVR7PIwODfmHV0b2pZIUpWK1NzyTzD+fDGv/VXv6sUkW7wogGM
         HJ7keSTTEy54Ee3ZvGAWDa1L/u8459nkWNeuj6RT/lfATrs0qlGBTdDUpH3eB23VfPjN
         NSxmUCIynumcYNCV9SI4zDgSbT9lqCNPjT/NiNTKyS9UxJHjn0E2mTGZwB1c4coOcRKK
         /U0Jug9E+Vhu8svwFmH41GkHmwsjNElBP4xV4+cnqdQR9UOIfq1WFpgG9Qavi6OfQZx2
         cpVuBdnIeGcIfyZd29h9A8kx5l5dIZeRT/eAVFr2PvCLrMjzWRcE3UqrU4mlbjqmUbAH
         rlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rWwBxWU2EoS0//VooQ7L/gbV5CYc4/tvHmIZ68UlTxE=;
        b=OuLIWIsSaflV8L/KsfWbi5fDDjCtF74LmDJ6Fel+5dHRkO0myu4TTXIoqt6/wPnXJY
         K6hUOt2gU33P0uTAJdjdpC8vwb8cezZXNsmd9hfQO1rNSiMacuhJ+i5LUsHcm3VLFtGs
         u2dgJVaSR/iPtRjvxODUOabFo/e9WH2mWPA5/m0mES73tE194xh8Bvz3nfvBYUTqopf2
         K14TK17uXbA/jr/RrHf4sVELNkFDNK9rdDdriwRNaefzFEdii8q2PAXvpNIPv/D1LZ9v
         rJdZ1sf0PubNmbHbNs/j0nPu4/VcgBOfwBnjb2Ay1dIdt05TziHRPfpreE7Cc8uSRqyl
         C49g==
X-Gm-Message-State: AOAM5329T8sh8nHZE92Mml1YgAFsG5SKLd57TL3qLbeTcB90oNSWik3Q
        PFeSeGq2/Bcz70IgiKqnRid9LItHJJ6bJLQ6
X-Google-Smtp-Source: ABdhPJz3/6jrhpF5i72YbFMp9JTx77+S7dfRqhlE+J3YkIpWCHnyOE98fTI0p+oGEww6rP2c775UAQ==
X-Received: by 2002:aa7:870e:0:b029:3c2:f326:468b with SMTP id b14-20020aa7870e0000b02903c2f326468bmr3445056pfo.53.1627953299542;
        Mon, 02 Aug 2021 18:14:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s5sm12786168pfk.114.2021.08.02.18.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 18:14:59 -0700 (PDT)
Message-ID: <61089893.1c69fb81.21cca.5ce0@mx.google.com>
Date:   Mon, 02 Aug 2021 18:14:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.277-32-g4d2b3a84608a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 4 regressions (v4.9.277-32-g4d2b3a84608a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 4 regressions (v4.9.277-32-g4d2b3a8=
4608a)

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
el/v4.9.277-32-g4d2b3a84608a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-32-g4d2b3a84608a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d2b3a84608ae3b6ae55ecfee1987d40620d7620 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61085eacc35908393cb1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61085eacc35908393cb13=
66f
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610862eedf5ec4ccd1b13672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610862eedf5ec4ccd1b13=
673
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61085e9bc35908393cb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61085e9bc35908393cb13=
662
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610863852a216234a7b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g4d2b3a84608a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610863852a216234a7b13=
66a
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

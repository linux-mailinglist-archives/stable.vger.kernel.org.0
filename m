Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA9409D7E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 21:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347609AbhIMTzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 15:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242096AbhIMTzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 15:55:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D4DC061762
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 12:53:52 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t4so980181plo.0
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 12:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MQMtvlmnWQBemzPLmeku5yOggP35aptyj6fPyfhwsxI=;
        b=cqVs1Oeh/AA7c/liiVbcSsxftHwkkXY1sI6/X8jHnSr79o/6lv2uy7TkDilR5C7bW4
         mLwgfKEu5ZIf2fzoFPgorPdcAooqc6wO16wUIdeMWPqod5y4x+h3uRZ/hTHKgW7Qlupl
         jMS+swzUFOdFhDXVasGgaZBX9km3mebHKsAkaCWhWt+53o6BZFxm1mJrjyGdJsUkMLeE
         1LVagakMeyJIPV8xx0JLx8S0+yCpfPfjmyt3uIF6/WBflCnNKr7849ALYnPtQHIOetVS
         YDInE3abjOc2MX87PciY/QrJDqxwoPDfXAwVj7luEXp1XGimkuHcWlYjqozcI9ZVpjLV
         XqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MQMtvlmnWQBemzPLmeku5yOggP35aptyj6fPyfhwsxI=;
        b=d3509s+ofcz5KTkK/h/7doqZWRQHM5GXno1i9TdzT8ds4lhMEXreHLR0QVWuFplODB
         jK31H6YXl0LrarqYSYybAiTdY3T0U/LBlFu7arFhzk1IumYNUrjf9MBcmBicfPXQmTd7
         d9OrVTXEM77nKOJNtdyztfz65gABmVhvl0cRD6W1rI/egQx/6YcPH8wTDUL9DbwEbEKP
         Kn539ZdyeokB20hNhxUICSw+gFTmMvl3M9mhsUl14uWrhrIexUMKO7QksU7i601Zsdfb
         HhAPKgM+AS3ozNz8iEYGZGSUe5ruOQncWibLGsHX9yWiLL2ndYBTJ0cr6sVTLKty7vK9
         ROeA==
X-Gm-Message-State: AOAM531NEwwxRyvBqPGGzwzIIQKL04FVyC/QOEfnm45m7UrQ+8Ca+PBe
        Txn8aBHiFM6qfvuNByDB714pmjXZrgkX4Srx
X-Google-Smtp-Source: ABdhPJwJDi5vxlf1s+1N+o00TdAE8AiTsEPGnnM22/NQteauzKlv4kEXFnsn8cErZsSSpL8IlI4GdQ==
X-Received: by 2002:a17:90b:198c:: with SMTP id mv12mr1197942pjb.223.1631562832251;
        Mon, 13 Sep 2021 12:53:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm7890997pjc.49.2021.09.13.12.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 12:53:51 -0700 (PDT)
Message-ID: <613fac4f.1c69fb81.a82c.6f3e@mx.google.com>
Date:   Mon, 13 Sep 2021 12:53:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-89-gab2abd1425dc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 113 runs,
 4 regressions (v4.9.282-89-gab2abd1425dc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 113 runs, 4 regressions (v4.9.282-89-gab2abd1=
425dc)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-89-gab2abd1425dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-89-gab2abd1425dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab2abd1425dc71656086c5fb6d4bda3cff4d68b0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f785c8212c089f699a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f785c8212c089f699a=
306
        failing since 303 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f78548212c089f699a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f78548212c089f699a=
303
        failing since 303 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f78336da83b70c899a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f78336da83b70c899a=
2f6
        failing since 303 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/613f909de3e038c13699a319

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gab2abd1425dc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f909de3e038c13699a=
31a
        new failure (last pass: v4.9.282-84-g18813fd5c498) =

 =20

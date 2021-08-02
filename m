Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E7E3DDE76
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhHBRZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 13:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhHBRZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 13:25:00 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC09C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 10:24:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so974708pjb.2
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 10:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SwWGLPgcmr1pmL441O5pX1uLE0KZJVTFzWakbjMsftg=;
        b=MdMHkVxEmtSFUO1OWixf7bCuGxLKA6c+PMKWMtraxHupiyKH754lbG/XO2eSbrUjMd
         J0PD9/Nt2RzVywJPllrzzCyHJ50gFIKEZIStSrQHdc8lZRownqbliH5EgU748y0p7XSQ
         clL0LOJ6KBg7bv6z83GTSLItUIyRZZwC5tgFkhIpdutNpR+aMhX1gCunDE5YR4rr3S5c
         J2P/KhIl9yDSnjbPlZyVskG8MMQ1lGd4ECy1p/gTTkEJ2do3Q8F3tNR9ghMRFyF0sqcP
         eJH3475bUqWjm2oQVJNzt7gijUuoAyPyUxykcioKGUqIqHrngoynD2Szo8ZY056Sh7Rf
         8pjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SwWGLPgcmr1pmL441O5pX1uLE0KZJVTFzWakbjMsftg=;
        b=YosXrYa+VFEK1QRUmpBymqH+jWuEUzwaLT7f/lCRdOR/7kcSm59ZkP2sZeu+GKiBbv
         P7QDQBoWlfUCcY7wDgWTZiyhykKr0yJTczUFuvi2o5nCLMtZz3TVpN+IrXW7US3n07/R
         E2BoCTUaeuPuO9kPODqa5Twk2oMUn5WeFyrBuiZGgm8k7KUG7qn9qPX4QOrbj/rh7rgt
         PKP4WG3cY4bSXGVYhoUGqk52lgipedwcvBCBRgN4KhTaHEDkjexa2Qll7l9Q+H/3UjnQ
         lWbl5lOxY5EQMJRhrcZgtiPm4+i1W2DcCiI0f9gRp8xa+mLLem1aumhzdWC48urn6zkR
         g+zQ==
X-Gm-Message-State: AOAM530ALj8b+YxKD1tIR35nXI6U/WwCdwjmkKpIXTbjt5pyW/U5BY6F
        ERhBLMCYUxo32GrBIYrK0Qhh1252/RPp8hJ5
X-Google-Smtp-Source: ABdhPJyyAno83LcfnoGoFT56xA9PXQ4TLndpWzVYIIYelWECfl7/ORpzC89gniCvBE7e71QZs/nLGg==
X-Received: by 2002:a17:902:e8d8:b029:117:8e2c:1ed5 with SMTP id v24-20020a170902e8d8b02901178e2c1ed5mr14887455plg.39.1627925089184;
        Mon, 02 Aug 2021 10:24:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15sm12677080pff.149.2021.08.02.10.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:24:48 -0700 (PDT)
Message-ID: <61082a60.1c69fb81.14912.3f48@mx.google.com>
Date:   Mon, 02 Aug 2021 10:24:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.277-32-g8f1384a45291
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 126 runs,
 4 regressions (v4.9.277-32-g8f1384a45291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 126 runs, 4 regressions (v4.9.277-32-g8f1384a=
45291)

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
el/v4.9.277-32-g8f1384a45291/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-32-g8f1384a45291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f1384a45291715bd679590c7397437e11a15f85 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f53f046a2332f9b13682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f53f046a2332f9b13=
683
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f5752ee6c6d561b13674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f5752ee6c6d561b13=
675
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f536f873e30d73b1367d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f536f873e30d73b13=
67e
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f50e85ee8092dbb136c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-g8f1384a45291/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f50e85ee8092dbb13=
6c3
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777B240208D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 22:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhIFTuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 15:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhIFTuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 15:50:12 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0354BC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 12:49:06 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s11so7686077pgr.11
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 12:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JR1R4iY6KmgIpmUGBVwJCeCYZFCsggB0i4uhUG6YwwI=;
        b=sMoTblBDNOOGSsxZgGIRGVzR9ErSfCiDHmwvOBiUhSdYo16RO+BNydhzN6iedGlSs8
         6n4DBAAirYgQgRUmZBmdxFLXQNkF+HX85MynZ6HWl//QGZ5bt0XEfkefn77fLFNRVw07
         ZYjPT6mg7t51iMmX+40Xp2Wjor6BOIbb1apGdElCcUlh7msl52ZkHy4ovqQJXM3h6TQV
         CyZDXgpoBrfjGB3/hekAfkLTVWEhdpFK7x8rTAKe2CVRUA2ej/hBT1WLptYhtkrOmDQQ
         W/YZ7sxCRLqDSsn/3mLMmm0fkBjMI6im6pJPzwTFL/ERvFDu3i55qUY2LDvAkoejySwF
         D5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JR1R4iY6KmgIpmUGBVwJCeCYZFCsggB0i4uhUG6YwwI=;
        b=lq1rlY3X2HtQmn3CB6lTqk2osCd7Brf/xl+g/glPQCTzPgMWfdloBz3TkJUW/8FISi
         kt9zq+OpV4N3CRxxzTWm2/MTnmYAkZDGS9k+j/RbmAnSSRzgJUwI3C9RE+YefXlkKb1f
         Plp+amYUXODBW2UjwpHKPzmT2oaR82Tbf+BKPqaLMHNlhqa9ITUAdJuqZ9lmHfs3xDff
         cHCe6GVyJQHkBwBBEKlVAmYqwW+7LXvTgoI3KVpyUrtrrLb+1U7bwXpsSMy/yi1FqRyH
         GeKiGWlX+CEMEckI9lD0uotGnpW5DBoja4HB9qq7NLL0NRUVfW8FBMluW0Vkg9T6wzh7
         cXOg==
X-Gm-Message-State: AOAM533vukFimcME3AtYz7S9SvEia41/e7T4fsDYMc/sqR/NO1v17i6C
        iDYLtuihvy1hNs1IlIzY7S3ApEGBxWTvTioG
X-Google-Smtp-Source: ABdhPJz28XWhYKVa8o7gBfwJozqpWwk0VKjeccC6nBhv8XB9lU50MPzhvv/Vo2eKft2yFLAF24TlPQ==
X-Received: by 2002:a62:1888:0:b029:3c9:7957:519b with SMTP id 130-20020a6218880000b02903c97957519bmr13465094pfy.17.1630957746205;
        Mon, 06 Sep 2021 12:49:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b27sm5305233pfr.121.2021.09.06.12.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 12:49:05 -0700 (PDT)
Message-ID: <613670b1.1c69fb81.f79c0.ebca@mx.google.com>
Date:   Mon, 06 Sep 2021 12:49:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-15-g1c2fa5df96b5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 149 runs,
 4 regressions (v4.9.282-15-g1c2fa5df96b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 149 runs, 4 regressions (v4.9.282-15-g1c2fa5d=
f96b5)

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
el/v4.9.282-15-g1c2fa5df96b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-15-g1c2fa5df96b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c2fa5df96b5de516c097e12ef23ebabf30d8a7e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363e57de0a346bbdd59675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363e57de0a346bbdd59=
676
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363eff57c51a07acd59672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363eff57c51a07acd59=
673
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363e4ead107cab6bd5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363e4ead107cab6bd59=
68c
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363fd04d46655cf0d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-g1c2fa5df96b5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363fd04d46655cf0d59=
668
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

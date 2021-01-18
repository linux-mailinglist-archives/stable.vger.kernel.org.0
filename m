Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3F82F98DC
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 05:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbhAREx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 23:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbhAREx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 23:53:27 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D712C061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 20:52:47 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id x20so3564711pjh.3
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 20:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cIjPB+lc4S+sUchBpUjyRcgTlPgGmIxbkLqItEbE7i0=;
        b=an59VVHwEq9JJOXBm9QA6LOEBVlHwWmXvviMso3OF7AykxKB29aH83t7/+V2/n/yPC
         5zkHYJV7EBwxQkWEfxvR0vDBAeBXDqLz5DUUOxM+CRlNOvhs85PYplKk+vwuDUunlnBU
         qLl90wNeMMuVNgdpokBJxvtUGgigwco4gDz2sprzRXa4baYGCe63CbNbgG2iAaeybzEV
         OV60Wd+nocp6Vt/ySs8qZ15EUSMeJZ7la6SxtOxEXZV7gFrmen9xIcnqtpWkKEZoafUO
         gnr6UtUVU1OG7MyfIMOZpcspo//wvVIm/7iWPt9f21TdwyQcbSciGmXmST8xvpDegxr+
         LbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cIjPB+lc4S+sUchBpUjyRcgTlPgGmIxbkLqItEbE7i0=;
        b=ex+Mg2WOUF372BTy3AXFHJTNpopB4KKcxpFeO/T6ku4IKPqL+DOJ+Q/4O+XzTEvYsl
         drRNt4BdzSwBIPlM657A/h+exIaUVyb0yKOgC4c0D6rL5B8y0gPnUz4GuN117nbI/Ezi
         6SN4VehTnvx28WoBZFuFR/IIPavK8LaFzEoKgl3Nl/+TLlzu+CtuCcuyJqHn7ugbhDSZ
         sLoaqredtfMw0k3/drhRv92jJqZh/N+hBgVAtFv1yRiSKCRvpvcoHtxkBlfCBCyOzJ4p
         d7YfrUOWJB+rOXWq4ixOdhMmIOO67tApUvdnEKfpLlcJp0mFM7p0IL8DjvV8yinHX9aA
         CVOQ==
X-Gm-Message-State: AOAM5329bAjaGi5Jfp50a3ol7YEA2AKoV1sQx1OdNRSD36MEi34cJtae
        2oZJ0fAYVVOz7fvjf0eqNzMYwQjg/JdnUA==
X-Google-Smtp-Source: ABdhPJzwkUGg5GY8gxslEdvPdY/sPysSZsfB2Y4ZsUJR9gVnvkAxxO0o7A49yx1Am42nY2ydSPHTOA==
X-Received: by 2002:a17:90a:77c1:: with SMTP id e1mr24884568pjs.141.1610945566650;
        Sun, 17 Jan 2021 20:52:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s29sm15103331pgn.65.2021.01.17.20.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 20:52:45 -0800 (PST)
Message-ID: <6005141d.1c69fb81.5e1e6.5ba7@mx.google.com>
Date:   Sun, 17 Jan 2021 20:52:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.252-14-g2e053b32fc97c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 128 runs,
 7 regressions (v4.9.252-14-g2e053b32fc97c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 128 runs, 7 regressions (v4.9.252-14-g2e053b3=
2fc97c)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.252-14-g2e053b32fc97c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.252-14-g2e053b32fc97c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e053b32fc97c49dd9e4bc35163844c33cfb59cb =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e0f5243d32288fc94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e0f5243d32288fc94=
ced
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e0eb80bb4a8b6ac94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e0eb80bb4a8b6ac94=
cc3
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e0e980bb4a8b6ac94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e0e980bb4a8b6ac94=
cbd
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e0a21d81a2de0fc94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e0a21d81a2de0fc94=
cc0
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e22bfca38db388c94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e22bfca38db388c94=
ce9
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e2821d17382a14c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e2821d17382a14c94=
cbb
        new failure (last pass: v4.9.252-14-g5a6a27db47a20) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e284d2415ffabac94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g2e053b32fc97c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e284d2415ffabac94=
ceb
        new failure (last pass: v4.9.252-14-g5a6a27db47a20) =

 =20

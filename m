Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C263A1163
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhFIKs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 06:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhFIKs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 06:48:26 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA180C061574
        for <stable@vger.kernel.org>; Wed,  9 Jun 2021 03:46:17 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m7so5160566pfa.10
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 03:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kPTgNWtzec65Wx1TVbR/DELPOFPUnEw7C3x4/B51KXg=;
        b=qaNUAmUqwZdI8OfMb4TMKTCtd1mStkqwYgKjWvZHd6DA89x6N79c4sKUB03BhfTWcE
         186pdnqwdwvhYAr1pnlQQjqntACEnC3CWSUGxQ1D85LaNfAF8ktrMfWCXK7a008uI7V1
         9PKpYVKYTRXBqVoZKq8RPgxben7Yv9NM+GVD98YM2qvDtQ12KujpAV1URzdW6NDr/GTB
         KIqbaY3d+6Xbm/rdB+fIJqmCVoVXp64AxdTXzn2sxs5/C1SNgytRxEg87GUVgvyr43wd
         yogF9t5oLb+T7BR0JqZTHRtUpgpxRk/csP2UOkL+pszCDeVOCEga6oGdtjGKTQJwLNjU
         VXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kPTgNWtzec65Wx1TVbR/DELPOFPUnEw7C3x4/B51KXg=;
        b=SoryJGFhmNHmJI0U3sNDDaYOf/R8vnwW4Oy1qhhHKBebfEKSQBtAIrLbIlc/8F9Vt4
         BD+8TOZiEEYPnpO4ypcJt7TMLcGIT/76n7R+BM0pU4dV/qLJSWMWZrygAibzWgyOGrOd
         uu38+pP+xSkPxS96zDogBbNoaDZYgA7O0HjPeDaMpAM4aR4QZjsTWh4qkDRTqBY0yOpM
         JU3vitaSghRCBrpV3htRdXKOJfG07RyyJks+7x3yPVqg0h30dm+mkPmCUYJB2YhoZl7J
         grGXSVGznihocRdJnIzE+7ukjpFIlD2qV0b66Flg/tevmHO2gahtBs4asF1qkG4RLJN1
         JZrQ==
X-Gm-Message-State: AOAM531SKN8n3EiLf13yEy2zG0IA29/bUJRjruxTybcDUjU1TlI6S6Jd
        8//y95t/SW8bXkKzJ4TsseLJHrUixIkt39gS
X-Google-Smtp-Source: ABdhPJzJzTyirVUkhDZwDgrC2lNSyKZ/VvqKeXKYp/0ftwVzZcQ09zzFKuoIox+DXyQ3+LHHyjGL4g==
X-Received: by 2002:a63:f306:: with SMTP id l6mr3285033pgh.46.1623235577246;
        Wed, 09 Jun 2021 03:46:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w10sm13324262pfg.196.2021.06.09.03.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:46:16 -0700 (PDT)
Message-ID: <60c09bf8.1c69fb81.18c3.90ff@mx.google.com>
Date:   Wed, 09 Jun 2021 03:46:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-58-g3a6c65ec05c0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 142 runs,
 4 regressions (v4.19.193-58-g3a6c65ec05c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 142 runs, 4 regressions (v4.19.193-58-g3a6=
c65ec05c0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.193-58-g3a6c65ec05c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.193-58-g3a6c65ec05c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a6c65ec05c006c635fbfbbbbb941bb397dd4086 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c063f64b241418190c0e0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c063f64b241418190c0=
e0e
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c063f04b241418190c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c063f04b241418190c0=
df6
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c064024b241418190c0e1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c064024b241418190c0=
e20
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c0847450bae868870c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-58-g3a6c65ec05c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c0847450bae868870c0=
e07
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20

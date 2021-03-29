Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370D34D51F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC2Q3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhC2Q3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 12:29:00 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34721C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 09:29:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a12so1325736pfc.7
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 09:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5R0oUI98gs/G9Sb4LPhk+LswBqpB6MCzOLsW/10Zt4Q=;
        b=NaW73q9FOtUcIVcoAeFUbhnCOq7Hzxt/YTbDB8SbQPCmWLzrrTjp+YFJO03URYjLLw
         oBjS6eWXvytrP2YdmidqHQdM48sJY+I2OmRDqr9ddOswTc5/M80OzOvZ5FOIYNrA5Qqb
         4XB5Ve3Py67kl8LmKDfxZrB5qNlWVfbUbc/YScmvRo9u+q08g4xz0zuEGF1JO0pMZwi+
         acteS7Emv+z/U929OQII3VyB+Z4pEMbT8l1UiJufBzIjqzS3RKVWB9dqEcSG+IzvTkFn
         worRRf4XDAbOQyYlga3W+sw78BBhxGPY1uKlXKH1XXCEY8kA5bMHeykFkbbnjaBqNNv/
         QbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5R0oUI98gs/G9Sb4LPhk+LswBqpB6MCzOLsW/10Zt4Q=;
        b=Ck7/bj+OTQC9l/GojdAgotuHQrilRGt+nzCZnCPXAy++R5lTdcDuWVwPhckfHLC2Iv
         OWtXAZ5kssnwIznL4QUjdP6IsHTZgy8s3+jnPN7yVK17r7cmOf/eL70mbVIZJTYcDspk
         HgHOFZMUGIIuBrqzC/B0VsN/g31UkTRCjLnh0n8RaaooXdTofmbR9mNwVELcWX3427AQ
         kG0w3Byifw95+AnSkc/phWwn+WlJeZg+pRFJOIKSEy+2t9Q/XHrXMTnzRuQXxP+brTYp
         f4unWJ2quehglAuBwjh29rXUhS7VcSYHh1hZkFhmCY5eJumzGf/z4ao/OhGO7EP/NTy3
         MFXg==
X-Gm-Message-State: AOAM530/qs+HFyxOzwE2S2jcE8ugKvChLUv1aEx1geAPeetd/9nDQDoC
        DgnyTv2W6U4yelihSezRVGxXRiFrL/Ds4SzF
X-Google-Smtp-Source: ABdhPJy2lzVcjbEIAkyesdBj6/3HGnLyJlzI+c8z9jlG6R6fSJSQR1MCw3rojuO8F1AJEL8/vugj8w==
X-Received: by 2002:a65:6483:: with SMTP id e3mr14548293pgv.208.1617035339553;
        Mon, 29 Mar 2021 09:28:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm17280560pfk.138.2021.03.29.09.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 09:28:59 -0700 (PDT)
Message-ID: <6062004b.1c69fb81.dd850.b3c4@mx.google.com>
Date:   Mon, 29 Mar 2021 09:28:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-73-gbbd08292bae40
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 145 runs,
 4 regressions (v4.19.183-73-gbbd08292bae40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 145 runs, 4 regressions (v4.19.183-73-gbbd=
08292bae40)

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
nel/v4.19.183-73-gbbd08292bae40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.183-73-gbbd08292bae40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbd08292bae4049381e5537588ba9f581456c4d5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061c68e0acd9ac6d3af02c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061c68e0acd9ac6d3af0=
2c6
        failing since 131 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061c6890acd9ac6d3af02bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061c6890acd9ac6d3af0=
2c0
        failing since 131 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061c68bea21758f7daf02d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061c68bea21758f7daf0=
2d6
        failing since 131 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061ddb6eb20ae55a8af02d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-73-gbbd08292bae40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061ddb6eb20ae55a8af0=
2d7
        failing since 131 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BE330CA75
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbhBBStv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbhBBSs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 13:48:26 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDDBC06174A
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 10:47:46 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y10so8736213plk.7
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 10:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=98DlJlB/9WyPABT6u4ngByJX+9LBT81NjKdjPVPBRv0=;
        b=ZapPvpC4j3kMZV9HrOuxFrtrmp5TBYambcjvOYZaXgF43RXKUPxTqi/V4ShoXELKgc
         wmnWinBcVgcF7Rditp3Pj/OgfLoRZiDMzbiPpEg8co7xL3vTLzFcXoElwXQGaRr5aLey
         5+gvVSEl8kx2D1mQDEh1U+79HpiHNMkK2wgnh1FakAYcVKbO8BuYwpU28KhS3XcEnOvu
         WnfkfAd46Wb+N2jD0IGFcqAfATTIsMScUT8rowNQtSoQ0VKi5Bdw6CAJIRbO4teq/f8k
         bpIFgqkI98CcDTPjSh4fNdHItjRpUyvlHJTxUdsCpk78SB+e9Cnf1/5s/VHip2UGQAv6
         Z0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=98DlJlB/9WyPABT6u4ngByJX+9LBT81NjKdjPVPBRv0=;
        b=ERVVY9bdk145Yrfb2MfmJjunaVIcf1klgLYT5q6H9GSNWvq+PSYkpaarTCzQJ4pavx
         XSzLrMsb+CYldYuiFHfnkis2jwFvyJCfa4XeGGC1uN4lqNUGzFMGjK08YH88fZASANxQ
         SUFXMD++REIqmGFdts634VcuSMtfyEPoyoe7jG0MQ3PDCoCyJYIkBT4jUb/j6qlGUuZt
         Vhjb5+QS6nEFJwp51Tzky4GTcWUxPiaR6UiqVQ5xKWoKVGJWbZrerKL/TMmE83NnjLI4
         1pGrJtc6M0d5zvMTOLA1f6qXzE5V0FADg7kWUUZw7boE/5/m1UZEt5nV06ys7a6QILm4
         qTjw==
X-Gm-Message-State: AOAM533mdmKIBo+Qf9lhg+3RwNhga/WcoqVD0Dn0qvxbLOGLcxaiUHN3
        RyogV5Mx7sXuuWVoL9vNxDxGM85l4plFNQ==
X-Google-Smtp-Source: ABdhPJxWX076Fga9C3MnMhfliBO6xQ7xxeRPUOfNd5Omdlx0OQFfrOGazaxtQYQuavX6AfW4NpQGCQ==
X-Received: by 2002:a17:902:b616:b029:e1:805d:b4a7 with SMTP id b22-20020a170902b616b02900e1805db4a7mr6393138pls.34.1612291665550;
        Tue, 02 Feb 2021 10:47:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a31sm22776456pgb.93.2021.02.02.10.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:47:44 -0800 (PST)
Message-ID: <60199e50.1c69fb81.f11c3.4ed5@mx.google.com>
Date:   Tue, 02 Feb 2021 10:47:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.94-62-g339dd34feba5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 171 runs,
 4 regressions (v5.4.94-62-g339dd34feba5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 171 runs, 4 regressions (v5.4.94-62-g339dd3=
4feba5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.94-62-g339dd34feba5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.94-62-g339dd34feba5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      339dd34feba591544379ca9623fc350452e01be3 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601968a58b33a7be283abe72

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601968a58b33a7be283ab=
e73
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601969c15b8b3618e03abe8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601969c15b8b3618e03ab=
e8d
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601968b88b33a7be283abf0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601968b88b33a7be283ab=
f0e
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6019684902319674c63abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
62-g339dd34feba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019684902319674c63ab=
e6d
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20

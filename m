Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE243E0DB5
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 07:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhHEFSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 01:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhHEFSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 01:18:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B63C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 22:18:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so5692792plh.7
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 22:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ER5U307nNuV2z6tIVJHIB0+eofoyD8O8VZD/QmADzqo=;
        b=2KSTKv/YPz+sggKv4WVaTyOi4nC1SgzTQhJcTzMbLDZm46VLO+qxvFWXAWOcEZVavl
         Mhu7/bd8kaNs88Q3Fn5sLG7vqIuZLsxz08r38La/D3qKgUP9b8TdpGjDpMvoDjYJqTIn
         SbcNUVkUdn43ta4yoNJ65YEBzEy38e7S3unQLYUloDVJBXHu1Xp+17jX3s4yQJcfuicw
         I5iceIVqFicEtDUB04MIXOKCf9B4NJpXWzdnSgvOhDmS18DiPEHAKlDAiak6YUM+iHdn
         SD1i5x9/4r6mSU6lqrAH+3xTNhNYLxCMHW2aNIlsmNKg59EJSEZK15I9nZTbNg4tTD+o
         8Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ER5U307nNuV2z6tIVJHIB0+eofoyD8O8VZD/QmADzqo=;
        b=e5TuV94h8fGiI82wmjs6UV/yiPLkzvfHgmv2Koyt48S/d5plQ+PsCNpbh5JxubyX0Y
         p8oyD/1F+Yo/KZRJQVfO3PW86HYzlTT0Q3xDo31+/JphhBUZwgnd259195b70uL0PEv9
         1+4x1BSFVGuXGBxiPS6AzXg3orgaMRNe3Dpf/8h95mAwN9AEGqBU1M+0DddEIk0pvdrz
         O2LHnzCn2mdW7hylN5gqfY2Fv0J9+1VG3s/ONrHjOAgSXe56ekB18UzG8o8vpbNak3iZ
         U0kHfzmSRDwiC70Go6WmtOM90Ao44lAVgCDlgOrj5RoXfg5aP+rMH3DPmxh/HGvKxUX4
         afVA==
X-Gm-Message-State: AOAM531Hab0/2vOyZvkppBv4XqnMqe02i8IM2Eh+ySZVws1RLGa8pHiz
        lsK+burL6bmsJ2H4xZ4/QT8ctxQQlRbWsRnWFa8=
X-Google-Smtp-Source: ABdhPJxHREnmRaIc8f5/dCuzl2DHjNcb7apdQhPOr7lD1Ll8230a87sdknbtaEyjCe3zXquHcMnSzg==
X-Received: by 2002:a17:902:c205:b029:12c:daac:c8a0 with SMTP id 5-20020a170902c205b029012cdaacc8a0mr2423152pll.13.1628140689437;
        Wed, 04 Aug 2021 22:18:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm643061pfm.27.2021.08.04.22.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 22:18:09 -0700 (PDT)
Message-ID: <610b7491.1c69fb81.42ec4.1d22@mx.google.com>
Date:   Wed, 04 Aug 2021 22:18:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-1-gd189ea5e8a56
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 68 runs,
 3 regressions (v4.9.278-1-gd189ea5e8a56)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 68 runs, 3 regressions (v4.9.278-1-gd189ea5e8=
a56)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.278-1-gd189ea5e8a56/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.278-1-gd189ea5e8a56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d189ea5e8a563387d06e32e84353932c82660dcc =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b37ab82a59cfeacb1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-1=
-gd189ea5e8a56/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-1=
-gd189ea5e8a56/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b37ab82a59cfeacb13=
67c
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b3888ffe5e5a027b13692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-1=
-gd189ea5e8a56/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-1=
-gd189ea5e8a56/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b3888ffe5e5a027b13=
693
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b5d748a36c51c26b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-1=
-gd189ea5e8a56/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-1=
-gd189ea5e8a56/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b5d748a36c51c26b13=
66e
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

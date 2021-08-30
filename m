Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F723FB0BD
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 07:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhH3FOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 01:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhH3FON (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 01:14:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802D5C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 22:13:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so12999146pjr.1
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 22:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jrZ4TN6bggoNU6pDFkF8/X92ZJwHHLscf9JsNRTJRVg=;
        b=iy3IKAn1LSSYLIsDwnATsoqm5YzQNwnWeMHgq4jXp/9zjB70ZtQvAM92VXuHBAX1FT
         Pm8AJlo4LJ7DWJwF1Z5nuITSvDzmrW028G3+LPMB+ThAURl6eu/ohdPbzoImcd22vhcZ
         UMk5mk41gi8EOYsk1jhefrMDBUtr80yu1JXZkQa/5Mbm+m9lFDJSg2UXHEaX3rybhSBt
         MscYL2Q1mBac8tFRsGfAJS5yiREbFPgYzzsE84Iheyzgcr6tq4nDnreIgAOMsc59f0iF
         OSz2k44lbx/QGZu2mGNenyUe5dSFBlRe+4w3mVcKU1TcA1S9wQ/u/0ZS/IjyEvKiHTUD
         etkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jrZ4TN6bggoNU6pDFkF8/X92ZJwHHLscf9JsNRTJRVg=;
        b=jxjzdsqAztXsTm8KXQzV5vhVb/xd67fT4Cypi1KowhpgE9kW4elyQov3XQKEKSFaA9
         e5f+NfHTcge3/uSe7iddqpd+33t82G+1STsxaTd463SfoLdBuUrWlV4oWgYpR7gXC1xd
         KNylHoLfnMiKonxBJZFSiMvS8jXgBQgFavNMTrSLFOKW2Orx1EAeFs2HcpoKgICo4HdW
         U1pe1oarj85+8pzS/I09FNyaPGxkDA2sMLxpOHVur+a3Vn7iijs+ZWJXrAtHlv88Dksj
         XxKiVuZKkesPDK/D6AF3ZujON54ib0GXil10adwKUiAHORTOekOrhlV21S3sBiwVRgRx
         KXyw==
X-Gm-Message-State: AOAM531wGees2qYL0RLznvQ1vHCAxAYzXoYh0M/IaXXQewx+EhdheZYJ
        N+OygJLAEgjmwawngSh0GexuhKG8ZQfWU1mJ
X-Google-Smtp-Source: ABdhPJwmJejAr42H26CZv4zIPdvi7qhUlX5aaq2QcpU2YZR48x/TuyGuXwcA/lLIc9ZuE5GlkVQWVA==
X-Received: by 2002:a17:902:b48b:b029:12c:59b:dc44 with SMTP id y11-20020a170902b48bb029012c059bdc44mr20057058plr.47.1630300399860;
        Sun, 29 Aug 2021 22:13:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm4626713pfm.208.2021.08.29.22.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 22:13:19 -0700 (PDT)
Message-ID: <612c68ef.1c69fb81.31198.af1f@mx.google.com>
Date:   Sun, 29 Aug 2021 22:13:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.281-9-g1aa4ebfdd9da
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 4 regressions (v4.9.281-9-g1aa4ebfdd9da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 4 regressions (v4.9.281-9-g1aa4ebfd=
d9da)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.281-9-g1aa4ebfdd9da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-9-g1aa4ebfdd9da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1aa4ebfdd9da8e4c8963c929b2875256043263b3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c36b908ada157b68e2c7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c36b908ada157b68e2=
c7c
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c4543764d0731f48e2c8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c4543764d0731f48e2=
c90
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c39c83a7f52734f8e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c39c83a7f52734f8e2=
c83
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c41a7569220f0f48e2c9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-9=
-g1aa4ebfdd9da/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c41a7569220f0f48e2=
c9d
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

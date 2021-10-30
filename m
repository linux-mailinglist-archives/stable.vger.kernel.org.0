Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543A6440B66
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 21:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhJ3TG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 15:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhJ3TG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 15:06:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52F0C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 12:03:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s5so914214pfg.2
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 12:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vsx2leFUEjVNDuYdywIVhQE2r1oKYXGe8ta7BvrKsYY=;
        b=z61H+DWX0wkZCjeP3oGYeQACB+WD0BKZIOtOTRrVjJ71f8+PyLE9xtmya3Ap8HVwP+
         1e5G8Ucp01Ie+Xp9hnt8s17DPQe6lvReNnxcWYg92Q7vqFtNDc7VuJpVzVY5egdDy5N4
         SbXZ5r63EGAoq+KMY6nuKgmphkGFbXLYuw61BmY/IsAEqXlzACmwrngkql7nOlGJVqTh
         u5ulKGrx+ZIDmf4woqkoG84047xdw1X0wl10Hn6GdTpsWIkF0d9DHfEtaKS4hj/Y5hg7
         Ei+MSn1f0w7izXv4bTH+iDzcpIiAxVQrwf8c6Fqm3G9PsddyF3m73Z3Kf728gYAkZDZy
         GzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vsx2leFUEjVNDuYdywIVhQE2r1oKYXGe8ta7BvrKsYY=;
        b=iKMpxNb9D+GuIG/h1VqEa+PwCQUBDslVYQNiGwOxwY+pVC2fasOQqCBWdcreiDfeOS
         OXDvWu2yEmew5jfngZJwdiILnLsZwRCcV24+D31+w762a3dIw6NLt8mDKo01dWpoaA7J
         +OyyF2L3flmux+diD9oBckxiDIkhNWmhfb5UYzQ+Nvx7FDMQpH95RVYl8Im+eRhlPjVS
         L/zPOTuvcViSC4vZgR+lPbmVFHjq6e6yflBadWD0MqUkubREtMAKJlKpWXkeVaY9XXRp
         KRDKE0pwkmU0uhWRWAxZGajZbaf7HYE7vHdDm385u2QBrmKu8tjuVZTNu52tRj69hNj3
         0+0g==
X-Gm-Message-State: AOAM531QpqNQcQCTDBrr2W7iSETAA06aU1wwynrv7MuBnBNKJtLJViFx
        rWxR8J6aPBfDW9Ui82Vb9Zf5S/cOTQCThqPU
X-Google-Smtp-Source: ABdhPJyhlv9EvaX61RU1CA4LsvE+4r0MoHjemu0vG7FS37D0Kfwu7x2mcdqvp2JaPydJUerFsx7x1A==
X-Received: by 2002:aa7:85da:0:b0:480:fa13:7785 with SMTP id z26-20020aa785da000000b00480fa137785mr1256741pfn.74.1635620637429;
        Sat, 30 Oct 2021 12:03:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2sm9388392pjo.20.2021.10.30.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 12:03:57 -0700 (PDT)
Message-ID: <617d971d.1c69fb81.eaeb3.a46c@mx.google.com>
Date:   Sat, 30 Oct 2021 12:03:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-95-ge10a980ccb8e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 141 runs,
 2 regressions (v5.14.15-95-ge10a980ccb8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 141 runs, 2 regressions (v5.14.15-95-ge10a98=
0ccb8e)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =

i945gsex-qs | i386 | lab-clabbe   | gcc-10   | i386_defconfig      | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-95-ge10a980ccb8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-95-ge10a980ccb8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e10a980ccb8e186b77e45e45c0600d7a43156344 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/617d636141068eb7633358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
95-ge10a980ccb8e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
95-ge10a980ccb8e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617d636141068eb763335=
8dd
        failing since 6 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
i945gsex-qs | i386 | lab-clabbe   | gcc-10   | i386_defconfig      | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/617d5e94124394a5d73358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
95-ge10a980ccb8e/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
95-ge10a980ccb8e/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617d5e94124394a5d7335=
8e0
        new failure (last pass: v5.14.15-16-g9d1df96acad4) =

 =20

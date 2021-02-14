Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33B231B09B
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 14:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBNNpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 08:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhBNNpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 08:45:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0553C061756
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:44:19 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a9so137736plh.8
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C7DSK5F/3wnGnnyiQcON5q3lyhcTZ2w3BDm2ZcSpnaw=;
        b=h3HjzjIt6nd/bBVqJ4F+D/KdK71JpRTlG61oWD0Os79MO/SXUPNjVNOmNpazSEZmfQ
         210e+qq0NeRlfmGVmPfIGuLbjRESKFn8qIQ7D8gAik19VAo6WTRiWnQepzzbbbvL1EFD
         AfKpvLR5udhbC1zkG6CmMF+0K55JOpffGN6/NHGDBYIk0u8ZbzPjlHT81A1+VWFNJ2Ft
         ogJpQwzaA+sryNKXI/F6w0ZUiwdLYPU43ybTt4+6eRMmmUVWH8pzSwNmMULOZeQJW08k
         r+alQgr6rCpaH9QAL/yYTMhkAv5/XA6nzUFoHMWzNj6rX424jUk/rPc8iZ+8sovgIn03
         agog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C7DSK5F/3wnGnnyiQcON5q3lyhcTZ2w3BDm2ZcSpnaw=;
        b=rnSArs0/DKrRkNjTpAuIUTOa2p0ehYrGjbKWnZwSyw7ZbwhYE2X3LMbuopt1Zoelr1
         6hMW7+TZtU43Xj+TkIxyd+Zz1d/xGiqa+tCcsY11/QdGczs0w2xQqIkjEpDdGAofDLft
         6YMZ9EyBTy/MKsjTZubX6RML97zj0AkJC9Q5pHOplZUyTsDezLP4U/pXsae4cYdaL/91
         nyFEEGy6djCUQ08ioyEkBaC3VMsNUWSy1LcIUyJ1132y6T90/gjYf3YGIeJlPNjrw1A2
         XF/cbBgMaXT6MPkLwfZT9XyHyrg2U/VWPQsNKAX52rF2JyYS8NTVYkZlAMlusY0Y/CPJ
         njeA==
X-Gm-Message-State: AOAM531LXmsPqmuiWIxOE2p2MceYriXxPSzS6I87gdRM1PI9tMi4Oe7d
        hXu44QnxAZ/1yFliTmmijii0xCD+51ZppA==
X-Google-Smtp-Source: ABdhPJw36xtingKgDeK4jFCgzg8focQXy4paV2pAm85wTjzormLV6UuJUxqDhsduhrnZ3YdFly0OJg==
X-Received: by 2002:a17:90b:4acc:: with SMTP id mh12mr11557628pjb.10.1613310259225;
        Sun, 14 Feb 2021 05:44:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm13321499pjg.46.2021.02.14.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 05:44:18 -0800 (PST)
Message-ID: <60292932.1c69fb81.ef196.c63b@mx.google.com>
Date:   Sun, 14 Feb 2021 05:44:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-21-ga0b9f515faaed
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 62 runs,
 3 regressions (v4.14.221-21-ga0b9f515faaed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 62 runs, 3 regressions (v4.14.221-21-ga0b9=
f515faaed)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221-21-ga0b9f515faaed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221-21-ga0b9f515faaed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0b9f515faaed00f00a306151d38dcf0df389ba6 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6028f986aeddc121363abe88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-21-ga0b9f515faaed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-21-ga0b9f515faaed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6028f986aeddc121363ab=
e89
        failing since 319 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6028fa70e63cd42b2e3abe6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-21-ga0b9f515faaed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-21-ga0b9f515faaed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6028fa70e63cd42b2e3ab=
e6f
        failing since 3 days (last pass: v4.14.220-31-gc7c1196add208, first=
 fail: v4.14.221) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6028f57996bb3b81453abe70

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-21-ga0b9f515faaed/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-21-ga0b9f515faaed/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6028f57996bb3b8=
1453abe77
        new failure (last pass: v4.14.221)
        2 lines

    2021-02-14 10:03:33.888000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2021-02-14 10:03:33.897000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

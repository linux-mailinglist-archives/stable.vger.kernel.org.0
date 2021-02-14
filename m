Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE731B08D
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 14:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBNNdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 08:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhBNNdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 08:33:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FF4C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:32:52 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l18so2308243pji.3
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CDRJYkyxrfs5W0j0xeh5I2+z01bAC08CaspNxu2KWwQ=;
        b=H2Xd42EMcV/hv/hU++8Ik5jUot2B2xkFfQZTNGwPG+OU1DiPSHY7Zrgu+Ey2Xw+itC
         ofhozzCe4bUYIjoboy7m7q+nW4t8sZ41Co4AFv1BqpvFImJhq1yCsaNgXF0CqOSUm292
         T282Tj+rGYAmL4QhDx4Gvf8jqHInFPcO1qyl/aHI1M6/zOi0tSZJP44AzH2Zy5fvGtwV
         AFXDCV07vY1y6k92CDt/QOowCOSqKTUrFL6bauod6EOht0f5jPqnDVR94OK+T5t67C7F
         oj8J4chFT44rN+Na9qnXARpyL01JZZisMxDYw8EqKy2NwgVq5D0dB/4Gf2fIGWEmtghU
         uDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CDRJYkyxrfs5W0j0xeh5I2+z01bAC08CaspNxu2KWwQ=;
        b=nl2xyMFosNwfwplErOebvhEX2ZDeJ0tz9XZkdLBRS6nwLCRfRZteG324YcurUvojhW
         ZW1cblE1LwskEmLe628YUyULgIz81M0aLS5wnl2YDuuf29WznvcbJo5XZ9BMFNMepfag
         jzTVyBpLc8NF8tI278L5Co3v3k420YHCwdRxVBxO+fjhQaZ8RVZt1IxP+R5me9TCG8Rs
         yd4N/LNdChMo+sA3NwXLg9GEkzmppJ0aKK4fF4yxN6txRjkoRJl6Gxv+0I9c3ox0MhJQ
         XcPRyGukmwLTiUDQuP9NmEeWcXP67iY7LfhIoncrxASXtSDaiY8Qh0MFjI1nMaZEpsjP
         Ns/A==
X-Gm-Message-State: AOAM532ZORht/+Yp1W3t5SIx+Ab3kU5YPKs1/cCRlYhXTwg2HK9/6LVV
        whVu2QeaFnHkR9OP0Ib2+f72BsIfgDSROQ==
X-Google-Smtp-Source: ABdhPJwy1p61ypltDe+Wi8oX+k4WVf5IMBUXfbh0NhQw+0x4UhZaIgoLVbSIIrLkLzkpSCT68sX2kw==
X-Received: by 2002:a17:90a:5d0d:: with SMTP id s13mr11453274pji.156.1613309571419;
        Sun, 14 Feb 2021 05:32:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 125sm14484988pfu.7.2021.02.14.05.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 05:32:50 -0800 (PST)
Message-ID: <60292682.1c69fb81.d8258.ed3a@mx.google.com>
Date:   Sun, 14 Feb 2021 05:32:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-20-ga982926e8a91
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 60 runs,
 2 regressions (v4.14.221-20-ga982926e8a91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 60 runs, 2 regressions (v4.14.221-20-ga98292=
6e8a91)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-20-ga982926e8a91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-20-ga982926e8a91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a982926e8a91621afd1ea9e4949f98f7da28de81 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6028f817175959dbd23abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-20-ga982926e8a91/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-20-ga982926e8a91/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6028f817175959dbd23ab=
e63
        failing since 67 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6028f370df23bf15b73abed0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-20-ga982926e8a91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-20-ga982926e8a91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6028f370df23bf1=
5b73abed7
        failing since 7 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-14 09:54:48.129000+00:00  [   20.225280] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-02-14 09:54:48.145000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/105
    2021-02-14 09:54:48.155000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-14 09:54:48.162000+00:00  [   20.263519] smsc95xx v1.0.6
    2021-02-14 09:54:48.178000+00:00  [   20.272857] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

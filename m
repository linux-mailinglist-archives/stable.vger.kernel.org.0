Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7E3182A6
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 01:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhBKAbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 19:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhBKAbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 19:31:18 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2102C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 16:30:38 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 189so2484637pfy.6
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 16:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b2M0H80/CaNtKEaKQT+nBpbTHZ0CiAIZTAiudjOTrfw=;
        b=RNawpXnoSnvHFKeZPAZ6nkKF1hb8258jIAcCTHRsOkuzSMcRi9YUgMNdtEo8msVhuH
         wTysUhkF1eN5uA61QhdqXOHTOf9SKR5+UiwZ7z0Ig5op+17tqvPeVdU8DptJdbwr+Z8V
         HDlvwQULncsFhb0u4uxclGDgSDCJw1C3kKigj4YV0Y6aMt7Y836kHchLzpQ9QbStoze6
         FR8YB0x0FLtJ+7F03cYQgJ/bIwQQd2jLK5MDY1YytVmCrW9kiCdeqRvEdHir2JEbU93i
         vFkff++eP0M6q1y3CyVODapw+GJTDARwhKdi5UXwSlceKo+bJhjR9sXqn1oDcASztQcG
         Vo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b2M0H80/CaNtKEaKQT+nBpbTHZ0CiAIZTAiudjOTrfw=;
        b=YlxUnUgboehiWsozypLDDkmMoP41bfLbUrBWee83JWMrTRGK39B9Sm0xqP1ggrpIRH
         XcrzbHa0z7BaeoXU0jDF1C7kDm00ctIZmmdwcWa+ofM1BbTxdme3e3qV2FVteYIwYDCx
         Wv8i5ZR21MNJtjttgcEKR+od2cQOaL9EhIRWg/Gao9wD6Cb6UEnGeseRlG0ux5HyUfNf
         DOT7AEuJ5QIZ1Zwk/TjxeBgg8zLXwV/2AgQRpc2sZ1J2xtPogD2ST/CKYF4Vm1UKDxDZ
         TXAe5rVf6gBMHtLbuFBTGAXx371gzUKb7Pr/c/Xm7aCqJEpBoJMF2s8A6pTJlfhuNCw1
         T9Tw==
X-Gm-Message-State: AOAM533UPdxjLnANb5S1WuqItpghfolbU8whj0FRf/uJRIPyJwJ6IT0u
        +jwfoV4sRm5bSFW+zP7SUZsqjeF57jyytw==
X-Google-Smtp-Source: ABdhPJzKHmeZVmPrFemv7agrbwBESVtwRjB4ZIebPUtpRSmgGEvtdDS6Xk8gNUwZ/KqCFpmtbsOIJw==
X-Received: by 2002:a62:78c8:0:b029:1d3:85cc:2133 with SMTP id t191-20020a6278c80000b02901d385cc2133mr5858370pfc.65.1613003437829;
        Wed, 10 Feb 2021 16:30:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm3274866pfl.190.2021.02.10.16.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 16:30:37 -0800 (PST)
Message-ID: <60247aad.1c69fb81.658a3.7732@mx.google.com>
Date:   Wed, 10 Feb 2021 16:30:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-13-gc9281b21dff81
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 59 runs,
 2 regressions (v4.14.221-13-gc9281b21dff81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 59 runs, 2 regressions (v4.14.221-13-gc9281b=
21dff81)

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
nel/v4.14.221-13-gc9281b21dff81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-13-gc9281b21dff81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9281b21dff81065afcc0260b81dccd596b953bb =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60245776c175a7ff883abe83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-13-gc9281b21dff81/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-13-gc9281b21dff81/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60245776c175a7ff883ab=
e84
        failing since 64 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602443901a7c380d233abe6d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-13-gc9281b21dff81/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-13-gc9281b21dff81/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602443901a7c380=
d233abe74
        failing since 4 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-10 20:35:24.795000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2021-02-10 20:35:24.808000+00:00  kern  :emerg :  lock:[   20.388458] s=
msc95xx 3-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc9=
5xx USB 2.0 Ethernet, ea:9f:37:2e:ff:04
    2021-02-10 20:35:24.819000+00:00   emif_lock+0x0/0xffffed34 [emif], .ma=
gic: 000000[   20.405181] usbcore: registered new interface driver smsc95xx
    2021-02-10 20:35:24.822000+00:00  00, .owner: <none>/-1, .owner_cpu: 0
    2021-02-10 20:35:24.849000+00:00  [   20.436767] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE940D33B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 08:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhIPG3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 02:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhIPG3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 02:29:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE9FC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 23:28:35 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j16so4989145pfc.2
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 23:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i5x5lb+MAV0FThllLSmRrwvXwkuuww3ViauRqQMbgdQ=;
        b=DYiz/Ke7De18qn8Uage8c+k5lAo7yZVRqdMboyfYshVpC05vx9Q3hWG+G18JtTxZ/4
         ZZvhUbIotlB9zady8ZA4ezYrmVvvQQyBHdFreJ6c1dQjShkaVXho5DKk4j1+lSQnYH5R
         /tE0vK7rz/92xHm8KT8tFDoec8jQldflTCEZ0fBSCXD3uTlf2E0E+dOpJnmz+S7PusmO
         MmPgra8fg3AVORx/agdz12G8TSIpa9iFwfJHGnQZEWzuUYXJM3X4/EdU7hosrzmUcttl
         J4jQInRSgwPFXlY1MUp6iUhoi/ng/3tp/1jRs2RTvbBFApqm5gXf9c8yKJJsL13aCCDt
         k7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i5x5lb+MAV0FThllLSmRrwvXwkuuww3ViauRqQMbgdQ=;
        b=Fxc2ipZO3u3QZurRNlxgjLJDQK4bCCVXgc7OQOOdaZ58s+FJswPDcJ9ec/wM1XUBEq
         t67UraBvWfEgyJrHMVLh2QD2SQ9gi78woVxk8dzeQPvbo6UzE8Vj4nh3ARiz7jmsg2Z/
         DE9YrIEMedVurjbR/jGNZHVixZgGl+alNl89R/m8LVG6MVErrbRPrp4Kcy4OosrnLnfp
         rqB9FvTMxtGtcQTqRjrrqSOvtI7DfFPTsNlBJwWhpzIg9mbZ69wcwD9GZuZkF98PkEU/
         pzd6urj7WJvvoYYErqmthDCI023iPPx4q7t7g/2IrsmQXN34EarcbAZb+83niZZvm1vv
         +2jg==
X-Gm-Message-State: AOAM5316ekk21X7+KbKf+5YaEd2fVHsp85HOyo1sW7RPEe8RkF+7v5Ay
        zoY4HsjboGF9QCGyD6zmx8tWNIw5n5aKeGkEDy4=
X-Google-Smtp-Source: ABdhPJzEw51yXehvssJ7Zq6Gr/IZB3Z5Ma46M5Un2I/q+XE5Kitx1mcm+gyVimJPEGMVzvTKAZleSg==
X-Received: by 2002:a62:51c6:0:b0:43d:e849:c69d with SMTP id f189-20020a6251c6000000b0043de849c69dmr3479008pfb.31.1631773714514;
        Wed, 15 Sep 2021 23:28:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 207sm1730294pfu.56.2021.09.15.23.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 23:28:34 -0700 (PDT)
Message-ID: <6142e412.1c69fb81.6dee.7329@mx.google.com>
Date:   Wed, 15 Sep 2021 23:28:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17-69-g9af0951786ff
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 103 runs,
 3 regressions (v5.13.17-69-g9af0951786ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 103 runs, 3 regressions (v5.13.17-69-g9af0=
951786ff)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.17-69-g9af0951786ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.17-69-g9af0951786ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9af0951786fffae57af899121b161add0e44b3c2 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6142b10cabdac6ce1a99a37b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7-69-g9af0951786ff/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7-69-g9af0951786ff/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142b10cabdac6ce1a99a=
37c
        new failure (last pass: v5.13.17) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6142afbc97a096ff6b99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7-69-g9af0951786ff/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7-69-g9af0951786ff/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142afbc97a096ff6b99a=
2db
        failing since 0 day (last pass: v5.13.16-301-gdaeb634aa75f, first f=
ail: v5.13.17) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6142b11c6c0c4f0e8499a312

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7-69-g9af0951786ff/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
7-69-g9af0951786ff/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142b11c6c0c4f0e8499a=
313
        failing since 3 days (last pass: v5.13.15-23-g7f3773195533, first f=
ail: v5.13.16) =

 =20

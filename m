Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F413C3D8EE5
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhG1NWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 09:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhG1NWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 09:22:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F04EC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 06:22:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so4073243pji.5
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 06:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7an2C5AEtb+IuISZueLacEaQpmzTLd3nC4Q+OWAxk24=;
        b=chU/YXDGjHHcXOmHfEoxL3vuT/IgR9uSRc79KQ/tnTbUYmxHVQEptww/dFQ3OgPEs3
         4lamP/azuPnjMsLHK2j9Zcsj6zBAFEqkdyu1gXzaRDZdrgx0tCnHUVksbERRtRwEzgEC
         TnXM62MvaJpUPmRXOdqBA9njggM0MBcwE7XL/f66+Yih4RZ/sdeL5BGk4KiJ7qgLgUsm
         o3M/hm6iYA7ktD4gA6LjxkO58zIIDJ27TYWRx/8RW/pp2LCC0i/0V7RWQn6M9tt1u08y
         h4t+nTlml1TKbOd0rhFZklUd2jY3FeMTEA2vx0lzlidnLAgzfstB5+4Au0vtqWaRSK8M
         SbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7an2C5AEtb+IuISZueLacEaQpmzTLd3nC4Q+OWAxk24=;
        b=WthgUhXpFu3uf+QMtd2tdohqk0jep9jPa+6yriEcxsSlMqeAdgVtpvRWxpHTDOPaTd
         DbovnE++C4jEskvrL9m6cp4TPNWfFVX0Xog0tBRFqhXxq8N5datZ3dRObX7Tvo1CkYzO
         H+H5qAQdRKPi/dLjFCoHcyFbM0ZoE1YGZgThcNaSzfMxT+qINfvvwWpnpkT0kKHztP8M
         RGjOorlHKXsoO3MIQA/eDx/w/xeVpyk7m7AJIfjEMfGqjJcynPJhV+iPqhx5SgEOvtwT
         QAtz/AMHMIytJIOi5BN7ak0xHrEAAjGb15ib3fE3JP1HD8mdWWjyyOSLCMALziYKxrN4
         o/wA==
X-Gm-Message-State: AOAM530MIJHHvrB+OKNQKYB24d8E9BBWTIeh7T8wwpiMpnW9OCsFGPxC
        FDlJWEY7mK4w853mf0LiCC7xpEqQGOFrSYfi
X-Google-Smtp-Source: ABdhPJxfN0PlfidiDrN4+C5dPYgZzEvxd6d6pDz3sWh54d/0VBJGlHXziAGbk6pHmAjG58wlVRbPUw==
X-Received: by 2002:a05:6a00:1951:b029:333:64d3:e1f1 with SMTP id s17-20020a056a001951b029033364d3e1f1mr28618214pfk.43.1627478561041;
        Wed, 28 Jul 2021 06:22:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ce15sm6691117pjb.3.2021.07.28.06.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:22:40 -0700 (PDT)
Message-ID: <61015a20.1c69fb81.88024.4635@mx.google.com>
Date:   Wed, 28 Jul 2021 06:22:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.5-224-g079356b51f75
Subject: stable-rc/queue/5.13 baseline: 179 runs,
 5 regressions (v5.13.5-224-g079356b51f75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 179 runs, 5 regressions (v5.13.5-224-g079356=
b51f75)

Regressions Summary
-------------------

platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | multi_v7_defco=
nfig           | 1          =

beagle-xm               | arm    | lab-baylibre | gcc-8    | omap2plus_defc=
onfig          | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.5-224-g079356b51f75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.5-224-g079356b51f75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      079356b51f75b77fba856260833a433906ad5c59 =



Test Regressions
---------------- =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/610127334d3923e1f95018fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610127334d3923e1f9501=
8fb
        new failure (last pass: v5.13.3-506-geae05e2c64ef) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | omap2plus_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/610123731b7c61d9b45018cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610123731b7c61d9b4501=
8d0
        failing since 13 days (last pass: v5.13.1-804-gbeca113be88f, first =
fail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61012af7584625f9cb5018d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61012af7584625f9cb501=
8d9
        failing since 16 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61012d142506f7dd7c5018f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61012d142506f7dd7c501=
8f8
        failing since 16 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6101255846a96bfe6c5018ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g079356b51f75/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101255846a96bfe6c501=
8cf
        new failure (last pass: v5.13.5-224-gf89aabcaa51e) =

 =20

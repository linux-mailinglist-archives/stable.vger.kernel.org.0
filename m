Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EE13D7A4B
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhG0P53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 11:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhG0P52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 11:57:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE59C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:57:27 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c16so10681630plh.7
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bIKlY7cGd6byR0MpyFnUTCdx+1s4AXzDcpiah3FUyug=;
        b=1lsWWS4nx6dtqGEvuDGHV95pLA9Py51JU5bJcrLeKyKTs8ONKiPJkQjUBBaFHCBqL4
         biNr3L8PjFsfjCZUwgQp0/IoA/HbTRl3tKGZ2Ml7nqocwMFc0n/0Qse7cwLUqD76uM15
         +3Idysxv8t+jIqKqx+M6ld4tlZI2NEzgO7VA7eBf8+oO6kgAKHtLEQdnugrS6KA3NLn2
         XoP9cJVHAVFYl/OBN7lJZOqa8nGvg2Ho15bO+fHsgt758qknNaRCXWIhL95zCBupCZFx
         MprLRk/RLFVi+bfseG639zfxxPegjGOdtGFxjQl1eelG/z7fmr5u1Spc2311EWL+QAbf
         wTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bIKlY7cGd6byR0MpyFnUTCdx+1s4AXzDcpiah3FUyug=;
        b=UPStQwREAT45F3hyfJJMn41C+RIaBzHgARaU3VcL0cGyvhpZ/0PZHDhs/mubNXU2PO
         sy1WQ7M6pDTS4/+fAfBOAjokm7cm7nYpw3/tji530IGjJrp3ZQbbtWEza3bvB+8KJd0a
         mnVA/yfZ99iRpRCXNHN+vAj/Npfd974SxcvtNxNSM+h+nMyyKozm0J8vpUAU3k7DflR7
         a0+MjJq8V1kNSq1OcIcdqWqaS+Hfyp3vpLD4fsU1n4h7AoYxW4LjSOgdVBTaKPif8/eG
         +tFmAwVY26JGSFs5KHGHjgbkLDStbXQgoTpgkD+OjLIDrA+yJIMtDSIGiMdjqOBEW3gT
         3UdQ==
X-Gm-Message-State: AOAM532eNQXFns9JTRJDWaeWFX/BgxnYTnKqHtBKq8D9EIOAVz63mYvC
        dZOIuSJUnkJqe3GKSFunWnqM9i3yO8R67v5I
X-Google-Smtp-Source: ABdhPJx7XNwG5jrT3gHUzM+ulAJPdP7pwYX7CgEvxsVMnqqHv1+ClP33dHQjna/5wlgebOP8BggjpA==
X-Received: by 2002:a17:90a:43c3:: with SMTP id r61mr4962717pjg.11.1627401447245;
        Tue, 27 Jul 2021 08:57:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l65sm4750180pgl.32.2021.07.27.08.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:57:26 -0700 (PDT)
Message-ID: <61002ce6.1c69fb81.1b0a1.dfba@mx.google.com>
Date:   Tue, 27 Jul 2021 08:57:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.5-224-gf89aabcaa51e
Subject: stable-rc/queue/5.13 baseline: 147 runs,
 4 regressions (v5.13.5-224-gf89aabcaa51e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 147 runs, 4 regressions (v5.13.5-224-gf89aab=
caa51e)

Regressions Summary
-------------------

platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig        =
  | 1          =

d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =

d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig           =
  | 1          =

imx8mp-evk | arm64  | lab-nxp      | gcc-8    | defconfig                  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.5-224-gf89aabcaa51e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.5-224-gf89aabcaa51e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f89aabcaa51e465ff587b9040b2dc875e4e46db7 =



Test Regressions
---------------- =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fff5528f043bca225018cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fff5528f043bca22501=
8d0
        failing since 12 days (last pass: v5.13.1-804-gbeca113be88f, first =
fail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/60fff40ef58cf66a2050192b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fff40ef58cf66a20501=
92c
        failing since 15 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig           =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fff59811cbf504745018d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fff59811cbf50474501=
8d2
        failing since 15 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
imx8mp-evk | arm64  | lab-nxp      | gcc-8    | defconfig                  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fff66d2e00a38b635018c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-gf89aabcaa51e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fff66d2e00a38b63501=
8c7
        failing since 0 day (last pass: v5.13.3-506-geae05e2c64ef, first fa=
il: v5.13.5-224-g6b468383e8ba) =

 =20

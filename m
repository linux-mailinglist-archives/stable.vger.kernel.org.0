Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB73C3FAC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 00:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhGKWdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 18:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 18:33:45 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B83C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 15:30:57 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t9so16236504pgn.4
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 15:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rUeL7HHZAFW4tX1bGdx33f3NCgj7yo1Vb5i1p5mFxRM=;
        b=AFCeD54hfPmWkl/qhVAoFNK+XHjcm0jL+X4Z9cukBXihU+UZkpgrVODCunh2X4+ZSw
         5qrD2UpHBnX9kWUv9iRElEreiABXZZBlSTBgMVZdolJv5Y0azZJlPWGNfv2rsbVcuBmp
         huQWYr3RgiHfQLyAsgltGD4ejXzMIVD7pyxsK7Hmev9b1GFVfntIzO3EKJAO5wERAi/t
         8SYdFyimPF4GaypDNdmBEN4Wu7SM0U9JZgG6x2q1MZCtb+aTA0/z/o4Vc08EyGP4Uu0f
         xylU+nxImybhf1e8vpYm8ghpAIELKchNv278W7kprWqhK9hV1r7UNa+uvs8rJ3bkKlRF
         MyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rUeL7HHZAFW4tX1bGdx33f3NCgj7yo1Vb5i1p5mFxRM=;
        b=sBt+ziSlsLbYcJXnGwS1rttdEp8G/1HAmIAjprUnkCGbyP2zplpovZuUwHFZYMVCjT
         wFt0esyk3mfHvJks1GzqLZ2Qrt2/t8Zt/37cFlchT21PFPRzUPURamUPweua3rBXYakL
         mNAlR8ZBYzOBCOH54lSZ0D150NXpPmbO7dTPFhbxvrdNoxpts07P/e6FEtGW2tWfgIMa
         NMyOI0Y9m87kofuODh55pvRKxgv3g9PfrKrsAvBl/9vdaFr/Zg0cr2wGBzJWosmguTJj
         9Tythgh5Lohigg/wdclcPaosCmv86xdmuLNeVtFP1QHBvTqvw3ljXB8JAUXC09To0jPM
         8NvQ==
X-Gm-Message-State: AOAM532CT5kkY4+9A2MyY/9kAk9bSy2YcC0AgExspcSs+z9+73I3RJc9
        GcMoe39UP+l79Wt3+zNdGeDLGm7ynMwATWpz
X-Google-Smtp-Source: ABdhPJyULFgSdGkCd23elNvT+1jlfXme+ZiYdfx9U5j9Bno6KQPSjpXhlMMvZwNiu7bU3oSyHzD/2A==
X-Received: by 2002:a65:63c3:: with SMTP id n3mr955474pgv.369.1626042656954;
        Sun, 11 Jul 2021 15:30:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm14117452pfa.99.2021.07.11.15.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 15:30:56 -0700 (PDT)
Message-ID: <60eb7120.1c69fb81.61811.9e23@mx.google.com>
Date:   Sun, 11 Jul 2021 15:30:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-782-ge04a16db1cc5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 189 runs,
 5 regressions (v5.13.1-782-ge04a16db1cc5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 189 runs, 5 regressions (v5.13.1-782-ge04a16=
db1cc5)

Regressions Summary
-------------------

platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
bcm2837-rpi-3-b-32      | arm    | lab-baylibre | gcc-8    | bcm2835_defcon=
fig            | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =

imx8mp-evk              | arm64  | lab-nxp      | gcc-8    | defconfig     =
               | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.1-782-ge04a16db1cc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.1-782-ge04a16db1cc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e04a16db1cc5334b368c86a21c2982102aea5498 =



Test Regressions
---------------- =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
bcm2837-rpi-3-b-32      | arm    | lab-baylibre | gcc-8    | bcm2835_defcon=
fig            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb3d7c8b3bef62fc11797f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb3d7c8b3bef62fc117=
980
        new failure (last pass: v5.13.1) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb428f7a6056090011797d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb428f7a60560900117=
97e
        new failure (last pass: v5.13.1) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb43e3dfa99e731011796d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb43e3dfa99e7310117=
96e
        new failure (last pass: v5.13.1) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
imx8mp-evk              | arm64  | lab-nxp      | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb414ca93282c9af11799e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb414ca93282c9af117=
99f
        new failure (last pass: v5.13.1) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb40fd132687fb27117996

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-7=
82-ge04a16db1cc5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb40fd132687fb27117=
997
        new failure (last pass: v5.13.1) =

 =20

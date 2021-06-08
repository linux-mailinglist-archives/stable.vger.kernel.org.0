Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE363A04EF
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 22:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhFHUGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 16:06:47 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:46691 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhFHUGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 16:06:46 -0400
Received: by mail-pl1-f179.google.com with SMTP id e1so11279788pld.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 13:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uk++ugyg9NU3YsLvWLBj/dttzymvByTCqU6MZ59sRtw=;
        b=RhDH10gY4VUCpxeTrMj23kMoP0EDTlvIQrx1qxIje3CNsoyqJKDSQZk2YekSwsXBIg
         1dpVOilhed0L2z5Y+PYu/7rbUx42leOcgZluEeWX924GCZBa1iT4sl8cTUmZC3hT+/30
         NhkEd8sFM+4rXhoiiF2ifd9lVie/6FIDk+2p7EhmUw8YAa1QVUytRtffo9F2OP7G7yys
         V+toG+QMs3rBu2Kc0Eik9KHxmR7rDwtDN+Wn8+Cl7y7SemYXwOgXefE7bdH1I370UGet
         6bYIvGKJCkoEL2dcH33G91son1yQp3kiLs+l/nZaxXub3DLxCNdfE/xwykuTCT98T7kO
         2BGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uk++ugyg9NU3YsLvWLBj/dttzymvByTCqU6MZ59sRtw=;
        b=DomY89Zg892aCekiRGB3v6MMgkeRw3CxNXI59dLOTG5c1bH8V/wP53C1U4W3c4HP2O
         Yc5cgdcFkvBHUmrZbPm+aWi5ifcmzNTHad/eo4wGfNpE+jag8WeaxwV4Z7X+wrjorEjP
         CyDxyTx8rtM2cw5ioMFNE3SUuKLdUxeLaF504eFTNRKe61EIjKBIBoBuF+DCDCD0vHPa
         0cI7p8o3rmlg9wAkRkd6ieVKPyDc5Ci/y+LHV9VYzmlYPfY6aNS5HGf47vjsVhc4IhmK
         5cWD01+bZ6unSgXCQOvB5BM1V3oYDTa/AF5Op6j59RO5kqt1PgmWFybsxZX9fX1fFGi3
         /M3g==
X-Gm-Message-State: AOAM533By5g3+ct+zrWLE+Ye0yoWH25OF3BHKWDhwyyPYigM68pkZviy
        FZvnVrfOqRvKCaJZOSY/0/1cLuVqJxryU+TW
X-Google-Smtp-Source: ABdhPJye4tzinRLnbPbX8Tgq1mojHhsN6HOyiqiEmfiDV5FihExWH7VEX3QCAP1e+EMfAkw1dbsUwA==
X-Received: by 2002:a17:90a:80c5:: with SMTP id k5mr6708555pjw.129.1623182625176;
        Tue, 08 Jun 2021 13:03:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm2413980pff.160.2021.06.08.13.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 13:03:44 -0700 (PDT)
Message-ID: <60bfcd20.1c69fb81.6d2b4.64f3@mx.google.com>
Date:   Tue, 08 Jun 2021 13:03:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-126-gf4185f0d2d83
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 160 runs,
 1 regressions (v5.10.42-126-gf4185f0d2d83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 160 runs, 1 regressions (v5.10.42-126-gf4185=
f0d2d83)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-126-gf4185f0d2d83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-126-gf4185f0d2d83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4185f0d2d83f623cd17a7733efe76600b315217 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf9a2db79b954ab00c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
126-gf4185f0d2d83/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
126-gf4185f0d2d83/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf9a2db79b954ab00c0=
e03
        new failure (last pass: v5.10.42-68-gbf77ca472c45) =

 =20

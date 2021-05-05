Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D13374B38
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEEW0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 18:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEEW0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 18:26:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705C3C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 15:25:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b21so2165363plz.0
        for <stable@vger.kernel.org>; Wed, 05 May 2021 15:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PzXoyh/Hm9GyJYwH2zkZKwuhNr4JHzXdMLDb+MVBjVk=;
        b=JBb4voZBFtDrpdzGJ0uBlyQbdZEfOSb2ZeAvnUtK9TobHgYBtSUlU8NjC+PsVfBTfI
         zLpCs2c76zVUBtR4TFbeQtpkg/puSxU5hIrSamFZvyFvsX62kkkUFaDXsXBqn7mSKHDi
         skIDN0myruGVoC/B69mpLj3kljB04uK+uur454nyYoBSee+45NST3IvzuqsgGd9GpHqT
         Nsaxlk3wmYprlQdYryZ9G7TvKzvOhHf2wIgE3oep2CNCKPbxlCV9/t6W/zxxesJ2HQqf
         3Cr5dk6kiHPRANDru44Ii6xEudVRn7RGE3KuQsDhz0V7ki98m2teIojlm4CG56TJ15hK
         LPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PzXoyh/Hm9GyJYwH2zkZKwuhNr4JHzXdMLDb+MVBjVk=;
        b=DqfmC2oWYdnM2P7uOous/xHArjielYXdD3BS46aWntwJjaNlTV4Lgi5Sbu2/VmBO77
         xiaM/ax2M+PNMw3QJLSukaMj91MwrmlkbM/5oQ2+EwxHJSh3UEYs1S0TNUEnB3lFBUQu
         Rs5axvh9UII/qT1nDxwneyrFlP9q3EwEFoGvxGyJtQPMqi1yyj/Fwjg1ZfNZb7U8yozS
         Q29UyzKEa44hujqarLXbGOgHPgtGRpd6r4d2MqTI8yvBi3iWDKDi6ByfcxQoUvNn8q7S
         U0+86PfXMSjW3hq2kvKA9jLZwQPBJHkLvKwEZWlk7weelLoqGfu/2jzURVL+d5+Pqacy
         1qnA==
X-Gm-Message-State: AOAM532wqv86+CjC1OEWW9vMJOX20Tv5JBvnS3sag8/yc2qRDy4rctjg
        j1WBQIGB4YiRvbq3DyrWLdmJDjKQdLRcNcD4
X-Google-Smtp-Source: ABdhPJyTrZe5TZeb+xLzOgI5167vEwnO+Ao4Hj1nPr+1yG1iXoO2nLoFxf+7lPTx7GpQfw/oKQQT0w==
X-Received: by 2002:a17:90a:6285:: with SMTP id d5mr917101pjj.136.1620253552854;
        Wed, 05 May 2021 15:25:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t12sm232449pjw.51.2021.05.05.15.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 15:25:52 -0700 (PDT)
Message-ID: <60931b70.1c69fb81.466a8.12e2@mx.google.com>
Date:   Wed, 05 May 2021 15:25:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.18-32-gcffd2a415e64
X-Kernelci-Branch: linux-5.11.y
Subject: stable-rc/linux-5.11.y baseline: 82 runs,
 2 regressions (v5.11.18-32-gcffd2a415e64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 82 runs, 2 regressions (v5.11.18-32-gcffd2=
a415e64)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.18-32-gcffd2a415e64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.18-32-gcffd2a415e64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cffd2a415e649b47f93b2f10fd7b7fa2441c3585 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6092e4a0e0c2a1895a6f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
8-32-gcffd2a415e64/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
8-32-gcffd2a415e64/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092e4a0e0c2a1895a6f5=
46a
        new failure (last pass: v5.11.18-31-g2265d2b2a27f7) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/6092ec9dec18a783696f546b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
8-32-gcffd2a415e64/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
8-32-gcffd2a415e64/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092ec9dec18a783696f5=
46c
        failing since 0 day (last pass: v5.11.18-9-g7c5623736e0c, first fai=
l: v5.11.18-31-g2265d2b2a27f7) =

 =20

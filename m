Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E2B3505ED
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhCaSBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 14:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbhCaSBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 14:01:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8C0C061574
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 11:01:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q5so15105104pfh.10
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 11:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pnHCoyX5KSz6aOphHZIPd4WWlv/IxTN/xeBjtv4oQvQ=;
        b=fwXlckrSasMeIpj4fMhJDqm5ycxhHD1uLIpywgaTh7NcSLyGFi84fNpJ+l0Q2EGPXC
         obwlMLNejlqUAU51BJMHqNdmS0YJSgOlXJEEwoHb4ztyN05bEeCMpCrAHKRKdSRNE8UY
         9FWMMLb/r8O2K+OvP08RcI4cG7/hsKSvXLMz6njFvyOEPz0Xd3umQH/PzLvtgOTdr5CA
         Xefwrmf1NOneeuDqGt7k3sfG5FXTsGwwnmOhchtYdxBF9ot8G9z/cR/Ka6+HyScpkCxA
         sL+2T5paMiki0FxMtjZvYniIiZLZpnO3Z9oGIAf9FP8etiwTwzJtbldn8Fmg+Lg2AWXE
         9yCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pnHCoyX5KSz6aOphHZIPd4WWlv/IxTN/xeBjtv4oQvQ=;
        b=Ak1I2l/MYT4MV+qLpEIqk152DsaIQdWtLxCfczJzxidac0nI/kTOn9IQ8kM2GPVYF4
         2ZcBTZ0AxSlGjRPZgoX2eXpztfBl2oA4NGLoAqqjyLPY9wa7slNgnIillSRagVwnxGqO
         27V6TAXqabXYRV0c1D9T/8u+UHzGJIlO7LDlsX8jWW5Lsd0f/dVBRXn68RMgtTXkXp19
         a3nM3Uw4Pb70QFDnj/BvyTdHnPg1jivY3NAw5rRLM1B1YzTxuu/pt6ap2v+cnr60Xw4/
         w6fVywgWlB5WP6YWIf5kJn7ODuJapgJLTIEUEsS9b7jVGhESKT8LPgdcYqHG7bNsekta
         4uQQ==
X-Gm-Message-State: AOAM532je+Qzwn9lWxFcLKzk2y/BE870TComCbWKFiEX/bjAXhtNKegQ
        X5I0zKeqhf7OdQV0oYgVO0TsmWNlGHtPRe37
X-Google-Smtp-Source: ABdhPJzfVoVPyLjGaqtdbaeKDBSvuwI1+0W2gIVVbN4h48Lfvk4966MnkC1cn7ReNVRCk66IhvKS/A==
X-Received: by 2002:a63:4d0:: with SMTP id 199mr4409012pge.304.1617213684154;
        Wed, 31 Mar 2021 11:01:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11sm2773949pjo.48.2021.03.31.11.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 11:01:23 -0700 (PDT)
Message-ID: <6064b8f3.1c69fb81.9c30f.7446@mx.google.com>
Date:   Wed, 31 Mar 2021 11:01:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.228-18-g7a380dbab05df
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 119 runs,
 6 regressions (v4.14.228-18-g7a380dbab05df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 119 runs, 6 regressions (v4.14.228-18-g7a380=
dbab05df)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.228-18-g7a380dbab05df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.228-18-g7a380dbab05df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a380dbab05df7b7fa4b3c29f76dcd81a478497e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/606481565638563d60dac6dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606481565638563d60dac=
6dd
        failing since 0 day (last pass: v4.14.227-60-g91b0dae99c608, first =
fail: v4.14.228-18-g18fff9d01d033) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6064810e6b2fe9b74ddac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6064810e6b2fe9b74ddac=
6cf
        failing since 30 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606480395ed2e4ebccdac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606480395ed2e4ebccdac=
6b6
        failing since 137 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606480455ed2e4ebccdac6bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606480455ed2e4ebccdac=
6c0
        failing since 137 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606480677e38cddf74dac738

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606480677e38cddf74dac=
739
        failing since 137 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60647fe8f3a85f2ed5dac6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-18-g7a380dbab05df/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60647fe8f3a85f2ed5dac=
6cd
        failing since 137 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20

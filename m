Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFA389332
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355073AbhESQFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 12:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346574AbhESQFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 12:05:05 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00648C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 09:03:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so3663773pjb.2
        for <stable@vger.kernel.org>; Wed, 19 May 2021 09:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ax+/tAmq/nmStueZ7T05REw8QXCV8N/5qkW17yTSRF4=;
        b=EpbAy7Jncyh5mMKpIYOXPtkGThov4alkpodNfiEjatWVhBQ3WowxBvqg2XmuWMmNYK
         M95bMstsCfv764LD8rdOuy4OSFTE+35ZYzeRZfUEp8y+tRvphfndR6AMR9kRgBYR1QJu
         7BUyBRdrmCatn7Y4SSnsNWCiW4YjeqrEgbZ0bV26j4jYlpVAVPtx2yyfVC1ZNgmYQbKR
         gvwUa3/s6VVCl/yDLr06BgP+l62eUrGVs7MqiH7WxBnTIzB+ricCyVtiZLupu+f+8sj8
         fc3YNq0DI53uXuhFEb/3Prj8jmQGVP1DHlEWjIhegFVsVUSQtEJzYk3Vi9cweuMWEY7l
         Gbfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ax+/tAmq/nmStueZ7T05REw8QXCV8N/5qkW17yTSRF4=;
        b=DNCDF62k23JKTzNLcwNM5ByOk02/bm1Cf52Z1FR9zmNEytCyyTVP+2OUMDBAjIbSlW
         3nqN46uNEmxXWp58YW5snaXt4G+epzMbRcQruOJMeSmn++r2/lYdIBNQrd/dk416MPyV
         oxaeyeHn6tXEU4QJOwLuriRgQO0LFXvnim8QKgcZf+B9oh0YACQI8btezGVS/zegvpUJ
         12oimwp6IPjbejLjcItNRnvv1oJGxe70LSWP2tHGGZs9qcu+Jq586Uyrr6I8w/mQOJc3
         E9BrjXQ2axxveuCCd6J97rkG1JJmxjdHD7jIj5DXqa3zcN/mw43VE6mEop1G3vKHi0nv
         tITA==
X-Gm-Message-State: AOAM531Fv+pSJVzS8SsCxDGLSQA1jQ8BzeyLubtEtJo1vbEeDj2dnVn3
        R8+i4QABnlot7lV+tsNZisSclZIm7we3pg==
X-Google-Smtp-Source: ABdhPJyPrBPVCbzgvxnHdqa0RTo7ppQDDgGcIG6p0EWqqGEMBxdEdXEQGKintWoqynoj8R4JpOLZnQ==
X-Received: by 2002:a17:90a:d793:: with SMTP id z19mr12241612pju.91.1621440224290;
        Wed, 19 May 2021 09:03:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1sm338053pfw.34.2021.05.19.09.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 09:03:43 -0700 (PDT)
Message-ID: <60a536df.1c69fb81.e3f64.105d@mx.google.com>
Date:   Wed, 19 May 2021 09:03:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-394-gea57d62438f8
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 148 runs,
 4 regressions (v4.19.190-394-gea57d62438f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 148 runs, 4 regressions (v4.19.190-394-gea57=
d62438f8)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-394-gea57d62438f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-394-gea57d62438f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea57d62438f8efc6b801ba1ee2b9744e2368b6b2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a50243fb507327e9b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a50243fb507327e9b3a=
fa6
        failing since 186 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a502572ca65355dfb3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a502572ca65355dfb3a=
fa8
        failing since 186 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a502502ca65355dfb3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a502502ca65355dfb3a=
fa5
        failing since 186 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5020746843a8c33b3afc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-gea57d62438f8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5020746843a8c33b3a=
fc3
        failing since 186 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20

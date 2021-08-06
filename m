Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353203E20F0
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 03:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhHFBZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 21:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhHFBZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 21:25:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F82C061798
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 18:24:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ca5so13313358pjb.5
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 18:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C/brP8j9ev4dVYFYSobaZAAV4joNwSouuHJEECBmBzI=;
        b=aYf8gtgRjuRYBAmli8IK/ZpnRt7hhZ+VrpY1Iy08rcODDBf4EnTcJOLKQKlwdcRudK
         +Yaf7ev9eVCA/ZXYIDPpxgKtsiSLYHFtSNAri//Ma2H3zU1oP+8L7VwbhKt14QCT75Vg
         Pr/3ncuTjXKRX/zvC4NbJvZfzkIYrFYlyElZhwiRqz7oBCddBG3s0xn/BHwVpI5cCG0s
         W+vQLXWiGGAKhd6DExfbRXQBrX9voDi+RqWjhkRxl0ryjUEcDYwGqhjtEPKAstKeZBLy
         tIwmw9/H3ad4LRT9PdyEwjWE/CwLtWliNbQhSE5f7aGin1VXIXXkSRXs3KdKOfk4ul7D
         sgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C/brP8j9ev4dVYFYSobaZAAV4joNwSouuHJEECBmBzI=;
        b=mBsb7/SLvURiopkzvqIbfzcmfppbCdIt+I/0zMbSRLdlHsLUNg+cITJvsRqqH136qv
         ieRqrp36OxrqATjlv6njMscktck/1n7Z8nTA9s9Gr1qFuh7biZIRC4Mu3IVoXZjsnjrQ
         IM+P9XcEkUuLoOwIABZMnUTm2C8eCG/hBYYgC1+XyjMcTlkg8Jczt3Edo1EIyZvCsqQu
         ulvmKz37uztaXvhHu51sy6G+LvkwXY1+7s2aMBoL+Nc/5XtIgbnGIWf8/e2NPzNsKBpq
         4/cj48fY7uYI8hXs5qsx9rbyn2uhww4PJAkUBG+cOFl3PBMrz2Nj+zESaMhdtRNppCQr
         gHxQ==
X-Gm-Message-State: AOAM532V84dqVMwK5qOn9QDsUlDXlZ42OZJc3jpnPkaeYDMTWrMjtssV
        Y2SH1g3OkuY/RPhZFthbC6A7WauIAOLgzWRJ
X-Google-Smtp-Source: ABdhPJwtENEu+UMFk8cwovcg5tn5jh7O9vMKJ7Ndb7rvJkfSPYNpCHu4KrR1oXUiGOtSvXU9sCp61w==
X-Received: by 2002:a17:90a:4404:: with SMTP id s4mr18188401pjg.218.1628213093449;
        Thu, 05 Aug 2021 18:24:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm8102677pfo.159.2021.08.05.18.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 18:24:53 -0700 (PDT)
Message-ID: <610c8f65.1c69fb81.7cae.90bd@mx.google.com>
Date:   Thu, 05 Aug 2021 18:24:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-33-g3fddce574f66
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 145 runs,
 2 regressions (v5.13.8-33-g3fddce574f66)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 145 runs, 2 regressions (v5.13.8-33-g3fddce5=
74f66)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-33-g3fddce574f66/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-33-g3fddce574f66
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3fddce574f66a9afef938772ee2488c280f45f65 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/610c56eab956e9c80bb13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-g3fddce574f66/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-g3fddce574f66/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c56eab956e9c80bb13=
667
        failing since 3 days (last pass: v5.13.7-92-gf0aae5f0b8ef, first fa=
il: v5.13.7-104-g192e974dc8be) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/610c583d7909a1af0cb1367e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-g3fddce574f66/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-g3fddce574f66/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c583d7909a1af0cb13=
67f
        failing since 8 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB78A377620
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 11:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhEIJyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhEIJya (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 05:54:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1417C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 02:53:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b14-20020a17090a6e0eb0290155c7f6a356so6851380pjk.0
        for <stable@vger.kernel.org>; Sun, 09 May 2021 02:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e5I7Tdyzf501J6eYdYYjxulStyUwJUokysCULATmO6s=;
        b=VFT0g3mDzIHE2Ww9CRQTakk1/csxm3vZtfHnykdFcl1y4mtsfH7a1VxETTt7T1x+7L
         r2/qBgm7y8eG72YTvaUeDJyteDNQWSsX3WKsYiQr6T5yxF8vA48iLuEpZ/0lpokW1cLm
         nLCCKK3Jkdy5Pxe0DpKoJBjb6sLvCJbOyhl1NTHWvcut+RZFsVBO5++k5TZz78F8aHbT
         v2/T4BgjkSPHXSZgOgNFRZjLhp2UreWrqcxOh/zTcpzq6ZxcNdRABliG8E4UaXkiOBXv
         tUbCXkwaeCTFaNLi3ABE6v4aqwMNgOql12otHgkm7tT8woE07NUS33q7zsoEaY4kJIEX
         OtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e5I7Tdyzf501J6eYdYYjxulStyUwJUokysCULATmO6s=;
        b=t3ng/islLiDt68Et2kmm2ALV9ZGg494wp4xdaDKubNLyrDmVumZuV9h56/QkmJT3YO
         jT7XLuoo6Dfkuc5jUBNiCJH/JFT2nkY/ejasfmu6AO8wsOqiy8LyX8Mo9UqjT651P21y
         XF8Yb8Cp/nClwpTWzOeHyTLOxH/Ekzemxqc0PmeQRqATfZKE+fvFyzbddkZIl76r3M1n
         fbN7hTqCt6zsKx8pJVJEDFVHWzF0MLuw2oshwMITXdw2pJr+qQfbDqbn9JGAPjiYMFRb
         nKgcuKH41QRBF6RExZsYwIUVubbSuAGNEvm2wWUpYcUqJUzzxDgl5QwIoeRRnWMZFfmj
         7XDA==
X-Gm-Message-State: AOAM533FiYAb2fYJqCMp/mlg8sgfV/WGFAq5ggqrsk2jeEocQMtojuz3
        VZ61ZofY+3DN/L2OEsZLVP4T5eOvyz5U8Rpy
X-Google-Smtp-Source: ABdhPJx7KNozUztRUKyjcTR+AJPiHTSh9rW42Py0Klqh1RNPV1iK+76EBcFmfsUHuFkpXoXQ55oZHA==
X-Received: by 2002:a17:90a:fa0e:: with SMTP id cm14mr34415160pjb.59.1620554003239;
        Sun, 09 May 2021 02:53:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w8sm8838243pgf.81.2021.05.09.02.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 02:53:23 -0700 (PDT)
Message-ID: <6097b113.1c69fb81.9b1fd.adcd@mx.google.com>
Date:   Sun, 09 May 2021 02:53:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-222-gcc2109a6a918
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 2 regressions (v5.10.35-222-gcc2109a6a918)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 2 regressions (v5.10.35-222-gcc210=
9a6a918)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-222-gcc2109a6a918/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-222-gcc2109a6a918
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc2109a6a918906209d110851f8f2dc8d9e84e34 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60978028ff3477e3736f5487

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
222-gcc2109a6a918/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
222-gcc2109a6a918/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60978028ff3477e3736f5=
488
        new failure (last pass: v5.10.35-222-g6e80e7d220ea) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609780cd07ea26197f6f5497

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
222-gcc2109a6a918/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
222-gcc2109a6a918/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609780cd07ea26197f6f5=
498
        new failure (last pass: v5.10.35-222-g6e80e7d220ea) =

 =20

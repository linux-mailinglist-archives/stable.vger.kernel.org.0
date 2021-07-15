Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2493C9607
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 04:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGOCsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 22:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhGOCsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 22:48:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C44FC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 19:45:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so3031556pjo.3
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 19:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q6yPdWm9npTwclRwPT5tQ6HHnxSQF7jtLKV/VMSCtwk=;
        b=lxZU1etdDNl9arasSKN6piwnN989TEcFmwEF6N9kz/LnEbMdSD8wg15i9Rj+chroKy
         Qnio/JW/y+tma8Y0l347cm3q2uDvg3PtYFteoJnYMR7heg1KBLub5xw6prQEL1UdgIlH
         9NOF4iUi5BnGey1DvKMAiNL015x1SEsjx/WeuU6NGpBZFxl0qlU6NziXwySA03FepPUF
         rCeykiwT0JMoayZZ43l7cdVb2FUpVMle68xjb3fAyzUFGA4BXi0NJPSm+a1n8LrWN1Y8
         KCSQTYoYTOKUI90kql1mZYtdRuq4WEOa26bW1ZfMEGYtw9fBr7G8qSYm8jIpVEFgFZfg
         FHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q6yPdWm9npTwclRwPT5tQ6HHnxSQF7jtLKV/VMSCtwk=;
        b=F0dkdXtDrf9fhwphThfNOryHpBskEasc6VqzNr28NB0fiNO87Q/hLTR6l0DPq+hyzY
         bJpL0ud4domvvlaMbg8zhwIIrsI4YmKmFziH25SDyB7796OdKvjMbcL9cZBxZBmMJ5Rf
         +Wq2jYqea77lJ6fZxRZzYl/pC2UGUiwLNpL7PuASYEU/xXHPSzMRdSZ3aW8n3udAlQpi
         2TgXwhY2KFtS+jwq0yue0e9g8IBR9sw3I7CuX5iEZftznfBacBxeE9l0giqM/p68rliH
         Omsb3YSVa8AurRH5Y4h09TThjZYdOM/U9EJIhoRncTwDPC6BmS+7rdQx++Qno0DkJzdp
         DFFA==
X-Gm-Message-State: AOAM532azmQHjiEHpgGWCgGiGv7hDSbO9VTjaYSpWQc3moqFDGdBIiyU
        1WgVBYzsNaY2wRPdUxAL+VKZ98znZsFKUpte
X-Google-Smtp-Source: ABdhPJzjLZm0bdcPoM/USP7IVwX2oRBUMiqiD3fGEQmsCLacp99wlDslhYLUfvSI7LlChm/PxSmeOA==
X-Received: by 2002:a17:90a:fb96:: with SMTP id cp22mr7256492pjb.154.1626317148541;
        Wed, 14 Jul 2021 19:45:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a23sm4141440pff.43.2021.07.14.19.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 19:45:48 -0700 (PDT)
Message-ID: <60efa15c.1c69fb81.dd2ea.e2d4@mx.google.com>
Date:   Wed, 14 Jul 2021 19:45:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.2
Subject: stable-rc/linux-5.13.y baseline: 180 runs, 4 regressions (v5.13.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 180 runs, 4 regressions (v5.13.2)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
beagle-xm          | arm   | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

imx6ul-14x14-evk   | arm   | lab-nxp         | gcc-8    | multi_v7_defconfi=
g  | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6fc894baac777c38a95a31f65343bea8b1a2678 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
beagle-xm          | arm   | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef6f379ecbc633ff8a939d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef6f379ecbc633ff8a9=
39e
        new failure (last pass: v5.13.1-805-g949241ad55a91) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-14x14-evk   | arm   | lab-nxp         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef715e157d8fd59c8a93a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef715e157d8fd59c8a9=
3a6
        new failure (last pass: v5.13.1-805-g949241ad55a91) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef714524cbc420bf8a93ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef714524cbc420bf8a9=
3ae
        new failure (last pass: v5.13.1-805-g949241ad55a91) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef716067ecb825448a939f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef716067ecb825448a9=
3a0
        new failure (last pass: v5.13.1-805-g949241ad55a91) =

 =20

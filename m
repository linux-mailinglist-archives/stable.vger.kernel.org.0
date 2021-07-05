Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629053BC37D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhGEU6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 16:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhGEU6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 16:58:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC9FC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 13:55:48 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l19so5619312plg.6
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 13:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BEWC5afgqW6z3Jqdw4MSjflqnQiqMsRz1s1F8dKITUE=;
        b=hD7MbptENuRgJK4XPLBmw6sDX/ldcf3sI/suKu34Y9UZEbNfWg8lCqpV0K88x3DJRG
         FlSAAt7VYNC02VshUxNSrcc2ovlbfWiinv62x3hn48HqZE2E2QwQNiyzmli4k/xg4MxQ
         HsUjYU5q4zSYNiVFQJkEg6ZR1OZdyur2lXHAyAIMHvump4saYfLxhK1kLaoREFjDYIb4
         Bz6fGPbZMHl8Pga6AVvezVPEyGYxrPXard5R7lwq8R+r0oCyPKORoRvaJCwc6iDMH4R2
         KSmRP7/Vg3OOPn11kbtgakfs+WVGqO+SQzUBJo4uFhmJT1Du+GAQsHEXk6I3AKlbF6uX
         3rXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BEWC5afgqW6z3Jqdw4MSjflqnQiqMsRz1s1F8dKITUE=;
        b=IEmRMYt8AnP3gAA+TonMCuL6oE8y8FMogZPq1CAyndX6Z0dXUoFKi4T3w58Zf/+Ai9
         bw+nfZlmOGNM4FVRHMLQowVXKwBSyRt/51PeVPs5i2b/53lia94c6qQKDbp7ox0yLzOy
         QfIKZT5CHaTuZ1ZWwD/VKN2g8npt8hytJ75732ZWdAhEHpbXlm/Ugp5Eh+D47gpreHiu
         t91JvKpWu0bvcvfBKx6PzNNc/uCEBcdOWn985+/MLoQ7WefsTN4yDssbnbIyA7lFzT5J
         cp/a+HAulZkinM3gwqd4SxWWdyWnKvUirlSfPvvs89UIM4Er0LdUUVw+bl0PXvsel2R6
         sNkQ==
X-Gm-Message-State: AOAM530YZwRXgOWCKCaHTZqQs9iRZRK8tAjTW49KuCnoha4R6Ad38ow4
        wlg7DjGkrBeztSKhYwGCLnkQWaUFcdFM0oUf
X-Google-Smtp-Source: ABdhPJwWdtMwogIGayMT6Kv+ExXh0De33JYFL37i18HukMgK7fLphsHNH0nnEGp/V/i6Q3VA2SKA4w==
X-Received: by 2002:a17:902:ed84:b029:129:73d9:b83d with SMTP id e4-20020a170902ed84b029012973d9b83dmr10357507plj.43.1625518547446;
        Mon, 05 Jul 2021 13:55:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l7sm15600959pgb.19.2021.07.05.13.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:55:47 -0700 (PDT)
Message-ID: <60e371d3.1c69fb81.739f9.f041@mx.google.com>
Date:   Mon, 05 Jul 2021 13:55:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.14-6-g9a76cc7cd8f73
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 177 runs,
 4 regressions (v5.12.14-6-g9a76cc7cd8f73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 177 runs, 4 regressions (v5.12.14-6-g9a76cc7=
cd8f73)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
   | 1          =

hip07-d05          | arm64 | lab-collabora   | gcc-8    | defconfig        =
   | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.14-6-g9a76cc7cd8f73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.14-6-g9a76cc7cd8f73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a76cc7cd8f73188ca9d1d61b72b0f4c8d44c73e =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60e3393891e75657b511797b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e3393891e75657b5117=
97c
        new failure (last pass: v5.12.14-5-gb49b7dd97218) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
hip07-d05          | arm64 | lab-collabora   | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60e34e1da344de51dd11796b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e34e1da344de51dd117=
96c
        failing since 4 days (last pass: v5.12.13-109-g5add6842f3ea, first =
fail: v5.12.13-109-g47e1fda87919) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e33bd074acb5d7a911799d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e33bd074acb5d7a9117=
99e
        new failure (last pass: v5.12.14-5-gb49b7dd97218) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60e3403d9ecd9489cc11796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
6-g9a76cc7cd8f73/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e3403d9ecd9489cc117=
96d
        failing since 0 day (last pass: v5.12.13-109-g47e1fda87919, first f=
ail: v5.12.14-5-g0029a8b67c08) =

 =20

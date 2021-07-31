Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C53DC466
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhGaHTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhGaHTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 03:19:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EB8C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 00:18:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso17580768pjf.4
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gmCzxhLJg5H1BbShM/j9JqL0CZ7kIwr/Ag8jcHNo7SQ=;
        b=iyO7g9kO3wF+EDMSU4U5v3O3dfqz1xjxEXkZAZyGya/ZEIC3KDcir4IWNLn7NMndSI
         HunylBjIqAoXHNElqUkLXo4hBjlcoU/skaJhBWDOZWCDHjteM5GLPYQhHOdcuDGYYQvl
         Ls4743dNGI2gWJAn8MTMVPbu+tnh/+DVfB/+Co36qvbT1uro8hIyb+u3WqKp8rdFrdvo
         Im2eju27pnAhITIVf9OHNoUQe2tmdOEUn9Ga8thgiy5PEBCw+R3dRPlqpwAMSV5zVKXB
         GPaqHoBHZIWW0CaK9COM1UGKQbPN5bJYWude6QP51cGKF+b7kXA0YV4K1igpSS0HLNcd
         O1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gmCzxhLJg5H1BbShM/j9JqL0CZ7kIwr/Ag8jcHNo7SQ=;
        b=UxL3Uhqh6OTbmAFMziHcuN+auR0sQRgNANoV/A9Txm5cmZ1Vz5K2VPsSkuCK6UWPXm
         YHISUaSBgW2MFtPAmA5mz805FlOtYLZb45n4IOcMc+ysFx+zs1hsFLfhkxFQavVwoTVw
         YbGqDjMu/88MCZUlQ8aqxYcLduaF638bE2oJ8Kk+aEIl+AsQPEaOJl5J8Zlh+VuRMciL
         jMgloEBH3+cN9VxTt8pOPy+OfSo8TUygNjlB3T5YvjKV8B0ePTlbnzgiEZ0/tbOUsn68
         Rvya/bzZZ/FqOVXegIdyBarAbE8lhRJVML6/v2IFImGbDYAoPgNkgqMX/zN4UsduuyYU
         R3OA==
X-Gm-Message-State: AOAM533p3R8VtzAKw0Cb86xQ9Cck8dqQGqN/OxCdvPqfTpM1pvygoPLQ
        nqr5EsgfcKovIMr1OCK/jo6nTVTIzhqvBVtd
X-Google-Smtp-Source: ABdhPJyd5WTdgvOrn3+de6DVXZAgU1YTAPMWGr0QYTtKj1KBAMOXEEERwbRwenN+BwESoh2lLYBZYg==
X-Received: by 2002:a17:90a:bc4c:: with SMTP id t12mr6989691pjv.92.1627715935927;
        Sat, 31 Jul 2021 00:18:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y17sm4978743pfp.147.2021.07.31.00.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 00:18:55 -0700 (PDT)
Message-ID: <6104f95f.1c69fb81.1feb7.de24@mx.google.com>
Date:   Sat, 31 Jul 2021 00:18:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.54-2-g41c54732efb5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 173 runs,
 2 regressions (v5.10.54-2-g41c54732efb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 173 runs, 2 regressions (v5.10.54-2-g41c5473=
2efb5)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.54-2-g41c54732efb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.54-2-g41c54732efb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41c54732efb52c3df0e1ab8058a8954ddfe9ebe6 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6104c3577e969f8acb85f46f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
2-g41c54732efb5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
2-g41c54732efb5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104c3577e969f8acb85f=
470
        new failure (last pass: v5.10.54-1-g413d16971b6e) =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6104d8ca11911b572585f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
2-g41c54732efb5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
2-g41c54732efb5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104d8ca11911b572585f=
45b
        failing since 29 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =20

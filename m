Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC176431419
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhJRKJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhJRKJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 06:09:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B21C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 03:07:19 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id np13so11835734pjb.4
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 03:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PZi4CqOeNvJwcpNuyxij/N2/KbdgS81lWmUlVuyW0Zc=;
        b=2CD3TM4EPsEK3R1/ZxPfp78BUrK7ZKewViyjf7mqG6Q43te5Llf2ZY9s0hyKOuGAQu
         jF8+BuEZFFyOmxAtxwnKbYBBElxIIVzpHm70ZySJ53xBfmQtL7SVmjUpCvB7Vi6WpU7F
         1D9OlbtxuD5OFua8yDzfxl+5hEBDwUO78snvoAmNAq/A8F/456ENFHvk3JRVSYzwNB3O
         lzK8VWhcZiA7zlK0gV5G7dEfUmIkMACCgsNhe8Z2j2/3fyZKcI5zSY39Ae6LYk+8Lf0Q
         eR4cyNYmdF2M8yXAYq93N4kWU7LWLqY+NDf8PO+t96cwOIenLE8Abldv8xWaSeAxKkS2
         tlhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PZi4CqOeNvJwcpNuyxij/N2/KbdgS81lWmUlVuyW0Zc=;
        b=KZktu2xP0LDU0/TH3jT7i8u+YWIgbhaX//07hzGm+cT+zm0Cf84fzzITWcYROQJckF
         JF6TiuX4Upf3N2OYTCQY10QxJdUJoHPC+mPz2obJAZRYNI07Cd1Dw42lRfzl5oYdEAnv
         3HOuNF3ZFJK4ZSQQXcz9OnB4FiseCyMEPvggikwrlX+HCZ2C7jJ9m+uwX9KYJTCRWZ3w
         7BjsEf44hQjmeXWedQLtIIjWkGgZWp25Ii2FF87jmFvnOfHZDzKkyLnsvybw4cR06MWY
         h2myX87IM0rl8ts/ACWiDTd3AOnNqSUWYqGQxf7d/BZtClrD2NBwA+KmEoit5W7h8Ie1
         Q+iw==
X-Gm-Message-State: AOAM530iNv46EMgYSuiGzFUw3vA6lpD/kWzGEgySbjUJWeWt7dYdQQ19
        pVCYCJKNF9Zr7fog2VwgtoqQBuvkF8/+MnPS
X-Google-Smtp-Source: ABdhPJxnzvdrCJy0oPvk5f09aljl7L6DU/kSAFjv8PMK7jZgNDvgN2z34zSwPqLVbifFQE2hdm9ucw==
X-Received: by 2002:a17:902:8a8c:b0:13e:45bc:e9a9 with SMTP id p12-20020a1709028a8c00b0013e45bce9a9mr26902040plo.11.1634551639015;
        Mon, 18 Oct 2021 03:07:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c192sm12534073pfb.110.2021.10.18.03.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 03:07:18 -0700 (PDT)
Message-ID: <616d4756.1c69fb81.2abd9.25f2@mx.google.com>
Date:   Mon, 18 Oct 2021 03:07:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.153-35-g937fda060bec
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 76 runs,
 4 regressions (v5.4.153-35-g937fda060bec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 76 runs, 4 regressions (v5.4.153-35-g937fda=
060bec)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.153-35-g937fda060bec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.153-35-g937fda060bec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      937fda060bec916541d631ab306bf1581673cda3 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/616d0e22e36b87a5813358e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d0e22e36b87a581335=
8e8
        failing since 331 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616d09ecaefcdc66ae3358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d09ecaefcdc66ae335=
8e0
        failing since 337 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616d0aa6f863f3e21e3358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d0aa6f863f3e21e335=
8ee
        failing since 337 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616d09ed8f1af12ed83358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-35-g937fda060bec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d09ed8f1af12ed8335=
8f5
        failing since 337 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20

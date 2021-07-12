Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50303C410C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 03:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhGLBnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 21:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGLBno (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 21:43:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4C2C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:40:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t9so16625025pgn.4
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qdDixmbK57YExtU+dPPKT4WKuA6K5K+DjQHbTo7vLu0=;
        b=w9kuMiiN00x5e2C/Fd070rkCumnvzSxDpHrPw6ef/lMzLleggQwCahnIxHywK7O8F5
         l1Um9qstpfGLssT38rmJuvHAIbKsGst3/x+8MGPHFmPFz/m9Z+bA6L0ar4XUQlir32+G
         tPBuNwAcPSsq97qTJupljk2FpXYd3zqtbemxZLCvhGs4J6eeJljmge4Uww4vjVS2ss3e
         3fCsIuJjzPKjEXcyZIbDL+cxPtg08jEZBQwNsQsyoiqixRXHFZbxyZPCBfR4j0SvqwHZ
         Q79yXtBodoPqm357hdtO0rLzMd8If2mM4OMkH/coQzY56Ka0c9z9aHoj8wD3foaXLNYS
         st9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qdDixmbK57YExtU+dPPKT4WKuA6K5K+DjQHbTo7vLu0=;
        b=qQ+3ZAYu5KKs2ctREoR7yXorUIEFgv0CAcCru4/wcKd2DCcWLzb+mgUEFuIxm8dF6Z
         b/l37i97AQTZwDkbAW/hP+ISey3o9PCXILJah89gKzeSxA5Gv0TFPwmoNYmWbluBqViF
         j7Rm3wHEovibWZ0kt83bcPG7rUbGbheyYFniWyvvkZ+MGbkQdRHbbckK0RiKaCdJMft5
         ahdVaclaHco98AkIATyC/sAlE4oNVVmfWkh/IvWpAyce9kha/BphPBJyGDXq1fYTR9af
         GHV6dprLJ+VktT+tINEeTKrmkNGERie0u7fJKdmyFx3xI3FmvazZ0z37MMi6P1nnjUwj
         YCtQ==
X-Gm-Message-State: AOAM530r+EA07RtvoVCl41cX7wGh0DYWxpswF6IWMGN0M3r05owoT8fy
        jNGuw+g/qOZ1rdZcp9jEkIB8u8Kgha2dSaUL
X-Google-Smtp-Source: ABdhPJwRvgGXftLPzoN4Jz6eOfL7UqrYLiO6rHFL5hlMfSnXGEQC1LLCxZbb0x4rnWYmVEbTv0f8BQ==
X-Received: by 2002:a63:b48:: with SMTP id a8mr39796017pgl.169.1626054055434;
        Sun, 11 Jul 2021 18:40:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c141sm13854981pfc.13.2021.07.11.18.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 18:40:55 -0700 (PDT)
Message-ID: <60eb9da7.1c69fb81.4952.949a@mx.google.com>
Date:   Sun, 11 Jul 2021 18:40:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-801-gb2246d387d36
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 186 runs,
 3 regressions (v5.13.1-801-gb2246d387d36)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 186 runs, 3 regressions (v5.13.1-801-gb2246d=
387d36)

Regressions Summary
-------------------

platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.1-801-gb2246d387d36/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.1-801-gb2246d387d36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2246d387d3602b36fbe7ede74bffc7086e637e2 =



Test Regressions
---------------- =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6ad6a32f64a3121179aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
01-gb2246d387d36/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
01-gb2246d387d36/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6ad6a32f64a312117=
9ab
        failing since 0 day (last pass: v5.13.1, first fail: v5.13.1-782-ge=
04a16db1cc5) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb68de9df26bde4b11797c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
01-gb2246d387d36/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
01-gb2246d387d36/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb68de9df26bde4b117=
97d
        failing since 0 day (last pass: v5.13.1, first fail: v5.13.1-782-ge=
04a16db1cc5) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6a32e39f1afa7f11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
01-gb2246d387d36/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
01-gb2246d387d36/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6a32e39f1afa7f117=
96b
        failing since 0 day (last pass: v5.13.1, first fail: v5.13.1-782-ge=
04a16db1cc5) =

 =20

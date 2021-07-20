Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717223CF4E8
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbhGTGQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 02:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242367AbhGTGQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 02:16:17 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ED0C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:56:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s18so21651756pgg.8
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ku9Sl3A9x30+GEGe+syRrFvnrLkAePw1mOu+DVs3CY=;
        b=kU8BLS6TahX9i3iXQ4LhRVd4RUR4r6RiRUU+WozdClLJ3wNtGpgVkndChjxV4UID5X
         IJ3g5lzkg3SoRRtaeiCbGpFR7fw+tUaPUzW5PuasfqSltkTgO3JmUsu2m3E+9DgzHGJy
         Bq/KM4enP8suP9m6G7tlHLSTqsbjnhY7kDgFQXfDJW/fYYe1QbC3FVEiI0Fef2FBvyrA
         CePTQ21xuU6MwimON9YaP0ZlBUQFB8fBJBwiDUdF1qaiODHB6mwNabs/BV4PJ3Zl3dKY
         DjU7hYQez9KihYxa9K3fGTWxtDQAa/0W8XAlosRT/Fp8M/PXl4Xsqy8XtMqEIs5m6OUk
         kYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ku9Sl3A9x30+GEGe+syRrFvnrLkAePw1mOu+DVs3CY=;
        b=huzL8E+d2ApYtFJPfdTzOdGb4kFAuwIcTc9DIHD4+DwNkovYjFoV55FJwdt5AnXU3T
         3UK7yRAJi1dTqDT3drJyOs5wxObUJyhfg04PklmINy0U3TkI/McW9ZI4tsfoUGLkgQPj
         3tt2jUmj8BIT1Ap2KXon3fLV0+7Wv4l7HJhm2HeJLXqEPAFQbXMcnuyTr9GuIH8j7HCA
         dz4r2cRlxEiCeQna+VOX+KadaUsZR0fKzThRZFgTaj1Ay4EDX4EHKHBifwJWWdKqN0xH
         Icvv5aKuXsUFtwnl+KK9AwWePQSrXG798fxp/eP+3NVH4ReKNkG0FnT+lz19SswV9Ksn
         e73Q==
X-Gm-Message-State: AOAM533zwUNLaU6YDNVR37hzb9jtgSEBmt4YuKotKf/ipfyMwh3dbexM
        VwihNzgYOnAbXZd03GXE7A4Gdx8tpfOBrg==
X-Google-Smtp-Source: ABdhPJwYPEftl/IjBAyWz6cOEtR8zsyT37sb+adGCMkY7MS1aA8xFYC4a/achZR5gHZ5qtPMZZEvRA==
X-Received: by 2002:a63:7152:: with SMTP id b18mr29196408pgn.209.1626764214701;
        Mon, 19 Jul 2021 23:56:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm22057945pfl.9.2021.07.19.23.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 23:56:54 -0700 (PDT)
Message-ID: <60f673b6.1c69fb81.9beaf.2619@mx.google.com>
Date:   Mon, 19 Jul 2021 23:56:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.133-148-ga2316a5d4646
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 180 runs,
 3 regressions (v5.4.133-148-ga2316a5d4646)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 180 runs, 3 regressions (v5.4.133-148-ga2316a=
5d4646)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
    | 1          =

d2500cc               | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig=
    | 1          =

imx6ul-14x14-evk      | arm    | lab-nxp      | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.133-148-ga2316a5d4646/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.133-148-ga2316a5d4646
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2316a5d46461a485bcb38d3379b67bd37dcea8f =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60f63d107f3d6c9f8711609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-ga2316a5d4646/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-ga2316a5d4646/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f63d107f3d6c9f87116=
09b
        failing since 264 days (last pass: v5.4.72-409-gbbe9df5e07cf, first=
 fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
d2500cc               | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60f63f41de3bbfc39d1160bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-ga2316a5d4646/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-ga2316a5d4646/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f63f41de3bbfc39d116=
0be
        failing since 8 days (last pass: v5.4.130-4-g2151dbfa7bb2, first fa=
il: v5.4.131-344-g7da707277666) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
imx6ul-14x14-evk      | arm    | lab-nxp      | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f63e6e1663008d651160b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-ga2316a5d4646/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-ga2316a5d4646/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f63e6e1663008d65116=
0b6
        new failure (last pass: v5.4.132-92-gcd43e7d2a167) =

 =20

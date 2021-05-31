Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D62396913
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhEaUoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbhEaUoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:44:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B7CC061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 13:42:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so195616pjz.3
        for <stable@vger.kernel.org>; Mon, 31 May 2021 13:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k5jStgUXyf8D53JMR9Vg9CO0mUEzguJN4ZrC7RDNz9o=;
        b=cE9LHaV3DRptZ2Mhpc/m3iB+IHJ75haSMpPPKlWY7fmt9ot6mi0w921LMRv9ucaUww
         6fB7cqBikFIrfO9ET5wf5VHdFQW4O3Y5sETRQi3wekAEGMeFx4nJ1bPbj7gQKrUy7nkh
         WCCYQkhFgwkReP1Vgwn+r0I0DX+Eo6hihDy1QGGkWs2TZUMl5Murn/oiqH6lKubJZ6/6
         aAHjkfAkTkxcAyR7KAkYzM10xFKf0JJ0Qv6ISCh93yd3Zsi36/BQ4/7F5SzOscJbS04+
         q8A/AXYli2DcJI3W/xMxy8QWY4MhFIa+fvYPVrKt9QTnMpkdyqieFDGjs5NQkPzVx9cg
         0NJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k5jStgUXyf8D53JMR9Vg9CO0mUEzguJN4ZrC7RDNz9o=;
        b=ciSttoPDg6jJI1LdXDc/UuSPbVjRFCo4HNE+PHgVWofgklOgQT9jpDwnQpVGOMSYSI
         gXCbMIsvYz63Mx5CJaRdIZMw7ijSAQGY1PTFXcT915XFXDrQJXvN2xdWh9AK8BX9z/oC
         MuXTwH9d80GqS49VifsM5ntzBTpvamACdONCIdSdPrBv8rPUUTyzkEMk7XRILcZNUu5+
         fntiOEhC/a2t8kJX1FUVIOj1hUHfSsfDhKVYcZdjqmUdSl/bJfenKkPkLl5JDIUUQm9x
         4iezMiH92WeDLvPXVkpMN1wxUb9FDliHf6qnsG+aXXL0K5SLpc35ZnVH0bjLo7pvMpbh
         nQZA==
X-Gm-Message-State: AOAM5328+ZdtZsDYDM0gZSWMzfUZp0fqbP4NNBTSyhquoSOoIqKUQEQK
        cPtvqk8gCWZ5J7F52RPRSnYQyth7BRN920w9
X-Google-Smtp-Source: ABdhPJyxzTTZrJLMWjIjkVntGpkYo/7M0HkyzBkOq9Sr6nOSxqCqXfRC4U1uKJ/dpkO1Pz7k3dvigQ==
X-Received: by 2002:a17:902:be0d:b029:f9:c913:821f with SMTP id r13-20020a170902be0db02900f9c913821fmr22427349pls.2.1622493745108;
        Mon, 31 May 2021 13:42:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m9sm11520193pfh.76.2021.05.31.13.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 13:42:24 -0700 (PDT)
Message-ID: <60b54a30.1c69fb81.aa590.4de0@mx.google.com>
Date:   Mon, 31 May 2021 13:42:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-305-g327e3cf768fb
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 127 runs,
 3 regressions (v5.12.7-305-g327e3cf768fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 127 runs, 3 regressions (v5.12.7-305-g327e=
3cf768fb)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.7-305-g327e3cf768fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.7-305-g327e3cf768fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      327e3cf768fb44b16c21a0589a492bf7bccef28b =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/60b50efd90c104bc5ab3afac

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
-305-g327e3cf768fb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
-305-g327e3cf768fb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60b50efd90c104b=
c5ab3afb2
        new failure (last pass: v5.12.7-8-g6fc814b4a8b3)
        8 lines

    2021-05-31 16:29:27.275000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000
    2021-05-31 16:29:27.276000+00:00  <8>[   14.409515] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2021-05-31 16:29:27.276000+00:00  kern  :alert : pgd =3D 0cac5162   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60b50efd90c104b=
c5ab3afb3
        new failure (last pass: v5.12.7-8-g6fc814b4a8b3)
        128 lines

    2021-05-31 16:29:27.280000+00:00  kern  :alert : 8<--- cut here ---
    2021-05-31 16:29:27.281000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000
    2021-05-31 16:29:27.281000+00:00  kern  :alert : pgd =3D 42aff8c8
    2021-05-31 16:29:27.317000+00:00  kern  :alert : [00000000] *pgd=3D041b=
9835, *pte=3D00000000, *ppte=3D00000000
    2021-05-31 16:29:27.318000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM
    2021-05-31 16:29:27.319000+00:00  kern  :emerg : Process udevd (pid: 10=
8, stack limit =3D 0xd3c1c5d1)
    2021-05-31 16:29:27.320000+00:00  kern  :emerg : Stack: (0xc4275c48 to =
0xc4276000)
    2021-05-31 16:29:27.321000+00:00  kern  :emerg : 5c40:                 =
  c1820a00 eaa9dd80 c0e04248 00012cc0 c4275cb4 c4275c68
    2021-05-31 16:29:27.322000+00:00  kern  :emerg : 5c60: c01f7ef8 c0439bb=
8 c0e04248 c1820a04 000027ff 003f0000 c2d7f850 00000000
    2021-05-31 16:29:27.323000+00:00  kern  :emerg : 5c80: c021d6c8 df4dd93=
1 c0f67190 eaa9dd80 c0e04248 c1820a00 00112cc0 000027ff =

    ... (87 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60b511840c56a008f8b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
-305-g327e3cf768fb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
-305-g327e3cf768fb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b511840c56a008f8b3a=
f98
        failing since 3 days (last pass: v5.12.7, first fail: v5.12.7-8-g6f=
c814b4a8b3) =

 =20

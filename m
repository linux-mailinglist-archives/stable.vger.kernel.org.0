Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED3E280C91
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 06:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgJBEDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 00:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgJBEDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 00:03:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E06C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 21:03:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t7so72810pjd.3
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 21:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xQvenzEraMluKJjQlohZmCG1rEFGR5dR9LNgb6d1D7Q=;
        b=ARACj533HguQeAdqMHs5nr6/n1k/tUX5twcAh1fv83EgPl7aLj8NPtDuEZtqSUDlpz
         i57bc32AjncLYmd3JMyRNOGfUvtECYrIUhEQmjR/b4mUmNIUQLJV5ZpA/kGsbtIVl4XC
         IagqVxKUmPX5Tcb9f+c/crqyxbSqxVgkAfsAYMfA2C3G7Ezof76qcERA52oE1cXixePu
         Xds6c9suMSn795SREhLtjnPomvdzzuHhIZz6WRln8po71BZU1i91PwGXYJ28rm4UrMgb
         b4wfakP0CQhfzlol0SjvYEx8a9gpeB91o4ECYjzRBOO2o0GjqI35Xkl5mAlx0Kzd92ue
         geQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xQvenzEraMluKJjQlohZmCG1rEFGR5dR9LNgb6d1D7Q=;
        b=Ghj+y0JCqqmMZwd/+XAwuC7L+GdLOgFytLae+AIJcL36IYLDEUePcET03ngawXyElx
         ZZq2e3728j8W/S8wPIwCC1yBpGsRyHmi0CD1gy9erwleodrzXBTaJ+sK9etvIGBDuuE5
         xo5/F4oP1VOnrQL9LpP24gUUAzvruhyDBiH80pC51DQkyRyf78rRG288LHQngA/mGKjD
         kr6z2DTE0t1NFwaPiy92qrpgJXE4DbulC1N+sWQk55bNhzoWYpxEAhZ2KvpNDRK+mH/w
         kFAxDus9LU7P9j2z3acLl43KcHy8TXv1vPaefzTyt2dT5GNg1Ih6Kl6oXapNJ7RGu+02
         tC6g==
X-Gm-Message-State: AOAM532vEKInrojUxc5+pgUA6bCzQvTqGwAarJiIU01+KbJjxoLP+3z0
        cOjIXYD4LpwoTw/BcXESUsRdTxOQ3OCv0A==
X-Google-Smtp-Source: ABdhPJzMuYcKJSm1GzpMkOYkdgQ0yO2erFMr2nRZsbrHxEvCWvYtjkMiBSvpKltA3DavyGEj8LQmQg==
X-Received: by 2002:a17:90a:a09:: with SMTP id o9mr601867pjo.134.1601611428858;
        Thu, 01 Oct 2020 21:03:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s20sm126978pfu.112.2020.10.01.21.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 21:03:48 -0700 (PDT)
Message-ID: <5f76a6a4.1c69fb81.3c424.05a0@mx.google.com>
Date:   Thu, 01 Oct 2020 21:03:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 131 runs, 3 regressions (v4.14.200)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 131 runs, 3 regressions (v4.14.200)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.200/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.200
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bae31eef2a167ef160ab2703b6a2f5bbecd98d92 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f76735c5b7a1ef06387717f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f76735c5b7a1ef063877=
180
      failing since 69 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7681face6f0c0c7e87718c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7681face6f0c0c7e877=
18d
      failing since 184 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7673c189c3e20b2e877184

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7673c189c3e20=
b2e87718b
      new failure (last pass: v4.14.199-167-g7b80cb61f2b2)
      2 lines  =20

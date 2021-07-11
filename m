Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D4F3C3DB2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhGKPom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 11:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhGKPom (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 11:44:42 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CC4C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 08:41:55 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n10so543451plk.1
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 08:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IXGhrhnp1MrSKBpzmh8vNKzSE2mkptf6L8HZeO2kBiU=;
        b=KVtE1NgSpSHYTnJCXERV6y5CJLgx2qV0h0/qUJJmsjdy1iR5eSrD796EmUwhQCieVt
         Zk3AQCIe+Qw6sQbT58XUz/BahDkBVxbRG2kqCWhMwU9Bin4by0K/fq4swuffxryMioLD
         rcN++WM7h3JVkuLFqyaHKFFFA3W5yPui7x+XvignjKGJCSwUfioAoLlGuDxKaSvw0HU6
         FtVXenWVanYc8oG+Jx0XUhif7armosIFbmhmZZ8SxZPch8AbvQy3ABcnDjjrg6fgeVHs
         r0L+P6xsso88BnS5cVM9r+JiHHRwwwb8z0XLdH0g82xchUDsFzx7XNnvaKqSRFI6dC7V
         UvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IXGhrhnp1MrSKBpzmh8vNKzSE2mkptf6L8HZeO2kBiU=;
        b=nV2Kl3Qf62gFiIC8vcpoTrTL97QGl+Moy1u1/gYN3IV5orlVhX2/GK/msZix/jcIi5
         auKTEpOsOG9dby1ADgp/fYysQuQGoHgEWR+jOmDtzYiJdhFPWvWQWrp8PU3fbIssxdvi
         9A0YeXQkaIjy6flDjq5w1xw4z+0OLLW89FaNAdbWbBSKRqcFnBVxgB1aUQgnFqvTPwd9
         zY87aATzM35PdfvfpGsjf+VwP8yxSa7d9xNmF8a+Xz6kx2wblSP6GRD+mDM4cKg68uxQ
         h8MprebPmqZSGyY1+A4DucSuyahqsB2g+hHyjBHfyRt7Mag8Ey5bR9E0IAwZXrPihxpp
         eLcw==
X-Gm-Message-State: AOAM531017JcUvSPrGh6FolJOAW36qQGw0xLcdCrXcXnkp+a1etmc9ff
        Dv0u6QNF+Mo0bK8O2BXtgP8CJPrRVN4DR2xE
X-Google-Smtp-Source: ABdhPJxWNG+qo+HoCXAsHJ4AqI4+rdRLEFxjl0HuB/y0rH5Bt0R7dkdgGkY+c2ZWzl8c1TLBXeq6wQ==
X-Received: by 2002:a17:902:c643:b029:12a:e698:f74f with SMTP id s3-20020a170902c643b029012ae698f74fmr9479929pls.60.1626018114110;
        Sun, 11 Jul 2021 08:41:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ca16sm7826546pjb.44.2021.07.11.08.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 08:41:53 -0700 (PDT)
Message-ID: <60eb1141.1c69fb81.baef.7664@mx.google.com>
Date:   Sun, 11 Jul 2021 08:41:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.275
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 124 runs, 5 regressions (v4.9.275)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 124 runs, 5 regressions (v4.9.275)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.275/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.275
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e0c3e706e94deeaa75c5f9fb91cd24b3c71b4793 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eadc815ff6005e46117989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eadc815ff6005e46117=
98a
        failing since 234 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eadc7e5349794df7117983

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eadc7e5349794df7117=
984
        failing since 234 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eadc8c4321d5efc2117990

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eadc8c4321d5efc2117=
991
        failing since 234 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eadc2828eb9bfcde117985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eadc2828eb9bfcde117=
986
        failing since 234 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60eadd887ce9363795117982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.275/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eadd887ce9363795117=
983
        failing since 234 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20

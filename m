Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1C43B7CD1
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 06:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhF3Erk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 00:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhF3Erk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 00:47:40 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82D1C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 21:45:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j199so832866pfd.7
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 21:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kTGvoAb49O7YAn3QNPvVf7eWsv3yZ6s7Van8C0UcfwE=;
        b=vmIkA4pkrXLpLxg58fr5BG+1s7cAnJs3UJYOKHq3kRu9s//dxxAAbzN02mZA5fo7N/
         gmQXUlq7PPrEFnlye4jQkKIuKiAq9/UEFdPBkl+Ur8FnOgfDMW3z4jAKN8of9Cju6cQd
         L75RrWVIJTIhqyCDvy0f/IuExq2yzxIZk8HusYQ0vTO4PPQdEBuMbjk3ZJd+Aa6/ylJJ
         vZalwfMZRv6kh6Eht9xLiglQm0u6h5tE6LAej8CpGEdeI2ar6tyPuNgBkueEeL++NkDO
         bKb8KfRn1B0w+dBHL/Pd+TZZJJjFUmdxk3pEC3cZH9s9o+S2rDM517lx9DnGR6qJrE8K
         OwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kTGvoAb49O7YAn3QNPvVf7eWsv3yZ6s7Van8C0UcfwE=;
        b=hW3xqHZrkUJIOCx8ClfOYC4JQ+cF/YyOJ7siF3CwS+Yuso648knmTXvrOTE3YVZq7A
         1AE1trwyWAQDDtgkKIFYIIcgHnnwNbeU2cxnj8paGusr9N+GYdbtGYw16wXaafsrNTcz
         HQEVoEJJbC/Xv+ucpYNemoXelzy8Mxfu0PZEhIehtIMbZwIIVePb85LE/lTh4K4ye1ik
         cPa3BUaRULnMLN6bSB3Cj3rxs29a2CZ2jFvBdvfoHEGPk9CsDtqmz2Q0fziKFiymPW9Q
         TmuOTX9nbOMGAuiVp1WzdfgzXpo3dgkzepBDiOq3d6U6InrTn8itBpp50k5kSN8Okwgm
         ivfw==
X-Gm-Message-State: AOAM530mvDuK15E56fwYRa9MQhc5n6d7u4qN+6bbqpfwNLPWRbXCGctz
        ia/iKYILqVKXEl/2VIoK/7QhSmc2ydanmJdV
X-Google-Smtp-Source: ABdhPJz6I9fpkqslUn1AnxXs5IwZC+UhBvmNrWILV+S6thsBtIu9tqEu7Uaso0ua9ULSXwxn0eykkA==
X-Received: by 2002:aa7:8e18:0:b029:2ec:a754:570e with SMTP id c24-20020aa78e180000b02902eca754570emr33597807pfr.38.1625028311269;
        Tue, 29 Jun 2021 21:45:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm7840332pfg.216.2021.06.29.21.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 21:45:10 -0700 (PDT)
Message-ID: <60dbf6d6.1c69fb81.4d3cb.7bad@mx.google.com>
Date:   Tue, 29 Jun 2021 21:45:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46-100-g3b96099161c8b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 162 runs,
 2 regressions (v5.10.46-100-g3b96099161c8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 162 runs, 2 regressions (v5.10.46-100-g3b960=
99161c8b)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.46-100-g3b96099161c8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.46-100-g3b96099161c8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b96099161c8b15af2cacdffcc1383e09859da0a =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60dbc2b661fd86023523bbf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
100-g3b96099161c8b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
100-g3b96099161c8b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dbc2b661fd86023523b=
bf8
        new failure (last pass: v5.10.46-100-gce5b41f85637) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60dbc63821f619447423bbf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
100-g3b96099161c8b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
100-g3b96099161c8b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dbc63821f619447423b=
bf9
        new failure (last pass: v5.10.46-57-g54dbb0e69e1a) =

 =20

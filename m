Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4ED34283F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 22:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhCSVzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 17:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhCSVzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 17:55:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ADCC06175F
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 14:55:09 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 11so6816915pfn.9
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 14:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/0Q4nMud2vZdLzzdmCfvZv81ejSUc2/rB9QCdjhEHDM=;
        b=ymxTRDUXqFgKn4qBKzLH/r2TKFtaiUz9t33exlg+GXV64qfxOW8QEqPN8Lfi3mXLRl
         ujyM8DUot+n7k7rVFBlVXNMhomz4Pl1zWwGuHi+L7LmlIhoZzL7/N8wysHw/pe9TGzNX
         01f9/GnI4KOIDCwmWD2RYVtpy7cC+9PAN0SkXlIo6KfDPrb8/Pfcy6+NKiVRpyCQial2
         3eSxCPqQDpWaj1/8DiMfP0i19sQQqEE2md/e2lhrWhCyyuYPzIvzkv5vyOO3EGJUA6F6
         AwJ+ZfXWs0lWLun771ovRutq2jEyd/BhNopv03elxyvu6pua6wT81H0uB9Z6qpTJtIh0
         MetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/0Q4nMud2vZdLzzdmCfvZv81ejSUc2/rB9QCdjhEHDM=;
        b=i/PfOYb0+27Va58JMMHXyT7OcVefDyQMOTxYM/kmRz6WMi56TljDjcE3P+NJj7aLyr
         xMyAPL5/oxrpvnfk6fhA17Py0VlnHZFl5dYW61Xi2m7yRavpIB+JQdgeVOenUZZRpE+B
         7dQbaRZo3yety+yLioNCryNkxRbpIjHWp1xC2mBEwMZz2GMOmgmQxwqwC3Ni2bHZn9J5
         abgx2Z2wJgO+c8ThnQv11DXW3t6lk4bQMz1YxPAPzaYQ755wg9C1QzImreBJywQ8ypgi
         z/8YHw5OyJq4e+g3LhJWsbHKh1sqEK/t4G7WxYdrssznUvzf+oJUOizPepNixqwswE+Z
         vbwg==
X-Gm-Message-State: AOAM531Oz1SHVYBkoCNIlk65sLGeCAjnFsjfTNvMPCrurXV1bq/3NTov
        mqaWwMjoECl6R9kyyBC2gy1yq68wq36nmg==
X-Google-Smtp-Source: ABdhPJwkDdeOyUX0mfJ4MByNdHZ5//Szv29RKarcKR0oLN4739nSmSbOQkEmTNchWp6L2htpbibtOA==
X-Received: by 2002:a62:447:0:b029:1ef:174b:a242 with SMTP id 68-20020a6204470000b02901ef174ba242mr11044659pfe.28.1616190909365;
        Fri, 19 Mar 2021 14:55:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ms21sm6345421pjb.5.2021.03.19.14.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 14:55:09 -0700 (PDT)
Message-ID: <60551dbd.1c69fb81.ad33b.fe3f@mx.google.com>
Date:   Fri, 19 Mar 2021 14:55:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.24-13-ge91220a40f8da
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 3 regressions (v5.10.24-13-ge91220a40f8da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 165 runs, 3 regressions (v5.10.24-13-ge91220=
a40f8da)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
   | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.24-13-ge91220a40f8da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.24-13-ge91220a40f8da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e91220a40f8dae85837e99878d5e82abc466aff9 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6054e9f1de3c363e48addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.24-=
13-ge91220a40f8da/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.24-=
13-ge91220a40f8da/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054e9f1de3c363e48add=
cc4
        new failure (last pass: v5.10.23-289-g9ee0b4dbbfce) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6054ead4f06a2228ffaddccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.24-=
13-ge91220a40f8da/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.24-=
13-ge91220a40f8da/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054ead4f06a2228ffadd=
ccc
        new failure (last pass: v5.10.23-289-g9ee0b4dbbfce) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6054eea365c8a52820addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.24-=
13-ge91220a40f8da/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.24-=
13-ge91220a40f8da/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054eea365c8a52820add=
cc4
        failing since 2 days (last pass: v5.10.23-289-gb6c4038ab5994, first=
 fail: v5.10.23-289-g9ee0b4dbbfce) =

 =20

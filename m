Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA37A56C46B
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiGHWD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 18:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbiGHWD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 18:03:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE90D5
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 15:03:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so3218547pjn.0
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 15:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Aes+fR0EuY/zbwujPjt2NdzlG2Ww7/3kcTKyyLLVwi8=;
        b=1PZZOd0vpXjdIIS+1pZLu0r5+XO5MRqt5XWeJgd/8DjyQkxHBqzxK6kL2sdMU7woGn
         QQxWl3I9blj7VbJTqXdMgmnVvCSkrHeOhN9qeay/mgpoXusF2SW3CVudOATZDpKGiJzU
         Cly7495uirAkGoIILZPBNb8MrctUZemEKWl0eSx/XDIfcoyutjos/nhHDyJlnggxFVA3
         M2evLeIq6eZc5+7NNLsk5zQ6XGRAK0Yflb59UD4y/tlX6g15Z9wt2m/sO+UK6k+fva/O
         den0CTw6f1Xxb8mfgyPO1P5qt1na+BPoN7s2d1mW8NMgCYiYyvhzZ7YHGO+94loEzEV9
         /HdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Aes+fR0EuY/zbwujPjt2NdzlG2Ww7/3kcTKyyLLVwi8=;
        b=hezmcX/A8E3bOlTMvRhLVrJnMIL7EhP0quUZgflWELr3gSTrLwJwvfLJyAARNJzigV
         zHTNpotU3cwPrXpL8rL9uLUuRtm9tIeErf9ZPW91tISeUpeO/eoCInEI3mTCke6VOB9L
         2NQzAedzK3wbBchkCc7OKAm1EiIWZL/UF75JzHtgwFSrcMXUhTWYsvXVaK2IgIrm+b7E
         lElRHy3oJwjSjDVkPgeXf+wR80lILh8gfuntFmUqbDq5pTtPrZgUY8jKD6c40h63l+PN
         h+NWLM8cXg+PQD+O4ClUj/d/AvNjlLplbopG3udYdqiIDXhZ4QbJihYZHsKFVKIRVs6V
         m9Sg==
X-Gm-Message-State: AJIora/nRxfFBPtdqhjUMX/SaiTZNl90gsrJv/J3/oWpI7NEZNIlpM6L
        tCbrtLIncnCV5gaWk2dVYUqXhqdLgvJTL+if
X-Google-Smtp-Source: AGRyM1u99eLxgA1cXjUNv4sr7jB/7VwG1DoFdqDX5SooutphCIBXEkuWAS85CqDlcWft6Y1lgVTzNw==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr5818643plg.11.1657317805548;
        Fri, 08 Jul 2022 15:03:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12-20020a170902714c00b0016357fd0fd1sm21262plm.69.2022.07.08.15.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 15:03:25 -0700 (PDT)
Message-ID: <62c8a9ad.1c69fb81.9ac25.00a1@mx.google.com>
Date:   Fri, 08 Jul 2022 15:03:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.10-27-gbe5c4eef4e40
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 175 runs,
 3 regressions (v5.18.10-27-gbe5c4eef4e40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 175 runs, 3 regressions (v5.18.10-27-gbe5c4e=
ef4e40)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =

tegra124-nyan-big  | arm  | lab-collabora   | gcc-10   | tegra_defconfig   =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.10-27-gbe5c4eef4e40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.10-27-gbe5c4eef4e40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be5c4eef4e40fc0dd424ad7af132256f4e29b723 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c86c9ca4da546cc1a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-gbe5c4eef4e40/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-gbe5c4eef4e40/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c86c9ca4da546cc1a39=
bda
        failing since 2 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c86bb294342405f8a39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-gbe5c4eef4e40/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-gbe5c4eef4e40/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c86bb294342405f8a39=
beb
        failing since 3 days (last pass: v5.18.8-6-g365d872fd167, first fai=
l: v5.18.9-96-g91cfa3d0b94d) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
tegra124-nyan-big  | arm  | lab-collabora   | gcc-10   | tegra_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c86e8ca83f0047f7a39c0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-gbe5c4eef4e40/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-gbe5c4eef4e40/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c86e8ca83f0047f7a39=
c0c
        failing since 10 days (last pass: v5.18.5-141-gd5c7fd7ba94c0, first=
 fail: v5.18.7-181-gcfa4d25e33d8) =

 =20

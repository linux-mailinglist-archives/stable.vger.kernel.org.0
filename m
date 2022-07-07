Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8FF56AE19
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 00:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiGGWHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 18:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiGGWHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 18:07:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819E75C967
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 15:07:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w24so16498427pjg.5
        for <stable@vger.kernel.org>; Thu, 07 Jul 2022 15:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q3EVo141Ck91vSuta36SQihb756iAPM6+iQ/Rf9WiKE=;
        b=xLX8tzu3JSpAlMBFIlIXjTDJKPW4MS+FtmDqkZzETn6MwCRhev8GBc3VBhDyuSAI3O
         Oku4KAiVg+6NZHjHsubRF+bgmaeXKJ9GsOkHYisyG25nhxfJZGON+6FKBo4VqEZIaDFB
         QwFkXB9APGHdEVM/L7dWtpWOFNV23jTTyZmr1nqe5xTGqAARuvYHph6QlfzwQxyQI4MG
         gaws11TlPlFv22V1Fah5tWEW+GNlCvtKjty+K71RYWpBbG0nYxQ/Sn0uYhR/eBym5AzP
         R5VHnpPAjBFwOhNHDviuvRIzY/vXp5+ztz9n4Jz63xzZ5Xnwc1sXP1Ua2TrJYEHmw+lc
         Fpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q3EVo141Ck91vSuta36SQihb756iAPM6+iQ/Rf9WiKE=;
        b=IHSQcliL2jE1Om4H3ONGJ93hhp6Pf3yHQaMzApYPQhbtvo2ZY7HEKwMOMKbP6/ruDB
         BwF034d9oefBwJ9H2WLikst3xat4TlWZnLOroEwcWsxbLqmTaWQAqKGhFABv2W3usdC3
         4KYlA3oSKHvMIIz2yGaA/eAj1pAir/guYc1RdJtHYnhoAtBnVfSQ18OnzRYxnn50PVsI
         X40dpaAjIgScq2u/wtVfM+7QLDcjOyUBH5NR9c9vCWuQJ3YqhQ+/5RXqPxY3lsM+qFJt
         zrxO/v5rOpWdzNNwvD0f9vl+F8yTWnTKaE3Gx8+YNvo3HuKaVQq+XwoICHarLkiVuzn5
         MXwQ==
X-Gm-Message-State: AJIora+CvPFi4/1ZGyPP4WXybuklkRwyQuT3XmP79+ckeZ0eh9uLUAmZ
        lWOHk6FtXqDJAV2mYM6IJOC2++oIm5dSETUN
X-Google-Smtp-Source: AGRyM1uXBXEch/n17qwHXlMZuGmYj9pmy1aCB6YjqJw/AXByvWn/Y4qWc9zkKIs3K4aXhnoulkqADQ==
X-Received: by 2002:a17:902:db11:b0:16a:567f:12aa with SMTP id m17-20020a170902db1100b0016a567f12aamr183961plx.172.1657231654887;
        Thu, 07 Jul 2022 15:07:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0016bdd80a31bsm10563027plh.218.2022.07.07.15.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:07:33 -0700 (PDT)
Message-ID: <62c75925.1c69fb81.2355.fdc9@mx.google.com>
Date:   Thu, 07 Jul 2022 15:07:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.9-102-gd7e2eda0e762
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 192 runs,
 4 regressions (v5.18.9-102-gd7e2eda0e762)
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

stable-rc/queue/5.18 baseline: 192 runs, 4 regressions (v5.18.9-102-gd7e2ed=
a0e762)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =

imx8mn-ddr4-evk    | arm64 | lab-nxp         | gcc-10   | defconfig        =
  | 1          =

jetson-tk1         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =

tegra124-nyan-big  | arm   | lab-collabora   | gcc-10   | tegra_defconfig  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.9-102-gd7e2eda0e762/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.9-102-gd7e2eda0e762
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7e2eda0e762c4686b6950b290ed55682d1ba972 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62c73e3f6398375f3ba39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c73e3f6398375f3ba39=
be8
        failing since 1 day (last pass: v5.18.9-96-g91cfa3d0b94d, first fai=
l: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx8mn-ddr4-evk    | arm64 | lab-nxp         | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62c726a552818d5a58a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c726a552818d5a58a39=
bda
        new failure (last pass: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
jetson-tk1         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62c74087ad8023e4b3a39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c74087ad8023e4b3a39=
bef
        failing since 2 days (last pass: v5.18.8-6-g365d872fd167, first fai=
l: v5.18.9-96-g91cfa3d0b94d) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
tegra124-nyan-big  | arm   | lab-collabora   | gcc-10   | tegra_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62c7452161c0947d11a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd7e2eda0e762/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c7452161c0947d11a39=
bdb
        failing since 9 days (last pass: v5.18.5-141-gd5c7fd7ba94c0, first =
fail: v5.18.7-181-gcfa4d25e33d8) =

 =20

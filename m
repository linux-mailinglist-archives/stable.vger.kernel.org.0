Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C7036DC4E
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbhD1Ps0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 11:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbhD1PsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 11:48:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AD5C0612A5
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:45:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b21so4563415plz.0
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jqSGA5DUomhMnoyO16knfeCTG/v1U37s4AZTgmvlIyA=;
        b=lqj7ioOdzr9aozbbi4Rs2wGFKI1ocOvN9c3/qFDaGTQeFjLcPjOcgVUy0owlow1hpO
         dwLIDUpk1QxUeTQTnr8BqwZUkkNwhdIHtANQ272kejlcU1lq1TjMRZLpLSOuDIhaMtxZ
         cTGxZMr5Vlq22DGbuT+nuxF+74WDpLWACDo9FlLw6ydDV5y/B+XEjqtbdtwMyypQPrif
         Md53q5V3pzjYw/QBu+CgUHTXZmUK0hJU8O2Jl5bsHQoOx6859LOyUi6lqhrybnAkDKOq
         eMNMXSd+Vafqz3/WUt1z+iPGyPOA+TjL360zLnpA3fyS5dnHewo9T3RXcQiTob6hqEPX
         3rxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jqSGA5DUomhMnoyO16knfeCTG/v1U37s4AZTgmvlIyA=;
        b=HIqMDA/6hWyRxIoxE4WSmeZlfHeg4v1BbL3qDrjPftakGqq4NgbklErNj/C0RfH6rE
         csUzNH95CLebUMxDcWdAik/mBYyGiyCfUlQtEjSStsJMY++bLcd1opvaJpeT+GMMnRYp
         IKjD11VL4ddGhXm2SIVkRk9Uh81HMKYVCfgx4q5CrjPRNNXKj0iGSI6sYzj1nz+sUjqe
         6fvm+/jUL4jz5O/4GNPvRNCiBCHgcfHvWkZ88QW6fbSChUj5efrfHJ6g47EPVJcj9W69
         LhzRO3Fm3Q/xORy16Hojs/8ELk7ZGBbDOILnnI1AXQYJAWYECBdXVVA5UBENuhEQvxx1
         XAiQ==
X-Gm-Message-State: AOAM531Dn5O8NYJgoh1iKpxCjxgf5V1q+mTr+Sc6LEMwJUC/T7QD61YK
        ffdnoosocEHA6bLQTVfzgbna3BVtzdODR8sl
X-Google-Smtp-Source: ABdhPJy7KBPjFIpR774c5LPF+IU/1Pj6Wv8KAmUI6pgnjW+UiOXygF/9ERVsylgJ5QPO+WPUurBu2w==
X-Received: by 2002:a17:902:d4d0:b029:eb:59ea:2f32 with SMTP id o16-20020a170902d4d0b02900eb59ea2f32mr30757487plg.58.1619624731521;
        Wed, 28 Apr 2021 08:45:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm118149pfc.186.2021.04.28.08.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:45:31 -0700 (PDT)
Message-ID: <6089831b.1c69fb81.bfe51.06b9@mx.google.com>
Date:   Wed, 28 Apr 2021 08:45:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-38-g15cd8ee5df5db
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 2 regressions (v5.10.32-38-g15cd8ee5df5db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 132 runs, 2 regressions (v5.10.32-38-g15cd8e=
e5df5db)

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
nel/v5.10.32-38-g15cd8ee5df5db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-38-g15cd8ee5df5db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      15cd8ee5df5db333377eb19ddff8ffbf0eb391f0 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60894cbc13e3be43d59b77bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
38-g15cd8ee5df5db/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
38-g15cd8ee5df5db/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894cbc13e3be43d59b7=
7bc
        new failure (last pass: v5.10.32-38-g6794b7417781) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/608950bea890ca75c59b77b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
38-g15cd8ee5df5db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
38-g15cd8ee5df5db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608950bea890ca75c59b7=
7ba
        failing since 2 days (last pass: v5.10.32-12-gd2a706aabb95, first f=
ail: v5.10.32-35-g413e8e76f9149) =

 =20

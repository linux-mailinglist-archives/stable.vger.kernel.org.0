Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33983D96AC
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 22:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhG1UZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 16:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhG1UZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 16:25:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE47C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 13:25:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso5790266pjf.4
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1pao3yV7Eep6QeirEmACJ3y5jxte52h1LXOw/pBgSFQ=;
        b=kDLztnJIP1hPEFiA02gJecmc1R8JTcDwpFTTZwI1/lPq3FKRo2nX4pBbigEjTrNOy5
         PXebelJr8k6x0SWnT7ehchL+H69zJgPzERI3DmLrxBGWReUVIDCYDSLyT/ZDJfejEnsh
         +aPRirnU1oExoAI3mRXxdiBTGP65dkKg9ZW+Z+8+4hDMRvqy5p95jz2ESprMw1noZEFp
         BWvpgL4Bog81Dts9zdspCX6DUkOf+EM85rDOrVQn2p257htzdjj8Op1pZI10A7BTzd9A
         hR0ypwRtRJ+xhXg6KJUfMdqbUwo7TD2nR5X2sl3ggnizshyFuX32YaXf7FSZHO6diStV
         Xudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1pao3yV7Eep6QeirEmACJ3y5jxte52h1LXOw/pBgSFQ=;
        b=ksx/pUIHEfWJCU/VQFHaqkfRuQ1i71u+hoAv6NpNDmxvjgMdvu+PVFstxRePxSiWB2
         CsTQcj9cOvQ/CKkzD89rRWZ0fDTD/LfVcvWnOO443MlCG9n5ULJWGzbI9Gi3WYAQW58A
         /QOWw1KIvRm/1dFwU7zyhA9BjGYTzgMUIQzBxnNswGQ1Ga9TMdndAc1b/+J5fZU620iL
         jKcFydx+9dI9PDWMpFF9n5lPegjn6ZjxDM9kadaOGqdY1k58N6EpWvESI9VlhYYTh01d
         lECAc1JIgefDSWhZ6bJCm9NXGpgFkn47qIkPQir/xBoUVJzXBdhuT3ZjrHZQq47GEGc8
         13uQ==
X-Gm-Message-State: AOAM532HGS41UPXcO1pyLPh/5nfkpqeTdMOiACl3SwL/g47q07IUX5C7
        3jVvt8phHPlLbKaAoFHdfD4A8CJs9Nr4qNjp
X-Google-Smtp-Source: ABdhPJxMNzeqDtzeb2onLC5ZMJL8fk5pqz6NQUIj7EgilZ5uSd6PmJDnBJBZehYklNIlNNWMp8WDaQ==
X-Received: by 2002:a17:902:e04f:b029:eb:66b0:6d08 with SMTP id x15-20020a170902e04fb02900eb66b06d08mr1410016plx.50.1627503931074;
        Wed, 28 Jul 2021 13:25:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d67sm909224pfd.81.2021.07.28.13.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 13:25:30 -0700 (PDT)
Message-ID: <6101bd3a.1c69fb81.d295c.3b69@mx.google.com>
Date:   Wed, 28 Jul 2021 13:25:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.5-223-g3a7649e5ffb5
Subject: stable-rc/queue/5.13 baseline: 157 runs,
 3 regressions (v5.13.5-223-g3a7649e5ffb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 157 runs, 3 regressions (v5.13.5-223-g3a7649=
e5ffb5)

Regressions Summary
-------------------

platform      | arch  | lab          | compiler | defconfig           | reg=
ressions
--------------+-------+--------------+----------+---------------------+----=
--------
beagle-xm     | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1  =
        =

imx8mp-evk    | arm64 | lab-nxp      | gcc-8    | defconfig           | 1  =
        =

r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig           | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.5-223-g3a7649e5ffb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.5-223-g3a7649e5ffb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a7649e5ffb55a745030b7db8ef1db95ce99aca9 =



Test Regressions
---------------- =



platform      | arch  | lab          | compiler | defconfig           | reg=
ressions
--------------+-------+--------------+----------+---------------------+----=
--------
beagle-xm     | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/610188b5d2ad58f26e5018de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
23-g3a7649e5ffb5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
23-g3a7649e5ffb5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610188b5d2ad58f26e501=
8df
        new failure (last pass: v5.13.5-224-g078d5e3a85db) =

 =



platform      | arch  | lab          | compiler | defconfig           | reg=
ressions
--------------+-------+--------------+----------+---------------------+----=
--------
imx8mp-evk    | arm64 | lab-nxp      | gcc-8    | defconfig           | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61018738bd5534f3875018e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
23-g3a7649e5ffb5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
23-g3a7649e5ffb5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018738bd5534f387501=
8e8
        failing since 1 day (last pass: v5.13.3-506-geae05e2c64ef, first fa=
il: v5.13.5-224-g6b468383e8ba) =

 =



platform      | arch  | lab          | compiler | defconfig           | reg=
ressions
--------------+-------+--------------+----------+---------------------+----=
--------
r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig           | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/610185fd7e8ff45f585018cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
23-g3a7649e5ffb5/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
23-g3a7649e5ffb5/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610185fd7e8ff45f58501=
8ce
        new failure (last pass: v5.13.5-224-g078d5e3a85db) =

 =20

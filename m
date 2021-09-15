Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A939F40BCE0
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 03:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhIOBFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 21:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhIOBEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 21:04:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEADC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 18:03:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d18so544649pll.11
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 18:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HxGoIozf0vQny6RhrZc09XjK+ISHvXczAHcDHVquXOU=;
        b=khWuN0yZhjyKGEiKTgeahU7YS/fSJ3WJAwh6ElEpJAj7KxRDxZ0KuF7JYavKeorSGy
         ppVvWdBHfv+G/Hm3F22mr08HSUIXJGl0q7B3pGpIW/N9B4Vozq8IYq/Y/WX6AmlV03GD
         /M/7COQxLSeTqD9fncjr6n4fjCtUQl7yV7icpUuAi/MRWCVEXrVIko011u3iaVAQZ0/n
         bJfcFi0OpsFWCk+u1IbAMEC3P9PbVEx25BnQLEXtYSveV1PxWUX3shOWusuYdA6ol/7r
         aMEasTDAw1ZEWkxVHh3KO7xx7F73paHgKotc28ZGvo2KewXxhhV3zoUt9orqm4ZfG0mC
         xxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HxGoIozf0vQny6RhrZc09XjK+ISHvXczAHcDHVquXOU=;
        b=l4ig37inVzsmIj7QRvCoRCrrzWG+mwY8Ar+EyV4OHSJoZhLOkI0HJgOTOxN4hFWH4u
         NP1phfE90OFs1xHprZtuy+22RgyvkJ1CRK0WAG0v+kq7+fP36P2druf9fLGt6Wl5ii3r
         i69lX/GpIcKa5pY9Wo0AytRyi9Vhpx0skd4DO5l0xMUqCOR11rR709KuPHBDmelVJOEd
         EIqC0YbSxlLPN5xG/4Oyd/UJhD0vn6xc2lKIeGBN97KEPAC91HzR4lSzX36I6pCVvQLL
         52yzTptWGmYlILMLaWvMaZewWIhOeUUlqyAzFJ3G/LSBUAPPrfG7HwD9Okiy0BnQDU5S
         cJlg==
X-Gm-Message-State: AOAM5306URFTHG05l+NqWHtEkFtYNU/RvtQjzr24ZHaB4nZ+RLTvgPl3
        QqZGVCy1rA1XeCPzvZDfPBrYMQsZN06d9cbv
X-Google-Smtp-Source: ABdhPJyAw8DF2T3xDcGHHrJFN+qUD/yOyc56v6CBxatFVSM21gsHyjbqhr4MiBGAZklj5aWomYVFsw==
X-Received: by 2002:a17:902:d202:b0:13a:709b:dfb0 with SMTP id t2-20020a170902d20200b0013a709bdfb0mr17454047ply.34.1631667813188;
        Tue, 14 Sep 2021 18:03:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x8sm6784411pfm.8.2021.09.14.18.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 18:03:32 -0700 (PDT)
Message-ID: <61414664.1c69fb81.44a89.66b9@mx.google.com>
Date:   Tue, 14 Sep 2021 18:03:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.3-328-g86b6bc3e3300
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 192 runs,
 2 regressions (v5.14.3-328-g86b6bc3e3300)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 192 runs, 2 regressions (v5.14.3-328-g86b6bc=
3e3300)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.3-328-g86b6bc3e3300/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.3-328-g86b6bc3e3300
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86b6bc3e33007c57ed19fcfa9063771af4b348e1 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/614113eadd9b017cb899a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
28-g86b6bc3e3300/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
28-g86b6bc3e3300/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614113eadd9b017cb899a=
310
        failing since 4 days (last pass: v5.14.2-23-g1a3d3f4a63ad, first fa=
il: v5.14.2-23-ge6845034189d) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/614116c150c469e2fc99a353

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
28-g86b6bc3e3300/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
28-g86b6bc3e3300/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614116c150c469e2fc99a=
354
        failing since 1 day (last pass: v5.14.3-294-g9d35f37c1067, first fa=
il: v5.14.3-334-gea4f8a6d7906) =

 =20

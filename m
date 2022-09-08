Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A7A5B216A
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiIHO65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 10:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiIHO6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 10:58:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BD411C7E9
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 07:58:54 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id iw17so11504723plb.0
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=lmwEyOI4zFz1V3WDPF8j537ut8E9DKokzandmxFxuCI=;
        b=llGolAsv93TYLXvhUOUP1b2z1hajaHwSvFup6Q/BUEd5lMkBCCepuOK7wh/AlpCDDX
         hqaZaPPpTwbjMJsZfsMjmVLxvSVV6TQnRxDiqU49qsnFpajrh+H6uKoEZo5deRJMJ+V7
         3ymI9I0cJckxH7AwTR3S+HzNIyaYxtLAq5BrgR021PMKBohhr8RSL+9gPjPAn8u5QK4d
         sRZIm2LZTkRI6dIwOrLg+epPCVIBoei2XFjnwXfV+9ISS7lD0GG5EfMeOBTDFHJGzFPt
         OjF+Yo7Mjk9hVZJXHTiY33coLGljjFIj1SAwJUQvSLbLzsY/FQgEwjA7tz1RyKmVuflM
         T85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=lmwEyOI4zFz1V3WDPF8j537ut8E9DKokzandmxFxuCI=;
        b=n7m/Kd4nwMYJU46FFkgk5ID3gjGpUB15ANG1NNCCVta+hPlPM/uP2UObXk2IAzv0xF
         75L5zP0A5YDDmkdjLCVrUJkNpOvnUhP3v0XdHGRCPHAIIICOpRW1miJlF5EojFVlbsDj
         QgD2yxMKxPSiPgrp3DVrM/K/SFckmW4mQmuDL9Umj2qRu3aloz2oqDODwTaK+wmuIQBB
         fEBLtUOKS0JAg36qFCHWEvnBTRDJYvXvFzahCVwO9TdguDA6yz4RslRdjk+OneirejL3
         u+fSLBPjsjAVlHZA7dAGBiscs3z2L8d7S8rcTRXZz2YnLsu9PFgxXdKRZ/AY/W8moZnI
         7BKg==
X-Gm-Message-State: ACgBeo2maEv3swI2rpTneMJgJsxk/I9P33OgheUS2nQqOPYnNAcPHouN
        GTv3CEfRky06GrUgSRNA68QUhQ+lAVSaurpFTQA=
X-Google-Smtp-Source: AA6agR41Ovroua7h7rztspIDFWd+/wKo44sLhf/3YLAmHZAJ/R3mk6rLpg2clAM/EAlYrcC41hgZ7A==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr9377201plg.11.1662649133817;
        Thu, 08 Sep 2022 07:58:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 67-20020a621646000000b0053e2be5605dsm6593600pfw.214.2022.09.08.07.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:58:53 -0700 (PDT)
Message-ID: <631a032d.620a0220.3d9d8.b0e5@mx.google.com>
Date:   Thu, 08 Sep 2022 07:58:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-318-g324e0ca7e112
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 2 regressions (v5.15.63-318-g324e0ca7e112)
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

stable-rc/queue/5.15 baseline: 177 runs, 2 regressions (v5.15.63-318-g324e0=
ca7e112)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.63-318-g324e0ca7e112/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.63-318-g324e0ca7e112
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      324e0ca7e1126cc245971626e61741ff0d20799b =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6319d495fc2df851bc355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
318-g324e0ca7e112/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
318-g324e0ca7e112/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319d495fc2df851bc355=
662
        failing since 161 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6319d20e4855eac7d7355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
318-g324e0ca7e112/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
318-g324e0ca7e112/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319d20e4855eac7d7355=
673
        new failure (last pass: v5.15.63-210-ge77b14f8d83a) =

 =20

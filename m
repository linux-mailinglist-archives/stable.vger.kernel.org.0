Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CEE405F09
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347719AbhIIVnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347495AbhIIVnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 17:43:20 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C98C061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 14:42:11 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x19so2947903pfu.4
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 14:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1q0LQqQYeAmyDOPhAZwhkllPC90JRmTZN50DLG8yx8g=;
        b=yTGVQf064ldsBLN55oZEtkbvFlW1cGJUlPtxr7LjfE3HoPXzspWDG4Auo+EVol7eJQ
         7zPJTPspkB+1FBgR2t7oJ0perp0tGMGoSIgLAaZ5m2e25xO0T/AHzGN/+WRg+MpYB+su
         SZHjAPszpdbmNWr9QzS/BANRUpnggkDXuIJbwcxwCezY/VreSssSieruvL0r3CPKK78t
         7iRq08fdUClMadyjIwdZJNokOd1FzzFHT272skzYp30iWfpkbPFmpufV7z8fZ/Z+UkIu
         y9P0oPV5JXVWxWiZQBk1x/XlmpIgLFMW9tKo361o5CvB4MQ7Aokb5WJygp7c8Vfmr0pj
         K8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1q0LQqQYeAmyDOPhAZwhkllPC90JRmTZN50DLG8yx8g=;
        b=F7+Los7CNXNgMpu+KzbMWKj4diZ+w7t1exUnkXuhpysyaz3SiigFvMIeL3iOzI2mJb
         7vL65VQ3wx9Gn222tbiCNtYV9GE0dADGmtnIo87qzAcQMePdO+wN2cK8RXQuYo56UA3K
         gL9fLLsQPpnEKI2epEY5Rdpwwd1N+kPna9ZLjXJArZhQOdioQ+fyYFaLOMwWWjCbsgIJ
         6wP7/YaigZ6xD7H+ecWhVJZDYkF//6o9XcwBaJYQyzm4xwPY8dAAwQQG86SNzxelpoli
         C7Svcrxt2OtxvvffgJCLBNiUgQmKfOMISthVcg4AO9dNQx4ngyUdaPCoNiW16Ez+mjw3
         n90w==
X-Gm-Message-State: AOAM533wzqZHi2dDfp6LINR9wWZ9qxizj9Ita29ee7BR+QRH57QIrJ03
        tOJ42PmE9yW+N03fAy+rIZRVapKjVkYk1WQg
X-Google-Smtp-Source: ABdhPJyS7CnqUnHNp+xoFG44slfzhI+MeMwfih0A/+Ro73mlGW8jNRah4skqQcfmyOR02tDjVndr0g==
X-Received: by 2002:a63:590e:: with SMTP id n14mr4499418pgb.434.1631223730412;
        Thu, 09 Sep 2021 14:42:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5sm3013196pjv.44.2021.09.09.14.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 14:42:10 -0700 (PDT)
Message-ID: <613a7fb2.1c69fb81.4cf54.86a5@mx.google.com>
Date:   Thu, 09 Sep 2021 14:42:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-6-geca6b3b1c908
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 215 runs,
 4 regressions (v5.13.15-6-geca6b3b1c908)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 215 runs, 4 regressions (v5.13.15-6-geca6b3b=
1c908)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-6-geca6b3b1c908/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-6-geca6b3b1c908
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eca6b3b1c908af5c54bf6894ba527f4518565f25 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/613a485f3d4a9428dad596a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a485f3d4a9428dad59=
6aa
        failing since 1 day (last pass: v5.13.14-26-g85969f8cfd76, first fa=
il: v5.13.15-3-g247080319c1b) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613a4a7fd3365ace8ad5969b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a4a7fd3365ace8ad59=
69c
        failing since 0 day (last pass: v5.13.15-4-g89710d87b229, first fai=
l: v5.13.15-6-gd33967f7a055) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a4b94c732a16790d596e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a4b94c732a16790d59=
6e9
        failing since 1 day (last pass: v5.13.14-24-gff358fe92fee, first fa=
il: v5.13.14-26-g85969f8cfd76) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a4acf6b356a975fd59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-geca6b3b1c908/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a4acf6b356a975fd59=
675
        new failure (last pass: v5.13.15-6-gd33967f7a055) =

 =20

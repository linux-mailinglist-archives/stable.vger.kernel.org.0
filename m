Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87B0405C6C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 19:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbhIIR7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 13:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbhIIR7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 13:59:20 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA52C061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 10:58:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id w8so2583711pgf.5
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nDo8k/6OlI+KX2xjDppiRjamNrHebuUy06rUhNjqusc=;
        b=bDeSoZnYRD8SQ5fhYfZwSmuACzPFckxtewx+8m10hdktktlaNVs0uvU+khn2esy4mV
         OFaX2NtjFd/QFfFY0zDT7AsneADBFS+KslKBk7SdsyXJak0Ro8OjfRhePrUODujKY5SZ
         s8DCCuQEiZBP0IuM0UsZodTWr2hJTfcmuPFbJVxfQfJRDsM/vHQd/Wvu2XqD7RS2GvnV
         6MpK1rW+Wt+zgFcRcgfCdy8NyJrEvm4uKPLBTPjtn1w/h0fXQFFlcmtQcBaPhkqi8VXs
         OFUEsyAww0eWGvb/obvkgW5skZPftlGBoLiN3yKpvtlpB6Y8TciPkVo0zBU/VTcpD5Gv
         kWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nDo8k/6OlI+KX2xjDppiRjamNrHebuUy06rUhNjqusc=;
        b=c6oT07gecPh+jp/GQdeqihAYdrgY9/AoqiCbQswD4Rp0Z/GFWO4x1yqxZ6Pj4XU6Y7
         FsIr/3DHLCFDsjbHcjRdNkCqkWJowg2wVgaEuDKW0pUxti1FlmvWXZd4S8lyWfIfQ7cz
         xjH1C9wTEVUpFIHSEtmvaNb6cMaX8/Dbdl6hPwZ8/TwOaGZz+6nAWghORvFeYU3UXapw
         mXn9z67FF/pu9aKeF0645izd1XgrE8Y1PN38nzqqi5HWOGCEox7vPlUosaZI+A0jKISh
         SbURWxHCV/7noMG9jDwCIQEqpVs9abhCynvVweAiejeoYaFljK2c9B69aXkBkTpiYux3
         R4lw==
X-Gm-Message-State: AOAM533mzdBTcB/SogNi491ZbiEY0kWUlbHJBjsdRzCJ+brmPExxMJk6
        GmWbaCE/NQ9l+ao+0izpSNoHSNWSz3sLQYkN
X-Google-Smtp-Source: ABdhPJw3aMCrCI8qwTYyQdWTVEwu7Y9C/8h3OK4WP5gZ1C5tKgt4es2u0Zn1m8rJtbEi59KLGHauoQ==
X-Received: by 2002:a63:204a:: with SMTP id r10mr3717692pgm.365.1631210289966;
        Thu, 09 Sep 2021 10:58:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n14sm3333387pjm.5.2021.09.09.10.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 10:58:09 -0700 (PDT)
Message-ID: <613a4b31.1c69fb81.72505.8ac5@mx.google.com>
Date:   Thu, 09 Sep 2021 10:58:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-6-gd33967f7a055
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 215 runs,
 3 regressions (v5.13.15-6-gd33967f7a055)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 215 runs, 3 regressions (v5.13.15-6-gd33967f=
7a055)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =

beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-6-gd33967f7a055/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-6-gd33967f7a055
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d33967f7a055e1f40598a05e42fce3225789673d =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613a1a4f3239596bdbd596d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-gd33967f7a055/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-gd33967f7a055/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1a4f3239596bdbd59=
6d5
        failing since 0 day (last pass: v5.13.14-26-g85969f8cfd76, first fa=
il: v5.13.15-3-g247080319c1b) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613a1ba5486f0e2051d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-gd33967f7a055/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-gd33967f7a055/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1ba5486f0e2051d59=
667
        new failure (last pass: v5.13.15-4-g89710d87b229) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613a1b8edc20ee3be7d5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-gd33967f7a055/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
6-gd33967f7a055/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1b8edc20ee3be7d59=
67e
        failing since 1 day (last pass: v5.13.14-24-gff358fe92fee, first fa=
il: v5.13.14-26-g85969f8cfd76) =

 =20

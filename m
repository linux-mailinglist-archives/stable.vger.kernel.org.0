Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52637643F
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhEGLHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 07:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbhEGLHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 07:07:39 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E89DC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 04:06:39 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c21so6918455pgg.3
        for <stable@vger.kernel.org>; Fri, 07 May 2021 04:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M9u55OyklKKHuqoN4UrD1K3iRnKjTf3MBuqvV7oOrio=;
        b=D4aBhN0Vxbw1I0Gorf7cxNRD1pnTubhFMimAW2z/BXIjQZLTfUuiKuEmKcAX6jCG+K
         bBqr0ijMQTBtTwlbn/UDGhX9DsvA6tGIn/RrLn1TC+AjDTaZQCXy8Vl5wJjzzIpVq6a/
         x/KytOujGs84ILAh70rX/X4fskLDoIsVnRcplnSkTDRrJUPC3t88/s+nA3wlxL+Cwms6
         fpnmsM640CN2O7EA0rpafjUTQIwqtNTh6l0CM7Fm1jSbIW7PyUitNOlrlvZc0Pfl+lY6
         QquCToP0EMqMteUzQJy0F8rEhFKy250skP47UNOASc2IxBU/YOPgRG1iTuyhRswaRog4
         oCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M9u55OyklKKHuqoN4UrD1K3iRnKjTf3MBuqvV7oOrio=;
        b=WqvjXUsjufTCCOjmBdeWV2/xMfjBfUk/Plx/c46igI4CI+LZ3WBEPtAcaPLqCDXjsQ
         NpPcihhWG/TT9HEER5jHxrhjWTlDn1A3plSY8G9rPpfdMTcLx038kP/FXxiqKn0Goz6L
         Ivv+3lR3IslL00xO9Gw5TRYXIfFi2Bxf2wioDl1oLYBDEfxlc8EKf2Mej1q1dDgWErAp
         P/oWMOA35H0PfTEgR6aXBziHvcev4GUdj3ng3Ja43x1I3X86uoB9+CLUyGbuNITUqC98
         +S3usSDS3LrSgfF5lDSi6EH9NXQuKA2AGXNlouoAvoolIlO0opr4fiSQ85z/GeMIPzqt
         p2Zw==
X-Gm-Message-State: AOAM533knsAPF+bHiTudipDgl3eGr45yTWNzXvD+VBMRvfCsV+7eB5DL
        e7MxCqhghxYUyn3tVGXWi0R/7n3IkDIGRD9n
X-Google-Smtp-Source: ABdhPJzrECvRdIaIb3fVDaaebAmvZ1YnNeD7988quGnRI0aoSLh9sdR0a7Y7CXfnPX8G29TgBjlxAw==
X-Received: by 2002:a63:f258:: with SMTP id d24mr9233900pgk.174.1620385599044;
        Fri, 07 May 2021 04:06:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm4116365pjg.15.2021.05.07.04.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 04:06:38 -0700 (PDT)
Message-ID: <60951f3e.1c69fb81.8b1fc.c366@mx.google.com>
Date:   Fri, 07 May 2021 04:06:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.18-30-g4232ce7a02cc
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 128 runs,
 3 regressions (v5.11.18-30-g4232ce7a02cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 128 runs, 3 regressions (v5.11.18-30-g4232ce=
7a02cc)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32  | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig |=
 1          =

imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig         |=
 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig         |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.18-30-g4232ce7a02cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.18-30-g4232ce7a02cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4232ce7a02ccc8d1557c184559b666485c6ac832 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32  | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6094eb4c033bc93d6d6f546c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g4232ce7a02cc/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g4232ce7a02cc/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094eb4c033bc93d6d6f5=
46d
        new failure (last pass: v5.11.18-29-g6c2ae64a2a728) =

 =



platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6094ec4a165ed642776f547c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g4232ce7a02cc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g4232ce7a02cc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094ec4a165ed642776f5=
47d
        new failure (last pass: v5.11.18-29-g6c2ae64a2a728) =

 =



platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6094ebe2aba96ed1986f5471

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g4232ce7a02cc/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g4232ce7a02cc/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094ebe2aba96ed1986f5=
472
        new failure (last pass: v5.11.18-29-g6c2ae64a2a728) =

 =20

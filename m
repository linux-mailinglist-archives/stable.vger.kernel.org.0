Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DE24219F5
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhJDW1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 18:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhJDW1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 18:27:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8201EC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 15:25:33 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t11so894098plq.11
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 15:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=62XWJVjRHelU30Dt4NjC1bzM/af6AhZI7H93MsVL86s=;
        b=mEI8zUp9xClN6T1KJobYol07iLhCV9VCj6UaI5Aptj6+RSmf5MDn9GauEfvpnK2Rve
         rWYqIvqDaJPgsVoWGq+eWK3ypB5DUSYLNzIBSaUPsldMUkXB1avFzihP+FRhV5nl3Goc
         3UXVsqkK7vxTJWdVWdZ/lxpSXbOIhkx+8bAx21YtfxqzHXErsi26axmDXzIREKkFOCGD
         R8YejlttiXaYIUvOwhRgQGTHAtd/PVSDzijPy0gfYfdxv/GHB2dEisH/HXq805LwZCNt
         D1sKe0FiRkNnSSDfFnqQxYkcMa4+yEG3iYSFRg+ri6+0iohAKJsrPoPVtLc4eniWKJro
         +Oqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=62XWJVjRHelU30Dt4NjC1bzM/af6AhZI7H93MsVL86s=;
        b=yJuE0yoQ5NFKnVpCUSWngXxLJWSwLWulnbuDvVIUcmxCaFs7nHWSjnP3HHoOgT7Hdq
         jh9XfRuYQkyTCwXEpKLhXGHRQTWT+LIgMSt63vD0TPJs0UsS+3Blp4kbrEt48GtGM956
         C7MDqJ3S7igBAdFZ5jELhTFAbNkHUBe90lMGCBU1NZ9o6ZiV3x/hpadW9Ch81EKFOLQt
         E9D+QH7q5cD2KRCdLA7G5sI+d0482JEV3KzxvB0lXH/E1alw8Oit5ALwEOceE9TXjot3
         xg0zCeBFAZu5Cwl5nD2UsPSkjddTXBoNBdTbyCmNkwCRW1Lxdt2JE+2KsdVDjDIXpnQa
         uJZA==
X-Gm-Message-State: AOAM532976CFxzxTFo1/YXJ/02Ke9awi32lflkLceP8u3f2/mO51eOtc
        piKfNL+bCTcK/rxOUbZOArOHOlOZuRciuMSV
X-Google-Smtp-Source: ABdhPJxFBVNYqPRYSY/fR/q+wC3XM4atFZzhlmD/3p9pZAcQas7t4zPe4sse4hRCdc/ytUkzEOo7iA==
X-Received: by 2002:a17:902:9009:b0:13b:9cae:5dd7 with SMTP id a9-20020a170902900900b0013b9cae5dd7mr1925454plp.53.1633386332826;
        Mon, 04 Oct 2021 15:25:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm14974467pgv.29.2021.10.04.15.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 15:25:32 -0700 (PDT)
Message-ID: <615b7f5c.1c69fb81.f50a.d0cd@mx.google.com>
Date:   Mon, 04 Oct 2021 15:25:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-173-gcda15f9c69e0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 163 runs,
 4 regressions (v5.14.9-173-gcda15f9c69e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 163 runs, 4 regressions (v5.14.9-173-gcda1=
5f9c69e0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.9-173-gcda15f9c69e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.9-173-gcda15f9c69e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cda15f9c69e08480d4308d0e5c62bd44324a9ff0 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/615b46c6d51f5a3b3c99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b46c6d51f5a3b3c99a=
2e1
        new failure (last pass: v5.14.9-74-gb50148bf3122) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b4b14a5cd24893799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b4b14a5cd24893799a=
2db
        failing since 12 days (last pass: v5.14.6-169-g2f7b80d27451, first =
fail: v5.14.6-171-gc25893599ebc) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615b49e9765878774599a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b49e9765878774599a=
2dd
        failing since 24 days (last pass: v5.14.1-15-gafbaa4bb4e04, first f=
ail: v5.14.2-24-g08d4da79178d) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615b48df8e94c65f3b99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gcda15f9c69e0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b48df8e94c65f3b99a=
2e7
        failing since 28 days (last pass: v5.14-12-g95dc72bb9c03, first fai=
l: v5.14.1-15-gafbaa4bb4e04) =

 =20

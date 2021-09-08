Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C515403A6A
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 15:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345296AbhIHNRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 09:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbhIHNRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 09:17:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B7CC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 06:15:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id n34so2026620pfv.7
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 06:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qOeGYZ3vmB2HYmqKulgDKycOw25z2tl+rJYj4cptE/0=;
        b=P/2DxTq7PLKHB3gYr5aZ7Ndb8sGdDNqw+GzeDgp/xVRPNoPqZZmte0XwG7s+mOcmxm
         XWvdlGsDMbWopy+o53R7BELk6iEkoGvLiLuyF/yReZ5DUgFEVlUVZPVbJz/7SPjIunAh
         0PNEKzxyLocXvz0whYt9ZpjN5K+50uihsYtz7vwgMSXfcd7DMuTuPJaenI5CUv6Syh0A
         SlGfuepVkDEgh3BB6srrAOJ7cAZZ8ZD4377iNbMsHd//DHTucCe5cjVkeYarKD92NVUt
         l5eS7BmOqKooAR2mwifwOenzE4g23Zw1VUyB8akMZG67YE8LrEXWg3gARpSXmGA/c+RM
         kJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qOeGYZ3vmB2HYmqKulgDKycOw25z2tl+rJYj4cptE/0=;
        b=GWLGzs2Yr+e8df3J3kiQYjg4Emt7fOqFlzaNz7AiRkJACwfnmab9z/2U3MOfJvhxLg
         EQ/8SnDOemK8czG0d3zewCq0Y9qMu41eF4sTh2Jy5RCMsnkiTc4WKGS7nPA63USsw0ce
         lQGQuQ9s4TP4NfS4tFmEMcVYqd574w1ZSXO2G6aZtkzvEoROdK8SOa8Ypf5zH/zqTqHE
         eHcaSv0QFl0j7n1l+/rPDlq9oySAIZG6RiS8pVV4MenZl3gL6SjbOEEqmQRzAWj5YyrG
         sbFB3r7vVc9TjtJ+25be50uwxEyFXawqKwmEjOWNXooaE5zCoEa2alDvJ8zpP/lqT4PB
         tTag==
X-Gm-Message-State: AOAM531i7CObgIqluO4km5KyM6Qi9qP1J+de426n6BTDJpeSW+Bhqzrj
        onSr3p62vC4g0a+RpnHIHpuL/WGVDOGQLHzr
X-Google-Smtp-Source: ABdhPJxF3aBg+I4k0MaubaIHIyh5et5XW0gGrQGcRxPDMS/kUyCOWn7bamz5brzcSDEKsEpQ9ujzXg==
X-Received: by 2002:aa7:8088:0:b029:3c1:1672:2f25 with SMTP id v8-20020aa780880000b02903c116722f25mr3764188pff.22.1631106956349;
        Wed, 08 Sep 2021 06:15:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z65sm2440894pjj.43.2021.09.08.06.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 06:15:56 -0700 (PDT)
Message-ID: <6138b78c.1c69fb81.28b5c.6267@mx.google.com>
Date:   Wed, 08 Sep 2021 06:15:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-26-g85969f8cfd76
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 205 runs,
 2 regressions (v5.13.14-26-g85969f8cfd76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 205 runs, 2 regressions (v5.13.14-26-g85969f=
8cfd76)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.14-26-g85969f8cfd76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.14-26-g85969f8cfd76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85969f8cfd76d67c58b914e5d01507c3741295b3 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61388589c206adae0ed59689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
26-g85969f8cfd76/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
26-g85969f8cfd76/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61388589c206adae0ed59=
68a
        failing since 41 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613886ae3a31336a63d59680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
26-g85969f8cfd76/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
26-g85969f8cfd76/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613886ae3a31336a63d59=
681
        new failure (last pass: v5.13.14-24-gff358fe92fee) =

 =20

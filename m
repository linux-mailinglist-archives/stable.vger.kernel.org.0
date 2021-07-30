Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB153DB04E
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 02:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhG3Acr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 20:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhG3Acr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 20:32:47 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA587C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 17:32:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l19so12748564pjz.0
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 17:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bxusc+EtX9r/NJO0cm+FmjgJlI3+X2+Cr0wt7T7H/Hg=;
        b=jq098wQVcqrRMywYi3V5m3ii580YWNZbCRiRna4rQW4cpnGKeTqaEyU0DVkajtO92A
         LYiqTyu5jp+L5EMu5CrQ/+Uu5PEZbIL3cSO1NnRH1bcsumHV/vnRznXrPzw6D8ngC7VN
         44ysdPjENYSkbSc/krzSqRY6VgbhPbw94bpIkNhfjXe0yKw0jj5OvPCdti4SV7UqLEJ2
         +k7CWSAEUDaBHP3OQGRhoHAID8GK+aPHJA2FG6XDzB//mYPyqIVLqUs6dwAXzBUUICth
         iw3WXNSmRjks+IaJwbUEbHtDpf5BfiGD1ALZWblFCqTfTt9av9DpuVqgzKu+RkEKigpT
         wzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bxusc+EtX9r/NJO0cm+FmjgJlI3+X2+Cr0wt7T7H/Hg=;
        b=qggcOnGdFX3UZssJHlHiyX/sHBprhxwjo700kxXBoA+SB7YV6lZr9perLIAswPgFIH
         ImxC41q5Do8YrrcrMtACXARuql/+LY+XC+IuSorx25kT7IE+5X9xCPLBXlv6glNNsmq1
         ilJ/G4sUhzPQCbqvwwUBCfyB59zibuKnHRrUIiPXq8oIy9K8vBPhfGI/9Ju4YIOSEWs4
         CXmdoBXTUMwjllWaDfJZNJ4TqIJ4NQP6y84wLC8BbYCnErPN1ybmhL/ZNU9nxLZ3o6P5
         HjarMXJk9kHPgsiqgLzMOHlD1illxAHjA1QVL7FbdMCWWizShJLPqiOgiBua3VGjsrZW
         NksQ==
X-Gm-Message-State: AOAM531dEvZesRs1NoZ+dNmw/vxdypliT0JABiXuGbzj13Pcd4DwUgEf
        fdBooAaPSaYLuDfg7jsVPX7APsUzyq1ivNoL
X-Google-Smtp-Source: ABdhPJzBpKgJiHdPUWxfY5MNgd50XUZn+JQ1CHsrCYm5NU9KiLIqIyinRJxo8jPE7PqRRNfGLOTVnw==
X-Received: by 2002:a17:903:244d:b029:12c:3c0:f21d with SMTP id l13-20020a170903244db029012c03c0f21dmr7162676pls.65.1627605162115;
        Thu, 29 Jul 2021 17:32:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm4478057pfc.111.2021.07.29.17.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 17:32:41 -0700 (PDT)
Message-ID: <610348a9.1c69fb81.f55ce.edcb@mx.google.com>
Date:   Thu, 29 Jul 2021 17:32:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.6-23-ga572733cda32
Subject: stable-rc/linux-5.13.y baseline: 153 runs,
 5 regressions (v5.13.6-23-ga572733cda32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 153 runs, 5 regressions (v5.13.6-23-ga5727=
33cda32)

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

imx7d-sdb  | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfig | 1     =
     =

imx7d-sdb  | arm   | lab-nxp      | gcc-8    | multi_v7_defconfig  | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.6-23-ga572733cda32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.6-23-ga572733cda32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a572733cda320244f6671ae091728a755de1b031 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/610310e589910799b55018e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610310e589910799b5501=
8e6
        failing since 8 days (last pass: v5.13.3-350-g6c45a6a40ddee, first =
fail: v5.13.3-349-g1d9dba03aebe5) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6103124e19ed03144b5018ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103124e19ed03144b501=
8ed
        failing since 14 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx7d-sdb  | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/610314fad9a83ae10c5018d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610314fad9a83ae10c501=
8d6
        new failure (last pass: v5.13.6) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx7d-sdb  | arm   | lab-nxp      | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61031318eb52f80ae65018f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031318eb52f80ae6501=
8f3
        new failure (last pass: v5.13.6) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6103143255963fac74501912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
-23-ga572733cda32/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103143255963fac74501=
913
        failing since 14 days (last pass: v5.13.1-805-g949241ad55a91, first=
 fail: v5.13.2) =

 =20

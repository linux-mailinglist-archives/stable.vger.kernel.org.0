Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227343D98EA
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhG1WaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 18:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1WaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 18:30:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E248C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 15:30:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k1so4470660plt.12
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BHCKw5Y2IPSv1rPzwRR6NgyOBL/81tbP2GwcWhhLpU0=;
        b=RsQJTOaWHvEVp1NpgKW0tgBuvGXCPgtIPnRFx8mtWSJrHo6MItZeygN8yQ9k2KOC2c
         jHvmVB0qvZ1Eb8muQiz7zVAOAcmIfU3BMekyeQX5LrCcZsXuP+NTlFPsU9L9bYvX/d1a
         1o0711v+q/ksvHpeb2GhkD9T4g/ICoqRhm+e9OR7UbNolre9glS25P+UZyVSPM0X6zaW
         TVReSYT1BSj4yW4yyXWgHrjQgfIZrhiS/tilomt1sRkMFQv38he7H54Sw+vMNt7sAoPx
         0gECJ2+7QeSifkg/e/WztJ+AAmwgAmfRlQHzuMYC8R7KTXK4Nc00+gYX9qtrNHtHUegb
         YW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BHCKw5Y2IPSv1rPzwRR6NgyOBL/81tbP2GwcWhhLpU0=;
        b=WmZmtpvQda5u7xohTik+/IP7fw8XlNDbPSJr0s5Ge6tVCL0TjkASD/BA0Aop+X3D60
         Nx0IvC8xU0RNLqbi56yriu0xKNTvY5CsKmeV207uDO5z+Ktbe7+5h2DwXlusiKdFy325
         jVRgeck0RM1OfDJ9PtOyH2p39mNYp08PEmpyBkE29ATPRupXpmGaIHjnsYK3dp0bcopT
         tXvRVo8PRV8l5k8etnl5QBeZ1mWfuVKWBVQ6kcwW+9mXY/og0IEfGIslP0K93TgICbw7
         TLIFfF0DCSS1hLp9/Luc2QtmXqBJDMA9YNOF+WLNNEbDNsacIdn+W/tDdDyaGo1v4AN3
         pZtg==
X-Gm-Message-State: AOAM530SbpEbswZqhPAbrZhOzTonnP2/8wqc5T+cUj1uLfvaStU3Tgd4
        cCEUgL7ZJcqTWK87891MsBtByAYXUd+NfQwD
X-Google-Smtp-Source: ABdhPJyzh/n0diDPHnigUSmH37NNowePB0XFzYN3ibFeMuoQTdN39DLgw99o4je7vE4v7cd8oSF2aQ==
X-Received: by 2002:a05:6a00:26e5:b029:330:be3:cacd with SMTP id p37-20020a056a0026e5b02903300be3cacdmr1976423pfw.78.1627511416940;
        Wed, 28 Jul 2021 15:30:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r18sm956586pgk.54.2021.07.28.15.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 15:30:16 -0700 (PDT)
Message-ID: <6101da78.1c69fb81.ffc79.4403@mx.google.com>
Date:   Wed, 28 Jul 2021 15:30:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.54-1-g8d71121686cb
Subject: stable-rc/queue/5.10 baseline: 158 runs,
 3 regressions (v5.10.54-1-g8d71121686cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 158 runs, 3 regressions (v5.10.54-1-g8d71121=
686cb)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
      | 1          =

imx6ull-14x14-evk       | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defc=
onfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.54-1-g8d71121686cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.54-1-g8d71121686cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d71121686cb26c666d038d2df1c83ca5ee58c9c =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6101a4c80fbd63f67d5018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g8d71121686cb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g8d71121686cb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101a4c80fbd63f67d501=
8c2
        failing since 27 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
imx6ull-14x14-evk       | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6101aa375afc4d28ec5018ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g8d71121686cb/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g8d71121686cb/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101aa375afc4d28ec501=
8ee
        new failure (last pass: v5.10.53-167-g7fbcbc1a9534) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6101a321c903d21c2b5018d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g8d71121686cb/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g8d71121686cb/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101a322c903d21c2b501=
8d9
        new failure (last pass: v5.10.53-167-gff9fbe06f641) =

 =20

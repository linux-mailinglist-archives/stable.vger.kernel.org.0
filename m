Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1151F458420
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 15:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbhKUOoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 09:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbhKUOn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 09:43:59 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302B2C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 06:40:55 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q12so12969249pgh.5
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 06:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XL+w9QVD1EW3E7yAywr4B0/6T3eoFvy8svR9LHHnhxM=;
        b=3rykLR5Ccr758ldevkoh/yOx4J7XLMxVA7Q2hWnfRml5NkcLlbFxjVePVBoPzmhoUY
         0tdVQ32WUB/Ab7aty6USQdt09tWL+YNFyuIDgvftqmORwliJMEtt8u2G8pFmQql10jAs
         q4hlqa6QDi+/Esy1RSV/0FZ5glaxWDpLdzQehgW23zGETh804w92UASoz94oaRhFqO8X
         oICVCvbNA1jOGFgv0C/PORqxpRZpeDwk8eqIRDK6DfNkMvR5i3sJjCwy2XXqBCSIVzc/
         tM6RUKVkEnmt4n626ktTkPy4bj/fT6HJFIHUAZ4yWhrOECMlUCrlVqQxeeh1xgEubVZK
         j62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XL+w9QVD1EW3E7yAywr4B0/6T3eoFvy8svR9LHHnhxM=;
        b=RBIWYPqnp/DgoQPfxGlPdSsdDtqZcrnhJegzDNpOp4nKKResaE29ekR9uRF4CUpxzK
         Xvf/0dwMObhzCm7TKSWHKOKcNj+1VBQJeUkPIJT7zzrWNQPaNOWzY2z2q9AeGJdOvbCR
         SuFc9WB59EyZ0Qx7HvXIImzEe+92InR9ZTC7uIm9fMQbbcEG1nl/w5w6tSFr4I68wEGx
         Jt40gIqSHKp4xTcWFjKSIjaGqbH4yG3i3HI+tzy6BgFcaNFKVsvPdK9MLkMpeJjzKLoo
         fE9HQgzoXV2QPtnch60SmeorSl+beCit2K0asdCOe8YpRdtuy2q4SatdBZFEaAHt8dT4
         /YqA==
X-Gm-Message-State: AOAM532775Jd6YedMkYchHHEd1ukdxn7bncVT5Lnm7OB4KmBiF4brw9z
        7QyFEWMIoC6o3jrXNnP4N0jSuNmVSyZpAY1w
X-Google-Smtp-Source: ABdhPJwXgbQa9+p005xIbl47S4HAziJiLEBt08xJCZ0fYy6Qj5mC8uf5k1ufsGnMQQMp+N54sc1z3Q==
X-Received: by 2002:a05:6a00:9a3:b0:49f:bf9b:3192 with SMTP id u35-20020a056a0009a300b0049fbf9b3192mr77589696pfg.44.1637505654273;
        Sun, 21 Nov 2021 06:40:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o185sm5524572pfg.113.2021.11.21.06.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 06:40:53 -0800 (PST)
Message-ID: <619a5a75.1c69fb81.dea4f.09ef@mx.google.com>
Date:   Sun, 21 Nov 2021 06:40:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.20-15-g9bf8ab4a66d02
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 174 runs,
 2 regressions (v5.14.20-15-g9bf8ab4a66d02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 174 runs, 2 regressions (v5.14.20-15-g9bf8ab=
4a66d02)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig | 1=
          =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig           | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.20-15-g9bf8ab4a66d02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.20-15-g9bf8ab4a66d02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bf8ab4a66d025f700c079a93fc576b00da90a25 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/619a234440101cb96be551f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g9bf8ab4a66d02/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g9bf8ab4a66d02/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619a234440101cb96be55=
1f8
        failing since 27 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/619a23ada0e4460d8be551c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g9bf8ab4a66d02/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g9bf8ab4a66d02/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619a23ada0e4460d8be55=
1c8
        new failure (last pass: v5.14.19-3-geb15f5bfec790) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52EC406D59
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 16:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhIJOMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 10:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbhIJOMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 10:12:46 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9447C061756
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 07:11:35 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i24so1967132pfo.12
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 07:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xQBtEkIexoQFVOLTIX//DeRBXzxu2ZQP/4v7iCQmRjs=;
        b=toAQdcMJdpN1VK40FhndrHs8d/xcwSwXq7kDKn+mh/ny58xJsJK/lD4jyTln1EeUN2
         eEE7buRJ1L5Hmn/rmjnsguw+OrCLzbI6e8iTn1hW/q4la1fvczq94jvP6bl0OuU9oVJ7
         mJXGyzcpS20PQr8pepnXDzHv9ie65FR8wddqQns04Ih8GN9I2uXFKo0bo7wWA2g/FHtx
         3BknIDACnbZH8KkW+mRtIGHTqRttduK7MURswsPfLiqRK2TIY9gagzfAhTr2z3AyhoCH
         qEcxnuKiJyCzMzOtohJzTiuTS6E0EpRZpr9+8WkYlMznHJ1oT6vW665P2L4f/qr97WYq
         IJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xQBtEkIexoQFVOLTIX//DeRBXzxu2ZQP/4v7iCQmRjs=;
        b=viuw9dnKH2ZS8tCxzwXiTVjKLGgvBZWaRXPgN98pXs84QTYJrd6NXNrNletmZiSU29
         r+S3qevoeEUiBiARxXK03WPVIDO6ptQUhYZlIR+UiSUakJj2P65JhgNGi1psQnGaDpQD
         emlJAqr6hPJI6jf3o2eA4sAAYP/TQF5Bp0pPWYhSkMoFqBmcBNCpdTJBimg1cElLp1Nx
         N6e+fH+GBYQPQ3UYzuEcPpUG3Oyat5ZWfodyyeV88UAy6HCg8EQAufYv2ExzzUg3NKfX
         JX6aSROnVJtfn5bJH76z7MNXk+X37XpDk3GU2dtxFPoci63nmeKYAsAFZ7tjM4UCaoNt
         BroA==
X-Gm-Message-State: AOAM5338Y0mKcZm8QZF/SCqL/QmvVi9PCgHAM4PGlxTcL42knbfp2i/n
        Ql19bxZCyTKf1X8IsRDsf98jbVCJPKl1G0oc
X-Google-Smtp-Source: ABdhPJwxqKORYQPfpWWEDcSNLs5fAZrgcaPF89hgYW5ncL5ctxb0/JRjaTJ4vGJGFGocgUX068i/JQ==
X-Received: by 2002:aa7:999c:0:b0:3f2:8100:79c2 with SMTP id k28-20020aa7999c000000b003f2810079c2mr8393803pfh.80.1631283095104;
        Fri, 10 Sep 2021 07:11:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10sm5318561pfq.205.2021.09.10.07.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 07:11:34 -0700 (PDT)
Message-ID: <613b6796.1c69fb81.1326c.edc5@mx.google.com>
Date:   Fri, 10 Sep 2021 07:11:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-23-g1a3d3f4a63ad
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 192 runs,
 2 regressions (v5.14.2-23-g1a3d3f4a63ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 192 runs, 2 regressions (v5.14.2-23-g1a3d3f4=
a63ad)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-23-g1a3d3f4a63ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-23-g1a3d3f4a63ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a3d3f4a63ad62366f1d23182ded4c6e65c56a58 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b31546dd79833d7d59670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g1a3d3f4a63ad/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g1a3d3f4a63ad/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b31546dd79833d7d59=
671
        new failure (last pass: v5.14.2-4-g7e05d47c1c8d) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/613b31af7579ceed49d596a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g1a3d3f4a63ad/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g1a3d3f4a63ad/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b31af7579ceed49d59=
6a5
        new failure (last pass: v5.14.2-4-g7e05d47c1c8d) =

 =20

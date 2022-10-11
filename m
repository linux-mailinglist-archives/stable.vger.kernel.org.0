Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B68B5FAB6E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 05:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJKDvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 23:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJKDvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 23:51:36 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8FA4F1B2
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 20:51:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f140so12425562pfa.1
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 20:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=L+uK7SMxNO6o0hyj83e8bt/4ctKlmW8EdAPz68n7/5k=;
        b=rueoIQT84hORX7fhNY7lUQJPuxfR6K/NIt6CfFrQukW8/ly+MLhOOQN2GlPf7+nWOP
         b9f5IHfbQ+HN7lykeV2iPPSXZArtC4o06dv9Kt4C3ZjmLaLsE4RiZXjo3LveyY7+Digu
         V23XLRfylDUN1coLLU6DuMp3+7sc1f4wiJZ0VCLzarleaoQj/2Zrg4rKN8bShE1UgAFI
         p9z+Q7fGZRaK59hus1um/ZeRnJhVPcLZSDlp9W82JHhCp5Ybm9lu39JbMOVyhpQ2hPqI
         moZV86dGN5Oen9vuVWZQd8l9plfjW74kR2yAH0RgMNyI4ZP9Fxe5XaBxlFYdj4SFLSxK
         9fLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+uK7SMxNO6o0hyj83e8bt/4ctKlmW8EdAPz68n7/5k=;
        b=IlttNxtKW4xrIuCXDvyhxdGkWcuwHK3J7FtM+f0EmkurBi4Xf8SxXri5EdbNhH7NSM
         sLj3s31y47Vw8efmZCm+ZBhjghQR8bU9VgN+aaSGh3EO9RdvKQiZmvWurg8ZHrtzTAHW
         Yip0Dm33BkF8iZ8uxL0P2M0o+QGqZIlDzA3wsnkBEvWY2NLaWOkGASMg7F4z9+gE+20v
         lCcgw21b7mk9XzCp+9zFpLc/WrjTLQkKX6O5WY6F13HELwjk9klE8djQ/qfVtpxC9oJs
         yFaMKZoC+sxHtU/8DEbJ6Rm82EABRG4c1p20OqEfOLDa7cOh9pimOdVx6m8uQCS0I+Qd
         pk6Q==
X-Gm-Message-State: ACrzQf3E56iUlr5gqI+Erb7x1V5z6n37YBZ5BIfD/U8rFLpBPMgDOGd4
        WBFV+ZvfBgKhEb6Z9EuwPWrRWnz93G/PUnP9a3M=
X-Google-Smtp-Source: AMsMyM7uAP/e32k1G+uAfG13paP7a5E8ipO/os3KYR3q7+Mrz/QR1vP0OZPolFCsAeKjBlnQXgl7sw==
X-Received: by 2002:a05:6a00:14d4:b0:563:9296:f320 with SMTP id w20-20020a056a0014d400b005639296f320mr4493076pfu.27.1665460291077;
        Mon, 10 Oct 2022 20:51:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u186-20020a6260c3000000b00561c6a4c1b0sm7891906pfb.176.2022.10.10.20.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 20:51:30 -0700 (PDT)
Message-ID: <6344e842.620a0220.274f3.d8d3@mx.google.com>
Date:   Mon, 10 Oct 2022 20:51:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-35-gd53b3c6ae238
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 115 runs,
 4 regressions (v5.15.72-35-gd53b3c6ae238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 115 runs, 4 regressions (v5.15.72-35-gd53b3c=
6ae238)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
 | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

panda                | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =

r8a77950-salvator-x  | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.72-35-gd53b3c6ae238/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.72-35-gd53b3c6ae238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d53b3c6ae238ade336409227d0efd20a8347c288 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6344b88d4cc8dc279acab650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6344b88d4cc8dc279acab=
651
        failing since 15 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6344b6b3b0e10f64afcab69b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6344b6b3b0e10f64afcab=
69c
        new failure (last pass: v5.15.72-37-g16538c20c2add) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
panda                | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6344b8760665089d77cab5f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6344b8760665089d77cab=
5f5
        failing since 56 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
r8a77950-salvator-x  | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6344b91cf0a4e8e23bcab5f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
35-gd53b3c6ae238/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6344b91cf0a4e8e23bcab=
5f2
        new failure (last pass: v5.15.72-37-g16538c20c2add) =

 =20

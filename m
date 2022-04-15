Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF108503147
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 01:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbiDOVNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 17:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353541AbiDOVNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 17:13:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DE12C676
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 14:10:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k29so8559539pgm.12
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 14:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q+EiSBkSUwe9mr5QwpQUXNx8zkV1ZsFNB/74bsMDFkE=;
        b=Tyq+qUO7Gk81LY0qT7NoMRl5ox2IcLabuHogye1TzPcflVxbzuXkmjZboRVOu/cfk1
         l1FhNdlmX0Qizb7qq4k01yupCp6kfkqxKYuTEayOB1UIS+PGIxHiEnQYgrWSKPrU6YZZ
         lRsxyhKdf1eLO4FmPK65R11OfX7Ocxg3wEvFGNJr2OwLZ/FqJ6JSwmphpNcNYqEOmtAf
         7qGyM77ylQ5mjNmD9g8OmDGcmijPVrxLcAM4bqg9CFjfyaP9daAwM+EIJqHSgDDB6RkK
         bdlSAInY6w94PoeALl5ixvRC7KnGIxl9vMr78+CBittVAhcAgnTDj/sPro+7TnLjVzCc
         92RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q+EiSBkSUwe9mr5QwpQUXNx8zkV1ZsFNB/74bsMDFkE=;
        b=o58OCt+CQ2QAbJFlMoXnKAMpDBuYDips0ShCna9YYFEMlMT8mzNaXq3XTemXD3M8hW
         TtgLqtr9b5EgQ0YoGs3zwlMvcbHlRzK6c+PANq7/E7nNEAabudcuCbyh+3cxKqICG7OZ
         iEZBxDoNJbMs2J/ZsnRLON9sys/qmjzw8sSkxIM+eew5C0hgIKqC9N8b4YtopAW/cVhy
         Qt+lowd8sUzOdpZIx60AqFFtf+c5qKbEfW9t0sF4EMqn0K98enwsawA+47BeWcqtAxnk
         7/QhI44fQvz6yEqn0rFtkVQV/ZovDW7O7AGBF5qCEoP5sY8x1W/7QfwoZY6kJh6Tv9n5
         XF5A==
X-Gm-Message-State: AOAM533Wzcp2DKBcntHwHoapQTXp5SZZ0vYO/AlrPuEzH5AOe+9I/xP+
        yiIGtxqYXL6CpDBCQcDFAnSQ/zDibWKyTcn4
X-Google-Smtp-Source: ABdhPJwjko1YngcS6V+c2rXP1bU/WLMUyWt6cr4Xw7+vSRB4n3M8XupPvO95gKudqcgu3HRQm5CTTw==
X-Received: by 2002:a05:6a00:174f:b0:4fd:aed5:b5e4 with SMTP id j15-20020a056a00174f00b004fdaed5b5e4mr707551pfc.39.1650057047509;
        Fri, 15 Apr 2022 14:10:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r32-20020a17090a43a300b001cdbda883ccsm5836740pjg.38.2022.04.15.14.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:10:47 -0700 (PDT)
Message-ID: <6259df57.1c69fb81.51d25.fb7c@mx.google.com>
Date:   Fri, 15 Apr 2022 14:10:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.238
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 106 runs, 3 regressions (v4.19.238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 106 runs, 3 regressions (v4.19.238)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.238/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      aaad8e56ca1e56fe34b5a33f30fb6f9279969020 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6259ae5d0c60329bfdae06a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.238/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.238/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259ae5d0c60329bfdae0=
6a4
        failing since 9 days (last pass: v4.19.235, first fail: v4.19.236) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6259b0151665f481d8ae0791

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.238/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.238/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259b0151665f481d8ae0=
792
        new failure (last pass: v4.19.234) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6259adb1a32dd20056ae069c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.238/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.238/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6259adb1a32dd20056ae06be
        failing since 30 days (last pass: v4.19.231, first fail: v4.19.235)

    2022-04-15T17:38:29.792679  /lava-6099975/1/../bin/lava-test-case   =

 =20

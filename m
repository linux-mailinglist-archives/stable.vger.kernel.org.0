Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0277A4F5761
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 10:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiDFH46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 03:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444633AbiDFHrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 03:47:40 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834643DBB11
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 22:41:16 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s8so1487593pfk.12
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 22:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cUbH+7YSVBWZ6ECOc7f2jRFn4piyqb7S9GSgv7Zz384=;
        b=d/b22qzB15pkQLLS9PrvVNABbGH3A0pq4ONu/Zict5fLiGdm/nlWoWCpCgFk4gfyFg
         xjK77JAsMdmADGqkvuE/RRtI5sRmZxZLQ6CYiPzdnviByEN5V2/7uI57D0HTWrVi45Ii
         +fgI0EoVdKnNZMk0aypiQzOw3KRNY43L93xf55CDldYvq9PB5yYFk4G2GRlFyOGwNG5I
         nlLsA22D27afBbQbxfdCK3zeB3JMsktMBGVKltal/c0UkwS7xfape+PYwwvlUw/3GU58
         yDJx79lt3ow3zHhY2KsnNku8Qc3dGRlptdM9Le8u7QbQestYa5zz5hDibKa67KMlIzDW
         /TWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cUbH+7YSVBWZ6ECOc7f2jRFn4piyqb7S9GSgv7Zz384=;
        b=XBsLCX3eAqjqh12eBliDJ3hj5NDkLZwm7i4tR6Ze0ePSpgSYB7sU1n9mkt5LreFglz
         i0geT0orOD1nGjyxwfnwguboycZsj/OOGEoCK72Pu5MJZodqDcbWrWeAYnzOCzSmC6DT
         5e3jnbg/S9UkS1/2QleL0vrmyeBWd6zpF1++8freQ10vyim09tDGRj/EIBIoyFQcufPN
         2NPJK96NmagD2f1xoTxdj5NrOJXjpymVnWL/ivaJNvAk05LwEFUwQ5JTXVsagoWHzhDG
         zK4oXcEplM9iGm+SarHyq2tX5XqZfvrq0JB5ipY31o0W6uzEFPin7OtPf0VnVz1YOhKT
         4z9w==
X-Gm-Message-State: AOAM53080MxnbTkHjY9R1cmOsB99DxWrv+W7WMT9Ui9NRy2PGi6K0Yga
        VXhJidh4kFu9fS2ntxKitLXmO+uROLpYFwi9FbM=
X-Google-Smtp-Source: ABdhPJz3pUcNkXBmJX4BgmObny4za7DrK68T6gpnOTNB5uCZrgZ77QcSXV5/szSyH4RNklGyDvnRWg==
X-Received: by 2002:a63:6a0a:0:b0:398:6fb4:33c2 with SMTP id f10-20020a636a0a000000b003986fb433c2mr5863674pgc.151.1649223675849;
        Tue, 05 Apr 2022 22:41:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22-20020a056a00179600b004fb28a97abdsm19598166pfg.12.2022.04.05.22.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 22:41:15 -0700 (PDT)
Message-ID: <624d27fb.1c69fb81.d8715.2fa3@mx.google.com>
Date:   Tue, 05 Apr 2022 22:41:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-256-ge149a8f3cb39
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 51 runs,
 2 regressions (v4.19.237-256-ge149a8f3cb39)
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

stable-rc/queue/4.19 baseline: 51 runs, 2 regressions (v4.19.237-256-ge149a=
8f3cb39)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-256-ge149a8f3cb39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-256-ge149a8f3cb39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e149a8f3cb392d671161e9e8c304c1c3191f96ca =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/624cf7b8ef2381d592ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-256-ge149a8f3cb39/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-256-ge149a8f3cb39/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624cf7b8ef2381d592ae0=
6ab
        new failure (last pass: v4.19.237-15-g3c6b80cc3200) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624cf8a0c4659ce86eae06ac

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-256-ge149a8f3cb39/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-256-ge149a8f3cb39/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624cf8a0c4659ce86eae06ce
        failing since 30 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-06T02:19:02.755820  <8>[   35.675634] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-06T02:19:03.772311  /lava-6033560/1/../bin/lava-test-case   =

 =20

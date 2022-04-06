Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED584F6C5C
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiDFVQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiDFVP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:15:58 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF42493D6
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 13:00:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so2921252plg.5
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 13:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+1m1jktNosBj5J2y4o5L0RlS2hErrZGh+bP8LJfzxg8=;
        b=IfINN3CeQ0xKjqVajcA2I8lLmi3oaY7ToWNoDjkMpW/A01Wh2TXe3tzMRMcFXtkfA+
         8hXn5uzbPPDgJMM0n/1OxD9bIic0WUvci5K4CVulCUzwEgQX6KooFqqAbPy5xIA53SxF
         d1bqRIiSwVBtn245bTjv9rA4tY7hbkLNBxKZAUfFbnuhlS06NyZVmdfO2/C/EEeXrLrm
         uBq0geQe/GcCalrlYjs4P4anABc7aZAPVafqwya/Vgi2ckCaXMEt3K6Omv1cABT8Bknx
         4EXuhKcR5AN8IdfMurKyEKA3CBvW5f3a8CdxUfegxT7+2O4qGug26X6PepNQfco12s/R
         IeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+1m1jktNosBj5J2y4o5L0RlS2hErrZGh+bP8LJfzxg8=;
        b=n6d+ZBlWU5feZo0n89+0G1jKQHKQCK7Y/KeN/YoHeHO7G0L1dMz/F24iioQdYtkh2o
         UNcjknSmo1yN0IboDXjQG1LEkHLpLTT1p/F+kNC81wdqY2c1DUnsbAdXfnLFm3juF2wk
         qEnBvMjL/ha+cuQSRCwNXy9BS7p0yDaGYHHLQyQqzzcjyOeBGqq1evLMXZe24TvTxCbB
         lss5FXEYvdRN//LIkmjGijIZJG1hOm3MkVnbOZeUVwDrmCOfl5fLuS1ibQapYJLhWl7g
         Zw5JNKA4NcgDXdxFi+gnxARK2Uu01XrrlDNi1iQA4TjZq3PtuMqRNXDX+nEesYSq59Kx
         vFjQ==
X-Gm-Message-State: AOAM530YH3L+uiXA8+qHYrSPjlGwEQHm9tXWIN8ktWy8U3Gm3c41zbRB
        LhSU4sUOXmvLk2NNXTIdL10A+W84Rizij8wtFdI=
X-Google-Smtp-Source: ABdhPJzi+uGu0c4DOV9HNafb3yYdjvBveMQ0j+1iFEpGMqoIbQofZHHuMCS0Gt5Q50IKv+PxXVyfKQ==
X-Received: by 2002:a17:90a:5d89:b0:1ca:8687:843d with SMTP id t9-20020a17090a5d8900b001ca8687843dmr11680504pji.28.1649275222448;
        Wed, 06 Apr 2022 13:00:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a7f9500b001c97c6bcaf4sm6683401pjl.39.2022.04.06.13.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:00:22 -0700 (PDT)
Message-ID: <624df156.1c69fb81.2c4a.2cab@mx.google.com>
Date:   Wed, 06 Apr 2022 13:00:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-597-g1c0fab2f02262
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 70 runs,
 1 regressions (v5.10.109-597-g1c0fab2f02262)
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

stable-rc/queue/5.10 baseline: 70 runs, 1 regressions (v5.10.109-597-g1c0fa=
b2f02262)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-597-g1c0fab2f02262/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-597-g1c0fab2f02262
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c0fab2f022620d5cc2cf6e09f3432166aea3a3e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624dbecb85a8eaf246ae067c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-g1c0fab2f02262/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-g1c0fab2f02262/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624dbecb85a8eaf246ae069e
        failing since 29 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-06T16:24:28.848673  /lava-6038994/1/../bin/lava-test-case
    2022-04-06T16:24:28.859306  <8>[   34.312201] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

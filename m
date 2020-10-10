Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C96289CD3
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgJJAzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 20:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgJJAi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 20:38:26 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA757C0613CF
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 17:38:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i2so8592610pgh.7
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 17:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wUzVuyngBr19t12IK9+p+VNZfvzkDz8BdoInn0onBeA=;
        b=qJvKVroyt/tzAbM4j5/pMpYkWR9k7X94YVRPp7ZwebZDmpRqwMG34u3OWO54taRcKx
         VCVh+jPQoDv1LOBmcrGIkE9eKDozA9h9iuAWpiMvsGvF5kq+Br9xfROpIBKBxBSKNGvl
         cWP57gBDYhvebGx9CuA9TTDQCtOC4kqXcxg3tww2O2xaemg2rJOp0GslmWIVy5Kcru7c
         ZYU9XCVOOc26wFbaxz4cFpprw698Hdlbo6kZ4u7dVKaNY6dMRYi00UP+PM0gPlgCdEy+
         trUFloMtMzD73eaErKMVMg8rtnvDhZpixqf1k56FKzbggqi8bKEmxpwH4x9NmQF1CJ7P
         AB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wUzVuyngBr19t12IK9+p+VNZfvzkDz8BdoInn0onBeA=;
        b=JwAPXczlpZeCssfDIcejsugAtJyYsASIJk7dyUR0GDiNEwQ1N389L68SwiW0nZZt6O
         VuxVmCBWosftuaJRiJnpyEqpkse/G7Ktwwg2YgAiUGewHOThRMQ5jDGRcQ8zR3kNBYl5
         2fZtxHk01gu2CW5H6gZ3sOuq31VIE6JHbp9TGd8cvYkN+/uRVyRxO1Chrlz2KGrJvT9i
         o5asm4ARx6q/CRrvSEUCGwjg0Y/Sn/RrldgOasQCxPaUHbJ6UzxvF1LyRc8/ClbCYFfx
         budzXxJzORh8aS8xPbKgTWSq4BGvBXLtyJnNJIMK+5FX4f1aj0rEwYe85C5KS8L3W9wc
         PjaQ==
X-Gm-Message-State: AOAM532ns1Uqk3mQVVvAcSzwcPVs7K/n+mnmuKf4NU0WkIZoA/P8DThq
        VHg68QcNPd/GIabGLP8D7tihHZ/B9rJa1A==
X-Google-Smtp-Source: ABdhPJzRHyiqlfDXzAGxu9w8dosMZGpSnYf4CsdW/Bt+qSjbxleFt8BQ+vbAb/IsnFRlnwHLSmKtCQ==
X-Received: by 2002:a63:4945:: with SMTP id y5mr5305155pgk.181.1602290303992;
        Fri, 09 Oct 2020 17:38:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm12233241pjs.34.2020.10.09.17.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 17:38:23 -0700 (PDT)
Message-ID: <5f81027f.1c69fb81.ce765.6bbb@mx.google.com>
Date:   Fri, 09 Oct 2020 17:38:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-31-gf8a7c17f9bb0
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 130 runs,
 3 regressions (v5.4.70-31-gf8a7c17f9bb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 130 runs, 3 regressions (v5.4.70-31-gf8a7c17f=
9bb0)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-31-gf8a7c17f9bb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-31-gf8a7c17f9bb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8a7c17f9bb00b29d40b41711a96ee0d05b70fda =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f80a0793b4da5daa54ff3ea

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-31=
-gf8a7c17f9bb0/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-31=
-gf8a7c17f9bb0/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f80a0793b4da5daa54ff3fe
      failing since 10 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-09 17:40:00.724000  <8>[   20.637700] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f80a0793b4da5daa54ff3ff
      failing since 10 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-gyro0-prob=
ed: https://kernelci.org/test/case/id/5f80a0793b4da5daa54ff400
      failing since 10 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-09 17:40:02.758000  /lava-2708379/1/../bin/lava-test-case
      =20

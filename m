Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5F0508CA0
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 17:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239354AbiDTQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 12:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiDTQA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 12:00:59 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F07C326EB
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:58:13 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g3so1358210pgg.3
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wBXPHdDgrDSHF3gNSrovUYFw7TQpGtsMiNLN2SRAC0k=;
        b=Ix7ac4hQ2MyCwAA+voRGyKY1EvW9oXt3HtHTduGXxMTMujy9oQ4QCLV2h1AnkZVzjK
         WNzeznpKn4+bN+p3JvkhmDRqhvVokffwk9mh9EQF/15w/4aD5TMdjyK8OWM7Vb1h3zsn
         /hjFJWt9qT4ZviXCa2Us0wel5xrzRGCVTwepAEXigWSrk3tp8MraoLP/jLCAtSdbv11g
         lboBNmznR6DXUfZ2GDDjhbKE35U44ntXshM905QA5UoyPmbk8o3KUW4CpL55YXyOoJOJ
         JT0SXqJOwzjsqHAR1pAsw9O9GdWLjDQGyojifp4peS97L1ypKM4legeyP3iKciEV0gW1
         rdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wBXPHdDgrDSHF3gNSrovUYFw7TQpGtsMiNLN2SRAC0k=;
        b=YipuphugP4813ToLsVfXAj5TynfuQLOF/Ess7KBdGxN7MG1zKFdZ9bSX4tEkEcPZKr
         oHjQbpgCiJANypuyn8QC7ZZfSo8oxxiDSpV2kTkaMgrFiR2O2z644o0UiUbV6K/mrwPN
         0kAJnmQYgrDETqUGFkBkLi1XHnoorWjVLBQo6NAWMGfdBN9RKxNl/mVqYk8QT881iWeY
         /v2aKX3190ZeaYcjtBSwWp5nYG1XH6ScTsIobrS+OQnbfWcqC3FIeqWCjVWW8M9/zfxU
         fNKXQ6CgsXAK2D1/UGHL0xFW4zMtFbLNVCM+xDJ21Fb8Ffwnv7ONiWENSHgMIiS31aG9
         +uKA==
X-Gm-Message-State: AOAM530Dv86QHy5xybRGr7SLLaazkkQSqzLX7Gmy5vHHljktrdOFkeL7
        8lFI77ebh9FMUfXDjmvQU1H6g/FhAZOdKqSvnoY=
X-Google-Smtp-Source: ABdhPJwPSezVbr+gVBb/sQQVvMs4AVv0jxnDKtnSeVRQjv9BS+e8Yt8jRFzV0pGbC35JFNXYfjQTLA==
X-Received: by 2002:a63:cd05:0:b0:3aa:4cf7:e45e with SMTP id i5-20020a63cd05000000b003aa4cf7e45emr6070078pgg.498.1650470292510;
        Wed, 20 Apr 2022 08:58:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020a056a00218600b004f65315bb37sm21754161pfi.13.2022.04.20.08.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:58:12 -0700 (PDT)
Message-ID: <62602d94.1c69fb81.8d418.30a4@mx.google.com>
Date:   Wed, 20 Apr 2022 08:58:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.190
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 84 runs, 2 regressions (v5.4.190)
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

stable-rc/linux-5.4.y baseline: 84 runs, 2 regressions (v5.4.190)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.190/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.190
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc213ac85601199834e7f2d222a5e63d7076d971 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625ff9d3e45dd9093bae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.190=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.190=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ff9d3e45dd9093bae0=
67d
        failing since 13 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625ffc9d181a16a98fae06ba

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.190=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.190=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625ffc9d181a16a98fae06dc
        failing since 45 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-20T12:28:54.299472  /lava-6131185/1/../bin/lava-test-case   =

 =20

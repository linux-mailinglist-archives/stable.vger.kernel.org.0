Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0731D502032
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244617AbiDOBse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiDOBse (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:48:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E873A5F9
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:46:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o5so6627614pjr.0
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=54zObQMijr8A+574dhHqS+XLi2b20hxKzuem+2A4h68=;
        b=NaScoFU8JbghA6IrROf63DA8WXGbzcyQ4ChDoEb+wpGBVJNTSHn4qcklvp/6T1SDks
         lRg8DFv/WMF+wemYpQ3mIPMsbE6YlHoeX5k1TfFQB7Acsnruj/zN8tLGYBNYh8f/Qewa
         A5+DZN71eANoRM/+fdoyDdbkzScUQ7Boup9qTyZ2PV0WyccQ5XIva9fFvzrXbhVtmzf6
         Ne4x/SrebtUiiQJbmLEpcn40JXLsr6JXvPrV84q9zu9JV/6ckSbaBhmO8Qn+9ySpxg5Y
         N09MBv+7XwoSp8Mi/QJmEYIu7vGqALJtpECIEY0BOSqCqgaoi6mf2RYNRByydXfNQPAO
         kmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=54zObQMijr8A+574dhHqS+XLi2b20hxKzuem+2A4h68=;
        b=h3X5tCZkL2r11axRJlvLUsvcFMkNg4vSygzjigqesK1hY4fZH7/ncIp8mlKmDZJiSi
         DysJUq685U9FWZFd0Lrlka2pDLSKXOQ3pPn7TYHCxtKEKoBLTUZudsCvpscIfFOQcTku
         k7z4qVXd30GwRF1cCm7PQfdo4y243IX7sIvVttVHUNEIfKc+5oKESYcCtoITVOHhTFY+
         yVtuT+7/KVJkRywEX/5qFe+j11U6CubGh2gaNjFh+6V4oUqXsZ4cLLKf7j6Kf1swrayp
         j/tAqW4vETgvNcEIgzfZTrxb/i/IcqVViXN1gPLuGo2/X4yCrkN8WeYj0GB7QxFmVjee
         juXg==
X-Gm-Message-State: AOAM532JKOFqyY7lkMF5J55xZf9PfljLdfc5jw9djhPGrh7JkPESNF2o
        JEkmK5DTrIuPVWL/RfHNxq1aOMxKy3kts6b5
X-Google-Smtp-Source: ABdhPJweuu1stn9Klc7vmM2qusv7hYYy/eR+Ad1+PUwVZR3toTdPc+XLKefXC57S8VQ7Jepnqkx6RQ==
X-Received: by 2002:a17:903:2c7:b0:158:2f26:6016 with SMTP id s7-20020a17090302c700b001582f266016mr31445892plk.154.1649987164897;
        Thu, 14 Apr 2022 18:46:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f7728a4346sm1110025pfj.79.2022.04.14.18.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 18:46:04 -0700 (PDT)
Message-ID: <6258ce5c.1c69fb81.fc98c.4287@mx.google.com>
Date:   Thu, 14 Apr 2022 18:46:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-335-ge2984ffcd13c7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 100 runs,
 3 regressions (v4.19.237-335-ge2984ffcd13c7)
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

stable-rc/queue/4.19 baseline: 100 runs, 3 regressions (v4.19.237-335-ge298=
4ffcd13c7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-335-ge2984ffcd13c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-335-ge2984ffcd13c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2984ffcd13c753c75399a28024253b24fd51322 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62589f5548bff45339ae0682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-ge2984ffcd13c7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-ge2984ffcd13c7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62589f5548bff45339ae0=
683
        failing since 14 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62589f56fd4f661875ae06b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-ge2984ffcd13c7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-ge2984ffcd13c7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62589f56fd4f661875ae0=
6b7
        failing since 8 days (last pass: v4.19.237-15-g3c6b80cc3200, first =
fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62589d308555a40bc0ae067d

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-ge2984ffcd13c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-ge2984ffcd13c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62589d308555a40bc0ae069f
        failing since 39 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-14T22:15:51.430544  /lava-6092325/1/../bin/lava-test-case
    2022-04-14T22:15:51.438731  <8>[   36.910072] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

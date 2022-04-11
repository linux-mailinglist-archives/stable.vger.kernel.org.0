Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB34FC4CE
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiDKTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 15:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349671AbiDKTSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 15:18:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5565936B7D
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:15:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso226228pjb.5
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wo5EWXmbx8sxnqlikFKn6NqZqhw70QN3p6Xpwy1YJUQ=;
        b=2Si2+MxB0PeQtuIElOcSgGOT01Kci2Ptgc3nafMgZyN53RVh3UqHUYtoDWvczVqC7c
         BSlXFuACPvI2hTrxcdkwC1kuUja6OKzfgWrQw/Xnx/zQv3Ir1xEff8Ea1vnx4/ewRPLh
         aLulgR1dC/7FBMx/UTVDhuxGjGaPfys8ucDBuJqmSRNRVZsb9UzGpjWv9EmGRsgaMGjn
         atxVtfXroak1ySrhwUbgwy3S1ZYBbF8m+CjTJwPsI72AGr2B+R6slFYJF0X2dFj40YMe
         f/ydnxM5qn95yyb10CtDHd6QNRjvx6MZv7RpdZUYbvbFQPvWWUWS9F9+087rjSq0JOb0
         PCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wo5EWXmbx8sxnqlikFKn6NqZqhw70QN3p6Xpwy1YJUQ=;
        b=AOy1akcPFFmoHS9OzXTId2IjuZaP/3rViot5TNA+y/MBidXvBQtdBW9DACJ9Emn9Ir
         h+j5c8+T96aO0eCmeOIZhsmb8Kdk4jzw36Vz9CNZ7HQ8R+D9oHH1IU2UJXjPeIZorBnb
         RFF9rN0YDQOqp5YMOrBZwtLIKTlMWl7ee7hJrWgA/O59BEo7qNhqf6qIfK+reQr/3xna
         mHpPF91WdFga3eg+j6WT2mMlFpS4WYl+EVY07aD1l3aZuH7fJ07UXxKfaVp7Vtw5cBul
         sb/RnurNtDdUxdzD3w7TLmc8JOhvK8FNqWRDKtMTeqSzQGjaJ6sfvyRNkfuNzLUU9BBz
         jsog==
X-Gm-Message-State: AOAM53201k4VrJFsqVgDDW+xC8qh2eOQH+WfamwsiMu+TKABRS5vnoOf
        Ij9bgDhfZRDVq/vuikcTZ2lSl6lEJUj7aDLD
X-Google-Smtp-Source: ABdhPJwJYlwQKHlkDsBrTsTU0bGW9hX1UXpLD+fkDCnV5npIBfq1WNjfVLYP1y/zU466MSCLCVjXXA==
X-Received: by 2002:a17:902:ba8c:b0:14f:d9b7:ab4 with SMTP id k12-20020a170902ba8c00b0014fd9b70ab4mr34284050pls.23.1649704552676;
        Mon, 11 Apr 2022 12:15:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm243158pjf.23.2022.04.11.12.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 12:15:52 -0700 (PDT)
Message-ID: <62547e68.1c69fb81.5aad1.0de3@mx.google.com>
Date:   Mon, 11 Apr 2022 12:15:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-327-ge7739ec4f370
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 2 regressions (v4.19.237-327-ge7739ec4f370)
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

stable-rc/queue/4.19 baseline: 106 runs, 2 regressions (v4.19.237-327-ge773=
9ec4f370)

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
nel/v4.19.237-327-ge7739ec4f370/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-327-ge7739ec4f370
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7739ec4f370f9af21e9417e4ad118651aef1260 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625449edbd90e531c4ae06e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-327-ge7739ec4f370/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-327-ge7739ec4f370/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625449edbd90e531c4ae0=
6e8
        failing since 5 days (last pass: v4.19.237-15-g3c6b80cc3200, first =
fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62544a820de696d4d5ae06a0

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-327-ge7739ec4f370/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-327-ge7739ec4f370/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62544a820de696d4d5ae06c2
        failing since 36 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-11T15:34:20.567997  /lava-6063416/1/../bin/lava-test-case
    2022-04-11T15:34:20.576353  <8>[   37.254501] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

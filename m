Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B351B597
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237242AbiEECES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiEECEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:04:09 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940BB13F4C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 19:00:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p6so2868221pjm.1
        for <stable@vger.kernel.org>; Wed, 04 May 2022 19:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4D/8yN4btXh09YTj3pZrXbZPYgGTHRkzWNBiqcbIY54=;
        b=uO3m1m8GEWeIaHlpXoQTy8+uHlsO45jc777fuvh7FGijTgMAmayuhCHJ7MkY6b8b5H
         mBMhfMeAwzPGVmb+UAx3AUl2WU7To9Nbg6ZqaVYjcO30QJbu0vnHbZ0lXs3e34Ex1IiK
         BizmvvgODHJSdctY2DJNzXmxns+SQB8YpoFk2L4BxAEhiZJ03J5UYjQ6bg8TcOE7NtGl
         1lWNd+/Y7Z2d4Ktb1c/rSCSeZIsmzkWIiEn3zoQqg0Khe1FbGuSM8bYc0z5ni7f10uOt
         4fEqO42YOjwiorjBrP2eImr8TAid5E7uX8SdZm6LDwbOYTvyB3JPilenUGtaQIfBnwJa
         oyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4D/8yN4btXh09YTj3pZrXbZPYgGTHRkzWNBiqcbIY54=;
        b=F7rU6xbBzNox8lmkArP0UNu4mChTNaaOxEc7Sb32EnPGDa5nBtjDh84sUiJdaBfZaz
         Mm1IJbg0ijMD30IS09NiN25RkgMHubJ1kTu/JorRK8gAn33yDj+XSEaOrXPLo2kZyc1i
         CtKtLMgOdESe6Mf4/+lux7TVgcKdfEwdGnenf8o3t+77hlGwSWx1lRodI/gw7bbrhGH8
         xtPuakGxNxCMXJdRwksZbq7j3Tt2CPlLgt/nLkk5+ua24f4eccQSWB5suo/rCDalwbXH
         T6nR9M/lBHR0V9h9yFa9BwP3PzqY8OP/LDcrzCT310b8//GXGUMhEdhaptNhESbro9f/
         d81g==
X-Gm-Message-State: AOAM531WAKrHomDDP1s9X81LqS5PonbTlRJoq7/bhG9LqZSs2p1d8WDr
        AggeXVDyzbdz3l6caROK8Fd2/qeRgDl/Tko1Jiw=
X-Google-Smtp-Source: ABdhPJxpjCs3vrhoiJWC4PvjXR3G2P2gRloEweJN+pg0bCAcDDPonbgPm7tjNrDrG2tN9i6Qjk1oKQ==
X-Received: by 2002:a17:90b:3901:b0:1dc:5a24:691 with SMTP id ob1-20020a17090b390100b001dc5a240691mr3165090pjb.40.1651716029932;
        Wed, 04 May 2022 19:00:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902e88900b0015ec44d25dasm149292plg.235.2022.05.04.19.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 19:00:29 -0700 (PDT)
Message-ID: <62732fbd.1c69fb81.8ec62.08bf@mx.google.com>
Date:   Wed, 04 May 2022 19:00:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.241-59-g7070c1b6eeed
Subject: stable-rc/linux-4.19.y baseline: 114 runs,
 2 regressions (v4.19.241-59-g7070c1b6eeed)
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

stable-rc/linux-4.19.y baseline: 114 runs, 2 regressions (v4.19.241-59-g707=
0c1b6eeed)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
meson-gxbb-p200  | arm64 | lab-baylibre  | gcc-10   | defconfig            =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.241-59-g7070c1b6eeed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.241-59-g7070c1b6eeed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7070c1b6eeed13cb59403013f04c1224e75fe70a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
meson-gxbb-p200  | arm64 | lab-baylibre  | gcc-10   | defconfig            =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/627300068b3dd2bd138f573c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-59-g7070c1b6eeed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-59-g7070c1b6eeed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627300068b3dd2bd138f5=
73d
        failing since 29 days (last pass: v4.19.235-23-g354b947849d2, first=
 fail: v4.19.235-58-ga78343b23cae) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627305773ed518253a8f5734

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-59-g7070c1b6eeed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-59-g7070c1b6eeed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627305773ed518253a8f5756
        failing since 59 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-05-04T22:59:56.222945  /lava-6266426/1/../bin/lava-test-case<8>[  =
 36.632075] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s1-probed RESUL=
T=3Dfail>   =

 =20

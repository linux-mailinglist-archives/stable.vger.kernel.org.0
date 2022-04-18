Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39701505A2E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242115AbiDROmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242092AbiDROmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:42:35 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3751D6
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:28:23 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t4so18894930pgc.1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qmeNvCG4ISRHk0Ap3eeL0Z7tQdKVGt6HohNAUHrLYBo=;
        b=n8Aqlfhc4zbK8kGaLMnioma/mHCA4+9JSKd5wKrvwwsKWkvhnUQyAYZASJ9fiydrGa
         QuLNQsHodaimOvCkpAYKaPp9C1DwQUE4zuPLJt/ZlDUyi9ca08TayFdSd2DxCTj7v6YM
         63/AQNgAySpAV/DRnRjP/ufmOxy7PDsow10DTIWbcr3WSvqOe9Z42gCFb34K2Ol8sCxE
         76QXEKCnc03yEfd1N1o8Uou/fYKmCVPQYG7w2yAzxMH6s8ar0aQMCcfpECwfPlHRFtwO
         VAPWJ1VbP9ow5vsWf5Y7F0x+yn3l97XYHQEPwQAR+7zMF0iwsxOYKna5bz6Yut6shFFS
         i3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qmeNvCG4ISRHk0Ap3eeL0Z7tQdKVGt6HohNAUHrLYBo=;
        b=Ri2ptYJggTAGz/oqTL5bPSRuJ1wVpHC/7w2BD5BqjOST0HE+35FsRZIcte1wLeUXg/
         avRgra/aS7oWpVw+Qs97upSoAtdxK0t+dpZSBFV0csrbmD3SrZx3nvgXmoJ7hJNYoBuH
         XiAQndWRgfzGpmA5uscPntotBfz0EdQ/vzpoY+HWCy7d0ymVe5ugqT15Ydv3o0k7yjuE
         Yu72Jy+g6WX7AwOP1F/rN/qOAyqK0SkZHPYTCgA1PVHF7ssFC/C8c9slaY9rd18mCLsJ
         vgKRVBf8WyRDix5RtcP8LVI9LZJGyD+2OpIG/b2J8+yD0mZK6/ZiA+wa4Da9i0n65C+q
         1sbA==
X-Gm-Message-State: AOAM5304XRtK2T22b7k2xnh7L1/xGv9XWQSZxkMSHmTkdhNB0LXP3W3u
        2nw+cLrcLWJOirbP1ehQ6FNR3YV/zW3UU7ZO
X-Google-Smtp-Source: ABdhPJwiVcz6sPQp5QK4fMFt5wwu5RSJgebrw+G+5yWhT7ci08iG+Ziqec5Sqj+Zm2SyM6nJ5Ermfg==
X-Received: by 2002:a63:40c6:0:b0:39d:9463:94ac with SMTP id n189-20020a6340c6000000b0039d946394acmr10004707pga.289.1650288492222;
        Mon, 18 Apr 2022 06:28:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x136-20020a627c8e000000b0050a6a93b3eesm5465506pfc.116.2022.04.18.06.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 06:28:11 -0700 (PDT)
Message-ID: <625d676b.1c69fb81.c322a.ba19@mx.google.com>
Date:   Mon, 18 Apr 2022 06:28:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-153-ga8728172968d8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 147 runs,
 3 regressions (v5.15.34-153-ga8728172968d8)
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

stable-rc/queue/5.15 baseline: 147 runs, 3 regressions (v5.15.34-153-ga8728=
172968d8)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
beagle-xm            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconf=
ig        | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.34-153-ga8728172968d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-153-ga8728172968d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8728172968d8bcc46768598d68dc08360f0d99d =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
beagle-xm            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/625d36855b4f01043fae06bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
153-ga8728172968d8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
153-ga8728172968d8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d36855b4f01043fae0=
6c0
        failing since 18 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625d351cc0c06c9939ae0741

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
153-ga8728172968d8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
153-ga8728172968d8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d351cc0c06c9939ae0=
742
        new failure (last pass: v5.15.34-11-g069d3f023b9fc) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625d3027f17e09b106ae06fa

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
153-ga8728172968d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
153-ga8728172968d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625d3027f17e09b106ae071c
        failing since 41 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-18T09:32:01.351177  /lava-6115126/1/../bin/lava-test-case
    2022-04-18T09:32:01.362322  <8>[   33.736003] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

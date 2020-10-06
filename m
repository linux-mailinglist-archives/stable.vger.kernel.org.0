Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEE284353
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 02:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFAZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 20:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgJFAZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 20:25:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB75C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 17:25:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o8so344042pll.4
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 17:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rQ3DJj115AT1N+abGT8omPXEdv1SQn8eErIhRiAFmSA=;
        b=AGcN54u6IGGdQONJlcf5lSdJfucgDW5hv/CwoJrk3Ny5AGlIFJTUOBERD0vZNX7Rgm
         sYeTLDZaDHmw/XzWBtTKSqf3tzuoePuOQXYybymUmPUxMavy+njvCGG3fMU8y3geaJ8z
         mVwL7Ol9rRAuH5Osi/Xqpt6K3oL7c+Y3n6SOWtQrJLY1ic2ujtvUSKm6I8Al+/sPBKiG
         ZTUKz8MIxuNHbs4OC36DQ6cUoOamUTflJo/40fP6Wu4pvZ0e7OTOV1sQN3/Hr/KGHfb8
         HAuxFjQcQBCWjV55PBEag2xRRTmXsIyv4/Bsu26eE2UfCy6WsTbAWlLEUw5jkTfJw8Tl
         OcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rQ3DJj115AT1N+abGT8omPXEdv1SQn8eErIhRiAFmSA=;
        b=rrV0P7TiUU2/222SHBu1ZcA03G+3AT+gFvTdCbD2QDRhW/sBC/Z8HVYLfqS2eYL9Ii
         lr8x8PYe8mj4VK83uE7hUY0PCHgGNnIiEcv54g2A+sYjSugAAHs5VF+7wu0SejpTRrc9
         ODokOYAWUVkTvfvCOO8lxT8WiHiqcI7kPQBIA/ODbgIRHvTky4kwppDggtj1a42LCBNu
         xyreoW4Q1dpvA7QH2SwX5gn0V08xA3UxnADRLBgg6gmnFK7sKo5Q5hq8PgWhN7d3znRg
         jFi/yPMD0oBLCRyLqB57hPZSoIQSfkD4KGSLuFjrv1EX6AsD+CTmoiy2mCvss4Ujr4Y7
         JY2w==
X-Gm-Message-State: AOAM533GlujXwHotywkb1WtTivuqul7Xaqe6mHJedZ8PyAwsusOIjDbu
        h1uedkTQUY0SujL+TxBtXdoQn/Vzbubuww==
X-Google-Smtp-Source: ABdhPJykTbTdwit8w+cS+h3892+yQQVbpBkOfCTxokIFb9gOI0X37kNqtd416wzR5AxaA7yyNz5sfw==
X-Received: by 2002:a17:90a:e2cd:: with SMTP id fr13mr1822008pjb.156.1601943913966;
        Mon, 05 Oct 2020 17:25:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x10sm1088168pfc.88.2020.10.05.17.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 17:25:13 -0700 (PDT)
Message-ID: <5f7bb969.1c69fb81.a8311.2ded@mx.google.com>
Date:   Mon, 05 Oct 2020 17:25:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-58-g7b199c4db17f
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 124 runs,
 4 regressions (v5.4.69-58-g7b199c4db17f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 124 runs, 4 regressions (v5.4.69-58-g7b199c=
4db17f)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.69-58-g7b199c4db17f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.69-58-g7b199c4db17f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b199c4db17f19594dcf4d24cc26c8ddff8443da =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7b7ed93124673cd94ff3f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69-=
58-g7b199c4db17f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69-=
58-g7b199c4db17f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7b7ed93124673cd94ff=
3f1
      failing since 177 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7b7cfc5683be81a24ff403

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69-=
58-g7b199c4db17f/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69-=
58-g7b199c4db17f/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7b7cfc5683be81a24ff417
      failing since 6 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196) * baseline.bootrr.cros-ec-sensors-accel1-prob=
ed: https://kernelci.org/test/case/id/5f7b7cfc5683be81a24ff418
      failing since 6 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-05 20:07:16.911000  /lava-2692395/1/../bin/lava-test-case
    2020-10-05 20:07:16.920000  <8>[   21.735046] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7b7cfc5683be81a24ff419
      failing since 6 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-05 20:07:17.942000  <8>[   22.756618] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20

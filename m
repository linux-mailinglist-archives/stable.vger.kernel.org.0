Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1FB2826FE
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 00:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgJCWDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 18:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgJCWDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 18:03:41 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C134C0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 15:03:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 34so3248071pgo.13
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 15:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h3L6+By94wn75kN6Jd59ZD2c6gatLLKGZQcF7heTbVc=;
        b=WAveIwtbxftj7ZreGbbIEE4AxBJUNGyGpzUgw+txqQyv+7Qqae0bRWJxVhy1lYWJ25
         nS5S84kzvb0kksXvDff/nY6sqF03W4AYEM+YotEVFb/Ra6I+kbzVBQ/8UPY5vz6IJEHG
         TTFfmCQO9o2lsr/X5SXpXdh7QsLy6ZkJIIn362ENwkkNOTdaE9m49e/B8PQjXCADkUZr
         jFEZ8r+JBK7Aw7JDv+sj7HusjCT6eg62YffbiJjyy8kYa+48De+0fLNmjk6B2Ez5bZgs
         PMHigL4w0UHVHSz8lkwIP7fzHunxo9S47DCdYIfz2e/Xy5aLGhpNmmGmAx2+OZIOg3g2
         YfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h3L6+By94wn75kN6Jd59ZD2c6gatLLKGZQcF7heTbVc=;
        b=MybyHsxaOFx414RfFT3WnFf0dYLew/bcPMIsf04FEJwx8iZGjOMgdQG6+QYmAzd7Yy
         OukKQsC1k7COKMRLHRP80JVe55M8KRe6juGMLr6mjjQDuGUk0gadXg+QlIj7ycI4O+V1
         Qsoo/p7ugFoIcQ4TDHmDMFcBakwBkkXSITu+wz0uQMUxCzIaexqukvblhJtTukg0CwwR
         rOJqAonS3iy2hR0bn47oGGxaXor/vtilRrtU02QeSilRDX7FOPwiDehjrTzLEoOTuOwd
         b+laf0uguzOEPBi51T8g0CxkqCLr2omD98aNwW1ImqoDAxtuXymykeLS/eys0mMstIh/
         c/tA==
X-Gm-Message-State: AOAM530clJkf5umqzUtYVuIsmHE2tP4A9NV4HPj2X+JltXWKk6A+vTiz
        HGjJ4glhVbGs2qeppaeXzCXjCOyRVYZc7A==
X-Google-Smtp-Source: ABdhPJw8IScdwIEdU/0lL/KnqvbEhJvJX6gcwQvSxBqYaAj80e0zG2dN86xFTcqZjkYyjT5yA4p6Jw==
X-Received: by 2002:a62:79c7:0:b029:152:197b:1b57 with SMTP id u190-20020a6279c70000b0290152197b1b57mr9354786pfc.69.1601762620129;
        Sat, 03 Oct 2020 15:03:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm5546285pjn.16.2020.10.03.15.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 15:03:39 -0700 (PDT)
Message-ID: <5f78f53b.1c69fb81.56d2.a983@mx.google.com>
Date:   Sat, 03 Oct 2020 15:03:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-3-gf31ade88ddd8
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 140 runs,
 3 regressions (v5.4.69-3-gf31ade88ddd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 140 runs, 3 regressions (v5.4.69-3-gf31ade88d=
dd8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-3-gf31ade88ddd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-3-gf31ade88ddd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f31ade88ddd832bff0cf2da944d25848542c1af0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f78b84b803797d69c4ff3e0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-3-=
gf31ade88ddd8/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-3-=
gf31ade88ddd8/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f78b84b803797d69c4ff3f4
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-03 17:43:30.707000  /lava-2685974/1/../bin/lava-test-case
    2020-10-03 17:43:30.716000  <8>[   23.144846] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f78b84b803797d69c4ff3f5
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-03 17:43:31.736000  <8>[   24.164281] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f78b84b803797d69c4ff3f6
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)  =20

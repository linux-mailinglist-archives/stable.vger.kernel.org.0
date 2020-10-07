Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A70285E9A
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 14:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgJGMAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 08:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgJGMAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 08:00:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812C9C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 05:00:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ds1so916833pjb.5
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 05:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qi6KMZjNtGzHQed0jSE0360NAdBOlrAuJuWFG+IedeU=;
        b=S7JUulRltg7+b8+8Jq5EXWxJ5o02gbNFp9w6PBpbTMct/gAj7bk3S+ZG5WB0ppg+mp
         ZrpjjVV23pmt09c+ITL9HbqjrIVJ6WgpYFsH3vDk2Jrps7+9xnrb3pvm8I9yAS5pdwx1
         95asfxSByx+pl0EmzGEdvqwt1WASlGEv2ZKaA7sQzHbfDBz/juJPQ283GIF3TCm4chHp
         nMoUd8a4xfST5rRbT+eKgF6WYpNGC09tib7mWnRmtUqcuCBMZXEcF3U0D96P01GrSy8r
         F8pWrdqLY1hgzysuZv1PYtejZNM12nfQ4dIVfIAMW5lDroNkmisoZqHITpMkIIcmBSuN
         /hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qi6KMZjNtGzHQed0jSE0360NAdBOlrAuJuWFG+IedeU=;
        b=GhFEcwNsu+vO18ziCcbnuvVDqFt9ixRr8y/DviZyVoEQ4BYkfyHNPj2uMIoltyOq/4
         0oSfGgh/dvMesYSi68L5FsDfmy2qsUlNKz/JT159M8sboDqydqjU9FB6n99/16JHBI1O
         6X5Kh7aIszg4t6FjFgcaoeOo4pI/bVXQbf+mgwwkvWHe5Jh6BtwTkWZ3iB5qwSEEpMHa
         xDiFupY1LOaUbiBroy4FHV0ObN+Dfo6u8E5HiyiLKlTAxDiVxZfdBUqcPsZFSipWL26L
         NKO4L5F3p4FAeQZQB+xAib74IJlLatsvTOndctm5yUkWS4qhZFLF5MVTxJtHiB4ZlUkR
         w+iA==
X-Gm-Message-State: AOAM531eMKOfkIAyVTovuTVeyRxSvCsgCpUS0t6z3M1IQDXqsGJP919a
        4Jf36otCBvZ9sbe25fKmgUrJWDQdxCpyXQ==
X-Google-Smtp-Source: ABdhPJyP+IIdWfOsuafiIgep0xY47nRFSnWJWnDSbioA3UoQpoVP8AVo9Vig1QFkZZabjHsSh3LJUw==
X-Received: by 2002:a17:902:222:b029:d3:b4d2:105e with SMTP id 31-20020a1709020222b02900d3b4d2105emr2622720plc.32.1602072047646;
        Wed, 07 Oct 2020 05:00:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y195sm3079165pfc.137.2020.10.07.05.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 05:00:46 -0700 (PDT)
Message-ID: <5f7dadee.1c69fb81.87ed5.59ae@mx.google.com>
Date:   Wed, 07 Oct 2020 05:00:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 131 runs, 4 regressions (v5.4.70)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 131 runs, 4 regressions (v5.4.70)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.70/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d22f99d235e13356521b374410a6ee24f50b65e6 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7d71f303ff3f43514ff3f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.70/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.70/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7d71f303ff3f43514ff=
3f9
      failing since 111 days (last pass: v5.4.46, first fail: v5.4.47)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7d691b2e2870e85d4ff3e9

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.70/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.70/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7d691b2e2870e85d4ff3fd
      failing since 5 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-07 07:06:56.396000  /lava-2698569/1/../bin/lava-test-case
    2020-10-07 07:06:56.405000  <8>[   22.959273] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7d691b2e2870e85d4ff3fe
      failing since 5 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-07 07:06:57.427000  <8>[   23.980885] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7d691b2e2870e85d4ff3ff
      failing since 5 days (last pass: v5.4.68, first fail: v5.4.69)  =20

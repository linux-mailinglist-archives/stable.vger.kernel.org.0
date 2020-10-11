Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF62B28A932
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJKSQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 14:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJKSQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 14:16:10 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E16C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 11:16:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b26so11346869pff.3
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 11:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wu9IadXgqL5suYBML9aqT9gxczURcuJcJ917sIID5PA=;
        b=IOyaL7ILjMJKvwPPr//hEqKAjYeD2EFvYrt9OLRwts1ifZPTL3P+nA+Qwf67z1Lo+A
         TaD2gINBihSTXcjT9I4GVZMg4t2LzjDxoHsf9KCRsGWq6CLTX5b+JpsfpTHjdXkTxprL
         yRo6XBGC3KPj1Z1ZFt6o2BUu9EBJ5G0/REdsfmJfzBhBYKrQSHBNyLMp051122aPXz59
         5qwdCOuETH5odydatA0HKZMGXhxOGuEdvReipeUFeQ1aN2qFunm0CXy2yK6GD/R4Tx0a
         7eBGAI3tnTZBcDtcIWc0Ei/Zco7jFg42cjy7dCxFotcZYJLWCP3VqrtolSneQWD5KYmJ
         wdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wu9IadXgqL5suYBML9aqT9gxczURcuJcJ917sIID5PA=;
        b=VHy18lbnwsKMnN0v+Nyqe693PIDXHNLVpRIQ2tr+iy7YpmErox/cfZRhYOtrt4Nsu3
         F1apAY6Mn+8cDwe3I/XAalh1pGQMKgxsKTfj51/wkqg25h+xjKlDzQpDLbcxA1gBionU
         YlwtZRrp3pyfhlPA4KDKbsPhxyib8K9zUIPs7GjJX5XQOmDF0XvpRsM02INPk9XcSR+w
         nW6hVCk2CCpIz//1Yz86Xac5iEo7MFXN0kPY1rnOEtdNmp5vF13po4VpsZ2iSp2I2JsI
         /BcXx9bcOEfdqDjIcWZmz0fcal1iQuUUm1b/m0Vtoui5MMMRgvxUV3iuHyFo5tJ+B1B+
         HbOA==
X-Gm-Message-State: AOAM532pwgBZ4eTKLdlRgkxQ90JWmu1f6DPlviWd+pwEcqhn8kv8ODZc
        MyxHI1IQA6+WgwOU6VhQIlv0V+KmcNdigQ==
X-Google-Smtp-Source: ABdhPJy3HD7ZoT8lYTFis0iVpSXtHW+/9XSxOAnUMfDUuLRzhvSRqWAFt8hb1Ff5kmQR6dsakCuL2g==
X-Received: by 2002:a17:90a:c204:: with SMTP id e4mr13568289pjt.209.1602440169039;
        Sun, 11 Oct 2020 11:16:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm16705278pgk.13.2020.10.11.11.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 11:16:08 -0700 (PDT)
Message-ID: <5f834be8.1c69fb81.2ea4b.f1ed@mx.google.com>
Date:   Sun, 11 Oct 2020 11:16:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-38-g55678c4c1bef
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 132 runs,
 3 regressions (v5.4.70-38-g55678c4c1bef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 132 runs, 3 regressions (v5.4.70-38-g55678c=
4c1bef)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.70-38-g55678c4c1bef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.70-38-g55678c4c1bef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55678c4c1befcdabf19d4227bd84dfd25d5c30b4 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f82f3651dd4ca93264ff3e8

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
38-g55678c4c1bef/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
38-g55678c4c1bef/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f82f3651dd4ca93264ff3fc
      failing since 11 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-11 11:58:20.691000  /lava-2712356/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f82f3651dd4ca93264ff3fd
      failing since 11 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-11 11:58:21.713000  /lava-2712356/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f82f3651dd4ca93264ff3fe
      failing since 11 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-11 11:58:22.734000  /lava-2712356/1/../bin/lava-test-case
      =20

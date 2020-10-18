Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A009B291533
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 03:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440073AbgJRBM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 21:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440072AbgJRBM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 21:12:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857AEC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 18:12:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j18so3807149pfa.0
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 18:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F2/FFC+Om3ai6fNc6Agsznn1rUkSZ75u2GcK+cNLgJw=;
        b=x0etS0QIBC9pd9DC+ygQXzMG8LDmHZpdEepSCHide6tldn90wWZyLKpO3oVELGSY+/
         9wEZzvhFJDiJUaexCQ0L9ni3w42XFV20tLKhA4hssunniyKiLpBTJs2fLOzJXr4Xl7VW
         fVRxJt46ayw3vLOihw9az6Cyz6fFKCv+ZbeoZijJhWIdyjwIAYfFiK1LrTD1rr39bEOi
         v0PJdlRNGFd0nsjjq9XKUCeLxuFCcYMhHsEQknn0dPj39L4eJpIpXDWhTTIqMx24U2VT
         gINHxWfR5ZdOHL/NVPcLnV996ohW8FuycU48hLdbjHcBglZhV9Dy11/XCFhISBFZuIqZ
         otHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F2/FFC+Om3ai6fNc6Agsznn1rUkSZ75u2GcK+cNLgJw=;
        b=tQhKnic97nF+68NioqRhB4SczZXRfqB+E44K9VEce1apLNyvcJlVGTO+KsrgP3NXcT
         gCzE7opOuGH2ZOP+lrXCpkAytqyWroYMfHTU5APxuqKHjPTl7sSyHuZqcPivM03VFtAD
         asYqKqQtMlzuJzCZcleJZysb2Kcz/PciApQRldQRpJO3b74jaPJgI1/kTSBG4dvYNaPm
         NKd6upHviYnA8WAMLKMxrVOXxWTinkKvXyUnMufpAHPLFZc+E7swPgAm5IBj9jBtznVr
         zGPQOiUX0edQLSqPku6Cfg5DywkBZQSjzwkk+1TCNzf+NWLl8ub4Efrbr5PYN8PjoAE+
         lNdg==
X-Gm-Message-State: AOAM530VPL9XNgFsnrsu2Jw0aiQXv+Y0bGD427+kFfh66riA4bThujCk
        WObMoTClIaoqMWvM2mser19UqwiIoMuHBA==
X-Google-Smtp-Source: ABdhPJwjVgPwMGaRQUyzdlt+fiMixq5o48QZZOyrB5IVOEPICCF0Bn5oH/gbLCGMmHMKeGqs3Axe8w==
X-Received: by 2002:a62:e112:0:b029:152:b36e:b05d with SMTP id q18-20020a62e1120000b0290152b36eb05dmr10602318pfh.3.1602983545708;
        Sat, 17 Oct 2020 18:12:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p188sm2684335pgp.65.2020.10.17.18.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 18:12:24 -0700 (PDT)
Message-ID: <5f8b9678.1c69fb81.59cbe.4e1c@mx.google.com>
Date:   Sat, 17 Oct 2020 18:12:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.72-23-g71c30c5eec09
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 200 runs,
 3 regressions (v5.4.72-23-g71c30c5eec09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 200 runs, 3 regressions (v5.4.72-23-g71c30c5e=
ec09)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-23-g71c30c5eec09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-23-g71c30c5eec09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71c30c5eec091073c8b307ce05ca64308fc624d1 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8b5c64fd9d441ed74ff3ee

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-23=
-g71c30c5eec09/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-23=
-g71c30c5eec09/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8b5c64fd9d441ed74ff402
      failing since 18 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-17 21:04:27.523000  /lava-2730793/1/../bin/lava-test-case
    2020-10-17 21:04:27.532000  <8>[   22.919377] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8b5c64fd9d441ed74ff403
      failing since 18 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-17 21:04:28.553000  <8>[   23.941002] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f8b5c64fd9d441ed74ff404
      failing since 18 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)  =20

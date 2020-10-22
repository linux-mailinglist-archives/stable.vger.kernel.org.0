Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BFD29658D
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 21:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370442AbgJVT5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 15:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S370439AbgJVT5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 15:57:12 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94363C0613CE
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 12:57:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 144so1872613pfb.4
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AmRE8rA0X0q4DcZtYzzd6wXJaC1ipu7RvS4WBDaksTE=;
        b=SFr9hMdEgrBYyiwT0npCB/LqOf75v2ykuSZbhQx7In/OaaF0ot4QtLp1VQ626VyzBN
         F3iD24OudI6Lm3pj4dj+neJ2QcBO4b0efOdt0YBlt2htK02XstCnT8L2WlkSCZlFjstp
         qyhWEERT6x9iZEPgsAOzYUU/MieIYkryyu2W0k9FbQHmedJmLBgoGgQmDQnMt8JWBOM6
         /CwrGTU8tvQsYbSiyAo8eooJwXrUDe0yKRhqjK5fO9ZWblZa5GvHAtiLJ8155BhDIN8L
         T84M8QPhDLOCO9Hm1U3oRBxL4EjhirN24OZVTHqkCBEHTp4JzZQWYyOfjGBfHqpZM73c
         XsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AmRE8rA0X0q4DcZtYzzd6wXJaC1ipu7RvS4WBDaksTE=;
        b=LLMb3B8lYNXP5X1Rw0IbFLghFZMzSPqlBZnKT2w0Ry9X4wObwN/A9qimlzoahDXsuW
         vv5n7bDZ/rYx9+IWA5/XGjRpgaVkNvsqQayIU/JjaUmBdeh8Xsg62zvjwTJrrQAFehma
         t94qDZjma1gERMuZiA4z7l+NQvSv2uQWhfoTr4ybt6eC3XpZO2I/3PHchVSBeVO96jO1
         WrMJHPFaXBj9zbpZ1TSbtx0CPuWIGrlKGEUdVEysVyZHy2eAUa0QklDA2XrGh7AVG/m3
         coTnMltqJA3Cq9q8pg4tbrlaXuoyHpC4iTdFFPZHH66vCnxJ83FDxJplopaWopv33cJb
         2qRQ==
X-Gm-Message-State: AOAM531VXZlMkGR9HqQIZTV+X0kFRIKUD5x4HwHTYqK1qJO/L7DH6eLi
        xd5Chn5U49VhBqfVz+obL6v9IHA53f/5Vw==
X-Google-Smtp-Source: ABdhPJz/aNBgmAmJbG0LYGx+sCBhumeZqHOJInQRbkDIdc7j/9XFGuD26U6Yi5SujDA1kOiA5gkrnQ==
X-Received: by 2002:a63:4f0b:: with SMTP id d11mr3826873pgb.210.1603396631145;
        Thu, 22 Oct 2020 12:57:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x25sm3269312pfr.132.2020.10.22.12.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 12:57:10 -0700 (PDT)
Message-ID: <5f91e416.1c69fb81.16363.641e@mx.google.com>
Date:   Thu, 22 Oct 2020 12:57:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.72-24-g088b4440ff14
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 180 runs,
 3 regressions (v5.4.72-24-g088b4440ff14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 180 runs, 3 regressions (v5.4.72-24-g088b4440=
ff14)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | regressio=
ns
-----------------+-------+---------------+----------+-----------+----------=
--
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 3        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-24-g088b4440ff14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-24-g088b4440ff14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      088b4440ff14b5ccab572077650642dfb5113f1c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | regressio=
ns
-----------------+-------+---------------+----------+-----------+----------=
--
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 3        =
  =


  Details:     https://kernelci.org/test/plan/id/5f91a86478c441215e11095e

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-24=
-g088b4440ff14/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-24=
-g088b4440ff14/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f91a86478c441215e110972
        failing since 22 days (last pass: v5.4.68-384-g856fa448539c, first =
fail: v5.4.68-388-gcf92ab7a7853) =


  * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/tes=
t/case/id/5f91a86478c441215e110973
        failing since 22 days (last pass: v5.4.68-384-g856fa448539c, first =
fail: v5.4.68-388-gcf92ab7a7853)

    2020-10-22 15:42:20.722000+00:00  /lava-2740803/1/../bin/lava-test-case
    2020-10-22 15:42:20.731000+00:00  <8>[   23.353458] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/test=
/case/id/5f91a86478c441215e110974
        failing since 22 days (last pass: v5.4.68-384-g856fa448539c, first =
fail: v5.4.68-388-gcf92ab7a7853)

    2020-10-22 15:42:21.752000+00:00  <8>[   24.374792] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>   =

 =20

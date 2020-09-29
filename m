Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C10627D7DE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgI2URs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2URq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:17:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2FFC0613D0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 13:17:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q4so3316513pjh.5
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 13:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GqFPbJxBPN+7UMUmdlTrnoyF0IrgkuFn3tICfmWYyfo=;
        b=CtcICzWrAWn8Y+ARCDila/Xw3zs1BQHxmxe4lfFrDnKE+deOyz2fSD3HqQ4La20UNJ
         8cu251cUyFkyeujQ+JWumI6Xon5KIpWEzfxTwY5omI8QbGYQjDgSExfEtZ7dgv983j6H
         yMV94VebA1roDsoTYviR2uzbyIEvA95yW7DAKyY5LCZrKtDeOXYG6myCdaZo2rE8coLV
         npOpcWHS9w2cOE19yb/APaY1Sc44SX7TREzcEDzWYhpxiLrZuW+5M9olkwp1mB/FHt7B
         IeWZJrzR1LWVe4n4EG5g+bu5HMdjDvQWk//MlidvQIE2Rnd4IUNdVKvaJ3L2GuMtfTgj
         /CWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GqFPbJxBPN+7UMUmdlTrnoyF0IrgkuFn3tICfmWYyfo=;
        b=DqtOvjKGS/6ht+ih5I1d15t5LU7nbHXyJswikVsciIY4mUQKf0UDVOV8hTJlAe9HpN
         tjK2L70FYIHXI0MMVTwGDHhhYuWqY4Tb6QeuAjHzSCSeNnq4PwNpSOUv2bCooZhOaQii
         B8EZtg4FTVBN6Xxi6VucTqe0qFuZTo5Lno3KMffC5e3dFd6bJcMZrw8GyyZg4ea2+0fK
         A+VI2RkClf+E0scuzAPtwHtgfDIb302w3RfdRTI+S/0Fna0zD2VToBJ4KsEDm8fnubwY
         HgqW29skiRrQ0GHWteWVKJMaFZ2Q2m+2VNFkH/9xxSILn4pbnQmpbIHuWfGv3idmcAcq
         qhIA==
X-Gm-Message-State: AOAM533S2R8RNm9z60LQ7ggInlRf4N1ceFLEOVMcQ9JOMpISGI6ekFec
        Ah262/1K4Q9cmyEKN6N7gQBjXQfPEnCwKg==
X-Google-Smtp-Source: ABdhPJzpBf5Ni5ejybkfCYHvNuXke87ulJeUjvng+uzu0nJAgrkMd0HpI/djEbSz7vHj30SjIgPUkg==
X-Received: by 2002:a17:90a:ead8:: with SMTP id ev24mr5455540pjb.89.1601410665602;
        Tue, 29 Sep 2020 13:17:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q65sm5396473pga.88.2020.09.29.13.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 13:17:44 -0700 (PDT)
Message-ID: <5f739668.1c69fb81.aa2f7.aeb2@mx.google.com>
Date:   Tue, 29 Sep 2020 13:17:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.68-388-gcf92ab7a7853
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 3 regressions (v5.4.68-388-gcf92ab7a7853)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 3 regressions (v5.4.68-388-gcf92ab7=
a7853)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.68-388-gcf92ab7a7853/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.68-388-gcf92ab7a7853
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf92ab7a7853eef0e022568ad6721512a4580df1 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f735e8b764b2b6748877169

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-gcf92ab7a7853/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-gcf92ab7a7853/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f735e8b764b2b674887717d
      new failure (last pass: v5.4.68-384-g856fa448539c) * baseline.bootrr.=
cros-ec-sensors-accel1-probed: https://kernelci.org/test/case/id/5f735e8b76=
4b2b674887717e
      new failure (last pass: v5.4.68-384-g856fa448539c)

    2020-09-29 16:19:15.583000  /lava-2668162/1/../bin/lava-test-case
    2020-09-29 16:19:15.592000  <8>[   24.021925] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f735e8b764b2b674887717f
      new failure (last pass: v5.4.68-384-g856fa448539c)

    2020-09-29 16:19:16.613000  <8>[   25.043780] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20

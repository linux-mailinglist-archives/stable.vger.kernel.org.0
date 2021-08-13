Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C9A3EAF5A
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 06:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhHMElh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 00:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbhHMElg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 00:41:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2C7C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 21:41:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso18926144pjb.2
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 21:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gJoaW8/bPIGpoHPCqgl5MGYaJcFsmOOOXzCc2cqrNwA=;
        b=sRgzssGznnZBlIkJAAbaabEEhwA+CnaWqUSeqDbx/TgFERJa/+NScMR5W3cnH9+OLA
         NdoWZRzilWM1k7mKnDZWhlMzIlWwrDXSf4H92vh/f7Wlc++Eaekkepy1DpGxHDIgJwJQ
         QsL4pjoObLivjWKWgp3zNnoxdbK8YS6Lcp9FfcDD8ffnBb3J6ZkyTIMENB2rcZtTI7et
         0NNqimbUVIaMKRDmzq2/fzvBG1oTsTg7SzAHMyOzudK2wc166T7T+bG765/PVhNSPNv4
         IKrQRIZYICEV2nechxqrF7qJibVju9zrGKWrkgNtHkqzxZrIOgiWBk8D41I00Ez6D2I5
         UP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gJoaW8/bPIGpoHPCqgl5MGYaJcFsmOOOXzCc2cqrNwA=;
        b=i/PZclKn7KBihf6yaMx06wkhkZh9/SPRMJ7mTz8N74ATmyJXpYH6n9ydzX4Gah5Agj
         gKuQkHHFOqI/K0dHRG5bThyfCZfwe9MwkXSArRrjHVmQz1f8wreg5DtT7KvKF/TIzOFG
         GUDd43llaEqBLZSFAIGMLm48exJMRp7sGohzwEr6dlbVVreQvwx07WEYJlg4jw6TbV3P
         SYiE6bOj/ql9ifacsHJs+vo+y21GQUkh9ujWC+81OBJQxLxBDPoVs0j/NEVIRMnGKIop
         DBiRhzo4yWKkg6OcXKvLvUIih5IMDkj85DsIzylIxkGnHW2FJSWybqBoU328nxbIX5K6
         hW0A==
X-Gm-Message-State: AOAM533EoT7nJ5XTuxUnxoV+jo7FcIWkKdCFBKCWKJFVWLt5gaqfVwZh
        gAHu5ZetvAWUzy7WxBPuQmqUaMru7wv4dUJe
X-Google-Smtp-Source: ABdhPJzIKvIGy9YkudogHhjc6BQwGVua96D5FRkQjdeB0doW/GWY7J9bU/cwgj484jOz6F6BrF3pZw==
X-Received: by 2002:a63:33c9:: with SMTP id z192mr603761pgz.42.1628829669914;
        Thu, 12 Aug 2021 21:41:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id dw15sm348157pjb.42.2021.08.12.21.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 21:41:09 -0700 (PDT)
Message-ID: <6115f7e5.1c69fb81.30e4b.11ba@mx.google.com>
Date:   Thu, 12 Aug 2021 21:41:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243-38-gcd75c55a5afc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 144 runs,
 4 regressions (v4.14.243-38-gcd75c55a5afc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 144 runs, 4 regressions (v4.14.243-38-gcd75c=
55a5afc)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64-uefi  | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.243-38-gcd75c55a5afc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.243-38-gcd75c55a5afc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd75c55a5afc3cc59113fcdcd4c923f0fe391b54 =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64-uefi  | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6115c884c239735011b13668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-gcd75c55a5afc/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-gcd75c55a5afc/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6115c884c239735011b13=
669
        new failure (last pass: v4.14.243-38-g7e1cb7d15ad6) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/6115c55d9c12c8fb70b1366f

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-gcd75c55a5afc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-gcd75c55a5afc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6115c55d9c12c8fb70b13687
        failing since 58 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-13T01:05:08.779659  /lava-4355866/1/../bin/lava-test-case
    2021-08-13T01:05:08.796695  [   16.303340] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-13T01:05:08.797208  /lava-4355866/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6115c55d9c12c8fb70b136a0
        failing since 58 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6115c55d9c12c8fb70b136a1
        failing since 58 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-13T01:05:05.329776  /lava-4355866/1/../bin/lava-test-case
    2021-08-13T01:05:05.335811  [   12.853623] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20

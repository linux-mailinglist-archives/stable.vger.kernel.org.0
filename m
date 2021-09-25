Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A4F41802D
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 09:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhIYH3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 03:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhIYH3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 03:29:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75862C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 00:27:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t4so8156851plo.0
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 00:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5OCM2fiYirS4Egfv/V5YIdp2tPpcToAJORxUmlE6Rs4=;
        b=g6zcAeMAl7cy7lNb0/KpcAk3kKLm1oS9Cw4Y6VA3ZslCPMxRcK/VlMfWOVXiqZmVDm
         VesXiJvN2M1NvdsHtD7ykqAMJteelDV0ZWsRLYCAGFv5zwBTZ8jYq2k37D67X6oowAWO
         UdcwPW80k4BmUME6ZzIvt0yxlKHt2enmEZ1UIEXJ3a0CKKEJg8QQQ9MJ+pEk/nWwihK/
         0UdH7eQ9ee/stwMulccMPeu4rOtqqmXyl22R07JCCG3ePjaHivC7SQJ6tPP8ifKwFTtr
         w4q2eqoQKKxquUZaZGZ3QSgrKQsTtRWShez5PRuyjnUyDmu5vakR7qJnIgj11KDUA1SB
         tb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5OCM2fiYirS4Egfv/V5YIdp2tPpcToAJORxUmlE6Rs4=;
        b=ZmJ/7v2zCrtNPFmAFtjHgHAsNlUYB24mXNJJl2YkW1PkHxLtMycgZ79i9y9NQCGV06
         TlaQfEjaFXQ7Syy7eTNZiQ5S3dDQwRj0jiRCMYK4sEFoNNU6ylHBH6loCywDe13xcYzB
         b7l8Ps/SGxF7vhM4cwHB8bzU5MP7C/FnaMXP1hSCZlFqq4RVm3U5eVx4AZ2gyosRu8my
         15bJgSFsYENNETnNb7/nLCmIGgPLt45qfaUQCkO+JYI7HYYag2d2iAs+FK80tsRN8Yr2
         pfpBMczN1wmtX6deESJN0Iqyi5ii2h/DnDtt0Qt+acxx4UP3WCEiLr9qPfkbgnUQeso7
         cciQ==
X-Gm-Message-State: AOAM530+DcCpIg8CmkTQEM3jz8aUKf8FTmTpo5pWzIVPdJW0/Bq8PCyj
        MOEMJKV4DXj1lbi5oYy0dbVRHZDx75SLI6jF
X-Google-Smtp-Source: ABdhPJzhccAJFoVyItZfAfk6ObF1XQBrBnxS6m2tlbJIN+xQSMbt+t+SxBdUXghdoB+7osict3oz0A==
X-Received: by 2002:a17:90b:23d7:: with SMTP id md23mr7060660pjb.76.1632554846788;
        Sat, 25 Sep 2021 00:27:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22sm11035365pfi.149.2021.09.25.00.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 00:27:26 -0700 (PDT)
Message-ID: <614ecf5e.1c69fb81.89e0.3588@mx.google.com>
Date:   Sat, 25 Sep 2021 00:27:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247-27-g0aae8faab314
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 62 runs,
 3 regressions (v4.14.247-27-g0aae8faab314)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 62 runs, 3 regressions (v4.14.247-27-g0aae8f=
aab314)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.247-27-g0aae8faab314/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.247-27-g0aae8faab314
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0aae8faab3145ee8bf1602b4d9256c503f58dac7 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614e9106db1546a34e99a2e0

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-27-g0aae8faab314/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-27-g0aae8faab314/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e9106db1546a34e99a2f4
        failing since 101 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e9107db1546a34e99a30c
        failing since 101 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e9107db1546a34e99a30d
        failing since 101 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-25T03:01:08.577269  /lava-4581592/1/../bin/lava-test-case
    2021-09-25T03:01:08.582501  [   13.155760] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20

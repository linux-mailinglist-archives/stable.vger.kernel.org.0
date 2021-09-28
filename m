Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB8E41B3A1
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 18:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbhI1QSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 12:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbhI1QSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 12:18:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1475CC06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 09:17:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso3228601pjb.3
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vAX0+oqO1q+LUNQx3iEB3eJqa38Bort79uhRh4vE+cE=;
        b=fqOQuJhFJfOc/ntNLQPdT5fgo2c9i8VD+NQHBaGO6YsMwUGdtdA6052xghzhQvutp0
         NqXuhDFsVgsuiGxnVJc+zOjdCrw05j5xSsYCrSQPp0hdsrPhd98bnkae0VMFzRfnoSlb
         2Lc8VsUFfA8eoR2/QGtWIN71TGzKTI+0wIWdN1riviuSCH2s+0HHSfOHHEEpVo0xV/De
         kU1eaLepEbSwtcN91KOyuQnVcH/U5lP0h27WCNMmf1jenUEitaI+Tyeh4/Vv5C7uecgB
         wFGGDmZY6KLwQCH6NdsCiSNaVP1tI/SPHY8NGRy1fZM89epU2DUGUKRbXaB14jJN7mZ5
         3axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vAX0+oqO1q+LUNQx3iEB3eJqa38Bort79uhRh4vE+cE=;
        b=4UoE+wcBm/lR/8zAsXvATcfRv+605IBFeUj5E4kRzQX3SI+Inq3NL169B6UlgHjVFn
         T591NphpIJeRKrzDMx9zx6/GC8ub/QACFn9wpU6Y+oMLamaBqVQ6ON+7dwriETnVQZx7
         lLDqVEERMWBI8L1i0vKzgchKYCUl0sT0ifD8NpH2HEyDGuSWThet74rLOFD/NztvfQq8
         aCIqopM0lgrf5J8N+WwTQ9RAEpChLFoSJSexnxEORLLeRKuSdgbIiCtRm5p0S9OwjHs8
         K+c2DnwX13VSQqZeg7u/T+TTptGUqP3Kyto9/2mGpIg+bJb+tgGKLf7+4SsZY9BEvHSF
         Wn+w==
X-Gm-Message-State: AOAM531Tnlt4+x3WAUO9v3It+cT3igPuElApzre0ejUFaeOyxLimaccy
        00rvaGDgyUXqiC9TlWA4X8Zj69w/fuTVVwWj
X-Google-Smtp-Source: ABdhPJw6ZuK3rFXbaa0YnFOuCpwo3aCNqb9CiKRFNYppbJf0PcZ3yk+Ip840IfwekI/0qI6Di9fIQw==
X-Received: by 2002:a17:902:8307:b0:13c:ac55:5e1d with SMTP id bd7-20020a170902830700b0013cac555e1dmr5832386plb.56.1632845827211;
        Tue, 28 Sep 2021 09:17:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm3013238pjc.29.2021.09.28.09.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 09:17:06 -0700 (PDT)
Message-ID: <61534002.1c69fb81.5732e.91c2@mx.google.com>
Date:   Tue, 28 Sep 2021 09:17:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-41-g90e58933cbff
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 106 runs,
 3 regressions (v4.14.248-41-g90e58933cbff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 106 runs, 3 regressions (v4.14.248-41-g90e58=
933cbff)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.248-41-g90e58933cbff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.248-41-g90e58933cbff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90e58933cbffb000cffd6538ef7e7d8ade24c236 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/615324b0437f722e4e99a2da

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-41-g90e58933cbff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-41-g90e58933cbff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615324b0437f722e4e99a2ee
        failing since 105 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-28T14:20:11.232290  /lava-4593844/1/../bin/lava-test-case
    2021-09-28T14:20:11.249097  [   16.867299] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615324b0437f722e4e99a307
        failing since 105 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-28T14:20:08.802249  /lava-4593844/1/../bin/lava-test-case
    2021-09-28T14:20:08.819318  [   14.436710] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615324b0437f722e4e99a308
        failing since 105 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-28T14:20:07.783554  /lava-4593844/1/../bin/lava-test-case
    2021-09-28T14:20:07.788934  [   13.418117] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20

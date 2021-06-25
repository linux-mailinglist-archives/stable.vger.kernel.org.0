Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C53B46CA
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFYPmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 11:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhFYPms (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 11:42:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE5C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:40:27 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso5754304pjp.5
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j+JjDhnJj1pwNv6zeypYZOx7iWYpMvoVRjNG6bdCnt4=;
        b=WmhHi+8bRQ9a/OS/iBSYmeKaE7f4bH6qYoI2xGyriTdV4wLTzr5hWspOzZ04kz1dVu
         rl6p4GJnpmLXpU1tuGPsncfGsda3fpj5XTH6tWQlB5o8qDKpdnToW5+MK/NCHw7dnipc
         ZvyGV9qSNI+cWEpqU8frrceRSyodbz9WhnBh/2YcOr2HpDdAdZF+e0vVLZQKZOBaBZfu
         kA4kx6ce7BiH/P79P/0p2OucvIpLKdnp080mCH9Eiys0RtgPmgGm17p0nC0LzoVvWWlW
         EdZ8KOf/T4unrdTqhV0SsauDJkQuJM+87ANWKXWeRgK1vHNUC9azv47oVCyI4fmhBWDh
         5/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j+JjDhnJj1pwNv6zeypYZOx7iWYpMvoVRjNG6bdCnt4=;
        b=IrR0wiaYs6tDmXEgPtezi96FFPqcx/SBxSRnxUzlOLlS1czoxfgzSuAVrk1lxtujuR
         5QNG34H133+XbECIjUWJBmTcyd/O45sNI0nb3Z6hnzcW0cgUCbRCDx75phrD9LDV+lwc
         CiaN5DJ4cKgs83mPNzw0xP+9On2wGgVrUW+EbY4ZqQM/lCFa3kG7tO7gdzskMxSfqWlq
         5Fo7AZirXehMOSAs7JKtQZ25TKPl991Ji1K/Q18kmOmIb7SEetWdR0Cz6FUDFXCV4mMv
         1av6namxVEEkNAhC0L445CLMNdhiZ41Z4m6AgqKPhL7i28A4vD0TihW7hxyZIXy9/MIL
         qGTw==
X-Gm-Message-State: AOAM531ELASHxui8AEtTvhmCmybcqxMVMKUSm91lfxfu13jrmKLG1d9H
        n8kHUG55G9FiCU6adp7Bjs/tqedf/dGHJTVW
X-Google-Smtp-Source: ABdhPJzB8FPYiHyC/Fr1yYQxY5KAac1E+JMQxY9a+yBpg3OWsggLG62XYZPerGy1UgBXr6UcFaaIHA==
X-Received: by 2002:a17:90a:9205:: with SMTP id m5mr16757570pjo.172.1624635626547;
        Fri, 25 Jun 2021 08:40:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16sm11421319pjs.33.2021.06.25.08.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:40:26 -0700 (PDT)
Message-ID: <60d5f8ea.1c69fb81.940e8.f5a8@mx.google.com>
Date:   Fri, 25 Jun 2021 08:40:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.128-10-g0a9712e2f437
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 152 runs,
 3 regressions (v5.4.128-10-g0a9712e2f437)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 152 runs, 3 regressions (v5.4.128-10-g0a9712e=
2f437)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.128-10-g0a9712e2f437/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.128-10-g0a9712e2f437
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a9712e2f437632b5ff15588b39db129d12bf4fa =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60d5dc9702a552b1ab41326e

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-1=
0-g0a9712e2f437/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-1=
0-g0a9712e2f437/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5dc9702a552b1ab41328b
        failing since 10 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-25T13:39:28.844714  /lava-4094318/1/../bin/lava-test-case<8>[  =
 14.157875] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-25T13:39:28.845123     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5dc9702a552b1ab41328c
        failing since 10 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-25T13:39:29.858844  /lava-4094318/1/../bin/lava-test-case
    2021-06-25T13:39:29.864740  <8>[   15.177352] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5dc9702a552b1ab4132a4
        failing since 10 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-25T13:39:31.301480  /lava-4094318/1/../bin/lava-test-case<8>[  =
 16.602985] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-25T13:39:31.301839  =

    2021-06-25T13:39:31.302072  /lava-4094318/1/../bin/lava-test-case   =

 =20

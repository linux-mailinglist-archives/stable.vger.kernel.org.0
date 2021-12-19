Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED747A222
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 21:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhLSU4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 15:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbhLSU4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 15:56:21 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D7EC061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 12:56:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r138so7571730pgr.13
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 12:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nqb0ihPOHaV31f4nAkSZhX6Upg3deVk/0g+uHNxiNsY=;
        b=NbcX6G69k+/HmMx45Wv0jzfPUZjdo2afsoXPMJpmxCpQz3YBZBSzjdFdC2P2g0yzql
         f9Ny1XSs8wQB4u7WNDx3gJbAyxXOJrgYBgmRY2Ffxe6yvfycU3p214GK8M2Tlkf18Vwo
         85wuCJKi7tSL24rog6HIkjvkXAZ1PXXgvximbgL+ChIqePetUEVZQwq0wjrzhlKqDeZv
         +U4uWygAPJs4m14j1OdefkcjD7Kvft778rdCfYNWhkzq3AhtG1CfCM9C0HUvUA+vjscz
         qG6majotvziEqcimki2imBSombe+cgDqEtzIgEVQ9RYZhsalseSSohQsEIULM1XhMK4x
         JH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nqb0ihPOHaV31f4nAkSZhX6Upg3deVk/0g+uHNxiNsY=;
        b=alT5gBM+4DpqGniB69znjjXXSG9KEDDGlwk0jvwAyj5AOKKTWGcQFAJ2/WhLJ/LPK8
         pXb3Me/BewYqXBLect2f6/6PkNS+NAkuLhVV2Omxct17XefTm/a5iMeK1Gbc6lhLnTqY
         CM6ku4E+HZEn8ci6zYxi1+SGfGb2Ah/zrOFk1CbKdksBz36NF9OAiLgN68uGtlkqqU8l
         CWEG4y0Xm1ds7XgzLfYYX4vZ3LxD9xRAOjcDbURsp2fPcAgP+tmZIbZrEMRA3jOHQUlY
         B4MBhSdzVkm+6+fvm/khBd4n7pklX7IaBUbRSugK4aNzn1Cfp2zV7istTOHmCu1z7Ukd
         4waA==
X-Gm-Message-State: AOAM5325CarBysIHSv2D7gBk1laie5pKXsqoSdUNxlHlkJbxQOcea8Je
        HkCFISWIEio9k91BHWG36UYkkjNLLvg9k73J
X-Google-Smtp-Source: ABdhPJzC7ggLlJCrziEOBV/Rmg2nQ3qjva8mpf5JlK56tvKnUScCny2pRkJMwOEWpYSUNFVWHCrfeA==
X-Received: by 2002:a63:ff4a:: with SMTP id s10mr11934611pgk.191.1639947380837;
        Sun, 19 Dec 2021 12:56:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9sm14719956pgl.26.2021.12.19.12.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 12:56:20 -0800 (PST)
Message-ID: <61bf9c74.1c69fb81.43722.9b29@mx.google.com>
Date:   Sun, 19 Dec 2021 12:56:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-14-g2b3c2f816b58
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 1 regressions (v4.9.293-14-g2b3c2f816b58)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 1 regressions (v4.9.293-14-g2b3c2f8=
16b58)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-14-g2b3c2f816b58/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-14-g2b3c2f816b58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b3c2f816b584ef729e14cd4e48981a727d09e0b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bf63444710ad552c39714f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
4-g2b3c2f816b58/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
4-g2b3c2f816b58/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bf63444710ad5=
52c397152
        failing since 2 days (last pass: v4.9.293-7-gd89b8545a1fa, first fa=
il: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-19T16:52:03.117159  [   20.155334] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-19T16:52:03.159687  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, ksoftirqd/0/3
    2021-12-19T16:52:03.169088  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

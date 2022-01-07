Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACD1487C23
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiAGSZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 13:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240991AbiAGSZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 13:25:30 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B281C061747
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 10:25:27 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id h1so5465312pls.11
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 10:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SoDnX74z6fho4jOEfmWA/OaHXv7LSjFf4PBe5xOBBQA=;
        b=pu9N7KOkurvaqnJXfORDpoyPwpKsF76o62vp+qjGPx2+Uvhfx5CnZ/fzB6hTV3xLtQ
         8e74aCQo6wQirrd0svxIDQz10VT9FxItZraAF1vE7rMbRtFu7MmWxzJT0w65DD3Ln6hE
         KupAlYF8wp0hhWaPxElZGpXlUOjO4nu54K00q+cfh0tNBA3+pmpOLovwOCmQxPfSob3n
         G6IWcHlv/aBOO0ATLQViXGrOmrBhpFnXlPDxtQjSIW3vIW65r053a8NxrzRBYrudSPOM
         TYPsAy3qxEQ4OMuMNME03yqBwg+PQyRov4+Sr0SJGFk1jHi0aCr2DiglIqrarKHHdNrR
         Aimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SoDnX74z6fho4jOEfmWA/OaHXv7LSjFf4PBe5xOBBQA=;
        b=Xu258JNyRI+e4xxSv2HaLaSEwZ51lG+R8BA+g0aUn/XwgCvxdQhT/xCmPXDsdle4gI
         YeVd+wKo8d4WGdGG59xoaQ5v1QFETguVZkEgwMdokj8eTZtjmXUWrW/31jIloTEpzObg
         v+U28a7VUeaBuxFluwmH12doyn9en4Bq208dvWX19AjZP6pBj9CU0yIdhxf437vy5eYE
         ky0033psXUdctby12mOKrS7bF4FtLYeNbPvjJmBk3FoEuagfemf3F0B3E0dVMIsFOzrL
         hk3IGH4m+22Wb3J73AJVPtvfBi8pULphXt3y0cjAEEuBs7Avd6tHXISs0+8QG75SaFna
         rEhA==
X-Gm-Message-State: AOAM530KbbC7+d5rIY/aeOhrK7Ml20fMrNEuwSPV8juKjX+vJoI83wEA
        fbqqt0Qticipn2I5VVpqkd7VOjIzKPv4H2uX
X-Google-Smtp-Source: ABdhPJw3mLcG6d/r7xmWrZM8tZGl8Ceck1tyCPjm50dq2Ump1cBnuNR/9E4j7ZI0Ri17urbSkByQlA==
X-Received: by 2002:a17:90a:e7c6:: with SMTP id kb6mr16995090pjb.200.1641579926867;
        Fri, 07 Jan 2022 10:25:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19sm6562058pfk.83.2022.01.07.10.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 10:25:26 -0800 (PST)
Message-ID: <61d88596.1c69fb81.66b4c.0656@mx.google.com>
Date:   Fri, 07 Jan 2022 10:25:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-5-g7203781ae31d
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 116 runs,
 2 regressions (v4.9.296-5-g7203781ae31d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 116 runs, 2 regressions (v4.9.296-5-g7203781a=
e31d)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.296-5-g7203781ae31d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.296-5-g7203781ae31d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7203781ae31dbd7a37a3746b9c410efad7e9d553 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61d852a0084b07c159ef674b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-5=
-g7203781ae31d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-5=
-g7203781ae31d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d852a0084b07c159ef6=
74c
        new failure (last pass: v4.9.296-1-gdae9eb7a8688) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61d84dcf7b3837c178ef6756

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-5=
-g7203781ae31d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-5=
-g7203781ae31d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d84dcf7b3837c=
178ef6759
        failing since 10 days (last pass: v4.9.294-8-gdf4b9763cd1e, first f=
ail: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-07T14:27:02.656587  [   20.459899] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T14:27:02.707753  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-07T14:27:02.716916  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351F748E3FF
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 06:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiANFuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 00:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiANFuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 00:50:21 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C4CC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 21:50:21 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m21so1861566pfd.3
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 21:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zUReR4RSMmCnmAkPtDcesEVuwZ6l1vleAERhdCJG9+o=;
        b=MfGEtCk3iAKs+dHHkbHnP+Gsfl3VwbJwUGQPNVsi0TE7HawJRcwE9dvPmaQCugFAgA
         UO6LiuyNqylHaId8JTESk9dseSsBp5fcWEffIq8l/XvPpssQg4Cnks56Y205Kz0FbRTL
         lgYWcmLm987mKtr2Lw/ANnGBM+DSXE4/DX6OQRa1WQ1AZw0ol5kaEvdtPqbrUTiYj0wb
         zyehCz0fNar5m4lJgJDRvUMOki9KDju06djNvFX+CsX1ny7xwK0m+/i7P52Gwu+T8s2K
         2T069CF3Iva8IplbRFS9Ou2dUAPPddqf9ZIZLO8IkxwwHIT5ugYBFs7v5ezBy9zQUY96
         zS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zUReR4RSMmCnmAkPtDcesEVuwZ6l1vleAERhdCJG9+o=;
        b=V1cTX1rbBmIQuV8hl/c3WmEyOW9KRhfNzyyr1AYcw7K8tYQJLWsFwepFBjdBNZ276U
         ti8J0Sza+m+aqwYhW+eHe1xx0hdgnvNlGlpiFAVDw2SOnFj8mauj4B+rLjaXYcFDrqBB
         3schRkUUI5Bhw95t9o5Oxh0dGl6kgW/td9SUHtfU8eEEsstErY6NcrgWRQxKKwelMcSA
         PcTdknDUIgNe443mafVVVbVqZmgZBczjQYkGA5j9kPSKosL70aCi5vGpFDdWYN1tTBec
         8um5dAN7aAxn0sGjTGNHh2+CNRzOJK1S9Bt+4Cy7QwZHG69qT6D9zhO4jlqeUYpO0p1c
         EIrQ==
X-Gm-Message-State: AOAM532xzMEg1yHGyKjT7P2onVyd0N7YBqKSzzKZ8OnI66GBAH467XsM
        M60SdvbDpPDNkqmdZStvVL2xUk+Dpg619enVXfQ=
X-Google-Smtp-Source: ABdhPJxElRUROleg97EQB7WL6JoVHkTVKycD3aZ5XDBoUZ4QWjzspyYCV3UjjkoQY1vhny9toAATFA==
X-Received: by 2002:a62:1c12:0:b0:4bc:6d81:b402 with SMTP id c18-20020a621c12000000b004bc6d81b402mr7416970pfc.40.1642139421104;
        Thu, 13 Jan 2022 21:50:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa9sm4323430pjb.31.2022.01.13.21.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 21:50:20 -0800 (PST)
Message-ID: <61e10f1c.1c69fb81.5e713.cdb1@mx.google.com>
Date:   Thu, 13 Jan 2022 21:50:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-9-gde85bd6851bc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 121 runs,
 1 regressions (v4.9.297-9-gde85bd6851bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 121 runs, 1 regressions (v4.9.297-9-gde85bd=
6851bc)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297-9-gde85bd6851bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297-9-gde85bd6851bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de85bd6851bcb580db619b575638ebee29765379 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e0de4718c2d95830ef6743

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-9-gde85bd6851bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-9-gde85bd6851bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e0de4718c2d95=
830ef6746
        failing since 10 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-14T02:21:50.840237  [   20.119293] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T02:21:50.881860  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-14T02:21:50.890939  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

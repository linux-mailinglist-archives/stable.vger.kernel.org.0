Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EADE53549C
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 22:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbiEZUjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 16:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiEZUjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 16:39:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CFB45AF7
        for <stable@vger.kernel.org>; Thu, 26 May 2022 13:39:35 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c22so2277721pgu.2
        for <stable@vger.kernel.org>; Thu, 26 May 2022 13:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xj+U7vcO8KQfy3QeeVmb91JXFmwPOTbsedRM9iOfBiw=;
        b=26XpzNjZqU/wNmzVrGX6PT8xcv2f4rUWwh3y/U4N63TBGzRpGeueDEijoOXj1wL00e
         0fkgKSGLhKtSSyEqYAe/z3WAFwDp5SGK9/Ps29I2sIqPIEDWlfJ0GuEUWC0D7ZAbYOWe
         n/cnEdyUd8CvWB+ZTJMcubkkrT08GaCLJH0llcf1H+yRyhZwiokfnTK7z9UPHkRo+Z9a
         o0iAnxOsh6W0ZhMnuOi/J2NXJNo/G1VGqXzWW2JLzyNetSsK2GZrOv0uXUvFqlvfit6U
         1sgMsTqAdv03Kl8PxrxOrYod0ngkRte4nZ72Y2TsX4QrVT+etxMyNj2O4oV30BFus1oB
         qTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xj+U7vcO8KQfy3QeeVmb91JXFmwPOTbsedRM9iOfBiw=;
        b=N/FpQajWj27rJBy0yuTO87grmCkiL80kAaPzSQ2ygiuUKYfiRCZ9XNih4i/H38nOCe
         I0PHlizHMrEYRUIRYrP2iWpzX2jAfj7sj6BBlERHiws0kY9CT9Hp4Mfe0O3Aor51a8s3
         A30JmaygxYiNtN/hfkZytM1M2YS3MbVd84FGrvwYs+OUXV6A/nfxZuVtO75IxMa94WHp
         Myhr8can1geggaMes5efotTYjVW5Td56auftRNw+4PVb1Py/EsbR40vN1vVnQHQWziCz
         VC+Hp39Cox8YTZam/1gPFtYclp22fgwhgsUpdoO5mRj+QkJOI+FMV02XYMwOLL9LG8ro
         zJTQ==
X-Gm-Message-State: AOAM530SCuIWJ61yMHsQeSP1aLxSToAwWj5Qcn/aJbBRjizB1tUHByy+
        dTy4lC/BdQwhQSz/MUlSDUluNDpIR/T3WVhoJSQ=
X-Google-Smtp-Source: ABdhPJwBKsXUY2R8EStDrmCYz1vYZenL1Uiq+vBg849U0lp2YfLU3Xjf6SntyKy7/sm3Rx6DurXoxw==
X-Received: by 2002:a65:5acd:0:b0:399:24bc:bbfd with SMTP id d13-20020a655acd000000b0039924bcbbfdmr34574794pgt.323.1653597574628;
        Thu, 26 May 2022 13:39:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cm24-20020a056a00339800b00518142f8c37sm1952723pfb.171.2022.05.26.13.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 13:39:34 -0700 (PDT)
Message-ID: <628fe586.1c69fb81.93136.4332@mx.google.com>
Date:   Thu, 26 May 2022 13:39:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-110-g16e9bf68158f9
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 78 runs,
 1 regressions (v5.17.11-110-g16e9bf68158f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.17 baseline: 78 runs, 1 regressions (v5.17.11-110-g16e9bf=
68158f9)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11-110-g16e9bf68158f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11-110-g16e9bf68158f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16e9bf68158f9694c9bc86339f75f820730eebf7 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/628fb1ffbc018f3c68a39c29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
110-g16e9bf68158f9/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
110-g16e9bf68158f9/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628fb1ffbc018f3c68a39=
c2a
        failing since 3 days (last pass: v5.17.7-12-g470ab13d43837, first f=
ail: v5.17.9-158-g0fff55a57433d) =

 =20

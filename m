Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E1E5678BD
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 22:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiGEUtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 16:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiGEUsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 16:48:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6225B2728
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 13:48:22 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so13814335pji.4
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 13:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ayVmvGojXaIht7ocM8fmS97hM5Yk6UYmWjaMpwMqWaI=;
        b=JjxK57lHGV8v0gkSuQldozBgjE5dolWRewreLpfqzlgVwL7sey9Gf/HlwrxL2dm8XQ
         ItwTCECU5UeTHuaHc7sH/saIrfw5FTI2XDUoTo6lWYIwHnMPIenhVIH1PoZkgjSdCA73
         H5i7+yl1QEmm+gpGX0ppqGgRo//mm7/RGVMHJKwfmM+wyyiiEp11oZft6Yvx8R4c1SGp
         NAzHj27xPtGuvS/UywgljElWvKYdYWvfKUS2QN64mYcA33VkTo/8BvYO4izPwY95RcAV
         JFQhKihjL5jNIg/ZSdrDv1cK4cC2UBSGcHzjnHreg3axx6imM8ZXFuOfB8QYSSkbXiZj
         /mHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ayVmvGojXaIht7ocM8fmS97hM5Yk6UYmWjaMpwMqWaI=;
        b=jIivvxdimXGqHam1802VC+GUCquO6pIf2fq2uExbczXmtQwR7LRVYbSjSkvJcUswMl
         G16j9Wo0r3onAo7tRGmldEFuTpMzErziXTyMJJ0YXDlCc8rAcelrZ39uErP7Va+o+W0j
         JdJQEolhwaAWad63AGG3O+mSW35usPfEOeaLzeax+KEIkSTaZdyQAJRhNHiAVUfxsmpv
         5Zkc3nVRJvjW/yQQvFmhf9LcA9SydP2EiaTTJlZrk9KgwB+O/N5oXiwSGGCyn324N8SM
         bL35vsB9SloSE+xOvLoT4aEz7iyFbcd/WRrroKgIDQ28EABVdu8+23IPi8s4MqW01x1o
         pkKg==
X-Gm-Message-State: AJIora9Oc8V55zowvsh20Hz9iXzPJV/y+ywrwtVMma0ITuKA1cUPVNyp
        ZC8+32PwoY7kH3deqDizc61ZTr29wkxnORJn
X-Google-Smtp-Source: AGRyM1tjieabirpFeZ/cldDy/hLh3RU+TectXs2ElHRrHRUTwbjWHrtBxtrXQYIBVoIwe0ul/bvZ/Q==
X-Received: by 2002:a17:903:264b:b0:16b:dcbf:afff with SMTP id je11-20020a170903264b00b0016bdcbfafffmr15716971plb.79.1657054101581;
        Tue, 05 Jul 2022 13:48:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm23907845plk.3.2022.07.05.13.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 13:48:20 -0700 (PDT)
Message-ID: <62c4a394.1c69fb81.db0cb.2599@mx.google.com>
Date:   Tue, 05 Jul 2022 13:48:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.9-103-g7622cfa48fbd
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 125 runs,
 2 regressions (v5.18.9-103-g7622cfa48fbd)
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

stable-rc/linux-5.18.y baseline: 125 runs, 2 regressions (v5.18.9-103-g7622=
cfa48fbd)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
 | regressions
------------------------+-------+--------------+----------+----------------=
-+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | tegra_defconfig=
 | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.9-103-g7622cfa48fbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.9-103-g7622cfa48fbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7622cfa48fbd5dd4e0d25abab655ab754baea9a4 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
 | regressions
------------------------+-------+--------------+----------+----------------=
-+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | tegra_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c46c24648df491f8a39c13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.9=
-103-g7622cfa48fbd/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.9=
-103-g7622cfa48fbd/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c46c24648df491f8a39=
c14
        failing since 22 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform                | arch  | lab          | compiler | defconfig      =
 | regressions
------------------------+-------+--------------+----------+----------------=
-+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c46e8f7aa5f045c1a39cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.9=
-103-g7622cfa48fbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.9=
-103-g7622cfa48fbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c46e8f7aa5f045c1a39=
ced
        new failure (last pass: v5.18.8-7-g2c9a64b3a872) =

 =20

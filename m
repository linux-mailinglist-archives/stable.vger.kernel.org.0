Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0496569245
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 20:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiGFS6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 14:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiGFS6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 14:58:51 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A46E1EAD7
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 11:58:50 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a15so15118618pfv.13
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 11:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qgj7rhUbyTZQqrlhaHq3Lz3Bu/4z2ck7iKGHU/tEnkI=;
        b=IA4A+wCYtpzDtL9Hveo2E+a/3j3y0FhLN4opyRCusaPHZkULrJmRxJKX1BvxVHUM/L
         zvXEayt4KnvSJhtGUefTVm5lew4kgm/aH1bSi7pNEO/d97qg/xGvENfjFlE7CF7AUkt0
         pl9wHahBCwtp03skmoqQVxpkTYgXDPTDAMxTGAUsUzzulHLAb8rMyMTz/H4z7Hxz9ZKz
         73B3FHKabRCZsrJDhxgbwwTtojA7MvHFySLY7/VMBpooY+aqKlEyk/ZtqpwPo+sdjh4w
         jlsgQFrV8usjDqbQRjR6NVUtU/EpssxT5t9qEGP+Uzv94LJpBHpW6SIwUQxBACV4KtVz
         4bYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qgj7rhUbyTZQqrlhaHq3Lz3Bu/4z2ck7iKGHU/tEnkI=;
        b=kTgqn0N4F/WdJtiToCEoQbQRP/VWfNPKEykTsPBGw/tOzKleHzu6dreD6FM7WdFZQ0
         5taW+USl0iZiD82KPZjRexCWpChxRrjpfTKhwS6YBuWKariV4n5GEqnQOUjOfu72CeFy
         c/YeJzTENiFmpiSPriIrOEaeYfBMUUNCK1pdTq9nMEBPGy2cNcYxYK+O2I5+hiv78q1E
         HQZ0Qj7ss5BGj8PRRsxd6VF8dd4j+mVebA3hZu7PVlPuuOqr73xOQ1RqdTgEwxXQ3/+z
         mxNewzpTEEORV5RWigXa2yK5A2tV+tJFHpFpIT8pMpyUCV6YDqbjnaFPsJaU133esEa8
         a7ng==
X-Gm-Message-State: AJIora+LBMm3eAmmU12OWFsuIoc5t2R2inFJBH4VTLXDIkMWnWTRoBGa
        CfcubiCNSKiJDSD17X1GMvjkJNcpchSe4ZUe
X-Google-Smtp-Source: AGRyM1vkZvGZNA7CgeIlfuZmEKFsaAJq3uyogIT2Cv6QwwfNsTb7F6MBjCWYdKqZ7akC84kbDzWmuQ==
X-Received: by 2002:a63:149:0:b0:40c:f753:2fb0 with SMTP id 70-20020a630149000000b0040cf7532fb0mr35435202pgb.172.1657133929799;
        Wed, 06 Jul 2022 11:58:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090302ce00b001678a65d75bsm25985574plk.81.2022.07.06.11.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 11:58:49 -0700 (PDT)
Message-ID: <62c5db69.1c69fb81.41786.5e09@mx.google.com>
Date:   Wed, 06 Jul 2022 11:58:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.52-99-g46abc1c965f7
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 176 runs,
 3 regressions (v5.15.52-99-g46abc1c965f7)
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

stable-rc/queue/5.15 baseline: 176 runs, 3 regressions (v5.15.52-99-g46abc1=
c965f7)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

jetson-tk1              | arm   | lab-baylibre | gcc-10   | tegra_defconfig=
    | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.52-99-g46abc1c965f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.52-99-g46abc1c965f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46abc1c965f7323426185a25b27c6e647aa34dcb =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c5ab35969632b4f6a39bf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
99-g46abc1c965f7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
99-g46abc1c965f7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c5ab35969632b4f6a39=
bfa
        failing since 25 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | tegra_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c5a9181b419525a1a39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
99-g46abc1c965f7/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
99-g46abc1c965f7/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c5a9181b419525a1a39=
bff
        failing since 2 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c5a5fe1ee9b90d53a39c1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
99-g46abc1c965f7/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
99-g46abc1c965f7/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c5a5fe1ee9b90d53a39=
c1d
        failing since 0 day (last pass: v5.15.52-98-gc89c3559309a, first fa=
il: v5.15.52-98-g46dd125f577c) =

 =20

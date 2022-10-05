Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113E25F4D8F
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 03:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJEB4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 21:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJEBz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 21:55:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9195165255
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 18:55:56 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j71so7999903pge.2
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 18:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=77Yw/us8lFEDf+tU6PDaeNjWAXSq+UeviSPCXWsNrfg=;
        b=SbRQwoqSXR21N19+0KayczJDNAVRYYGze1rqLH+vToniBh3T10egojENDzz0XNAMOQ
         1Di5af+SKEkGle3eBeaKsu70uvKBkzgY3GNkFV795UdIg1Onqrc8VjNTdQ/FXcdObaba
         XlDar7K0BCBTUctJKN35FgLwiZfeMBJozhqrgi7YCOt5KL7JTlbAspt2okXzrga56Enb
         aumhYnZvy9cuPITWkbvjLsQS4/nbO50uq9bT4kmm8hYO6OS0odXhXJr8UekOG4kRRypE
         HZEsjPHkMHpSIbT9OuR84EASnkezE3udYl3l63hUgCINi8LrCg7oydSyKdI6dPKcIpxY
         Lw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=77Yw/us8lFEDf+tU6PDaeNjWAXSq+UeviSPCXWsNrfg=;
        b=R0w7OAq6SxpV/vy01mN+dm227nK95okX9iLxUASx+i1qjrCWnFvnbwmhrUCCN/1POV
         AFUYud34G3KJweMgvyr0O/JyaPPj88NbvacIylQpCL+9xQabJiXJdnGrJNhnuWM45jit
         ZRBoMIjkcazMIiWVyj7Yz+ds4QVhW+lks0zBncLN22wy7ewBvynOZupaiYdM4GFaLmX6
         DRViJdptUGsOxK2nDNRwuGd9TV9sUFMHcV0NVIlM6+i8F0NhEZWNSnq4ZO5So0SJPFOx
         K+H0D4XQcfXyPL3yEDuaHz04d6cgidaN2dmS4d1J0pwAoEYqgnIOc+/aEcKuz/BK7KPd
         wrrQ==
X-Gm-Message-State: ACrzQf0v9YB2yVzepwN1ImBffun76jBckKiiwTqgT2avwmLJ+Ydru74h
        /GJhc/huUtbw28lf4Mtlgbqbj2Yeez0eY+vx328=
X-Google-Smtp-Source: AMsMyM5agwHSQGGeKnQUAZeBfcnktdWqqHSJngH0mnsHO+iFjJq6HAbFFsdDvgBg7NqF8piHGgUiTQ==
X-Received: by 2002:a05:6a00:1a0e:b0:547:1cf9:40e8 with SMTP id g14-20020a056a001a0e00b005471cf940e8mr30368105pfv.82.1664934955707;
        Tue, 04 Oct 2022 18:55:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0017ec1b1bf9fsm5383618plb.217.2022.10.04.18.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:55:55 -0700 (PDT)
Message-ID: <633ce42b.170a0220.85e36.94b2@mx.google.com>
Date:   Tue, 04 Oct 2022 18:55:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.71-70-gdc2f8bdb310ce
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 107 runs,
 3 regressions (v5.15.71-70-gdc2f8bdb310ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 107 runs, 3 regressions (v5.15.71-70-gdc2f8b=
db310ce)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
imx7ulp-evk        | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfig =
| 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =

panda              | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.71-70-gdc2f8bdb310ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.71-70-gdc2f8bdb310ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc2f8bdb310cefa547df45ec65272d3d66c64d86 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
imx7ulp-evk        | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/633cb86ee56d6ba0dfcab5f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gdc2f8bdb310ce/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gdc2f8bdb310ce/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633cb86ee56d6ba0dfcab=
5f2
        failing since 9 days (last pass: v5.15.70-117-g5ae36aa8ead6e, first=
 fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/633cb4f49933b38defcab5ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gdc2f8bdb310ce/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gdc2f8bdb310ce/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633cb4f49933b38defcab=
5ee
        new failure (last pass: v5.15.71-6-g484b1d27e3e0d) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
panda              | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/633cdf6763fc781ce3cab5f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gdc2f8bdb310ce/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gdc2f8bdb310ce/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633cdf6763fc781ce3cab=
5f6
        failing since 42 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20

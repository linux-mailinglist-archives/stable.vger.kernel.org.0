Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539AC4EB4C2
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiC2Umk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 16:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiC2Umj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 16:42:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1817A6D3AE
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 13:40:56 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y6so16161821plg.2
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 13:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cb8oTRcBMp1VScd5t2sbkorzLZjR9GLJG4aMz/jCviI=;
        b=add/6kWnXtZ9imesheP3hdcvQu/Mp2mwP9rmS2S3A/JQlUYQC6J0KuHiJ/CgoWLSfq
         0ZEmS0gIRh5BeUNwyYb5TeVkfoXxqMGJzTdiUOHlRMojfvtoIpJM3fsL+dgHlAxoShlm
         esuE41x/Jv1UWrGk+jIikzNPJSCLp0Zido5NAlTsL6eTI7Y2z/taldXNZSw6JMRNum1I
         u2CQ4Rr8AYu1z3HtfWgnwTUzpvqRcTiZbdCb1hQu2hcsR8XW/sPnWKOnCW/zVGEfEP2w
         2AsEbtlL31QRaEuXkKY+N0Y7Q9VkjkddwhVtTQXwSeErhQNtdk5Bb8cOfDGK+23FB27D
         SEEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cb8oTRcBMp1VScd5t2sbkorzLZjR9GLJG4aMz/jCviI=;
        b=w8CGLNJTUGLewLHNH8vpjlPJwvWYsfCsIFqlJOW5rahRgD/3z3ZpbS5yT1ZQ4ZIpL5
         zQBPBWf2e0pQBX4rfJHqQ5rSogTuV6FriMIc5AovnC2yYrrOHudIUy4QBoIsq3X3pLHv
         3SFkzioOgTYiX9VAayG4sALobDh6bzDpcZEPziuiDqvNBMcZ00b8KaBG6HwVbplcfO1i
         Ul1uR2BTDKZ3jo8AKJVi6kFHTZdPs0KIV+B8CfPIU17pGdwNCHyDeeI6UokEwN5hkQaI
         Rak4oBF15SX26t9bQ/hbIugTnXRYOOSbHUnMZxkTLzbq4q0UVQrcL69i+cfBtqoT7vP4
         gwdg==
X-Gm-Message-State: AOAM5310P22zdJLU6v5kkoo9k9g70CpXbk6vo6a4jf+F/PG7mp4xO3ek
        svRoznTSdviasFS1hBMFr+Vhv5nXeiTuuZWWQp8=
X-Google-Smtp-Source: ABdhPJyu5kGIQy7XWz5vFMzRXy0S+SSumF8Pi0O+jB+kb3LCPtZ32n/S78Oc6VYWBopKLHc/9IZ8vg==
X-Received: by 2002:a17:902:e746:b0:154:124e:6415 with SMTP id p6-20020a170902e74600b00154124e6415mr31508166plf.79.1648586455409;
        Tue, 29 Mar 2022 13:40:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x39-20020a056a0018a700b004fa7e6ceafesm21939398pfh.169.2022.03.29.13.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:40:54 -0700 (PDT)
Message-ID: <62436ed6.1c69fb81.bfc38.8c7f@mx.google.com>
Date:   Tue, 29 Mar 2022 13:40:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.274-9-gd506734be583
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 82 runs,
 2 regressions (v4.14.274-9-gd506734be583)
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

stable-rc/queue/4.14 baseline: 82 runs, 2 regressions (v4.14.274-9-gd506734=
be583)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe   | gcc-10   | defconfig =
         | 1          =

meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.274-9-gd506734be583/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.274-9-gd506734be583
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d506734be5830d4fb8ddda7ae523acbb6c75aa99 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe   | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62433ee945ca4e4f20ae0695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-9-gd506734be583/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-9-gd506734be583/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62433ee945ca4e4f20ae0=
696
        new failure (last pass: v4.14.273-4-g30b6431344d2) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62433d4de996d55c60ae077a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-9-gd506734be583/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-9-gd506734be583/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62433d4de996d55c60ae0=
77b
        failing since 44 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20

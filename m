Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78BC595EE0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 17:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbiHPPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 11:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiHPPUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 11:20:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E32365270
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:20:11 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d10so9500294plr.6
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=PlaallCB10Ry4WxY1rcQ8WPPtWKABJXP4hEONEqzlkY=;
        b=kGjgWyH3NRUCNbhM5M7cGgeH5GADzyeb9xoMp55Mf8B5hgdqubFpOrGa/7jVkVqOOQ
         DWZPti+Jkq0w4ZslAkQ3dIjeGp3x3J6SOsft7gkfS8HrwNJDEb8j9coa4oH4m9wufthh
         LsoghGU9p9c//q6+BpPg+usDwuwZtQrWF2P4tp7KgNtIhInLoYowc9nkJ9xsIDLgJ+hJ
         lMM/pXuGQB7DGdVdD8mVkYi9Czck+xwjt6Hwz9+s5nRMQDmOjVVtDiOIF2WGn4wDH+UZ
         NkG8UL1325RGqE5Z9wfbNB1z37XTzkSYPXy1lpQ0BSwVFt28nQqWI0IHsNSyKZiWuGhF
         HIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=PlaallCB10Ry4WxY1rcQ8WPPtWKABJXP4hEONEqzlkY=;
        b=47hMndkhUfqvRMsrl/ABYyqOc3ohFqy3Xz+hmKb/QEBtV2Enl7oCn2fGkXM/WytwfW
         IDY0b3Nc2FphghBpJ9S42QIvP3LLQTWFlFXzmoSkrJRh95qjMqQrOCDOUCbyIMwqQ+sk
         DLW6G39Og+otYf3fsyYbcQMs8d9cWD56jRiF/9avBiy3Lcuq49p0umrOXDytkKicG/Bl
         grUND98Yye8yT/zPAENKhrvsvLa08mYSuXZ9+91ry9VW6jTKvVgTXspFRfYmn9ByCscD
         /oO+n1lSv2nAQ/7fjVgACvcnHm6kSHQ5c+kXLBK3Bmd/pOkWIlbJY3/Nh1dr3kQrGPU2
         Rj2g==
X-Gm-Message-State: ACgBeo2LlmwAWzfosEY9+kHC7o1cII7hflHUs2yitfDZgTr/vL0akYfB
        CK0dbDmz0RPCkOZw5InDsE/dK2jExt4vvWsN
X-Google-Smtp-Source: AA6agR7C5p8V0g7Rvth4nMLOzne7Nf5Jx6XZ4/FVY0vP6V/GR3tYRR75NCPzo3S7XvR1hrNqY4MGGw==
X-Received: by 2002:a17:90b:1804:b0:1f5:946:6b6f with SMTP id lw4-20020a17090b180400b001f509466b6fmr24527022pjb.160.1660663210593;
        Tue, 16 Aug 2022 08:20:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a34c900b001f2e50bd789sm6466523pjf.31.2022.08.16.08.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:20:10 -0700 (PDT)
Message-ID: <62fbb5aa.170a0220.1d74f.a29e@mx.google.com>
Date:   Tue, 16 Aug 2022 08:20:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-1156-g4a31fcf38f446
Subject: stable-rc/queue/5.19 baseline: 113 runs,
 1 regressions (v5.19.1-1156-g4a31fcf38f446)
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

stable-rc/queue/5.19 baseline: 113 runs, 1 regressions (v5.19.1-1156-g4a31f=
cf38f446)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-1156-g4a31fcf38f446/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-1156-g4a31fcf38f446
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a31fcf38f4468c86c0a1eccd1d763ecf116bd42 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb82fcf25b3ca5ac355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
156-g4a31fcf38f446/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
156-g4a31fcf38f446/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb82fcf25b3ca5ac355=
661
        failing since 0 day (last pass: v5.19.1-45-gee0f76071c2b9, first fa=
il: v5.19.1-1157-g133ae52c0a31a) =

 =20

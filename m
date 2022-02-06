Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF114AB1D4
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 20:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241858AbiBFTur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 14:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiBFTuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 14:50:46 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB499C043187
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 11:50:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso1095087pjg.0
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 11:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=or6nlj0t6pgXBaCyHdFXwZ6f66QHHFAzh4joRM4mYQ8=;
        b=3xKY1SP5UNz7t38ut8w9e9XSsvdyl+DFRrbUDKPPddNfKcGPLtBURGv5DdWBXaIVlP
         kfKvLVitzsa3/U+CQ6PS6Vme99bSP6/GJ5BK3sqnfOBVBt+NhpUWz77A9kPwvHKfsaAx
         fvExBSAOAjGsel5r45ueKtKBAhiJFcpd+Q04jMScw4GBIE9/hWDco/olfSNmPSXkTNOE
         fJi2+7KuZjgJGq3EMh8/1EPVuXT0FLQPEVzEeSRdT53ERyXJt9X4z3Ss/2B98hBF+3i+
         2Orj7AVP+zPTDzdlZIBw/jsFVQjS3g7q5CIGe638W2cVQukaFL3PCAukO51qLu+YWJkq
         8HSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=or6nlj0t6pgXBaCyHdFXwZ6f66QHHFAzh4joRM4mYQ8=;
        b=uRgerImctYgUr3Tjy+I94XWJ4tKHf2d8GRi7nwShAiPUtoRm+/VfI95n8eOa3rbQKI
         q9klUQjPvzrXp/p0aZY3ThaOnBo71ffBMVpKy8upqIPEfRz3ezVqTKDuKTtDmsn36gBh
         qvYK+xr7HWs8YLBmPkOzd6Bqz7pCn/srDPJhjlkys0K6oQYkRQugz8hTxvN51882Fvvk
         gi6eqYytp7l1QUcGIPXrAlxn5IYcDkVsCuYUgK4sozYl3Odn2yTKlRE74FqD7mH6i92y
         b8WhHC+cKMPvaUXUjBppVOkqhLSr5I/vYo0qkWrbnFmhwz9h+1rDB/hytQ1d9Pk9PNpG
         JUBQ==
X-Gm-Message-State: AOAM531SwRDXX2TpxTfwpZX1kvEa45tYqnFEJMvCjhRZFqRwT5M3A0a4
        vxlF5PdmxLik8sxo1LkhSQotHyRDafkBR/mv
X-Google-Smtp-Source: ABdhPJyeWziIXRqEtTfvThU/uyuD2mAke9Ki+igGewUqx7CgfJDGlm9rP3tn1XPNmVU3oPAS3FxkWQ==
X-Received: by 2002:a17:90b:3e8e:: with SMTP id rj14mr10459565pjb.35.1644177045166;
        Sun, 06 Feb 2022 11:50:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co21sm8118329pjb.13.2022.02.06.11.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 11:50:44 -0800 (PST)
Message-ID: <62002694.1c69fb81.f5c4d.4f00@mx.google.com>
Date:   Sun, 06 Feb 2022 11:50:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-45-gf8835b05f3e7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 1 regressions (v4.9.299-45-gf8835b05f3e7)
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

stable-rc/queue/4.9 baseline: 87 runs, 1 regressions (v4.9.299-45-gf8835b05=
f3e7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-45-gf8835b05f3e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-45-gf8835b05f3e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8835b05f3e7d82e5f22eec69d7e1c7c16b2e6f2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ffed59904446c6f35d6ef3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
5-gf8835b05f3e7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
5-gf8835b05f3e7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ffed59904446c=
6f35d6ef9
        failing since 4 days (last pass: v4.9.299-13-g3de150ae8483, first f=
ail: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-06T15:46:07.533579  [   20.547607] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-06T15:46:07.575329  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2022-02-06T15:46:07.584634  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

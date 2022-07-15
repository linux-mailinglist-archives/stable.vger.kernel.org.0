Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D65763D5
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiGOOs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiGOOs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:48:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F177E1E3CF
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:48:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z1so3406734plb.1
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2MAaUEWJszwq73T7hDLZjxv9FsxWivc4JzcM7xNNp2k=;
        b=s3IyakoYlINXioLBEex/qzMFUlS93hbWnMJc7vHgebfL5BwmJLVFdgWBTmfQ/8eSjY
         8UaI9/ASW/bKLPRS2DNcW5VPBQk/otA/SV1815er8x+mcvtqa8xdhKuCkNEm24d3HioA
         5V5cj01KtTas/Tn+2SKz+QnVz+5n9qbuuidyAKFfNzG+7G9Gw6daaZMCAlFAPeYBTPpq
         pu0lFWITzCv+HFxjhjDFRAX0d+FZBdN8nfaMOSF2L/G9MXxiSvE6xC6Iql+EneG8Sl9H
         DKKPbPC+EaPuPsf6m22RLXV9kr1zkV3zBLFsAu3Im2d8gDZs2zkjS/634D5s4Fro/XnO
         ldoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2MAaUEWJszwq73T7hDLZjxv9FsxWivc4JzcM7xNNp2k=;
        b=rXhowqPpzHm6SHgv6SuDbtO88Tr76WrDILaLOOcL380v5CYZAQANoNoczEaaP5/3UI
         5z4NwION+st9qDgP0AFGl15mZCqnqhAU8oBQayBGCxW4axk1VtlAvAugUEecuA6BCvL9
         S7OMWTK+zqBUC0Fg1OcHhgIks0mkj9O6zEPnHcAadle/gREjhPNGMG6hJ75eORh1lbx5
         o3JcpBkFzMB8/zBxkuTk2eB6UE2qc/4ZN5izOwMbTpQub9krCOmBUkBrZS5nD6APk4eu
         Ge3TR5Ad1REKnIVQCTOuN+1cjqAiyHKATJMyszjtFSH51Ay9z9zGMQ8aXvu3RZyZaKb3
         HXmA==
X-Gm-Message-State: AJIora/ilvQ4zJy6806HP64HPMkUD0kL3Af6hQZUrZJ/Ce5Dx2jHir/Z
        cdKo9eFDJ+R+PpSb90R2+R0fYkicu3/w+lEA
X-Google-Smtp-Source: AGRyM1tfrzCv9f9xTcwxdfD+uD1WK0X9x86qRZtG7rjaY2x8XUW04CDQL8ZiwQcEiSoE23olmOvLDQ==
X-Received: by 2002:a17:90b:2242:b0:1f0:6d85:e196 with SMTP id hk2-20020a17090b224200b001f06d85e196mr16485464pjb.3.1657896536259;
        Fri, 15 Jul 2022 07:48:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2-20020aa78bc2000000b0052ac1af926fsm3939399pfd.20.2022.07.15.07.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 07:48:56 -0700 (PDT)
Message-ID: <62d17e58.1c69fb81.3bb8c.6149@mx.google.com>
Date:   Fri, 15 Jul 2022 07:48:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.55
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 143 runs, 3 regressions (v5.15.55)
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

stable/linux-5.15.y baseline: 143 runs, 3 regressions (v5.15.55)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
jetson-tk1      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =

jetson-tk1      | arm   | lab-baylibre | gcc-10   | tegra_defconfig    | 1 =
         =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.55/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      baefa2315cb1371486f6661a628e96fa3336f573 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
jetson-tk1      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62d14a980f5ffd9bcaa39bf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.55/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.55/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d14a980f5ffd9bcaa39=
bf9
        failing since 50 days (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
jetson-tk1      | arm   | lab-baylibre | gcc-10   | tegra_defconfig    | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62d14c4fe862ccf492a39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.55/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.55/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d14c4fe862ccf492a39=
bfb
        failing since 50 days (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62d14b0246f33bb84fa39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.55/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.55/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d14b0246f33bb84fa39=
bfb
        new failure (last pass: v5.15.54) =

 =20

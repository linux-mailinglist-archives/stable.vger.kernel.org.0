Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987655F5761
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiJEPY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 11:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiJEPYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 11:24:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E6E3FD51
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 08:24:24 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f23so15681447plr.6
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 08:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=L2Qa2hnVXTtPnSOC3c3LanPcqkuQk70KLfZUaCxquxE=;
        b=2oerN9mnSMcW4T6HoOrKcSiWDYLPA7HwhVrcfq6ShXqd03WadzdBqHVCCIcnM6HLmW
         bnyV/E0tN/dDJVFES77laHvhhOohHB3AL2XaNrYFMTg0I6cteFheGbmzuWbjpfLNvEzd
         Rljlm3gVquLrDfIZ7W9VSLnUCxdXJmZ1Fe/pup9QeoVKcaTacqxPEtJ/qZbbBiX1ffl9
         9zvfaCUuaEka5e/rYvUDPLR77rx6wVBCl/Qhv3jJaqcizgK+gxbxvN6RgS475phJLdv6
         2GSH3JxsvR7Qp3R/kOpvu+M+cKw9U7pbYP2J3efd3qRuvpzsBpngkBsQv1AnXR0a+iB/
         o7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=L2Qa2hnVXTtPnSOC3c3LanPcqkuQk70KLfZUaCxquxE=;
        b=IkIUE+Vnm+R8fa5gEr3CREmnNYtfHhRLGQJVfR8vJqM3ZTethif0lDPyithOtS3npH
         2OMneBvJ8FStXRVMFMfhG7TWbAVrjxW3wH+o9VVxQPuP/kGBF1otDb2bEmpaGo+ZSvIj
         ZW5c1Q35vIkicmTSFsP4wubbKXNOe8zRkwe98h15wCyDltKkzi/jhv3t3feWfTNA5evq
         +fvjM9zSegFTBvUB3Uc2EYbdjRtaoN08ydHN7/oNgur1V7FPzrskD+8NWfk3Ijy+Z1cd
         YeWZT3RsTTs1enOYWRag6fesGZNJNSo1WiW1ll3QWpvDOsGcAmdrHONvV1tNhk7t7EQx
         r7QA==
X-Gm-Message-State: ACrzQf3pDhRQTzkgVoK3Oe9ccI2+IKmQR7TfCptuR2Z61Y1UdkimwoSO
        IclSzEBWjKuXyV9aH21ULQIFcvCYvL+6kBIuU/c=
X-Google-Smtp-Source: AMsMyM7rz4Z6db93xlp+v0TwbIOb/BL0LK4RfbQQGK2RTjbNEz3z3Gq6cZHv45WP3wzEZhyzWHe0cQ==
X-Received: by 2002:a17:902:ea85:b0:17f:88c1:7015 with SMTP id x5-20020a170902ea8500b0017f88c17015mr63607plb.49.1664983464353;
        Wed, 05 Oct 2022 08:24:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902ecc300b00176a5767fb0sm10728956plh.94.2022.10.05.08.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 08:24:24 -0700 (PDT)
Message-ID: <633da1a8.170a0220.69e28.2d7d@mx.google.com>
Date:   Wed, 05 Oct 2022 08:24:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.72
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 80 runs, 4 regressions (v5.15.72)
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

stable/linux-5.15.y baseline: 80 runs, 4 regressions (v5.15.72)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.72/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c68173b2012b8eba332cf9832f0ad23427d795b5 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633d6dc65335c2b4e2cab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6dc65335c2b4e2cab=
5f0
        failing since 7 days (last pass: v5.15.67, first fail: v5.15.71) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633d6f2d67153d9098cab60b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6f2d67153d9098cab=
60c
        new failure (last pass: v5.15.70) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633d74dfe8e1c50955cab6fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d74dfe8e1c50955cab=
6ff
        failing since 48 days (last pass: v5.15.59, first fail: v5.15.61) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633d72d6b8c287aea8cab638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.72/a=
rm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d72d6b8c287aea8cab=
639
        failing since 34 days (last pass: v5.15.62, first fail: v5.15.64) =

 =20

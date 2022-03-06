Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309944CEE12
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 23:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiCFWCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 17:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiCFWCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 17:02:04 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F501C125
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 14:01:11 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id t5so12162909pfg.4
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 14:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K77S31xEmweAGN75CGim7rLFwgLq5MS2AnUu1mlxmSw=;
        b=kt3m9IN4vNMlrBU3iiVFPjt0gd0a10R7taQTOFZcdDBSlv2rsKHUxpi6dMlOuqEW6b
         9J9jSJOASMIQpvMkGbUJWjwBZgRUeqyJj9sZwpS/2QCoU673OP7g7ykh4M7TY4LTvMZd
         HbAGqSqiXJ/3um1OsiNwKO91W6GyF+LiEYyLYo9w9arFTwN93MTJtJfyeZP7oHnFilMh
         61Ql0NADitnlnnrBdWHGc3/l8r2sNM6TGtKNkY//zXYx7+rDPBhbEqkAKRsx3RfJbrLr
         7AgbtILP/6mHRigxsj2zvUFbtp/pYRlAgsCDIhuhFA1C1Gl+6KzhJPS02qQ9n3w4bCeD
         XHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K77S31xEmweAGN75CGim7rLFwgLq5MS2AnUu1mlxmSw=;
        b=bY0VVtxQT8FQPgxEmjT7lag4pIpYwjR2EtwdCicGLAp5JLe0U1wQOFaVBgtZweugls
         1FILxqC1/dtWZ7rQ1XKFE0Doe/liHD6PbbQypNn+id+VkzRpHuHa65Yceuym4wSYCDoP
         BEyN93u9HmwAw2Y7ZQQ2bR2VEgUpcmABx62znMSLJrhcIXfRH4yxcAnnNxIfmz0nl6Sc
         YgUyr4QW0sSUDC53a+EpIkanbjFTUvwi3G3Vs2b2tagvPf56aD1q37ZGIhr0+1yuxRGb
         qOv7nO+OEvF2Ua0Ls0UHdlwSSAIWCK9oEnDE5x+9qlljKjPqQwrYBRVRRjj2hSDjW5fu
         vcFA==
X-Gm-Message-State: AOAM530yGxW7b5eX2JI4AM+1RJy1t5dSJMYFVLT2/rFKr50J0HUE1iR0
        dDS0cy2ftCXpva8hC/G+eVXrykMZ36e5ymALwq4=
X-Google-Smtp-Source: ABdhPJzYlvGDIVX+LUxIqsFQf6xmXRtuZ/nflKz80GJ6sT/potGV/F8+Wp738aWBhdK1dS0sgNBSeg==
X-Received: by 2002:a63:5a4a:0:b0:380:260d:47b0 with SMTP id k10-20020a635a4a000000b00380260d47b0mr3772029pgm.45.1646604070995;
        Sun, 06 Mar 2022 14:01:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79a45000000b004c9d286809csm14256687pfj.61.2022.03.06.14.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 14:01:10 -0800 (PST)
Message-ID: <62252f26.1c69fb81.1b07a.478b@mx.google.com>
Date:   Sun, 06 Mar 2022 14:01:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-57-g85357dafc890
Subject: stable-rc/queue/5.4 baseline: 97 runs,
 3 regressions (v5.4.182-57-g85357dafc890)
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

stable-rc/queue/5.4 baseline: 97 runs, 3 regressions (v5.4.182-57-g85357daf=
c890)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxm-q200           | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-57-g85357dafc890/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-57-g85357dafc890
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85357dafc89074ab12f8e9bda4860aaa4a8a8f3c =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxm-q200           | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6224fdf1b20b2b2ef3c6296e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
7-g85357dafc890/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
7-g85357dafc890/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6224fdf1b20b2b2ef3c62=
96f
        failing since 0 day (last pass: v5.4.182-53-ge31c0b084082, first fa=
il: v5.4.182-53-gb54ccf4e0b7c) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6224f59147ad83fadfc629a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
7-g85357dafc890/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
7-g85357dafc890/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6224f59247ad83fadfc62=
9a3
        failing since 80 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6224f57c47ad83fadfc62995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
7-g85357dafc890/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
7-g85357dafc890/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6224f57c47ad83fadfc62=
996
        failing since 80 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20

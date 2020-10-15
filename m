Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D1B28EC9A
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 07:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgJOFXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 01:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgJOFXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 01:23:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0143C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 22:23:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a17so1126108pju.1
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 22:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r0N4UiVkJfkQ9MqF8r7/hj4m+wIL0JNkCWDmlfBFvmQ=;
        b=UJMWIRZsoUxzCjaOS/UNK62cGbqq0IPr9rsNns05lmz9GTCP67PkHYDxgazxQpsjI2
         vfv2t80FxA+99R4LkbxDDrpB2B1tDs6sLQH5XqWFFvu9n2isDPlwJHTLOzXsd6Vi6cLB
         v+Ou2LVFkAhtrhc4NYpmIMTpXLD66lNkJlOZAplAD0KEO+zDFTw2HrkMaC3g2R6GXUMS
         6Av2i0NDGKztsWpYz+lRbuYr1IZwEP3VRCvbdw4M6og2WSZAsk3YSEJiCcxrWfP46p3P
         hnF53sl1J576aY1v+tdoCM9MobPqPWvLbD39n7T0KKFbmxTUwtaJFzJ4k/2fQV82gTmV
         AQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r0N4UiVkJfkQ9MqF8r7/hj4m+wIL0JNkCWDmlfBFvmQ=;
        b=gf2zCAfTMLEKqfuqhmndkc/Kyf3U1WD3YEahcWPYp9MEMj/Q7l2weY8+Nx9YLRGugA
         cp6TF7F96bwTX45y2wdDoABtvKtC1escluvHR6k9ROAIKmOKK1j4GwSpd8+aJlkKeKoD
         eG1PvNAM3RD6rNc15SImh86CR9c7MbCpXz5xxZlDyHs2lfHvH8nMEVNbPIJk5AW7thgL
         d2rqgcvcm5dc0HO7/J6pxVpUh+AaQWz6Fdt1308KYXad3QRA26RQ/YPihW5bRF82CMxl
         kOrkBikxCVlP7O/yF4Abr+44R1Yww3LTod+tXamcsNiJjTaULq+gJ1ECebziD3GVEZzf
         DgIA==
X-Gm-Message-State: AOAM531pjyIF69S/QeXKIcjGNv0x+hAoKnTx0V9iKYU/tYKY4qIsaFiM
        5Ji+sKcs/CnZzLGacpWK3XkoD3LiWQxzzg==
X-Google-Smtp-Source: ABdhPJzmhwiSKMqEj9MSrNWdMmPjN0dyD9HBnJIn9v7/61lnHnC4UCp9owjoLUD32oTDQ7FM/CyuXw==
X-Received: by 2002:a17:90a:ad98:: with SMTP id s24mr2608550pjq.199.1602739382790;
        Wed, 14 Oct 2020 22:23:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2sm1503313pgg.3.2020.10.14.22.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 22:23:02 -0700 (PDT)
Message-ID: <5f87dcb6.1c69fb81.cbfa9.3f39@mx.google.com>
Date:   Wed, 14 Oct 2020 22:23:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.151
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 179 runs, 2 regressions (v4.19.151)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 179 runs, 2 regressions (v4.19.151)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.151/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.151
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      47f6500403ea31aa0c8e329aeee607671d0f9086 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =


  Details:     https://kernelci.org/test/plan/id/5f87a0277cd97974e14ff404

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.151/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.151/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f87a0277cd97974=
e14ff408
      new failure (last pass: v4.19.150)
      1 lines

    2020-10-15 01:02:48.331000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-15 01:02:48.331000  (user:khilman) is already connected
    2020-10-15 01:03:03.825000  =00
    2020-10-15 01:03:03.825000  =

    2020-10-15 01:03:03.825000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-15 01:03:03.826000  =

    2020-10-15 01:03:03.826000  DRAM:  948 MiB
    2020-10-15 01:03:03.841000  RPI 3 Model B (0xa02082)
    2020-10-15 01:03:03.927000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-15 01:03:03.960000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:     https://kernelci.org/test/plan/id/5f87a4e4368385a4304ff3f3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.151/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.151/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f87a4e5368385a=
4304ff3fa
      new failure (last pass: v4.19.150)
      2 lines  =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A5286E4A
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 07:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgJHFsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 01:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgJHFsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 01:48:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003C1C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 22:48:19 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id o25so3343196pgm.0
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 22:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LQ/E36EziK2bl2/9MxJBDyQ2zIBqvX+rqmZRnXvE6n0=;
        b=Jx1W96gCb2KMtJndsahH5f/XKje2f3qZ6CWeLqrmBajExkguIXa3lMM0ZjKi84/WIT
         Cnmy5Ih0brSEJrAWJlANJOLVmH5F2Ik4QTr949XBfsz/LBR0xFUp1aIFUhWWBNLP5f2+
         goI/cwQwRLxk2nVcekE3T1Bg3D3ZdCp+M6HnwDXvO+J7D/z++Q+2j5XDTjVpUDgCilsq
         4OsM2laMLh3zXUvXA+UNNHCVZ8lGu8gGJMwD1ukmPyX8AT3FZoDowBFgJY5lHtTPsJad
         YrrryiVMJMfjLfKHzjAQzfJwTmbhJzD4CiXd88cCBuqdUWWFeyn55O67YzcMeXUsySok
         VZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LQ/E36EziK2bl2/9MxJBDyQ2zIBqvX+rqmZRnXvE6n0=;
        b=snLl8PyZjNrYgYUaTVa+lrlDUTadUYkkf+ZPwonYEr/erF9gxURtB0Qq8KwjQLrKNE
         nnmrHAxI8EFM6//LKlfasTGEsCqGwMHNfZUohnMBfp6q+g7YKjgAauHyYQzkaGIZRpV8
         nLQ5aZXzzf36nTfxwa8VvUdtnLs6fdY70kq2HOZKTDadH1HvAdLcuCKtqucgVC6X+/8K
         NbY46EPlc1BqaAh7xNv9DOyTKf7VEtqOlEs1ulvR8P+T5GncXfyC2H84NF9Ob9pg4Kx/
         puqOjpy4jLlaOKmdoDaxAkCPun/tSK0oVrjfBM+7cXQp7gU3929KZ+IWXU3HYwT3WztT
         zSbA==
X-Gm-Message-State: AOAM5326Oh9YZkO9GhXgZEihkssCjLp/v73ENcmTvOazhhxx0AkbDe0r
        I4fgZyeOmma4V/HkxBYnrlwAPHTd4YD2Qw==
X-Google-Smtp-Source: ABdhPJyARiqpSynmQLszOo+U68CgMORZ4l0uMhpLbUAc+f17BR9zCxVhiq3exlkBVJHRha3cah8PTA==
X-Received: by 2002:a62:1951:0:b029:152:6669:ac74 with SMTP id 78-20020a6219510000b02901526669ac74mr6037381pfz.36.1602136099014;
        Wed, 07 Oct 2020 22:48:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o15sm6110878pfd.16.2020.10.07.22.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 22:48:18 -0700 (PDT)
Message-ID: <5f7ea822.1c69fb81.dba93.bca3@mx.google.com>
Date:   Wed, 07 Oct 2020 22:48:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-5-g11bdb6b2eb73
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 108 runs,
 2 regressions (v4.19.150-5-g11bdb6b2eb73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 108 runs, 2 regressions (v4.19.150-5-g11bd=
b6b2eb73)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.150-5-g11bdb6b2eb73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.150-5-g11bdb6b2eb73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11bdb6b2eb736558e5a82e1fc665bf434e2304ae =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7e47b9ac7afa9d704ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-5-g11bdb6b2eb73/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-5-g11bdb6b2eb73/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7e47b9ac7afa9d=
704ff3e4
      failing since 5 days (last pass: v4.19.148-245-g78ef55ba27c3, first f=
ail: v4.19.149)
      1 lines

    2020-10-07 22:54:54.187000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 22:54:54.187000  (user:khilman) is already connected
    2020-10-07 22:55:10.029000  =00
    2020-10-07 22:55:10.029000  =

    2020-10-07 22:55:10.045000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 22:55:10.046000  =

    2020-10-07 22:55:10.046000  DRAM:  948 MiB
    2020-10-07 22:55:10.061000  RPI 3 Model B (0xa02082)
    2020-10-07 22:55:10.151000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 22:55:10.183000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (371 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:     https://kernelci.org/test/plan/id/5f7e675f0a311d08264ff3f3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-5-g11bdb6b2eb73/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-5-g11bdb6b2eb73/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7e675f0a311d0=
8264ff3fa
      failing since 6 days (last pass: v4.19.148-245-g78ef55ba27c3, first f=
ail: v4.19.149)
      2 lines  =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADBD4C8263
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 05:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiCAEiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 23:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiCAEiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 23:38:19 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A92D3584F
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 20:37:39 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 12so13456770pgd.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 20:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=258RIoHYlnomey8yUXuD/r6V6E/uZXB4Rk9CjTAUcf0=;
        b=VaAEgDVfoB9zH2UQ8Mu+kJGvqrPvwjhOFsQB2ghw0BORIrtckRctqmgGUNjY7WvpDK
         Npf4HfmmHIrtg5qHebLydjU6soON0+7Nwfu6m6JhOsu9IAbWllaZQl6u4QqRh/B0NhcT
         sKl/lJKogAKj26msf+7ftytQCFjP3tb2wy83hhEWvh4XDnd825AaWIupoHMx/yRvcZ7G
         7u37ncw349Hsm0YYknGgMU8QVOi+KOjqR0SR4lq+rB2VbSCN1gk6n23wq0lEHiPOvbIk
         pWNl5UtQblhliRPraqm5shDbVg2WP3QwjyO8wb2OgGLZdlbQ2XINIQcG4jRqDWu6acDR
         iEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=258RIoHYlnomey8yUXuD/r6V6E/uZXB4Rk9CjTAUcf0=;
        b=qrumZ99zz8ousSvTu7cJbVAuarqjUdgJIyIOyGWrwVOdP8O/oRPBdRyiGug8EPGnJZ
         II+5U32WMIid6IW/kNrQNt8BxEFtkgHigGKbKulh38Bi5LhloxISgkajuAY4f3AUwDmV
         9EsxyIa599AF+YcdrKXKjjXaIJtgRoS6sOy8J6w/uzl6i0vT0OQxIP2qMdoHHWQfYKnJ
         UAcCbmejH6XqzVnwoSO8sbHQGhYPR1XUGyAJkdZRlc1YQruNy/MOaHGFPWFkETckt1Fh
         OcGygq05dTGM/wqmPHx9ph/LvrgSRW40q1EH5VvPcw6LrgUQP9txpPPFgJB3fuLd3m2Q
         1ScQ==
X-Gm-Message-State: AOAM533T6WuPcgjTmJGClvkbFadbLwQeZlifJcHwp5Q3tsZF8niI96uA
        8jkVbhYvDnU/zx8YtvfNmkVQERT3kgKyg4S03zE=
X-Google-Smtp-Source: ABdhPJyUgw07SHwQKWlCAYzMBkgBm1nKxCf/3ezPljlPDACcIrNO0GxkeNzh/hR42RJpyYk2ohpVaQ==
X-Received: by 2002:a63:701:0:b0:374:3afb:e5d4 with SMTP id 1-20020a630701000000b003743afbe5d4mr20498869pgh.600.1646109458797;
        Mon, 28 Feb 2022 20:37:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a056a000cc900b004f3581ae086sm16297789pfv.16.2022.02.28.20.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 20:37:38 -0800 (PST)
Message-ID: <621da312.1c69fb81.9a1b3.a6a3@mx.google.com>
Date:   Mon, 28 Feb 2022 20:37:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.181-54-gaa9d24e3c108
Subject: stable-rc/linux-5.4.y baseline: 89 runs,
 2 regressions (v5.4.181-54-gaa9d24e3c108)
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

stable-rc/linux-5.4.y baseline: 89 runs, 2 regressions (v5.4.181-54-gaa9d24=
e3c108)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.181-54-gaa9d24e3c108/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.181-54-gaa9d24e3c108
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa9d24e3c1088399a4cd2b031c4c6abee5d58a60 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621d6a708dde8fde8dc62971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-54-gaa9d24e3c108/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-54-gaa9d24e3c108/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d6a708dde8fde8dc62=
972
        failing since 75 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621d6a498dde8fde8dc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-54-gaa9d24e3c108/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-54-gaa9d24e3c108/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d6a498dde8fde8dc62=
969
        failing since 75 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20

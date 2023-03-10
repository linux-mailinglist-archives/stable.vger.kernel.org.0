Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3175C6B52A9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCJVTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 16:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCJVTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 16:19:19 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE2011E6FB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:19:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso11194916pjb.2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678483157;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/DAPwytqt0UoxSv0LPjve8O+ldRD/wOKtTEA8wwfoto=;
        b=UBjew8vk+sLs8v++XGBar07OBfLwdjEoAWPA3i0HiCPTDafvFLqtaz/0fJOxr2LSrG
         WeXWBZZuLYuDgy9/Zbj1/ICIvyW16ZZ+KgMxbv9jmM3P0yG1AcLBPXRjdYZztORbkZo1
         8FYt3OReI4Y+0kowTOiOA/218cP0r0/DMjU/tosX75FU57q8yxX+v5CYKBPGJgN26+vs
         jg0YwrePFs2mhWWi/az9qxDKCWhBPEdeEzWxOohREKZ7gs213f9KrqN7UM+qE2PGeJKK
         PQSSr8fowxIHzNLQXFR16WgOCUGc+o3Mxe8kFsTb16H8W9eE1zGQ/qNZmP6ATVU/dcEB
         z0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678483157;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DAPwytqt0UoxSv0LPjve8O+ldRD/wOKtTEA8wwfoto=;
        b=XYhQSz2n5mzU98CyZj3jwySn9PLi7zQrw/xFnBNdF9lFCmHuNPIibGWlvfz8yiTBTg
         a6hLWhFNzZ876F3x8WQriphaOHXrMPPi11Mrs1nXY7h9zbJ13JjOd4knFJMmWUQl1KgE
         HoQ4qBIcIeszEqnsYkKh2bFskVrtzJtLhFlmw8vVFZLpwz/AgjsghzW2TPZYZVZbfuPw
         /iRihQY2X9h4RuT55Dg4s7G4quvZc+qMCdB3djP0WyWDjbTotIvnsE6gNL2fzJYg9Z0I
         7WqpFjKJExybc8u8WG2ASlUXpf5gxcbezjr+jo4i0DowuQbyWHd51IdJhScTUDenbQmU
         BfOA==
X-Gm-Message-State: AO0yUKVSOJihvz5LKULcsZk241pWmAxj17weBtJTtqDUeyKCbt4ZxwRw
        Mf1M3QNDhaTzfTP4gfct9brbqqP/CAkVW7WXpwQWLON7
X-Google-Smtp-Source: AK7set/VMg7mqMwL4xm4vZCRegjZrKNY1Yfp3BJCg+/UGb/g9MPSTkKjuBPXfME7dqZelxnQYKVJ1w==
X-Received: by 2002:a17:902:e5c9:b0:19b:c498:fd01 with SMTP id u9-20020a170902e5c900b0019bc498fd01mr3520470plf.11.1678483156853;
        Fri, 10 Mar 2023 13:19:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4-20020a170903230400b00198d7b52eefsm380783plh.257.2023.03.10.13.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:19:16 -0800 (PST)
Message-ID: <640b9ed4.170a0220.4bd62.1577@mx.google.com>
Date:   Fri, 10 Mar 2023 13:19:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.16-201-gf345f456043c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 177 runs,
 1 regressions (v6.1.16-201-gf345f456043c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 177 runs, 1 regressions (v6.1.16-201-gf345f=
456043c)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.16-201-gf345f456043c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.16-201-gf345f456043c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f345f456043c26b6a0d011d779ae746c16a9f8f1 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/640b66b05e75b81ae78c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.16-=
201-gf345f456043c/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.16-=
201-gf345f456043c/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b66b05e75b81ae78c866e
        failing since 2 days (last pass: v6.1.15, first fail: v6.1.15-886-g=
7ff82f8ebd2b)

    2023-03-10T17:19:31.105154  + set +x
    2023-03-10T17:19:31.108918  <8>[   16.385800] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 137716_1.5.2.4.1>
    2023-03-10T17:19:31.222561  / # #
    2023-03-10T17:19:31.324933  export SHELL=3D/bin/sh
    2023-03-10T17:19:31.325558  #
    2023-03-10T17:19:31.427194  / # export SHELL=3D/bin/sh. /lava-137716/en=
vironment
    2023-03-10T17:19:31.427708  =

    2023-03-10T17:19:31.529332  / # . /lava-137716/environment/lava-137716/=
bin/lava-test-runner /lava-137716/1
    2023-03-10T17:19:31.530434  =

    2023-03-10T17:19:31.536768  / # /lava-137716/bin/lava-test-runner /lava=
-137716/1 =

    ... (14 line(s) more)  =

 =20

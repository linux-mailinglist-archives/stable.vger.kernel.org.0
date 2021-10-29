Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FFC4404ED
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 23:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhJ2VcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 17:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhJ2VcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 17:32:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F89C061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 14:29:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id r5so7659808pls.1
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 14:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ccRTQxVwneap86hN86G5bbfL1EdvjBIrYoBXeUVXPmM=;
        b=H53UvY7myYalEQkONOd6CR456DaHtlg3/csEGLkD53XdamRGkRRymVdfYb9Xyp0KoR
         gbHLKUr1ordh9gDh9ZH7/IOhalHZMRllN5z+z2oUSKTuXzNjqgtrGaCVjhweAMUB/V08
         D81FTuMIV/vQ9WV1dZXIkTw6Gfjz1RNwfu8RL248VeD4TenKRXYjGuK9rQyBhHYalTxJ
         rDsp2KOJcRfNcrKRqN4nSX3v+Xnk29l8+KsyQLCJCXMw/WDP8jWCGmP3yPldc4Yi7bOE
         y1Fbac7GUfclTdD1eiAoJOxWW5RuHtfskz/xccXDb80nUomzwzdRGn+TdgGeLT2L4Q58
         IxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ccRTQxVwneap86hN86G5bbfL1EdvjBIrYoBXeUVXPmM=;
        b=05uTiWnWggx2JWwuOT7HjZUE5hu1ox0VfBlAulufwpExXKbkYAc83BSosAKTL6jR4C
         Y8W3MBDcaZRDtpfRDq+Ep5rIHw4aeHAINlIHQivTEA1z9j/PQDbY1MH3waMA161l1XQG
         3rkIgJK9KKjKF0JzlawJLTQlpa4vQiUXHi7Zso9XVuLqsLMrTH0/bHCD9rv464dnTdkZ
         4bB43xqg2k6NcmRnsEhsBXhuyw4NEx0bCWrpaBKHM60X09JaUtQv/VDwgGFSDsc3vaXQ
         XbwKg1r9Nwb7IwunY3UIXTANMxkipxoAa4jiw8a3SYzjdHlJoFDa3y5qTqVxQ4QUMiS8
         NRyg==
X-Gm-Message-State: AOAM5307QUFqJOlwZUlMQXnejPdykqgOhXBqdKkG5jr5MFI0Xbr9/cNS
        Ip3X8I/Sy/Ih050bhHcLs/17m11lPRALTyOE
X-Google-Smtp-Source: ABdhPJyqnWReFmM+JB7OrJPiM9inT1BaAZDWhNZXzVpCWghvoH7zELXht9z4SuzYtmvn6TDxyLhW6g==
X-Received: by 2002:a17:90b:3141:: with SMTP id ip1mr22372473pjb.234.1635542977979;
        Fri, 29 Oct 2021 14:29:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x190sm7441452pfc.212.2021.10.29.14.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 14:29:37 -0700 (PDT)
Message-ID: <617c67c1.1c69fb81.f6952.6bea@mx.google.com>
Date:   Fri, 29 Oct 2021 14:29:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.253-10-g2d214026445d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 1 regressions (v4.14.253-10-g2d214026445d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 1 regressions (v4.14.253-10-g2d214=
026445d)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig        | reg=
ressions
-----------------+--------+-------------+----------+------------------+----=
--------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.253-10-g2d214026445d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.253-10-g2d214026445d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d214026445d05faf1fb731ca33afd597b3ff31b =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig        | reg=
ressions
-----------------+--------+-------------+----------+------------------+----=
--------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/617c2f7d3603bfcd0b3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-10-g2d214026445d/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-10-g2d214026445d/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617c2f7d3603bfcd0b335=
8dd
        new failure (last pass: v4.14.253-10-ga2eff9f8c0a2) =

 =20

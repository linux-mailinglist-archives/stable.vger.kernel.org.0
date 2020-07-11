Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A76D21C182
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 03:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgGKBBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 21:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgGKBBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 21:01:17 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B2DC08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 18:01:17 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x11so2930527plo.7
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 18:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rBIuorYhFiw4ELErLisDsYTXyR64nu+ss4/u26Ghc8o=;
        b=gLzGCPoL8i2pmORdqX/y/JnPlm8tg3jxRW7wF4MJTZSEEa+1C9IG+lciXqvWI4Lcy9
         HNpt2JhwE9HSy+aEfBd9t6xtMYImbuJeRszmgyUMOGqzhZG8BZVp3BAJCnjlCN9+Arj4
         sZQAiOaP1SnKlEiV4PuhCyfEFAxUKHmsAhqrJwppylhD/rFIa4P/MW5zD4uzF5r4M4rq
         HrDPlZ+XX9kBYPCFR2idJx8IUXU50bO706pFqUFLO0KfEdAtwlisSpuofD860i357y91
         COfyIwrU6JN9KTeTAbamqXa/uTCT5kK2ABiNBOIx4l/dc4BXrW1vaUPKS+ai1GOoRUDu
         ApCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rBIuorYhFiw4ELErLisDsYTXyR64nu+ss4/u26Ghc8o=;
        b=OCTGM1sC9tz0ep+ulU32yFqC4ceAkCHufa+2Bt7iJmqwX4F9VqbWbKhjwDi/dmLYi8
         3Q9XmgNu7Wk5beo/tZ3cfwxbL66PsVPxKAxCY5WTRAOSgoiDO3Hk5ddC7mNc5PljTxI5
         MIBRKtHoK5dXiaFHJO9TepIXe1ZtPd24EVWiDJgxvGZft44+CWXvan1R9DaZupkn7iXx
         O1fkWUbVxhsgweaMMIWNpQQT3ovlf0D/Grz+CIrHUczsdDon+uKrK/G7qJXA5deNvmjS
         53GNhDgIZIP6yyKh6t392Y8eJNTEInfTdZONPsMa2r92z/wqcx4S/MMTZyXRlOlFqMPa
         f9pA==
X-Gm-Message-State: AOAM53294+0oIWDlZ7+zUPNM/eZGpUSd+X445M8oR9/wwfLFyXDTdrPY
        sUaQsv5bpn0uePnWJGaALCYGTcARnOM=
X-Google-Smtp-Source: ABdhPJzpMEQm0sG2gJSbqJ4SHp3YS8JlUDeWcxRyuvSYhkaG+swJnI86XAty8c288+YhFEFLFe4a4g==
X-Received: by 2002:a17:90a:3689:: with SMTP id t9mr8375083pjb.28.1594429276550;
        Fri, 10 Jul 2020 18:01:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f14sm6771374pjq.36.2020.07.10.18.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 18:01:15 -0700 (PDT)
Message-ID: <5f090f5b.1c69fb81.b3367.07ec@mx.google.com>
Date:   Fri, 10 Jul 2020 18:01:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.132
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 109 runs, 1 regressions (v4.19.132)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 109 runs, 1 regressions (v4.19.132)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.132/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.132
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      dce0f88600e49746b4bda873965b671a23ff4313 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f08db1fdc485a1ca285bb29

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.132/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.132/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f08db1fdc485a1c=
a285bb2c
      failing since 9 days (last pass: v4.19.130, first fail: v4.19.131)
      1 lines =20

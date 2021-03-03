Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA3032C83D
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377181AbhCDAfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388050AbhCCUkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:40:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA2DC061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 12:39:44 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id s23so5143359pji.1
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 12:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F9m6NSsizabvWnidi4uZ8Ksf4obvM8tGixJEgo1s4jo=;
        b=TgP44kZmmhyXd0aN/QwMO9GA/LNud4JdidUkBZyGHwHfw0a/kYrksSC24eMqHBz2OC
         992ycQPZ2Rxeds0qywHMvPi8hS/HEOpApLOtKv9rtztVN0nYRRbLAbYMUi0lxU9q0l+9
         UO7FwXjodiBo5ehzp3Rm6o/5wLLNZQ+jzXO7sXx/7hGNXuaL6gaLzmegzjz9j5w7mU16
         wVjCTZOrR8QQS7ipO4EVGtTOnPN8AfGwCo1Bit8WAeRqWiQiMERvxeaBT1R75xo9+3De
         O6iTa3GDV99fTBbsCETRbeoxrd0rRdDdcI6PN+PUo4oNwd/UrDUPg9ioOs4K6l5CprNN
         t1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F9m6NSsizabvWnidi4uZ8Ksf4obvM8tGixJEgo1s4jo=;
        b=RgL4kMresPPFb07ozd7Ya6t3dSHf7bNZ9OKtKmO0KQElVIKdaY8yURO7HNyc3SfsCs
         IyQKZ8J9BANdl/8sGvWrxLgZQ7XCsnAClx6vy4jWD8EPVgZltDbnVCec/Zbp1Vn/Hc/a
         m5nz/Lil+20VQoGcPygMg75vxOnbc/C30Gf510k/mrdDNYeAZHWTn5aFT7xkn4jNsJ4W
         sjjV7DZ94vqaaWnuiL3rcNjr5l04N9WCNoRcwYrv4ZUMm5m0VhAxSXskvqJ/CxCOJPiN
         VxniAzbJOLbD9olEwGWaz+0Gd01XYCyD42E7lEOd4ht9vszUmNAIkdN/dVipKawvkf2f
         jt2w==
X-Gm-Message-State: AOAM533mobH20gxRkDLlWVyj9c0lj2RVRs8oTdtsGO2tvtAa7btwdK9/
        Ue65J41cbAMgWgUYSh8GwE328+YSm7JqKYc7
X-Google-Smtp-Source: ABdhPJw+QH3bz0HWuPmMfmTdl8FnX9+WCRk4Xysgk9FDVQl8zXPAUMLJFDnDwXCby6O/h8xvOH+vzw==
X-Received: by 2002:a17:903:92:b029:e4:bf7c:cbf with SMTP id o18-20020a1709030092b02900e4bf7c0cbfmr774256pld.55.1614803984470;
        Wed, 03 Mar 2021 12:39:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c22sm24131546pfl.169.2021.03.03.12.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 12:39:44 -0800 (PST)
Message-ID: <603ff410.1c69fb81.9d6a9.8573@mx.google.com>
Date:   Wed, 03 Mar 2021 12:39:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-655-g101a2c837f2a0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 101 runs,
 1 regressions (v5.10.19-655-g101a2c837f2a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 101 runs, 1 regressions (v5.10.19-655-g101a2=
c837f2a0)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-655-g101a2c837f2a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-655-g101a2c837f2a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      101a2c837f2a06f1e024546c59e6d1dd04aca5d8 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fc1ecde21bf5e08addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
655-g101a2c837f2a0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
655-g101a2c837f2a0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fc1ecde21bf5e08add=
cbc
        failing since 0 day (last pass: v5.10.19-658-g156997432be5, first f=
ail: v5.10.19-657-g84fa1f13a46b7) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0276A320E7A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 00:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhBUXFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 18:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbhBUXFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 18:05:31 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7F7C061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 15:04:50 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d11so1632597plo.8
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 15:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p+3BTgXfyMORK9c193pjp/j5kf3pSojjCJFyfR0ngCI=;
        b=oVhDNeHjGiL9YT+qNwGnpAeH1PDXO1cRDgbFDHNpDmbbjQmEokA6724UMaYPIwDSJs
         zt63mTZh4Vwsk/NEdxaKZyi/b1qShhrEdwHakpwyKF/OtZH/innMDLGqJ5k+avZW2C7y
         CQ5vnXJoNcU50e7K/TJYikBq9v5QVCaNU/RFdb2i4G119z7DjtItMR50t6i8e0KJtQvz
         /zRTvZmfDwY4IpaGq4HDvoOp4AiPgBBhq5V/oGQi0/VCTwohHstTGusAIl+zk3TAeEQT
         9WvDG2nmJBBWAnyRZHltc0sH5PaaWtJPbYPXQKIaCY3GLHuPmL2J6Fkxcnms5kSGv6NW
         iC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p+3BTgXfyMORK9c193pjp/j5kf3pSojjCJFyfR0ngCI=;
        b=icnefHHQsrQm904ADUcSw6EXs2SInyX5OVkgHHLw09L+jYnZeuSJI1/PwZgM2lRA0D
         rtvADhmRI3DBVecvVd/NltigOp0IXC6c1A5taMhZsYgka8dJPihZSWjvW/9yJc5fTtkx
         YuCTubywp64Ohoet3OS7oGGl1eWz9K1yCYM3zGOOnKnxcnt+UUAd5/AdVR6s1g8QsdZg
         6Nm/b1FftmLcgA/DK/7mgUqNElVpaNA7DL7qMqqAPgrcMb83cq6b1r1hjOO/lDxgz6h9
         Rk7gxT/ibOmtU9My5BiXY2WAOyJSiRNOYRQlYHGZqwBl4z5oBoXEvHQwXnkAYpiRBwB/
         eJ4Q==
X-Gm-Message-State: AOAM530RCr3+W2K2Ee34R6vqFtuFSEUOL9WUPAfySe1JERh5FOaoV5sr
        4niqqpwbtQHgD90Z473+SPvpzUniCNyFyw==
X-Google-Smtp-Source: ABdhPJxxywVRGBuEBrkUYIJifJM64Y4aaPJE/DYuVMBParWGJB+xQBx25NVOnAf+Jyc7HQg1kTQTeg==
X-Received: by 2002:a17:902:6bca:b029:e2:c5d6:973e with SMTP id m10-20020a1709026bcab02900e2c5d6973emr19167768plt.40.1613948689976;
        Sun, 21 Feb 2021 15:04:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm1607150pfo.201.2021.02.21.15.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 15:04:49 -0800 (PST)
Message-ID: <6032e711.1c69fb81.d0aaa.3286@mx.google.com>
Date:   Sun, 21 Feb 2021 15:04:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99-1-gd50a4341411a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 113 runs,
 1 regressions (v5.4.99-1-gd50a4341411a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 113 runs, 1 regressions (v5.4.99-1-gd50a43414=
11a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.99-1-gd50a4341411a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.99-1-gd50a4341411a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d50a4341411ad6f4ab0b9f857e15571fae324d20 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6032b053b40261936eaddd40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
gd50a4341411a/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
gd50a4341411a/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6032b053b40261936eadd=
d41
        failing since 93 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20

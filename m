Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B364E326715
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 19:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhBZSrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 13:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhBZSq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 13:46:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA0FC06174A
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 10:46:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u12so6386434pjr.2
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 10:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s+bJZ0y2wdgviAe/fpHEtodYakNPlAhIhe28rlEnAJo=;
        b=oaBbas8fNGkgso8M/vi+eLSVW+N5zCWhr1g7fGrdVYdW5+MS4p1PxPVh+LSu91lVun
         EYYMkBTlLi1pl5BG1bXBFedlTDb4vr22hbYBpGOaZ6jIaSd3obA/gTnxDaHx9aFQcXpR
         3rKdvPr5L7F+iyTMzjaEmCK0KAvl8n7ChLrdmd19wBo2NpBi0rqHhaVHhITi3PjJqs/m
         PiNAmWB7lQ1KHcCH1IS555Ni4j956ttmBzBASxHQWALp/AKbR1yAIlDqgrGj5jlBaSXM
         lQUI3/isr+PNPgTZPoTqMKTe/clU9gD7VaVTODUrkMLXfdZEdIf46F8CNk3IWnBjKvfc
         /diA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s+bJZ0y2wdgviAe/fpHEtodYakNPlAhIhe28rlEnAJo=;
        b=MEI/UZaa5JMkCo9OYoIV+vainklZ8zqD8aZiOOMoqkFf3XLWHhNTSsDowc9xRq5+FZ
         G6iE18GbiPPYUhERyUiSZfWx429Idbsv/5NFQgsuEUSO378e90cbtasa3jXvyefPSTTU
         a8qoXLAMu4zG9Kje91IjGPhMultCP+g4YorZ+BsixITUGOqzKQivMmUrMUsGVhpNh+Dz
         Hu0aIIyavlcuGlNFeXy3gEiWKRdvPtjbHKCF6VeUIALFCru7j4DtWHYVmlZL8DsA1Zgx
         2jiJniQ7PtkqQvpWw7GomYsIG5ReRvdCdo/Hu96QBcozoEwlQI1xE5pUXeYRW8MiIYVQ
         JHuw==
X-Gm-Message-State: AOAM53269EMir9Wl8bWOtV+bfzeqDdueOuQAogliYv2FcqepCDv5pYzb
        afc1mekiIosXF5sD1bWlUJKqa8zDymewNg==
X-Google-Smtp-Source: ABdhPJxCAPlHhCWtsapdP5qLELHFb3iPUH2VK0s+5zzcs5kzkdF69B8yjsAQsBXYUOIGHDpWFdWgAQ==
X-Received: by 2002:a17:90b:941:: with SMTP id dw1mr4905172pjb.35.1614365172730;
        Fri, 26 Feb 2021 10:46:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e129sm10565718pfh.87.2021.02.26.10.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:46:12 -0800 (PST)
Message-ID: <603941f4.1c69fb81.4fc3d.8161@mx.google.com>
Date:   Fri, 26 Feb 2021 10:46:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 101 runs, 1 regressions (v5.10.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 101 runs, 1 regressions (v5.10.19)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b43ec8a0cc6fefdd63a1443edef0d2693ff99a2 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60390fb22d3ae1d2caaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60390fb22d3ae1d2caadd=
cc7
        new failure (last pass: v5.10.18-24-g6ffb943c0e01) =

 =20

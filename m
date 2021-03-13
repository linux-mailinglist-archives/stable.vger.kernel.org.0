Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C1E339BE2
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhCMFF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhCMFFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 00:05:11 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FCCC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 21:05:11 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 30so8307647ple.4
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 21:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CuqGMSvx3h7pFGQE3f/vd8xrBQwaUF3+6LJekOo+lYs=;
        b=HcLUUb6NtskVzTPrddEy9o1jLMuAEZSPlcNay18M5+k8NtdVEAzq8Kb/7xJUHMeUZE
         yJVRkcfcB9aA9R0zTKIAgwF3HHJgWY7iV/8e4RGQH76rD+Pn88Pvhv/xUNWV0kRtQtf9
         d0yeiXrC8EUKA7QyVHFaFKsbDJxjkYyMaAWqggRD4MOv1pyNG184bTTh+SNTqPoeaViU
         POh+sKBl5A8n+aoDrAg+JGHF8uX3gzpiuTzZOgdstK/OEIipakYGSqOgWXqaxxWgh8jz
         KaG0gwHmTm2ShoIdGOdnN4BD2Kz/bRBbTbE92YGTC4Kn7/+wP+Fxap621mEMiDdNt3Su
         cBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CuqGMSvx3h7pFGQE3f/vd8xrBQwaUF3+6LJekOo+lYs=;
        b=WsVx1ODA+7mVR099c7xPki8qqDYCiGuAhZKItq3YnNuU3X1sGTIKaX54uuxMCNeq3x
         5m0wcXQaDb0IBK45Xuq4F1gzgiKysVevi2VcjlHzB8fojyw2mjhocXV2uDHn2Ppo2L59
         lSME5EcPNLF9mbq5UO7Y5tPcI56fHQakBmHzdMsFj/c5UuU4PwkynJZSEOj0oSMVpsD6
         VPurkgHyz9NpNlDmF4Q8xKS76knQxyu+d7bl/T8B+aVFftEagvTxc10jPw1xhQwIx4Np
         mloewJtrw2KPvg+IA2AjZFg+OhVE3P6eoUy5i9WhL82OdQy4ivTiChdPvWpkUYSXXECu
         /YAg==
X-Gm-Message-State: AOAM531QXESGbYqEfpqd0pC/Af10PJZLITgH7QTaFz9E6ljDseOfYBIx
        jj/htaGATsfwVjiS2GYhCMmstkSaKPKibg==
X-Google-Smtp-Source: ABdhPJyiIA5QW4cq1SS06I9mTnLSjmbLC3pTsJ8bCB0dD8867Jmn/fA8Z6Hn4JZTqCE43mYrlcXvPQ==
X-Received: by 2002:a17:90a:be07:: with SMTP id a7mr1834179pjs.75.1615611910357;
        Fri, 12 Mar 2021 21:05:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1sm3814315pjc.24.2021.03.12.21.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 21:05:10 -0800 (PST)
Message-ID: <604c4806.1c69fb81.ba4e1.a53b@mx.google.com>
Date:   Fri, 12 Mar 2021 21:05:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-132-gc2d4d7bec382e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 2 regressions (v5.10.23-132-gc2d4d7bec382e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 2 regressions (v5.10.23-132-gc2d4d=
7bec382e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-132-gc2d4d7bec382e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-132-gc2d4d7bec382e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2d4d7bec382e1fcdc78341947c7842295f9db75 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/604c1439c933337b9daddcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
132-gc2d4d7bec382e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
132-gc2d4d7bec382e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c1439c933337b9dadd=
cc5
        failing since 0 day (last pass: v5.10.23-31-g559d8defe7bb8, first f=
ail: v5.10.23-37-ge21780881c24f) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/604c15a86cdd918b3baddcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
132-gc2d4d7bec382e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
132-gc2d4d7bec382e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c15a86cdd918b3badd=
cc2
        new failure (last pass: v5.10.23-108-g78b73fb5a5f43) =

 =20

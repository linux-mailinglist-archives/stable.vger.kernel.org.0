Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D037B1D5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEKWxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 18:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhEKWxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 18:53:51 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322FFC061347
        for <stable@vger.kernel.org>; Tue, 11 May 2021 15:52:43 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 10so17295588pfl.1
        for <stable@vger.kernel.org>; Tue, 11 May 2021 15:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=beBxTBTH0Vl1IL/0yNkHE+Ub+Lr/nvM4jQypd/GEFqE=;
        b=dUHftvV8S4TnE2mISYDO8IALO9iVusIMAoIGhqeUcgVHeF87Cp/qDzTGBrmcRq2Y1b
         fEP/6WmGSiZPA3GAh4u7fW03j2jKnfd/FGzkPGuWGV+sh2H35wIAAZm/RodRxVNpI+qO
         R22Ugm4Qt3l///4YEWnfVft4UEpUm0cnM+qCUlELgKldiM7isp3cScsrsjb8qimftyRH
         13otEwi+VIGwG4Q9c/R3UNqkVfRcKTuApAgS7ZFrRj5Dog/232nGnNoH8pXLHn8C8ehC
         XXDbvLPi8db271GhxItOn+QZ49Rbfp0A9CQ98WmJ8ZYcyaeLNqmNvMzu/Q9lOUFiGZYH
         3kXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=beBxTBTH0Vl1IL/0yNkHE+Ub+Lr/nvM4jQypd/GEFqE=;
        b=iJAC3U0BSSRNrYn5vgZbtAWsy3s51ymXM0AmEhM5QJqa6XvLXSyFURnjmUUk6rIHoX
         SFI3tHD1PLaa0hG+0p+NYgbI4QJR7NdzE7qiN/aGXlZYlXSmcfO6HXvt6aBBHmIy+3Dt
         V58xuOvPOpw0ixjiTJ/g8apt5CT+Qo5u/74H13Uafql8Agi6EWBQT06fzpwlh4PXReYE
         uY1ILhtd93CvXKE80lbeh1F66IPdAOf3U28eeV3nUH+gC71J/HhEPYinChW7A/0LAupt
         N978vBeRJFU2xT/pB54J5zrLG8z9/hpuv6R5MLGqbE2LvfAtJuxMFoC7WFx93fRu4/tN
         Qa5A==
X-Gm-Message-State: AOAM531AtLSuAt7usuUkHhBDW0j5rPksY/xfnu7g+nqOVaOf7t5RVda0
        W64iP+qCEGFk3o3/2WWoXvj1yVXJTztfvXin
X-Google-Smtp-Source: ABdhPJx+5+6cKOmPintevWE1nlTuFJq1Ydo5fhvhlRiDAxP8QnX0HP/xF5e+1iwYnzdFnn6hzxt0uw==
X-Received: by 2002:a05:6a00:224c:b029:28e:6004:d0a5 with SMTP id i12-20020a056a00224cb029028e6004d0a5mr32991687pfu.1.1620773562548;
        Tue, 11 May 2021 15:52:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a16sm14431570pfa.95.2021.05.11.15.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 15:52:42 -0700 (PDT)
Message-ID: <609b0aba.1c69fb81.6678d.ca90@mx.google.com>
Date:   Tue, 11 May 2021 15:52:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.36
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 177 runs, 1 regressions (v5.10.36)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 177 runs, 1 regressions (v5.10.36)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.36/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      72bb632d15f2eabf22b085d79590125a6e2e1aa3 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609adba15c731986e3d08f3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.36/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.36/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609adba15c731986e3d08=
f3f
        failing since 9 days (last pass: v5.10.33, first fail: v5.10.34) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC248E121
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 00:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiAMXsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 18:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiAMXsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 18:48:22 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42505C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 15:48:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so20393977pjj.2
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 15:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eRKJU76BTGaz2lAnBrff71hRW6sZyn7T0t1/2bd/wRk=;
        b=O1zgAkv3U8BILjyaLNGw79N5XrHVnYSZIaykS1mnhTXVeH0Ouyc4otO8jHW1Eq5DJB
         wDeheeJRUig/C4ru8tgOnTzw3fjv8CWmRFxcD4t598DXk5H6j467x9BQ8OUYm4OSpupH
         44eb3Ry4irEJSOfhoFe9fmagFgOZavyaxShBkyOilzMRU1TK1ZV1n9diX0xNEbUPKUbx
         I3FtskC8Vkgkocn6FGF7PsZjsrVYhfSzvBL8kTNGzLq6MLQi4npi+BxAm0cVvp3Zekx1
         /DlhOjoeAI2HC1eFsW69gXCLkAG+zAMG024kw6y562h5rfkevHEFOkYhAYVR+stgl+yd
         /OQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eRKJU76BTGaz2lAnBrff71hRW6sZyn7T0t1/2bd/wRk=;
        b=vxnxcYDLng9TDqikL/kfDlNsmT+1ip0wJ+OkrxgXHLZy+No7Yliss2iwJUsVilpNxf
         VmcW9OWmaN2s0xpEVCG0FVfECNZLwQPeiO6yHUDs3VOExZ+dnbEgLnEtOa3yxY7Y3Yyu
         FCuIXJXKVSWguhNbzHHS4wZYeB9vL03cSar9zSbTKz7hlNsNb6VsCZw6NTyEcfnDyB/P
         HSZQxPX6/nLoMRmJQWBgLWGUrw/QicwUhZtK3g/T8ViKS3KfMC8vTKlq05yiqvJFbez9
         q8DiIBZqB4mg+qwYtpepP9p8ZCPESY+sR5N56TR/cGgRUTzY8X4ku6xoq9NKCGc5G70z
         I40g==
X-Gm-Message-State: AOAM532oIKoQ8dIDQx9Jv9nVoWzks85LJ4qbNI/5vO54stqEkycXmEIu
        4eXGOTjtzW9Ocpod1/nuGFeuoteBbvOsHKN6IIs=
X-Google-Smtp-Source: ABdhPJwmfaxJ54j7XTka51xKDoH+eHzq8TWt3YHG3F/+y2IrHdHNI4An++LhRgsAa72ub3AN8fGgxg==
X-Received: by 2002:a17:903:32c2:b0:14a:37ba:2fa3 with SMTP id i2-20020a17090332c200b0014a37ba2fa3mr7070229plr.37.1642117701609;
        Thu, 13 Jan 2022 15:48:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm4034583pfu.72.2022.01.13.15.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 15:48:21 -0800 (PST)
Message-ID: <61e0ba45.1c69fb81.f0f0.b2f8@mx.google.com>
Date:   Thu, 13 Jan 2022 15:48:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-15-gfa5ebb31ce11
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 1 regressions (v5.10.91-15-gfa5ebb31ce11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 146 runs, 1 regressions (v5.10.91-15-gfa5ebb=
31ce11)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-15-gfa5ebb31ce11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-15-gfa5ebb31ce11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa5ebb31ce1175e76b0521eb60368e9909b38f93 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e0b2faa4e7974893ef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
15-gfa5ebb31ce11/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
15-gfa5ebb31ce11/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0b2faa4e7974893ef6=
73e
        new failure (last pass: v5.10.91-15-g4ef1ec6a29c5) =

 =20

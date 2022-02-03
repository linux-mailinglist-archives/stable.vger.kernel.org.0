Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3524A8821
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 16:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352045AbiBCP5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 10:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbiBCP5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 10:57:13 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF970C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 07:57:12 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id u130so2592773pfc.2
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 07:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jFXm2gRHvIZG/BV8EEgCuBxbiAOOtdilvuDqaUH/qzk=;
        b=6HkI1WM0SQweFwhrRvfaog56V+991bCLu6TMSaQBzh6mkyB+BWFcrniwQXqjsRbNmQ
         zvpuv8q4nNCE+8PAYx+5B4n4C/3BU2q9A2QBSZ2vqyJ8uyAPEdetSBF4V8MhEZ+aO6kS
         YC4bGchLbGf7iJqXO7jTU9WNtQzLstl7dUr5e5GM8vwlyi1EZjUIPB9xtXXa7DQZuihf
         0Wc9tcpi5lksrSfMZNH/Sle98R5iusZS0jgcn6/o1qE5f0K7hnPYhnmL5zAmCdxvXUnK
         FBOT8Lp80dL0uMVfAlHU8poNBdEUeOX9YHlMbweXF+o9lEHh1413+I8LoA4LOEV69Utb
         zINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jFXm2gRHvIZG/BV8EEgCuBxbiAOOtdilvuDqaUH/qzk=;
        b=pbECAbzqkuui3CReEeUEQyw1wBUewv993nFfkp/r2irtAtDzAIlphRuRjVX5lxCSbx
         Bhh0sHHhordo4ufq+Nx5urKrf9VhKZvZ13qdYpA/2dO5CcKL+lMoSNytAgAx5xQn5WVM
         3I6ezQmX1UAoiC3Ova2mDEv27PuCVHLRVo0ZBcDESCZZ2sI87aGYhNNojb/Iyxa7ki1d
         +qExqzzYqBBKXu0If54jy4UhgfJMYcNwkbmd0cCXokNjHq7cbx/30xu/3Q2QO040ZBBg
         mqZxg3v7w4D5Y057dn/F2aSDZ83bHD2ja2AAtxyJjWcoRiEVsuo1WsQGa3T2trX5FkK8
         Aywg==
X-Gm-Message-State: AOAM531KlZefVLXPkzHFzlOZJQ7O71GPeJrUtpSqyRP6u5RYzGFcxBLk
        dIA/w+DR6cKOEzkZrkewuRYimiCdFb1Cjkdg
X-Google-Smtp-Source: ABdhPJzhB0ae7bDbM5FCOl42CST6JfPdURi0pGjUwcwzzspkUJaAE2HEEmxldaAMLJ7DI0OxKllFNg==
X-Received: by 2002:a65:5c84:: with SMTP id a4mr27840777pgt.258.1643903832171;
        Thu, 03 Feb 2022 07:57:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pf4sm12281177pjb.35.2022.02.03.07.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:57:11 -0800 (PST)
Message-ID: <61fbfb57.1c69fb81.5e9f8.d6d4@mx.google.com>
Date:   Thu, 03 Feb 2022 07:57:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 199 runs, 2 regressions (v4.19.227)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 199 runs, 2 regressions (v4.19.227)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.227/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.227
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4b1bd6d9c2e2818ad1ef2483471c8b9a5c0a01c =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61f56e36e638256fd4abbd23

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f56e36e638256=
fd4abbd29
        failing since 3 days (last pass: v4.19.227, first fail: v4.19.227-4=
7-g0366c2cb37a1)
        2 lines

    2022-02-03T11:55:14.442921  <8>[   21.230804] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T11:55:14.485004  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-02-03T11:55:14.493747  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61f5b24463bc55bd2aabbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f5b24463bc55bd2aabb=
d1c
        new failure (last pass: v4.19.227-47-g86004a50cfe5) =

 =20

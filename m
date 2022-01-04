Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2FE48461B
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiADQlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 11:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiADQln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 11:41:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EA6C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 08:41:42 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso3784087pjb.1
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 08:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=McgM6jkSgE2NySwy71O2CQ/18ILO2N480wGwCnufAsE=;
        b=asqAo7rG5ELfuzB7RwEhV1IBn7MEnE6zrFFuHHHKVFoMkc9Sq4Itcp2agsnSY1J0bm
         ayKboRm7AjBlMqRZ1PWFyuDNTfTn1aY1d6n8jzft8iXatQet6RqkK0jHcALHAWqrSvV6
         Xk6sJxd2XkGkalowQfhp9OPohFdeICpISH+y/1AHyzGb0yDeacskEf4UOjmebVlvK3bT
         ZgpKYgAZ51Xr6EA+o4HBGYqqJNs3KYzl8+qAREjZHpnJb8HsAX1sDP5MLADJgubYSgpJ
         Zyvzqf6Z7GWyHC6DSahFZlUtipXpRTzufxZAlp11UfvxQCaoQB4VbMiPrIeIgBfnCms5
         fxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=McgM6jkSgE2NySwy71O2CQ/18ILO2N480wGwCnufAsE=;
        b=0ZH7zDAkUrvs4MA0hrME7pKkXvR4/YicZ10ZyKusCDkdwqBGpge4C1qg0fWNTwi7bS
         hm19Yo1eNQA77pipEy01/Jimli862a3xdHHnX2r5E3CKIssP8a6hyF0Yciju4mlvrfqu
         +pwdlISSHzjz+DaGjj/q9ftGXvAcOKNjhnKuG9ne1ZgVxnKAGl8OuYTP+30MAkv1IikS
         xrU9UX9Uhk5oCyS1F3KYwO3yoIYseF2jAL+vB5gzwwDLKj/esFWggPP5ZXzzW1c0Ea2c
         7/MpjJ70ovPWeWT44VSGLWvf1q4n6jjybN0XX8HoSuk7bxjUB9l4JdihYsd5sd4tyiPC
         UkXQ==
X-Gm-Message-State: AOAM532628xaBB/Z9eOVra1rt/wT8J8HCm9KW1zp6O1v7jNpPBxGKtgm
        B3Nd8pSV6Nz+PZx+qUnKzeuGRbth5drxZg8L
X-Google-Smtp-Source: ABdhPJwyzVIXyZsZKelSF/iy8MU+WMB+ec+V0ilD62MjnJZIJW84mMDwmIjcKsqR2WtCxBVz1Cx15g==
X-Received: by 2002:a17:90b:4a51:: with SMTP id lb17mr62284170pjb.101.1641314501963;
        Tue, 04 Jan 2022 08:41:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm44379920pfc.130.2022.01.04.08.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 08:41:41 -0800 (PST)
Message-ID: <61d478c5.1c69fb81.498c.3747@mx.google.com>
Date:   Tue, 04 Jan 2022 08:41:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-28-g1a042e04b035
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 164 runs,
 1 regressions (v4.19.223-28-g1a042e04b035)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 164 runs, 1 regressions (v4.19.223-28-g1a0=
42e04b035)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.223-28-g1a042e04b035/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.223-28-g1a042e04b035
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a042e04b0350091f20d98920a2315abd4c2a11e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d44362495c1d1afdef674d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
23-28-g1a042e04b035/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
23-28-g1a042e04b035/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d44362495c1d1=
afdef6750
        failing since 0 day (last pass: v4.19.223, first fail: v4.19.223-28=
-g8a19682a2687)
        2 lines

    2022-01-04T12:53:35.876387  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-01-04T12:53:35.885642  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-04T12:53:35.900687  <8>[   21.332733] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

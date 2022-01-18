Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333334925DA
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 13:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiARMnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 07:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236761AbiARMnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 07:43:52 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA3C06173E
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 04:43:52 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id c5so13846685pgk.12
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 04:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2yt0bJS6NvB/DCsMo1SwbnzEGm5XaLu8/zt/kcwHXxo=;
        b=JUKmnl3aGpwbV2NpciD2u6m4XyYtk2CGrghjvvMTE1BE1Mc+kP4TLbqLngWFnZUimh
         uHAD14LmeNIsnpSycOrVKIXDkee6IUsUdReESYYiUBRxWlBQIcJ/U3+t8ZpNRsQOaR/N
         WSqkLcclpOcSV2Ls75pyRRHBywNVnkEFCOhy2YU3izYeuJonOwaUiJ380+UenU5BNp17
         A8yjjxSsqro3H9nB3/CewK72pj9hEbhT14bMTo822WQJjowkjDw89ALSg20txhO62CCH
         ymY4vdiJahDkE6H/G9vbwUPUGx/aLPWnynxx3vMMY08Lw64OTgICz/kAMoLmVjb2kcB4
         FRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2yt0bJS6NvB/DCsMo1SwbnzEGm5XaLu8/zt/kcwHXxo=;
        b=J7bU9HxHmOOWOFCwxOTs0LRHLVjV0pcmVA7iEzyU/jr8ORIATIQJ6Az7Vsgm45e8d9
         FNjMSmCgoa02izmVGisgmfNnIyOVvB+snaF1tfX6pKRb+cCvzNcWbO4JM8dHg4+Cw1rV
         hen252gpogqeT76xBlzp9XSWCHzxXI68NLvJbBMnvHc+WnDK3xxPNqTBvC3y6z9WmuKE
         CiU+YqfltKJnKAeK2Rk1fQz7p0vAdzJFBTQJKFYV5VyzSXZYiF+M7pI8gzQB/6R2Onis
         oVOXxrqpKGz84isM8KC3g3rYM1Wu5zCRvuNBE4ur+tqPRuy67kcr1g2y1johfEfhj6xc
         Zz1A==
X-Gm-Message-State: AOAM533VbeKE20cyND92X7RiZ7maDQd9i8VOAy7BryamhEdU5TPkT2cT
        fDZA3xTGMgJgEjSwxSlfNFPbNB3Xdi93WbeW
X-Google-Smtp-Source: ABdhPJyF8qsjMfEWwC/aoXeXqPfSyCY4h7I2QVV3imYAFbLsY6Piz7xiErK8ehKj85t0HI3XZxhzEQ==
X-Received: by 2002:a63:2b4a:: with SMTP id r71mr23494825pgr.57.1642509831425;
        Tue, 18 Jan 2022 04:43:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m10sm2583718pjl.33.2022.01.18.04.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 04:43:51 -0800 (PST)
Message-ID: <61e6b607.1c69fb81.aec58.685f@mx.google.com>
Date:   Tue, 18 Jan 2022 04:43:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-10-gece287e6caf0
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 101 runs,
 1 regressions (v4.9.297-10-gece287e6caf0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 101 runs, 1 regressions (v4.9.297-10-gece287e=
6caf0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-10-gece287e6caf0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-10-gece287e6caf0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ece287e6caf0c867595f29ebba9e1f4f95877943 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e67447178f77f4d4ef6762

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-gece287e6caf0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-gece287e6caf0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e67447178f77f=
4d4ef6765
        new failure (last pass: v4.9.297-10-gfdec8da75479)
        2 lines

    2022-01-18T08:03:01.082505  [   20.568481] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T08:03:01.135221  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2022-01-18T08:03:01.145027  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

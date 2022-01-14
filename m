Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BF748E484
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 07:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbiANGzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 01:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbiANGzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 01:55:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3551C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 22:55:20 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id p37so1974577pfh.4
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 22:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jOenW4bkGwTATEve9n3eUjpycw7imgouTWMNXtvWR44=;
        b=mPXwyXty9v0nmY6FrvQwmlGurYvcERbv+/rf5eCvd+5WA4NVDx4bVdduEiRHGWhgJJ
         xGpGm9WghNG6Lg9gE7E7IKOVHn5c2NgMlVW3tcTb96fd9HPEQE5fQdFXmkbz5P2DdrpC
         mHNUp00NSYJZC6Kv1ar4UU3oaTBhrUtlWQTC+yomNcFUgG4aDWohk+GYKKnNNiHcwzjQ
         mFZFPN7KF9faqxPo0C4Rhp1wsaNkCSA/dficgCJ2umpcy3w/pQnZkPvmMtsr3mP2kFzX
         lglfTNNbqHw/p+o3cMhwdHPs2VqvCAk1qUIr/rg8QU+UeO5kAQTKc9fUVE/WMu63Jfss
         FFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jOenW4bkGwTATEve9n3eUjpycw7imgouTWMNXtvWR44=;
        b=iBTfG9fIJ30wXmig5sFKpKoZmG9rnGoS7yloBzgXLNqg8ype6pXuNNtTYop8hAlxeZ
         jmHUXyVlOq+EBr4voc34q+m3ZMTWqbYe6zbZFXL2UbOe88YQ+5RNhuVwqjBqqHWNgxBJ
         wESsYbRLQ2jA8I5gUTE7mBXBl0ldYkEZ9f6tGyjdGFDfDIBtMv2nXxp3EjibCr1f4Wdl
         ZOpGZJO4QPDBKsK+rFhGAY98Oei2pWPYWqOTBgQ4xs79fTQml9di35YqQo4oSfqyDWlN
         j7+wkEiniordLv8tGL1wGHVY2Qmdnav7kWTdeFtw+BxcLiKSkNxod1xWaMMhsFCWCjUC
         ks3Q==
X-Gm-Message-State: AOAM530VDZRIHZXjELS1N2W21+zJV6xY0KnSd76c8Ee2vpksSuc9H5p8
        nM+A5L0m9imL1OViX5KJOUmbdXQOELNiz9WkTwM=
X-Google-Smtp-Source: ABdhPJwsXc0GvOItCSNjiDdwIo3NQXhFYPv3ZUd06hlgmU7vwRjOfT0YY4obxlGa/aD86dEHLKTpRg==
X-Received: by 2002:aa7:985d:0:b0:4bd:8a52:63f0 with SMTP id n29-20020aa7985d000000b004bd8a5263f0mr7596189pfq.56.1642143320340;
        Thu, 13 Jan 2022 22:55:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm4564776pfo.91.2022.01.13.22.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 22:55:20 -0800 (PST)
Message-ID: <61e11e58.1c69fb81.a33b2.d88e@mx.google.com>
Date:   Thu, 13 Jan 2022 22:55:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-11-g9b4502501eff
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 168 runs,
 1 regressions (v4.19.225-11-g9b4502501eff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 168 runs, 1 regressions (v4.19.225-11-g9b4=
502501eff)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225-11-g9b4502501eff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225-11-g9b4502501eff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b4502501eff6da9258c8fa2628e0f467fa690f6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e0e995893143b593ef6782

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-11-g9b4502501eff/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-11-g9b4502501eff/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e0e995893143b=
593ef6785
        failing since 10 days (last pass: v4.19.223, first fail: v4.19.223-=
28-g8a19682a2687)
        2 lines

    2022-01-14T03:09:57.000160  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2022-01-14T03:09:57.009782  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-14T03:09:57.026132  <8>[   21.340057] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

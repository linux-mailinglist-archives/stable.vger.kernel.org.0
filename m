Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1946B476964
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 06:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhLPFSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 00:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbhLPFSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 00:18:33 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31629C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 21:18:33 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id o4so22606345pfp.13
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 21:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9QGSjvfsKgM7PI3RKW6M9HTUgU5roWP388DgJG+KDjA=;
        b=URWjTAupvvEsOdbKMfJgw5cV8fycwonyuCFJrgIwMfiJNmcbUI1bGiJllKBchSViWs
         FhxPXvY4q/0a7bydTViq5/LmhDpQzeTvfd4Q9HsJwEP5VqCb0qfg0vFtJ+KaM/B0h7Du
         ToOv+44GrdBkig7GqKuxMdmoGMz+NsIJEm3DsX0uajkMwmcMrQ4J4wz11JbcU7zzXg5w
         toi2ypfeOQlInVNslMypuDjqqq3lp5M32RuYVHEv7mU8IiukbjHieKqF1dqNuyio+Wyk
         P+Hm6RDhoUpxSQrPqcm+yJnaub9s8qatoah4BdTxd3wm0eVpDK7RGJ2KXclYj8jdLXpS
         xJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9QGSjvfsKgM7PI3RKW6M9HTUgU5roWP388DgJG+KDjA=;
        b=2W3koGju7clUhm07ULX/sHSf/f7s6DOalARz+K0ntotsd7dg1mV8SSqHVCB5hROvhr
         zUGqOZdVTldjcoNfS/NXjLSxrmsXLmbq5m8WmtoKjIWx/Bvlvp0lr8MrAQkgWrB88taN
         ww/+kctkMp9BEw5NiiVIm0d6JvYMNEu5EO9Rh0QKTjJgCwVpst4JHHOQaj/ZVsm1+u62
         Q1sReuiR4EJDCOCc/5XV8rerbGhMZhg19qgZy5ErQ83IJgSJ8S2lGGyZnRXPnopFGjJo
         l8m5Y+qLvDrS0Du4m04uSoiysrug/j63JROx9acUE9THLtyw4+oH1JnmCIh5U+zrxncq
         HkTg==
X-Gm-Message-State: AOAM532EDibJLRlKJ9d1/ymr9pPEl/BlppPQ0ckvX/t5l4n6aondYa9G
        P5W11TT8RCHcFDU32BQH5zJjT4qtwiLJ1Ad+
X-Google-Smtp-Source: ABdhPJz3cNWC06RIkP1Q6adYtZJowjYQUMKu+gp9SuYu6FDeX/55D+J2GlxILn2NPHrUPHD0Ha7/EA==
X-Received: by 2002:a65:40c3:: with SMTP id u3mr10620157pgp.160.1639631912199;
        Wed, 15 Dec 2021 21:18:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lk18sm6303882pjb.39.2021.12.15.21.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 21:18:31 -0800 (PST)
Message-ID: <61bacc27.1c69fb81.7db09.231c@mx.google.com>
Date:   Wed, 15 Dec 2021 21:18:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-8-gd6269e6b81ba
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 117 runs,
 1 regressions (v4.9.293-8-gd6269e6b81ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 117 runs, 1 regressions (v4.9.293-8-gd6269e=
6b81ba)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.293-8-gd6269e6b81ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.293-8-gd6269e6b81ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6269e6b81bae4cceb5763985be4e6f0a1feddcb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ba955e72742b2b37397233

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
-8-gd6269e6b81ba/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
-8-gd6269e6b81ba/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ba955e72742b2=
b37397236
        failing since 2 days (last pass: v4.9.292-29-gdefac0f99886, first f=
ail: v4.9.292-43-gad074ba3bae9)
        2 lines

    2021-12-16T01:24:28.248007  [   20.241760] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-16T01:24:28.292369  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-12-16T01:24:28.301752  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

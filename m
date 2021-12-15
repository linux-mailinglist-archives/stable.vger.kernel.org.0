Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A91147662D
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 23:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhLOWsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 17:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhLOWsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 17:48:20 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C19C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 14:48:20 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id f74so4597197pfa.3
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 14:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=km/EKTVd3IYtWU2GwFv6mjO9ZJnCVHbwHtlxKW+B/s0=;
        b=c8QttbAP5OAuoFH6K4//YH/OBhmgSRoxvFI9eR5M0icI7b3AU4/1wNJQ843aBowALs
         Nabc42ZUBDnBzWMeE6P3zpS0sGXs1DQKMKI1yhj3QXFuAnOvyJDT0yFmTbfntwMbPgds
         re+pBX9fviDv+7bo79gvcpT8gz2CufPEk2BGQA3fd3TZD3H1dVShQRTtADPYuJBQktU3
         nleEwkWBa9ZwxWGkof8JzEsBTa/+dwKt+NEYbWf0TmurBhnFeU9QW/p9fYzmGJtXanMO
         NoWZNA1vrT6Iiv6JUjniPv7/7rwPOfVfrH+Bg2VcY2hXFtOOsWzmdDnd5bp9vgFLhikB
         Wugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=km/EKTVd3IYtWU2GwFv6mjO9ZJnCVHbwHtlxKW+B/s0=;
        b=b3NV3G/i3zJZRoBBwz+X7D/B+0jVHZABdxuBpATVxyaf+VTqyH2TsPktUgPdm8NF4u
         snF3Ett9tB5z3ZtaXL6NpRUacMK8N8wnNdnmu+Qxng1LrjH0MPnZMRtrJanpA217cygp
         5sBf1AHJpWxLNxPeJWt0uCgZaKVmKofRU0rRUluxgAS31oA37HPDEyScQtMrpmPYzWAE
         LFBO1ySMEhPONoRNlc79iqzRIA5IEd5GS+5e/62B3HH1BG7d+3srSkyEmQnmq6mkjqsZ
         mbFKNt2WlAXlttaqyeVXcPNp1zxPhyqMQP5ngDT/EFEkhyCSNwz056uR5bu0J3qir1O7
         FelA==
X-Gm-Message-State: AOAM531JCknOG7SZdMAO2ir1fu5Uf69E4B7/EKBRhrw5SYDS6/XvxgCW
        VpTaKyyErcRS7ktnGi84KGtyjKMiVoP/UbaP
X-Google-Smtp-Source: ABdhPJzpCNhlIuyqRz6lBcWGVBVVdxawaA8jhxE1LqFoM97W14UA6MQlBXZ3D6tC3O2HVX1f1e+wlg==
X-Received: by 2002:a62:7a92:0:b0:49f:9a0f:6bcd with SMTP id v140-20020a627a92000000b0049f9a0f6bcdmr11069545pfc.43.1639608500082;
        Wed, 15 Dec 2021 14:48:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k70sm3162526pgd.19.2021.12.15.14.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:48:19 -0800 (PST)
Message-ID: <61ba70b3.1c69fb81.fc96e.93ad@mx.google.com>
Date:   Wed, 15 Dec 2021 14:48:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-6-g76eaee78184e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 123 runs,
 1 regressions (v4.4.295-6-g76eaee78184e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 123 runs, 1 regressions (v4.4.295-6-g76eaee=
78184e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.295-6-g76eaee78184e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.295-6-g76eaee78184e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76eaee78184efdd97914cf0965b43dc28284f5a1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ba3903fce7cd871c39712a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
-6-g76eaee78184e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
-6-g76eaee78184e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ba3903fce7cd8=
71c39712d
        failing since 2 days (last pass: v4.4.294-28-g4af7e373e6fb, first f=
ail: v4.4.294-38-g597c1677683a)
        2 lines

    2021-12-15T18:50:22.972166  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-12-15T18:50:22.980898  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

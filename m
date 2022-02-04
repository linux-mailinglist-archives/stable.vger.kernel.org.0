Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8EB4A9D13
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 17:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiBDQkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 11:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiBDQkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 11:40:45 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2BFC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:40:44 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 192so5575131pfz.3
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 08:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=awq4yy77Q3ZlcCExRMn2vQnh+AU7BwCzq2gX7yfqhfw=;
        b=FGTwYD2gpZKa7VO6WfLu1oszimbAZI1OUIVjdqXdof0+iAKN/3J1ZyvODi8eIc1rQx
         Vjw3qLXQUHHl54gzuFeZ9bRwbHh/UWB9ecKGz4XRYEWFOt2ic8B6u4PvhF2ycXrxnAn/
         x2q1EyXqK2fDRdNGB2laZZEJ7AdTJJaW+QiXvHMSnR5zGcRPWRhzsGK5zMbX7IkUju7w
         LJ3CXVoyeoOQKN/QEBOTjEBOo+SqTiXYS8XZOB22H8z7JcvsD6XB5tAfBMkgOpmucKET
         Dt7wAFp61ODYrRyXpsntZ5tzTK1Y6U04lRhcWY+nM8PVTGckFsjfisUdoG0y258MY5XT
         cJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=awq4yy77Q3ZlcCExRMn2vQnh+AU7BwCzq2gX7yfqhfw=;
        b=hf/z4aMNQLQU3d5fYTlwAfC2LQzYSKAvpow7+23k57m+ks7N1j3H4wyTiTx8J5Qh9K
         7HKBKG6A5UTlWpwTxCIk0E/aTjCYDu8u04oBzMJDhg+/QWh3+ZpY2L1wPDb33jrCuCJc
         XGiuvC4Li3R7hncyznhAr7HccxZrv/O737Zige/bNbIlT8QWO55WYS6lWj6UUCsL/kWE
         LDdFSSNxepSgdSweiJgLn3bSVqYU6LwSE6B4M/qZGXVzWpLe9fyq4GhSwn/VB8chmDIa
         hlORoGWxb1c7JxdViRJfNj8r//yu+LPssUFxUVf7oUZ+IpNJb4hNsjANo50qbvbHTGhF
         p5xw==
X-Gm-Message-State: AOAM531KGbMNyZhe6T+lzzUvgB2z+bgYH7PXpb/lrRUXxiE+VF+z727a
        H0o/oeqZVJT7ef4mxaxuVia10hF9RldYNsQd
X-Google-Smtp-Source: ABdhPJw+IRm/de3yz53Fj9HpCcz4ljh+I0dk3GVsIBJvNOvv0S9CPzAcFRpZbCCTZQ3i7AMmI9pDww==
X-Received: by 2002:a63:81c8:: with SMTP id t191mr2928289pgd.223.1643992844151;
        Fri, 04 Feb 2022 08:40:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm24sm2648379pjb.20.2022.02.04.08.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 08:40:43 -0800 (PST)
Message-ID: <61fd570b.1c69fb81.edb24.6a7d@mx.google.com>
Date:   Fri, 04 Feb 2022 08:40:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-33-g5e40da2b7be3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 34 runs,
 1 regressions (v4.9.299-33-g5e40da2b7be3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 34 runs, 1 regressions (v4.9.299-33-g5e40da=
2b7be3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.299-33-g5e40da2b7be3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.299-33-g5e40da2b7be3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e40da2b7be397e37cce994c7b9ff7f5ef3f9f54 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fd25779658c580d45d6ee9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
-33-g5e40da2b7be3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
-33-g5e40da2b7be3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fd25779658c58=
0d45d6eef
        failing since 31 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-02-04T13:08:52.618085  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2022-02-04T13:08:52.627251  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431A14780FF
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 00:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhLPXyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 18:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhLPXyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 18:54:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D19C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 15:54:38 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id mj19so610698pjb.3
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 15:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S8YtplPn+cVlPtMD9VVfM2EK6bexkkqsEuRLxFEbHzw=;
        b=nSxFumXYkjrOgglmtHpLyiT3RcOKt7ZuFA4H2YUNr88m9x7Y92FWUYLF6iXHLeCp25
         BFCEE6nLfHmr3RSlWzuHv8VarIAo8Nvx7USOv8TtQ7oCKO2x9MRuq1yU1dubOW0knG5F
         Hu1uKaGJ+xrRgpqFOawLbuVUN9cbv5tZ9jQpNVMIb2l+6Zhc57IsX4PZiA3dDq5bYcUQ
         qT2sJcTJ8XSId5VtESGMX4/gvPa2MwS38+1mXN6DTUAz2dvEi0ZziPrHujH3IGAjgVLD
         95yQhsNP/8aRhRs7Mx8PYx0ZUQMP9JROmkgSQ/AAoshKK9c8YvkCwvMN0etQfGeIUYI2
         mA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S8YtplPn+cVlPtMD9VVfM2EK6bexkkqsEuRLxFEbHzw=;
        b=icpPXBniyQnLVe5JCkNs7+Ard9gv3D4ZVbizCZLQl2Yqt+iRsrbA7Pui76MJMj/9lG
         Q0DYoyUGVEqNO0Yvrykjv2oScoAMc8oeySorq6hmjmDfcLESAsx3hAVIYzvvj+eyPRVF
         39vFd93U5H6x+1E00ZSEMTLtGP4iuVrYkDzeE72jK/ENmUB4sZf0HLN7b4p3fwmzPfBJ
         Fsf47wqtNH8apZmzyLWM1CR9+NHCXNJ4kIDL+WaF8gAHT6GVGpH/QCaHkxj6ZhZ+uEQW
         qTrbmBymXEEqiPkI4p69as0zsbB/AorycKOgXV7EW0kMzN8Cb5QzToMUvYw1LymmKwDJ
         mETQ==
X-Gm-Message-State: AOAM533uNEuMVzMnFe7bA3AWd0ExKtfEsZglTBVa8Tr3TFT5H9buNSjw
        nXPWm+r14cWjKYB/MPKPo0zt0tyjFrY2grF3
X-Google-Smtp-Source: ABdhPJyBn0cjx1++I/7qlxyi6v479j9Q38VuIiFQn7LQT1pre17lJVBX8f6BwQtlw2QSnPhfj/7N9Q==
X-Received: by 2002:a17:90a:f682:: with SMTP id cl2mr608174pjb.124.1639698877436;
        Thu, 16 Dec 2021 15:54:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm6389619pga.80.2021.12.16.15.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 15:54:37 -0800 (PST)
Message-ID: <61bbd1bd.1c69fb81.96d8f.2080@mx.google.com>
Date:   Thu, 16 Dec 2021 15:54:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-5-g649b146b7173
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 2 regressions (v4.4.295-5-g649b146b7173)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 2 regressions (v4.4.295-5-g649b146b7=
173)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-5-g649b146b7173/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-5-g649b146b7173
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      649b146b71737631e1c9d66c02a1809be6ad9ce1 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bb9f96d6fae1862439714e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-g649b146b7173/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-g649b146b7173/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bb9f96d6fae18624397=
14f
        new failure (last pass: v4.4.295-4-g6f24489e6ad7) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61bba0c0e50904071139712c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-g649b146b7173/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-g649b146b7173/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bba0c0e509040=
71139712f
        new failure (last pass: v4.4.295-5-gf02062a2d548)
        2 lines

    2021-12-16T20:25:17.905774  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-12-16T20:25:17.915264  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-16T20:25:17.931360  [   19.381469] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

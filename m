Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F58440C83
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 03:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhJaCMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 22:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhJaCMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 22:12:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B365C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 19:09:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id om14so9847296pjb.5
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 19:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S6mymnjRP2uqjD2lbDNYi3Kxlmokn2CtIENTpGS5J5Y=;
        b=4cwjbUb88jz50TpRkNmFmDyfTCwnsnfYN/WlExm56t+hP9glewBvoUfDivUx4lFV5s
         iNOawCBgmWQBfo8tLPrGHcmUMc45OLiDI3S0ldFnuRUmWM80kBagKsFRLyOEOtUH/XVA
         KEhZWI6OPw9OGsMKN5yq2FGZqkakJtpmj2LjhzQScOJSofqHWM2MYWrtiLU888lf7ycV
         v/cS8mtVtYI3AB6YMPMCT3dGbq8spLkogTOs/s99fkkBLOnL+84qkh7wwPQNoY6kM2+7
         wLwJ0qP5pBlDAoOm5CwGea6PJ3w39YQcOxHo2w4j5l74tkgkHpuK0E5uJHnEmQ7L83v+
         Rlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S6mymnjRP2uqjD2lbDNYi3Kxlmokn2CtIENTpGS5J5Y=;
        b=3paMqYPg0UiZ4R7FVdJZYNFJ5i52X09qlee00gCWxF0kvOIy/76a2xI4hAq4GPLLb/
         fkQ5MbPtQGyjGHphq4x6Wmd5o2XjgSEO4c7jTxr1glwBjwuo+U+eQvIm9filLU6VotqL
         qijYWXeZ09BqdhRntWinvXuC3jwxI9DGCJDzX75Zb1p0s6Xp8hIyMOszlVG3bWoWLTiv
         ckyenvnwTgEWCuh9vHCAHT0m9RQDT4cCI5rwskr1wmcFKk+PBaUO1D6z7TNU2BwHgYru
         lDh2IY/+wmQkccabCWLoiekjy8MSe50haSCTGfQ5orEZkhKBEF/O5OQaDN0OEJbaLCCi
         DIZA==
X-Gm-Message-State: AOAM5324ubos7UKV7qj9XljIu2UJ4in9+hH5DXnwJMOFWmpbRsmACuuf
        LeTur3e0zKJQ3ZZPHdEyOXy4+rUhPrCyFamy
X-Google-Smtp-Source: ABdhPJxGw/mrYQu2m3imvCOx3pW1IkmvG21EXb23Ej1eZHuvxEWo+sVtR9Tr0yp3J10WoQCQAla5iw==
X-Received: by 2002:a17:90a:bd04:: with SMTP id y4mr20947778pjr.99.1635646178794;
        Sat, 30 Oct 2021 19:09:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11sm286612pfe.3.2021.10.30.19.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 19:09:38 -0700 (PDT)
Message-ID: <617dfae2.1c69fb81.d150f.154f@mx.google.com>
Date:   Sat, 30 Oct 2021 19:09:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.290-17-g18caef77d35b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 97 runs,
 3 regressions (v4.4.290-17-g18caef77d35b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 97 runs, 3 regressions (v4.4.290-17-g18caef77=
d35b)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.290-17-g18caef77d35b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.290-17-g18caef77d35b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18caef77d35bcc05a6e46084a584c82a1efb97bd =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/617dc31482717552173358ee

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g18caef77d35b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g18caef77d35b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/617dc31482717552=
173358f1
        new failure (last pass: v4.4.290-15-g2a82217a1115)
        1 lines

    2021-10-30T22:11:14.710057  / # #
    2021-10-30T22:11:14.710569  =

    2021-10-30T22:11:14.813174  / # #
    2021-10-30T22:11:14.813626  =

    2021-10-30T22:11:14.914850  / # #export SHELL=3D/bin/sh
    2021-10-30T22:11:14.915203  =

    2021-10-30T22:11:15.016307  / # export SHELL=3D/bin/sh. /lava-1006728/e=
nvironment
    2021-10-30T22:11:15.016588  =

    2021-10-30T22:11:15.117715  / # . /lava-1006728/environment/lava-100672=
8/bin/lava-test-runner /lava-1006728/0
    2021-10-30T22:11:15.118592   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617dc3148271755=
2173358f3
        new failure (last pass: v4.4.290-15-g2a82217a1115)
        29 lines

    2021-10-30T22:11:15.481295  [   49.342041] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-30T22:11:15.547657  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-30T22:11:15.553636  kern  :emerg : Process udevd (pid: 111, sta=
ck limit =3D 0xcb97e218)
    2021-10-30T22:11:15.558082  kern  :emerg : Stack: (0xcb97fcf8 to 0xcb98=
0000)
    2021-10-30T22:11:15.566087  kern  :emerg : fce0:                       =
                                bf02bdc4 60000113
    2021-10-30T22:11:15.574487  kern  :emerg : fd00: bf02bdc8 c06a350c 0000=
0001 00000000 bf010250 00000002 60000193 00000002   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/617dc2f750e68b9c5b33592b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g18caef77d35b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
7-g18caef77d35b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617dc2f750e68b9=
c5b33592e
        failing since 0 day (last pass: v4.4.290-9-g87e26bdcfc0f, first fai=
l: v4.4.290-15-g2a82217a1115)
        2 lines

    2021-10-30T22:10:41.514474  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-10-30T22:10:41.523588  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

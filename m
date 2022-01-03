Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F994838A5
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 22:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiACVsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 16:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiACVsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 16:48:15 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF4AC061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 13:48:15 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g2so31013245pgo.9
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 13:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=smwQ1Jdxph4oIwoW7HHpNeypXY53VzrSPrAUB7ODJqo=;
        b=R/fvH2RvndxdZjSQUUYafLkZxJ13yTSGB4jYU1QfkksDC5qGdaNP8ImBQGHID9pXvK
         hIw1ueGu5fsd8lRLVZohS2j7aEJ6pMM67wb96Fl0rZX5Nbd0AUgA+gQtPdgIB6NmHw6x
         adJTJVTWL3lqWSSmfbQ73fPvKRPTwwBksJULbLlnWBXNj2lfLpgAgMMhArfC9JqFoB2Y
         thJt3sAykckoaokE+zgP9F0ATk72umiEn423uNAEgNGMNhS6gQzeXm6IWk7ul63ZFaqb
         1uKEN7RGghNMqUOp0z+N6RM9EcY7TY2ny/Oi+Cfs5RYJsgl/dcvyj+lHJxe3KQCiIIs7
         dhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=smwQ1Jdxph4oIwoW7HHpNeypXY53VzrSPrAUB7ODJqo=;
        b=c3HPCpg8H3U9rDUnUi+t4mSmSw9da3B2qPu5f/AQPOT55wn+wQ8GNHpivhxJNBNb2+
         3EjUY+wIialLo7u45f7dhZOU/ygWq3SNszcu0z/sbvOB6Y1anBlsb+JUQ8/T97tvdyxC
         I2Q+D7A7O5irtzN9+FB6F9n8NPZ9wqgqA2xyFvbWDQwbakae/zYHWlWvSmKIhdO8KXRQ
         UYTf6O6LP5N3k2kHGwC+Acb1YODdGkOgLVk5/JMDWfJ7tDmwVxN6byfoZm2qIQIc1Xlg
         zydan2pLMCBcV8dLbxcDkJ7gCLjs0xLOeLeZWiw8ZyyHR76JQF6ynuk27Dq54qV2SXTR
         Zzkg==
X-Gm-Message-State: AOAM530/NRYUwQYaeiwer43Y+CA6lTQ6kfQPRlIomX7tcSS5ZLVQnNvr
        lnpsZd6x4D5sGXdG9Vv9RrF9FniVbTj/BuMG
X-Google-Smtp-Source: ABdhPJzqzjO41mlvyrOF6Y0vz//xBOEIvyzLD/93aSbSVmkBUclpJaOGh3rWtI/AUjtw8elpUlFyRw==
X-Received: by 2002:a63:b909:: with SMTP id z9mr42398486pge.26.1641246494346;
        Mon, 03 Jan 2022 13:48:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9sm26926955pfm.140.2022.01.03.13.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 13:48:14 -0800 (PST)
Message-ID: <61d36f1e.1c69fb81.a9513.7d35@mx.google.com>
Date:   Mon, 03 Jan 2022 13:48:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.89-49-g38b2ec850bfc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 182 runs,
 3 regressions (v5.10.89-49-g38b2ec850bfc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 182 runs, 3 regressions (v5.10.89-49-g38b2=
ec850bfc)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe   | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.89-49-g38b2ec850bfc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.89-49-g38b2ec850bfc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38b2ec850bfc4ecc2b202c3b232d5ac92bd4365e =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61d3385528c926d245ef6768

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
9-49-g38b2ec850bfc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
9-49-g38b2ec850bfc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61d3385528c926d=
245ef676c
        new failure (last pass: v5.10.89)
        4 lines

    2022-01-03T17:54:08.109157  kern  :alert : 8<--- cut here ---
    2022-01-03T17:54:08.109534  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2022-01-03T17:54:08.110043  kern  :alert : pgd =3D (ptrval)
    2022-01-03T17:54:08.110622  kern  :alert : [<8>[   11.037910] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2022-01-03T17:54:08.110877  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d3385528c926d=
245ef676d
        new failure (last pass: v5.10.89)
        26 lines

    2022-01-03T17:54:08.162349  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2022-01-03T17:54:08.162738  kern  :emerg : Process kworker/0:5 (pid: 55=
, stack limit =3D 0x(ptrval))
    2022-01-03T17:54:08.163267  kern  :emerg : Stack: (0xc2407eb0 to<8>[   =
11.085113] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2022-01-03T17:54:08.163528   0xc2408000)
    2022-01-03T17:54:08.163765  kern  :emerg : 7ea0<8>[   11.096314] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1343153_1.5.2.4.1>
    2022-01-03T17:54:08.163998  :                                     1e9b1=
0fe 4c9022c5 c22d049c cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe   | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61d33ddb682cf41030ef6741

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
9-49-g38b2ec850bfc/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
9-49-g38b2ec850bfc/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d33ddb682cf41030ef6=
742
        new failure (last pass: v5.10.88) =

 =20

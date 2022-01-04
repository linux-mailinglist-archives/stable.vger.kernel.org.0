Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AB1483AAF
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 03:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiADCt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 21:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiADCtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 21:49:25 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82697C061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 18:49:25 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id y9so2994237pgr.11
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 18:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M3nbtzXGXUOzjlkKuaV+gGqzjSB4dM+KZ+KzEmX2tuM=;
        b=L8o5EqoflSfl3FwhZf++WlZoNLKO/J1G0qLrXH4Eqpzl7cKPtiVVt2NvRGHj3IjUnj
         cPRiaoLoaDdRuRxHtx+XN6BroJFO3eTGDyfAwx7S65lPDkenRxFGmYy/UXvBJmRoUq43
         Jf+QWFXJteX8knP7XUXa8OXoQoY2SwoTkP67xYyCf65CnZZYb59ZPeiRaNGcmgNqFP+f
         CL5m+lzleQFztYG+OoJGtYjbiABK8aDxoEPJd6lW80ntwyDy/iFUEQ43ry+4fo2DiWXm
         z+hOI5fm5BHfvGCrZvIdAPdb8zwERzr2wUboL7Qbd7RSq7fK6KK02eJMG+fZLYzU2DWC
         eOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M3nbtzXGXUOzjlkKuaV+gGqzjSB4dM+KZ+KzEmX2tuM=;
        b=DvH/3o5wp0XdS0PPz89VKhimn08kC4CvyklAwU3BEZs8QM4705q4DJ3RLyuzCoxAfV
         g0s1DWAwYn2QLVmToMdEQfzDPvM4V/WLK0dBT8xqKbfLriUDk2ZbSLgH/B9y7aEHabfD
         9NNpPalJKD5HlxGB/ihZryy9v2Y8M4o/csF5LRaylIfZXYvzsNTi7A3f7Qd2Qq5nIPlJ
         FCr8knqTLidYu1z8kFD1uoQgXLII773JYVyNk4kqAZkFy+1jRtvsk4mKr3zfjJ9j4KeT
         xvA3+zdK2b4D3/yO+RE0sgkiQtJzaNIsBjWVnuPV2ThrC+C42pdUpF+gC9Y5qdfEhEWR
         rmNw==
X-Gm-Message-State: AOAM532AEI1baYwaAfqOjmtQE7mPzSzSxs70BUAWWsREDHj2nvgoxGpL
        06ncYYWFSypfd/0O+clWf5eB2wG0v1Rw/mb5
X-Google-Smtp-Source: ABdhPJwHvXKdpiOcfontL/DyOL2OcouBT19FoHNOXTrEWRDuK/1voSytv8z17w9jbilCCXdifVZE4g==
X-Received: by 2002:a62:1c12:0:b0:4bc:6d81:b402 with SMTP id c18-20020a621c12000000b004bc6d81b402mr17676554pfc.40.1641264564824;
        Mon, 03 Jan 2022 18:49:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b65sm38736964pfg.209.2022.01.03.18.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 18:49:24 -0800 (PST)
Message-ID: <61d3b5b4.1c69fb81.79317.8f9b@mx.google.com>
Date:   Mon, 03 Jan 2022 18:49:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-12-ga1c4d899b501
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 121 runs,
 3 regressions (v4.4.297-12-ga1c4d899b501)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 121 runs, 3 regressions (v4.4.297-12-ga1c4d=
899b501)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.297-12-ga1c4d899b501/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.297-12-ga1c4d899b501
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1c4d899b5013233346ba4f33d952c391f0fe7fb =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61d3842284dc4a09ddef6745

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-ga1c4d899b501/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-ga1c4d899b501/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61d3842284dc4a09=
ddef6748
        new failure (last pass: v4.4.297-12-g35b04967ef14)
        1 lines

    2022-01-03T23:17:37.200863  / #
    2022-01-03T23:17:37.201413   #
    2022-01-03T23:17:37.304127  / # #
    2022-01-03T23:17:37.304699  =

    2022-01-03T23:17:37.406005  / # #export SHELL=3D/bin/sh
    2022-01-03T23:17:37.406295  =

    2022-01-03T23:17:37.507415  / # export SHELL=3D/bin/sh. /lava-1343950/e=
nvironment
    2022-01-03T23:17:37.507712  =

    2022-01-03T23:17:37.608837  / # . /lava-1343950/environment/lava-134395=
0/bin/lava-test-runner /lava-1343950/0
    2022-01-03T23:17:37.609680   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d3842284dc4a0=
9ddef674a
        new failure (last pass: v4.4.297-12-g35b04967ef14)
        29 lines

    2022-01-03T23:17:38.125273  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-03T23:17:38.131359  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb93e218)
    2022-01-03T23:17:38.135522  kern  :emerg : Stack: (0xcb93fcf8 to 0xcb94=
0000)
    2022-01-03T23:17:38.143689  kern  :emerg : fce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d3841a1925b48f71ef6746

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-ga1c4d899b501/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-ga1c4d899b501/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d3841a1925b48=
f71ef6749
        failing since 4 days (last pass: v4.4.296-18-gea28db322a98, first f=
ail: v4.4.297)
        2 lines

    2022-01-03T23:17:27.779329  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-03T23:17:27.788673  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

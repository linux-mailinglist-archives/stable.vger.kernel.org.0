Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F333766DA8C
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbjAQKE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbjAQKE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:04:58 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22572CC49
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 02:04:57 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y1so33020359plb.2
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 02:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RSWV/L0/Cbsu8Gh9YS47+Vo/Fi70nxDixuKcnMd8vX8=;
        b=c2CRQcc4m5AjsDWFTwm7g71AfFpa20WpFwrlfYPMlnKITzHzl178nwpdisPVjUhYf6
         m656F4UADn39WllqNdhJZvd4QcYSg7xM/ODF29Ksc7WGgm9+O8Bfaag5xKuGiNqTNGtV
         yMsqU88hSre7JzHbtSBnQlyo7UGtR+AuC3oArof8ZSS9Wfchp38nznu9Jv72+4ArRila
         lQkWiWgicGWVRdOaH8YF/oJe+rULDOLWtDubORnQJNw86nB89MUIXXE9Xvw0BSflIFHl
         rSN0loJ6opxcu9GQo+t98mKaDZD5A2tBLSJGFFf/rMUcOHTaxQLYqFbOLCiWwjZiasSA
         W3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSWV/L0/Cbsu8Gh9YS47+Vo/Fi70nxDixuKcnMd8vX8=;
        b=VO+YpVeWO4KiPkyT4EzHilSvuEP6aQY6eNdg9aaOnYPMsVQTaOlYcT81Wq8CJxIf/G
         z+NkiBUwqfrFeyHbKuRCZaWXDCPb556MrZA+QLbkuBf1IrJNa5PcnnyVnzo6a9u58Tb1
         T8/DO/tjZJk0GMzsUGIGeZbc98vr/8YchI8VZYEaoSQMwztGPdXIe50Z4Zj5EXg7OICu
         P+X6nQTodkm+CLHIMbXdmbRlGj9ur+r6T0kO/vNm5QdjGu/RUfVCIkYIn2ji5xPkAE1B
         3t3Ji7MRQg7r1tTT2NahA9rtQL1/akvSlI0qunY3rTXRrdl5C8blsbrEdAqXISy5P43F
         yQEg==
X-Gm-Message-State: AFqh2kqENy9kTQN90v769wK57ARVFwAvBoeH4FnSY8cKbzM2X7/8g8z3
        s1Bm1sLocW2yJlfFh2VgKX4zg0gfFzb5QdPNhxqhgA==
X-Google-Smtp-Source: AMrXdXszIjT69Q9lA9KEo6MsnBjVePsKC7Y6NrHP7R5R52bRBOfMd1dFSNW5bxUpcDbEEXhbv7jx8A==
X-Received: by 2002:a05:6a20:1710:b0:b8:499d:7c99 with SMTP id bn16-20020a056a20171000b000b8499d7c99mr2282239pzb.0.1673949896939;
        Tue, 17 Jan 2023 02:04:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6-20020a63dc06000000b0043c732e1536sm17165965pgg.45.2023.01.17.02.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:04:56 -0800 (PST)
Message-ID: <63c672c8.630a0220.be5ef.abd6@mx.google.com>
Date:   Tue, 17 Jan 2023 02:04:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.87-101-g5bcc318cb4cd
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 182 runs,
 2 regressions (v5.15.87-101-g5bcc318cb4cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 182 runs, 2 regressions (v5.15.87-101-g5bc=
c318cb4cd)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =

cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.87-101-g5bcc318cb4cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.87-101-g5bcc318cb4cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bcc318cb4cd6b13569afdfc6d7b5c8c1f408f06 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63c640aa792dfc2e21915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-g5bcc318cb4cd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-g5bcc318cb4cd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c640aa792dfc2e21915=
ebc
        failing since 249 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63c6418753c56497a8915eca

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-g5bcc318cb4cd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-g5bcc318cb4cd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c6418753c56497a8915ecf
        new failure (last pass: v5.15.82-124-gd731c63c25d1)

    2023-01-17T06:34:32.954603  <8>[    9.937952] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3142133_1.5.2.4.1>
    2023-01-17T06:34:33.064025  / # #
    2023-01-17T06:34:33.167491  export SHELL=3D/bin/sh
    2023-01-17T06:34:33.168666  #
    2023-01-17T06:34:33.270818  / # export SHELL=3D/bin/sh. /lava-3142133/e=
nvironment
    2023-01-17T06:34:33.271925  =

    2023-01-17T06:34:33.374235  / # . /lava-3142133/environment/lava-314213=
3/bin/lava-test-runner /lava-3142133/1
    2023-01-17T06:34:33.376012  =

    2023-01-17T06:34:33.380589  / # /lava-3142133/bin/lava-test-runner /lav=
a-3142133/1
    2023-01-17T06:34:33.448400  <3>[   10.433625] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =20

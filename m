Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C609B4312E9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhJRJOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbhJRJOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 05:14:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C486C061765
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 02:11:57 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id i76so12083898pfe.13
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 02:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=65XlvrjT3kqu1mMZ7NJKRZtt5qFbdHyma/4tyP27bo4=;
        b=b0cxMGaIkCyWlshXYypqwrh0YjZKfsT+TIdbZvxyOLm1wOi6KWf+QCTVlIVGBw8AGm
         hPsS/yHad53FVWCX2xcDClPK2jeu9JmzCRgqcnAID+a5s3UImVmNVxSagP6dX4uUYpMx
         43mIjXIfsXZ0/+6qDdKiJglWYMBTEnnUoeM8M8qGgUzgpebG+K66JQgVQsb5e3NemXVw
         0p3Ec2Y1zyapswdlxXrqVR8fn0C1OJ1//sKIsnXkAwDICRigSUT7ADvJAF4ftIHQBAoR
         CAFCqyrf+8JrUAu22V+I81l30rxdwc5hLc0bGOqElL0n3UVA9USbTBNZNhweZkn8MATT
         iYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=65XlvrjT3kqu1mMZ7NJKRZtt5qFbdHyma/4tyP27bo4=;
        b=Noc+ciewG5LUD/a1C/vEP9VO3Am7ge5iBxApLU5g6Qo9SiRAd5MZvjEir7cySBQfDa
         aoO6g18nd02nFtPHRjRPwUWAV+GPUIViQuEunIQZfGOVN7fmBp6ODUhrQcjWPZP5XAWM
         kJj6hnmIX36LVCJGpHq9Km7FOyZdFLk6Y+WUCtF7wsFZpapKkv3azYOl5OtIfpm8WDQy
         D8V5ne5tjSrHo00j3i63Rm7E5ew8w845vO5Z4DQq0uRH7yRAb2r0xRnd3ZoIW+xZB+rK
         GfTifSuKVleyIDNOmgnKFNDrIyzT80VSLE6fdrUdzuTCQmX5o5yoOmStkf1b0ckZhVPY
         Cc2g==
X-Gm-Message-State: AOAM532M7s8CVIxit1RvN2tUQzm1Q2OgaELXtyCGDSpXotoZaD+/ejst
        TGTNUE72qMgV57ealHuxVTlYtSbrVKPY5g==
X-Google-Smtp-Source: ABdhPJzRPr9lj0p2mEwh6+9G0GzvpSfUEFfL+2YLzU7IxJIpbBmGVpKc9l2aw87ry9yShSLs0KG2JQ==
X-Received: by 2002:a62:2982:0:b0:44c:f2a3:ec62 with SMTP id p124-20020a622982000000b0044cf2a3ec62mr27536872pfp.23.1634548316500;
        Mon, 18 Oct 2021 02:11:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f84sm12496405pfa.25.2021.10.18.02.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:11:55 -0700 (PDT)
Message-ID: <616d3a5b.1c69fb81.66327.30e9@mx.google.com>
Date:   Mon, 18 Oct 2021 02:11:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.288-22-ga0cc68e7856a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 41 runs,
 3 regressions (v4.4.288-22-ga0cc68e7856a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 41 runs, 3 regressions (v4.4.288-22-ga0cc68=
e7856a)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =

qemu_i386 | i386 | lab-broonie  | gcc-8    | i386_defconfig      | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.288-22-ga0cc68e7856a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.288-22-ga0cc68e7856a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0cc68e7856a17b196b58722615d0a138dc1d91a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/616d00a5b8f0e12d203358f7

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-22-ga0cc68e7856a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-22-ga0cc68e7856a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/616d00a5b8f0e12d=
203358fa
        failing since 3 days (last pass: v4.4.288-19-g46f1e1a33c90, first f=
ail: v4.4.288-19-gf9c6c370e0b0)
        1 lines

    2021-10-18T05:05:24.875135  /
    2021-10-18T05:05:24.979105   # #
    2021-10-18T05:05:24.979888  =

    2021-10-18T05:05:25.081452  / # #export SHELL=3D/bin/sh
    2021-10-18T05:05:25.081915  =

    2021-10-18T05:05:25.183150  / # export SHELL=3D/bin/sh. /lava-952051/en=
vironment
    2021-10-18T05:05:25.183632  =

    2021-10-18T05:05:25.285011  / # . /lava-952051/environment/lava-952051/=
bin/lava-test-runner /lava-952051/0
    2021-10-18T05:05:25.286346  =

    2021-10-18T05:05:25.287294  / # /lava-952051/bin/lava-test-runner /lava=
-952051/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616d00a5b8f0e12=
d203358fc
        failing since 3 days (last pass: v4.4.288-19-g46f1e1a33c90, first f=
ail: v4.4.288-19-gf9c6c370e0b0)
        28 lines

    2021-10-18T05:05:25.801315  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-18T05:05:25.807126  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb930218)
    2021-10-18T05:05:25.811603  kern  :emerg : Stack: (0xcb931d10 to 0xcb93=
2000)
    2021-10-18T05:05:25.819697  kern  :emerg : 1d00:                       =
              bf02b83c bf010b84 cb9d4e10 bf02b8c8
    2021-10-18T05:05:25.832806  kern  :emerg : 1d20: cb9d4e10 bf2310a8 0000=
0002 cb[   50.015838] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
qemu_i386 | i386 | lab-broonie  | gcc-8    | i386_defconfig      | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616d052d0e47ccfba73358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-22-ga0cc68e7856a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-22-ga0cc68e7856a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d052d0e47ccfba7335=
8e7
        new failure (last pass: v4.4.288-19-gf9c6c370e0b0) =

 =20

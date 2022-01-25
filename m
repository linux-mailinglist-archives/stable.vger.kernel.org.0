Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9311749B56C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 14:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386093AbiAYNzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 08:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386644AbiAYNxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 08:53:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A898C061757
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 05:53:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso2114235pjv.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 05:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zkOywRL/GDCym76hLrtUGmFThn1skEtio3oBPDy7hG0=;
        b=nnk7VnWjEFWvo2KGSz6IXOCkaLv1DD2XPoZkqabxCJdwkYopkGwn5/MUaWF/V2OC+R
         Y0x4kou6xgCIZJAXOdll2W2abEn9ZsKoDu6Lx+rF4hIWLigM/waT49kzZ33DFa7zeLdH
         ARwrRpOcBL8nhBmIj+5NWFwV3ZjHZhrX9gp7QvNLNagJWxOl5RcjRlmixTYn6cN4pig8
         J63ZD4LSpRVfylI9anK/D9PdIMAw58QUqd1DKI3V9PggYaYc9mC/YPbCXcde2roAcaLx
         Fk6sUzz6nxWI625MwxAlAAH9kxZS58n5kbnhqFurPezxtGT+zqBT0FAI3k19UGJdt8Cy
         uXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zkOywRL/GDCym76hLrtUGmFThn1skEtio3oBPDy7hG0=;
        b=QuCZaUg2B/OG/53FPWJ1KZp/MWOmkOPadm/XIrSxt24ilv+833ippbChiYKA5lf2zP
         imDqJVPApy7ZWMzp747aVDKCuGrkTUfF7pRrk24YCgIA/k7ojyylymFU/kQJKJ8C83uH
         NpsolDkaqpTQyMU5FzVElzFuCZ3nGT6TBfYswzvNXRNlPSZYCd+lKdyhRgWZZJ6wESGs
         Yg0+vg9JgmrDtjRWCOYJURD6n+4Ra7qBwf++4qny71AYX2C+B4DqvU12RAEtF+fRiJcU
         +0oWRRsjoVQZJ2aZ860trL8ux71SF5Vve4FOSQEhUZSBIjnwusQNJ7CitY6VnVi17egD
         LQrw==
X-Gm-Message-State: AOAM531fONPBeCzWYEVt160+5PG+0qHLhmCdMbNiS0U2SctzjCbgFIC2
        UEtVl96cVUmPAl0PTMVTe7LXV+Dw88GWoVmX
X-Google-Smtp-Source: ABdhPJxF6y3BDxbXV/uCrZN0S35nFiY5M9qMjvfvkOK5kb/VOKSScZNdQYwPcrh9K9Nk+/odcHj8Gg==
X-Received: by 2002:a17:902:e74e:b0:14b:1100:aebc with SMTP id p14-20020a170902e74e00b0014b1100aebcmr18774756plf.133.1643118787453;
        Tue, 25 Jan 2022 05:53:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p22sm6920079pfo.163.2022.01.25.05.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 05:53:07 -0800 (PST)
Message-ID: <61f000c3.1c69fb81.47b59.0e13@mx.google.com>
Date:   Tue, 25 Jan 2022 05:53:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-114-gf17c34b78a00
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 84 runs,
 3 regressions (v4.4.299-114-gf17c34b78a00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 84 runs, 3 regressions (v4.4.299-114-gf17c34b=
78a00)

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
el/v4.4.299-114-gf17c34b78a00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-114-gf17c34b78a00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f17c34b78a0083682f13ccccf27ed1bfc58f5695 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61efc82ac047d16993abbd16

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
14-gf17c34b78a00/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
14-gf17c34b78a00/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61efc82ac047d169=
93abbd1c
        new failure (last pass: v4.4.299-114-gf2a0d44e5c7a)
        1 lines

    2022-01-25T09:51:20.725345  / # =

    2022-01-25T09:51:20.835178  #
    2022-01-25T09:51:20.837337  =

    2022-01-25T09:51:20.940545  / # #export SHELL=3D/bin/sh
    2022-01-25T09:51:20.941811  =

    2022-01-25T09:51:21.044131  / # export SHELL=3D/bin/sh. /lava-1445360/e=
nvironment
    2022-01-25T09:51:21.045528  =

    2022-01-25T09:51:21.147957  / # . /lava-1445360/environment/lava-144536=
0/bin/lava-test-runner /lava-1445360/0
    2022-01-25T09:51:21.151077  =

    2022-01-25T09:51:21.152085  / # /lava-1445360/bin/lava-test-runner /lav=
a-1445360/0 =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61efc82ac047d16=
993abbd1e
        new failure (last pass: v4.4.299-114-gf2a0d44e5c7a)
        29 lines

    2022-01-25T09:51:21.642755  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-25T09:51:21.648188  kern  :emerg : Process udevd (pid: 111, sta=
ck limit =3D 0xcb98c218)
    2022-01-25T09:51:21.652656  kern  :emerg : Stack: (0xcb98dcf8 to 0xcb98=
e000)
    2022-01-25T09:51:21.661023  kern  :emerg : dce0:                       =
                                bf02bdc4 60000013
    2022-01-25T09:51:21.674009  kern  :emerg : dd00: bf02bdc8 c06a3d14 0000=
0001 00[   49.496276] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61efc8259ceddf09faabbd35

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
14-gf17c34b78a00/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
14-gf17c34b78a00/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61efc8259ceddf0=
9faabbd3b
        new failure (last pass: v4.4.299-114-gf2a0d44e5c7a)
        2 lines

    2022-01-25T09:51:14.051898  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2022-01-25T09:51:14.061038  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF63306D3
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 05:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhCHEZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 23:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhCHEZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 23:25:19 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10E4C06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 20:25:19 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id x29so5614253pgk.6
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 20:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QHA/kDUmgD8KRuuXJhm0a6QebFqy8bLuBpWoqpZaFAs=;
        b=E4GgPKEe/hIeq+Rk6kr5Yr8iCJMWH+lwsWCuQvPSXSY05xs5kkBgGTVd4NOd2VVw/w
         U8Lw3osCPmYi4ELlzvqmYI6HWTvo/iSzmeT4ons8LUykHs/B83l+oIaq1usZ5rgFvxpA
         0t65A1HGFGHsdQYNrmF25wtCoujxCgWHGx68hkJbtMSFZltrVKQ3RqEJE3cOjIEPcPn/
         z23WMhMGmzBlDRS9vxxslhXVWcpcuyHyx6E0YucNqdQUX/4DV59ld1hmJssL4+l19MSl
         ykUDJ3uoCehxYh7RZcApwTaqR2AOCaLghJZTzKmYr57kYzCx8vSbOnrD4tJfK1uGrxeI
         EbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QHA/kDUmgD8KRuuXJhm0a6QebFqy8bLuBpWoqpZaFAs=;
        b=EScaDN4xLpMicpqv5TULxIvZxa+NG/kYDYyBYjtTHFN6N3ewF+Tj9gLcWOoCpvXRxw
         /5+uIE9RzXudjiYupXsrT3OIT8QWFz3d2uTv0tbtFhs/aP1Swwgrz2nSht6fXfu6Jj6q
         06ZUivcXns6E5Vg3Iil3Ps2z3HNJnv/9chfq8y1445S2HALvKxCmGCrAjOJqauncxFWt
         scXswvCML/gcPh3EVyK5D+vzSZvtufDNhAJv6J6d5S+vtdIfBv6IsSQSvlxaAWbwHc4G
         p8xQLuDPx3XLCwCyvjkUGBb/auVzmHc4AV5za9NbfTBvwxuy1DRH+A1TsEpB+JeG1IoJ
         gXDQ==
X-Gm-Message-State: AOAM530TM6lWPIizpPI/qlT6k2UVthQ+NXNNAKZ+Ki1ofuONAVa37Joo
        PgM0/ZJiCM0aFCikm5sIT/XdIK6D3NUCZA==
X-Google-Smtp-Source: ABdhPJwjhXfIbD0uwdOqNMXCd6vyF+IQL+8wD/8cpEg2oj47F5hRwrDxWN/ZfJ8F2Zb4so39W4rkjA==
X-Received: by 2002:a63:368b:: with SMTP id d133mr19234492pga.88.1615177517614;
        Sun, 07 Mar 2021 20:25:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7sm8733508pji.25.2021.03.07.20.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 20:25:17 -0800 (PST)
Message-ID: <6045a72d.1c69fb81.19ac.6671@mx.google.com>
Date:   Sun, 07 Mar 2021 20:25:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-139-g399d512602cb1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 2 regressions (v5.10.20-139-g399d512602cb1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 171 runs, 2 regressions (v5.10.20-139-g399d5=
12602cb1)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-139-g399d512602cb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-139-g399d512602cb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      399d512602cb11f2c5636b0c9218cad1f9d20009 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/604578f579fb643de5addcbf

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
139-g399d512602cb1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
139-g399d512602cb1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/604578f579fb643=
de5addcc3
        new failure (last pass: v5.10.20-131-gc7f3b8dd767e)
        4 lines

    2021-03-08 01:07:51.180000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-03-08 01:07:51.180000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.689952] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-03-08 01:07:51.181000+00:00  =

    2021-03-08 01:07:51.181000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604578f579fb643=
de5addcc4
        new failure (last pass: v5.10.20-131-gc7f3b8dd767e)
        47 lines

    2021-03-08 01:07:51.232000+00:00  kern  :emerg : Process kworker/3:1 (p=
id: 53, stack limit =3D 0x(ptrval))
    2021-03-08 01:07:51.233000+00:00  kern  :emerg : Stack: (0xc2443d58 to =
0xc2444000)
    2021-03-08 01:07:51.233000+00:00  kern  :emerg : 3d40:                 =
                                      c36835b0 c36835b4
    2021-03-08 01:07:51.233000+00:00  kern  :emerg : 3d60: c3683400 c368341=
4 c1449398 c09bf1a4 c2442000 ef86c320 c09c0564 c3683400
    2021-03-08 01:07:51.234000+00:00  kern  :emerg : 3d80: 000002f3 0000000=
c c19c7724 c2001d80 c3a1ac00 ef86c340 c09cc8fc c1449398
    2021-03-08 01:07:51.275000+00:00  kern  :emerg : 3da0: c19c7708 3d5adbd=
f c19c7724 c3a19540 c323be00 c3683400 c3683414 c1449398
    2021-03-08 01:07:51.276000+00:00  kern  :emerg : 3dc0: c19c7708 0000000=
c c19c7724 c09cc8cc c14470c0 00000000 c368340c c3683400
    2021-03-08 01:07:51.276000+00:00  kern  :emerg : 3de0: fffffdfb c22d8c1=
0 c3b15840 c09a27f4 c3683400 bf026000 fffffdfb bf022138
    2021-03-08 01:07:51.276000+00:00  kern  :emerg : 3e00: c3a16bc0 c3b8590=
8 00000120 c3b099c0 c3b15840 c09fc328 c3a16bc0 c3a16bc0
    2021-03-08 01:07:51.277000+00:00  kern  :emerg : 3e20: 00000040 c3a16bc=
0 c3b15840 00000000 c19c771c bf067084 bf068014 00000018 =

    ... (33 line(s) more)  =

 =20

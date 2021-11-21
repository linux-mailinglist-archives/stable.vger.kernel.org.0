Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE63E458621
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 20:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbhKUTXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 14:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhKUTXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 14:23:30 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F860C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 11:20:25 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b68so14124562pfg.11
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 11:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OXrmha4g5Pt/vJHRDCgkVmnWI3CQRTPGixFSGLUX9PM=;
        b=uXjeihPfFEon0kEBmp2iNr8pvCIEVX3NJhEAfAV9pFNRKz49X5vSsAW+sx77quPjqR
         FNbJC3pzAYKkfp8bAr1nDk49BdxDGc0v9xyI1NMMnbEqtOPEyr6q15QE+l1VQ+oL5TUp
         b0JjAhUvbgQCZyDjPXX4sopOLU8n97Zg41ItxGOo5GZVFT3IfLzv9FeupgV/7KUH5d04
         JYAj3I/o2RAbk7jPuCUN0JRdJS9duK08nq+1B1cd8vRCCOxwMsInViC9w3P5KPupCnhl
         Decvavan5gfN6HqgfyuNV0cAiuxyIYt9HYgkNNfKx/gRSynWhszwCkB1h0XLSSzt6IZM
         CApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OXrmha4g5Pt/vJHRDCgkVmnWI3CQRTPGixFSGLUX9PM=;
        b=ee0ku3/mDT20Mkho1SR6FzFoOtwgLtVlBUY1YSOq6KiSM3/s75gVpgbRdpbiOPg6co
         Q92/gDVneRbQuyflslqQuYwnqURrWgbyVox5RFnorDIvDrnjuHFHXGc1fkMshGeIksa3
         NBTaafHV+VcnRAe7KgvwioYBsxrgJyHysgvU1bU88z4pkO7jToVmIUawzpbtUoaLINiU
         8mljYYVVcWR4gWNUyf8UqQefzi402IEnz8m0CU6vfigfkUhUgJnPGSRugkapUYLUDWNr
         P1fc7LFFwMybkEQonLCY3Kc28zGtiU4c4MHi/3zHDua8Izywu1baha9c5b/vjpOOBPAx
         0x2g==
X-Gm-Message-State: AOAM532j+lXBYlPbv1zX4TwLZb0mN+hsyNWDSN4xMJjs3OexhrY7MPlb
        nI1wTOI3JesSDBMI64HvGM2qssRdKujwhrmd
X-Google-Smtp-Source: ABdhPJzWvsn7pncYBQU/MCcoI/+tXilk15GJpsSZpVKSJNP2KcQk1DuXMQcFFEYNWWCWcoBld/rDSw==
X-Received: by 2002:a65:6411:: with SMTP id a17mr30103493pgv.54.1637522424994;
        Sun, 21 Nov 2021 11:20:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm6426706pfl.138.2021.11.21.11.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 11:20:24 -0800 (PST)
Message-ID: <619a9bf8.1c69fb81.378d2.2de5@mx.google.com>
Date:   Sun, 21 Nov 2021 11:20:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.81
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 190 runs, 2 regressions (v5.10.81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 190 runs, 2 regressions (v5.10.81)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.81/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      99957dcea4e9702cc9060f576233ac1ac84c2a39 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/619a640882f6b45503e551e1

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.81/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.81/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/619a640882f6b45=
503e551e8
        new failure (last pass: v5.10.80)
        4 lines

    2021-11-21T15:21:27.689354  kern  :alert : 8<--- cut here ---
    2021-11-21T15:21:27.725530  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-11-21T15:21:27.726706  kern  :alert : pgd =3D eb4e3c0d<8>[   11.19=
1245] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-11-21T15:21:27.726979  =

    2021-11-21T15:21:27.727209  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619a640882f6b45=
503e551e9
        new failure (last pass: v5.10.80)
        46 lines

    2021-11-21T15:21:27.775071  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-11-21T15:21:27.775589  kern  :emerg : Process kworker/1:1 (pid: 57=
, stack limit =3D 0x3252c465)
    2021-11-21T15:21:27.775826  kern  :emerg : Stack: (0xc2461d68 to 0xc246=
2000)
    2021-11-21T15:21:27.776042  kern  :emerg : 1d60:                   c3c7=
69b0 c3c769b4 c3c76800 c3c76800 c14459d4 c09e310c
    2021-11-21T15:21:27.776254  kern  :emerg : 1d80: c2460000 c14459d4 0000=
000c c3c76800 000002f3 c39f5f80 c2001d80 ef86bea0
    2021-11-21T15:21:27.776920  kern  :emerg : 1da0: c09f085c c14459d4 0000=
000c c328a740 c19c7a10 df7861eb 00000001 c3de5fc0
    2021-11-21T15:21:27.818151  kern  :emerg : 1dc0: c39f1000 c3c76800 c3c7=
6814 c14459d4 0000000c c328a740 c19c7a10 c09f0830
    2021-11-21T15:21:27.818686  kern  :emerg : 1de0: c14436f8 00000000 c3c7=
6800 fffffdfb bf0f8000 c22d8c10 00000120 c09c6828
    2021-11-21T15:21:27.818993  kern  :emerg : 1e00: c3c76800 bf0f4120 c3de=
5040 c39aed08 c3a3c840 c19c7a2c 00000120 c0a23200
    2021-11-21T15:21:27.819228  kern  :emerg : 1e20: c3de5040 c3de5040 c223=
2c00 c3a3c840 00000000 c3de5040 c19c7a24 bf1560a8 =

    ... (37 line(s) more)  =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D41848307F
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 12:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiACL24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 06:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiACL24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 06:28:56 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A66C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 03:28:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id u20so29156972pfi.12
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 03:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ofy3yhX/UnUsIeU/M9nMACAwL/SESleR563sISCSL28=;
        b=ltlu2m/E/PPJH0ExmM7BNkQLYP0ODCs9IJyQtceH6Nyjv3+xy9gLVqjF49b/Ac42um
         HEP17lMYDAcyPUtk0+Z42r2JJ4DG2wBhqgaz2P//2HHczI8Fns6clpgcniPS0Z5LybxW
         6Fo+rI0nqYpuRs5pttg+M16RFDgBLYWPY8UL7zbfHSwQjyjWAg+WSbVlCME8/fwdeT3o
         p8BOZ/FsEyfBtzi4HnewOPjznWD+E6Wd8vz0ApM+pOktvNneFsg56ONKpcg5fVBXyRrR
         v18OOS9VXnzFjG9qxMtWnv+vAb9O/B0hBJ1yQ0r4Vszrs4Y6uBOpzAuD0xo/U3UEXG8y
         f0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ofy3yhX/UnUsIeU/M9nMACAwL/SESleR563sISCSL28=;
        b=FSwFpSYPMR2SxCB1uimRiUEJSVaE2EGkRbWo1SRkkHvkIxzablSHfHkFHx7BcKMo/V
         CYnqDD1fbKVJKBEb9UApljSocBICXcghDXyyq+mnuBD3vdMqxos21lIQZK3Jl69CuXgr
         1syTmzaqr0a4UF+WIfb5n86xpDwTAVPo/WLRrMKoZ36eYtZ6wUrCyfJPlJP0kv1LSRK+
         n+bjWZFcdv8IZzhOiCU2KxUPkuUFUhaeSv4SsR+EbPIhDDhPD1Np7VSjiXb8QpKa+8+n
         6VcQYHeQAtJUMWUZ3TATyHd+wTEH1A0ajY2L1Zs4Jgi/R4JkZIqTqURTOB3r4/XsRdEb
         VvbQ==
X-Gm-Message-State: AOAM532M9v5ylBAmRxBl7GWs5/QJNmVqFlO0ym2QRHlTteFMGJ7MgY0o
        hZ5kSOy/YcCoAIMYnqPidnOnedAlX1HVOo93
X-Google-Smtp-Source: ABdhPJwW/Wpk4sk7E22PoNgIJ439kx82R7LKuiAo+S4JKivHFfvC7W1jjXf2pBmTnajFPWytJyybOw==
X-Received: by 2002:a65:6aa7:: with SMTP id x7mr2356020pgu.273.1641209335241;
        Mon, 03 Jan 2022 03:28:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm31682253pgq.54.2022.01.03.03.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 03:28:54 -0800 (PST)
Message-ID: <61d2ddf6.1c69fb81.c525.7285@mx.google.com>
Date:   Mon, 03 Jan 2022 03:28:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-9-g3c1660c653ab
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 144 runs,
 1 regressions (v4.14.260-9-g3c1660c653ab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 144 runs, 1 regressions (v4.14.260-9-g3c1660=
c653ab)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.260-9-g3c1660c653ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.260-9-g3c1660c653ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c1660c653ab5dbf9b9855b4ae7826d978a59974 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2a9874d9acd3177ef6775

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-9-g3c1660c653ab/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-9-g3c1660c653ab/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2a9874d9acd3=
177ef6778
        failing since 0 day (last pass: v4.14.260-5-g5ba2b1f2b4df, first fa=
il: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-03T07:44:53.595923  [   20.141967] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T07:44:53.638605  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2022-01-03T07:44:53.648150  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

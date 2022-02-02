Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF064A6AA2
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 04:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243201AbiBBDqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 22:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiBBDqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 22:46:37 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5492C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 19:46:37 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i30so17668117pfk.8
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 19:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iUUeW23YODmJpBk4BjNN6UgHISatE0OsgPVAn7YZydc=;
        b=aRHv+kGQPdzjDCwG97Zzk629hyL04FH3JYkfC5CjdXtCpzA0HbjrDAAiqu9+uIuSv5
         qICosjdz31pT6hNyQNSfYA3zGx594Gjb3tOAp91m3CLS+mF18xKHYVlTuffV5x8Porgg
         t4EtGFBzMq625m7SKuW/ScW24dkTKxPeX98FDlL5IwSkM0nI2qR3NKzTeOMEbOMQjX3h
         aVbTtsaJjupXcKvv0DxGoCp10+/psbZgZ9nHI0gAvjgWYQsuEZ857d8QfELMccOLDiVx
         RCI5SGD8jsEdeEjTH9gfKJMVFuWHTWo8v9pDdOQLgCAvbkhi9d28P1KxZCcgcdn6r+Ht
         mm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iUUeW23YODmJpBk4BjNN6UgHISatE0OsgPVAn7YZydc=;
        b=QwN4zqRxigdwHKX5JwGLdHdHJ4f68oAuBFlwEhCpARBTap81IrU6MY3Nd5LuJBQUO1
         DaPCL4y9JYcRDlwvWrHKXUVola7B29BIydhcOrX5V8+Pj52/oU6uGPjDZBzPUpN7osO+
         Ml0E9t+gyzG0DXqD4cmbPefAJ5yMYuQWe80kqEpkfwBLbEH4ou0U1DNK2d7DSpFmoD3h
         WaWnP2/xFY9ZExvXaElEqiUPoqoZPhg+iONi5nB9KBts0cGTQ//FVBN7oDlTnmkCWoo/
         SsREXnVdfXLCLFsGsMLY4SUUa2kESojCMhrTH54cK/k59mn7RdsQmqDNkkPxkMvaOOUI
         U78g==
X-Gm-Message-State: AOAM530fR+I4dpF2xHvGnJbySjaYCygy+reUzZsjQPmA5KtDFz2wmBE4
        ind5OSjC09vQsMUPTTPScB2h8SbjkRzupoUe
X-Google-Smtp-Source: ABdhPJzPtVOjeXCm8Ne7S1+MyaQC/6lIglePaLSTUPl4X3uHVQJbcfij63goa7tquiUrS4wuPJqy+A==
X-Received: by 2002:a05:6a00:80d:: with SMTP id m13mr28122802pfk.48.1643773597018;
        Tue, 01 Feb 2022 19:46:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3sm22449496pfu.84.2022.02.01.19.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 19:46:36 -0800 (PST)
Message-ID: <61f9fe9c.1c69fb81.9c829.cb58@mx.google.com>
Date:   Tue, 01 Feb 2022 19:46:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-26-g806b2893e010
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 140 runs,
 2 regressions (v4.4.301-26-g806b2893e010)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 140 runs, 2 regressions (v4.4.301-26-g806b2=
893e010)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | multi_v7_defconfig  | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.301-26-g806b2893e010/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.301-26-g806b2893e010
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      806b2893e0101bdff3ead10f038759a025f73557 =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | multi_v7_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f9c675c3a640c0bd5d6eef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-26-g806b2893e010/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-26-g806b2893e010/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f9c675c3a640c0bd5d6=
ef0
        new failure (last pass: v4.4.301-23-gbbcda064239a) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f9c4090c851d77e85d7019

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-26-g806b2893e010/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-26-g806b2893e010/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f9c4090c851d7=
7e85d701f
        failing since 1 day (last pass: v4.4.301, first fail: v4.4.301-23-g=
9b80ba4cf655)
        2 lines

    2022-02-01T23:36:20.178253  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-02-01T23:36:20.187765  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-01T23:36:20.204211  [   19.183349] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

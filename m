Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DBD495592
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 21:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377653AbiATUmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 15:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377625AbiATUmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 15:42:52 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43BC061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:42:52 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so6870353pja.2
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bEEbYKZ2E6ri+SoTGH4Nepi8bnkcBo/1glr30kkjcOo=;
        b=XzVWf0pPlByRVwVD55BfVTV5JC1uWI2gqZ5Tcy19lb0LOtj8Vp34f4d14aHuK4JXC7
         DyP3oaLnVqBIGbHzgOk+wb5v6niE2a18u6aMuNRzLOIIh8ybCSv8rfA8D/QRomWXFYmK
         Xxwl6LHSRsuOMsvvII7uPDb4LabNiGJi/llijFa9hFGZzWDv71+DAHzTiN/2l47JfxGu
         qltwhnZkKSvipwWCcpSLXiSplQm2tN236Gxm7cfx0zzG5A3pRo+kvIIfvA0BDa6yg01S
         MxRYe4DlZcXc6jpMFKJievYTVLS/nQ2OPlulXadKbnScw3olkFEVmI8c9DxTk0y2aoxJ
         JE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bEEbYKZ2E6ri+SoTGH4Nepi8bnkcBo/1glr30kkjcOo=;
        b=jVvYEyfxOcYkkbTdATvAYEEsTle5sVJHkOEONF9n6vdCt1rturiT38HtTgjJKLIEqF
         SkEPV2kmlH+oEQf/pT9NfOjMYSbxg8nPv2apdC7QCS2lof3NtAdh00DJIe+Ue1QrsO24
         7p86H3KTl9T8M717zLOJ/agoUd+nvVHe2JT0ZGpMdpgD5nHML8gnezBOGOAcDQvTp3LL
         VxnFgmCmzOsjuTvSsBq33qGvtdmTLfWc3/dJXbAu0BDdM8w9/ND2k85UQaQHLQj0XRWu
         FAfBNeOMo7uduVLkzrhv+wXWmjDGNc+GhcrxQZckZtDE3ebqE98gtE1kibtN7TpQEC0z
         AHkw==
X-Gm-Message-State: AOAM531/WtTwyhuZKe5R2rtdtNIu78wEAbM2296zWg0rFjlbJjdQ6yno
        UiQlUDVwAu4MMK5R6C0WpPn0RybW+hqbhsyg
X-Google-Smtp-Source: ABdhPJwC37vGW3Y+onn+6RDygmlaXIfDHT3PB8F/RmJ26qUUXyFvtUnnE/lynt28gtNmhYW4md/Vog==
X-Received: by 2002:a17:90b:4c0b:: with SMTP id na11mr903443pjb.118.1642711371170;
        Thu, 20 Jan 2022 12:42:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t21sm424610pjo.56.2022.01.20.12.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 12:42:50 -0800 (PST)
Message-ID: <61e9c94a.1c69fb81.da915.233e@mx.google.com>
Date:   Thu, 20 Jan 2022 12:42:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 283 runs, 2 regressions (v4.14.262)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 283 runs, 2 regressions (v4.14.262)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ba8e26127c393c32776dff6d79c5b82de6dc542 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61de778d64d5cb4c02ef6759

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61de778d64d5cb4c02ef6=
75a
        new failure (last pass: v4.14.259-30-g5ddb49631ce8) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e9943004e5823a22abbd1d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e9943004e5823=
a22abbd23
        failing since 6 days (last pass: v4.14.262, first fail: v4.14.262-9=
-gcd595a3cc321)
        2 lines

    2022-01-20T16:55:58.149888  [   20.168640] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-20T16:55:58.193210  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2022-01-20T16:55:58.202334  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

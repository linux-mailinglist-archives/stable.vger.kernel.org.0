Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D2E49A9FB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323902AbiAYD3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3410340AbiAYA3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:29:03 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555A0C046E1E
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:14:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id g9-20020a17090a67c900b001b4f1d71e4fso549187pjm.4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OsqfALm1JiUnP5EkzZito61oC8xEaIYvybztU73y/74=;
        b=XAIDjpgizrq2ukNS4Ldr4jWNNvBlzFScWnAboprpP3nXwdYJ1CLF0pIXW8UF7txnoZ
         5HGCW9a6R8gz3HY5G+UN4hjI6J3YKWpnHW3WPlGVLwaTKx7SAMi3ya7mmgdYxUKLIAn/
         neeUsJlyZZZK/NIdbCe8XeGiLpMeo/6L1tylEVV6XE9v5xZ78+QBHpLDpOK4FqOk3y/9
         4oBYeI4h1ZVw3Bn2xtxGzzdezEBIaL76ot5nYa/m9a9VRI/kqCmthUriqz6YlmOnF/Oi
         qgLQQ7mpKL8XVMHa3d27aInXQpITsw2D4Gadk5sMONCgzi1nISaNdalYCSvaupUI1wja
         +E/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OsqfALm1JiUnP5EkzZito61oC8xEaIYvybztU73y/74=;
        b=w0xw5rK2Q6qfhUMfH7eC2LaGMGgwucIlxfq/P99PrTOLPL8OGzElGw6UONJyl0xYD7
         orPKN7WpS+r/DJBqz896sqKbPDuJhLtytLDdxiJYA6emC+69k/w/OQxAkgUjPYVGTFsZ
         m0/AxB6uuYtA4/a/bgzIoV+8bavL/y+nBHnCa1Srt4vsW3uEHM28d0Mkp2lkZto/PCh3
         QE351S80qn0jKnHIai+Vw/LgvLQzHSntfi4L7DuBlXEWIfILAHVEXvLobiM4z5hni8TQ
         EseH90beloS4uO2svV2IqfDlcq4HsB2kIY2ogaKYCdGYMSMDczvS3HBDddfu4fxNSdsL
         omQg==
X-Gm-Message-State: AOAM531I0FVsEBud7E0WhK46x6UWX3YTsEWkMqON301QZpuAC5FV/3Go
        zjBVngiKPNMCIrTtdI0g69BoTajkmsaJJAtS
X-Google-Smtp-Source: ABdhPJzg6+QD75cD0/V3E6jSMN4+ThLieO/tq/fU0KPMPCxzPxU5prO9rA1tk/DQURgr/RfN8cK87g==
X-Received: by 2002:a17:90b:354f:: with SMTP id lt15mr320602pjb.83.1643062458712;
        Mon, 24 Jan 2022 14:14:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s23sm18836275pfg.144.2022.01.24.14.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 14:14:18 -0800 (PST)
Message-ID: <61ef24ba.1c69fb81.9509b.2655@mx.google.com>
Date:   Mon, 24 Jan 2022 14:14:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-151-ga397812f7f1e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 117 runs,
 1 regressions (v4.9.297-151-ga397812f7f1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 117 runs, 1 regressions (v4.9.297-151-ga397=
812f7f1e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297-151-ga397812f7f1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297-151-ga397812f7f1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a397812f7f1e08833fe69853049f9e10dd60e967 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eef2792626d8c965abbd24

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-151-ga397812f7f1e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-151-ga397812f7f1e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eef2792626d8c=
965abbd2a
        failing since 21 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-24T18:39:39.486675  [   20.137573] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-24T18:39:39.528440  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-01-24T18:39:39.538120  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-24T18:39:39.554261  [   20.207397] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

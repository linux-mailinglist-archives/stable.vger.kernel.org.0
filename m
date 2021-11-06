Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518F244705D
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 21:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhKFUQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 16:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbhKFUQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 16:16:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA72C061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 13:13:23 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l3so10207012pfu.13
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 13:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7TQjTn6h5gnK2iga9XK2yzWsmkRucj85tRLUQmPYo8I=;
        b=h2Cuwsws79KgPy2w6fp2rXuRs4ZMZXAmTCGSP0fzdLS1WeKXiO4A6dfBI2aagcWVzJ
         K2ep4Vmaddy0D0FWPRyznWOJIGoXuL5TMNUwpwuyVpDAcXUGOzyAoaEJxb/RxpieHrFG
         vjcJwImvCve9BlTwrRkN3TWwiaJUPCLa3YsxaxNqOUiDC3YiD1U/mbmDmjDR5qNoIpd4
         ZF9LeoqCtZ1Fuu+0StYPNxi9MD06p7dVfcQdVsfLuikRQGon6n+8tQjBlq7QFcH2/upi
         rd3MpRONpBPJvwB3fIZr+tngvVptlP373U2iAz9yNc4gQRttEECCfSyixjLum2W/HrYX
         bVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7TQjTn6h5gnK2iga9XK2yzWsmkRucj85tRLUQmPYo8I=;
        b=ewQF89AqB17BeVHQKoFejl1XO74/ZM9NcAk3z7huEBc28y8NHIAGwX4c3wkzI1YBko
         gDBpYKa+r2ydZKH7R9AgVcX5GbJiNGyt1pBU18v8/9AOCQM9B5fLOprAw0f4kwBm1y09
         ZrNmAPltWN0frM1dGOESfoWL03Yy+l0nIc0wBIzSh/PR5n10RFJteeCMowLVmhcCzqPP
         p5oDJUwYce1aJeZ6/E4Hy+98WFBy0PbpyCDj1Zl1VrK87jfQWKKGLtDgcDQFtRQP57Qm
         bqFi/iJ4BWBlaXCeJL8kbaNtmCPhXz+Zz4OKzTT5rmjjpxXmJb7ksBE5mDxlt2OBzm7+
         HEdw==
X-Gm-Message-State: AOAM531xNDS+V/8drR6IJyy8LHnE+fz7yMNGo53SGS27CeuCR1Ka5yK9
        7uGrKEgrTQeFq5GymdVcCthSIaFarMVyi3A8
X-Google-Smtp-Source: ABdhPJz3kYixxbu9zgGDipKAXuyPgtZRHtsbn5QfdBunp9GvRojSEMZPY58ismSf9HaRFyJOpi4AFg==
X-Received: by 2002:a05:6a00:134a:b0:47f:2c6a:f37d with SMTP id k10-20020a056a00134a00b0047f2c6af37dmr60769823pfu.50.1636229602980;
        Sat, 06 Nov 2021 13:13:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e8sm11354037pfn.45.2021.11.06.13.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 13:13:22 -0700 (PDT)
Message-ID: <6186e1e2.1c69fb81.c561a.4a0c@mx.google.com>
Date:   Sat, 06 Nov 2021 13:13:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-7-g8fa9029bb41d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.254-7-g8fa9029bb41d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.254-7-g8fa902=
9bb41d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-7-g8fa9029bb41d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-7-g8fa9029bb41d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8fa9029bb41de933e53de0058d7f16c95d26d24e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6186ace13332c12b8f335907

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-g8fa9029bb41d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-7-g8fa9029bb41d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6186ace13332c12=
b8f33590a
        failing since 2 days (last pass: v4.14.254-2-g86b9ed2d25ed, first f=
ail: v4.14.254-2-g116ed5b2592c)
        2 lines

    2021-11-06T16:26:47.623359  [   20.018341] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-06T16:26:47.666940  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-06T16:26:47.675606  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

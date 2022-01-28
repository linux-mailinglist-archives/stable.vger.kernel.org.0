Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FEA49FB85
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348069AbiA1OVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349040AbiA1OVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:21:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19409C061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 06:21:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so7376331pjl.0
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 06:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N3PIYhm7EKPVIf8mUmgv1wGHiVE+cNyKNoqmzE2qSq4=;
        b=kjudfon3YElGckBLPMzazq/GxF/4FnOqgkcrosmdcAy/qGqEuaQlayD5YIZkeVzN4e
         aYIu/elnqXCHOzbPhOadsOojZKd/5uHAhDNegmo/Z4TP3aASdH65otlLtHd34uX1gFkO
         5ev9B/KhcayCrMaioqq8UDS/qhwbwoCNv3NNlotHxc42x6T+buM3F6+xvi/NIjN2mQtg
         96e0AeOzAq9o33/HFtwjKUkivAvA69IBrFPtI0X6E+B5EofzTyY3ZUNkWeHmj0OJgkP0
         y/k3fHnB4dd+JFowzr9OKW0aItzzPY/sVbUUWMEGT/XyRutnQKdqWLXRHHIcnAYIhZTh
         CHxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N3PIYhm7EKPVIf8mUmgv1wGHiVE+cNyKNoqmzE2qSq4=;
        b=dRXYOyYPFOFOxp/4IW4ZEe8BIgkDE/TyLSd0HFpjLRBiJj8KOkSWVTe3aKptkrN0mV
         T7ukrCCv+VA65KStyEECDnEK+9be7UaaG5813BuhRXRVWl+QNsgBcxd0UaxKA4jsfHD3
         OHbq3y3pYTKuzMJsk+z+EzHtWvRvAdfZCZvHqynBYYM18eUoejg+9erKuEI9uQcNEqQV
         aadKP404lFh666mfPXG7egNLiPO6ZGATSnnCtMjD7mElGv8mCMpajAIGRDn3UNGDmmWa
         Ugl6kWXadZbVcdL9RSY80Nl0G/7ZsOv2+sr3ToVeRIRb9aSujtpEyTU+jorrdfKUgMZl
         FsBg==
X-Gm-Message-State: AOAM531XQevKJEl4PZaG3nCnhy6oD6DPbTfkMZFl+dBak3lfr3AenlRN
        GN36yFvOIL9h1ph6ietpTcoO3cCweCP25aKZ
X-Google-Smtp-Source: ABdhPJyd28VUfuMpGFixaNdqwj/7gu0yyoVjjrUzSVkQqMRHkemj0JjIBy2R6TdjQIgNbYCFpG5LAA==
X-Received: by 2002:a17:902:f54f:: with SMTP id h15mr7341637plf.125.1643379681474;
        Fri, 28 Jan 2022 06:21:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm10137946pfm.17.2022.01.28.06.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:21:21 -0800 (PST)
Message-ID: <61f3fbe1.1c69fb81.ee158.ad18@mx.google.com>
Date:   Fri, 28 Jan 2022 06:21:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.263-3-ga2d9e2bae197e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 117 runs,
 1 regressions (v4.14.263-3-ga2d9e2bae197e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 117 runs, 1 regressions (v4.14.263-3-ga2d9e2=
bae197e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.263-3-ga2d9e2bae197e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.263-3-ga2d9e2bae197e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2d9e2bae197ed692ffe411bcc08d9e3b22b95c0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f3c210707192d545abbd20

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.263=
-3-ga2d9e2bae197e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.263=
-3-ga2d9e2bae197e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f3c210707192d=
545abbd26
        new failure (last pass: v4.14.262-183-ge251e7983f4f)
        2 lines

    2022-01-28T10:14:23.327320  [   20.043518] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-28T10:14:23.370099  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-28T10:14:23.379481  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B92482E82
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 07:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiACGi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 01:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiACGi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 01:38:28 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E20FC061761
        for <stable@vger.kernel.org>; Sun,  2 Jan 2022 22:38:28 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 7so16769404pgn.0
        for <stable@vger.kernel.org>; Sun, 02 Jan 2022 22:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bUdNv7XErhwohzYpB8Vd+84sE2NZRR6KbkTdb0JYcy8=;
        b=38dzSJ23TfMYd3eawAKJ/2+ExIVeM8uipYdljz+dUYTcq58MtNXsDtwWVwqJyqc1Y6
         +kGQ91U4VucLOlQFIOwgW/zFLk9Ds1vmRsxiE8B+ukjM4us6RQJ1JQRxOvMFhyBteLGI
         pjLvixl9OWbZllh6RzOzyyqYODOOmSij8YCaz0fVL9kjC+Y4lHkVUn8nF/ML39ocvUyA
         dr6yB7/1aqDY5liPHhjDPvpFCnZRn+xVZhMElRcA8ohLX4WWYMhloUOCQp2bj3t4Il6c
         xH+G1IReDQeh0DBH6yFSoPGQkrt1GOPmHxwO4YjoBSFoURBCVdkRBQJdDUmTSZmBlRkv
         HBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bUdNv7XErhwohzYpB8Vd+84sE2NZRR6KbkTdb0JYcy8=;
        b=Y9x9NmWEFVSVDx9dpUEUPe04G0b3AAF7vp5Sr40gmzeH2s3mIs/f05Ry4A6O9fMwqV
         fSaWiNnFzZ9QgdOEdh9sdbxq+o/NQxeT98fG1wUgrqUzKeWfLR2xfTAdsGOQj16x4FgY
         zq5n3DUdT6/ZNJHER7GK2bN8GnDgRQ9YDC/kDJHk61T3N2v+q0U7G+nYRpsK8aZiHeKX
         pO3Wp4kytgl0+YMNiREpnxhxyfncg4ZDymZornuPv62DeHC9fMwtPxGWkVvmj8TqzzHO
         RaNGb131xv1/ArffZxkwgqY1+VGM/x1c9ODGZ3xWB6qrChe/rM55KuVuPrdueWjHx0VA
         WdpQ==
X-Gm-Message-State: AOAM530Xw7Wj3abjXz+YVztpC4zP0zgVVIWXou/jj62tmnyBHhwYNmqC
        33Cn9f8nWS7oczMS5o6YQQrwfaHhHEeUIje9
X-Google-Smtp-Source: ABdhPJxWTOeU92KHoWc1kYVBRgPMio4XhlXgYBbH3MGERG9xTStyeaDLsCQbfTSqQn5aQCpQK3B7ig==
X-Received: by 2002:aa7:8e88:0:b0:4ba:8792:b with SMTP id a8-20020aa78e88000000b004ba8792000bmr44427263pfr.23.1641191907992;
        Sun, 02 Jan 2022 22:38:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm38688598pfv.48.2022.01.02.22.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 22:38:27 -0800 (PST)
Message-ID: <61d299e3.1c69fb81.5592f.7458@mx.google.com>
Date:   Sun, 02 Jan 2022 22:38:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-5-g54e1ec732cd2
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 133 runs,
 1 regressions (v4.9.295-5-g54e1ec732cd2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 133 runs, 1 regressions (v4.9.295-5-g54e1ec73=
2cd2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.295-5-g54e1ec732cd2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.295-5-g54e1ec732cd2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54e1ec732cd2471314187713e55f8bc7425620ff =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2684f0895a1f9deef6764

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-5=
-g54e1ec732cd2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-5=
-g54e1ec732cd2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2684f0895a1f=
9deef6767
        failing since 6 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-03T03:06:37.864805  [   20.468719] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T03:06:37.915577  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-03T03:06:37.925192  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

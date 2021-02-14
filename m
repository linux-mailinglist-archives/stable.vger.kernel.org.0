Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2E31B089
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 14:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBNN2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 08:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhBNN2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 08:28:01 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB51C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:27:20 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gx20so2310295pjb.1
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QGb6OOOa+M6MnvXnrLMw3ySn/vC2rX1gwAbcKYgLBrw=;
        b=O5kaq/MlJLmhAT2rbqM2EjddTxnC1pXSYBfJjfS8r+XfHZhZFxs1xYwmSgGILqpPhH
         pUSDRuHkBrZJrFU7FD8l6Xr7yo9E9xb4c76ZTp530Np/dzRmaAYjpO2qRC6uzwrdJ6mf
         TIPn5sPeaeRrnwfCeA/R8H/HCryj+vtWWhvLxx++z1TdZhMZLefuTFKB8M+VpxSMCyev
         v3oG+ggOF7NOKx3siQJ6amO2XIz188phR2qiD3adHSy3+Qg9e+JJDEOo5ntL0fQ8pKok
         hyQ//DeAntqacRrXfRwE4o6pCCyGDnfReH2pKRNuTxQk59sRUpznvwPe5RxHWA3R2liO
         b2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QGb6OOOa+M6MnvXnrLMw3ySn/vC2rX1gwAbcKYgLBrw=;
        b=QW2HY8BFZ8FVLstUiz2pTWkBmufD634cMTMoKdo8y+xINX1LzNp5vBMRWKxLXvxmyN
         rS2OgLaOHQDbAT6ERg6ie1IJ1guM4mqCQNv5IKuGGbG/DQevxxVDOiL0cPG0UC4r3sLf
         J6U5OQTCCNueW7+yxagOvr05PXyhzqtnWhpcFKo20WBdlLYB5ft9ezsDsyx+Qxtt6AVy
         gYKT20fl/wvDQfDIG58b+bIG5ZlSx91IVReQYNFDWmQ2aiu7rt7laVkmrBqDtiuxEswO
         2Qw16IkR5vwUuKSTGSnWH+QYjm/x/GHTuwyCxJhQUwOAN9vGz/TpYOmVlDFF9UzvVzYI
         kuwg==
X-Gm-Message-State: AOAM530+kL07iINi4Qc2CCOVbJ4impu0b4TIsClY85KNjkAtMke3/E1j
        zvw47WYTS7ftayvsJctuVEnVA8410M0j3Q==
X-Google-Smtp-Source: ABdhPJx7JkHl0AuaY4QN2yTGdlclcoOTsNCh0eOPbCD0d52Znkxh5Z8OG9VHPXCWzWpljcsh7dBcEw==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr11137696pjm.166.1613309239987;
        Sun, 14 Feb 2021 05:27:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16sm15255006pgj.51.2021.02.14.05.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 05:27:19 -0800 (PST)
Message-ID: <60292537.1c69fb81.0239.0949@mx.google.com>
Date:   Sun, 14 Feb 2021 05:27:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257-13-ge179efa66a00
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 31 runs,
 1 regressions (v4.4.257-13-ge179efa66a00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 31 runs, 1 regressions (v4.4.257-13-ge179efa6=
6a00)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-13-ge179efa66a00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-13-ge179efa66a00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e179efa66a0099eb767e404b4f4e2f8ff9a2fbee =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6028f2f3eb5ba0d23c3abf05

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
3-ge179efa66a00/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
3-ge179efa66a00/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6028f2f3eb5ba0d=
23c3abf0c
        failing since 8 days (last pass: v4.4.255-14-ge5269953cc26, first f=
ail: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-14 09:52:47.343000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/110
    2021-02-14 09:52:47.353000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-14 09:52:47.372000+00:00  [   19.519744] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADB4487C63
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 19:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiAGSqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 13:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiAGSqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 13:46:45 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4E5C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 10:46:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gp5so5897444pjb.0
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 10:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D0vYRnSjVlXQsOkAgKAoXNyORloP2DW7991x0dMQJpQ=;
        b=m9ggCvu7m82pTkwC+3UjPnhgFKJkMzVtGUjPDgwvd/AoGz7HyoNVnTJkpIKEdEjydB
         QJtFh2VSKT29cjPhOM17i46Lkbc1hAFH0zR1xWs3WH2H454FuZWT6wesJasXSMYxdp25
         fYIa1UcJHoolwy/oS9HYP9ZwAYRS9jLR7UEzpOQBFyIWgZF+ldKaK2B+XbLinE0Ei9sW
         64UJTKMdQaNbsCqLnf7oplOHR1VzfKOaSfewmbpwRwzVpb/nd2JTe51ZzwR8KcLlNTIh
         h38mTxF4NgAVkz1CnRFR3WA5jhAgjoOy8odbBm7zJLt24dDb/p0P8InKYUdSsVfJ1kfq
         8zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D0vYRnSjVlXQsOkAgKAoXNyORloP2DW7991x0dMQJpQ=;
        b=ioK9C8+HvhAQfyBSRHFnfXIHW7sRwShn3sWPZeWygojOOgh6upY7yOjGq9tcRbFiDd
         7lQ0scnQkYpYTfKn83BrITdBgi1dXiIBJ0qTkF9f1PTzA9vQbRv/1zmKj6Q0Y6PBumyP
         GyNoGb5JQIMM720aPAX/+MwOiyAqW2JHoKt77wJjQFqSXo6Z8BGeTl9BZgTuO8w426Kd
         DZwhYJXzH8jhaBacwllnr09aIt5Ai5Zaiqf/c4ABM1lfDUTp7xXQk1bWI/ERp5QJZE1S
         JyHRnWnj8k7tHXhZ1gXOH/BVLuSxnva8SgmsD9qXYnrkbkefgSTjcpxLI/1IyC5U1ewg
         QOZg==
X-Gm-Message-State: AOAM531mcm7gmdXc1CqX6LdhxbnIlzcGnEHOe5zw3yHSekAJ1jEifyAY
        Mp21SWVay0sxVtE+03HJDGSPl76J/rEbCZhi
X-Google-Smtp-Source: ABdhPJw5LmOQrNwPxgvLjHdmDmR+lgB2nuMoTkZsIqNI0m/30UZwAc/R1ckpBYfsgtU2aRa1vv9MvA==
X-Received: by 2002:a17:902:cecb:b0:149:3fe9:12f3 with SMTP id d11-20020a170902cecb00b001493fe912f3mr64644389plg.24.1641581204244;
        Fri, 07 Jan 2022 10:46:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17sm6602438pfv.217.2022.01.07.10.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 10:46:43 -0800 (PST)
Message-ID: <61d88a93.1c69fb81.1dce.107c@mx.google.com>
Date:   Fri, 07 Jan 2022 10:46:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-7-g0a2b042fe0e2
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.261-7-g0a2b042fe0e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.261-7-g0a2b04=
2fe0e2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-7-g0a2b042fe0e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-7-g0a2b042fe0e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a2b042fe0e2bbbcc02417818699165cdcf535f0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d854d2c428665c95ef674a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-7-g0a2b042fe0e2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-7-g0a2b042fe0e2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d854d2c428665=
c95ef674d
        failing since 4 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-07T14:57:04.068424  [   19.933166] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T14:57:04.112897  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-01-07T14:57:04.121757  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

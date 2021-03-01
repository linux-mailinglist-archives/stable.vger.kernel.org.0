Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E3327A8F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhCAJRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbhCAJRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:17:08 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6C2C06174A
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 01:16:28 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 201so11076152pfw.5
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 01:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m/dlpvrSwzgqPJJd/BaRIJziveUP7k+aZrb2m0NbEyk=;
        b=s/hI09Vs4PaccINENNv8t4tYZoTLXr8pX33XEumpSaGt7yzhJ/4OJPGjlsHeS7Nw8P
         goGQCcNsERfQEFmUgfjc7ToTSANBcU2crhjDlfTCeOQCG15l9vxrlpwH5tUy/zm9D+cv
         24nrFv8CDoT6Kr0qnzx9dOcMHuG9hsCHf8A8I2v9H+APaRieiw0ZjjfPFuPItnrYcLDr
         mkwEgG2+A/EJzA+yT3kzyLdRGE5ZvGad2jsK/eVuYDV1oLhWoBY7g+noMnwZ1zO8eWCh
         t57GMPL46DdemYo850NP9WhDdJn0bxXVUfEfpzWaievc7B4oKkTmpqp75rYi9QaZlUF5
         AMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m/dlpvrSwzgqPJJd/BaRIJziveUP7k+aZrb2m0NbEyk=;
        b=btzaEJ5qPS4TCh76d2/Bo/TEBchp6VZNRYSVyG9UHCkUCbaM0XwHly+yg/d1LFhEXb
         2gG+iRga6XDMGZ9DZPD/OGMCdpT8O0o+Xtt6TF0mQ8ctGw9zn+FNUz4i5iVyn2pzv8gM
         XAG4Jyfl/SmT9DyP2rUpAIXxtV7cV5MdeACw9shcmUta2qq/KDiHZJmhmxn3ARexaSPm
         kF63jJl0dqY12lOSVlHuvEcsL0mhNQsMtZt0qpDKgRQQUMBoCmirHliTqveg/73GU5mn
         Fvie41Ww76oNQxM5VPp0M9fQ+O3PZlupvienejSD5rn0Wp0HMfkpLkDpIsgAUgv5dtsN
         QfWA==
X-Gm-Message-State: AOAM533Gxi36DrIYRHPl4wB1o3rru58mIbI4IP5LvW2K27emvQLrSaJk
        sD2YWvrHsQkYM6wpJiBi3XeAqhWRnTyjkA==
X-Google-Smtp-Source: ABdhPJwm1n0m4SIcVkSAFBUlHRyrfmMceYiSDcgHMRYm/KX11aAEtWWweD/P1g9SQW4wTHEVDvv06g==
X-Received: by 2002:a63:6604:: with SMTP id a4mr13452990pgc.402.1614590187439;
        Mon, 01 Mar 2021 01:16:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15sm16185114pfk.128.2021.03.01.01.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 01:16:27 -0800 (PST)
Message-ID: <603cb0eb.1c69fb81.e6dec.64b0@mx.google.com>
Date:   Mon, 01 Mar 2021 01:16:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-88-g9173936eb9805
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 45 runs,
 1 regressions (v4.9.258-88-g9173936eb9805)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 45 runs, 1 regressions (v4.9.258-88-g9173936e=
b9805)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-88-g9173936eb9805/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-88-g9173936eb9805
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9173936eb9805af386567e80a3975d111d7bea8b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603c7e06c726fe5013addd0b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-8=
8-g9173936eb9805/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-8=
8-g9173936eb9805/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603c7e06c726fe5=
013addd10
        new failure (last pass: v4.9.258-12-g80c6cbdf1f84)
        2 lines

    2021-03-01 05:39:15.115000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-01 05:39:15.127000+00:00  [   20.488189] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 36:84:3b:a7:fe:5f
    2021-03-01 05:39:15.134000+00:00  [   20.500793] usbcore: registered ne=
w interface driver smsc95xx
    2021-03-01 05:39:15.167000+00:00  [   20.530273] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

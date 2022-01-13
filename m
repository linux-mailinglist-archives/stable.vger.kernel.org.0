Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3253148DCBB
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 18:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiAMROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 12:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiAMROa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 12:14:30 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D806EC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 09:14:29 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h1so10708815pls.11
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 09:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A0jSEoldpU7Ur6mleNp2/UEmiyqAolwiiBZx8OO0J4Y=;
        b=Ya52ToMd90fKPpjYHZGV0AbPHkArpCHLHeBv7HnQOI6hlP9CPg4frDpQBf1Jd2U7Da
         e7MFyEgdLmp0itLyr7qAFaXrEfyE0jA7/+xCiV8PfUWfpEpIXv3CE6Gthf6z3PDciOQi
         Cl5XHpLKRiCvO1nWiiSbJ/EfchyVPHBNyseRVFarCjkJ/dOmca9sMPvv6dDbjMc9dTDD
         RL4IRS2vO/IwOhzyEhiedLELyxJAVRU0FfAbNJsFaSLY/8wKd+OBV93EA5xXCskg7iyc
         0Cm0/WzqvC+X8gVN1EgN9o/kNlTl7/lF0R0xIdlQ0IM9DEXOqxdFUBhZzygttGY9h8MN
         MDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A0jSEoldpU7Ur6mleNp2/UEmiyqAolwiiBZx8OO0J4Y=;
        b=ol5YZKky5GpC+YHdJMrLwvwFJJb9KAD1ypbf535/VhfOXAdmrqwrQz8SNxxpQ7eaAp
         tXSoNq7ajnZWn5i3S5GtKMRyI3b862+q3vzgqUv6w6FwvS58MiUiwRydZykWlINO8MbY
         zCipwXBRSQFwBUFDjr78kt9YnJL9ohz8tRsdDsfmNiZ9hV9UyKh7UvXUV2oWdoF6Axmu
         HxDERhmgbBCId/X0JDvPNBBY7BZM8cl+aAO1GuH8eFQqdkMeNISJ/YCRNcHDfPa6pcic
         dYyusJEYnNZL8Z/Ramkil+BYf7U3d2uI1lGxrC2TIu/CMTUasmIjn9HTt9Nmse4Wo/pb
         7Waw==
X-Gm-Message-State: AOAM530rQNO5wHcG89RBhPZFP6kzbsckHKe4sCOEdB4nXf8RIhO4+Z/D
        IaJeGHqoVKEfriqJtFaB24u6h/S+sy21yzbyy4E=
X-Google-Smtp-Source: ABdhPJxc4gm2tpL0Ny3IKHWX0LFyyYD3J1D/1UahYvHMX7L/7v7jHRnK5aGX0L4foLMSYxJFpA2n1w==
X-Received: by 2002:a17:90a:1108:: with SMTP id d8mr15077419pja.175.1642094069248;
        Thu, 13 Jan 2022 09:14:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h124sm223302pfe.34.2022.01.13.09.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 09:14:29 -0800 (PST)
Message-ID: <61e05df5.1c69fb81.32040.0d60@mx.google.com>
Date:   Thu, 13 Jan 2022 09:14:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-3-gc3f2df517d8f
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 1 regressions (v4.4.299-3-gc3f2df517d8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 1 regressions (v4.4.299-3-gc3f2df51=
7d8f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-3-gc3f2df517d8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-3-gc3f2df517d8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3f2df517d8ff00c045d8cc1efdcc29b75779dc9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e02b85f2f251b40cef673e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-3=
-gc3f2df517d8f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-3=
-gc3f2df517d8f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e02b85f2f251b=
40cef6741
        failing since 23 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-13T13:38:56.994946  [   19.064971] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T13:38:57.037368  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-13T13:38:57.046699  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB9B48FE93
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 19:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbiAPS7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 13:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiAPS7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 13:59:31 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B1DC061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:59:30 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o1so5951348pjr.2
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jz5Kb3/JreH1+g+3vL+KaEvLKyjDKwPjEPWR8VZ3LZ0=;
        b=CH6Wr8S0NCb1qC/k+76MF3/b6FcCOLSoy1S+APn6Qxn2e4AsmesLB+3f6OmbkKLRWn
         VgG5YEryBemQhe+JJhKzC1kMh46vR2j948oRnvOm2GHC2kX+uvcpf5QGhJByjbyy8tLY
         QkLIlcfJ/xx77zARwUpA9Ym9yMYhMO1YAMHvNjq0oFf2hiI4sVWbL0u4dvWIqD8VQcWG
         rOrdRS2ZGnh9ZakA/OSrKeVExM7eskLmUAO5glnOivMzH6vH20ORYzp2oc7w/Etov6Ao
         3tKyHtRtQ19G982akR5dYozMDALD9HxU3uLqrxii9roje26yxHZMnxXNQuns1H+s5WsZ
         hIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jz5Kb3/JreH1+g+3vL+KaEvLKyjDKwPjEPWR8VZ3LZ0=;
        b=iLZYQmFDbjtTjEPCmNws+acQ/59iSqEGYPprvfqSXa98otR//bbTj/8emtShyqK+lW
         6LcRY9YG2Eqzb1NAPcYoUnGf3Uk4oB9ZZyK9zlaMY9JwDk89ElqZrEM7RHui1WFoxgpF
         LxWKbzc4ihqgSNaRim8wvvKS+zHpUlgdYIe1jHJPWOmGyVOrQZHh4KcLhMFXhup0V4fy
         +y+AXqKGU8TzpJ4AXi25ixoTDacGywemWZopgThGK1FMXXAr6saE1BHGWHNHa3vDx2ji
         MUAMxbMQgxUTdI2w6O7eM4JBK3l7axVr5th677o9oXGdpEbdkreMpUdFbSfQYMVNk93L
         1oOQ==
X-Gm-Message-State: AOAM530Vw3o3xOWHssx/qW+BzKjB/Bix17oGrYxJunzf3WzfwT2duC9w
        xobb45OHo3DUhlkjQGcvdhfTRXotmWwCGCT9
X-Google-Smtp-Source: ABdhPJxhI8VUqZBmPGB83KQCgZyvhTjzxz28c0c55xMAXxT1wb+/NXjsvsqxIauPLbyR12KJl6vHiw==
X-Received: by 2002:a17:902:8a89:b0:149:a833:af2a with SMTP id p9-20020a1709028a8900b00149a833af2amr20048840plo.153.1642359570111;
        Sun, 16 Jan 2022 10:59:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z31sm9482787pgl.10.2022.01.16.10.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 10:59:29 -0800 (PST)
Message-ID: <61e46b11.1c69fb81.a1f32.9f14@mx.google.com>
Date:   Sun, 16 Jan 2022 10:59:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-13-ge42865c1b590
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 165 runs,
 1 regressions (v4.19.225-13-ge42865c1b590)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 165 runs, 1 regressions (v4.19.225-13-ge4286=
5c1b590)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-13-ge42865c1b590/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-13-ge42865c1b590
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e42865c1b590dd8f2a5a5aab3b3b604d7b2119a8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e4388403cd41bb0cef6749

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-13-ge42865c1b590/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-13-ge42865c1b590/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e4388403cd41b=
b0cef674c
        failing since 4 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-16T15:23:32.848583  <8>[   21.220703] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-16T15:23:32.893551  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-01-16T15:23:32.902918  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8315B485D0B
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 01:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343684AbiAFAWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 19:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343675AbiAFAV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 19:21:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B974CC061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 16:21:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so1022537pji.3
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 16:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P5Q0QdUm96PFlI6Ehik/Y5/QWvMg8sATPJHTX09lx+Q=;
        b=vWoRdb/z5+69uYhtA6fnmYBx3bPuzuFTEpX1nkNpUd87zvyfNDO6cy2kQYhOXmMFMD
         HdMgIHcrKnljxUk3EkjMCHzaYeFW9o37dDW0dZ3h9BDLrB9XuPl0Y2MH8uFJdtwafz68
         vdFL5m7CXfiQtR4Bd1wGmGwds8E3k60jn7Lv8WneE3EYO9wTJ7+vdLwWUpZQoLDu35Y5
         WUdSzMBf/wcT/1dHzYRwf4jvIsQoUWiGoWBU4Bs7xnE0qO4s2KZsyp22lL4wdcRmJRir
         BtWAGVdPqmbARwrmS3SCkwmV4hGuHz/t/rWVnPoIY6sI72xxRo2O8dwE2RfSxWfmATUe
         bjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P5Q0QdUm96PFlI6Ehik/Y5/QWvMg8sATPJHTX09lx+Q=;
        b=5ENNZVHJ8aBNVFSgDQbKN7Fk8UEP4NjprW9kZ7ZnO4BcknCoh6BydPPh43FhbrHq5B
         oZJKMHo/Cb16JekhC/jpKxaT0NaXk3Q1FDrNaocH46tY1wgvT/u4Dy4N+5StSbfEmYdb
         DgkirvqM8B6QfQrU0Wsy13A3sTpKohBkZIH8uLjhTHjvB+KgAW2z8/OOQUmvbtx3v1rW
         ufriKt0nwx0h1khRxyK0U44vwekSxXzD96/yuEKpFeify6TWUD3JF+fPTacKAwnUK3OD
         wNTsT3ccZ0RIUNUvuVxFNTBTIhfFEjLXBf0ZccVQAUiDTZRGrE5NnE5m1iec+MOzBYAf
         IVtw==
X-Gm-Message-State: AOAM531XkBokLeHjQRC8ZDjWMC1UGUk9uzIZ81FPHcRmEasIFU4RdT/E
        2dT9uqizvfy9YSxvauQF/GG3gl3WIif8Ft32
X-Google-Smtp-Source: ABdhPJzslgxvmFOJdEXYg1FITR837TzupZkEaBq1NpKQHHRZReHlQQgRP3Rlv6f3j+diggB4e0Qalg==
X-Received: by 2002:a17:90a:578b:: with SMTP id g11mr7083567pji.76.1641428517117;
        Wed, 05 Jan 2022 16:21:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12sm157143pgc.13.2022.01.05.16.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 16:21:56 -0800 (PST)
Message-ID: <61d63624.1c69fb81.b949c.0bb1@mx.google.com>
Date:   Wed, 05 Jan 2022 16:21:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 121 runs, 1 regressions (v4.14.261)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 1 regressions (v4.14.261)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bfdef05c8da46b022172695aa493cff7ac667a4b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d5fed99d1eca64dfef6746

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5fed99d1eca6=
4dfef6749
        failing since 2 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-05T20:25:41.983683  [   19.845825] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-05T20:25:42.026165  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, syslogd/78
    2022-01-05T20:25:42.035538  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1BC44AEC4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 14:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhKINco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 08:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbhKINco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 08:32:44 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58951C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 05:29:58 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id o4so5462717pfp.13
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 05:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TVXtMQiU2LZZ7o77tRx0FNouR9TSk4Vd9WznIV/hKrY=;
        b=MT5gwhrJXAkWWiv5Uxw4Sg7DglCfU4km4z+bwtwtBWqYobrBY+a+UzgSJ5cRmIcI0o
         IUMG9hqxpBifKohRZAczQOO/xnDTeaIceOZND3eLLNoG9BOGXPVH6THpoUn8z2Jps2sB
         PhTLMs/XQdaSQl2lxYk8/7UKECpAudYL0RHdIesgkzKGh7GiA0KrQ2blrspeR0ogzlrX
         pjUG7R4Z63w6rUeokw6NPWVHIPFseOqHKsbOxjSpwuBlt9b+zRxt4VZ88ciRzvB0xQen
         YZjktdOlvNoroEvAfVGniaEFhbFVrz6Qnax18DZD3YVh3rdvSHYqdDnTRqXrmID1Xe2o
         A2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TVXtMQiU2LZZ7o77tRx0FNouR9TSk4Vd9WznIV/hKrY=;
        b=tt6EwIwdTr/3qND0hhWlSmYianEB6UTZMksiBWKam45mR6QAP1fYLB4O9WOWjWhLj5
         Ilb08up/zpOgOgSCvGqt+QWmE77fr/cevrSeYsjAwYlxWH7Bh9wVfOK/fpKJ9ACigV1y
         TINjS3de+MxZvi2cuj0v36/ftunkCJ1VkK16fNPTo4YYFLtP11K7I1xWGg/kuW2hM4R7
         9Pe3CMd2TUmp1nhEE8kDbKPs8MERGOKUbdyDR+/XQtwmd2fafZbNekA7EvKhT9RJwGuJ
         LlKhLOE3+O/PH/mh4j+7A3cAmMlkgOSEZuBEnlIiN4t+Yp7vN+2JxYYrX9gsCxNr6I76
         rwLA==
X-Gm-Message-State: AOAM533OIU+fq5mTCqWsNbpkEBw9K6M+Pju8LGPf8QxDmDMtrJSGjgC2
        /Igd/4aNv0VD1Zfu6qxmx2FNFNZwXMXSSQV3
X-Google-Smtp-Source: ABdhPJzobcpzx7/XIBRHddkvhKPrqjdCL0yVT66fLs9cMwMLu0dgLrNnS6QjL2j8NzhVb8FBlxqbbg==
X-Received: by 2002:a05:6a00:188a:b0:49f:c31f:b2c3 with SMTP id x10-20020a056a00188a00b0049fc31fb2c3mr8061065pfh.9.1636464597787;
        Tue, 09 Nov 2021 05:29:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y184sm13207468pfg.175.2021.11.09.05.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 05:29:57 -0800 (PST)
Message-ID: <618a77d5.1c69fb81.9e376.4655@mx.google.com>
Date:   Tue, 09 Nov 2021 05:29:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.216-6-gfa81136e6d6c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 176 runs,
 1 regressions (v4.19.216-6-gfa81136e6d6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 176 runs, 1 regressions (v4.19.216-6-gfa8113=
6e6d6c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.216-6-gfa81136e6d6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.216-6-gfa81136e6d6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa81136e6d6c7ca18eb79022f3f008677b8c2219 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618a3b7063da64d75c3358f2

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-6-gfa81136e6d6c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-6-gfa81136e6d6c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618a3b7063da64d=
75c3358f5
        new failure (last pass: v4.19.216-6-gc918d64f13e9)
        2 lines

    2021-11-09T09:12:01.171964  <8>[   21.276153] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-09T09:12:01.224761  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-09T09:12:01.242067  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

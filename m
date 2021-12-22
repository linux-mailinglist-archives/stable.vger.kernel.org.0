Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361D847D41C
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343660AbhLVPJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 10:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbhLVPJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 10:09:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130EC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 07:09:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so2896429pjw.2
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 07:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wWRFKnupxZkX6cywVrmZdnTMGk5WE9x+/EkdaTzRDwE=;
        b=6AhUYI8rTNppDhgXXIIJzwhnZ7O1XBWPUksj7WXG1U81CHAGHzm/zEHASMuqj0VSjg
         dqLu9+/r86I3XTgEFvEhJdM0IFHmqCzk9b05nTmeZ+irGJMlzxG2xGtk+Um3Vr3ElOyb
         guUg+aoi7MpUnYZ8LUopcMx+suWwM7RSU9gFQgtT0jmU1xEnxK8s3y2LwjhTiPovyLs5
         74pYvVn39BfxYld4VML/YReL1CRyjCCgdvHVy39WJV9A/5krRdpYFlnxbu0xifFa0vV6
         zGcP1Lm7y/uMujurOLSCLLJQqkhRoSAiQV+D8OjyLJcaTFT+wT+UByy71AUlCbk9yP6W
         9eLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wWRFKnupxZkX6cywVrmZdnTMGk5WE9x+/EkdaTzRDwE=;
        b=bSpRh3A69zQw5IIVtgjm4LIWhhUaYBqii9TItkCzLUGmpjXBoO7QrvOnLjUKOpyrtk
         exNM+LWnk0ygmsMLVHA0BTrZa6NMtj6I2IJ+4/RMXNCIWD4nw1sNYKPul5YvIT63SJhD
         M/OgxGZ01JTOxiY/M3ogx4n9mU4tW6DHZMFH1dXf2A6Aq4utYGrx5ptTwPFEeFgmRzs2
         BamoRFUb2MD2boNFkCW8127AvL0Nqt8jgYXjVWXvp4ieEWYQZnaoqxk0YQKucSOEQhkB
         0yJMmkhl1/5YcbgUUBN3THcEUvCmBvyOipZMuVGmJdm12il+JmHyACb4dtz8MiR/lrCh
         M/7A==
X-Gm-Message-State: AOAM533b6T4ipXpmOtMYYvDWWCsSIG07AqLRtg4ZB0nxU16ieYUxvvHx
        Z4SVKzROmQbDu9vKFZUkGSSaz78YOHuMaA45
X-Google-Smtp-Source: ABdhPJzscFxVOpMsO18xnRIV4oVTPbHoPc8QcGJCXFdohTkZjNwS5BTE6pIWtiI7Szl45e9x7S8xHw==
X-Received: by 2002:a17:903:2307:b0:149:1bb6:fc28 with SMTP id d7-20020a170903230700b001491bb6fc28mr3091199plh.84.1640185755392;
        Wed, 22 Dec 2021 07:09:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm2808432pfo.37.2021.12.22.07.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 07:09:15 -0800 (PST)
Message-ID: <61c33f9b.1c69fb81.9e9d0.7719@mx.google.com>
Date:   Wed, 22 Dec 2021 07:09:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-23-g208fb3a43fb1
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 1 regressions (v4.4.295-23-g208fb3a43fb1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 1 regressions (v4.4.295-23-g208fb3a=
43fb1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-23-g208fb3a43fb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-23-g208fb3a43fb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      208fb3a43fb1b9ad2492f5094ead07289730eb73 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c3058aa864cbf406397136

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-2=
3-g208fb3a43fb1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-2=
3-g208fb3a43fb1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c3058aa864cbf=
406397139
        failing since 1 day (last pass: v4.4.295-12-gd8298cd08f0d, first fa=
il: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2021-12-22T11:01:15.340004  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-12-22T11:01:15.348562  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-22T11:01:15.366998  [   19.263458] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

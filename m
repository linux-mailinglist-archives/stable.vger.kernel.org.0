Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03B4475E2
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 21:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhKGUgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 15:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhKGUgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 15:36:45 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A90C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 12:34:02 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s24so14526820plp.0
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 12:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O149Ze6pWQo078M2Z9XSNoku2MRv2m02o8GjBjs23S8=;
        b=bQzMmUBdN0PCk2lI7JgTj6lkGRNPsFTYDMQ6WFWMIgqwwEnEo3xQKTZDvhDmr05YRG
         fNUbEG+D1fLUZ68oPR5dtdoR2533gvjrXd6v+lXi/b0R4wFkikXoKqjB46kIk1BEuFZZ
         SVjj+0hxkB11e94jSKmsOy5uj7mz68BPYjpDxrCT9t0sctWKVrrgCNEURcyJHeLwamY8
         0MD+3zyV4sKS5AJ5k/uAYIk6WPuLCQz7p3uir19RgfzsIoYrggvE3WRopBllX5p8E94r
         +E17Bc8RmgpzQOLyjwdAoaihDjWxu+OUscwZWFPyeDGYiCNVC95ADghGVC44U00OdZ+H
         m4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O149Ze6pWQo078M2Z9XSNoku2MRv2m02o8GjBjs23S8=;
        b=LFTPRy7YbQZKxXqRxeIyhJfwXhgQmR01GjdUS9jiLskh9X7/QQHFRlSxGs3Nc66Hlf
         EZQ1CNmyr7xr7jxRIgltznpXf4ETKojuntydIJJK+gj96tMb1jDdzMFhCGej4OE0Np4l
         7jayGqS+PPtT2eYUxrSL2/pIKKDnNLYp69mBxIXzhHzf26GhgYPQA5JtQUKf39LcoXhg
         LBo1WStaz4LOGMbTo+vmYnTuRtTxvGESy3FKCIYi4iB1lUbMBIT1jZv5Ez1lhIXEv4XI
         rhKQeyLxmMoxJFCWwOZ7gTpwsIVjfd2rABTN6ed1azm3JzP9AkrDNPnLDdA8x+4r5xtV
         Svvg==
X-Gm-Message-State: AOAM5318ek9aT+V6kojclagUlP10Vp4BWBvKJpmg2xrn2tfpVWjbzhCK
        9Suqe93PTsj8k/NXdPCdeTacsfwHq0DMFOGP
X-Google-Smtp-Source: ABdhPJx3CLqfrewVf4qtZPU6Qj4Tj9MKhFhet5j4zUAMuEw241nE+RnUSKOO9smgnqTox63GWwwNHw==
X-Received: by 2002:a17:90b:3a83:: with SMTP id om3mr27347973pjb.0.1636317241740;
        Sun, 07 Nov 2021 12:34:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm14387709pja.52.2021.11.07.12.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 12:34:01 -0800 (PST)
Message-ID: <61883839.1c69fb81.7e22d.c7fd@mx.google.com>
Date:   Sun, 07 Nov 2021 12:34:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-5-g036ef9ffe416
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 116 runs,
 1 regressions (v4.9.289-5-g036ef9ffe416)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 116 runs, 1 regressions (v4.9.289-5-g036ef9ff=
e416)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-5-g036ef9ffe416/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-5-g036ef9ffe416
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      036ef9ffe4163098496fc6167aa0db3872c52941 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6187fd04a091055eb93358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-5=
-g036ef9ffe416/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-5=
-g036ef9ffe416/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6187fd04a091055=
eb93358df
        new failure (last pass: v4.9.289-5-ga04f0d029c20)
        2 lines

    2021-11-07T16:21:06.361663  [   20.425354] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-07T16:21:06.405033  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-07T16:21:06.414309  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-07T16:21:06.430288  [   20.495605] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20

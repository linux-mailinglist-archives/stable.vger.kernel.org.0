Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC06F497645
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 00:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiAWXHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 18:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiAWXHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 18:07:25 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD8DC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:07:25 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h12so14546193pjq.3
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MbZNupE0/WZWAAbo1YVMmRis+uj5m9ni9vvqWXOvUDI=;
        b=xPXDQTvevRW4xb74O0OwKU51s1zkIdJyG4SIOgl96QdJFDDBoZPFe1CwRWn3U+C4Ne
         Y3hMru8hViwY2/Ymoc2sw97mk6bcnMdoqBDuElv1+sZcnFf6tSxP3RX4D/VbU6ZjgNAw
         G40ieZvPLXgo1sdKTztTRL4lOr5DD2i1NNWXmmx/SCcO6RJgyk81Li5ZbLGI1R3qrOei
         ppf79SXbm0X1HUoLD8N3sXM8uquTiQoawxdY+feNZuH1bBrdXqKGLH7XEDTSQqM1L2wZ
         gHuUHLLkX/hoSkxVVzVdRlfZt0T/ZshyRm8diXABwz6ryREWIakRAT095+LZwjH4wApo
         kMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MbZNupE0/WZWAAbo1YVMmRis+uj5m9ni9vvqWXOvUDI=;
        b=QudRCcEZCUNrpMt51PHh2elA5gfNOhN2auG0nQQjMaY0cPUvrZqUoXZSFz2EezrdwL
         XT7koFRG3IvVsqjevaeZ7/dCruqIVyv2Jp+v18sETbGPJjZWOS/sPpmYdO5KUZGmYfss
         HNlK99zc7+q/XW6bp0hwAXpkE0TAKijTimCXWv4pqgrfd3KoTIjLJWUbHNcDnynrH+Rt
         KEe4rjpUl7yIxc7CF4Ee75tK0ZoXn5j75KUwL5ErcOh4If2gGkVL71GqKwIzvL1USxDJ
         fP/i5qx2DmyYy94NxzjcznEtcg9CDONh+OmP9Fui+XY3ElRZ+QQwWTgpOEBcmPT6a0j0
         6fdA==
X-Gm-Message-State: AOAM530pzMqIKAgm54uFBJ6GWc5AY7jFDUCFo/ZD/29+Gx6d7xrCZdE0
        ODgDIPVcBSosYEp1KJmOKe0ECAfVuste+GO4
X-Google-Smtp-Source: ABdhPJwVUdGFSRgJnUx1I+Kj9N3Nz3E6jaA+rN3v8MvqlMM5XVHF3ZwHT2BN3E7HQQwNA91EuEStuQ==
X-Received: by 2002:a17:90b:4b0f:: with SMTP id lx15mr3290847pjb.128.1642979244485;
        Sun, 23 Jan 2022 15:07:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13sm13002289pfm.161.2022.01.23.15.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 15:07:24 -0800 (PST)
Message-ID: <61eddfac.1c69fb81.60688.44f5@mx.google.com>
Date:   Sun, 23 Jan 2022 15:07:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-97-gdb5c2b0cff5a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 93 runs,
 1 regressions (v4.4.299-97-gdb5c2b0cff5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 93 runs, 1 regressions (v4.4.299-97-gdb5c2b0c=
ff5a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-97-gdb5c2b0cff5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-97-gdb5c2b0cff5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db5c2b0cff5a2b35c19503639376c9dc3ed2d43b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eda77ce61a4a9221abbd23

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
7-gdb5c2b0cff5a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
7-gdb5c2b0cff5a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eda77ce61a4a9=
221abbd29
        failing since 3 days (last pass: v4.4.299-9-gf0ed06ea70f9, first fa=
il: v4.4.299-9-g7958be08b7c2)
        2 lines

    2022-01-23T19:07:22.620207  [   19.427764] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-23T19:07:22.663958  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-23T19:07:22.673158  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

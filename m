Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9601B4358B7
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 04:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhJUCpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 22:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJUCpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 22:45:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AA7C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 19:42:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso3849935pjw.2
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 19:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4pTlEQG0xUlJoxEyG5ZxJ8jQY6YgpXYU8THDEDmGzio=;
        b=J/yB5r00Wqpwbfs2B69avCYjSIgo0htQe+smF4mmZ/SN+Y8LQUW7SDMqLL8WwKI6oF
         lHe4H6yH9o7uRhaPYq8MFQMIrC171wLtEGKzG1Nd5U3vPDv+SOa/aNE3O3PpEnxIKsLf
         fQNF7XGUsUB/yIOIw0r+FBJkWxqAy8CWbYs4nSBh5ZQPo502OOOZEytz4CNkN82GfEYN
         6c8Yl3AD4dzM0ZPuwz4L4+e39YHTHHEzz6ipSP8WEN+5AwPUASSVtjyGvOeDOueQYsSX
         eDkDGNMqeVk4ikXKjp4e94H003gDciOVTtrJb3a3E1B0IhARf1AgGAN5kVm1JkOX+Pcu
         3drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4pTlEQG0xUlJoxEyG5ZxJ8jQY6YgpXYU8THDEDmGzio=;
        b=KswmgcaoY3z/CgvFyq6G4U+yifFJ0Q005fLTqaLi1nZyy2DBGuTD3QITwh72c4/xwV
         dCe1oeWOl3oXBm5FtZuMJLHm3DSxXhsxQrVh05gonmHpnSEJzj1FVVFoOWFYZSiRHs2d
         Z9Eh1tznHB/NxFyvqKeuDVMHmjJxkr3fnwJc0OGjFEQKXcxMN0GCGA7mDLF1XZu4w/eE
         0BgTrDZWzz2jbECiMCDUrAxj8atwPxwbaEzJiQCi0fRakP58I6QnMfHLtDkezB54f8i9
         5fzz2qKZTxFwd82cQqPp74pah43NbvN2MtYt4IHe3ZAdxvs8zJr0GKc28Ney/xMLiww6
         BJSA==
X-Gm-Message-State: AOAM533gvZxwlswybBvU1kuabvlCpt5Qa7qXt+g+cu62KaL5hvaiqOcr
        XqgcRxy+yDUOeEPm7WDp0K00oIqN/uyPu2Jp2Js=
X-Google-Smtp-Source: ABdhPJz+g39FnJB53cQX9+hSHfJmQeNiHImJ6wcRCoCqvEgDZ7Pew1AIE2yndVL2Vk4djMqSas0a/A==
X-Received: by 2002:a17:903:31d7:b0:13f:16cc:291f with SMTP id v23-20020a17090331d700b0013f16cc291fmr2670131ple.17.1634784178264;
        Wed, 20 Oct 2021 19:42:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s62sm3611851pgc.5.2021.10.20.19.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 19:42:57 -0700 (PDT)
Message-ID: <6170d3b1.1c69fb81.6a569.b61a@mx.google.com>
Date:   Wed, 20 Oct 2021 19:42:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.252-5-gdbf46fd54034
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 118 runs,
 3 regressions (v4.14.252-5-gdbf46fd54034)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 118 runs, 3 regressions (v4.14.252-5-gdbf46f=
d54034)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig         =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.252-5-gdbf46fd54034/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.252-5-gdbf46fd54034
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbf46fd540341c04cb7299f3735db2bff90e5c31 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61709f17ff88aa564d3358f8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-5-gdbf46fd54034/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-5-gdbf46fd54034/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61709f17ff88aa5=
64d3358fb
        failing since 1 day (last pass: v4.14.250-73-gcf46928023bb, first f=
ail: v4.14.250-73-ge93304c5bd7b)
        2 lines

    2021-10-20T22:58:16.467259  [   20.024688] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-20T22:58:16.510153  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-10-20T22:58:16.519674  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig         =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61709dad87601149e93358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-5-gdbf46fd54034/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-5-gdbf46fd54034/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61709dad87601149e9335=
8ea
        new failure (last pass: v4.14.250-73-ge93304c5bd7b) =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61709dfc438369c6f13358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-5-gdbf46fd54034/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-5-gdbf46fd54034/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61709dfc438369c6f1335=
8fd
        new failure (last pass: v4.14.250-73-ge93304c5bd7b) =

 =20

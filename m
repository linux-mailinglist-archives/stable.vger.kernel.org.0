Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DAE31F47D
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 05:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBSE2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 23:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBSE2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 23:28:08 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0C9C061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 20:27:28 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e9so2668194plh.3
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 20:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D3AqcYPmohpEhPKyFeVvdQa1zXsCwu83QsX3KwLIaiM=;
        b=1L0k2TIpPrSdeO3BVYfRManbZyqxafa+zccPe9oF1aVRQDM/wzQkSQsxu3DQMPa5kY
         1tlSpwYRP0h0GTSVk52YCe0RTd0NgrzHwA3c1SAudRl+TnHnVGyHvIm6uGNVlL4JRRr5
         vMG5wey9HPxPmiRfiNncFNq3BvjhU7SCqd2zBiq/5EU51IJb0ESgTtulR2KdWeYJlp3b
         YhX1Mzxi395TMCoJaSjdyDWtT2yni10XdwDuHERwRWjdHISSRYRjc+exGQm3jpfwTe1q
         ei0FZhavEC6bBSIVz83d1n13eBFDxY9kamAiGTEZuTkRwhqq+z2FxJkF4tXGlSBIX8he
         hHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D3AqcYPmohpEhPKyFeVvdQa1zXsCwu83QsX3KwLIaiM=;
        b=BhT2J0S+FFlDQXAM+W6h+RlT/I3bTNh7d1cctXdu/qeXLnnlKSELbLM8Mar7iDN8nQ
         Xd55pHvhNKPOesf7CVZ8+Y9jvfH4J4APGYmz9BF4JckJzvQxlyuYFnaTEuUbspnR5/Ex
         1OK04jOO0n3XG9Kstd8E2MM+FWvuW/VPYOWlpCJ1+DjujWNhDFxhveSFNytbkvkmeoET
         uaJrTzpFvThgG9aO7/hVNtLwB7gxoLzrsWIYKVzCgotEuEqaPLxSUt0qzKToZEZsl1yn
         8DKb9Cf0EF7j77q4dqfBPSYhrH84losoOOYlcgfJoDCQaRQSy4/gOAZiKtX5AFg2ir4P
         7FBA==
X-Gm-Message-State: AOAM533me29z/k4hMzhyE+miHmAJE8+DVR1l7gjDlRygJVyVI7R+56CH
        v/nmm49W1Hy24UpMWpdxxYcozqARcDI9YQ==
X-Google-Smtp-Source: ABdhPJwURdZ1O6jS1DCOaB9jTOoZaePqWZ8cqmaoO0ssTeu1WeHk6vmsfbMI61QsIzObO5f2iJzf1g==
X-Received: by 2002:a17:902:10a:b029:e2:e8f7:2988 with SMTP id 10-20020a170902010ab02900e2e8f72988mr7210253plb.4.1613708847382;
        Thu, 18 Feb 2021 20:27:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16sm7076646pgj.51.2021.02.18.20.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 20:27:26 -0800 (PST)
Message-ID: <602f3e2e.1c69fb81.65ef4.1290@mx.google.com>
Date:   Thu, 18 Feb 2021 20:27:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-g58879fce08ef
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 79 runs,
 3 regressions (v4.14.221-44-g58879fce08ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 79 runs, 3 regressions (v4.14.221-44-g58879f=
ce08ef)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-g58879fce08ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-g58879fce08ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58879fce08efcbf7757dd9a41989cb3665dada3c =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/602f32545814b90a8faddcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g58879fce08ef/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g58879fce08ef/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602f32545814b90a8fadd=
cb7
        new failure (last pass: v4.14.221-44-gba8c335d38a7) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/602f0ebe6adb6ff379addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g58879fce08ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g58879fce08ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602f0ebe6adb6ff379add=
cc4
        failing since 72 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/602f0d0c203866919faddcb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g58879fce08ef/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g58879fce08ef/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602f0d0c2038669=
19faddcb6
        failing since 0 day (last pass: v4.14.221-44-g6cf22cf83373, first f=
ail: v4.14.221-44-gba8c335d38a7)
        2 lines

    2021-02-19 00:57:44.237000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, ksoftirqd/0/7
    2021-02-19 00:57:44.246000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

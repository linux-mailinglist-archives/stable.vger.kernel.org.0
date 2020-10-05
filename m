Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C958283FC5
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 21:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgJETi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 15:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbgJETi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 15:38:26 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1BEC0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 12:38:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s19so29402plp.3
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ECR/BGCFZxB+X940XRKqGSq/zX2h+chNDhg8MK8xevs=;
        b=GYrf5/9ukjTR9E534nhPraLYtMYiWGZEiqd6IJQXND2/ZRqpgtpxVXriRpqOr7hhlq
         D6V+Ipj7erpxJDavTfoFwFeYPGbBnGGO5W2WU7Zxy0qhWwa6jhPaQqRCuwqgcu75FOuf
         PP3a6fybsLKdLLx5Ja3oC93uzrEyenXWO3LQUZ0a9O8t8PfKmIhunip+zkfF+5UIYn92
         XbxbCe9DoqDyk47NbjdmToNf4n/j5SX5+aWpP7GHEzAl/qRQ9Gbu6OqJsCtHvTfmKsxz
         qU+xwMHqO+KZiN4wYjFuvl/2uczztS3jEO8OEqfOFB6WVqLe0ag+KNIb7Y5GQfIuRmwN
         AoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ECR/BGCFZxB+X940XRKqGSq/zX2h+chNDhg8MK8xevs=;
        b=rl9UmVY7ZBxMk1zS1WV84DSPAgzk53kvfyGd4mEdalgTPuR/O/GC15ayxfHONE+aLV
         fJ9j7QQtO1csnnDRKYq3VH5qshev5LC9sWZH+i5uQ6s4eG+7PXn9m3Ti3BsqnYtXocbb
         mQ6KIijez8ayeJUjy5Oo+YwWX1wGUn3OGdxcv8625MYgvPR1uWE/NGZxbo5g2C19WkYx
         l3sav0Q9Z77YFjmQDDirZs2Mw8Y55cybpQgptO5y7XdQnsCcMuw3pU5IxwWeMG2kT7Gn
         Hx2w2krQg+gYfGgwjt5AFXfZNQoC3RzwuvFCeDrYww8FQ/bZCU+vr0GAcclf3TtMMuGp
         7sPQ==
X-Gm-Message-State: AOAM533l5Z4c9s5u/wVuZ+UzbW3EaWLjt7Pu1Og/L4WtVid5vUGITivJ
        1832tTFSEeacg1qwPIuVQxLBJALAVU9RHw==
X-Google-Smtp-Source: ABdhPJypNv2JnIrYIHw4QZvP8ps/mBiJEFGCZ+0JUHny/Qw71qdsDK7xcaCrcwjZlGO+63Dd4LISig==
X-Received: by 2002:a17:90a:e545:: with SMTP id ei5mr927786pjb.45.1601926704516;
        Mon, 05 Oct 2020 12:38:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12sm412147pgd.93.2020.10.05.12.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 12:38:23 -0700 (PDT)
Message-ID: <5f7b762f.1c69fb81.a0507.0f29@mx.google.com>
Date:   Mon, 05 Oct 2020 12:38:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-38-g9471efb6a728
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 66 runs,
 1 regressions (v4.19.149-38-g9471efb6a728)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 66 runs, 1 regressions (v4.19.149-38-g9471ef=
b6a728)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-38-g9471efb6a728/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-38-g9471efb6a728
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9471efb6a7286f61fa0994a04fa47d932d7c78ad =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7b37cf14ce1e313c4ff3f4

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-38-g9471efb6a728/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-38-g9471efb6a728/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7b37cf14ce1e31=
3c4ff3f8
      failing since 1 day (last pass: v4.19.149-4-gb110045ffdd5, first fail=
: v4.19.149-4-g55b73b3448d7)
      1 lines

    2020-10-05 15:10:19.764000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-05 15:10:19.765000  (user:khilman) is already connected
    2020-10-05 15:10:35.497000  =00
    2020-10-05 15:10:35.497000  =

    2020-10-05 15:10:35.498000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-05 15:10:35.498000  =

    2020-10-05 15:10:35.513000  DRAM:  948 MiB
    2020-10-05 15:10:35.530000  RPI 3 Model B (0xa02082)
    2020-10-05 15:10:35.617000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-05 15:10:35.649000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =20

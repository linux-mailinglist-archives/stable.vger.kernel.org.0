Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697A62C0DF8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbgKWOlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389202AbgKWOlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 09:41:14 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B42FC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:41:14 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c66so15093667pfa.4
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XdluzenEDGTISWUutFd+Z/boCdEylJNX0M2A2SpT1Ug=;
        b=D53p+RsbUu8aYH6thENtLDjWuP4IvGsXC9cbakLRYxxCvP2Ah6IpAldlpFlhnJv23m
         rHAW+jAk6Nzy+3x2sL+2PadOPEjykh4I1yta0TjKOO6nNMcM5qJcZA3eo1NGAemu0Ksx
         abhJIVbzp2VcZE0Z/L55ndaowksXe1mLlANBTuajudeix/gCzOzas7CJY0xVzLIT2LNG
         /WF/yagUCNITbhEI77vCfH5XnK+e0is/gtlgV/XLMfw3Gwqzhpa4i+ovCw7BQJNNhex5
         76CZBdbrf/sdzYRLL68EuPKVLI+ZXovlN/eckkoK4ok+DcfsNb52p9KHJCExGNZms6P/
         YmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XdluzenEDGTISWUutFd+Z/boCdEylJNX0M2A2SpT1Ug=;
        b=okvrB6VteU2oFqFDAaB2ii9QFI3ZjvCmvpDEBCdSiBmK3ELeBtQV5Y1wyMZ673o7B+
         lCV9fYsVKvZV1RC2rZPGpz3YO0Dv3zZn9JSmI78C8Z8Er2I9TLT35jRKvR6mONHMyFJB
         FdkSqXthAqVn7Vh0rLP79hfIoBW8q1dvFZRlsBUue4T9nbz/1fvELI/0EYN+0v94lskg
         5Ju5Kfq5Yf5wfjNVyjknD+NrUpGhn+OJhOSesV0egvbyo7gp5yj6lxC3q+fIuakTHMmS
         zGE4jENHsb9c2PuKSELojHRVUBk5Dz08jG/OmTwAmR66TDH9fgxqHMr/jz/9sbuHygMz
         miyg==
X-Gm-Message-State: AOAM532wg3rjI5ly8Zq9xE7obLjkDnqI2iMMbDFW3aYgB7sqgtycEdaU
        1jmvi1usOjfLe+mGMb/DaaC+YnMlEdxQrQ==
X-Google-Smtp-Source: ABdhPJys8HlFzzxYzFCbN5sjbMERZc5gDM2ony7Beigsdlxpug72TYpG35wm4eRM2faOGiLKcHSc+Q==
X-Received: by 2002:a62:2707:0:b029:196:38ea:9848 with SMTP id n7-20020a6227070000b029019638ea9848mr24538113pfn.50.1606142473649;
        Mon, 23 Nov 2020 06:41:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15sm2375587pjy.47.2020.11.23.06.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 06:41:12 -0800 (PST)
Message-ID: <5fbbca08.1c69fb81.f8f3f.3fdf@mx.google.com>
Date:   Mon, 23 Nov 2020 06:41:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159-91-ge3ab2e9b1083
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 125 runs,
 3 regressions (v4.19.159-91-ge3ab2e9b1083)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 125 runs, 3 regressions (v4.19.159-91-ge3ab2=
e9b1083)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.159-91-ge3ab2e9b1083/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.159-91-ge3ab2e9b1083
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3ab2e9b108329cdbaf14fc9770ed200d399c0c3 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb959f7c9a8389b7d8d920

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ge3ab2e9b1083/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ge3ab2e9b1083/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb959f7c9a8389b7d8d=
921
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb95af7c9a8389b7d8d9a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ge3ab2e9b1083/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ge3ab2e9b1083/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb95af7c9a8389b7d8d=
9a7
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9616fceabd96ecd8d91f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ge3ab2e9b1083/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ge3ab2e9b1083/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9616fceabd96ecd8d=
920
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20

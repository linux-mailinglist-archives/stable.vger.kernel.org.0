Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867534A9D9B
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357239AbiBDR02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiBDR02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:26:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340AAC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 09:26:28 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x15-20020a17090a6b4f00b001b8778c9183so757541pjl.4
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 09:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OSX6L5IwaXXJk2gUY2ATBy4MnIRY38gzCq8lrOJL75s=;
        b=n/yRnfZw3oGR2nYZAyNZsVVWD5sn6wgNBDZPQ10l7fm0339dIjxUpEh5QSDln91FLG
         xs/dmgqj4clzSrNJ8oK2pIvgPqz0K9OAplfkKXb2v/98M7MZ/9az+202Ro2t/JDbBG+Z
         oQysBKYV/zIp8S3BsYC2PuQedry2m7JxfoOVjBZxZrQ7b3UGIJTfIuVB7tht7oND8C/I
         Oeao72NVbzzLypyc5gWN6taEmlqj93XhSNBtt0JdHEaZH1pUww1N3qpVI/4jaWZnlatM
         5lNNzn+4geSNj710g8DduzXhAdHWHdqKVzvDbfjM7aZlua0pU49RTiEQX7h84qy9UbtA
         RcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OSX6L5IwaXXJk2gUY2ATBy4MnIRY38gzCq8lrOJL75s=;
        b=tzMMYWlmlzVHhQ/mTW7kuq2q2hyKRObXpjc/5jS5SkfJ92X3yjFuvr6mTFw6LtrM5S
         z8QW4IHbuKa0tbsNYApq3QhnpoeQuv+PQ9XHwz8/VBCLT6baLIXb2wFtqVTZoqpojCEu
         +MeianD+KSXXcLqWTXddZiVwnjhIrio6uNgBjZMq6fBBsId0IStsxbi5lJo98kf6Kr0r
         Aw7DOtsErJTeqUNRpvrE7NNF9QDby0zi29EFck3aKSOcN/dLj5WyEXZPMzoSrVI202Cn
         GEwV51waS5V9TiNntiUjSqsoalmcfVaQDPRRvi+mWyc+jI0eoZsC8BG3Yng0VZ7R7mt8
         p5YA==
X-Gm-Message-State: AOAM5314CkjJU1KJLGd+XiJtxTi8QKU9h/ZpyLo3VsUf5tAXMJnyh2e6
        GfxRUjhhuZjVmnFdmZ1YNGbNU5xGjJ5fGLPT
X-Google-Smtp-Source: ABdhPJztXI47f/vfHmWlA3y3F7SaBaGQmvjjYDEPkb6L0pnGjYmGDbVTqsIC28X0p6aDzCMiCYNJBg==
X-Received: by 2002:a17:90a:d907:: with SMTP id c7mr11331pjv.245.1643995587491;
        Fri, 04 Feb 2022 09:26:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm3099265pfc.0.2022.02.04.09.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 09:26:27 -0800 (PST)
Message-ID: <61fd61c3.1c69fb81.35e13.7fca@mx.google.com>
Date:   Fri, 04 Feb 2022 09:26:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.96-26-g847fbfddce32
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 150 runs,
 2 regressions (v5.10.96-26-g847fbfddce32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 150 runs, 2 regressions (v5.10.96-26-g847f=
bfddce32)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
hp-x360-14-G1-sona      | x86_64 | lab-collabora | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.96-26-g847fbfddce32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.96-26-g847fbfddce32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      847fbfddce327344933153bb39a4379b080bede7 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
hp-x360-14-G1-sona      | x86_64 | lab-collabora | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd299f11df3b48fc5d6f39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
6-26-g847fbfddce32/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
6-26-g847fbfddce32/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd299f11df3b48fc5d6=
f3a
        new failure (last pass: v5.10.96) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd2c99c95fefec135d6f48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
6-26-g847fbfddce32/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
6-26-g847fbfddce32/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd2c99c95fefec135d6=
f49
        new failure (last pass: v5.10.96) =

 =20

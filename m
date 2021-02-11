Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03218319532
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 22:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhBKVde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 16:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhBKVdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 16:33:31 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E6FC061756
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:32:51 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t29so4514715pfg.11
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6IJOgGnvTdTdAN8eLkzPe6EKkUEA60ttGH/iPmZ6Zjg=;
        b=ip/iBC5tx7by7AKnNhl1MsTt290LwTi2n6o0DLwM4nJzJmFl1bpw0DCQiQiHGBKvLw
         HnA6dLkPzF94kyP9OKLqmDmr0XZgsW2zbYYlcEncdSqzdJBispnnyT4IXRijeVfhxTbS
         dIEX3hE3Q56WRDTEF5s24sZQKL/5Mu3SJ+dCQn5P1Qz0bs0R+dwrDJmAZCw1fiVpJRCv
         DxJPU93mI5r3or8NlqN5dViTg4/U4bgFXbsMFEdR+blwF2qtdUWelG+Ga6vqIJUK9G5L
         gLNF8XgeRyEtHmqmXpY40q828P8juM4aP1FZLKpyAwpLlU/fMhm/F1ySh9yqhYn1MM6K
         UCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6IJOgGnvTdTdAN8eLkzPe6EKkUEA60ttGH/iPmZ6Zjg=;
        b=lrSqtyXoOpL94zFTeqz+W+C5FTQJGjPDDe1PItMGVZ8SRvSDZc28mQ4pWC//QldjkC
         kRTbtXUQiju7yHVkE2A/3zAiWck1FXVMdnhXdxnrL5IwF+qnP8aSEFNKKoceUMpSfOxb
         Q0QLwK6+Ko5D3A2yjnZ8j61M0mJQF5wFVD+3P5aN08BnRUZLSemw5c1xni75+Obbq4HB
         gLck+0yjlQe00sWhB/7LeYcRbf1O45KKel3b74w7X4M1Bl9QxCYW2X/gB6m2DAI2whkr
         Cnb6fyQyC3k8QtGA7FDQ/9uTOCH711APb55hcec9PbLSYKyELRYEIInTy5Qi0MVMixm6
         cliA==
X-Gm-Message-State: AOAM532TN5P8Fk3wsEHwl23xTpIliAgR4YhcpRh6ghmj8cn14ygqffP4
        j0GW7W75jwdrIzaUfaEekT35Udhv8lR7nw==
X-Google-Smtp-Source: ABdhPJxpgfnKStE8bRNswrERC7Ut9IEclFsnG8lR7R6pvbu9K/px7UhmcEB+3JznOKt/ECA0XNgZDw==
X-Received: by 2002:a62:8057:0:b029:1e8:3768:7661 with SMTP id j84-20020a6280570000b02901e837687661mr724072pfd.37.1613079170682;
        Thu, 11 Feb 2021 13:32:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21sm6710356pga.12.2021.02.11.13.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:32:50 -0800 (PST)
Message-ID: <6025a282.1c69fb81.a38f0.ec20@mx.google.com>
Date:   Thu, 11 Feb 2021 13:32:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175-25-g30e16c3fd5ac
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 82 runs,
 2 regressions (v4.19.175-25-g30e16c3fd5ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 82 runs, 2 regressions (v4.19.175-25-g30e1=
6c3fd5ac)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

sun8i-h3-orangepi-pc | arm  | lab-clabbe    | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.175-25-g30e16c3fd5ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.175-25-g30e16c3fd5ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30e16c3fd5acd42264d873aacb75891f3cd202c4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/602570e21e925590e03abe66

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75-25-g30e16c3fd5ac/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75-25-g30e16c3fd5ac/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602570e21e92559=
0e03abe6d
        failing since 2 days (last pass: v4.19.174, first fail: v4.19.174-3=
9-g69312fa72410)
        2 lines

    2021-02-11 18:01:01.553000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/102
    2021-02-11 18:01:01.562000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
sun8i-h3-orangepi-pc | arm  | lab-clabbe    | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/602572760842c9ea503abe73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75-25-g30e16c3fd5ac/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75-25-g30e16c3fd5ac/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602572760842c9ea503ab=
e74
        new failure (last pass: v4.19.175) =

 =20

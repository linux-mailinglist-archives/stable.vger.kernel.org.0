Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2199129153E
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 03:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439889AbgJRBcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 21:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439888AbgJRBcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 21:32:03 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A666CC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 18:32:03 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j7so3801021pgk.5
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 18:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UgjaVrTS3I8dHrfK/SSjQozD0+rDNyn1etc91L8y91E=;
        b=WoyS8e6ciTTI2OAloqW75JnvLBbVb9/WlRhkADUpWVGceBzddDFA5DaRhUB+hC/jFW
         CYRIocObn1sa8I644wgSZGNNhflA0YMQDA3yhyBV8tp8N2nX4Yg1TRk6SzbozhznKrgR
         v5iEkpC8T/Gk8Uqy1bgOrFtwEsNUxZ7kF0Rt61FqDSQoPOi49tj8YJHUHzWD6K+eAF2b
         /yBoXdlGTnq5g9NSXOjpE7gbP/e6PMV4Os+kNgIdP0BFM41Col1sl7vJQkzqiFkRwPCh
         cbIREPGCXwRV4VEwuKWD4CBPXxkU+e5eY5LsZP6sqcTFcEWXrNlO+Z3oO3cYNCBk/wXn
         Xhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UgjaVrTS3I8dHrfK/SSjQozD0+rDNyn1etc91L8y91E=;
        b=dxi+GNvv62eq1hCHhK8IopQoe1HfT6WiOjQLZgVwnmZdyhPydV+GLhypFaXjy4CEhV
         HzS5F826aPR5i/YiOartH2GfFl4XG4l5nOQQIAhouUCD2I/FlUd2sna7HAa2VHDFXkNX
         lglhB9p6CdmcRXPAms4N8Afjte9tDhRZtW+fqE7scW9ZUwgDeWFlukY1FK8FH90aXTXX
         AQ/1Qqx7JX6hVGg6ImeRQGFHZzbAT2UoV800KUuss3oTlXOKmKTIvcreeU8rRcI+050h
         TpMud/AtQuROeChjTFbPGifLX+u8ZUEX7m5wbsYYWtPoNSZwGNZUPBZwvRDjGL/2hyI3
         a5Tw==
X-Gm-Message-State: AOAM533JkXlm1ko8hlwurMA/BYsS65tmsrqoLlYDvUbc6wpEBiu6vkee
        Nvr+OROJ47zop39idMQokBFlNquf8HYQag==
X-Google-Smtp-Source: ABdhPJwYfhF89mpWoKokyQE5+Tzm653B4HMVZT8ZSPBg8GYHVmC9TRLF3dybF90SpHSFzSM06GmbDg==
X-Received: by 2002:a63:c50d:: with SMTP id f13mr9129856pgd.118.1602984722703;
        Sat, 17 Oct 2020 18:32:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i17sm7106896pfa.183.2020.10.17.18.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 18:32:02 -0700 (PDT)
Message-ID: <5f8b9b12.1c69fb81.3774b.f45f@mx.google.com>
Date:   Sat, 17 Oct 2020 18:32:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.152-15-g0c6e01c98d43
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 185 runs,
 2 regressions (v4.19.152-15-g0c6e01c98d43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 185 runs, 2 regressions (v4.19.152-15-g0c6e0=
1c98d43)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-15-g0c6e01c98d43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-15-g0c6e01c98d43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c6e01c98d4348124fd5c5da4103b5f2bb0e271d =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8b6147cd503c2fe44ff3f7

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-g0c6e01c98d43/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-g0c6e01c98d43/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8b6147cd503c2f=
e44ff3fb
      failing since 0 day (last pass: v4.19.151-21-g3d5eaa44a9e0, first fai=
l: v4.19.152-13-g2b9cb7715a7b)
      1 lines  =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:     https://kernelci.org/test/plan/id/5f8b62b98cf59f15454ff41d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-g0c6e01c98d43/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-g0c6e01c98d43/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8b62b98cf59f1=
5454ff424
      new failure (last pass: v4.19.152-13-g2b9cb7715a7b)
      2 lines

    2020-10-17 21:31:29.301000  <6>[   22.739898] usbcore: registered new i=
nterface driver smsc95xx
    2020-10-17 21:31:29.330000  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2020-10-17 21:31:29.339000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20

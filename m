Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3959381F57
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhEPOxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 10:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhEPOxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 10:53:48 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A18DC061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 07:52:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso2331806pjb.5
        for <stable@vger.kernel.org>; Sun, 16 May 2021 07:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UAkiDi4KQkOO517mIdc38OUOA7naetNwm+AaLndlBV0=;
        b=WmypjAy+GOEB54bS2PfuhhiCugsmrTVAoh3e+1F23zxp2V8wfuaE2rJy7rF8Ldml/t
         atzqJXHpLxvZ7eLGrXV8YyhR/1V+MDX5r3kbzPX7jVkyN+qIz+2YoBORBygMuQ9QLFbi
         XAUkodksiN7wKk4V9x20sPbr/4tYq8mNNKcx93t3fM+4uYuMoyzKQSt7CiD2Om+fLFBH
         D6w7ftjHghaplLJ57mb3IKtpSD0jU+lGsIf4N+pfw9HxZj3P+kZkQWq908W+b+shL5QN
         3a1DK46ZmdelJ8TkBattdOAbagbB90Wx/sc0No1Eh9wpC9ISbGxKNpuUhtvZFdk9SFRI
         VaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UAkiDi4KQkOO517mIdc38OUOA7naetNwm+AaLndlBV0=;
        b=exrBmq1zkBoB113mX6BAls446j8FAe6pWHK6uxqxYvIWNyvYqfJoTHAoFrs2CZQVca
         NS57s8dy91JIOYazcPFcfR2XhnQoO6kUeZ++Q18n+X12563VKzAHbckxXXHZ3XpNzQPJ
         xzjBkcFV4Fwoh2M/IALoalfiKOTXXh8efyEH6eopLL8Ko0Q8ysM+kiGzq296B9QmOaxF
         ZZ9ZKNSc01PFerb3Nrt04rF1GRHQnqQfRC/x+EERbTHeI54zzAIRxLQgHjR91mLJrypO
         Qo2+W0bYhwfjeuTCyPePTVNzxoqEjYrq6jlnx4eu3v6VqpFn98ouaqG0g6cvLe5SRwmH
         rixA==
X-Gm-Message-State: AOAM530jEleUPcbg5fbN+D3TVIexLGfTTfWpRcUVHViMD/pqKGQfJEZk
        vRXfmYNX3Upn0FF2M4ILhuclchiu/Zdvhsao
X-Google-Smtp-Source: ABdhPJxOfBfjJPjUjX7b9EtBMA0vZPLG/3c3u+hwZmv+cw5KCR/YJ+RQCZaJQg4RVYxb+S1Z56sD5g==
X-Received: by 2002:a17:90b:2307:: with SMTP id mt7mr21105819pjb.131.1621176752496;
        Sun, 16 May 2021 07:52:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t22sm997053pfl.50.2021.05.16.07.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 07:52:32 -0700 (PDT)
Message-ID: <60a131b0.1c69fb81.b050c.2a70@mx.google.com>
Date:   Sun, 16 May 2021 07:52:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-369-gd9cc666b4bdd
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 115 runs,
 4 regressions (v4.19.190-369-gd9cc666b4bdd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 115 runs, 4 regressions (v4.19.190-369-gd9cc=
666b4bdd)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-369-gd9cc666b4bdd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-369-gd9cc666b4bdd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9cc666b4bdd40ae451a2acd4c089506348f8666 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a0fe5b7aa15ddd20b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a0fe5b7aa15ddd20b3a=
f9a
        failing since 183 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a0fe326010f1f7f7b3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a0fe326010f1f7f7b3a=
fc1
        failing since 183 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a0fe896a43a33a0eb3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a0fe896a43a33a0eb3a=
fa0
        failing since 183 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a0fdaab1c6d2db84b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-369-gd9cc666b4bdd/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a0fdaab1c6d2db84b3a=
fab
        failing since 183 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20

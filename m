Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E9F3C411C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 03:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhGLB45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 21:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLB45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 21:56:57 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5504C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:54:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v7so16650199pgl.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7XqVbM4DacQaYm2af+ZYhj1bFKhIxYK1GS+I47rW7js=;
        b=qMUC2jVyfkIgcLQGmfuIffaxJZig8zQBkVxpZw1gLeUlqC0PPCZPaZixkywJqtBr0a
         LbxngZIi//P0n2X+dwq0K8QzQ4+MqHtmIeXNu5YKrsNnXrw7S/Z8D03eJhVdDzVdyesp
         IEpsQZ9RSzBqY5u1W6SathQ0leTEFxE1NpoqpIDxuF8U7ZgpSHr4bG+hAJdGTMsMayGt
         LEeB85UZ3PGDEwj6BmA2bR/fkRax3jNYYX7Bj+e/zazU20Nifg8POGY9jFOI/XSu53/O
         X2JtAGHS5+4nRY42sQcdmV5bqZ64hZFDsMpBVIsU2Lj+N4K2nxtCTIRxzQoupafw1OKB
         evxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7XqVbM4DacQaYm2af+ZYhj1bFKhIxYK1GS+I47rW7js=;
        b=lfH0utRIbgWWOdhRvZQrb7tkEcEoEIrDJnL+wCwR9s1rq2kMY+H+LF8FmFmMSIYC6e
         9VPyc8WuZihyLG+w6w+LWmjH4ebpsAQQhuLh2TBqPf43KFEsvjR4hSpMaaIetU+hhF2p
         1XaRiAXRtHTOcEGE+xBVeQpXyb4QTSFcCrwj4F1egw/e+WFRhlpbLeS6vMvK+0W+Hv2V
         5CcLR3HT8bM15TuymcHnBzUW1HYQco9F5GLY2vljmXRKzZ8zEwo6ba9z1yXAG+HjD+iG
         JR1pzA/CBwXbtwPpvkyxySuoB0DFHJg0WJEHijzdEnOMHv3ZCVHsbwlfOfof8DXYBP3/
         YcmQ==
X-Gm-Message-State: AOAM531hnkuGX3wFo9t9Jb8PH9drjsC7e1dtE3p38eNyl2WE/MwkpiqL
        H8Tc8ycGYS1IOll1b4iHWJkz2nHzl85+X+q2
X-Google-Smtp-Source: ABdhPJy467p/Xs9lajUkGyvZdIRQlB+WFux/MfJy7nkfJlgz9OrcekSAn+QzAg5xWme2UO6llBTZ6A==
X-Received: by 2002:a63:f84e:: with SMTP id v14mr10808007pgj.184.1626054848061;
        Sun, 11 Jul 2021 18:54:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm14902021pgv.52.2021.07.11.18.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 18:54:07 -0700 (PDT)
Message-ID: <60eba0bf.1c69fb81.74c1e.d83e@mx.google.com>
Date:   Sun, 11 Jul 2021 18:54:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16-701-g5072f01b4ddd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 140 runs,
 5 regressions (v5.12.16-701-g5072f01b4ddd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 140 runs, 5 regressions (v5.12.16-701-g5072f=
01b4ddd)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
bcm2837-rpi-3-b-32      | arm    | lab-baylibre  | gcc-8    | bcm2835_defco=
nfig            | 1          =

d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =

hip07-d05               | arm64  | lab-collabora | gcc-8    | defconfig    =
                | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.16-701-g5072f01b4ddd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.16-701-g5072f01b4ddd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5072f01b4dddd6fde6660af966dbd8632e8b04df =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
bcm2837-rpi-3-b-32      | arm    | lab-baylibre  | gcc-8    | bcm2835_defco=
nfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6c3ef4cf883be111796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6c3ef4cf883be1117=
96b
        new failure (last pass: v5.12.16-701-g2f79637ed64b2) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6b8682de4309a611799a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6b8682de4309a6117=
99b
        failing since 0 day (last pass: v5.12.15-11-g1a88438d15d2, first fa=
il: v5.12.16-682-g36eea3662e2d) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6cdbdf6deacd83117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6cdbdf6deacd83117=
979
        failing since 0 day (last pass: v5.12.15-11-g1a88438d15d2, first fa=
il: v5.12.16-682-g36eea3662e2d) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
hip07-d05               | arm64  | lab-collabora | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb7a2c4d88756e281179b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb7a2c4d88756e28117=
9b1
        failing since 10 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb70c2b9728f7dc1117981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g5072f01b4ddd/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb70c2b9728f7dc1117=
982
        new failure (last pass: v5.12.16-701-g2f79637ed64b2) =

 =20

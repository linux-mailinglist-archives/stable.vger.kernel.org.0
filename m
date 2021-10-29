Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE07743FE8A
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhJ2Ohm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJ2Ohl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:37:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D5EC061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:35:12 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l186so10066663pge.7
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0nb6njtW0otn71Jj0rfikYWV6MJRYkD8I/HZClZZSF8=;
        b=NP6hfU0gQI1V0EVJsGWpc2T8RZ53lWIteyTtxHwRmHhlRN8jTHBK5hlPaN13lFzhQd
         zxtC/bgHLsokDqNIS4VgRJVnX2gbGamCkUgMzbye411+YhtabExSXaM/GdRdwmIFv+8V
         rTPB+w+ts6aurPLMrM5qec1aP3aKc+QB0d69V2JpgnPZ4e2e4XH+y+t77YWs27g5sADY
         HSi/+DVS9Rs9yoGoWgyQuXie/Dv/fTcMFrMxsLk5tBwZ3nB81Vx0CySKVQUEWZNl7GWB
         PA/8FJQb6iGtS9mb3zk1LfUY12BiyN7gwVfdogaidnJ6XXZMuDyJGk1kRe0uY3d5d2kw
         eyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0nb6njtW0otn71Jj0rfikYWV6MJRYkD8I/HZClZZSF8=;
        b=lzxnsZgYduxxR5OD/KAnox4JHrByN7gUTFIrUwaSJ4r9BCclOOTThUqBIrO3K4AnAl
         ednmi5cBJFVs1RnToQpJr8lycjmLEKNfsxdlR5hd5dbzntEsDYIW64EdR7LtBVIr6VoE
         pKDd9nJtxC2lo1DoKw/9kJ5csNikHBO+AqfuznxfnEJfQP46aHdx2UVqvRVrI+5/xVvo
         92Wd/UF6tPRCE9F+51AA4u+mJ+zsDWogWrgssso43qsJZpz0UhY+3lJFguX5p3T23HX3
         FFcjJxR0GBNSLj/0RPRrV5oQbD7R4I1NEtsrYmP+sLLa9cgZLsIFk4ycVbo2zN4KQkEU
         AN6g==
X-Gm-Message-State: AOAM532f/9LEEkxzq8OOzwsZrSlR7d6kaU9RxDBDsITtNGaNZjSr+FBk
        rOIRPwVila4W9SHXporXeWpAtYcXgRUjFPMg
X-Google-Smtp-Source: ABdhPJyHTjokJAqUn8nPkCd2kk186yJNy/od8ngdzq/X4ua5tKnrPcguuNRWnWNN0Mlh21zSaHJkvg==
X-Received: by 2002:aa7:96d0:0:b0:47c:efd:9ab4 with SMTP id h16-20020aa796d0000000b0047c0efd9ab4mr11463588pfq.30.1635518111818;
        Fri, 29 Oct 2021 07:35:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm7550477pfc.202.2021.10.29.07.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 07:35:11 -0700 (PDT)
Message-ID: <617c069f.1c69fb81.c4b14.57da@mx.google.com>
Date:   Fri, 29 Oct 2021 07:35:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.214-12-g143e6d0d992a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 147 runs,
 1 regressions (v4.19.214-12-g143e6d0d992a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 147 runs, 1 regressions (v4.19.214-12-g143e6=
d0d992a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.214-12-g143e6d0d992a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.214-12-g143e6d0d992a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      143e6d0d992a82c90fe7ef0cea1c6434e005cfb8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617bd135582f28976d3358f7

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-12-g143e6d0d992a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-12-g143e6d0d992a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617bd136582f289=
76d3358fa
        new failure (last pass: v4.19.214-7-ga1dea1931bd1)
        2 lines

    2021-10-29T10:46:56.533753  <8>[   21.088287] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-29T10:46:56.579536  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2021-10-29T10:46:56.588886  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

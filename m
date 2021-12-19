Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D969E47A21B
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 21:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhLSUkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 15:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhLSUkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 15:40:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B155C061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 12:40:22 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id t123so5570648pfc.13
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 12:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rqYnZ1J2WgWNheTEQsuhnsbhssc8j/ZhcJ7Hdf/5ZL8=;
        b=2CnulMUbtS6mAe4qMj+jbajJwS+HEiByiVJLD49lIXOSI5Hf3q9yESJeGkjBHUNGhA
         DSbw1J7kB4Tns3PvvytCmOK+LG6gpdjoa7sHr8wKoZRzID5RiXbyFaQmAWB4G4ydYK79
         QmBZa5iWDd/h/6sgHRTdZFiO2Rckym4ZfMKPwYCRQv8+usPc0Fxwbm1z/HTpT75fZqct
         JGxDLTpwN3z7VDbOiBNM1pXr/uxjbrxooFj23fRUKB1ti+/F4K7lM0+0AfvYKT5BgGQI
         A1i0BfG6YRO+Thkj7Cr/kFr5KbZCxNUZkoMJ6IO2IuVEIOuU05lBClUt132eQSquhEUq
         xPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rqYnZ1J2WgWNheTEQsuhnsbhssc8j/ZhcJ7Hdf/5ZL8=;
        b=H1VkZrmptrsgjPMun+3k8EqJkbCQDOLgZ27l7e3tDVWhpb7sa06O9Sq9GnV0AQDjy6
         Dyir8iYhnz20X7kBB/3X1E00I6Pojw/UXdP5j7ITLElpicgaVbltjGoO/ENJAZr/BKxc
         EPBc07LUGQO7s+pFAGeQzDhGxIz0sMc5ZgY0zoJ9XA4QCS86x3KEsZssyhwkYV7ZNjAY
         7aZr28+5lvNGuLBsSBwYhisVyHkropOmHehc9cl9UJZ4ipwJQre23xTRV3GzZRiNTNav
         kURPKC0mD8DE7gB6K2BVaupOyhxM65dKfpHTzXzTyiRFXnTnGbKpTBGc7savQpcYQRcz
         Kzlg==
X-Gm-Message-State: AOAM532c3wLuchUfIS2bW/KHYfvn++8JNNLHqz+lRJ8kJKG9X/IoF5Im
        6ymLWecTxQL+iM4YkXZgQkzb9m/kr6K/Fw6O
X-Google-Smtp-Source: ABdhPJwT6lOaWdqOrp5YwwsikMpp1FOc2LGAcYFn5RJ554yMET+mdADJq+gvYlZ0jv9rgwhUglUFrQ==
X-Received: by 2002:a62:c103:0:b0:4ba:75b8:cf69 with SMTP id i3-20020a62c103000000b004ba75b8cf69mr12947866pfg.64.1639946421480;
        Sun, 19 Dec 2021 12:40:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15sm14617066pjq.2.2021.12.19.12.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 12:40:21 -0800 (PST)
Message-ID: <61bf98b5.1c69fb81.77ef.8e52@mx.google.com>
Date:   Sun, 19 Dec 2021 12:40:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-11-g16c28781820e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 117 runs,
 2 regressions (v4.4.295-11-g16c28781820e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 117 runs, 2 regressions (v4.4.295-11-g16c2878=
1820e)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-11-g16c28781820e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-11-g16c28781820e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16c28781820ec755f681cc0a8dd2cef3112ba83b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5f82477df0f5de397167

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-g16c28781820e/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-g16c28781820e/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf5f82477df0f5de397=
168
        failing since 0 day (last pass: v4.4.295-9-g7d306649b59e, first fai=
l: v4.4.295-11-ga3118690cea0) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5da3e815672c2639711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-g16c28781820e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
1-g16c28781820e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bf5da3e815672=
c26397121
        failing since 1 day (last pass: v4.4.295-6-g6cb713214ea5, first fai=
l: v4.4.295-9-g7d306649b59e)
        2 lines

    2021-12-19T16:27:58.971244  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-19T16:27:58.980360  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

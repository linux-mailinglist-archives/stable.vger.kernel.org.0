Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE0B4583E2
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhKUNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbhKUNwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 08:52:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37098C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 05:49:04 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k4so11818830plx.8
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 05:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RNsimGl+J0EJi8ZRb2ikJXum955q5PU6yhz3OVmCofs=;
        b=ag0HyPimMLejhBtlvmHs9tBjHuBCHND9ZgmThBMJiWW1ke7AU6UnjBgqHThL0fjclV
         HY3GNJJlbMi6OKT6BLjOUh/FNC+ffo4C/Encik1pmB63uhMbpyWPZ60wO2Hk7Dlxc8iB
         bWOnnfqL/GrwrfR1v59PpSGHyEftx4NOjfC3XZuuBBlntP9VzFoyf96RZtAUttall78Z
         w7yw20a3yETWE4CDdndzFNS5+mrkmRRRXwQWah7/OdN0d06DCLayiIOQcN/34o7k4L7+
         BwBc5kWHPcP6rBQHjODSYPOu/j9NsVAFongNivJEKm5xjN6ci1tp75eC0Y6FSMI1igke
         kVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RNsimGl+J0EJi8ZRb2ikJXum955q5PU6yhz3OVmCofs=;
        b=vSn8A/fF+vGeXrh9gicBeBMz6ApUva7XBW9NIyVL8yxlxnwvRUoNB74jovGdEeDSXS
         OhkfpeO0kQ6jNPHMHXVjagmdlhjuU4Mj4HGy/zvLTv2zcTjVYIgZ1mWeQcFCnTMex5s0
         5IyhiCby3uf527R2r5+F14vDBYm24b7xHlFle43/KkigfMVyehL1Bn99mjpIZOrYTh0i
         X4RjCZfamOKmlurxYNKAeuWwBQfSgPWzl5kxHTHbdaFF03JSvag1erhc1rKaDgk/roGd
         YwVZ1prHj/lqtdMwhEPQksAVje1maLYlGut2DNqF97XGgCgbojixZfJbpJMU73onq0p7
         /PwQ==
X-Gm-Message-State: AOAM530kpqcH73Ggg0KS7NqnQr6vul1XViYO0T2AUik1fU7RwJqYiJIf
        M6EMvZ/GhXAKqqDg+ArD/cEpL0WKl9klgORf
X-Google-Smtp-Source: ABdhPJxRYSkq95JYD2a1utU5ZQsobeCOZO+kMsVv3iYZLcU9DECiwg3UNUpmnpJXJOeqR+9htb40Iw==
X-Received: by 2002:a17:902:6b46:b0:142:8470:862e with SMTP id g6-20020a1709026b4600b001428470862emr96607810plt.49.1637502543617;
        Sun, 21 Nov 2021 05:49:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z71sm5870514pfc.19.2021.11.21.05.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 05:49:03 -0800 (PST)
Message-ID: <619a4e4f.1c69fb81.afdbb.1427@mx.google.com>
Date:   Sun, 21 Nov 2021 05:49:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-161-g520a4edb46f8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 133 runs,
 1 regressions (v4.9.290-161-g520a4edb46f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 133 runs, 1 regressions (v4.9.290-161-g520a4e=
db46f8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-161-g520a4edb46f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-161-g520a4edb46f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      520a4edb46f8ec97d5f22cc3dc446d651fd6888d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619a1a70a0169fcea3e551ca

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
61-g520a4edb46f8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
61-g520a4edb46f8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619a1a70a0169fc=
ea3e551d0
        new failure (last pass: v4.9.290-161-ge496b1c75ac2)
        2 lines

    2021-11-21T10:07:26.150049  [   19.868804] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-21T10:07:26.201270  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-21T10:07:26.210228  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

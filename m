Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27659468DB5
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 23:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbhLEW2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 17:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhLEW2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 17:28:30 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D12C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 14:25:03 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so8176125pjj.0
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 14:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=setQAIuc3tLTlmnkCP+WgDgpSU7oatAI7FLbvOg9jhM=;
        b=UIl/rY4QUxDEQItUBp2YJa81U/1hQgZughyI0eKrAGpjWqp8xLiNIq/vXZlTeMOVOb
         8Xf1A04piRVbCcNPeiEORGttL64mbVPgtWWC4TJF+Gy2HUivXqIaEZ2qh86HA+J6cAkc
         2m1ViLEeviwkJm81zmcYvpfOLiHzI8hFWQD/XmH+jc2AJyxM9Kr60CUq5u4EDhPkqI6L
         si4gcGkzGhQ9mmh6iAIdkO10sSkiSG3c2bm3g0xmxY/9LWaV5PoTbPq8QP9qdU2rbgMo
         0HqDCucYb7Eq4X9fYrRTFtKyKFEU419rx/zX3r6z2uJPyHZ+7Fgx/7HRY2nlHkmZlIu8
         9xpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=setQAIuc3tLTlmnkCP+WgDgpSU7oatAI7FLbvOg9jhM=;
        b=egdcjSYlYhof35k26+xDT1he2K7dZ3IUHYzXzWXmDNnWvcRZGmhb1BgevXq74oKGwi
         b9HUiMoHRKXxn23MWA3P6yppO1z2RmnvVSESIjRn9YM9wsZqyLmPCo+iLY5CUL5gtmHC
         4Zd7y4bG+2x1FAL5eFPtdyDNVJJCs4L97wTO+q6C6yofCI24bliEq2DcgozbfkC7PjLH
         2OJ7Hf3CnTI0eWzb+1e62CrJgfF7Jh+81P1uYIs7o3RJ2/n3EF3vNPSIU2bqPy57Onrw
         rU6fapyFaJLSgPkG3oGqcQEQOwEN7Ep8vCkBBo60Ej3a+gINx8yxtNVosIXzBs0Qv1bg
         hVRg==
X-Gm-Message-State: AOAM530VvNTs3UlAeQlPqxQ22NLsKOJYkVqlYF7MWk1Juz68sM5ABJ2n
        T0KjpN+86WnSbAmcdlgywbl7RuXF9MbC8BnA
X-Google-Smtp-Source: ABdhPJwk92vrq3bQTh1+X4lXH/gmoplgcxH2Px678Jk4LuY9zaBMR7B2Ft7wZ2yt133qfJmMLMqivw==
X-Received: by 2002:a17:90b:1c87:: with SMTP id oo7mr31755647pjb.159.1638743102366;
        Sun, 05 Dec 2021 14:25:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm9989830pfv.89.2021.12.05.14.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 14:25:02 -0800 (PST)
Message-ID: <61ad3c3e.1c69fb81.6a2f.d39f@mx.google.com>
Date:   Sun, 05 Dec 2021 14:25:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-58-g806c3e48c0caf
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 83 runs,
 1 regressions (v4.9.291-58-g806c3e48c0caf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 83 runs, 1 regressions (v4.9.291-58-g806c3e=
48c0caf)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.291-58-g806c3e48c0caf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.291-58-g806c3e48c0caf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      806c3e48c0caf66c1f1deb4f7cdb45d9b3534611 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ad05504a4d7c01811a94a7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-58-g806c3e48c0caf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-58-g806c3e48c0caf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ad05504a4d7c0=
1811a94aa
        failing since 22 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-12-05T18:30:20.275185  [   20.336517] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-05T18:30:20.318882  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-12-05T18:30:20.328130  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

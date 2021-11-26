Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F445F709
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 00:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhKZXEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 18:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245508AbhKZXCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 18:02:51 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E66C06175C
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 14:59:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n85so10156281pfd.10
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 14:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lYSZ2XOx9EImprIh+D5/ewBfr8WHKR2xlkYUy9QAcGY=;
        b=DOWhhaDyRB0ahk056KMNOKq6dnQfi0SsiwysAEG9vPP8TNKhXuq6fAZ5aH+OZJSIV8
         bfP0lf4JjU/3NEgPVncKNHRU4MXSxYMegII3AEkSpV6aUcv1YtRhjtXdwJ32vYww+oL+
         6oU2VXMohwszA1D8mGNISWC0YvwPrnW3o5BJDEbBLU+8uTzz4oQG94FHNt37xdva6/NV
         yX5eNpgsoxFBItD71U2/gpneu5hdVZzZ2Bo/dEYT6xG1CXeX53j8nb8gK0zwGTBA8Grv
         ldeCktTmWmY70aScZEPKc8FAPpP3eYKUbGLMEBXN/SfoZYDYO0nXLJImLiwnaKRpvWfQ
         +lEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lYSZ2XOx9EImprIh+D5/ewBfr8WHKR2xlkYUy9QAcGY=;
        b=y6neBs8BOs9WsHJ4qNQpRPvBe+F9EacThZj6eTwG8ctvCBARWhY3WEK8hATa6/HLcO
         4R8dPsVencHcqqFpRNxOOxyvpQjDK/p8nVgPbuZFH2maWF4T4vPw4YB2rt/O9Mi2gVfz
         XWMNaAnibNJ3m5GHVXXUMQ3r2AwCNy1OYznq3shd3UIWsCX+eheQwTc9/nfmxTQ5g6+d
         LpiiR+JFh+TRX0sJ3aV5mtNn7R4h3hGvBYFU5r/rdBk/Wp60s8GYCb7e8YSCvMc0qoif
         984Z2Qscoy0gureXfGLWfB3JhvNkwrpPcUFWBgdTNjN8Sc5kxVligDFJ6TNedYfVAEIO
         hvZQ==
X-Gm-Message-State: AOAM532FjGL78qZmt0ZVZ4s+VWlwnLVJq/YTu9l0Vsj2F1DNped5hDLv
        VXG2Yme64EjCei9N2czyVEypv2arkQsbVjZ+
X-Google-Smtp-Source: ABdhPJxNobLKKgVUmQNprLKjE9lw7mQUMV2dji76r0fPlrlfDellD7WOKI2wy8YkK5jwUm8ae4Bz/w==
X-Received: by 2002:aa7:8198:0:b0:44b:e191:7058 with SMTP id g24-20020aa78198000000b0044be1917058mr24114546pfi.39.1637967577003;
        Fri, 26 Nov 2021 14:59:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f8sm8947471pfv.135.2021.11.26.14.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 14:59:36 -0800 (PST)
Message-ID: <61a166d8.1c69fb81.d7992.8efa@mx.google.com>
Date:   Fri, 26 Nov 2021 14:59:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218
Subject: stable-rc/linux-4.19.y baseline: 149 runs, 1 regressions (v4.19.218)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 149 runs, 1 regressions (v4.19.218)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.218/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.218
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f244a54b39dd02c69f79001b38e2650e96f1ea8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a13138b19fc49cc818f6e8

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a13138b19fc49=
cc818f6ee
        new failure (last pass: v4.19.217-321-g616d1abb62383)
        2 lines

    2021-11-26T19:10:34.247182  <8>[   21.343048] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T19:10:34.292187  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-26T19:10:34.301535  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

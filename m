Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547DC444AF1
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 23:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhKCWuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 18:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhKCWuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 18:50:35 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299D4C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 15:47:58 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f8so3962902plo.12
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 15:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qpAAzTfqWp/96khUANxrhwCTNGXCuT+75VhJgZpSCrw=;
        b=Rk2HkeHuxn6tbRXugI5QxSxrfA1HJeoVhc4iev8Z/wldtsBLVZDudDHprTN9a/sdKW
         yO/+YsovbxFQpLlzbWYv83kaT6YIjvbUtw9DNVmD4K2ZjZCVd6E9yszCCg6vjOPtT7Jn
         bE/9shfBt+rpPS4EzgpTN99q290MkrILMNvIXRKp9RuyAKROzSm2WvB5v1yPJ7g5qdoA
         xZqtqhQRs6PbkVepIE2FQX7MXIchZ+j1maq3iwsb8F3Aa+mbWguNzsGwuQxvZpP/gwc2
         TWucxg4QPguIzyj6oV8/iqj1bgjCojz4hPSyIofLX+KxAqNJaybqxXv6SEDzwVkjFd1g
         nE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qpAAzTfqWp/96khUANxrhwCTNGXCuT+75VhJgZpSCrw=;
        b=Wpe56+bu+TFmRUfTZbouNiylNYFRAhEaqFRVMs3u17qqyoe9ZryK5RBI1Om1rBb0Mf
         967/CX56APwvLWKD7cMAlqBtLJJktOm6KfX/lmRO09mXV6Q8rLCwX6t+MjuWVMPi7FVe
         vzMyCUGz2aeEZOof6GMN/LkszXyR9Jr4abcAzrNuFHb6xbr8DIchTir7bhDyFYxVxno9
         4V37gJeP9Hr/qrylqxVT4/9I27HJJsM7LprCly5ru4dGDfIBVVRMhb5UqJGb3ZYj03D4
         sWTnC/xP7t2maEFoAngkOH6Zo99Q1PYsKIzwjHVshJyeCHC9MoG9e5MmDWl0o7zGszG5
         uoiA==
X-Gm-Message-State: AOAM532IKGeByYYrq/c3n/3uuIaunPahnhYcuTpMMIcFNWcHh5JyJYN5
        +x8JezYkUk64eTJMv/1Gj99tK+5drXaXk/B2
X-Google-Smtp-Source: ABdhPJx/iqCF5xGPAwmt0V+WR7PQb6zVC0+8WgmceSay6RqqQwYJ8A3QXunfX8LpeJKa3oWDnqZL1A==
X-Received: by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id u14-20020a170902e5ce00b00142078078dbmr14048130plf.12.1635979677542;
        Wed, 03 Nov 2021 15:47:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c20sm2821884pfl.201.2021.11.03.15.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 15:47:57 -0700 (PDT)
Message-ID: <6183119d.1c69fb81.68c0c.8072@mx.google.com>
Date:   Wed, 03 Nov 2021 15:47:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-2-g116ed5b2592c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 1 regressions (v4.14.254-2-g116ed5b2592c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 1 regressions (v4.14.254-2-g116ed5=
b2592c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-2-g116ed5b2592c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-2-g116ed5b2592c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      116ed5b2592c79432c4029e91d8960be71862a8a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6182dc83110bdfa28833590c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-2-g116ed5b2592c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-2-g116ed5b2592c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6182dc83110bdfa=
28833590f
        new failure (last pass: v4.14.254-2-g86b9ed2d25ed)
        2 lines

    2021-11-03T19:01:02.296173  [   19.953033] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-03T19:01:02.336662  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-11-03T19:01:02.346224  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

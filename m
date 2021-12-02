Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1851A466D7A
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 00:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349058AbhLBXNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 18:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244721AbhLBXNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 18:13:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC89C06174A
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 15:10:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so3700084pjc.4
        for <stable@vger.kernel.org>; Thu, 02 Dec 2021 15:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0zripNig9djvxnPrNcBZsVctBjGKBFXpHt9W+915y68=;
        b=WgeP9lxAkknGIRyB7ttBf6GGbhXS3f7rH4ObrX8diI2Hdxo+UwbadA1VTrm8PK9nSb
         uUBfUu3VGFqNh8bfWEEqGSi8D6F1dBDwk3kBCFrXUg/N9NlLRH7kZyIr2UaAHK4GRjds
         EMXq6LZFMsMIexYiZ+mPXWcfxvjGh+xG1soj3nW0DUI4MY3WS+T81qnbac+nfzKswmrP
         fPRrzEUfJkhHGxldw8SyYAl7HIde7OSntD1HZNr3EvyGTf8snZXJdypZBWFO7oyd1idM
         UYg75ouzwrI3sGGbvyo9Og4ES6kYjegyPfaaKoRiZWKI4aiC3cBSSlryEiHrrzTjo/me
         GP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0zripNig9djvxnPrNcBZsVctBjGKBFXpHt9W+915y68=;
        b=QwE+bS7c2vJ2YRqickBk+XavYcbChg1PSvy+qwUePf+TJMm8GPSp4vbVo+ohCQHlGl
         /3vRgGi/uDdy5x22Wf/EqW1GpGkx1d94/xs1JDEYrjWOhMmIUvgza9YfSqbBLfkF3I5C
         jCQb172ZMCDHEqjzY+ea8r0I48JuUD2lSxsltJzpmFLHmRtqG2JwWnjbOGMYHo1JmD9c
         5zh5PXAewwOV/QzTjRn0QmIQ5E/veQEfw/O1s7hVolxwZlYNSJF/4FTLCY/7Xt4U6S/4
         pJNUAPQEQREJk/Sax6LKZYsvNrw/q/26mmaMGWRalpR2kal6cGPJhxHPn6IqaU6xu+1K
         qe6A==
X-Gm-Message-State: AOAM532ZAUcy8NOdQ3QdbJ1LIFQDe5gJOl248Jm3pXAbgXLSvdPi0aZ3
        D0UhrqiLqFO3V32pixIfUx+WOEESgOSXQc1z
X-Google-Smtp-Source: ABdhPJxRCORqchmQaypFgXpZji5kpXr8MgKO4yQRueeQvNe7AqppwGOCGTVzuwlVK5r36D/EDg+q5w==
X-Received: by 2002:a17:90a:5d8b:: with SMTP id t11mr9297420pji.8.1638486622762;
        Thu, 02 Dec 2021 15:10:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm573062pgr.11.2021.12.02.15.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 15:10:22 -0800 (PST)
Message-ID: <61a9525e.1c69fb81.c154e.2956@mx.google.com>
Date:   Thu, 02 Dec 2021 15:10:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-39-g8da2d5e984a85
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 1 regressions (v4.9.291-39-g8da2d5e984a85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 105 runs, 1 regressions (v4.9.291-39-g8da2d5e=
984a85)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-39-g8da2d5e984a85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-39-g8da2d5e984a85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8da2d5e984a851f8ed4e8385043b56dd6ed1d036 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a91e28e951fae8d51a94a1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-3=
9-g8da2d5e984a85/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-3=
9-g8da2d5e984a85/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a91e28e951fae=
8d51a94a4
        new failure (last pass: v4.9.291-38-gec9fdd0edb0ff)
        2 lines

    2021-12-02T19:27:18.273003  [   20.525146] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-02T19:27:18.315738  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, ksoftirqd/0/3
    2021-12-02T19:27:18.325345  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20

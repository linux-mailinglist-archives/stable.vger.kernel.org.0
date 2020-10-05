Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4990F284274
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 00:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgJEWXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 18:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgJEWXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 18:23:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B31C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 15:23:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h2so223847pll.11
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FB6ZCkBrCvoQWxDn0Pdg/bnh7L1n+LqhuVInzkHXmjY=;
        b=TpLeS+OF5QeyyGVOfQAuhlleAfmGFw9LT9hZAW0yZ14zcvqHkYmkRVWGpKctnm1UFs
         OQ6zRReQ563MjID0I1NhvUdFujYPfHXjqLUa/pL1XmmoCpyiSVTWHubdz8QBhByTnoXe
         yrYFxzzbCzM5vjtPVqisp5lY5h0+PuNeYdA1vBObmEdTY+7/H1FiWDRjOsPglvA35GLO
         c4cT39X2kCw2EmAWFTfA8SqU1jBg6fgQWlz72lsQq8XM8GR/WmZy2k/rY4QTZIKnzGJI
         3HR07dpCyYCO5bmZKtoLStDSKPTnRI++NOQXwJn+R28LXPjJTKQImWKJBGKRHefjQVVZ
         RzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FB6ZCkBrCvoQWxDn0Pdg/bnh7L1n+LqhuVInzkHXmjY=;
        b=l7ewXA1HYphZauJF7Ve/0lLp6vgKIich/RrphMAl1YppQbC5YFucIfyTXqDe1fHjL9
         yq9wsgD664HNig4pagUnRnjCcc0fEPzsl+gXT13kQgXVIBHgg4ARMsQmpr2h5QaZkSSV
         g9CGpzGRRWjP9U1IQ36VdFQcmU++IsVGtTaCnJQTpU0nIyAjOUiZpCM62c29JCn2h/EK
         vRADgeSVgq78ENXbIFHRa9aT8Vg1O6f16Bpdz0Wt0Rz35ebG+1L8Q5qRfnKGSNmvWVE/
         fgKEpcKbkpkG+hRO+SLkRLRM0OAFuRC93O/gwP+t2qey40pE34j4+pG6IOvDwmyQgZjr
         o7+A==
X-Gm-Message-State: AOAM530O7YqmFaUlBtjd87PWGcSgZg2+GMJWAWpa1MpAUZF4aPg36Byf
        a/DAMHRAdylPg01jyioYrbZ70GSS4qNflA==
X-Google-Smtp-Source: ABdhPJwkcQ6VaKj0Th5GNLO8qa0IUgByCGWjAtAZOxOuScPuSTtVV3yrUIsnUMP7Zy4tdCIdhQP3Jg==
X-Received: by 2002:a17:90a:b64:: with SMTP id 91mr1472663pjq.93.1601936630944;
        Mon, 05 Oct 2020 15:23:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e17sm616313pgm.84.2020.10.05.15.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 15:23:50 -0700 (PDT)
Message-ID: <5f7b9cf6.1c69fb81.2d453.1932@mx.google.com>
Date:   Mon, 05 Oct 2020 15:23:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-23-g314770acbbde
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 89 runs,
 1 regressions (v4.9.238-23-g314770acbbde)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 89 runs, 1 regressions (v4.9.238-23-g314770=
acbbde)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.238-23-g314770acbbde/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.238-23-g314770acbbde
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      314770acbbde3362d4d6a203b042807c96ebd4ef =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f7b6164df0cfcf5d54ff3f0

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-23-g314770acbbde/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-23-g314770acbbde/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7b6164df0cfcf=
5d54ff3f6
      new failure (last pass: v4.9.238)
      2 lines

    2020-10-05 18:09:36.428000  <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert =
RESULT=3D[   20.521209] usbcore: registered new interface driver smsc95xx
    2020-10-05 18:09:36.431000  pass UNITS=3Dlines MEASUREMENT=3D0>
    2020-10-05 18:09:36.486000  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2020-10-05 18:09:36.495000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20

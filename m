Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77141465C00
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 03:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhLBCIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 21:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhLBCIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 21:08:23 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D0CC061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 18:05:01 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b13so19145340plg.2
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 18:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hDpBmgEwhbFh0FERBn3LAeaQR6wlb276UFnnXBt5c3Y=;
        b=glBIe3ObF1eMabyCOXxJmj86OZZvnpxLlMGAxXS3vk8uqvBLuyGdve6oSX0USVHPbi
         rfjEMSle2gh2rwddhge5cegMMeNU1wTcethJ62kPZ6UsokFhET+QRZ6T7NsnHYBOe8Rh
         eBVJ5dXMy2i4EnLFCqf7xVfUZtoEqBfgS4J0aoadSFJ38BOyb3Vs0+G+D7JceotsC3Go
         2BHAziQOdw2C8NQXKV1pQ0uC83tNxJEukmEspW5f5HlRBTLIT4lYN+BzCrXRg/CuluJi
         ZgKWu1O7VMzNGewF7GbHly/+z+rJU1P5HQYdZDyF+2Yw2DwfizlGKW9L5TRoIK+4a6Yv
         ZFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hDpBmgEwhbFh0FERBn3LAeaQR6wlb276UFnnXBt5c3Y=;
        b=UT5BGKUMPuv6/f8qU1ZYxYccId3GIdBUxvVYyPBoEQ7t3fyMNVNCzGjtVxfTaOBv0g
         JGm3YnK3G3IYK6JyQtagrwiiVuCnl5RzV1qnNaj9zrYRHOHqHLMXJPgzhSjNk8ABnUCN
         w/TcCkWbjUjIilNL9ftAplFiLca6JSOsOBdDRKycbuBbD9kplRKJg26MKh7sIIi+3Xl2
         wEgjZH8e7WAb3Oyr98fa2NaYnII9384d9+EsG7e0v0uTV7uFV6YuShk3ug2zVAjhi1/s
         fY1QfdIwHRtxcNt5mB9lCpzZ6erHyry05j5pj3ko/iLpfiK1NL7k9svPfb+IqGvXdFrY
         MSqw==
X-Gm-Message-State: AOAM530w+q/wFY1cu6FvV+GZFp3vRzYnrX1RfGJQoA1LmNtPUeZRQp17
        qHyk69D6RgIRrgvZeMk7fT6dnUwD9S5abq7b
X-Google-Smtp-Source: ABdhPJyuzTMdz4wRwz+gXfuZmWF5ZKy9z5HwhkX/u2n2D6p/caMH8ywgUTk7NcR2m8i/8MACMBrIgA==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr2593519pjy.68.1638410701206;
        Wed, 01 Dec 2021 18:05:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4sm1104245pfg.101.2021.12.01.18.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 18:05:00 -0800 (PST)
Message-ID: <61a829cc.1c69fb81.e0a07.55ea@mx.google.com>
Date:   Wed, 01 Dec 2021 18:05:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-33-ga392ad1bb408d
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 84 runs,
 1 regressions (v4.4.293-33-ga392ad1bb408d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 84 runs, 1 regressions (v4.4.293-33-ga392ad1b=
b408d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-33-ga392ad1bb408d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-33-ga392ad1bb408d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a392ad1bb408d71f5058ded05ee25813ca998e7d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a7f0faea5711941b1a9486

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
3-ga392ad1bb408d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
3-ga392ad1bb408d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a7f0faea57119=
41b1a9489
        failing since 0 day (last pass: v4.4.293-33-g845bf34b777ca, first f=
ail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-01T22:02:15.420110  [   19.144866] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T22:02:15.469264  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-12-01T22:02:15.478490  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

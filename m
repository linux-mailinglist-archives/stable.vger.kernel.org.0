Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D5E2AF6E3
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 17:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgKKQtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 11:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgKKQtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 11:49:07 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA40C0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 08:49:07 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id f21so1263554plr.5
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 08:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/SaXOC7DK61IGgNBsantAZt343HGPDH15vNI/YpMeGM=;
        b=eA3XQIIibtKOFkAuc0dio6TT2mkk6WWqLbNUc/nrelDD6OOEALwUgmqm0buKXH176F
         D4t9/w28GacUBDDzOLKQro0I/RNym8R5qSmUbH+h/QyoROvpkiFWvQtWRt+QvdmaPRc/
         w8n1xQQUK5l2Tt4McZrVTQyFAT3M5blobda223cVk70ck257TEDdhY+wVvstMPWlmCWq
         8SdZfipnZtEvSf86PqsqBHnzy8d/J2H2LLytqWjlRhgfRxJHo4JRfaK9wsMXvksOU8VA
         kAKA1KWKX2CvcL1AwCliOpAEzsu/y6F7bkpCv9xT+Vi8WMINEioxDbmjFtDUcKXSRr0+
         38DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/SaXOC7DK61IGgNBsantAZt343HGPDH15vNI/YpMeGM=;
        b=Yu24T3i998vAKE1QqtJnYCV63aYOWpKXjhsoeblYXecJxwgVg0obwc8BGdT8D/cdbz
         3ZoAVeNela9IDzXJ9cNdLQU4UAZiX91IZT72z41+BGENKKizdTGhUgmQFfTQF8iwI2lj
         eSsZlMxrGsXHCZRMmUnVY/U+INlJgPWhxp1kwuMp+OOXvO27OKf7gRXXegZ3QOexZJxr
         RoglBc24oFux2VjxfnEHiIafEZ1me9IaZgEvRtdHEQKO2jIr7w9Sc1bpylBVilEyCsz+
         IzP5wZx2XSYENu1URz/WrXvaCLGQEQZaKmFLD3ObtJbDatRxT2Qh9Gmz0IcmJGlsH1Wa
         mJ1w==
X-Gm-Message-State: AOAM530qll/J8YupUXadpFxdQ25bNjIl+b88Hjbn75X8PqpwZXwfs3M1
        uv0U2qFswgPFEUTC0FFfKSiMOod9si9EKw==
X-Google-Smtp-Source: ABdhPJzR1raiQeafefb/QzqE11uBeLcNYuFZDRBhRozKM3r1PZ0e1v51rHaPeaTNVI6OkfyVUY5MGA==
X-Received: by 2002:a17:90a:5d17:: with SMTP id s23mr4694308pji.103.1605113346809;
        Wed, 11 Nov 2020 08:49:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5sm3498463pfk.126.2020.11.11.08.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 08:49:05 -0800 (PST)
Message-ID: <5fac1601.1c69fb81.b81f3.758b@mx.google.com>
Date:   Wed, 11 Nov 2020 08:49:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.206-20-g98b642d9cf4e
Subject: stable-rc/queue/4.14 baseline: 157 runs,
 1 regressions (v4.14.206-20-g98b642d9cf4e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 157 runs, 1 regressions (v4.14.206-20-g98b64=
2d9cf4e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-20-g98b642d9cf4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-20-g98b642d9cf4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98b642d9cf4e13c13379dab63140236a663c3807 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fabe3ebde4fbc715edb885e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-20-g98b642d9cf4e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-20-g98b642d9cf4e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fabe3ebde4fbc715edb8=
85f
        new failure (last pass: v4.14.206-20-gbe781f4237897) =

 =20

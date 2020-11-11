Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F5D2AE6F5
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 04:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgKKDRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 22:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgKKDRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 22:17:50 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A605C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 19:17:50 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m13so530675pgl.7
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 19:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IR0U5F2u4BNTmaR5dRdgyi1Ut6D31+JpiA294BAvN0U=;
        b=JQh8fDc1zbUwifgkD+m2Ls87T6ySh47JT3/TDXJJ2KXEXXcwwdlFBS0eEHKMUFxKUJ
         sTRCAqf2eIHi54QW/yhTUD7US3LkjbZVAF8VqaNxhovGeLBYoMWic+r/rE0HfGL4D85H
         T/2HW/PPFiU+tKeCVd0GTGiZqkfq6PL1MYpfg0dQlTph8stmUp5PZ7R+yCiKxcv9qW8z
         e5ppiZNGyF7VDl0otDUwYb+nEQvDqxnWoxKi+/yfftayOFZg0Fnnw+qFh2edSkP9XWWn
         VjfJMZe+W6bfv4EJY8qygl9TpoH/noxFXf2iqXzG7KLBnSVyQacyELpb4SqLFVneJ8hr
         5qHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IR0U5F2u4BNTmaR5dRdgyi1Ut6D31+JpiA294BAvN0U=;
        b=AbY7YAXQ2yAz2dhDOS/GoYo2YsCeHN9lDIbOCNTy2MN8a0+Y8eGrI75g6tFkY4kF3s
         TPmJ6ils9TmSANyNgDSr59ZWzhxCwrNmlVjmnvqkXUWCQ7MoDcpRLCT+L7FlZP6cL522
         Uoc2PLkTQYphWH0LAB+K/tV3kP14AthYSzhhECvcjPg3Lyt1gTHLIqGTeaxJtpVb6LHP
         +EgWn8cW2AjBUjVgyLp6xhyaypJlrv891XO+Re75AeoI/K+XI2MXUaWA2pSa4wFKQMKO
         tkugAQq6I1OXd8XpGUtEftKR81yqG7LVBufLDfOzUuiX49u4cIe4fQ6W+kUbXdQSmsFT
         D87w==
X-Gm-Message-State: AOAM531TGFCHAkTh5fCZi3H4ibp6r6AOPa06358Yj3Yc5aScmsvkP/+D
        E0hYBnWmFacN9I/GNNm2Jrk3Q9BkRr29uw==
X-Google-Smtp-Source: ABdhPJzuDYQH76vPE+w85M2V55vsrPzzugJ/WKgLdTWkvQ0UW2MpGNvpA0rjJtL3Nc30HCbvVxaV1A==
X-Received: by 2002:a63:1845:: with SMTP id 5mr4399950pgy.393.1605064669692;
        Tue, 10 Nov 2020 19:17:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q8sm457998pjy.3.2020.11.10.19.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 19:17:49 -0800 (PST)
Message-ID: <5fab57dd.1c69fb81.cb1c5.1e4b@mx.google.com>
Date:   Tue, 10 Nov 2020 19:17:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.157
Subject: stable-rc/linux-4.19.y baseline: 171 runs, 1 regressions (v4.19.157)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 171 runs, 1 regressions (v4.19.157)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.157/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.157
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      31acccdc877486a649a86d37725a15175fcd5ed6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fab24252fce9421f6db888f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab24252fce942=
1f6db8894
        new failure (last pass: v4.19.155-42-g97cf958a4cd1)
        2 lines =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC67028EBF9
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 06:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgJOEOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 00:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOEOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 00:14:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC15C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 21:14:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c6so872592plr.9
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 21:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B7tsAS0Tk3GgxgkwHidd7oexegVfmCbtYSwntPjLLls=;
        b=iBzxgj/ROBhBl8uSuZMqoqf6EEULAFaEuAitCRXsO+VcOY5Ll4miIzP3boubPA/aTm
         7JpyalV9BJl3JcT3gyE3355M2yEGuac35rzfRtVztDxUDaXjXzgwJ5oZcYUVxquZ8ujo
         3Yv0hfHXy/OQz72rOREW/myatDBYv1B7mur8xWpmPXL0IK+24sqWvFYB0yFQaCkxKf12
         KrWpED82X2XSH32RSmTeWU8SB/wPLnO4vHkFXEuVZZOxNk/XgKcCFQAAaSE+x2ehmYm5
         GnZPl8lq2b1s0WlwbEprPixRrPW1Zj7XPHLVE4kpajs0XHeoueVl2j3DucnF+pt72EKk
         e13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B7tsAS0Tk3GgxgkwHidd7oexegVfmCbtYSwntPjLLls=;
        b=JGNlfRbHSVHfCJL3JsxCLWmq2r5R0TcqMJY8GomvmN4AnxsccIeZfLuYl6jCC+CuCc
         2axMCbs4wg/M0ShO5AgWBj0i2rEpVBKmTWj4KLXNJ+E2wlVX7/NY8R3qswF87hhumSgW
         1BanpUt84Qs+hiVztukGieRyW/ilXxekv/9SB/j2u+9DyyACmwc2J0Hx8A4N7y5a5T+i
         G5ab/wN0ZP5VPb/M+JH5gfxw42ED9ljB1aCIMgdUQL5/yvyDvxZ+qurHjhwDoqjZjReE
         TnILmYHXDd89RQqumTMbeYe/1JYP0BlZySZKYpUPeyCPDrJKs+h9Ugd/xQPdTIROYqQ2
         SRYA==
X-Gm-Message-State: AOAM531LvqM2VrDCCXvd0Osiss/gEe3a48n2BimhSQGsJeWYGfW5F9n9
        D5JAwxdur6c42dQOeBg+1xb6VcBV3tecMA==
X-Google-Smtp-Source: ABdhPJxVPh1LPbGHcfQ0vXqQmu3LessZfjQHbkTCHd37lB6DSjyZkO1/FR2LWEDVPe2IS09qDYYeHA==
X-Received: by 2002:a17:90a:62c5:: with SMTP id k5mr2481448pjs.100.1602735241943;
        Wed, 14 Oct 2020 21:14:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 204sm1290974pfz.74.2020.10.14.21.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:14:01 -0700 (PDT)
Message-ID: <5f87cc89.1c69fb81.9e37.38ee@mx.google.com>
Date:   Wed, 14 Oct 2020 21:14:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-54-gcde3f5873602
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 138 runs,
 1 regressions (v4.9.238-54-gcde3f5873602)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 138 runs, 1 regressions (v4.9.238-54-gcde3f58=
73602)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-54-gcde3f5873602/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-54-gcde3f5873602
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cde3f5873602545362cdfd9952a762ad68bc9f2c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f8794ed28193921e74ff425

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-5=
4-gcde3f5873602/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-5=
4-gcde3f5873602/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8794ed2819392=
1e74ff42c
      new failure (last pass: v4.9.238-54-g625b39c2de82)
      2 lines  =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE043C92A2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhGNVAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 17:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhGNVAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 17:00:02 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241E9C06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 13:57:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y4so3752938pgl.10
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 13:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=02gUPoxdWBgwHSzSb37SSwthZpt+ac+syLEDP1iuesE=;
        b=ZPMEnLuXKsV7l7hxK7f7ookl+sb+tCYUPYTGxWLKu2HUN8zZwW5yQJgVwFTbZmsjbo
         eaSAAWQ/BBwsb07yiJ8zmcr62QYdE0lxU8fDtIgmKZPlbFyfIhdBvtxMAhSaSMHEAJue
         qRjNdI1MaRLqaOFXGNZabEVUmD8MH0wHspZJP7s6DR9vXhuqBxddw18kIKCj5XFC21ch
         WNNOp4VgLTFjOf1n4gAzuxSwUpe2c1fIg3t104b8HHIAiMufM2wk/L/STG2SyC2YbzLy
         pPopSuBje/t1KQqyp8z7nDqQYrn6YtSMcd7BvZ5MXpBBEczLE5ZDHYcmNsETUKErWwZe
         ygeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=02gUPoxdWBgwHSzSb37SSwthZpt+ac+syLEDP1iuesE=;
        b=QG5Z5+d5M7mqIidbhFvbLqm8VbpsmKUIkXTE0CxzSmyOvhIsAqh9eJa492m51sa/yV
         oVc3HUpGMddETymtfiGtX3dx/dW5jLtc1QVWchZT4we2B0kv6IDMpsd7xioWBSWabPYw
         EpY+NAHrUGQgQLUbVZHsbPca8lCe9K7jEFHYwr9WhF1yTTTSgPdHTc4N6yRICA8CBCGW
         58Fi0t9bpQs4XwBN2HEIpoMZTjuH0Vlj1YeUJMDPqsGTOzp2sKSyH2WfnwQnCPVf8GFL
         03dfLwUMeCvU0skoj1nYuGY49x9guspSE8h8v7jsuuHamYJrj+/VxwJOdBhYVJLUzXt+
         ltxw==
X-Gm-Message-State: AOAM530ynPnFj5Mj2eTnBus7+hYhQFyFtkTKOEmSkIFM67ncTyMQXkm4
        JMVMJiTOaxyG2vS8fmcG09EBKhT3K7nM7CzC
X-Google-Smtp-Source: ABdhPJx+zwEWVp48MHjiQzqUNkir2ahjkwX8S76eMfUHoI0vYp5BCY3Q/avvo9Y949I5gNonF8jS4A==
X-Received: by 2002:a63:f515:: with SMTP id w21mr11391597pgh.343.1626296229480;
        Wed, 14 Jul 2021 13:57:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p38sm3447076pfh.151.2021.07.14.13.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 13:57:09 -0700 (PDT)
Message-ID: <60ef4fa5.1c69fb81.412bb.afd7@mx.google.com>
Date:   Wed, 14 Jul 2021 13:57:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.1-802-gbf2d96d8a7b0
Subject: stable-rc/queue/5.13 baseline: 185 runs,
 2 regressions (v5.13.1-802-gbf2d96d8a7b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 185 runs, 2 regressions (v5.13.1-802-gbf2d96=
d8a7b0)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.1-802-gbf2d96d8a7b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.1-802-gbf2d96d8a7b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf2d96d8a7b02d8d33252fd166118612539cadbe =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ef1ad5d3f6a799f08a93b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
02-gbf2d96d8a7b0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
02-gbf2d96d8a7b0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef1ad5d3f6a799f08a9=
3b7
        new failure (last pass: v5.13.1-804-gbeca113be88f) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ef1fa87eef904a6a8a943b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
02-gbf2d96d8a7b0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
02-gbf2d96d8a7b0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef1fa87eef904a6a8a9=
43c
        new failure (last pass: v5.13.1-804-gbeca113be88f) =

 =20

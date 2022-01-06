Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F4B4860A7
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 07:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiAFGfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 01:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiAFGfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 01:35:04 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7350BC061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 22:35:04 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 196so1702362pfw.10
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 22:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ssAroinn34afYszc2/9aQbk08ErCnX35C+nhECykN2E=;
        b=kbSwtwB0OH0p0mHLNbeYzuWmxs7hO622cnm0rribKpevbzySoRJ1fLGysskliLARKn
         SS5s632ASe8ly81DWdP+eKJH+SCpsAeZHQ0nEstJAQEsFeLZqxp9rdevmRmwbb5M68Du
         2kyOiyxgZfZY25uHtV/ndUi068Rpweek24Uxm+lxoe4aYOxICUfQjezW7GBVYC4FP3oT
         8e9JIbYJ29IO8TnNOJ1s6eCmV3CaMIxoaaZre7oYMc8aRNF4PrBbDZeRixTG9gvZ+IFH
         Qunj0NBC6uo3gD03W83+PYgb01+BahEGBmnodWzQUylFZ8/ZAUH+eBAbaR+j/jGwVT3W
         4mrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ssAroinn34afYszc2/9aQbk08ErCnX35C+nhECykN2E=;
        b=pHhnGmbVhQ+DSKOHPBcia/Txnvz7AwD20DWh3kCgqnENvMNZxITOBC6XbT0nHXFA9Y
         cNA0c1YmhiQm8roowkvIMxKh5l/XtgNr6yY1IJByQNlOqz8yOXqvpEsPgPv8LAABxMXH
         wRYOe/fnwDWp1BaTr/iYpg64XrbIwSIpdHEc8cYfUzNxLZUbsVwzGHFsfExCmxxkpC9S
         LpwKRDfXK3OCbYnZcL18MXBS5ezyruR6BKwzz8QT/1l6XA0AjvL5IhCwBRUnlaZIHPAo
         Hsrv0yNHvBcMWb9Is2noy0VCfpO2Neq8wdtZzEqMmCP2jvH/MVgmjU3locCga99eT11w
         sKaQ==
X-Gm-Message-State: AOAM5316KOOi9RbF954OA3dB3C0mdj57otNJxwoqBJt8ogaSCRFJNWS4
        Ckt2vSgmKe3wZ1vJN1SgrnSUaiWLYUdt86xc
X-Google-Smtp-Source: ABdhPJwHg1NyKjxJjHigWrNTC34iHDPPm1JA2Nsqw5/9g1WNuk9UV+2jxd+5ae5g0OQfSE5CTHrDqQ==
X-Received: by 2002:a05:6a00:784:b0:4bc:cc58:994e with SMTP id g4-20020a056a00078400b004bccc58994emr10677220pfu.72.1641450903820;
        Wed, 05 Jan 2022 22:35:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 145sm915108pgf.88.2022.01.05.22.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 22:35:03 -0800 (PST)
Message-ID: <61d68d97.1c69fb81.3f37c.2dda@mx.google.com>
Date:   Wed, 05 Jan 2022 22:35:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.90
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 70 runs, 1 regressions (v5.10.90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 70 runs, 1 regressions (v5.10.90)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3e491a20d152e5fba6c02a38916d63f982d98a5 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61d65e32379304cb0def6745

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
0/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
0/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d65e32379304cb0def6=
746
        new failure (last pass: v5.10.89-48-gc129f56d557c) =

 =20

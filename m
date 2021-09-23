Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67B1416660
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 22:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbhIWUKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 16:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242979AbhIWUKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 16:10:48 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C954C061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 13:09:16 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j14so4745671plx.4
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QQ5e2bJMlLQTLcGVZBMDf+IGoROEXoVlsNc9GfGZBNU=;
        b=K1brfx/SfJSKtaKudSPCpEWAkP1c6/VSRJaU/Xw/7rDSLPDASXqtI2RuN2cbYZjE/c
         fY/HhcKiUZpiuIjMJ9c/vUpAQQTHbxKkaDUrWpaGTSLzaGEfGYPlsUbk8YPY9N1DK4vv
         amIf/quutMCECWSCrDW2JPGITZOaromjtOSeg3fr8Nsr99/ZOd36QGV7ujv0cvoEo4Wd
         n0Ot3T8SnupnovqY1mSgebj0t/0nOIZvcp7Tvb02RegQ7UzCwn6FlMaQ86Ldif4dzuMT
         ER5GgNB2yFtwpLc0jI+xYWuRoxIsV3LX5hk3ep6vkY7ZZoxvZRUmn8N7TQ5YYdyAhL59
         W73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QQ5e2bJMlLQTLcGVZBMDf+IGoROEXoVlsNc9GfGZBNU=;
        b=gWgaNqULF0WmPUwsq3eK/ES5cdf6JrA17mD3VTihTEkANEN3j9WbU3ToD5i4zO1rrQ
         Y8/EARsoEP4eAMz420bfiXV60qCxkayVaut29JgRd1nUbAKAzIiK+2K3rD79DdDD6U5g
         AnjdqBOQpejJ/gedMTC4JKIOWo6TNzsEEkR6Ys7/Ul5+efxhY5s5VrkaAZF4G7bM71v/
         Sp19/mGxkx6KkNSPBlzmjaTYb9TCJcGCmmlWMprMq4+cz/ezhcASVN6q76fzoeJHfvEM
         uvXc5rK1QHTLk7C06CwPRJuTDlFK77aZX8aGe02Hum1QMrZYNO5P6+Weogj/bd3IR6lO
         +y/g==
X-Gm-Message-State: AOAM530W4QL9nNpbCCuF9zBO6M8oNswjm/k4NbQkM8pIS+PzEkYDPIj4
        N8Huobs0VpPh5Chwk3iFOgvLKyVWQI9avS5B
X-Google-Smtp-Source: ABdhPJyR2NbEGNYaFaEKVNeA34Vql4RVLYoSFoYRxYf4CEauhvaKl2OPpoK/NPxMYz9EI3xzTrlhCw==
X-Received: by 2002:a17:902:b945:b0:13d:c17d:4209 with SMTP id h5-20020a170902b94500b0013dc17d4209mr5401363pls.75.1632427755858;
        Thu, 23 Sep 2021 13:09:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t15sm7388810pgi.80.2021.09.23.13.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 13:09:15 -0700 (PDT)
Message-ID: <614cdeeb.1c69fb81.91fc0.6377@mx.google.com>
Date:   Thu, 23 Sep 2021 13:09:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7-3-ge58bfe3d9b99
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 96 runs,
 1 regressions (v5.14.7-3-ge58bfe3d9b99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 96 runs, 1 regressions (v5.14.7-3-ge58bfe3d9=
b99)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.7-3-ge58bfe3d9b99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.7-3-ge58bfe3d9b99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e58bfe3d9b99b21b37b268100b16c3506bd38251 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/614ca758ad5b3c955799a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-3=
-ge58bfe3d9b99/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-3=
-ge58bfe3d9b99/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614ca758ad5b3c955799a=
2fc
        failing since 1 day (last pass: v5.14.4-395-ga49a6c3da2c6, first fa=
il: v5.14.6-170-gb1e5cb6b8905) =

 =20

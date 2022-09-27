Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0AB5EB6D0
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 03:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiI0B06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 21:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiI0B05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 21:26:57 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E425A285C
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:26:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id a29so8365367pfk.5
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=M47cQ9bMQ0lC1FAtNDrLT63uiBAZfD181VbR383adiQ=;
        b=7A41lbHcFil7nHpP7snLQQsLmk5ZGvPhlF8xiLoqlsePClcBYoxxeBvwIrVJ11Gky0
         H2koh4ePVVw1GlIubDnyOdTUsRcrbSCNCTLONbLJd3GZRCK7gQucq15gCU5J3p2JbAPt
         9HwMFRwSj0vx4FQleTiz1DgHoDz5OiXK54oRPG2RJVZ9c9KjGczbq1liRoNjreHDutK9
         qTjz3pHV/2vshXvXsWLFcZYI3KDhcBm/z7N9BKAieT2xodT61ERxG9xc3oIAXlCiWeGO
         0VYGhntXhdZkt4xJOHddXjwLG0IuW0/mNgJ9/96HGTlQ6XdbmSMXZtCESfivTUSLOCs1
         CnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=M47cQ9bMQ0lC1FAtNDrLT63uiBAZfD181VbR383adiQ=;
        b=tPzCDre/bW/N0wD+ZjxSvdNq5TZI0mPcHWBL0uxbfIupaL30Ltk5lE5SAVVnyOY5yN
         8+ktlQuRDM7A2o/FIB3vEZJeBbFNh0BR1X5M/dBAPjRm3kAXjFL8tAXFTxLU3SS2hV/5
         Ci7JKysz3Wbky8EZVRVzw3o9s9GL0zUa+Mi/F/t6oB8XZFbQMZU1+5envnXgSM3HbtDQ
         blktKeGEbi4NWIxS1s6Hd6p6RxVeaPYFqqCxgt0cYj2jdQsTLkfxYUiOyTvTTfN1Heay
         Jh1+pSYKeCgOwXN5be2ibwgyoZGSW7o6DKsVjOpo05J8pv0HK/S6fiqoCckd6vNURmLp
         721Q==
X-Gm-Message-State: ACrzQf1ELyd+3cZLDq6/B5AnQtDtFzB4g+JJwyWbCgpNz//FEqz59w/2
        2GVmaQKdX30+t8UWr7y4lqsnGHQsPO2Ebhpd
X-Google-Smtp-Source: AMsMyM6l84gPDUSjjBQasZySg9Njsu9rjGM32XTACUbn/tky+0012X3U7E41gb8+Id0877MZ9rVoZQ==
X-Received: by 2002:a05:6a00:f04:b0:547:50b1:4f4e with SMTP id cr4-20020a056a000f0400b0054750b14f4emr26566232pfb.69.1664242015863;
        Mon, 26 Sep 2022 18:26:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q14-20020a17090311ce00b00178af82a000sm90861plh.122.2022.09.26.18.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:26:55 -0700 (PDT)
Message-ID: <6332515f.170a0220.59930.0417@mx.google.com>
Date:   Mon, 26 Sep 2022 18:26:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-142-gf9f566b0cbd5
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 116 runs,
 2 regressions (v5.15.70-142-gf9f566b0cbd5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 116 runs, 2 regressions (v5.15.70-142-gf9f56=
6b0cbd5)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =

panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-142-gf9f566b0cbd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-142-gf9f566b0cbd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9f566b0cbd5e191bfd7ceb6f830fdc1e5641b3c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63321f46c6d1c6be99ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf9f566b0cbd5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf9f566b0cbd5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63321f46c6d1c6be99ec4=
ea7
        failing since 5 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63321fb66dc33ef7d6ec4ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf9f566b0cbd5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf9f566b0cbd5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63321fb66dc33ef7d6ec4=
ebf
        failing since 34 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20

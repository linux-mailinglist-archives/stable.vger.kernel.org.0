Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3245E918D
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIYHwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiIYHwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:52:54 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F6D39134
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:52:53 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t190so3955419pgd.9
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=3PF3J+e5WDNbAJsDkmTw8EY/ntrqqtLBy84UvQFyw6Y=;
        b=isryQVs7YXzkfvFqSVifMiIeTFC1gRi6kp5/cpm9Gux322THmjDGc4PghU+tiSsv+a
         2Q3AmxFZkyfOCKf0uI5oeAB5GvPULLp2JudYWjV+3Rt92YSm5r+X+WXECjxmj63uatrU
         6fbWPU6+pay/EO7hSPPxscNPiICLXX75fKYAAeqaY5lYNEmUiURkY3a8h0Ew0FvPNjSu
         104CphtUKqLKm8MbddHIvmkWpdWZjQgou8LeuOSn7xWJRSCgruHjVQ0ybM9czUqZuMIK
         UvStffVIFCfxQQRrKp1ku23qHowMKKp5KBkdBt53SDxrRzpV8+erfdfbg1wNxPLo+F5t
         YQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=3PF3J+e5WDNbAJsDkmTw8EY/ntrqqtLBy84UvQFyw6Y=;
        b=uwjvyOnaQx8vgY8+wNdNUwxjlXhCx6HHe0Zzn4Ng5l1hDTM0VISug9Sr5yugS+mNRP
         WOOU63ArPZYImEyJjUIcUaYBofT5BMzQDSUhPnlh9lLStvWq3H+CWtu2Mk1Qa9S5pFQj
         pq8rw66ehdjZ8y5gfB5EaWeqJuG3XDpi/Kfs7W4jzd4PIk/ct6l5KhDuoJKr1gkApzr5
         UYtBJ7NCKRqRJmuwgK8/C81f4fMihrHug8LPl2lTbOS6iL0m630SVj75bqmJiG3R4fHc
         hgkVWla4TqOfusSqBfTRkxVMHRz+lygvlRGnGOz7hDIBlFtf0mLe6MB88M2eF1dDVwz3
         lbdQ==
X-Gm-Message-State: ACrzQf0Waa5jsz1SW7LzqyzrIr+sOqi1SGI3DscTlJMkHyBlxlwHpoJC
        i0tEvEintpkUtY0Qv62lGlXWU1h9dWEI+CbwA1M=
X-Google-Smtp-Source: AMsMyM4xug2tvGkClyXWYkuFzqVqvRwktdqs7CybllwtfH5gRtLIJYMPqtv1siBh1rDVW/mz2l+VpQ==
X-Received: by 2002:a63:6b04:0:b0:43c:1908:d9c with SMTP id g4-20020a636b04000000b0043c19080d9cmr13799865pgc.258.1664092372730;
        Sun, 25 Sep 2022 00:52:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090abb0c00b001fba4716f11sm4339734pjr.22.2022.09.25.00.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 00:52:52 -0700 (PDT)
Message-ID: <633008d4.170a0220.599ec.7a0b@mx.google.com>
Date:   Sun, 25 Sep 2022 00:52:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-117-g5ae36aa8ead6e
Subject: stable-rc/queue/5.15 baseline: 149 runs,
 2 regressions (v5.15.70-117-g5ae36aa8ead6e)
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

stable-rc/queue/5.15 baseline: 149 runs, 2 regressions (v5.15.70-117-g5ae36=
aa8ead6e)

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
nel/v5.15.70-117-g5ae36aa8ead6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-117-g5ae36aa8ead6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ae36aa8ead6ed94e00869c9161a75a3dcbd9679 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632fd43f759cba6cf6355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
117-g5ae36aa8ead6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
117-g5ae36aa8ead6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd43f759cba6cf6355=
667
        failing since 3 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632fda253dc9377904355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
117-g5ae36aa8ead6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
117-g5ae36aa8ead6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fda253dc9377904355=
666
        failing since 33 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20

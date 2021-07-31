Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5AA3DC693
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhGaPT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 11:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhGaPTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 11:19:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4789C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 08:19:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mt6so19473284pjb.1
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 08:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f4bXBgY99druVxO6HeRsl0dnwFIN37KKzGtmINpNFbQ=;
        b=vGGp4Etq6rnqaEhgF1rwjXcT6x1ZpuzxPWCE/qn8V6dD1okff2P6xc58iZGbS4zD+h
         tujJ1OsfLKlZi5w2v9AILyIP5gWJYs9aZ70aSf2L+Ez5oCbzw0d/nJsldNm2jb4eq78S
         nNB2ZR4582NPIQSXYWv4V5NLa5yEfJaCBDTTTUIdfUX3Br1H2K22TnUXpn9vfI25qvNd
         cNC56GR3s59ZNvKY5Ari1R9dwBvUUIfQsQ7pD2YcqF8+VQTfcUfxqhCksZuwTkEtl4Ml
         skjBwvbP6pdDIPtAPkCGWi+nBcLb7F4sHhHJDfxRuEDDRCIWoPb6FNcZjs/qsE7HkeLT
         fn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f4bXBgY99druVxO6HeRsl0dnwFIN37KKzGtmINpNFbQ=;
        b=QQMUgFRJt7ub593vIKRr6f5OCUBfrOJOC8h3tu+fzNODZPDiapE3x7t0IfmyllwYg1
         Q/E9e0OZwUcn3+sqrrS/Enpetu1ciTcMTzp8rtDLqT1ax0XYnQfxhdaFh1vSiBb4FKcJ
         gz4qxEYDW33CovIAtPYAePhTmeFbkoV4wAZq1qIL13LDDRDgCeap26QYmYw5h+LANV3W
         hzzICF8csbD0f4EX+wAfYxe6nReFlAJ4hsnaMAtSQd9Kd/rgtCbNdxCEM2NqaDkt9zKq
         dtMYQf6OctSRgxLpRTUFr3pEjO2Zksn1AjUsJKOHyr42mVU7EuUmFUQ0LxFEOy5jNPZr
         l7lg==
X-Gm-Message-State: AOAM530O39xE3iHMuFih9ynMU7UMUC5TaHG/x6t1v3HMsj8Eytr/0ZKF
        E13f8w4YDKVitWDBCeYujXPh6tK8J62RHlz/
X-Google-Smtp-Source: ABdhPJxPMPzwwNbWKX0arkuKiGRHoB04U8DbQWxsVArh1L6RN6nq97dKKkFgKxkqMCeEqHOLHIDA3Q==
X-Received: by 2002:a17:90b:4f8d:: with SMTP id qe13mr8674934pjb.204.1627744757866;
        Sat, 31 Jul 2021 08:19:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a23sm5937864pff.43.2021.07.31.08.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:19:17 -0700 (PDT)
Message-ID: <610569f5.1c69fb81.a5277.025d@mx.google.com>
Date:   Sat, 31 Jul 2021 08:19:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.7-34-g59fb97ea0e16
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 155 runs,
 2 regressions (v5.13.7-34-g59fb97ea0e16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 155 runs, 2 regressions (v5.13.7-34-g59fb97e=
a0e16)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.7-34-g59fb97ea0e16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.7-34-g59fb97ea0e16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59fb97ea0e16d4bde4610d460b6cab36da7e0e13 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610533f502c3b81d2885f466

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-3=
4-g59fb97ea0e16/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-3=
4-g59fb97ea0e16/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610533f502c3b81d2885f=
467
        failing since 2 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610533229fb3586ead85f467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-3=
4-g59fb97ea0e16/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-3=
4-g59fb97ea0e16/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610533229fb3586ead85f=
468
        failing since 1 day (last pass: v5.13.5-223-g3a7649e5ffb5, first fa=
il: v5.13.6-22-g42e97d352a41) =

 =20

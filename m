Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92230430C8C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 00:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344748AbhJQWHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 18:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344746AbhJQWHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 18:07:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFFBC06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 15:05:15 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r2so14020668pgl.10
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 15:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2UZckDFoIQh8iZ6dF0dXm4DhDjLLSPl5KEicM9N+oig=;
        b=sdeuyD201I75WKiUq3ClQwb5TAjrldw9DiuZgK7kU7moj/G7DeNpf03T7jOjcSgl7j
         OC6H2FVyfbbpz2XfvFdh7oReosLNnjMr9f0rVO74/tHtTZL5g8F39PjefDsE3S1aNH/P
         GfCXPd0+a2rs6odREgAajWWaWrW/HDDi66WVGHJjP76JxGPlX/BM2thg0pMV978KOYHa
         TGD4ye0BiB2nVZdhnCor+SznHp+F8aXat4beY5GDwSAwKAbWtYgnwlDVEOytCB8eiYD1
         yy7lpfmv87Wx5WgNF+5PY+inbsUMFRvDWnsnrb9ywDVM0YVKgr9/dyNZsMjysgaIeqZh
         P1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2UZckDFoIQh8iZ6dF0dXm4DhDjLLSPl5KEicM9N+oig=;
        b=f6+mkEqHHWHq6wgqXQjNA5vHA6sisNoCT+QSW3xWCTRTlj5FRpOSV/M1OXiWLtRF53
         CcFgGccDKOg0TctgK7+Vw/9aSy52EooQHKmEApMHHzSsYc4egneHbrEBTevIZIoCJTm+
         mg5R/pIHXWMsYPg8qaWTgpmjzmVfvKUv3yKrJou589k3dz6+ANrfWqlmvgA/A6mUnl2B
         FiGe+Ez4YLcU40Gorq5bCSYWo7ON+pQzzDtdUOc3w5V3Pvc+zIJuSdKF7LtEAJkIIwMv
         4pHXS4SnhFZiE6VB29GKP+cHNsSwKDQm1MzLwnKFh/5J7L1y8ba9X2JAR4uC1O+p6H/v
         4aFw==
X-Gm-Message-State: AOAM532XkWfbRHC+05vRNyfZAX07/dYW22T4v8JhT+Vp7vRGpTP6t8f7
        xTcMdAapoJdCUAbv2nirnpRAj+UcL6EejvDa
X-Google-Smtp-Source: ABdhPJyiJ4OzalJQhFUZQeJ7o6whXV7s8/KmNNmYAytz6E5hzJOz3GFzM8hGNiGYNOPQhJf2VkjWAA==
X-Received: by 2002:a63:6888:: with SMTP id d130mr9324714pgc.234.1634508314437;
        Sun, 17 Oct 2021 15:05:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z71sm11454584pfc.19.2021.10.17.15.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 15:05:14 -0700 (PDT)
Message-ID: <616c9e1a.1c69fb81.8bebe.0183@mx.google.com>
Date:   Sun, 17 Oct 2021 15:05:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.12-67-gc15240390faa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 64 runs,
 1 regressions (v5.14.12-67-gc15240390faa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 64 runs, 1 regressions (v5.14.12-67-gc152403=
90faa)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.12-67-gc15240390faa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.12-67-gc15240390faa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c15240390faa8f584b0654bd41708499552432ab =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/616c68f4205643b4e03358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.12-=
67-gc15240390faa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.12-=
67-gc15240390faa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c68f4205643b4e0335=
8fe
        failing since 3 days (last pass: v5.14.11-151-gbc5a3fbd8294, first =
fail: v5.14.12-30-g495ee56a80cd) =

 =20

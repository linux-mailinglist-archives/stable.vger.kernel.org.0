Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352E0406FEE
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhIJQst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 12:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIJQst (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 12:48:49 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D419C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 09:47:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h3so2351188pgb.7
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6dXHBZBbV0VkhcP04Twcxq7EpvHXKoW2iHeFLJDIME4=;
        b=Zh9C76yKnWKjXgkDXCqHxiDdF9zAlDRw0Vm+2SlO7eyMbiYkud9DS1lXPMd7bPjeR6
         ewhNe9iTU+RWVtiUzQu8Tzye+8fRt7AYzlg9E1HK0W6ZJqSfVrJLkZdJfGj4xTzNERco
         pwvYhwjV3MXvKHaFhqJdUiaR/CWA4T1Wutydn2FZlLIj0HqLMlab56czqz/faTr02FeU
         ZI/55H4D1B9y8/sRBRUxTgUBlSPrL/F9HS1pL30ked73hWZhTnOQbDVcPyORbUVGSbci
         JoapR1TfmfHK+jhCUEA3sNtgqgV5RYK+dv//dA6BJYpiZtlwtm4Oz8WclQgREi7YPcTF
         C/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6dXHBZBbV0VkhcP04Twcxq7EpvHXKoW2iHeFLJDIME4=;
        b=VbkLwHm32SnWwLaBeFHAJoeWFEb1ISW6364D68AXbZKewHbsWhiJgVpbUHPK044HIH
         /I11kJVqt64psHSXSVSkXb1dWd7GwUwGQS73K8I0JzCPR7HqhaCszIhJZxpTjqB7MPKH
         PUCGqY25/uVhGzXhfX8NCU3S/KufWIv/3D/kARakf8KxErzylc1CpGu3I//f81owsWgP
         H7EjTKDV6/KZf3KMTZmVEQDPP0y61wGmWMdtEaafU/3ADSV376sQEshlCE10ekJgmonr
         8hiwXZYpCx1kpzO++3r42BLtu9/dQK1rbBSCfwra2Y1uSCkz39vukXCrTh3mLQ4OOdHH
         YqGQ==
X-Gm-Message-State: AOAM5326zGjhtiWcLNcuKJCk+e5NwCZ5SXRAyH4KL4ExDfFiw8UVmnP3
        DbMCTvyyaaG4nmV5RAVq727c0lKGz7u0Sq3E
X-Google-Smtp-Source: ABdhPJzuKc3ftwbWYiKRio8FH0nnzreQpTHs58Pw4Y5zF9j/hBOLEsW3pwgXCgjNqJ9jnLcpCw7AYQ==
X-Received: by 2002:a63:d017:: with SMTP id z23mr8093201pgf.108.1631292457544;
        Fri, 10 Sep 2021 09:47:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s5sm6362433pgp.81.2021.09.10.09.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:47:37 -0700 (PDT)
Message-ID: <613b8c29.1c69fb81.a2b29.2c20@mx.google.com>
Date:   Fri, 10 Sep 2021 09:47:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-22-g9744a6357aac
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 56 runs,
 1 regressions (v5.13.15-22-g9744a6357aac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 56 runs, 1 regressions (v5.13.15-22-g9744a63=
57aac)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-22-g9744a6357aac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-22-g9744a6357aac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9744a6357aac08c7509e57d83ca1010a774b7389 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613b5c320277e39de1d596b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g9744a6357aac/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g9744a6357aac/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b5c320277e39de1d59=
6b1
        failing since 0 day (last pass: v5.13.15-4-g89710d87b229, first fai=
l: v5.13.15-6-gd33967f7a055) =

 =20

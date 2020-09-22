Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B270A273A72
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 07:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgIVF6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 01:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgIVF6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 01:58:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7054FC061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 22:58:18 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z18so11463020pfg.0
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 22:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kwjOMwtwRcrEde2b0baDGUD6L2iatKv1cGvcdGEBM2A=;
        b=gDaZjYZY62awn4iHozj1KnoxUg4I7j1wXmhSVM6phw5a7rhLspPjNDf2PK3Sf4w0AR
         SBhlR9UAhrVEttJRX/7hc8Bjth26VkSk0wD6wev+DoFARwuKY55XJ7jRVaBRRNb7kNUR
         doFFqC03QzU01//FNUzZurGe40A1ruTbSAa9Af3v5350B0ABsW1sFa+xklQQU1cX5QZR
         UcubhxwaxKx1AqXPg+nDOXHoprRtjUUdMa67Bw1h1yVZUVQa/zR1Dx5f5eJbsqp2ZOn+
         SrqvwsZ4Sy8Wq5eRyjGrD5uJKXsPZ8okB+iyvf6oGBLAZGhlOR1rrj4cz+KayPBmrHUn
         hUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kwjOMwtwRcrEde2b0baDGUD6L2iatKv1cGvcdGEBM2A=;
        b=WD3bpQVDWeu1cLwI6NTGqMQYIk3qb5BWcd5DPwgoHeAKi6v73x5teVkDqq2r3V/qLe
         TkKW+X6JolAjd+4vgxWt8khvHR5d47InqXA6whXZf/UPVkklqKM0el3Vaa+PIzJ0saJN
         LPWhUpbStGpq8/Oz5b0+kVc8CO6Vh1H6OnaGKgU+1xKn+mAXVfebcYLoKfQYkqT8MS6F
         q8NQ+bgbqCE58BDOmxNvairKpYgnqX9v+dJazexUSTwGmJxaKMHJzt6xiDjWXGn8+4iR
         SrBShutC680csUYckvuKEeW2UIZpNTjLIv31qJhZRKboXbMUhxC3H6qSa29HwrWl6HqP
         72YQ==
X-Gm-Message-State: AOAM531EJWv3Cr2cPutve/WMzqSylhSWdLyzPNyixYJDF2+3uRxutOpE
        ag3OeiHixJzeOf7E3Mq9XeoJ+X7plhM5ww==
X-Google-Smtp-Source: ABdhPJxoRt+yiAzrUuueurAjbOLJt6yyiJWgGHA/pJ9k59RlEjunkAbZq4hIat3dv46w/cw8pHAGPw==
X-Received: by 2002:a65:408b:: with SMTP id t11mr1419042pgp.288.1600754297002;
        Mon, 21 Sep 2020 22:58:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a2sm13385766pfr.104.2020.09.21.22.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 22:58:16 -0700 (PDT)
Message-ID: <5f699278.1c69fb81.fa507.1a4f@mx.google.com>
Date:   Mon, 21 Sep 2020 22:58:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.198-95-gfbc0d5c8464b
Subject: stable-rc/linux-4.14.y baseline: 143 runs,
 2 regressions (v4.14.198-95-gfbc0d5c8464b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 143 runs, 2 regressions (v4.14.198-95-gfbc=
0d5c8464b)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.198-95-gfbc0d5c8464b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.198-95-gfbc0d5c8464b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbc0d5c8464b4a7bd7ad25355d983c3b815a2723 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f695a130af509a0ecbf9dc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-95-gfbc0d5c8464b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-95-gfbc0d5c8464b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f695a130af509a0ecbf9=
dc4
      failing since 59 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f695a8e523e4b9c65bf9db3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-95-gfbc0d5c8464b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-95-gfbc0d5c8464b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f695a8e523e4b9c65bf9=
db4
      failing since 174 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20

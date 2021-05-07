Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FCC3764D7
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhEGMEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbhEGMEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 08:04:11 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BF6C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 05:03:11 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s22so6992444pgk.6
        for <stable@vger.kernel.org>; Fri, 07 May 2021 05:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h77PUx4hHIbpF+jxrfLN401By7tcLh7A3S7anqq1p/k=;
        b=CJmcmhdJjaAzZS+zppa8D0dydBD6h+7nZeXryUu0/erihqtSUxnFs0SeFxk8mGVjdH
         ikFor9J1X67tRJudBzra3WZHXdO5iujBpzE6mNOBCkxURraSs/xe2oC1RMdD/Q3cb/Az
         gUDCp9zyXUcTXmf+BgSrKDgD1ZZSBdgkp9MdrONbzupUqsF5IgVHCuiCcSPmwm+RcMRD
         YEBsS2pFIi9T/gfgoxHOBdBksGLj7UsjI2e4jnglDn2lwQgb2OaA1YJID8KUmiiYSK3O
         hu2OQdqfmXvULIR8bgsWP/40pudZSkLqHu7LlzDGZLaUUPz5XMkq7CIMSvUWyn9YqIYF
         bbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h77PUx4hHIbpF+jxrfLN401By7tcLh7A3S7anqq1p/k=;
        b=RP1VEiuf/qs1IsOGsVQPHP9pw8FWHZ6xgMc+tqGbQyM4Kn/3FgPybRrGFa2qF+bBjv
         v2KsRv81ulHKaTvKY3Lb6lwRV9+88PJXo3xOncE2NalsBI5GPtxaoMX8ZDzjmp5/Jtvd
         v0ZN2RWygTYj4AO08X4OyecXJzi9e4unHIF4udQnUOENr4di2lDNfvzqD2sKdfTlxmTX
         soOm79f1OhStTO08Vs3A0tu7l24kknW7pamVT1ZgcrI41uPLr/Y21RUJQr1sKRagCHiw
         PAeytH/t0IAnVt1cZumDb3aTyV1JghNJ+Qt4lgFOnEbIjbG+ApTPKHcYIg+2AgWEz5re
         Hp9A==
X-Gm-Message-State: AOAM531n3RpWbn3bwXco5okYKb7J1/MQReDvCG9eX7GfDflCJHhIgGnI
        nPTxLdfYFeEtExy924a2WV0lvioTI6soFtrR
X-Google-Smtp-Source: ABdhPJw9vL438UT9FrP6+f3ODmt7vVttaBYdMzu8Zf61iYMDY8+Mq80De5Vk2Aerz9LfDxnLxeVs4g==
X-Received: by 2002:a63:1c22:: with SMTP id c34mr9655672pgc.408.1620388990922;
        Fri, 07 May 2021 05:03:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm4538593pgt.42.2021.05.07.05.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:03:10 -0700 (PDT)
Message-ID: <60952c7e.1c69fb81.1eeb1.d707@mx.google.com>
Date:   Fri, 07 May 2021 05:03:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.34-28-gfe295056d9295
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 131 runs,
 1 regressions (v5.10.34-28-gfe295056d9295)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 131 runs, 1 regressions (v5.10.34-28-gfe2950=
56d9295)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.34-28-gfe295056d9295/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.34-28-gfe295056d9295
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe295056d9295a29423e42718522d24933080fd4 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6094f7576bdc734cba6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
28-gfe295056d9295/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
28-gfe295056d9295/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094f7576bdc734cba6f5=
469
        new failure (last pass: v5.10.34-27-ge42f087e04ed) =

 =20

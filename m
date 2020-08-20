Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24B824BFAE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgHTNvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730349AbgHTNuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 09:50:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9A6C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 06:50:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kr4so994031pjb.2
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FKSq+WiirakVZ+gL+rlxmzWE96Yz5oOuhhc4jgWWWF8=;
        b=SiQXflGnikvHueQUAfNcC8elsJSiT3fuJE6/9a9ArgfTPUuj9h5mI2Ax/Dmk5cjBbU
         SAayl+pgtFjzdG+vgJWdRZAkFMpxvYcmDk6rh0zYmGosB2s+UvEknEYo7UMK+eiciLbm
         vHkYIbMAae9+zFo8H10EjMuYyB6OpX4GpoChP9nbFPST0cAqeCDO9+tFcKihm7TLr7hS
         swPnRbzrTqLKr383dEaVk+CstRDGSttJCtxU+oapxmBPhD3EYkqZkFvj0uTvayeMPKOS
         xYtoIg38t7tcxRRfCsmLKYAuCyhiK7K94Xp5Or3UC4NAtLHvKPkhSurjAULkZvJ8RQay
         nPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FKSq+WiirakVZ+gL+rlxmzWE96Yz5oOuhhc4jgWWWF8=;
        b=ksq1vu32ad9wY+VUuITzBvfDAWSfOH/55s07fNgTPNYLDfPRtXgjmWcGK4swE2e23x
         /F+wfkfh6BDmEUoRqnB0/OWatpzPnfUrUuWP/b/+ViABwtC3RlVmZttxqV4K+f5E711D
         3QzjEERspFVnn43Ff3kstwYs3meNGn4tRgpsxrdMFoywDUsyTG2L5Ax8c7e2W7Kv7u8q
         5IJnOfDFbzdT36eyAu0tpY1jjSdZA7qZTO3NfDBIK//kEEhQYb0VqRCD/o7BGtwD4J7h
         +QN4vavXJWb2h3wYPMGR/r9zjy8hI7Xmv2NVwk1WSaWmgh4A5K8VL4/LZnVYKUcDHqgu
         uLSw==
X-Gm-Message-State: AOAM53270VWu2BkDgwfnI06FwFrjFzO4tdah4Z1yFnT1yKdVPh6xkUl7
        oc+yxI534o12fwc/tcdT/Yb0bGPyFHlpMQ==
X-Google-Smtp-Source: ABdhPJwPaONe63LsI9FCZmICuj7PjsOhzmFIjKlF6nD+Z7AHfAfNX0xPMo7X5L808xlHUSA4gVlk1A==
X-Received: by 2002:a17:90a:f192:: with SMTP id bv18mr2475028pjb.21.1597931449421;
        Thu, 20 Aug 2020 06:50:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lj3sm1584866pjb.26.2020.08.20.06.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:50:48 -0700 (PDT)
Message-ID: <5f3e7fb8.1c69fb81.ea897.29c0@mx.google.com>
Date:   Thu, 20 Aug 2020 06:50:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.7.16-205-g7366707e7e99
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 169 runs,
 1 regressions (v5.7.16-205-g7366707e7e99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 169 runs, 1 regressions (v5.7.16-205-g73667=
07e7e99)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.16-205-g7366707e7e99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.16-205-g7366707e7e99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7366707e7e9962245a618a0aee04c22ab31115c2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e502c8b53ceaba4d99a3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16-=
205-g7366707e7e99/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16-=
205-g7366707e7e99/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e502c8b53ceaba4d99=
a3b
      new failure (last pass: v5.7.16-99-gc5aad81e7f2d)  =20

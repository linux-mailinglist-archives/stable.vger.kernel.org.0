Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF42824DFAF
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHUSdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 14:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgHUSdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 14:33:21 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB17FC061574
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 11:33:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d188so1492268pfd.2
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 11:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J3qGlierAFFZ3BJp5fUJkGox20R3I5HfI+gwWW+EMUM=;
        b=TQgyOU6LWqs/pQ2JqtGyYCGckglVFj0xPWBSMZoLqp2JQHNVagdWLdUllGu6cs2OvP
         2GTunh+Xoruv6cucUgFlGpJ6BH00g4Gij9MqHIkRfyhRR5IGuGnwAf2QfNvAf5ZS30Ze
         aL0VOAF0F2B27UnxQDTXwlP+eZy7GK8lmie60qj1kG0O7e/hd1zWbPwnFnLgOb7hNO8F
         GMnu9la0cfLGh+D6yELx0jc/1aqwwDK7fPyLwAuwvyLh6d3R436jv1hrL/dLCxFLCSGy
         4thjQe64e7665T6XvoOnSX44aXWOMeaIsowb69Jcnp4nqIDPkIQkZC48NIO/+vQ+STsX
         xXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J3qGlierAFFZ3BJp5fUJkGox20R3I5HfI+gwWW+EMUM=;
        b=jKY/clVnP8wxk0xyN9G7Vca3mvvaJunK66HWo0Vrsf9wNaIbwQS9+F8k9ICjKXPisr
         Cpo+3rnm/xYZu7b1AOmIJGPvrvH9BLcWZUCXwHlW2pFlOuwRBPJi/MWsouDIaTUVKjTO
         rR5fJZ/no6+i3BydwRP+ipgHcrc/6BCoD7tA5TlOtBTvOhRd6sDOj6NjN7zmvMavOJ/H
         jyQhUTzFJv1ZYVbd1xMnAq6mkT9FNv+5XmSn4M4fwOO1zB9ZkzlnaWtZ/A6nQKqo8v5x
         Pw98ek7Yi/sNXWsVWwFfIz2m3JnUbwp1Sj5p3eUq9tD5N3eyOM3ZEBM39Ur3ODcz4om5
         ZaZw==
X-Gm-Message-State: AOAM532uHIMa8x5dAKcH9ANhq4wsHLXq7DMy2HDVcE+4KP2+aFwszNUn
        8PBGjSJXpHZ1ae2zKyKvtaXiDn1FNlvx2A==
X-Google-Smtp-Source: ABdhPJzTEO/V8bNgnbx+Hs18XxO4tAGK8VRe50T9UWaoDyDj+y62bM46MiVPTBOK477jiO+C1qwVgg==
X-Received: by 2002:a62:7c4f:: with SMTP id x76mr3674241pfc.124.1598034799148;
        Fri, 21 Aug 2020 11:33:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r134sm3371827pfc.1.2020.08.21.11.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 11:33:18 -0700 (PDT)
Message-ID: <5f40136e.1c69fb81.3cafc.9c3d@mx.google.com>
Date:   Fri, 21 Aug 2020 11:33:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.17
Subject: stable/linux-5.7.y baseline: 184 runs, 1 regressions (v5.7.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.7.y baseline: 184 runs, 1 regressions (v5.7.17)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.7.y/kernel/=
v5.7.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.7.y
  Describe: v5.7.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3f45898cffc4e386952f3e4821810500adccea1f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ff44a6ea2c53d6f9fb42b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.7.y/v5.7.17/arm=
/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.7.y/v5.7.17/arm=
/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ff44a6ea2c53d6f9fb=
42c
      new failure (last pass: v5.7.16)  =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1D4A55DF
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 05:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiBAEWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 23:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbiBAEWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 23:22:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DEFC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 20:22:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso1197681pjm.4
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 20:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hjzKM/4jNNnVIOfCGI6a5iitt2qnl4dAYIOVh9SKO1o=;
        b=LTT7BN4ZTFU7ZxX7lK9dE/thZJwXiY7HaypV91UO80lgnoOoR2lRg1+gspVBRYKmP4
         uOMaeniy5ZbjI0lRwHdpmffP13O6vB4KUUB/Lk31yFAeV6WLd4Z/22RiC15ObQ443yES
         LqAUk6PIYgxDi4gHbLYFpFflmuU7USwZyPmFYkfyDsEYKbCF1InTltJSkaC2HZ2oAsjy
         eBUv71fEWZhdrlRr6aufGElQdcEhotW4wKfNFfg8lOVVJ79FDSwFM9PEpzbzasYDWF8m
         cYVgjZUDEOcRMcXFKMQwkOznpeixVx8mrO4WHYOBsx4PAmoFfmWP5cCOXlgdUpmwskUu
         8XUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hjzKM/4jNNnVIOfCGI6a5iitt2qnl4dAYIOVh9SKO1o=;
        b=V/AXbM3ly3navSWFg4vseMaPsuIW+cF9iKNBE2mgU/9g5gfpROoZ6HBpPOmSXNG2QV
         qYRpnR/QIq53I317gQ4rw/Snnh27cGaQ3fHuAaVkTfDj9Tg7Y4ZrXwtnyF8p3Fy2GE+6
         0KzzW2yDHLxeW5R48oEIPXPirGQTvqD/DMvwcBdfAULGiwq/F9gzi4i0VpI2Vk2HbaWw
         8gqHsBpaxlqJhKeQOpetpj0o2nKMGXqM90RVg8c/jmWyzzqf+cps2lB62Jaq5m5iFfGF
         4C29T30YpbtOkp4bnQ9i2ieZNdMNc2Cfx27V9jaoR+/75/QuKy6H+SvvBo3A4YnDqLr/
         9wMQ==
X-Gm-Message-State: AOAM530C5IFIXy+nxI5gvCyScJ3XeTdMdW2zCk7Ty0HWKyj6z5IVn+Fe
        cHlS0KzoFAsEh4E0QLqd46aouXjOxnhNR9kl
X-Google-Smtp-Source: ABdhPJxJHV3resbQAN4mFGVnuJxZ1kg93BWhfCzC3o+mO4+GGmJyQkeNwLGMtJmAJxLpDIL9BnfUFw==
X-Received: by 2002:a17:903:404b:: with SMTP id n11mr11369446pla.129.1643689319312;
        Mon, 31 Jan 2022 20:21:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm4183796pgb.75.2022.01.31.20.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:21:59 -0800 (PST)
Message-ID: <61f8b567.1c69fb81.a2349.b3a3@mx.google.com>
Date:   Mon, 31 Jan 2022 20:21:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.18-172-g39741c5e5973
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 136 runs,
 1 regressions (v5.15.18-172-g39741c5e5973)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 136 runs, 1 regressions (v5.15.18-172-g397=
41c5e5973)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.18-172-g39741c5e5973/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.18-172-g39741c5e5973
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39741c5e5973d935ea274c740a2f63118b5d19f6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f87e0ee5c5c526355d6f05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
8-172-g39741c5e5973/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
8-172-g39741c5e5973/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f87e0ee5c5c526355d6=
f06
        failing since 11 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =20

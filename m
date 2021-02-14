Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41CF31B0A4
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 14:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhBNN7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 08:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNN66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 08:58:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF52C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:58:18 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g20so2290131plo.2
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2R6VzoqHt05x/6lqUvlYnyPIjre/VkZWuL3x5+Hm8ik=;
        b=I0/ibcBxbpy9cer5g8K4BNNS8qB/Fk9nEhzoE1oqaFDajf3mFNvdiPxAbyYyH4ZGWK
         jnNcOpJwXr4A7Z4T4Z2RH5YXj68PJhqSuoEt7o4JC8a/oeq0rI40pGc1aNXHo44+ZwOY
         y04gH0OqKjEpgiLCFzcvjbg7ZbQ8hxfYJGf8kZIUM4FJ+deghVFB72gT1EqFwNi6bk9n
         v4dDJdHrP+QpqEq6m086/r46nFIp9sOi1A0SBbUsaonpE/+PcB9Nlxf1xADZ7CbtsQtN
         wKe6XLeq7rSu97Z1vTvx0O3+jpFzdOB173W5fmzcUTzBDcMFWvqzargDv61kcloJ7k/H
         5BHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2R6VzoqHt05x/6lqUvlYnyPIjre/VkZWuL3x5+Hm8ik=;
        b=i4xGkyQ7hTMFiA+JyrHi/DjKsEHeGOqwzCxDDWUulinxkKe4hio6XDp0uIK6oRikap
         40cWjSYCfvaaiJpse++RvTYkr2aLSIHszMVR2EnShhuilchqD5my9RayPBYidQOTC7hq
         dyNuyC+581oWSwV+OqWRk3VOz//Zw1wqzQYjnbJjRPpWR0p0OFa2EQGyYnuLM/gEBhs8
         KT/Zj5nLfOCakfVjJAlJZaukTkyDURd8qWV1/6SJOmBPPdrq/z/6Dj8gqbi4bkLVeltH
         bTkMMzizp2k9Xf6216Q34Mbk3jN45EAr1jB0UN3Af3pHroN9tSWMURp9C2GB+2egPTqp
         yZ/Q==
X-Gm-Message-State: AOAM533poSMnkccNiTCLBD7e+HdS/y+TOX0d/eLVT0nQXLLC+g1T3410
        eH4aJ/4ah4Lfi6G6K4DdjZDhO5+hIO/Dfg==
X-Google-Smtp-Source: ABdhPJw6ZEJqTOWqRQvqlKYnEPV1YfAGpNb3BwpRp2nwgbX0RY9GWD0+B5yhOZNFckNP6+hIU/i2rA==
X-Received: by 2002:a17:90a:194b:: with SMTP id 11mr11537830pjh.100.1613311097616;
        Sun, 14 Feb 2021 05:58:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y16sm14783678pgg.20.2021.02.14.05.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 05:58:17 -0800 (PST)
Message-ID: <60292c79.1c69fb81.f1d8c.022f@mx.google.com>
Date:   Sun, 14 Feb 2021 05:58:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176-4-g075b14a30060
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 78 runs,
 1 regressions (v4.19.176-4-g075b14a30060)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 78 runs, 1 regressions (v4.19.176-4-g075b1=
4a30060)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.176-4-g075b14a30060/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.176-4-g075b14a30060
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      075b14a30060c17dfe4f64994bb6b359760d2a44 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6028fa23c5deeb90523abe71

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76-4-g075b14a30060/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76-4-g075b14a30060/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6028fa23c5deeb9=
0523abe78
        failing since 5 days (last pass: v4.19.174, first fail: v4.19.174-3=
9-g69312fa72410)
        2 lines

    2021-02-14 10:23:26.561000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

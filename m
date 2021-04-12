Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2349935C55F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 13:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbhDLLgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 07:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238550AbhDLLgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 07:36:33 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69427C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 04:36:15 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso8649889pji.3
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 04:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lpdY9/fVl3ffgcvouujfsmUmj4FV1hN0DEk0zg69hSw=;
        b=YGgZNu1FmE9KMwfYP8CohpFA/CYs7f33O4LtRzUxzsfjXm3c+Cf5W7C7FmzBmO7Ert
         eHJ1FvUOyKxNpp9+uP8l3sBEyOeKasqN/hM8ynDYC5RD+zcHRL0Htwg1Yy1G1qn6z7vb
         A4cU2O4s8i7qmbEX8AFiqinpOLasyA4yQXS64uxAaVEb5RoR8tpFoWAvkAGwFhZjy5PG
         KcbDFYxPfSIdW5En9mWlXCVFcMKcXwallN+haNq98UZvTnrhRut7HXkf8Tbt3rd8uyJY
         Q/g3EKkq6VnL3SFKcxT/dKX8yt26DW1Cv5YhVUiN4MDJFCKDVgtV1RJfviczM8KIP3+f
         llDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lpdY9/fVl3ffgcvouujfsmUmj4FV1hN0DEk0zg69hSw=;
        b=Bqw7Goq8B/3ymEPdYMZJ2a7uXeoUiDj/otXxGILEA32duXhj00lofCkt1n09KHsQ7d
         KozoBUZPhmGqt4h5uk6IAAPY6Q/DxsTpfFDvujyngV+nc++xVZKhQDWVPZif99Hi2/vW
         6eixfU7mZP++1nIYYUtWY2gA6487cQnnP6fa15ujB211egvqF1/WgckOHgPIGnVm6t8x
         nvG+h8to2UBvkb53RqnWd6lMDXg+IGSQgCqvc6sVamomKCSZ9gH2hW3HCMryW+92I7Mk
         VUvVH+/nS+wCxoyZlV8BkQPUxZbDbRFu4xIT8jJbKXN+VU1Hncz/Nt6rJ4X2/6HF0zaS
         8Kew==
X-Gm-Message-State: AOAM533xr+H15AaYnDEovYtJ2GOW4Im4q9fpUT9qVgJso94ABaV64SyS
        kwx8edrwyKpKo27xfoJp3YReqwJpZx7NWhbF
X-Google-Smtp-Source: ABdhPJwAOE4GsQx+qnC6JEnQRYw1K2Z35nDQkSlPI3y9mrl4uNFDPMqQ3hKPxPqKSmbYxGJLHMTv5Q==
X-Received: by 2002:a17:902:6946:b029:e9:4dcc:9966 with SMTP id k6-20020a1709026946b02900e94dcc9966mr26139245plt.6.1618227374873;
        Mon, 12 Apr 2021 04:36:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17sm5506000pji.40.2021.04.12.04.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 04:36:14 -0700 (PDT)
Message-ID: <607430ae.1c69fb81.1fbce.c45e@mx.google.com>
Date:   Mon, 12 Apr 2021 04:36:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-25-gedd321209f787
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 1 regressions (v4.9.266-25-gedd321209f787)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 87 runs, 1 regressions (v4.9.266-25-gedd32120=
9f787)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-25-gedd321209f787/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-25-gedd321209f787
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edd321209f787000c0dfdd69dea1cb96fd68f0d7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6073f894bbf9b28a68dac6cd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-gedd321209f787/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-gedd321209f787/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6073f894bbf9b28=
a68dac6d4
        failing since 0 day (last pass: v4.9.266-17-gbef36b8f37175, first f=
ail: v4.9.266-17-gb18de8247ff14)
        2 lines

    2021-04-12 07:36:48.495000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/126
    2021-04-12 07:36:48.505000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20

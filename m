Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98618286C5B
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 03:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgJHBNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 21:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgJHBNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 21:13:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C6EC061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 18:13:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id bb1so1943132plb.2
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 18:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LbkJydYfq1qDeU5HXUVe2i2wJ/5x2hQFtfw8u0T+SNY=;
        b=Rd+qnvrhl7vH26Bi6Xo1VDAZfxPNYwZZfxl4KV7t5227jzTvAC/ZvBLkBWKLZWMPS1
         DqL7e4Vap6S4zAIz36NUkwvIEB8cUPspdpPP+s0m5q6nAZdEo7q+TJSnTWmkmiFnFf1n
         2D1Zwk9y4ffAqN8HGk1EGWBuZVHfUeF3+PMzc5617TLouKL2lbr/dNBkZkXBuFJZQ/Zu
         61QVQox7VKw9WPX7eK9S9KO/mAhcuihEYvFk/bMpRuKUjR7IIYu7gU/q1fFaHplEC0pB
         JDRjm4lbpIZrwOiuZd/ij/5ZCrRyChraBpdtbufpQfieRU82MxshwrsrRdxMFbticXar
         n+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LbkJydYfq1qDeU5HXUVe2i2wJ/5x2hQFtfw8u0T+SNY=;
        b=RhdBYReEP551RP/MnARlWeSyHi37NxoL1JDC/oiCXwy1IUGurk0ewK4532vm60pMC7
         vXyLeVgWAwl8ZGO/31eWAvn41k8VuP9ZHyynhiWfVVD/1ThYty36XOFCo/clnb/wDLZd
         T52f6rzgJi52T0Arx5c0ieW6VfGAZh1MimDfeS+iooRmP7jEq0vBOlQY69wpkkhNfqG1
         qQ4B8GeUoqLNheXDhSV7w8xumzypDAiATLQKxJ8uhqUBxd2HZ92zT4nrIgHd//t6LJ3A
         YxahJzA5eSWq+YRmBOoTJiCVbhCiGsPWM6aCwVXa+dhsezsRy3RF+pP5bewk52fZROfR
         ywrA==
X-Gm-Message-State: AOAM532N9dv8VOt3NOpX4Adf3DR7jJ3yW29ktLDqBhFWOVBpWONnIAS0
        Rua8ivzp+0eKVHmBf+9wATH5RMDlLXbOSQ==
X-Google-Smtp-Source: ABdhPJzAZpFlDGfWKCsDAdijNq7UgdELyLzUx/NvIVYTHBrGe9mrzjaCqumAAgOO+GeXPyzwxcdvpQ==
X-Received: by 2002:a17:902:6545:b029:d3:d370:2882 with SMTP id d5-20020a1709026545b02900d3d3702882mr5419361pln.44.1602119632881;
        Wed, 07 Oct 2020 18:13:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f28sm4683920pfq.191.2020.10.07.18.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 18:13:52 -0700 (PDT)
Message-ID: <5f7e67d0.1c69fb81.1380c.9284@mx.google.com>
Date:   Wed, 07 Oct 2020 18:13:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-35-g6413c9826509
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 1 regressions (v4.14.200-35-g6413c9826509)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 1 regressions (v4.14.200-35-g6413c=
9826509)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-35-g6413c9826509/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-35-g6413c9826509
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6413c9826509a58e644096a4871c85eef102f5a6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7e2600f65b3222334ff4d6

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-35-g6413c9826509/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-35-g6413c9826509/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7e2600f65b322=
2334ff4dd
      new failure (last pass: v4.14.200-31-g1c6e2b3644fd)
      2 lines

    2020-10-07 20:33:00.637000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
      =20

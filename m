Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179E51FC271
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 01:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgFPXvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 19:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 19:51:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9598C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 16:51:16 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v11so342993pgb.6
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 16:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HWba4so9oyfD54BGeTBTyM6Vi3VnAbDlQ4TUrpNEy0U=;
        b=ezab/muBAPuP4awYFI4WAwfk/Z1baE8bIea9SBuhYLmiHLhQtANFZWGiy+QojkbsZy
         tt0Z0GPu8EGkLZD9bYteiUe0P+pvVbMGa1KIpVTcNrp47wIOFmaJyNp4vI/odvSVZffP
         oofkLsHo3aKJzjSbcCqJXYwkrdeL3lpY7Pyl6ewx8FL2FeoWKPqs5zSda3UgdouGl0hm
         LyglKjiTyxUOA28+piZBGgFnIQiwiuEvkjNcROq8yiIOkmIgXHXHpfFu8EDCDvQnyEKI
         eTSy5HIGa/nfBlu+O12YnStOQ76AhvXY9QSxwb2DDqFM/RS1y4Y/yxRwSIFl9VbsVlq+
         /VQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HWba4so9oyfD54BGeTBTyM6Vi3VnAbDlQ4TUrpNEy0U=;
        b=OAI0DQ0rUQ0ec/iYwDavKpSAhYpNOL/TYUQfqVCvH47P27v5k3SnTdmG5ZFPxfh4yd
         8by/Z63M3MYF1jvdt97UAsLoQKu5ni1xslvONpx45MMc+ADYwM4g6hegBYg0zMHbFDvD
         RrkO2zE4QRQ9sGaas+ltu6uNzhMULbMqrRla4CuE1tR0skvRDD1MqHpXHVygAxj5RTky
         XETv5uiZL0Y5uy0iws6DZ564RAQ7bo/UJogQ79C5tV4EwL50HKeGNmKCcqqm4bfJrgnd
         4imt9Ug0rr8sISRUfJIWYZUleZK/giCovghh8nW5sTZ4OgfXZjql3khUCzahHQAeas/J
         nvHg==
X-Gm-Message-State: AOAM5308YEMxn3mLErdUyikOQCg+soRB9icbwMnEpaE6fshNzzqGBs0Q
        EntQ/WVBxy/sH1pnwBf7s3NZTkx1Ipw=
X-Google-Smtp-Source: ABdhPJzGm4ZTi5TwOEFvDHiRWRUtOzgHw6bz1MZjXid2DI4idcKjVMiAPL0w5biqyXyn4hNXWq5+rA==
X-Received: by 2002:a62:68c6:: with SMTP id d189mr4341511pfc.135.1592351476011;
        Tue, 16 Jun 2020 16:51:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o20sm3436070pjw.19.2020.06.16.16.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 16:51:15 -0700 (PDT)
Message-ID: <5ee95af3.1c69fb81.272f8.9e4b@mx.google.com>
Date:   Tue, 16 Jun 2020 16:51:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.226-83-g43fb0f9d5b32
Subject: stable-rc/linux-4.4.y baseline: 55 runs,
 1 regressions (v4.4.226-83-g43fb0f9d5b32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 55 runs, 1 regressions (v4.4.226-83-g43fb0f=
9d5b32)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.226-83-g43fb0f9d5b32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.226-83-g43fb0f9d5b32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43fb0f9d5b3227048e6be520bfe64a40d3d8bd7d =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee9261f0e01b74aa997bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-83-g43fb0f9d5b32/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-83-g43fb0f9d5b32/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee9261f0e01b74aa997b=
f0a
      failing since 6 days (last pass: v4.4.226-24-gd275a29aa983, first fai=
l: v4.4.226-37-g61ef7e7aaf1d) =20

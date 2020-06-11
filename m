Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FF1F6CAC
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 19:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgFKROy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 13:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgFKROx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 13:14:53 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB52C08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 10:14:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r18so2788438pgk.11
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 10:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WWIUFss0JFLLpy6baKzaOqoE2kOs1Y0xABk4bYuVEYs=;
        b=s0QPC9QYEsa/GH2+D/qWDWbOsqFnpVCFFlNBuhfWEvy2ixtKGFI7TPadEMlcgFUITO
         0pvYmnjk+VV/OfC3A7MLNHv/GPb3LAnOEfL2IvVRq0PKR8vlSwsMNvptbbW5Mi+yrcti
         I/lMTevPKZe+VsnpiEDfmPnIC7PE3RMZqBfOSEMUTc6jJA8HfvuLSGx685EqBiL7XVXd
         A07ElN2XD0r11DJ5qV4U9bQwWaOZ9YytGC22d6gHOSQ6JZgGNa9W3jMmUUXbchPhhhgr
         HIUXdO4PrJhmMXaTw1DWb3MDtkkk4imzfYy9OfAu4ChOhdFCLYwVz1EpN2arT4hKldKc
         gBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WWIUFss0JFLLpy6baKzaOqoE2kOs1Y0xABk4bYuVEYs=;
        b=h3DcpLuX3G1P6PCMikF9gc1N/KKT7/hfmPRsHQwQJISO/LVJdAbx9q4MtgxfV8kcVh
         2SOvkq9ALS0ShSgBP7MmSbo33U8AyyuIiScLyXQe9iRfhscdml8QElgZopoWyBvMUIWH
         eWFe5xPm8I08bZzi1WTVmrTj3vl+iNqjigCo3aF3Ku+XXTVXjbvwMJMy9t0yKwe/aSkZ
         Wz4hEASeM89T/HZOKL7ggrajeu6iRR4liL2Q105Btpycp7R91HFlqBP1BV7BPVcwKso3
         srDGfQN5A67Ww0AgUnDthGBMNfgFcttd6yeNLUc6dPvki3aqqcbLlTocNROtoKhZOaDp
         eDBA==
X-Gm-Message-State: AOAM5320rbd8MtJJ+hExkZQpjxd3CVG6obMLwKqZFHAqckA3NygBll7E
        TXdPnR4XQxOsQ6Io2J7AA5hKqj4wiLc=
X-Google-Smtp-Source: ABdhPJyyLXiE3mdhrgVhrtzYVgbQpWqzVOKpAfDEQBbfwafMoe5W69iTzmpLpWvVVSrM/4e6+r9WWQ==
X-Received: by 2002:a63:1c15:: with SMTP id c21mr2492018pgc.363.1591895692391;
        Thu, 11 Jun 2020 10:14:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm3091231pgp.56.2020.06.11.10.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 10:14:50 -0700 (PDT)
Message-ID: <5ee2668a.1c69fb81.b82bd.8574@mx.google.com>
Date:   Thu, 11 Jun 2020 10:14:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.227
Subject: stable/linux-4.9.y baseline: 41 runs, 1 regressions (v4.9.227)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 41 runs, 1 regressions (v4.9.227)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.227/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.227
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e0799bae56744764303252ac8d52ddb5774bcb4e =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5ee23178ee5a76624897bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.227/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.227/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee23178ee5a76624897b=
f0a
      new failure (last pass: v4.9.226) =20

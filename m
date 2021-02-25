Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD1B325413
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 17:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhBYQx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 11:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbhBYQvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 11:51:13 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D20EC06174A
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 08:50:32 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o6so3867735pjf.5
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 08:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d+dQFDPw2hN+017lEeCUYd0iXcxmTekddSI6goBA7W0=;
        b=wdOo/ZRw1DvbB7tK8caPR4z/59L89Mbq0d7rFyeaD4HseVC/ic0FKQQ8C7Mmlvr13k
         f0za3xxJSEYYJ3UMh8asGTArf7TGPZXUT+STUzlF3SRAo5MCwrqALiqeMMci/86MZAhE
         IzWpHzX4P+UV/JU10Wq9dexx67q48cBRDSAqESDZMfw2WhQIEV7bFqu/kU3tBTDveIrv
         sPOdJoZQbIEuM1QyjYLK3EFxAQqQicRUzJyVT9LA1CTRLueSHlD0pAVPr0vN2Dhf8dUB
         y/bQjpvRIGN4ROWcnvGQU4oFUNAa/Vn0KnW91G1awfgmFRz6DNEtfzLrQHoFsVZaY30t
         VcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d+dQFDPw2hN+017lEeCUYd0iXcxmTekddSI6goBA7W0=;
        b=enfmkYew50OqRL7v00aYKv1pudC9B7jhB1ijES4EeXXRTe/6tweixS8ALaCiip+tlt
         IvlDioeNHL8w4msbNKFigYLzb47ATq+3LItqmm1njA5q55aaDNV9HUQ0usDsANucdqth
         8/8tyh/HkMpkGS6j1obnHggSsIRinBTsBrIxgBcWl9k/obCDnh+YrAy4KjxZ68eSc57c
         E5cZd/bkUV3OdJtq8iTlXjp50zOehyW7X6Dj5cSsw1rZ7CgvrjhAb0I9PtkIG3nn4Axq
         ldIgwsUNcvD1jUi62wqROZ/Eud7blJn4nOS4j2C0ioGWzVcVHRyg9+oZeQhDhemaIuIT
         dNTw==
X-Gm-Message-State: AOAM531C9ucznXhHnVZq58rhFm9NqheSq1N/yil0NeWopCSMJQ65ntmW
        KJLqsveHGTbnC3jlHFXmWmKxTjLvgjBCsQ==
X-Google-Smtp-Source: ABdhPJxM/6Q7SOPDHgMSaJqux7aY7/AIyWZbQ4JrBQvLhtJDLSeOR3iESEbqtbDFqfnSFbsHawz8zw==
X-Received: by 2002:a17:90a:7e8f:: with SMTP id j15mr3967588pjl.223.1614271831446;
        Thu, 25 Feb 2021 08:50:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q7sm6641299pjr.13.2021.02.25.08.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 08:50:31 -0800 (PST)
Message-ID: <6037d557.1c69fb81.17512.e24a@mx.google.com>
Date:   Thu, 25 Feb 2021 08:50:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.100-18-g981a14c3f325
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 100 runs,
 1 regressions (v5.4.100-18-g981a14c3f325)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 100 runs, 1 regressions (v5.4.100-18-g981a1=
4c3f325)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.100-18-g981a14c3f325/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.100-18-g981a14c3f325
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      981a14c3f32577a8b2c1d21b17f134b14d41c89a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6037a109197155bc06addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.100=
-18-g981a14c3f325/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.100=
-18-g981a14c3f325/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6037a109197155bc06add=
cc7
        failing since 97 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =20

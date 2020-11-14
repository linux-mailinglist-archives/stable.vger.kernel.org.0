Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38B52B3168
	for <lists+stable@lfdr.de>; Sun, 15 Nov 2020 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKNXeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 18:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNXeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 18:34:17 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDA0C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 15:34:17 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f38so9773592pgm.2
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 15:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RFr5S0Qx4BX8G9efhmMxSwNe7OoJ2DrgrrIJMx3RX1E=;
        b=r2gpkxT5dCcFdRzuPYuNi8cpX3MUXBLTErmx9ZBlZbaEgHiFj43vYtuvWHozaMdMAW
         gCPPYQOzHuj4mvrpdfGtBClXbYf2V2RJPWtkz1cbrPLa77Seq8NMgdJhw2I6s+hfqJ0b
         rE8Nqc6mpgphMXFQlOKdaJTJOXqppiVcoLuImV1YiMIWvQcgnbMnp687Cn2rw+THTVri
         nvQ6bwFYyt5zrWXxW1QFAlFJX3V+YFTjxAO/Y2zbriXLY9iw/27iicVc5xTKcIGXYzWM
         DCMOy1zPRd9Wh5KgndYF7ISIRxmfZAPe3F2f4ByjJf5zBFv8kCe7UWVmt1XBzq72Lq3F
         jXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RFr5S0Qx4BX8G9efhmMxSwNe7OoJ2DrgrrIJMx3RX1E=;
        b=JEiSjYtxCw36vwkyAXNAdciuNABXEFa5GvW9PjUG+ytNl3W4mf19OOYHUfc0DXDg05
         uG4KalgGxqsKemAXD5JYuW++S8RBamGVrOKqXiuPfBMv4J2ZNrEL9G8bUceZdrpr932n
         nzHRujzG6wR4Mx2euLzFh5q6XQAUVsjAeHboUOpEk77F2/Tyjw0wVTynpdccikqLRjH9
         MQeKenLEoKV/DPi2G1fRrs8/mxnym4Tpw0stRlVpn/k9qir4wJwzwyi7wX1gk6r44T04
         FMGCOKf2iD4uErsWAj3RWNOqGDHAIJ2umry9LkhvUuLEtgUW//NB0UjizPlCl/wr+NQ5
         KoWA==
X-Gm-Message-State: AOAM531pAlRk/ZVh9ZzEa/IpOgKXO4WFIK/66MzICebAaFno98Q0DlT2
        M5CzzOzjRNO6gb+faxBho208KpE4D5vhvw==
X-Google-Smtp-Source: ABdhPJzR498ZujGMEwDqj+i3eUe7slAdAxYlTKSbhxGkH0OkZ+ts3PJy3Uyzoo474cztWOcDN5qbAA==
X-Received: by 2002:a62:2582:0:b029:18b:37c0:766b with SMTP id l124-20020a6225820000b029018b37c0766bmr8157036pfl.74.1605396856956;
        Sat, 14 Nov 2020 15:34:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm13462703pfp.102.2020.11.14.15.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 15:34:16 -0800 (PST)
Message-ID: <5fb06978.1c69fb81.977e9.d28e@mx.google.com>
Date:   Sat, 14 Nov 2020 15:34:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.157-29-gd8e487efe7b4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 76 runs,
 1 regressions (v4.19.157-29-gd8e487efe7b4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 76 runs, 1 regressions (v4.19.157-29-gd8e487=
efe7b4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.157-29-gd8e487efe7b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.157-29-gd8e487efe7b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8e487efe7b4eb65071a7a2667a492d851b727be =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fb02c198ec0f63b7279b8ad

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-29-gd8e487efe7b4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-29-gd8e487efe7b4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb02c198ec0f63=
b7279b8b4
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55)
        2 lines =

 =20

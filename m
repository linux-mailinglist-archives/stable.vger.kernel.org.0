Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94192AE93F
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 07:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgKKGyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 01:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgKKGyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 01:54:18 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1798C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 22:54:16 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gv24so227712pjb.3
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 22:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j1gDceaihuVoRlits2fm6PPFnT19IClH3uE8CtMP+K4=;
        b=jAI620Fp+gK0D8BNydi7Wdv+fbsVwCjjd5JoLSC12drf4cSlyVVC2cIHADxn0ippNh
         5o9YNY5RICYvXluJt2IEFlslSzwYVvG2JDuub2wYSN9L7BBf8939ZhgrrP92gOwA9uQH
         OlJA7miPSzFwUGgxq/usB3D0g3f6TIUzNHaceCn6ObLfq/hnyL6r8HVXSR1q0lX81VUt
         9gt6r47p6OrkdBxxK4VPCwGRR52wgIBaEbekqgCOj7uJAlKRIZnS7rKQHrqUmkUN+ph4
         MARRF0jaqID5zfAiTR5oDLhsTNh4Qe6hXLOQvF3rBeBj4W62DhKEHN9HzK+0n/4dV5HB
         ziBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j1gDceaihuVoRlits2fm6PPFnT19IClH3uE8CtMP+K4=;
        b=r4F+WcDVrfUgr/77EYE3HlyL5jqjdFcYUv2oI9LD4QMIy+YkvLwosbZYeGfxDC3KgV
         hZph/BTwR+x+KgWw+g8z3t22iel5tXwaHoBGKqrvdkjRv0KmEykeq4BF/E4hlVHwVk9l
         OZC9vUvBIOmipUzC7WWUlRKAEORyu0OEILJM09L51z1E/RFEM+mth4JSEOnPs3n6dU+/
         R+IuMHyQLX0sxC8VfRo0iH76nyJ160Oh7wgn3qSTWTDzSEyXzsCKVBRwyk9O4a2aBkGM
         nHVG1X2x+F818u+si7V953BBiJYS1v/GKZ2pSo/U+88ajWzr2G8+eqSzmYDcKrHjd+cx
         IEig==
X-Gm-Message-State: AOAM530ZvsrbfJLX8F0uD4ii7gq5l5fM4eeYFC9DPIb7PxRJXBvz9kZz
        kZVpDsIhYxTtGlVdxFGOqfue39h0oxpeuQ==
X-Google-Smtp-Source: ABdhPJw6ImIUcX1tPY2xNiD2U4594Ofmw3j8fx4grt61JAyHypKsO76933VXVHV0++nKi2PyTAt6aQ==
X-Received: by 2002:a17:902:aa06:b029:d8:bc5b:612b with SMTP id be6-20020a170902aa06b02900d8bc5b612bmr1650052plb.50.1605077655080;
        Tue, 10 Nov 2020 22:54:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm1185615pga.61.2020.11.10.22.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 22:54:14 -0800 (PST)
Message-ID: <5fab8a96.1c69fb81.f8968.3020@mx.google.com>
Date:   Tue, 10 Nov 2020 22:54:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.243
Subject: stable/linux-4.9.y baseline: 108 runs, 1 regressions (v4.9.243)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 108 runs, 1 regressions (v4.9.243)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.243/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.243
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6c52daf91779b01e54f50816bf3eb8f5d9035414 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/5fab58e4de2a19f5ecdb886d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.243/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.243/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab58e4de2a19f5ecdb8=
86e
        new failure (last pass: v4.9.242) =

 =20

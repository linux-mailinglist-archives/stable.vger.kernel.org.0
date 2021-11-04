Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB894455DA
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKDPBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhKDPBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 11:01:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6C0C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 07:58:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x131so921634pfc.12
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 07:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vwr8FZyL46Tc07JkBgrmdfubIPBdSITgV+Ky6PVbk3c=;
        b=JFSbT05aW7msOOUke8yyDzbamC4ANQKNDnTN0NMfBg1MTTcXemuz0mfivutVqMdFmZ
         ikHwarRZ+wwNi/69xcwPO4HByf0b81aioM6AD/LHL/xDw+2DzIhuCM36e3mIY39gtkXK
         B3NFaSOUKUPQA17eoJ0d6auK0u9anE23gJzLPhmdpg0OJj2tZc/PpEUP4M3Gn4xQOP3Z
         2sJP9DVFFbqzV/H6VWmn9cSHsXEt2b9TV7D/w3Ia/a8Fk41AeMgearKNpuyLXeP86BRQ
         kCJ5Hpvcyep/HoqVnkKEe0Tfpro7J3xPpPyGwuvshKeECXre3e/8c/4lJf7b20C61vkZ
         GbWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vwr8FZyL46Tc07JkBgrmdfubIPBdSITgV+Ky6PVbk3c=;
        b=aliFxEW25Dq8tB+Hr0RV2fhT8Yj+EMQj+G34C3PSWUzg3gngfN2VkSTxGRvZMv2DWX
         fh9+aAacSfrU8fVThfmpIGBLdqHGGYqOXY7KUuR4UMEnw3nrEyqWmfxp0om2SaEdlnMZ
         NQb0nEpqQAfCa2ofJ8NSN71SoiW1HYaE6x7vszn4OBfFI0+hwGVBSbGg2N2kg7T7ZeOc
         SUCDO6w0kvxnkaYdFh9hFE/+RrSc0kgKV05dg3Dyb8aFl37OHs/d1hbvavBicSWWvxji
         CkmliWH2UMjVQ50qnGbzaXJF3C6Dkub5w1u7aFb1GE5TYx6tY166sA3kJ+iJxErutyuN
         WRzg==
X-Gm-Message-State: AOAM532LPPKZoLm0XORkJDYCGqUwIUPm6GLYB0ZkATqzwgN47oZ5GuNi
        0Gp1L0S3l9NI2k78ciZMmIjVHZB2BLixqB4S
X-Google-Smtp-Source: ABdhPJwGIpf804/SBa4sZE2/baH+QBMrMRd04BZ+UWfdzMg9XtpJv87CkvA26q0/w8V6TAvGN0PAdQ==
X-Received: by 2002:a05:6a00:23d3:b0:492:7158:2c7b with SMTP id g19-20020a056a0023d300b0049271582c7bmr9847429pfc.50.1636037923089;
        Thu, 04 Nov 2021 07:58:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm4954999pff.57.2021.11.04.07.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 07:58:42 -0700 (PDT)
Message-ID: <6183f522.1c69fb81.9a08d.100e@mx.google.com>
Date:   Thu, 04 Nov 2021 07:58:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-14-gda4108f8f53c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 181 runs,
 1 regressions (v5.14.16-14-gda4108f8f53c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 181 runs, 1 regressions (v5.14.16-14-gda4108=
f8f53c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-14-gda4108f8f53c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-14-gda4108f8f53c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da4108f8f53c4b520158c508b9d6785091a43a9f =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6183c6287064b5c20c335927

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
14-gda4108f8f53c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
14-gda4108f8f53c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6183c6287064b5c20c335=
928
        failing since 10 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20

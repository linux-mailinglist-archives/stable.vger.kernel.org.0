Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943FC29FAB3
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 02:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgJ3BtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 21:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3BtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 21:49:02 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03794C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:49:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 1so2211721ple.2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UMnJcR/53EIf63OuULq6TYw+aGOIQOpBT1Wlk5a9Z+E=;
        b=HXdEbaRnmPmSCsskS69eydYoLHZmb37cmANoQcbe2HBxZm96mu1D4/tjrQpKm7Crs9
         ZDPfG8mI28oDI4bRz/sirvYkGRlAJlHolwfagMECocpKgKhJhuvoUrYwLYC7rJZIRBbP
         77ZmU3SSzyF4JuMEzu1oHEPfc+w5xbLbdMfJCI1OOSabu6AMZ2jhlvB+VgzESxg+XJQb
         XywhP9pqIIDhxqXWGei9C1DXeSHo+947sD66MaeBKShmz8zupLOVXcNQYRucXd4JGZZ8
         5K/kjOLnKIZn7fZIccy8V+gRJ8/h8UCl1okaVYXCN/0o0Sd+Hk0hrXFM/q/MU2MB55zx
         mCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UMnJcR/53EIf63OuULq6TYw+aGOIQOpBT1Wlk5a9Z+E=;
        b=D7bJ+oapvoHmpUXyXwjmDiNloUYSns3LHMHwuUneNBkXJJ14kOZUa+WEHtT+vBdDRa
         ziQX7drbRMtXRuvYCm3NBaPIVKL9YhTY+e0zhfpA2PuXhgq8IfDLD8wEBfCx5yahgKd3
         tz1Jt9I952faZ27didM1AFlMH64ot1Rq10IH2oussBm5I7PijePgZtaLyBYrYkVvCS7G
         rUTiGqHIbfAaZKBxNnGXqB9Bl4hgtFeh86ElPDyOPOh9esfcMg10gIiyKi+1aR+1Dsdr
         1DFkHHEoJ6Mgphjhkrh6+PNL4Eng23loE8lXGFxojYYZ1/Fa+joc7dQT89Y+n3iuO7qB
         bVfw==
X-Gm-Message-State: AOAM530LQP+pVEyoJqMlFemOw9wikNRhrUaWz0kp7YzU2fM8UURNegSg
        t+WG2f8jd4VPeTrxzt+/CgBPgLRIkxXPPg==
X-Google-Smtp-Source: ABdhPJyls8EfcTKNHQwIXqDmMkW5MwpvmnqrcaZiJOpQ7r5w+RRsZZ9ScjEb1AxpymS+s6RQ7IqNsQ==
X-Received: by 2002:a17:902:d695:b029:d6:a255:ae32 with SMTP id v21-20020a170902d695b02900d6a255ae32mr31597ply.43.1604022541043;
        Thu, 29 Oct 2020 18:49:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i123sm4187245pfc.13.2020.10.29.18.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 18:49:00 -0700 (PDT)
Message-ID: <5f9b710c.1c69fb81.cda87.acf4@mx.google.com>
Date:   Thu, 29 Oct 2020 18:49:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.153
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 184 runs, 2 regressions (v4.19.153)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 184 runs, 2 regressions (v4.19.153)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 1          =

beagle-xm             | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.153/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.153
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      79524e8c64bda80bb35ab490177d0e6813bf112c =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b3aa4eae87282ec38101f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
53/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
53/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b3aa4eae87282ec381=
020
        failing since 135 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
beagle-xm             | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b39b92c9c8cf62338101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
53/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
53/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b39b92c9c8cf623381=
01d
        new failure (last pass: v4.19.152-265-g8919185062d4) =

 =20

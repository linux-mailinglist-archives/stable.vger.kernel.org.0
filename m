Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE029C91E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 20:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1830360AbgJ0Tjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 15:39:39 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:34071 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504405AbgJ0Tjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 15:39:37 -0400
Received: by mail-pg1-f177.google.com with SMTP id t14so1393201pgg.1
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 12:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1Ut5eaYbDiPGl9hrKJkYtLnHjCCbclp7h+qboMhkBNw=;
        b=ZLowHWy4hfnFMRxuaKaTLOAXbhBNWMnKRyNbrYNZBR44LCLjv/CUjiGUVZmhYm0NRP
         +iuXudrvJT3iyF6rzYKH2VSQaBK7rI9wX4x4sZew4fZtTtTdDvG2lMYNm5UaV5peKbSv
         f0LeQxuv3BpFoSG73lpruulw55CH4dvfoJgKkcrrIlNC8/UF1tIaa1mh++qHFKam+2SI
         F7nON7Fkg8jR571lDpslpFSI1GjmTYweqCRZE9QBIq5aKVS9LqIPSRS7ZlsSzxVCJFtH
         iH9wV1+ba9XhPrJQXpAUHCHiy974j+emlSwr12Uyxuvl/k37SgCvbFaIl/I/EtIxOOmm
         K4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1Ut5eaYbDiPGl9hrKJkYtLnHjCCbclp7h+qboMhkBNw=;
        b=ExzI0EMsMi5czDTJN0EUqcrXrTBwPYfnkbFVeVYY1N+fA36Q0N7UgYRO7zR5TOi3pw
         yFwOW9fATj8rHkwTkzAu30IRHR4KjHw4Qne6n29CrZ+HH9zbXraLhfA8Vfs+5xAkHBuY
         0IdgTrcjH+ZCrCPPZmNzk18Y09XsFvu0SABvgd03LcduKmy4wtfq+x+PedOI1k+sBU4l
         exTzQ9a9elRZpX6C6/m3MGiVaDYebFexXm+rrq21ZbED2EtPxfpVgWIUsr18n7xv7/Fg
         Xxxns90WoaWkzaQoYilMPSeOKXbyDOPtwXJ9WU4OEzR2rbD4kOxkSq4qahERI+qrRc1s
         gSiA==
X-Gm-Message-State: AOAM531ljd1Ia3SoAFT/sjK/5Mtw/mfRz4jm9zxvLG2cDsAbJtOs8NqQ
        DCDYydR+1NdkL/HRGVtIm5K80LDlycm4/w==
X-Google-Smtp-Source: ABdhPJwjkxkQIKED5cJs/JcplW0nrAKvbo1cJRq2Jk6/280OVwEAfNwoe4sUaNPTqsrDUuWBOwbaBQ==
X-Received: by 2002:a62:a10a:0:b029:154:fd62:ba90 with SMTP id b10-20020a62a10a0000b0290154fd62ba90mr3144821pff.62.1603827575787;
        Tue, 27 Oct 2020 12:39:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12sm2844987pgr.4.2020.10.27.12.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:39:35 -0700 (PDT)
Message-ID: <5f987777.1c69fb81.8f640.52f6@mx.google.com>
Date:   Tue, 27 Oct 2020 12:39:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-409-gab6643bad070
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 189 runs,
 2 regressions (v5.4.72-409-gab6643bad070)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 189 runs, 2 regressions (v5.4.72-409-gab664=
3bad070)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.72-409-gab6643bad070/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.72-409-gab6643bad070
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab6643bad070b82c2f3cf336bc18c87eaa5c92d0 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9842e985b4f133dc381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
409-gab6643bad070/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
409-gab6643bad070/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9842e985b4f133dc381=
013
        failing since 198 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98451d53aea1e67938101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
409-gab6643bad070/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
409-gab6643bad070/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98451d53aea1e679381=
01d
        new failure (last pass: v5.4.72-55-g7fa6d77807db) =

 =20

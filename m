Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B32ADB2F
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 17:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgKJQDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 11:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732720AbgKJQDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 11:03:30 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08913C0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 08:03:30 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i13so5765884pgm.9
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 08:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wgR9CJXsLiDFOFUf9CXpbasNR/I43RikWonPzlVmxvA=;
        b=p357ShUF96n5PwqZmBQKz+nJFVs+JbxlQ3LgtNA8vDCRgaAcxCR85FIeWhxF7udIoJ
         yrw64w/Rs7iTB71i5NPDJfbjTpCAcmT0kPB+cQQb2Lv/s2omlzzxD4z+NPb1TLc8/79C
         VAcxV1RyOAekhKRfox4mITYF0oY6YpLSfO6OL5Pl7cF4tbdWAlHIJlbirmkSZcwCdB+o
         DcnYLKouJpkEQ1fazALniqZ3Y40xBII4dxywh3rXEJwSr6K7rt+eX2AHrmCLZ+ew+r34
         bKerGiJiJhX/5iH8uEUcff9R5MtNpPoTjlRFURsMcGCfufWHkvXelVnwfoGcRAU6L+kA
         Qdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wgR9CJXsLiDFOFUf9CXpbasNR/I43RikWonPzlVmxvA=;
        b=ojRICs7RO2KvrNbt8OLSt1EODifOh1XsFUGDMf8iPCgH8mV04HX/Yz678z0lHc1bYw
         RUFgpBu1nQkocRXkM3OsMeDu3Fwo5WhEUMqYHvpnTJDDJrbh/+l2BotixR+FOwnliJ51
         FTIG2ErygT2NraMbJn2Lcv4+S4RFMw3R5zG59hrgTWRWG6KOUwDJtxS4ZEE2eoFhTCi1
         tanaVfIjCh0Pk/5BV5wHwhHX5/Ui6vHsxpQns53WfI0K/iSGBMHWKAzR6bIgGtv7Qkkw
         DdJSn3OofaZJj8KQCu6guqUUTyzgySSIVDyJEzBGuULPhoEfMVw+l6SMOFgTuPiYS1o6
         autQ==
X-Gm-Message-State: AOAM530gfb5WQHOh3MDx+9g9t+aXSIIbdkVZphDHn9LV6nGbvNCoal8N
        3xK7L75XgPlMz1P4GHmMTfj+xhW7C3Juwg==
X-Google-Smtp-Source: ABdhPJwhC9yqbnRkVp78Pu4MSjiMLlnBPMMvjLIMzBbr2iTkatNpVCxMUO/R8/CfAMJM1+caUBGsDQ==
X-Received: by 2002:a63:e757:: with SMTP id j23mr16208124pgk.301.1605024209241;
        Tue, 10 Nov 2020 08:03:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm14785885pfg.192.2020.11.10.08.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 08:03:28 -0800 (PST)
Message-ID: <5faab9d0.1c69fb81.ea411.02c0@mx.google.com>
Date:   Tue, 10 Nov 2020 08:03:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.18-26-g0310d9f303bd
Subject: stable-rc/queue/5.8 baseline: 149 runs,
 2 regressions (v5.8.18-26-g0310d9f303bd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 149 runs, 2 regressions (v5.8.18-26-g0310d9f3=
03bd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-26-g0310d9f303bd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-26-g0310d9f303bd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0310d9f303bd134f0ab1e8d31b1329c1edc657eb =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faa8770d000f49a3edb8884

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g0310d9f303bd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g0310d9f303bd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5faa8770d000f49a=
3edb8887
        new failure (last pass: v5.8.18-26-g4c79ffd3cac10)
        2 lines

    2020-11-10 12:26:18.133000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-10 12:26:18.133000+00:00  (user:khilman) is already connected
    2020-11-10 12:26:33.754000+00:00  =00
    2020-11-10 12:26:33.755000+00:00  =

    2020-11-10 12:26:33.755000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-10 12:26:33.755000+00:00  =

    2020-11-10 12:26:33.755000+00:00  DRAM:  948 MiB
    2020-11-10 12:26:33.771000+00:00  RPI 3 Model B (0xa02082)
    2020-11-10 12:26:33.859000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-10 12:26:33.890000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (387 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faa884206affee3a5db885c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g0310d9f303bd/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g0310d9f303bd/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa884206affee3a5db8=
85d
        failing since 0 day (last pass: v5.8.18-26-g2f46df01d254e, first fa=
il: v5.8.18-26-g1bfb85c48918) =

 =20

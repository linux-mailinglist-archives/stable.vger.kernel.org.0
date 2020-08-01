Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E002352B5
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 16:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHAOWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 10:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgHAOWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 10:22:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E730BC06174A
        for <stable@vger.kernel.org>; Sat,  1 Aug 2020 07:22:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j20so15861013pfe.5
        for <stable@vger.kernel.org>; Sat, 01 Aug 2020 07:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y1aQ6ESdpk/7eymky8E7aIhOOtIRPyCL7y4sGjAdyYs=;
        b=g/NMHWMxDt9DeTO6x3sxFk9jJOARZWYZdjhUpnPEcRcafMdb0OTyi9zJ0RPiwRQw4L
         X7Zb2gnY15+JuwyJ2kOBFWdHHR0opRYZO7LPd5bUTUsgFP7/VonE4I2ONN4uBbXeXemy
         KlBShV7O5xOlUpzRAsLI4fY/xdUOF5aLym6zgr3sB3/hY3tlociuKejPf65R4fUcdsJr
         6HzT2903oM7gLIgDIqIja7f76DMyUG0Tm9PsaWqj+nGH+PAaUiCc8R56ZY/Uz3ihuoGn
         LHvW8Gxt6gvA39JKYRnmY37/GcEWJ01YA3OtVPx0vasMYjwFfgTlfS5P+uKimE/W1GDo
         crow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y1aQ6ESdpk/7eymky8E7aIhOOtIRPyCL7y4sGjAdyYs=;
        b=jQohXDXyzrUy0Uiv9W21QVAkgMWujBpHcoT4E/v6QruUB13u4LIxfTEqmCyxZwdlar
         TqlKN1S7ht/mNupL8TKXWGtauBxcRmkQq9b21v3c8DyI80ArsVD8CJHaJC2AHtyNSM+Q
         nXwWE0WtrCv1rAwElFWSahyvmcSyj62JfAPSuhNUGN6I2/6etII9lt/xH9F8IrPpzKS9
         bc2AEiU3myu/iQM3e9ZdxACShjjwpgBxnIGjbswl/JW7zbVbisrwWv0RkPiAqLHAp1g2
         ZlFETrLP1r0PR0JsiPUxcmXqLdg8Eia/CKRdi+a38ErqMtIxmqJG7ev72SO/A+fkhSmQ
         g11w==
X-Gm-Message-State: AOAM530Efob/hEd/BuuyAFr9xMLE4hJpUOjnQR5/LQ6UcAYaCgxLDCiZ
        kXi/fxWGiCsanaMbZb0NgCg7lpgst9w=
X-Google-Smtp-Source: ABdhPJw/f4J24H3nMzYONPj0T6z2tx7VTTpo2eBM45ZCy5KaBH72e8QmcDJVPw8iEEZi3CVCFqDrKA==
X-Received: by 2002:a63:c404:: with SMTP id h4mr7902380pgd.336.1596291750891;
        Sat, 01 Aug 2020 07:22:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm14511406pfn.171.2020.08.01.07.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 07:22:30 -0700 (PDT)
Message-ID: <5f257aa6.1c69fb81.963ce.3f72@mx.google.com>
Date:   Sat, 01 Aug 2020 07:22:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.12
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 194 runs, 2 regressions (v5.7.12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 194 runs, 2 regressions (v5.7.12)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67da9e2c2b730b9b788ace749d22d769cf11ee2b =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f25468531031268d852c1c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f25468531031268d852c=
1c3
      failing since 15 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f254815b8c051f44552c1c7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f254815b8c051f4=
4552c1ca
      new failure (last pass: v5.7.10-199-g3d6db9c81440)
      1 lines =20

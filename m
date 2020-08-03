Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C37223AB34
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 19:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHCRB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 13:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgHCRB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 13:01:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F076C06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 10:01:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kr4so226633pjb.2
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f3lWzYQkaFLKdTHGgW8aN2r4T2wa0kYmUlqgBvNR8sw=;
        b=hn56r3Qs8CCItwDP8L8FH+uRhzc3mQDXdk5BWTKepyzYFvyH0LP5Yd7hr1GKpVD2bK
         S1DMA/L2T9W8gsq7GRvG6rGdNBw4ZTk86FQGjJom0jC40yaAcvIlcZ5D6eMk+yl36hnC
         v5yPZj0FwWAqFoJ+LtJaVmHnn7N7/m5NGPQoxUDtoF7/2oeTNv3Omw/gQgIorCvFl53F
         0WQ6byAkI47Q5PgIh2Jx0avYAHPR+ydfIS0g3Nd4sJqzTdzfHEICRg0hEcFiG6NnsFEH
         sJo1kaCBdOHCEn6HIIj7oRc28musxxoM6o9DxrBdj3Hpn3nqf2Ro0t0KTaGNmjKmfuow
         +Hcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f3lWzYQkaFLKdTHGgW8aN2r4T2wa0kYmUlqgBvNR8sw=;
        b=DJ9QVrnRX1dlfy5m1teGlrN4gGcabZPrIsLEY+5+m78kqhYHqUM7TzONqMA/DqlVSr
         SxTeVVRokpK9Hi/JmC4i6Fb4DYbyuOQPEMpo+KzANrUjcRralTA8TO3KG6uMtdQri/8v
         u1e3kmjf+ZCHVtroIHp/35pHY1dlc9d20o90KVZvbcFYRGTFHjPGAYuZ+S9bVDViM/8u
         uOvkB4YzPDHOUmiPK2wobFKiT5/umBkxhv+w3/MNTJgDfCHkJomWK+V24IP73493ZQsq
         TNbnP0oDtE/QEZYYSPG8qrmWqOGqkx4XCOf/w/AJIY7wm+HMSwr2uT4dolcU40P2URvv
         AfOg==
X-Gm-Message-State: AOAM530V8bQBz1vZ2jBNnDp8/5BNiRCmk1DrCexDhZ3weNWFqB5ZAr/Q
        xkWJUcs/kYJmM1jtIQsVQWtPYmhUDOc=
X-Google-Smtp-Source: ABdhPJxIWaCIS81EChS6gUaOHGO5Muzv8i/63Fwlc1k4/PpuP/myzwW5jWJ4wUF3StLVHptg7H5DqA==
X-Received: by 2002:a17:902:d704:: with SMTP id w4mr15976336ply.278.1596474085840;
        Mon, 03 Aug 2020 10:01:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm19694510pfi.79.2020.08.03.10.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 10:01:24 -0700 (PDT)
Message-ID: <5f2842e4.1c69fb81.2274d.26c0@mx.google.com>
Date:   Mon, 03 Aug 2020 10:01:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.191-52-g333e573a423b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 163 runs,
 2 regressions (v4.14.191-52-g333e573a423b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 163 runs, 2 regressions (v4.14.191-52-g333=
e573a423b)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.191-52-g333e573a423b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.191-52-g333e573a423b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      333e573a423b816b8b28000d6106fa52bd98e198 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f280b01ad25e79a3652c1b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-52-g333e573a423b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-52-g333e573a423b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f280b01ad25e79a3652c=
1b5
      failing since 10 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f280aab695a1663f452c1d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-52-g333e573a423b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-52-g333e573a423b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f280aab695a1663f452c=
1d4
      failing since 125 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20

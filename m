Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1543DAE02
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 23:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhG2VIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 17:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhG2VIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 17:08:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0565EC061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 14:08:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso11327270pjf.4
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 14:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uiD3xQjBGzAabmWpo8iYwn2oeaXOTUeqri12U6Hwyq0=;
        b=YHLAPcijqrGdUD0T13fNXhiPgYF4PUzRPGZZ6CFZPYUgK8wbZJ9FBaFAVhi2b9SYD3
         C/cGQZJ7dzusGqxv5duAV/8U8foUPHVRcZtyDxCR9I7Rcesr3bX65oRMex/Qq9ISBL2h
         M/lBndQFT79ILRsf1zFf4a40CScKJS9b4V8TkygIgqJ2pxeDKncDsWi8xZ89KP1ccc39
         QX8kdYfsPVmZLJikj72Xo5PL19jhxTr8JqHy2Q5qMKyBv6U3uKnMSWHCQaZ+DKbdAXRX
         qhb5CgvPmblE9cGaCmNvxsjhU2IPHpnBpphDBZ5xQCCUcw0uuldjQno9wBSXWN98haE0
         joQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uiD3xQjBGzAabmWpo8iYwn2oeaXOTUeqri12U6Hwyq0=;
        b=qurmLDSxO3iTsdDYT0KKboxMWUTClgzjS0fT115o3YbiK21JhbAGD+Ah25Zck0CXke
         vvvDqP+j7yKG/CUadiErPNxnj35xgcqcZFHllRZlUW7ImFNB8hB7BG+bLLtko2ocEhhF
         oDWfbvVMlNTAaM+o9NmSX9NdbZSQqGTDSeD5QaZRuIgSVHQo+qIkMmfqs95xfzumEACy
         5AO0ZMCFCpb/DM1UN8tanyCMEsRPOjhE4CtcS6rJ20uilJZ4PVZFG2KqkPI33LTUIjPE
         AscMdtLlxG+QEgzYU4NXj5jx38+qL7YqjBP/gmjfT/5eUMsh1SrmBqNVicH2QilIPXL3
         nacg==
X-Gm-Message-State: AOAM533l84S/RajEFz43jYNFrQqtq3iuLao0rFs7hqpqk0WvbOL21lzd
        UWpjEm09rcbhhDyo5zL3iASus4BBsAlduOjV
X-Google-Smtp-Source: ABdhPJxhKZaVeTH0KlO/D4Ld4b8bLgIWYYCT1GGkFMpjAzI8BoWFqO/l3nu9Q3tUX7+DF5LsIKvgkg==
X-Received: by 2002:a17:90a:9b03:: with SMTP id f3mr6983138pjp.184.1627592888304;
        Thu, 29 Jul 2021 14:08:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15sm4780144pfn.63.2021.07.29.14.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:08:08 -0700 (PDT)
Message-ID: <610318b8.1c69fb81.3c77d.f020@mx.google.com>
Date:   Thu, 29 Jul 2021 14:08:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.54-24-gcf47f1842d05
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 5 regressions (v5.10.54-24-gcf47f1842d05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 156 runs, 5 regressions (v5.10.54-24-gcf47f1=
842d05)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 2          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =

imx7ulp-evk        | arm   | lab-nxp       | gcc-8    | multi_v7_defconfig =
| 1          =

meson-g12a-x96-max | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.54-24-gcf47f1842d05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.54-24-gcf47f1842d05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf47f1842d059bf20570916e264979761c391f63 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 2          =


  Details:     https://kernelci.org/test/plan/id/6102e28ddf51e4f7f85018f4

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6102e28ddf51e4f=
7f85018fb
        new failure (last pass: v5.10.54-2-geb01b613f84f)
        9 lines

    2021-07-29T17:16:38.430016  kern  :alert : 8<--- cut here ---
    2021-07-29T17:16:38.431538  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00<8>[   14.555924] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D9>
    2021-07-29T17:16:38.432299  000000
    2021-07-29T17:16:38.433094  kern  :alert : pgd =3D 775d1500   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6102e28ddf51e4f=
7f85018fc
        new failure (last pass: v5.10.54-2-geb01b613f84f)
        234 lines

    2021-07-29T17:16:38.436590  kern  :alert : [00000000] *pgd=3D041d0835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-29T17:16:38.437377  kern  :alert : 8<--- cut here ---
    2021-07-29T17:16:38.438032  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000000
    2021-07-29T17:16:38.438676  kern  :alert : pgd =3D 55573122
    2021-07-29T17:16:38.475958  kern  :alert : [00000000] *pgd=3D00000000
    2021-07-29T17:16:38.477285  kern  :alert : Fixing recursive fault but r=
eboot is needed!
    2021-07-29T17:16:38.478027  kern  :emerg : Internal error: Oops: 800000=
07 [#1] ARM
    2021-07-29T17:16:38.478703  kern  :emerg : Process udevd (pid: 98, stac=
k limit =3D 0x5ab9fa9e)
    2021-07-29T17:16:38.479320  kern  :emerg : Stack: (0xc41ffb80 to 0xc420=
0000)
    2021-07-29T17:16:38.480375  kern  :emerg : fb80: 00000000 00000003 c14f=
c040 c0e04248 40000093 c429100c 00000003 00000000 =

    ... (182 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6102e762b7734885745018db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102e762b773488574501=
8dc
        failing since 28 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx7ulp-evk        | arm   | lab-nxp       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6102e615fa9815af6b5018fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102e615fa9815af6b501=
8fe
        new failure (last pass: v5.10.54-2-geb01b613f84f) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
meson-g12a-x96-max | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6102e55b7f60f9aa2c5018c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12a-x96=
-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
24-gcf47f1842d05/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12a-x96=
-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102e55b7f60f9aa2c501=
8c6
        new failure (last pass: v5.10.54-1-g8d71121686cb) =

 =20

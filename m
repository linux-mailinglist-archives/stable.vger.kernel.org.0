Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB734FB06
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 10:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhCaIAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 04:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhCaIAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 04:00:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CCEC061574
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 01:00:20 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h20so7493927plr.4
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 01:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nMQMcZvFbbz0fWAcEn4Jf4/f361r+Qf57+aC9SZX0Vw=;
        b=faKXm5QQNJCMiRZGRfOAaj53S7jzIPfYUjrUFfl/HHUnXPK1vO8+2o0J2BcupMjUus
         DxtR/vXPUXXHpGyPxhH/4M2tSQqtIVtY2KPysbWgE5VaGy+sWgsLL4gYSsv6yi1fhVIE
         dYJvoYEdcNL+rdlviv7VUO+z6+S6RmwXe/zEDtVujOl7IYz9eppnMawnWgu4eZ7KnJdZ
         +3L5VnDOV1bmXGbVJ1uOwAjnghUqwDSY4bRaIqtHP0nBvajwmWpcGqJuAODrxHRMWA1+
         cmH5xRkb2TG4vgntQ/URsksH++6Gttd8Y9/dFYMvXsgPOULaBU5je43VmWZkZGVRAcur
         JD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nMQMcZvFbbz0fWAcEn4Jf4/f361r+Qf57+aC9SZX0Vw=;
        b=lHpcCIpNa5o04L5+Lbq+jXLhKDIPHr1stoxIhwswnNFfyAGiSfwKuunG+yqPbLXz6C
         +0AzMn+BXHwmnpXKR3fzrUoygwQKiJVyrbIc/O6FvLh9Ghdh/iF0KY42p8LXYdQnSgls
         TO/B0Zwaj9PPCbCpdkG7Gj8sZ/67o1QDdydfuHaB75ATxHZzlwnPUNzVbFao2vNMKtsZ
         r5g2f6DP+TkHT0sA4U+ntHKYJe9wrLo2HaUVvtmjs8u3AdvKQXKHYf29L8v+9JgAAXda
         w6NCe1pgsJsBBL/tU3pZsvKvShuUx2Xy+s4xXei0shhHcLKuCf3/J2lS+2EXo8giRkfI
         WPCA==
X-Gm-Message-State: AOAM532IRovTwDJzBpoWC00ubXvVaIsiRMO+jw6fqzBE/+yLG6w1INMI
        rzL2DPoMCr8KD9gI2xbyKH4fYe9w5NWMx9k8
X-Google-Smtp-Source: ABdhPJxlq/ownO08WGJuonZTvu7oKLzmm0NlDHrdlYGXvyjLVOl2HpZBJOJPDxv8jfk0d5UXs6LBuw==
X-Received: by 2002:a17:902:d4c2:b029:e7:32bd:6b77 with SMTP id o2-20020a170902d4c2b02900e732bd6b77mr2026950plg.45.1617177619762;
        Wed, 31 Mar 2021 01:00:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 205sm1441772pfc.201.2021.03.31.01.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:00:19 -0700 (PDT)
Message-ID: <60642c13.1c69fb81.8c497.3b66@mx.google.com>
Date:   Wed, 31 Mar 2021 01:00:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-36-g37e216a88aac
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 3 regressions (v5.10.27-36-g37e216a88aac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 3 regressions (v5.10.27-36-g37e216=
a88aac)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-36-g37e216a88aac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-36-g37e216a88aac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37e216a88aac4099378cecfe25e5c2690da3d60f =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6063fbb83a7eb134a6dac6b1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
36-g37e216a88aac/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
36-g37e216a88aac/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6063fbb83a7eb13=
4a6dac6b5
        new failure (last pass: v5.10.26-220-gbe3b7a407dff1)
        4 lines

    2021-03-31 04:33:46.813000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-03-31 04:33:46.813000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-03-31 04:33:46.813000+00:00  kern  :alert : [<8>[   42.688242] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-03-31 04:33:46.814000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6063fbb83a7eb13=
4a6dac6b6
        new failure (last pass: v5.10.26-220-gbe3b7a407dff1)
        26 lines

    2021-03-31 04:33:46.865000+00:00  kern  :emerg : Process kworker/1:2 (p=
id: 81, stack limit =3D 0x(ptrval))
    2021-03-31 04:33:46.865000+00:00  kern  :emerg : Stack: (0xc3543eb0 to<=
8>[   42.734405] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-03-31 04:33:46.865000+00:00   0xc3544000)
    2021-03-31 04:33:46.866000+00:00  kern  :emerg : 3ea0<8>[   42.745772] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 52004_1.5.2.4.1>
    2021-03-31 04:33:46.866000+00:00  :                                    =
 1e9b10fe 0aeff601 c2381e80 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6063fb87d69449eb09dac6dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
36-g37e216a88aac/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
36-g37e216a88aac/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063fb87d69449eb09dac=
6dd
        new failure (last pass: v5.10.26-220-gbe3b7a407dff1) =

 =20

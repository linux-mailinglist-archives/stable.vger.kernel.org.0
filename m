Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6013E0CB4
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 05:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhHEDK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 23:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhHEDK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 23:10:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1EFC061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 20:10:14 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so5375380plg.9
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 20:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xFa2NVaekG7AJDMrHAVUPVwLtp1PhgvdXuagipFFfRs=;
        b=REDQUK0Tq+OQVKCQmAqI34/ahjlqkt2ObnoVesoy5DmY8RHv6ihZMgYcBfSKjCvhW1
         J0UcRdJ0FfLfNAK5cuNmacp0UL+Agxkc85Vrw/3hfVj5XgNEMtojnH7WP2Z3VmAgUqzw
         te3z5jM1aMds5N2G1mZkoelXAojp0DBFGpNlOuPHsvBMJ8/LkkbhNKRFVvsekPFCpKBi
         vFW2TEgXnu43zP6YdBiMp1INvtCKcxkrXq3VCl91viaGfqUY57eAH0cjWGiKskp+nHA4
         +7VzP/lGLYEMYB/3azy9bM4kx2gd/g5sfDTcP8tNhaERNe8Z2NmDuZbrqKE6nYFuGvJo
         AUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xFa2NVaekG7AJDMrHAVUPVwLtp1PhgvdXuagipFFfRs=;
        b=E80hVxMnzLLuaXsykTZs6Rk6tEimRJZWu/o3lXGeRB70WqRjflPU4N40twIe0cGJ54
         +fqyZFJ9B9u2Y1XB9XaM79VeV6XSDnxyNd6xg3ASJ5kYL4VhgGy3du8kxtjGy09BRDUa
         xMDWmjsblVBRL6NYYGY6+ZqFnA8HZc29uWSuWkegx0QUO9Hwj9+9SY61hzpnZAh29S2G
         4GAnOz9OBU0YbXPcmDYRSqiRhd0dGGcfSDQvIfRHsv1jKss38VhUIuGm9VOHbM7ni3Bf
         3wB1VU68WPfbh1K8VMCXe4biQRVNYKiwlHTudZg2Obt0JvAAyHNh2cXs5BY59CuOXbkc
         kBYA==
X-Gm-Message-State: AOAM533lUcnUFyMqtUY85CqMb6caS2CGlZlJvrORB62c8iCWQQjUz513
        7P8WKhvSSvTzr7Jgj9XPpZ1/xZLd5KmCgNZE
X-Google-Smtp-Source: ABdhPJwxZM8ktSe1SYvvgi1zhK0A1BwvgbqAXPzgDAQS/L0AH0dMfshcwMIU3d+6Bagt5vzkvwUvIQ==
X-Received: by 2002:a17:902:ac94:b029:12c:9bae:7d with SMTP id h20-20020a170902ac94b029012c9bae007dmr332013plr.32.1628133013831;
        Wed, 04 Aug 2021 20:10:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22sm4385265pff.57.2021.08.04.20.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 20:10:13 -0700 (PDT)
Message-ID: <610b5695.1c69fb81.3f444.e880@mx.google.com>
Date:   Wed, 04 Aug 2021 20:10:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.13.8
X-Kernelci-Report-Type: test
Subject: stable/linux-5.13.y baseline: 115 runs, 2 regressions (v5.13.8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 115 runs, 2 regressions (v5.13.8)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.8/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3cfdd7252e00ecf3f3dc9508525acf1e67b7d343 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/610b1a83cdf1234e8cb13667

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.8/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.8/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/610b1a83cdf1234=
e8cb1366b
        new failure (last pass: v5.13.7)
        13 lines

    2021-08-04T22:53:33.351634  kern  :alert : Register r0 information: NUL=
L pointer
    2021-08-04T22:53:33.353647  kern  :alert : Register r1 information: non=
-paged memory
    2021-08-04T22:53:33.354775  kern  :alert : R<8>[   13.433297] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D13>
    2021-08-04T22:53:33.355634  egister r2 information: NULL pointer
    2021-08-04T22:53:33.356509  kern  :alert : Register r3 information: non=
-slab/vmalloc memory
    2021-08-04T22:53:33.357385  kern  :alert : Register r4 information: NUL=
L pointer   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/610b1a83cdf1234=
e8cb1366c
        new failure (last pass: v5.13.7)
        36 lines

    2021-08-04T22:53:33.361324  kern  :alert : Register r5 information: sla=
b kernfs_iattrs_cache start c357a000 pointer offset 0
    2021-08-04T22:53:33.395677  kern  :alert : Register r6 information: non=
-slab/vmalloc memory
    2021-08-04T22:53:33.396508  kern  :alert : Register r7 information: NUL=
L pointer
    2021-08-04T22:53:33.397884  kern  :alert : Register r8<8>[   13.477057]=
 <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEA=
SUREMENT=3D36>
    2021-08-04T22:53:33.398800   information: NULL point<8>[   13.487991] <=
LAVA_SIGNAL_ENDRUN 0_dmesg 647004_1.5.2.4.1>
    2021-08-04T22:53:33.399594  er
    2021-08-04T22:53:33.400329  kern  :alert : Register r9 information: non=
-paged memory   =

 =20

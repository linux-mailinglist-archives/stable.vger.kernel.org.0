Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDC0455139
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 00:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhKQXo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 18:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241649AbhKQXoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 18:44:24 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001D2C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:41:24 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b11so3562567pld.12
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hUDUFUz3lfPwgmOaXNnBZfTOzhw3oY0Wu7gddUvFPf0=;
        b=KVVSLRmXdcTTUM3TaB/Em7FSmHEhq67qNB/iiqp9pOIXmjuaU07o6ZjT2VwVIH1qG8
         vC/wz1SWS8+FHuhmDbg26AcI5ZbpjBZiZDQILBNPGv1vUHbq5QOqUG3Rz+VXeX5R6ppq
         yW8RyCL3dkeY6KMvqXbSJegUiuDAz2uRK+Jk6BL6JIkXk+cjQcfKOcKaDqi7nxMwQZrE
         0TBlPVHj1abJzfCDBCr1skt4a+qE5F7AbAwrlfI4OTQFigbFVykNkfvGvZSjZRl5OK8d
         rW7DG1EJbZJmkzTnjacElDpqhHPx4X0/SMRPc86MFk1bbV16U8eTU92uMni9ej9Oz4ZI
         XqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hUDUFUz3lfPwgmOaXNnBZfTOzhw3oY0Wu7gddUvFPf0=;
        b=Ffe/9NB1Y8rmr34qJvaORzAlMr1mg6EtpUYomjXlxo9c/NQuUDWxS9x25SuIWh5zmN
         JSCd2PFwlGLbwh7WBECbnVucnk2OQoBr/21+tBAeN+vlPigTJ7Xiy5QRSY1MUbkORlvY
         +JLRewPLsCUfc61b/tO1hxiC90bv2RxQzZFNk3reTucgBhxamDQzReKTPku1S6bC2vfZ
         +wutmD32TXXyQIlXNU/yIWl9VkYa2f2zS8k5mWRBKeVtSC7xMr6IomQOOBfR60C7ZJe0
         y2QKR0AepgX7Vg6zUeuZIjEBDkEq02uKHelqS0edUwO6Ovg2cnB+hmBBg5shp9UsGz2F
         jzDw==
X-Gm-Message-State: AOAM531SDyOTZucj7S+gOvxxc6KmB9nwAaavDtakSigu+u3uREBcxvKX
        /VM4G2JTgPu05K+tc71pc1+hahbBhD2sMk/h
X-Google-Smtp-Source: ABdhPJwXsnrWp07bQngA4jTYNvLJn+m49HJ+f0uxx/DdQ1zLJkQZiQjNsaGlQrZBUpe10XnE0KEFow==
X-Received: by 2002:a17:902:9349:b0:143:88c3:375e with SMTP id g9-20020a170902934900b0014388c3375emr60290715plp.16.1637192484390;
        Wed, 17 Nov 2021 15:41:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u32sm689339pfg.220.2021.11.17.15.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 15:41:24 -0800 (PST)
Message-ID: <61959324.1c69fb81.81353.3d97@mx.google.com>
Date:   Wed, 17 Nov 2021 15:41:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.79-569-g878c6aeb961b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 155 runs,
 3 regressions (v5.10.79-569-g878c6aeb961b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 155 runs, 3 regressions (v5.10.79-569-g878c6=
aeb961b)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =

r8a77950-salvator-x      | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.79-569-g878c6aeb961b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.79-569-g878c6aeb961b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      878c6aeb961b8ae3402c653b6cdae389db50f4f8 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61955bc19adb94827e3358ee

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
569-g878c6aeb961b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
569-g878c6aeb961b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61955bc19adb948=
27e3358f2
        failing since 0 day (last pass: v5.10.79-577-g36adb8b9fb074, first =
fail: v5.10.79-569-g7cba82f768816)
        4 lines

    2021-11-17T19:44:38.372206  kern  :alert : 8<--- cut here ---
    2021-11-17T19:44:38.403219  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-11-17T19:44:38.403786  kern  :alert : pgd =3D (ptrval)
    2021-11-17T19:44:38.404664  kern  :alert : [<8>[   39.442536] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-11-17T19:44:38.404983  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61955bc19adb948=
27e3358f3
        failing since 0 day (last pass: v5.10.79-577-g36adb8b9fb074, first =
fail: v5.10.79-569-g7cba82f768816)
        26 lines

    2021-11-17T19:44:38.456640  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-11-17T19:44:38.456944  kern  :emerg : Process kworker/0:5 (pid: 55=
, stack limit =3D 0x(ptrval))
    2021-11-17T19:44:38.457480  kern  :emerg : Stack: (0xc2407eb0 to<8>[   =
39.489797] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-11-17T19:44:38.457766   0xc2408000)
    2021-11-17T19:44:38.458025  kern  :emerg : 7ea0<8>[   39.501243] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1095474_1.5.2.4.1>
    2021-11-17T19:44:38.458282  :                                     1e9b1=
0fe 1c6a76a9 c180ab40 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
r8a77950-salvator-x      | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61955ea1102a0df0093358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
569-g878c6aeb961b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
569-g878c6aeb961b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61955ea1102a0df009335=
8e1
        new failure (last pass: v5.10.79-569-g7cba82f768816) =

 =20

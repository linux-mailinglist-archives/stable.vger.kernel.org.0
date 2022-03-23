Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45D54E55E3
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 17:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiCWQFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 12:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiCWQFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 12:05:23 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9358D14093
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:03:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q11so1927202pln.11
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kcNiuD+tWI1BSbUPY1xr4LBnURTdhXaVuwNGxKmk55E=;
        b=2ynPa/PQNI5ZdQEE4Bl8qzuTpxQz+CdEmlxx9mSxNiC5FstyeTb+522AhwL2CGoNwV
         OCqSYHOBo9gznbV5STpRQB6AFBq6gH3acUuPfz17hqXGFKlVUKgA1XV7umdksr9d8i43
         eYpBUdouNkSVEOjKBMX1zaFhT7u1pjHQOBb8KwnvrS/VOdsZSp39+g0+0f7vrcy5qjo1
         126eTGBOXmGOULYuhkYbdDSsfcThz9VxAeArSWlyRNTBPnPMUhqM8Jw75kp+UM1iO2uv
         kzDAgzn4557evxWvj6Wa25KFeFAIPXSerp45RMQjNx+YPSaFXGPqYL6HHVgfEn1Uobzr
         MYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kcNiuD+tWI1BSbUPY1xr4LBnURTdhXaVuwNGxKmk55E=;
        b=G1FoR1V/gQf/txBVc+LyjdZy0SJV/zJdJsTHWL9muzBLuJgj91XdiTmMzbp683CDN2
         w0It/lxLbcpXud13SGIAmjnAjKGnYGNcJUdTjxH8QvaNT5U6jTqUnPm8Yqn14qj+nqJb
         E/3YkS6VJCy1TSQfyaA5qUSZEHMkryFtOGuEQt1+2vkladWTfT7HvSCQRuHj5yNe2dH4
         7yEcCs/PNMkwedehIcX5gUbNHb+L6kjVMKCYnTTRd6hnd0cMiqXAH3plqj9XmKG9yH37
         Z/HS3bpslSwgPVVgvIyMDFFP1iMSZH3vxgMYpaySUBgJVzoSgf+Ck4bq6fVXAmnJwmFf
         Z9YA==
X-Gm-Message-State: AOAM533VvoQCeFxU4uBGJZXUA+rE3qR+F1EqMV+S2kSMhPaFkSmf6JZf
        adoyzdPY2duZdMjEn0WAUtYBrwiUGae6CoOsZWA=
X-Google-Smtp-Source: ABdhPJzwcWi53koGBJf2B0eRjS0VgWMyDJexWGB2kCryfQGcBmDuw06ff/Yj2NvKemDBoAfC7oRV9g==
X-Received: by 2002:a17:90a:a60c:b0:1bd:6058:1dd9 with SMTP id c12-20020a17090aa60c00b001bd60581dd9mr12443129pjq.118.1648051430947;
        Wed, 23 Mar 2022 09:03:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j16-20020a63e750000000b00373598b8cbfsm230693pgk.74.2022.03.23.09.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 09:03:50 -0700 (PDT)
Message-ID: <623b44e6.1c69fb81.fc65b.102d@mx.google.com>
Date:   Wed, 23 Mar 2022 09:03:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.186-17-gd1ed1cf41505
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 41 runs,
 3 regressions (v5.4.186-17-gd1ed1cf41505)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 41 runs, 3 regressions (v5.4.186-17-gd1ed1cf4=
1505)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.186-17-gd1ed1cf41505/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.186-17-gd1ed1cf41505
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1ed1cf41505572f59890b7679459cd39aecd008 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/623b125c8eef7f4957bd919b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd1ed1cf41505/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd1ed1cf41505/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623b125c8eef7f4957bd9=
19c
        failing since 97 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/623b125e6a545da515bd9195

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd1ed1cf41505/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd1ed1cf41505/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623b125e6a545da515bd9=
196
        failing since 97 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b185e645585268cbd9183

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd1ed1cf41505/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd1ed1cf41505/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b185e645585268cbd91a5
        failing since 17 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-23T12:53:21.399502  <8>[   32.118118] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-23T12:53:22.410969  /lava-5932171/1/../bin/lava-test-case
    2022-03-23T12:53:22.419527  <8>[   33.138540] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

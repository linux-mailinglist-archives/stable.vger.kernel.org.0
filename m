Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB859500389
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 03:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiDNBVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 21:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbiDNBVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 21:21:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD138B0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:19:28 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s137so3399756pgs.5
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XHLXbGI4tyaxAXHK4PfbMonuQpzRL+J25dbS/D0m7q8=;
        b=HXa7FABAiZHuN2rTugFzrPYwiWGv2v+oUuein3E0RrbM4HlMABnKzonD6T/ZlDGiTs
         3SlB2ut9tOuf4I6/8RlojzR/Fbl66SHQUwlLbXcOvojY+v6LTBpmv/Advjky/Mo8vORt
         QrpPnIOtI/sEjvlmb0/LDzMVo62xbrvbQdLff6RcFEoIu/8bWTbA4D9VTR0terX3fFaj
         imG1Glqzo2kc4eXWgGYV0srzE8EecwzpHZW/wZvMdNGvp++Tv3fyjrEPG9w9heM4dvkZ
         FttSu8l0kFcATfT0aCzTrQGTw517c6Ag7J0E2qyGW+SlBdPp3n6fE3XngObGEPvxJ0Uv
         Gnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XHLXbGI4tyaxAXHK4PfbMonuQpzRL+J25dbS/D0m7q8=;
        b=Xj5eg0g0P80ggdbwBL3YysjQ7k4FifYiXFnN/oIByjrA9+e9nmqe3YLGnf5v60EDUk
         0u5qqOY73alk/c0ZkJn5Wlrhs/JsvJrRDrD61MnFfLsoYYh41ay6yQHmCoRaSErRbwve
         kxv2D+Csa2qUzE4IhVyYEBYBTJGxXJWB7Xby+yycZqU1GMBWOa1CdYyBYlQXQCje3hal
         wJvxNMQo0+/MB6QzAu9tWB8HH1OAhxi2xW3HQRMP7Yk40vdhBI/N5HaPQI/LcKeZcazP
         64SwjGVecB9raPItMyboPyBFtiz/IxyRu9kVkY7BtUsZjUDWj2Z52zu0x2stzv8zA2an
         Yryg==
X-Gm-Message-State: AOAM531XGcAGSHvl4w0fmjqZDA0wHnqmjyfSveOK1+ocnhqRzoXSlYth
        oathL1bpCxGpV1v3h3PFJo3pQzAjqs1A4BKJ
X-Google-Smtp-Source: ABdhPJwraECzzd+K8UqmwiD10vyo4dbjYRyKtOMoUNXDX1l6EdVDCyf8r2q714xjRffMdEFjBZPmMg==
X-Received: by 2002:a63:5964:0:b0:39d:2319:2df5 with SMTP id j36-20020a635964000000b0039d23192df5mr280605pgm.427.1649899167850;
        Wed, 13 Apr 2022 18:19:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8-20020a636808000000b00398e9c7049bsm308545pgc.31.2022.04.13.18.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:19:27 -0700 (PDT)
Message-ID: <6257769f.1c69fb81.7a252.14cb@mx.google.com>
Date:   Wed, 13 Apr 2022 18:19:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.110-170-g8734897b96f5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 83 runs,
 3 regressions (v5.10.110-170-g8734897b96f5)
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

stable-rc/queue/5.10 baseline: 83 runs, 3 regressions (v5.10.110-170-g87348=
97b96f5)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.110-170-g8734897b96f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.110-170-g8734897b96f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8734897b96f551d8810681a82aa03c6cf4cd33f7 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/6257445ade87c01d18ae069f

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-170-g8734897b96f5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-170-g8734897b96f5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6257445ade87c01=
d18ae06a6
        new failure (last pass: v5.10.110-171-g3f868052db86)
        46 lines

    2022-04-13T21:44:28.698192  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2022-04-13T21:44:28.698456  kern  :emerg : Process kworker/1:5 (pid: 91=
, stack limit =3D 0x(ptrval))
    2022-04-13T21:44:28.698676  kern  :emerg : Stack: (0xc36ddd68 to 0xc36d=
e000)
    2022-04-13T21:44:28.699106  kern  :emerg : dd60:                   c3d6=
c9b0 c3d6c9b4 c3d6c800 c3d6c800 c1446608 c09e4c70
    2022-04-13T21:44:28.699325  kern  :emerg : dd80: c36dc000 c1446608 0000=
000c c3d6c800 000002f3 c329af00 c2001d80 ef85d340
    2022-04-13T21:44:28.699530  kern  :emerg : dda0: c09f23dc c1446608 0000=
000c c329aac0 c19c7a98 edc384f7 00000001 c3b56d80
    2022-04-13T21:44:28.741305  kern  :emerg : ddc0: c3b55200 c3d6c800 c3d6=
c814 c1446608 0000000c c329aac0 c19c7a98 c09f23b0
    2022-04-13T21:44:28.741555  kern  :emerg : dde0: c144432c 00000000 c3d6=
c800 fffffdfb bf048000 c22d8c10 00000120 c09c8398
    2022-04-13T21:44:28.741774  kern  :emerg : de00: c3d6c800 bf044120 c3b5=
6380 c397ad08 c39d4e00 c19c7ab4 00000120 c0a24dd0
    2022-04-13T21:44:28.742198  kern  :emerg : de20: c3b56380 c3b56380 c223=
2c00 c39d4e00 00000000 c3b56380 c19c7aac bf0b80a8 =

    ... (35 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6257445ade87c01=
d18ae06a7
        new failure (last pass: v5.10.110-171-g3f868052db86)
        4 lines

    2022-04-13T21:44:28.610304  kern  :alert : 8<--- cut here ---
    2022-04-13T21:44:28.639176  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2022-04-13T21:44:28.642383  kern  :alert : pgd =3D (ptrval)<8>[   39.76=
5565] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2022-04-13T21:44:28.642639  =

    2022-04-13T21:44:28.642859  kern  :alert : [00000313] *pgd=3D00000000   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62574a7e80debb81eeae067c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-170-g8734897b96f5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-170-g8734897b96f5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62574a7e80debb81eeae069e
        failing since 37 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-13T22:10:57.554897  /lava-6082726/1/../bin/lava-test-case
    2022-04-13T22:10:57.565304  <8>[   33.601161] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4181E4CE854
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 03:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiCFCth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 21:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiCFCtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 21:49:36 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93C122BF4
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 18:48:45 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b8so10398361pjb.4
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 18:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EQN1wMCeu5ocGXlBXwl2Xl04+JAFVcXNS0nDUpa3ND4=;
        b=PRAFMi5aowEqJZCDBSgPBzU8SDTUUXl7ekA4VqfE14t1Yh1K54tQVTgiZQ2Tb6Q+9c
         VF/BNE9Sge/YLGX4q0DjL/81MQEYWNwKrojfyT2PSxpXZeTTaszpX7olU7RtsyKdOluX
         pZm4A4y/AicVyF571KjVR74wzw66d/i/voWdc8mPt6G6yjnaz9FSvvXAUuBKj4M0p6DG
         VGOniJ4Nz4VFV2LcCg77P84c8KbmnurX8WMsG7QPgAKXpVRqkpLGmXgAK6uby1tvUaSW
         xHq6ekq2uf3d59nOLsTsAL2Sc7MqQaP+OX3MEp/Bqt1amc7VQFMTo8LVZNclGEodaqPp
         UM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EQN1wMCeu5ocGXlBXwl2Xl04+JAFVcXNS0nDUpa3ND4=;
        b=cJE/4Eicr6PkPiMPxUKDBYJNGJyWLmFNLOJwZbhZsB7ecO6sxPgUlXKAhAzDWlPnP+
         m6+6rxFmW/XiHdnX5fjGdtBhsNVYO+jk+0IMiS0aWTm+yeFtMDwF+x038V0ON/kn2sRY
         dL+bS7M6KZqWOVhVtNCNrUR9XBkNj/WephFTnzx/slry4XWgpa399Sh8pk0fhgRs04Zy
         hkWD93IULQRzrAulmlSfiAlFiJJojmUXDEpS6hrVCWmpuu2fzILubGwbxGYLs/MoYu97
         SHlTiPp7AsAOuhT+J11Dgg+aujaRNgtCSrGty4KILzMHMsXYRJd4rrws2rC5dmjZzKqC
         oM/Q==
X-Gm-Message-State: AOAM530GfDjPrt5YdJZ8JmK5S3gQcowSnPjG6lSIYGoyuzFldOLxT1OY
        N8HInhhFJt4OcfiQd4+vqQpz/ANZwuypygX2Csk=
X-Google-Smtp-Source: ABdhPJxuy+Fv1Ss8HfZq+8eW+5AXSTXDKQT8Iiav6ayvOYuE6vqfXJv+fWcu14sXCTJi2u9QALLqIw==
X-Received: by 2002:a17:902:bd95:b0:14f:40ab:270e with SMTP id q21-20020a170902bd9500b0014f40ab270emr5816316pls.101.1646534925021;
        Sat, 05 Mar 2022 18:48:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t11-20020a056a00138b00b004f1343f915dsm11308762pfg.33.2022.03.05.18.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 18:48:44 -0800 (PST)
Message-ID: <6224210c.1c69fb81.fca17.de00@mx.google.com>
Date:   Sat, 05 Mar 2022 18:48:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-53-ge31c0b084082
Subject: stable-rc/queue/5.4 baseline: 108 runs,
 4 regressions (v5.4.182-53-ge31c0b084082)
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

stable-rc/queue/5.4 baseline: 108 runs, 4 regressions (v5.4.182-53-ge31c0b0=
84082)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-53-ge31c0b084082/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-53-ge31c0b084082
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e31c0b084082e1917ed46c8a991c1811a882e44d =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/6223ec3871e79b9716c62969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223ec3871e79b9716c62=
96a
        new failure (last pass: v5.4.182-22-g33c17a134af7) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6223e8a48e9647bf8fc62983

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223e8a48e9647bf8fc62=
984
        failing since 80 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6223e8a28190029a44c62985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223e8a28190029a44c62=
986
        failing since 80 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6223ec1e70bb63703cc629b4

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-ge31c0b084082/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6223ec1f70bb63703cc629da
        new failure (last pass: v5.4.182-30-g45ccd59cc16f)

    2022-03-05T23:02:47.014654  <8>[   31.705044] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-05T23:02:48.024658  /lava-5822998/1/../bin/lava-test-case
    2022-03-05T23:02:48.033503  <8>[   32.726001] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

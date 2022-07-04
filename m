Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26A565F68
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiGDWTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 18:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGDWTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 18:19:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B41E264C
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 15:19:02 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y141so9928923pfb.7
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 15:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=knWbuDWXfBRQn/QUufmLFD+8CioC7brdS5//DFNw3bo=;
        b=pC5A5GbSB56gAzqDE0T+is6kbh+qpoEEp7bcuDJ85b2NAeDLQ5YScOV2gpsMi9Cds8
         jMpQV65NLLum45Q2aBBHtEB5Ks6dYgvEdhmtzfOmuS58znq/ZsJqQUGREZ0cSsAd0rX7
         jjbVVb7+xfjCUkXiVWlAKxN9hTDXFPnlbHJWXHIpN8Jf3UZ+/GZxs+/POJ+hyW/DuPac
         pvni4X/eYxhzKmv5riNqPJtAQqAP2vnIwNnCpJljHTrTGD5iKRCghcvlE0LUKplikCsp
         JM0tX2WOWSMVENuQ3Sp00SkLUJiqSUZOmd5c4yzOYFJUhCmNN5/VKZvTY9wX9D9INgdP
         IHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=knWbuDWXfBRQn/QUufmLFD+8CioC7brdS5//DFNw3bo=;
        b=aMFa3WcQMzigTxSMMJTw94A3rIRFMhQ1k1gkPztGmshmuZEmUNIAPiPeJH1wGreQfu
         GUuIW3ITMc5WXD6HdohF6q432IP541SY61xj0GdB7We/pE/Tyq+aiWC5O+u9nmkLnf5q
         DLQXXAnniJSvACECWsGFiBKw0QRTyhiy4+INeQwo6HNLRNVMfqolih1MDae+0BqLM13a
         7IRfU4jClJxtC8GCPMEL9ztjfFI57FisZSd16HpRuNiaIubnsLEOtm7CKlQ6/HF0kihp
         lXn7jXI6KPSlNSzEzFGKJpNsd8ywhnRl1EEWjYkLBsoagmoHiWvJ0jL/aMydtT+eNrkc
         zA9Q==
X-Gm-Message-State: AJIora8BNmqwjSS/dxxVBkCxuMqDcu3gq2moCFl7ZUqrSbt21bC//PBF
        rDQqNkt9WegnAUcN2fa2es1RwI7OLOseB5RX
X-Google-Smtp-Source: AGRyM1tXqZEwQUolXDxKsFDKsd9EkdUn0/Qc/PjYczjmrzDXPH8z1dkCerxIXIubCnaKBqXqyk2ITw==
X-Received: by 2002:a05:6a00:32c5:b0:525:933e:252f with SMTP id cl5-20020a056a0032c500b00525933e252fmr36943982pfb.26.1656973141314;
        Mon, 04 Jul 2022 15:19:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090a1f0300b001ecfea03d85sm10738690pja.37.2022.07.04.15.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 15:19:00 -0700 (PDT)
Message-ID: <62c36754.1c69fb81.4ffd.fb1b@mx.google.com>
Date:   Mon, 04 Jul 2022 15:19:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.285-52-g42455fee6b26
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 83 runs,
 10 regressions (v4.14.285-52-g42455fee6b26)
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

stable-rc/queue/4.14 baseline: 83 runs, 10 regressions (v4.14.285-52-g42455=
fee6b26)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | tegra_defc=
onfig | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.285-52-g42455fee6b26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.285-52-g42455fee6b26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42455fee6b26f9047d5a65666154a3d7a14c1c6c =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | tegra_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fe8b4dc6e1a7c3a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fe8b4dc6e1a7c3a39=
bd1
        failing since 29 days (last pass: v4.14.281-23-ga0c33ef6408ce, firs=
t fail: v4.14.281-23-g903e234594714) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2ff3376749c9fc3a39bfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2ff3376749c9fc3a39=
bfd
        failing since 76 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fe8ccea9a51f8da39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fe8ccea9a51f8da39=
bf8
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fe7691f32240f9a39c01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fe7691f32240f9a39=
c02
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fe78c19d397562a39bfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fe78c19d397562a39=
bfe
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fe7791f32240f9a39c04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fe7791f32240f9a39=
c05
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2feb629cd5a9b3aa39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2feb629cd5a9b3aa39=
bef
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fedae4ff7f419ca39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fedae4ff7f419ca39=
be5
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2fe8dcea9a51f8da39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2fe8dcea9a51f8da39=
bfb
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2feb229cd5a9b3aa39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.285=
-52-g42455fee6b26/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2feb229cd5a9b3aa39=
bec
        failing since 55 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20

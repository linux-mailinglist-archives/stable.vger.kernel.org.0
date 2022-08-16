Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7C594F36
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 05:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiHPD56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 23:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiHPD52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 23:57:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B717340995
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:23:52 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d10so7775438plr.6
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=ArFFomVR6BVU41SJx2yIG5E48CVpw4dVluw0SzNQbPY=;
        b=rjZDRfvjgakDwxY/sUSnP3exJeC0F/qHpIm33x/0O8CcFKpvTqTNMp02ilo0UZnneQ
         uZOUYtWmHZv3eIV2HsIXWKxOY/aGXeZtTUnsrRkVEGW85h0qHMR23oX9hFS4MG0oPIT7
         ID479fOfjd+eLmmEGsPbRM91lxoqcrQ/NhX+grwDn/a5kjSwgt7yUIGwI2aaO5ceIpCT
         f2zJjwseEZTHlc/nVzqL2s1hJSOCqBhkgsiZrqQZXXxhCEwuCxaseDdqp0ewGE2PDGOb
         gIXjfO+SDAgqntcmE5wP9SbRPG9nPwZJ7dyC23mlk+Xk6UVN1hbPp4e7zQDk/8qzy8i7
         JpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=ArFFomVR6BVU41SJx2yIG5E48CVpw4dVluw0SzNQbPY=;
        b=W8jBTdGBg8rzgdn//LYTJIG5DG+W6BKg8qv0a/HP1TkZQWr3cF1DYoCfMNDXZqnZla
         R3by5R5K128UeKfA1VOydEcdmbS91x15PYxO12Aszwmk0oQXS6zyyL/aUNce2fUFWkjC
         zXkZDmcO5Fa/i+A42B1ytg+4C1Nyvfe2534MZMgTGv2c2KhoKFahUyw1iPLuTcEff9cs
         BOTrPz34uk7/ORiqW8teehUKMuYHXnt0vBTWlhS92P76XrMi8bqgkt0UQsNfXWNf8Dal
         WaAOfARNIWQZfzOWfa5RmisqbZzG7ODKKaKY0CEgwiCYD1tMloqKEw1xjteg24wfocJ2
         yWzA==
X-Gm-Message-State: ACgBeo0J/tnJfaA+tQdEeb+kDgriUFoOHJqzfpIwoQTnHwO7ca1SWYTq
        eG6vHgOdyWNDgvZs0pkumsnLXlbeVaaeeg+K
X-Google-Smtp-Source: AA6agR61CrDc7EsgsVLKz0rUT6D8ZtJ4wtvvIfiJTmlN1GMWk4qnEJXWMBCEar8ZUOjU9KB+EBCMTw==
X-Received: by 2002:a17:902:e3c2:b0:16f:17cc:7d7b with SMTP id r2-20020a170902e3c200b0016f17cc7d7bmr19402579ple.145.1660609431152;
        Mon, 15 Aug 2022 17:23:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5-20020a621505000000b0052b6ed5ca40sm7021771pfv.192.2022.08.15.17.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 17:23:50 -0700 (PDT)
Message-ID: <62fae396.620a0220.4b7cd.b9d1@mx.google.com>
Date:   Mon, 15 Aug 2022 17:23:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.325-64-g227e01a19bd17
Subject: stable-rc/queue/4.9 baseline: 65 runs,
 9 regressions (v4.9.325-64-g227e01a19bd17)
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

stable-rc/queue/4.9 baseline: 65 runs, 9 regressions (v4.9.325-64-g227e01a1=
9bd17)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.325-64-g227e01a19bd17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.325-64-g227e01a19bd17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      227e01a19bd170ee09e76b70542e1f146154f9e5 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab7ed9d6385564d355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab7ed9d6385564d355=
655
        failing since 2 days (last pass: v4.9.325-34-g77ac6ccad6c27, first =
fail: v4.9.325-47-ga1c49d6741540) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab34de813ecf438355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q=
-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q=
-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab34de813ecf438355=
667
        failing since 2 days (last pass: v4.9.325-34-g77ac6ccad6c27, first =
fail: v4.9.325-47-ga1c49d6741540) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab375497b616f1835565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab375497b616f18355=
65d
        failing since 2 days (last pass: v4.9.325-34-g77ac6ccad6c27, first =
fail: v4.9.325-47-ga1c49d6741540) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab378497b616f18355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab378497b616f18355=
663
        failing since 2 days (last pass: v4.9.325-34-g77ac6ccad6c27, first =
fail: v4.9.325-47-ga1c49d6741540) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62facc3d97b01ff5a1355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facc3d97b01ff5a1355=
67a
        failing since 2 days (last pass: v4.9.325-34-g77ac6ccad6c27, first =
fail: v4.9.325-47-ga1c49d6741540) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab46d5b961f986335564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab46d5b961f9863355=
64f
        failing since 97 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab46f620de335d735565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab46f620de335d7355=
660
        failing since 97 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab46e620de335d735565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab46e620de335d7355=
65d
        failing since 97 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab459620de335d735564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-g227e01a19bd17/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab459620de335d7355=
64c
        failing since 97 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4F58093E
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 04:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiGZCEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 22:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiGZCD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 22:03:59 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64F8255A3
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:03:57 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o12so11985916pfp.5
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ysUPGmycye+pzELOshRGACXvwIytTmyIJIAJAs4+JIU=;
        b=CwrN5Dznu5oOFOQu/rBEemKq+M6t5HBWSFsEfOG2aZTO7Az1S4dydQumZWHGU7Kuis
         nOTYrpWRhfTC8p//PB4Wpga2QfKXoTZLLDqe8sOUvgzCnOaecg43AOaEM4qXzo+bC8b0
         UxF+8Al1pui21xxUaSnBItV7IzMhMplTisQr8mOGS6nrQn8hcTgdNfjStIX2RTl8lKsI
         9hmE2p8FvUg+FpI6ZFACrYX9N8akjvQsIhSEPGG3GghGw3kJvuLQMw/TcQJ/R4RcpFl1
         QBCSwelB2AVWnqjc2nhBLP+bXVVV1xOL303efwBGravVs5JH33/e42Wg49BQnDl5UUi0
         W2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ysUPGmycye+pzELOshRGACXvwIytTmyIJIAJAs4+JIU=;
        b=ZpmTjwYpjRRq5n4E3yzGqC5mq9pn8dHqK9mik4SAG/ZISGLX8h/g24JN3aQO23Wyi7
         z7L7q/1q77E7JaB/99OjiyPalb+pw1sQA9Qh1VgOy2qyFmy2lKR+kWZTciWPn/gC6Gg4
         QNB/PmfoSKF3dQEu9zkeZWAj8WPdPfuatCR6q4nNv6TUjHnhgcpgddLDeX3bCUxMkVXP
         HtJaj/DdBNzJl1lPNdRPImugSK71o8vkSi/0nRf/ARQ2YXWMfz8Xb9rCVuYpTEsMLvin
         eGtZ2pkUXjfMravaxwRZHbWQkEBK3jQOhGtNcmkHaDpVm2zohJCXmyIBS+CDALGm3zKI
         nY2A==
X-Gm-Message-State: AJIora+jKL0BgcEm0Uo37g/Jb1iDTB5uR80wqdtyoJMK2Xo8RDsNZXL4
        QJPS/oz7f/4KPRRvsi9OFDUcMsDHlyUzQvVu
X-Google-Smtp-Source: AGRyM1sxoxkMuZY9i5rCEonuiskqq3m/38iOnzKg7tEO4s/8pXKQcVQnlXP/b44vqFMFrmw+pFJbaQ==
X-Received: by 2002:a63:2b15:0:b0:412:4d98:7956 with SMTP id r21-20020a632b15000000b004124d987956mr13027539pgr.325.1658801036896;
        Mon, 25 Jul 2022 19:03:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b0016d21c1b265sm8083278plf.275.2022.07.25.19.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 19:03:56 -0700 (PDT)
Message-ID: <62df4b8c.1c69fb81.6812f.ca9c@mx.google.com>
Date:   Mon, 25 Jul 2022 19:03:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.253-43-g91137b502cfbd
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 18 regressions (v4.19.253-43-g91137b502cfbd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 123 runs, 18 regressions (v4.19.253-43-g9113=
7b502cfbd)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.253-43-g91137b502cfbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.253-43-g91137b502cfbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91137b502cfbd1c9bdd77a217ab3dacd65440080 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12c06e3c968e47daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12c06e3c968e47daf=
069
        failing since 97 days (last pass: v4.19.238-22-gb215381f8cf05, firs=
t fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12d3387c8ace7bdaf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12d3387c8ace7bdaf=
05f
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1af2fb3fd12ecddaf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1af2fb3fd12ecddaf=
05b
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12bd2f8f5d2f11daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12bd2f8f5d2f11daf=
05b
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1a1ca5dcb038b9daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1a1ca5dcb038b9daf=
05d
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12e7387c8ace7bdaf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12e7387c8ace7bdaf=
077
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1b2e12e63e445adaf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1b2e12e63e445adaf=
062
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12c3977a98fb03daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12c3977a98fb03daf=
074
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1a1da5dcb038b9daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1a1da5dcb038b9daf=
063
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12d1387c8ace7bdaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12d1387c8ace7bdaf=
05c
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1b1ad8c5cc5e74daf169

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1b1ad8c5cc5e74daf=
16a
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12bc2f8f5d2f11daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12bc2f8f5d2f11daf=
058
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1a16a5dcb038b9daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1a16a5dcb038b9daf=
057
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12e61ed21ddae6daf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12e61ed21ddae6daf=
06d
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1b6adb525e176adaf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1b6adb525e176adaf=
058
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62df12c2d4797ee732daf090

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df12c2d4797ee732daf=
091
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1a2aa5dcb038b9daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1a2aa5dcb038b9daf=
077
        new failure (last pass: v4.19.230-58-gbd840138c177) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1b5d927a6115d0daf08b

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-43-g91137b502cfbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62df1b5d927a6115d0daf0ad
        failing since 141 days (last pass: v4.19.232-31-g5cf846953aa2, firs=
t fail: v4.19.232-44-gfd65e02206f4)

    2022-07-25T22:38:10.894868  /lava-6886416/1/../bin/lava-test-case   =

 =20

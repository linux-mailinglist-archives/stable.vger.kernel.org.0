Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5487E5961A8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 19:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiHPRz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 13:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbiHPRz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 13:55:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E781B82D3A
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 10:55:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h28so9956046pfq.11
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 10:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=iF7ziX2DEGF1ZtzlHENjg8Vjga+MtO/1JW33LwTb1P4=;
        b=fFlotXPuQU0/EYjEqvYaGWiNS6tIt338pB9IiH59aKCDIKJvzc/g7j2TBWC4LYSRqC
         g2RvpQ42gwZec2R0WptxpBAu9vKnkuTcf1RCrJCcos9x3Au0v0wpgI1AH2MJTpSULBoi
         rRaBdiM3rrde4hFam32a7HnxV2FCihkbB+MI2E8bZTYVc2hzqNvz2lzmxNj+o4Ocm4dc
         D3V4BaS/lU09iCJ2SZz/HoRKwPxj9rDA3QqP3Rald0A/SghKw5NGNy5K89Gsy0LDRp1L
         FruPJVwBcBjfek9LmvDlvX4BOzRKDnhcbXZftiOOVLwTvaskv0DoYGU6laHSGM5ObI4V
         U23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=iF7ziX2DEGF1ZtzlHENjg8Vjga+MtO/1JW33LwTb1P4=;
        b=KTHMsQybL5UBIKeLxxJn64Y6gJ4AouQW6L+fGPHoq1/tWUPEbF/hTnpH9ptnajtXUZ
         i6FlovR5Wi5eY2+W82IHkoJfqgZlTUWpeX3YfUigj7sSgv5AFauyzfojYOlBnQYyYRs9
         xJuM3GpOpV/P8m68L89aEyqw188a1nvvxt2HoNfxStBidqEBfcAX/7n1yiltKrxHFqM5
         WEtAmyAdmMuHWONROfK1c2oPFqIfnpwhRSWKTAM5GhwpwqIDJFiwsvwnYJW9qMz9msRJ
         1Hokh1hT8w1P62OB6QGzIvGOzhAwbaqC7KUherEMDPT7NoI95Mm4upWu051WBMi7mHKR
         NU/w==
X-Gm-Message-State: ACgBeo33insv2URhhM4+/zrsgKEG6cerCqOFeQXKvWnTuN86Ug1ZoeCi
        A0B/rDMWmqj73kiAOxqvIjZBB9oE9v8W7o1G
X-Google-Smtp-Source: AA6agR7MTMxMjHuJXlkQzb9uFSf+QzlxOqntt3RP3yhCfr9bujLtspPFyz7+tNLyJvvR5YXXkiqkpw==
X-Received: by 2002:a65:5889:0:b0:428:90f3:6257 with SMTP id d9-20020a655889000000b0042890f36257mr10327063pgu.590.1660672555254;
        Tue, 16 Aug 2022 10:55:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4-20020a626504000000b00534bcd63f2fsm4848209pfb.190.2022.08.16.10.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 10:55:55 -0700 (PDT)
Message-ID: <62fbda2b.620a0220.4d30a.8626@mx.google.com>
Date:   Tue, 16 Aug 2022 10:55:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.325-64-gd029606eae707
Subject: stable-rc/queue/4.9 baseline: 68 runs,
 4 regressions (v4.9.325-64-gd029606eae707)
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

stable-rc/queue/4.9 baseline: 68 runs, 4 regressions (v4.9.325-64-gd029606e=
ae707)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.325-64-gd029606eae707/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.325-64-gd029606eae707
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d029606eae70792d5404dcaa652a2884b244a067 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fba9a75273c380e0355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fba9a75273c380e0355=
645
        failing since 98 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fba9f797d264ae8c355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fba9f797d264ae8c355=
655
        failing since 98 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbaae7589da97f45355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbaae7589da97f45355=
648
        failing since 98 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbaad3d0e8b96e19355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-6=
4-gd029606eae707/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbaad3d0e8b96e19355=
644
        failing since 98 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =20

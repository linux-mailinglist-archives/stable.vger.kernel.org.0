Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860204FC521
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 21:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiDKTaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 15:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiDKTaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 15:30:24 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3114C1D318
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:28:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 32so12930966pgl.4
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NQC2sNXjK+7mIY3axCsdcyF4sQD1lqy2pxsgQNfXBxE=;
        b=35qvloe6hyZ7GAqpZpNEhpmyurLepOCNM+ctRZ9nv+VaUxrF7oYpnBDLaDRdcl2p0h
         +V8P5VJGoFmgn9/idezZyN88sAbNh21+SsS2rEyI5GIuLOeGOXpa7TL5m14wC6OU4OKk
         ETLtqx2bEbGDS3mwGv+eW0UVdLbCzFLVW8BXLWQmTW+9dB4s1xG/D9IWc0YrwXCt5WAe
         iX509mSSexNoeXQk7J7v4iva0Uh5ZZbV1nfDBiaVw0dXJy5FtfsohIz0tx1G1Qkcxity
         1GT8X2to+dmlGxkybzjGSE04u3YhG+K/9SoH+60vhvoLiVcn3lp5rlciYSC2P3R7IExM
         gfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NQC2sNXjK+7mIY3axCsdcyF4sQD1lqy2pxsgQNfXBxE=;
        b=fD4CmySwiravO3WJZCWtPos0QAyLwOefssqBW5ksM87qj1948Wu98z4U5kyblzYnLK
         g5qmbJA90325U4DOviaI1kH91MTDHmUZwttkgRbbtVGAaBW+mUkih0zRlkRrZmGImd7q
         X9cei5BAY3NGDul6g48H+KZhfTvn1dIQl0F0JhmhxyUVwNiM6IOZAiuEXTw9f3jAANAe
         xhWiKoTRLYiyiLpTzHyxfCzyezISOp9nbvMm0poRdlffWFYRqYFEjHUkd4RObsLZHYcC
         s2OAs2WACk0yGy0wZp8yUrM3ulnAFQq//8easL0ENWSmIuvbcQ7E4XdzR09clEPuZeCT
         +6qg==
X-Gm-Message-State: AOAM530yYzjUofChZVyl1eznwKAfoLNJhSek1WyMVKY89f3E9C23aVnJ
        wFrm4Q1OdH6B7jZqVDyLDa7JDNJwijiT6Qfy
X-Google-Smtp-Source: ABdhPJy5saywLVAvo4vedK6RKy/fJvvWBNyBnJ532RIJ9Wu3g16fYnuwCtwqkqu9rZCzj8lmZNixwA==
X-Received: by 2002:a65:41c3:0:b0:363:5711:e234 with SMTP id b3-20020a6541c3000000b003635711e234mr27703925pgq.386.1649705288421;
        Mon, 11 Apr 2022 12:28:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f64-20020a17090a704600b001c77c6a391csm251543pjk.26.2022.04.11.12.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 12:28:07 -0700 (PDT)
Message-ID: <62548147.1c69fb81.bb17b.1171@mx.google.com>
Date:   Mon, 11 Apr 2022 12:28:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-462-gd76f6c1bbfe99
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 122 runs,
 5 regressions (v5.4.188-462-gd76f6c1bbfe99)
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

stable-rc/queue/5.4 baseline: 122 runs, 5 regressions (v5.4.188-462-gd76f6c=
1bbfe99)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-462-gd76f6c1bbfe99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-462-gd76f6c1bbfe99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d76f6c1bbfe99760baafb020eb59cbe3d34cbc2b =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625450c3dd6d7ed737ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625450c3dd6d7ed737ae0=
67d
        failing since 116 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625450c807ea70397eae067d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625450c807ea70397eae0=
67e
        failing since 116 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625450c4dd6d7ed737ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625450c4dd6d7ed737ae0=
682
        failing since 116 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625450b31906d0ec6bae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625450b31906d0ec6bae0=
67d
        failing since 116 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6254505b970d281b16ae0687

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
62-gd76f6c1bbfe99/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6254505b970d281b16ae06a9
        failing since 36 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-04-11T15:58:59.066938  /lava-6063573/1/../bin/lava-test-case   =

 =20

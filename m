Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6A639F53
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 03:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK1CLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 21:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiK1CLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 21:11:14 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E598455A1
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 18:11:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mv18so8172037pjb.0
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 18:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HW2KmPuQ3g6tPhQEc/6g7xFrgFDOr4K2WjjvAPdvxn8=;
        b=EXzkC09ZdcOkELhdRhG/77/24f1Y5l1iJA7rtx69Fbx6qTBYzcPFoCTNjPuv4cr+v4
         qSdqa8x64bSIKhgnY9RBamlDeeYS3gexOL8IgevmgjU1HbccMB3mOIpxRRfNf/7tSETn
         tRjhY98BF3TikwMcbtAeFt4jwVjllJBQJajB/traBVtJM9ddu7NfqE1KZTKq7V7FMiPA
         ZuLQNi59M8XRiN9R+J98nq34WvvC0o523pJcDyQDVPXzWxUpM169pAJkBveoLxWdfIv2
         QfocCGmbnMiLKyMS7Uzdi3a48iHucCtGZOzpbTH7N6jgh8dB3C6E5KzpsdbIaoljIOFY
         pSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HW2KmPuQ3g6tPhQEc/6g7xFrgFDOr4K2WjjvAPdvxn8=;
        b=fJ1YD/fgw2qPSjUFsLR/jgCoq5LueGz9B99C6IZUeujt8HqFJrz9+Pa/djUmSSq5Fz
         xHanW3R6C4Ux69llNoUTz9UAo+MUSDGr7kKDkohuvnDNmcZ6ZFNprRyPvt056bn9t90d
         c65KoSMzDhQmTB+QKDxsf8VLfC7jZ3zHpFFHW08kntgUm1jKINoeccV4dyJYN/c4qmGE
         zTglabQuY9sbF/dmyUjKVXtdSFWZv0NBA211ABIha3rnjpZakMyDyzbgYfEIswIrztyF
         6jlE+avsJwp/JKAbbD6lSfR6vXdyg6EufpcPjwyqGrCn3Rnv04inTcJAVc/WlcaxhO59
         0x0g==
X-Gm-Message-State: ANoB5pmQUJAFoKVtIoXR6sniOqOXeLuPipUVcFT7n8hsdXVbNN+lpL9h
        4fR4KIkkhc3nHXc73eJIql8kOfWYWHPmnPpY
X-Google-Smtp-Source: AA0mqf621frA/OqZe2BuK5fEDN1G4r66LpkQ7aF1YHAx4S8k7X4k1QISsSiADeC0EKUk/LVLfGYL3w==
X-Received: by 2002:a17:902:b20f:b0:188:d4ea:251f with SMTP id t15-20020a170902b20f00b00188d4ea251fmr42195531plr.36.1669601473093;
        Sun, 27 Nov 2022 18:11:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b001897916be2bsm3273731plg.268.2022.11.27.18.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 18:11:12 -0800 (PST)
Message-ID: <638418c0.170a0220.b41a7.40e6@mx.google.com>
Date:   Sun, 27 Nov 2022 18:11:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.224-200-g6739dda75dd9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 92 runs,
 5 regressions (v5.4.224-200-g6739dda75dd9)
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

stable-rc/queue/5.4 baseline: 92 runs, 5 regressions (v5.4.224-200-g6739dda=
75dd9)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.224-200-g6739dda75dd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.224-200-g6739dda75dd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6739dda75dd91a68d90a39a91fb18d24cb2f7788 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6383e34d00877e86232abd8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6383e34d00877e86232ab=
d8d
        failing since 201 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6383e424eed076691a2abd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6383e424eed076691a2ab=
d17
        failing since 201 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6383e4288516caf8642abd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6383e4288516caf8642ab=
d2d
        failing since 124 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6383e2facf6c50251d2abd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6383e2facf6c50251d2ab=
d21
        failing since 124 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6383e422eed076691a2abd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-2=
00-g6739dda75dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6383e422eed076691a2ab=
d11
        failing since 201 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =20

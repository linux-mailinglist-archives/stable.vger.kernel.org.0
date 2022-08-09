Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3943A58E2BD
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 00:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiHIWOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 18:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiHIWNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 18:13:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E6D1928E
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 15:13:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f65so12599120pgc.12
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 15:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=46VpXkaNvE5VTfkU4g5fyk7MYgRnX1ViTP0uJj+iW88=;
        b=gylrMXMq7r+iK4HxCNOEgCHP0xXb9wRfFE1i41uWjGf7OP1yJYoF3Iy33rSMqgX/4E
         FjBfRL2YWQvAW9nNYYn5CC/Zxx7FTJm422Ok4pxhcJ+vsElMUlAZ45dkHOrV9X+nVA0X
         RM7AiQmk1TXxerKKbqVrnsTQrpBl4C6mahjvaFqoywEDqlebPVUaigbc7pccBETEXPQ6
         Jghc14qkUvsymGPX/73zEQ0PRQDG5AutoZiksdzIIjPb3wK6D9DjBKtjhIpYFjZSlC4A
         ScqbMSPN4JSzC8fJiZVPxFuIbwojOKODaoIATKzpvejFuavjRh0N7rNjwUWQMp4HDqKw
         AJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=46VpXkaNvE5VTfkU4g5fyk7MYgRnX1ViTP0uJj+iW88=;
        b=4TUc1lfRmsYl1srWowq6CYFeKglmo57I/FCduP/1FQe8VQIZrdejzW2mLr0MEEwZly
         WOAgpLnsnWf2EGCmsiUW94rA4ANtGL6pQqsJ1hXsZli0daLKocgs87I6KylHudHKDUe+
         VxspVvP9RagJq5DSlFjVhf2RSB5we39beXLMgsRBuqi3+Omm0CiUf/9M/EBJQ8nvbU9t
         ESUxKoFQi8za/L4KqrHxJhqsrIe7wEZ3M83ZTTwOVPQgMMAwIjaQ+9AhnMcqpAxu7N4u
         Uxae/7mo/ADPUMIzwMANl2aWZ591sUsgmj0vn3h9ydUbcGFnndSeKQ2RFilDwQgBUmZs
         WPCA==
X-Gm-Message-State: ACgBeo3h/RC8u/o3msxxbLEykxxOA2/g61yHngIB3cYoyEdjKhsdMNSu
        jwF0uWttnD+O/TZ/2qInFYggW2wJNjBFnW8U0SE=
X-Google-Smtp-Source: AA6agR5V+eq2Z6kUA3o2f5A3gm9BGKx7pgATUwDHfWlsF218D9sm6HT3DxdMsTRFwNTY3ZWwyYoOfQ==
X-Received: by 2002:aa7:8896:0:b0:52e:7cba:ffd8 with SMTP id z22-20020aa78896000000b0052e7cbaffd8mr25053148pfe.82.1660083193451;
        Tue, 09 Aug 2022 15:13:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11-20020a170903234b00b0016c2cdea409sm11314032plh.280.2022.08.09.15.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 15:13:13 -0700 (PDT)
Message-ID: <62f2dbf9.170a0220.c2001.32b0@mx.google.com>
Date:   Tue, 09 Aug 2022 15:13:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.209-15-g2f35cde28ee7
Subject: stable-rc/queue/5.4 baseline: 138 runs,
 5 regressions (v5.4.209-15-g2f35cde28ee7)
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

stable-rc/queue/5.4 baseline: 138 runs, 5 regressions (v5.4.209-15-g2f35cde=
28ee7)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.209-15-g2f35cde28ee7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.209-15-g2f35cde28ee7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f35cde28ee76268529da58025b26795b22a2a19 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2a9be9fdc774b38daf08f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2a9be9fdc774b38daf=
090
        failing since 91 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2a9fa0729447a8ddaf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2a9fa0729447a8ddaf=
05b
        failing since 14 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2a97a82a5ef629cdaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2a97a82a5ef629cdaf=
05d
        failing since 14 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2a9bf9fdc774b38daf092

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2a9bf9fdc774b38daf=
093
        failing since 91 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2a9d2fc7525089ddaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.209-1=
5-g2f35cde28ee7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2a9d2fc7525089ddaf=
068
        failing since 91 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20

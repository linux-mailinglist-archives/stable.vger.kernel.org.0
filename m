Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAD65964E7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 23:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbiHPVuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 17:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbiHPVub (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 17:50:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0337C8D3C2
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 14:50:31 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c24so10395411pgg.11
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 14:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=hz57eBiNE60GuIZYgzgfQCEMOwdny/2XpvQNkNGdA/U=;
        b=t0aAgW4IZsr2lnI753X7sPGNNXaQ1W7nYpWyq4GS6CAdp36+42a4afsw30g2ZIw3o1
         1/y12O4VP7TR8iruT9W4QEzg2q8rodzsN+QhdBJ6R7hK8ijhWQnDE1Cq+7LaiXGDvAq6
         zsbp4djMdrgMYyFau1wPTe0SW1UATUMXLidWfOeZCWW0lxs7AN6e9Nt3AuHWizQKsN2x
         zmaU/f8YLJfcJawrYp16WvJ7GjlXWrcY7pUBCtsOqQBp4CYukxCif6K53OLGsacLb5V5
         QfyPcTnxiywLzJg10MHLsMG8urTELhASzp6Gl5xhSBxMdZU5ItFo33W5cJn5gf9m+Ikk
         yYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=hz57eBiNE60GuIZYgzgfQCEMOwdny/2XpvQNkNGdA/U=;
        b=RO7tSvj8lWzBGdRfYqKEta624bfOTXg6rCd9sG22O7vARb71cUxC4AGx25EBchh2pB
         kAzMKl4m/zn2UZSCTqz6TtQLfPoy8/tYGfJK//izcNu0cHK9wc8nS92xIm7CHyJU3uGN
         lUQPOrhxBxCnnjU2rNkFcWQaY4zPyo0qJk8ESp4IXh5+9QavcQ6yqI3fa4zpE99n+zp3
         jyVh/HxwLWEjRNz/Zl1LDRzfKbDqmRy4Iv3eJEw6hhL3F440WHO0PWo+pV3VFpMbOIqk
         +YryS09nn40FUpr7qZRroYVN7K6rLtovZty+mZ4Yp+dTEUaStvTvyDS/E/suFsF2QAFO
         dIbQ==
X-Gm-Message-State: ACgBeo03jbU+ASe/ZJ+J+yOgACRFsxsYi2AuUvkCO9MiVTWkfUWVZspR
        +fVR9lvadl/KXKHxv9GIDHiWX2U3agllKwbV
X-Google-Smtp-Source: AA6agR59xmuG8jlpNIGfdUGwbDjDtHxBNXUaaMoub8LwbjB8htsO76VQDtoU8MuNF1G/No+F0VU0VQ==
X-Received: by 2002:aa7:8096:0:b0:52d:d5f6:2ea6 with SMTP id v22-20020aa78096000000b0052dd5f62ea6mr23538742pff.0.1660686630366;
        Tue, 16 Aug 2022 14:50:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6-20020a655b46000000b0041db5a607c2sm8082448pgr.55.2022.08.16.14.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:50:30 -0700 (PDT)
Message-ID: <62fc1126.650a0220.3406d.ce78@mx.google.com>
Date:   Tue, 16 Aug 2022 14:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.210-284-gad089476302f8
Subject: stable-rc/queue/5.4 baseline: 55 runs,
 4 regressions (v5.4.210-284-gad089476302f8)
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

stable-rc/queue/5.4 baseline: 55 runs, 4 regressions (v5.4.210-284-gad08947=
6302f8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.210-284-gad089476302f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.210-284-gad089476302f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad089476302f8a7d9b7c562929fd7035a4e364d3 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbe2cdcd544e8460355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbe2cdcd544e8460355=
646
        failing since 98 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbe268a41920a269355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbe268a41920a269355=
674
        failing since 98 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbe2ce6c99d7bb9f355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbe2ce6c99d7bb9f355=
654
        failing since 98 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbe1a0c82f9e5ea9355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-gad089476302f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbe1a0c82f9e5ea9355=
655
        failing since 98 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20

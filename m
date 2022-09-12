Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99035B5DEB
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 18:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiILQNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 12:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiILQNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 12:13:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB5C18B3C
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 09:13:47 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u22so9035070plq.12
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 09:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=6JOfkaXaippDg9ICQ6MQ/7Tgc7CAmJXhZZlJIRhKOqY=;
        b=cQXhfbwjwMCLnuudOwf88mruRtdl91ejmf6gRmmYdB5j6Gad+aV9yTPQZ29X/Vg0Ef
         NxpdkR7bcXMs+oR6dtD3m+N2qtOS43jdP4CWEs8h4y9x8+dbw6TGyRjY/a8DMw7O3MuH
         NdHdxCQwE3On6X6LAtLrQveAT8drKNlmkjkBSE0KL9AAjoPbyeAJ579G/dEDw/T/7frj
         Xqxpo1oFfZl4dWSHLDT97HQrjt3fEJyjhwHhA3ncpp67+vBExZgQLoy9in9vTO8N2kfl
         w/+8YGm+RxaoACKGDJFcUHuLqj/weSBh6oerYm0nSeuswac7KTyPIes9rJf0krtWrUI+
         QnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=6JOfkaXaippDg9ICQ6MQ/7Tgc7CAmJXhZZlJIRhKOqY=;
        b=6f9pz1caMVFbR37Si8O+XuOLatYlOB1l5btVa/7kIAZC68oixdD3r4XgS1EfQ+w3YO
         UYJvBO0YS0OjqKZ5K7HMT33Kuiyqb1AU4PJ6cy0eyKWSeKUCCQ0UNi+4NDEt/B/u27iH
         yBHWHpuyUZ9AogFiS8Q55TuVCFqUSKy+X76R9U+IDWzOAYo72N7xh+hcGWq2jF733+UQ
         r+F01cRMsgIxOEOrVpa0L9PlgAyvCGNe4HozAcYhSoElJVSz5KhWVp3DjV8mLiXvE2iR
         zKowJvncffJavfDhePnug7bwoInrp0NpY4K/1rbLDzj4+2eZrF2ujRS7UZCs2cA9xXnf
         MKTw==
X-Gm-Message-State: ACgBeo3Et+ThdqT9d+Xe1hUftBMr6DFrCKMTZNmpYuftPnl7Rkj9Nzgn
        qs028r69guZNemEQybfPRiI7KvgM7ynYSVqRHew=
X-Google-Smtp-Source: AA6agR4dZSEWEOdZNJnTc7gam+2FtqzBb9EySTrUli11fP9MpspJEjdwhQFOMCEWgKDQCi+e46fziw==
X-Received: by 2002:a17:902:e550:b0:177:f115:1646 with SMTP id n16-20020a170902e55000b00177f1151646mr22700214plf.112.1662999226442;
        Mon, 12 Sep 2022 09:13:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ei22-20020a17090ae55600b001fb0fc33d72sm5408879pjb.47.2022.09.12.09.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 09:13:45 -0700 (PDT)
Message-ID: <631f5ab9.170a0220.1e44d.889e@mx.google.com>
Date:   Mon, 12 Sep 2022 09:13:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.292-60-geeac5009ce0aa
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 4 regressions (v4.14.292-60-geeac5009ce0aa)
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

stable-rc/queue/4.14 baseline: 99 runs, 4 regressions (v4.14.292-60-geeac50=
09ce0aa)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.292-60-geeac5009ce0aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.292-60-geeac5009ce0aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eeac5009ce0aab23501fc332cb701c78ed649a77 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2c2fb285d50682355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2c2fb285d50682355=
649
        failing since 125 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2bde8302bd0304355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2bde8302bd0304355=
665
        failing since 125 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2ac620cc5ad16e35566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2ac620cc5ad16e355=
66c
        failing since 125 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2b53bde7637bfb35565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.292=
-60-geeac5009ce0aa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2b53bde7637bfb355=
660
        failing since 125 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213755F55FD
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJEN66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 09:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJEN65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 09:58:57 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA5C7C1DB
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 06:58:56 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 3so15337049pga.1
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=4oKd7kNP3oEAPJUkOnZDjiDgVfQK/S1HJkk8mr6RgnU=;
        b=FmsZG4r/g0szE8TziAN1RqdxahS0f0E8YPlJ8+W+218hJhQmf0Z64ZIxC//cN0ttpD
         EeGb27aBlN3ThB6da2lSZYhKEagx03S5USmWTCDWgV6PWcV3eOdBDyetesnV6TsUZYlR
         JTOJBNosH7XEZsrdIQOVGoEyIN+fS3mi6CMmcfz5h05vg9AQoKWjQy8DdwANjTI4Iemj
         B5qfgv+BLHmesp4wo5jX52bIXTk8LhVRkUTsT/sAJCv1kbijcu6QA3WNd2l215LOClCE
         C1/XP7us9d7ApPnH3rT4KK5vhk/LafeAxg9KTAnGRi6dZDBNMzKqdpyXqTmLGmOsdA/X
         sXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=4oKd7kNP3oEAPJUkOnZDjiDgVfQK/S1HJkk8mr6RgnU=;
        b=IvUhZ6/eiSY0p+7ud7zIWHAgJe6O2WPt3qNRj3qtUEZEFHEMepT4oYqmsIDEMlBKAE
         pQX5a5O0oAIOZHPtu2WO0Ve9dHbsGlmMBGFTZDDZvRRmoIWdUWLDyAGyHpWZZh6zvG2q
         hpkh1IQugZwj7xczMn0wqrqWShTKvrXDg9kEQvqm4LWkVT10Kaa4ou4M7JZvknnUEvuD
         zIpO3CYVx+edZYW0Q8DmLNa6+gxtBZRhuohHckBT4WR4lTtYyCxzLwExhzNSZEe/7hkt
         lk9ZrZnhv5WUsxbecf1soo3apPb6WE1AhRKVHl/XsaC6l0DKHrNLNH9qZhrJM02x0lT5
         dmPg==
X-Gm-Message-State: ACrzQf2n17Jxsw4b4W+Gu/aQtCEbDgLCaiYC3YANG2FsyvGQPdNQO1B5
        axfNxb3FGVXkGKxBRNRHMwAhF2OhWipU5Qu+Bd0=
X-Google-Smtp-Source: AMsMyM7FmSKEqQtQ8N2c7+K1we0VyOvoMK15t6diU/kq/fisFII+ks4nmpHkSkr4xeWWdtUcwryrzQ==
X-Received: by 2002:a05:6a00:1689:b0:557:9105:cf85 with SMTP id k9-20020a056a00168900b005579105cf85mr33032385pfc.55.1664978336234;
        Wed, 05 Oct 2022 06:58:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iz10-20020a170902ef8a00b00179eaf275d5sm10549171plb.27.2022.10.05.06.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 06:58:55 -0700 (PDT)
Message-ID: <633d8d9f.170a0220.a362b.2b84@mx.google.com>
Date:   Wed, 05 Oct 2022 06:58:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.330-15-gd9449060e3a76
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 30 runs,
 5 regressions (v4.9.330-15-gd9449060e3a76)
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

stable-rc/queue/4.9 baseline: 30 runs, 5 regressions (v4.9.330-15-gd9449060=
e3a76)

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

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.330-15-gd9449060e3a76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.330-15-gd9449060e3a76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9449060e3a766563ce40ab2852a0e3502abebd9 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633d87b001194e0b0ccab601

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d87b001194e0b0ccab=
602
        failing since 148 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633d8648ed3f1771e6cab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8648ed3f1771e6cab=
5fd
        failing since 148 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633d87601cac3f42b2cab614

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d87601cac3f42b2cab=
615
        failing since 148 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633d86706348e02cc5cab603

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d86706348e02cc5cab=
604
        failing since 71 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633d5602794e96f787cab60c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
5-gd9449060e3a76/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d5602794e96f787cab=
60d
        failing since 71 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =20

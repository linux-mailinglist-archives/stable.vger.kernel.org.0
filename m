Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63C059056C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 19:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiHKRL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 13:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbiHKRLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 13:11:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718B273E
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 09:47:21 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y1so11775343plb.2
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 09:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=eltXLflRPmxKsRp6mQxn9tfxWoUCzkF09Zy20cnzyLc=;
        b=7oXNF13cUHqR0NtmcuOkak9pnUSYf5s+262xHb+W4Ir3nnNg0m9DM4sV6rKP+zieRu
         id/mwefviXoJxVOvvboii3Kn7dj1aYSg3wP5NeBR9SvC3FSB1JfnY6DHHsuizgI2bF9Q
         sBioHjlyXaZw/N0xJruxSN8k2CESmZshyGsV3eZAqUiYNVujyYAp4FgBpR48TPqVcilQ
         Okq2kFdpSGijnqQ1yoZwc26DtL1NnYluzHFoToAsVe1dONClEQ9urS7rPRvp46xRSg6v
         hI60Zz4trj/1AXAW1fR1IIfJBX0naLkN5QzTswoXfnJWc1KqGED5uXpLbnC1FhNER/g7
         4aeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=eltXLflRPmxKsRp6mQxn9tfxWoUCzkF09Zy20cnzyLc=;
        b=0WEoLh3dzUUxV1gIwEyS8SAhm7GC1La7zVO5dp3UPG/h9hEqZsmHyLebdZEsMKdCUx
         R2P8nQ3QcAgSo9Dor/GB+MHvh/UqboaXBHgYzmSoB/nlkKJzuYXQ3vn1Ct6AGHhiPQQ2
         HOvhjvrNwFOx6BDblpxJIdac8Pmm08BV0nX9x9GLjhFji+IB0HdJ50hiMwZ1DoXVuUrS
         fkqLRAlc64wTV2xaC+lZ2rWXWwr5jZ4O9Rherxv8ljf1fGYV7lE1hAhcNDKpfrA13qiy
         5nEGN1VhX1xAoDQwK0dyBi1xyDBTGXAaCqfyr8C9IqtyIL0BtDAj5R45iIDaniFEOhq2
         bTSw==
X-Gm-Message-State: ACgBeo1edeUyChl7yQFY9L3Aychebcxi5iBeMRizeQZexnDE7T/+Kq2G
        /dqaVwwt1EVdOQFijWE35UgFijAqE/25tnVmp1Q=
X-Google-Smtp-Source: AA6agR7R9Dlsd7N953CwJxWXwsUGPQ5ZV4wj6ePRsyWBucB7YKUTDuwJhvz7NtX5Udi8GAgXVCBDsA==
X-Received: by 2002:a17:903:41c6:b0:16f:3d1:f63 with SMTP id u6-20020a17090341c600b0016f03d10f63mr97583ple.50.1660236440381;
        Thu, 11 Aug 2022 09:47:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6-20020a1709026b4600b0016edb59f670sm15168831plt.6.2022.08.11.09.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 09:47:20 -0700 (PDT)
Message-ID: <62f53298.170a0220.b4adc.98a3@mx.google.com>
Date:   Thu, 11 Aug 2022 09:47:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.135-23-g1480d9920b563
Subject: stable-rc/queue/5.10 baseline: 152 runs,
 4 regressions (v5.10.135-23-g1480d9920b563)
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

stable-rc/queue/5.10 baseline: 152 runs, 4 regressions (v5.10.135-23-g1480d=
9920b563)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.135-23-g1480d9920b563/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.135-23-g1480d9920b563
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1480d9920b5636d86f9fcf80fb44e595b7165396 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62f502e5ad4fdddb01daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f502e5ad4fdddb01daf=
057
        failing since 93 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62f502bc3885a6f4b9daf086

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f502bc3885a6f4b9daf=
087
        failing since 93 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62f502bd9c311307c7daf08e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f502bd9c311307c7daf=
08f
        failing since 93 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62f502d1fcf9c9c46cdaf0ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g1480d9920b563/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f502d1fcf9c9c46cdaf=
0ad
        failing since 93 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =20

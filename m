Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03A5EC88A
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiI0PuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 11:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbiI0Pt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 11:49:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED67220DF
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 08:47:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s26so9767602pgv.7
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 08:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=NrNveVSICWS9Vje4YNSR1oo0aiDRPJ9rcP6bDFlWCpc=;
        b=4yGrCtsrZRBvjoM0R5Pyf5PZ5WjGJyd/0Devo+jX896jK3Evdza84InReRp4PdHKYk
         M5+H9du1EqedruiwEUc6hkmdibG0b6ero7rSDbMCGUYB4iHvyLt2Xcslw/TxfmzTCIcj
         zrF2rC2DF+a+V4sdvDsPCr7udHlN1xw6QZ9ixI/oId776IXuY8aGEhsEh2s3gfPX5q2l
         SR6UwXNYQAAuJbM9gZPhTGv6Fc8Fn2TdBtBpkd0elbvMmqpSUgPb0NKP/h9TEW7oSy2Q
         MLb4DNPxAuGT9YpgmiseQXgOMmGKrzR9IYi3aaS57+4EqBfmE0vfNI3kVQRENFCdQwq3
         76+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=NrNveVSICWS9Vje4YNSR1oo0aiDRPJ9rcP6bDFlWCpc=;
        b=0LgjCeLk+CYNVV87Uq9wREmPSwkiDumaubwwR7U4cObc++Rq35sHAfvz9UCXK2mjWT
         jKSPcyY4DsE+DWL0phXpN7VFLSTD54FYZfKmef9ng6qmtjm3GSttkY8l3JEp/kt8g/+P
         m+jnChg48LSYR4nzKf5WC1u95VvsgwiCHHBpNySxdo2PXEcxEqyJDyUEQmZtjpVrtPEB
         jiOJ8mRT+EExHS9yCagd8lJ3HwAzf9rE1T4RwXgfrbGjFQPizBOdIBGpoYFq+4+luzAt
         Po1XMOimn8b68w3IPlK9Q3b71yuEjUfK7QIpQQ+/gZ+wUgeCAl+bV0jaYqrJd7uQbSnZ
         yWfA==
X-Gm-Message-State: ACrzQf0cW2KMLMA7jg16O+JA/AXiBj1Dw6cJq/oVHZoEwrvBJEZFb2ZD
        4hczG8alI4e2qU1WRRIxmLL54eqQ2mG21zf1
X-Google-Smtp-Source: AMsMyM50i0dxmatEOZPVcFhiHloR0suJH1esTcs4G2hq+Uipr9IPLrY8gz+o57Gljl5wflQwVbLNpw==
X-Received: by 2002:a63:1e21:0:b0:43a:b17f:cd13 with SMTP id e33-20020a631e21000000b0043ab17fcd13mr25058698pge.553.1664293661394;
        Tue, 27 Sep 2022 08:47:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902dac300b00177faf558b5sm1746401plx.250.2022.09.27.08.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:47:40 -0700 (PDT)
Message-ID: <63331b1c.170a0220.55917.2f7e@mx.google.com>
Date:   Tue, 27 Sep 2022 08:47:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.329-20-g43dd4d765386
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 106 runs,
 8 regressions (v4.9.329-20-g43dd4d765386)
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

stable-rc/queue/4.9 baseline: 106 runs, 8 regressions (v4.9.329-20-g43dd4d7=
65386)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.329-20-g43dd4d765386/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.329-20-g43dd4d765386
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43dd4d76538680e21093978f37c11cf2a683c4fb =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332ee3b730739a637ec4ea8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332ee3b730739a637ec4=
ea9
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332ded910d3275edeec4ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332ded910d3275edeec4=
ecc
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332edd73f091cd27bec4ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332edd73f091cd27bec4=
ebc
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332de255800a3c09bec4f59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332de255800a3c09bec4=
f5a
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332ed0eba22c7268dec4eb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332ed0eba22c7268dec4=
eb6
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332ddd5dcb1f5e6cdec4f0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332ddd5dcb1f5e6cdec4=
f0b
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332ed4bfdf0c0cef9ec4ea7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332ed4bfdf0c0cef9ec4=
ea8
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332ddd7dcb1f5e6cdec4f5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.329-2=
0-g43dd4d765386/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332ddd7dcb1f5e6cdec4=
f5d
        failing since 63 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =20

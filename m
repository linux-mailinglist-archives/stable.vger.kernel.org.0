Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C385E602CB8
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiJRNSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 09:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJRNSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 09:18:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0565C8208
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 06:18:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so17343875pjg.1
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 06:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tImRbvu7feU6roTjS9RGRW2lBrQxJA+rdTAqz4XlFEg=;
        b=ZS3il+RV0dQ/F87UwY/5QE0v8/GlJvBCVuVNVsMMSBiSftK3JL1tLUPFen8zPbhAQp
         QpH5Iq7nvNeVCqPoJGOD8MeFsgUDk2asOK3XjjkS6k+9vMN1kQvv+JRMfLocSpFOmk5X
         I424lYwmIejQvHntEF46eeTk1FIPwAUpuAUsU96CF9DZhRQne2LEMC9gaie9FGZrJJRC
         cM8eYfauhWJ25jKbUYfY0GwfLUdHGACCsRmieu78XGitQxT7APfFB0feoDgtbzltCSRV
         ksPlVqx2XT6QLwKs641Cu1FN9opvl5Fd9SUFb58RH1Vp+7muYKrAD50oiaamHk3nhVB/
         nzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tImRbvu7feU6roTjS9RGRW2lBrQxJA+rdTAqz4XlFEg=;
        b=l7UgdiU6rOapHAg0LCJL315ym7dfkMrg83o4e4rsMWM574N+hr1wT+7TDpqi+1Q9Td
         aCWbiaLkw+7G20aYiXPiC4vEli22QejJJkwvpTSo/w8HMzrRwBFHFBr7lk+8GFRp49x0
         pTRTss7EDdOzg0Guy/E2+tOvHgAe0JKusIRYn8aOapxsqrHixsp/DvUaZsUJG6dGlHv/
         KVXODcSqjPPHUprLQlkSpJVfnsTiWQRdeFHz6KJLG8C8LXQ/zdx4Lwa08zrX6/mzDreL
         kzU6HrXcts/ZtSpJfkf8tEj1dm3em1yFls2g0sR2Lmh4qkp/yGmK/5k83XnHYKOkxb7L
         OK4A==
X-Gm-Message-State: ACrzQf2maznbNpzp+Tsad5aU2dnFAg6jYy37nrsin+w4ezUnuYVrh5fD
        As4izBTnhijC6+irkACn2Z0kj4BSD10gK6fL
X-Google-Smtp-Source: AMsMyM6ELag7fZNnis8aWhiMtQoO9pGp2ZmVB9tu7kxFIjjMIQ4QIkoIu5XL1GQq4oK1abl0MTJF1g==
X-Received: by 2002:a17:90b:380b:b0:20d:7364:796f with SMTP id mq11-20020a17090b380b00b0020d7364796fmr3454506pjb.13.1666099114306;
        Tue, 18 Oct 2022 06:18:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a1c8900b0020647f279fbsm11400308pjt.29.2022.10.18.06.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 06:18:33 -0700 (PDT)
Message-ID: <634ea7a9.170a0220.be145.5124@mx.google.com>
Date:   Tue, 18 Oct 2022 06:18:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.330-163-gc8fa5915d798
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 36 runs,
 5 regressions (v4.9.330-163-gc8fa5915d798)
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

stable-rc/queue/4.9 baseline: 36 runs, 5 regressions (v4.9.330-163-gc8fa591=
5d798)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.330-163-gc8fa5915d798/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.330-163-gc8fa5915d798
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8fa5915d798ca9f0f5a57ffdfe8fff21434ecd2 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e77b62015f681e1c2a84d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e77b62015f681e1c2a=
84e
        failing since 161 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e77b805909cc81bc2a849

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e77b805909cc81bc2a=
84a
        failing since 161 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e77b3ac2333a170c2a844

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e77b3ac2333a170c2a=
845
        failing since 161 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e78042015f681e1c2a870

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e78042015f681e1c2a=
871
        failing since 161 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e77b58b10881de7c2a850

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-1=
63-gc8fa5915d798/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e77b58b10881de7c2a=
851
        failing since 161 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =20

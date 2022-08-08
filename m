Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7242258D065
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 01:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiHHXL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 19:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiHHXL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 19:11:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B9215A3E
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 16:11:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so10588243pjf.2
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 16:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=i31eCWWgDLkSpY3w9JGfsCu/8DkUIWvftp3zoVJT1eg=;
        b=uC4xRLN+nlPlN/jMv/XinEYGTKppm/VpD0NljdxizKdAPQONFPZAxLXij9V0M/HMPm
         V4qloH/oIeP9MjnQQXNE5KlsV6+96W94OFMJBisa3IhVSCYWMvw9fE5DwDgFNlHz+YT+
         aYhVPRaKtcg/ZhBL+Y97KdtVzGko1CWNWOMffol7i/SkUVkBnQWGloIiGoYDoxOW8NBX
         9Uf8dW+7dxwwpcNk/EIsP3kWjKsnloJoqYbrCr4P3pstwEwudCTZpyE6SnM87UcpOSkN
         WT3TVtpzAKbKWLLsLesbMH2X/5n7OnwGu4cNvPv/zEPFwxynTcMIiMEsFGUrOUOr53/p
         z9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=i31eCWWgDLkSpY3w9JGfsCu/8DkUIWvftp3zoVJT1eg=;
        b=zNvaWkV0tMNCNWOOD5A0zjXnFlPv+JvDTBygTdkmVngoSWh6jbtTmD6OFSbNjq9smd
         Ec9UFT7lA6mZ0jE4fon/NWp/A5XtMGgrQI++KfaFuJrs5bzA0D1qe64cFECeGsP/Wjae
         RmY2rBFNi/fDtg2Hv7N5A6M0faQtsYqyW3frfyBKD5vM5ibTGnniqRgOBkwfqPE3SHsf
         i1Kz75MxQYSlT8anX5GQKaJZWm2/kX5dV4n2nrVMIp89njOylx7atBHQu/Lb4nHBtxl9
         RtcuLK7QbdfALBcL/AfR1eftncjjdECKan1VX2Dkus89NPYhecR6BnrUCvF/u0w07xs4
         zP3Q==
X-Gm-Message-State: ACgBeo0ljvXMBOhUi5+K5Q9a9hIRz6H880CqqJYn43GoeRmdqC0S8ptz
        jkIA3WrDwuue0ElbCaxhb+pR61HCkBJUSTNImIA=
X-Google-Smtp-Source: AA6agR7GIEWegTxhfKzUIPxAIvy9yhahfao/SjvLljYBW+aaWtUFi4aBj5he7jvWs4Wt5A3TrXL5Dg==
X-Received: by 2002:a17:902:848b:b0:16d:4c6b:bf00 with SMTP id c11-20020a170902848b00b0016d4c6bbf00mr20563560plo.58.1660000314787;
        Mon, 08 Aug 2022 16:11:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r20-20020a635154000000b0041db5a607c2sm1036951pgl.55.2022.08.08.16.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 16:11:54 -0700 (PDT)
Message-ID: <62f1983a.630a0220.797e5.1ce1@mx.google.com>
Date:   Mon, 08 Aug 2022 16:11:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.325-24-g4ca291c9c6fba
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 5 regressions (v4.9.325-24-g4ca291c9c6fba)
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

stable-rc/queue/4.9 baseline: 102 runs, 5 regressions (v4.9.325-24-g4ca291c=
9c6fba)

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
el/v4.9.325-24-g4ca291c9c6fba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.325-24-g4ca291c9c6fba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ca291c9c6fba5d7b4eecef3f8f56835ea569781 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f161a7f0c9db193ddaf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f161a7f0c9db193ddaf=
069
        failing since 90 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f161a94848a83108daf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f161a94848a83108daf=
06f
        failing since 90 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f161a6f0c9db193ddaf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f161a6f0c9db193ddaf=
063
        failing since 90 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f161f623207aeb53daf06a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f161f623207aeb53daf=
06b
        failing since 13 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f161abf0c9db193ddaf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.325-2=
4-g4ca291c9c6fba/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f161abf0c9db193ddaf=
06d
        failing since 13 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =20

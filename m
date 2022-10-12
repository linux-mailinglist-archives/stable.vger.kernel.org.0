Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A9E5FC5F9
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 15:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiJLNKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 09:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJLNKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 09:10:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A353E1EEC7
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 06:10:33 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x6so16163198pll.11
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 06:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=E9XTM55oKGQLjsZC2DvCX04/CRNp75+FxykGAeuuX1k=;
        b=Zcpm+44XthrS+11z5OmegRbg4rok3yFaGcnww/YR/TmdMpFpnxm7EdX3V3qwIYkYQu
         7EO6dhtrReyfAm/vB0uYWHd2DgkaFHC0g1qjGfLYOH096wNHa7oL40BZHidkuVEQAJof
         LLgF7nd76CdON8KhijBwUv1vEnw9VZCw/FYYVItgUzd8WOMwquFLk8JV4SDml/bFWRRG
         Kyg0jTMCWxTE/+NrcLJnrypyxCvWAhPMmvhjVNQ5VT5mttiktVQ1DJUxFJfSmkVrApAE
         +fQTaVNQsZ4tBjSAyZb2LeL+2PuGLx/dwsgenS8uQlc/LD4CS/WD4RC0CbqctcUJ2cOa
         u0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E9XTM55oKGQLjsZC2DvCX04/CRNp75+FxykGAeuuX1k=;
        b=bdUdrxpmkzjVDfPaPJGdounwkFsd1p+RvnaO6v5WYo0lLY67SuqkDqzH65hr98TRgC
         BPiqPWtkpwpiVcB1CigV/A6cMdct5m0XvWaBoNIC8XmjlMDxobcT87QzT0x5qyGeO4/z
         JVm56oKABd61hy5AlHIxiFv/wUAUUAEZ3Hs7mF0nxsFQKcp730XFVOV35FQfzNw5daJ1
         pm2/5Bydd6IpFPvyvB/1oXZoOV+oFPhQjP5rKtt5FnME4GYxzkEdJsK0kPD7z6sID9rk
         XRyzzgMTU7PI2sfrEUU/G/hFJ5ZvhoDHGrmu1l5YwgfgmQiuD7pqg36xiQcQsqPmnR1e
         9d+A==
X-Gm-Message-State: ACrzQf0Bd9VeZVXTW41OW+72z/Pe4g3oFLFb1QoBwlmROY9HmvnFS//Q
        4HZf7cF7QZpk2FR84wStfeOX9oxQs3832dhOH+8=
X-Google-Smtp-Source: AMsMyM5zakpx1xj7EZC4/mi7ZCrazJ9v9bCNjA0OrUcHApYbhUGHi8gXTHRZusuN936gNYYoj8JSYA==
X-Received: by 2002:a17:903:248:b0:172:7520:db07 with SMTP id j8-20020a170903024800b001727520db07mr29413424plh.76.1665580232865;
        Wed, 12 Oct 2022 06:10:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b0017da2798025sm10683423plc.295.2022.10.12.06.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:10:32 -0700 (PDT)
Message-ID: <6346bcc8.170a0220.82d61.255f@mx.google.com>
Date:   Wed, 12 Oct 2022 06:10:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.261-17-ga16ec9ce8fd66
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 63 runs,
 5 regressions (v4.19.261-17-ga16ec9ce8fd66)
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

stable-rc/queue/4.19 baseline: 63 runs, 5 regressions (v4.19.261-17-ga16ec9=
ce8fd66)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.261-17-ga16ec9ce8fd66/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.261-17-ga16ec9ce8fd66
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a16ec9ce8fd665d49855e138a1a62145810a145b =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634683b369bba26937cab5f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634683b369bba26937cab=
5f7
        failing since 78 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634683b669bba26937cab5ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634683b669bba26937cab=
600
        failing since 78 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634683b469bba26937cab5f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634683b469bba26937cab=
5fa
        failing since 78 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634683b569bba26937cab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634683b569bba26937cab=
5fd
        failing since 78 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6346848067ecb3254ccab5f1

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.261=
-17-ga16ec9ce8fd66/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6346848167ecb3254ccab615
        failing since 219 days (last pass: v4.19.232-31-g5cf846953aa2, firs=
t fail: v4.19.232-44-gfd65e02206f4)

    2022-10-12T09:10:18.405037  /lava-7561631/1/../bin/lava-test-case
    2022-10-12T09:10:18.413444  <8>[   36.940090] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867594DA27D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347887AbiCOSjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238563AbiCOSjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:39:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F501BE8B
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:38:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mv14-20020a17090b198e00b001c64b23f5b0so1535183pjb.5
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JCcC+Uh+k22p56X20uuNnSaNDqISKuRryO0wBz2+dJs=;
        b=oXadT26H6LczAB8dRJXb31bb9qc/HeLNUCD2B6yCkjTvCuk0FRxDBHvZOG+bLNlQF7
         Vih8I/DvITmveL4SK63NpRqhLYCvcMyI+pR4DvUyR+v2UtmecqOpF3ribQz1O9Iso+uu
         itn80PfGjc8Etje9MnqJKqhlM91WNjPn3XwuD2L8X+4ejed4LqlOVozU5Ey1lTgRfP4O
         TWgRlTwNBeGTUu4LhFEnlHNspA930qysXGz/QiZnSrPXF40osxmcmczmJWwre93u0Xso
         cF2KD17dl6EPbVqmAKssbEPxgKz/reCZ1UZmy3bbjnPMV/sw5aQmPFGOziZB+5Ill3tY
         qaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JCcC+Uh+k22p56X20uuNnSaNDqISKuRryO0wBz2+dJs=;
        b=1Q53fbV/lW3xSAsMfFNLglIv4ZVv9NXZV5GiuNcMeOyJ6koTl6/nbj90AdrmWylvMb
         CZh+hf85HQQM1/cE/j3qvDN80pjXkV/FQSvQzrOXG956AAAJnFyMuj+WTS7MsXGbtjwq
         y+cIuJHHrwTC0MystOBKLt21/UjUsf6Xj36ciD6wAU1/XizGEL1r1jJsH82E8diR3FA6
         RTJDS4WToLrN9JFrQL6K6FeHixmQLLzL/f45AWCeL+amLOfpXknebMyP1nNhQH8y6bK1
         mGpCE/dzXrwxE5QHmisTD+GpOM5lpzYbLVvUL945YLyOt1Bt794f0Qrr5vBabv3aB6/l
         teow==
X-Gm-Message-State: AOAM532IIBEGNp2OZS6k3asVLsfwp1vII/a0sKcUl6/krH2Iet0Y38JN
        HyI+tRN4LhzpH+PyCT3BPXR+JnhGoiCm/DH8Tms=
X-Google-Smtp-Source: ABdhPJzAf+U9qAeS3fMQqNApNPT25Pv5eeHop8wluNoSBxzL7V8mbvJuLInbQrKlc4OsHeM6rKbbtA==
X-Received: by 2002:a17:90b:314d:b0:1bf:1dc5:8e8d with SMTP id ip13-20020a17090b314d00b001bf1dc58e8dmr6178316pjb.204.1647369483586;
        Tue, 15 Mar 2022 11:38:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u17-20020a056a00159100b004f763ac761fsm24633227pfk.33.2022.03.15.11.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 11:38:03 -0700 (PDT)
Message-ID: <6230dd0b.1c69fb81.1970e.c478@mx.google.com>
Date:   Tue, 15 Mar 2022 11:38:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.14-122-g74c6b0438c08
Subject: stable-rc/queue/5.16 baseline: 74 runs,
 2 regressions (v5.16.14-122-g74c6b0438c08)
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

stable-rc/queue/5.16 baseline: 74 runs, 2 regressions (v5.16.14-122-g74c6b0=
438c08)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.14-122-g74c6b0438c08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.14-122-g74c6b0438c08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74c6b0438c087c61c3d5e1260611c532c91c8dba =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/6230aa60a960b4cd5ac62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g74c6b0438c08/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g74c6b0438c08/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6230aa60a960b4cd5ac62=
982
        new failure (last pass: v5.16.14-112-gba4f1fffbebe) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6230a88eaf7ae55dcbc62991

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g74c6b0438c08/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g74c6b0438c08/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6230a88eaf7ae55dcbc629b5
        failing since 7 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-15T14:53:41.628034  /lava-5883583/1/../bin/lava-test-case   =

 =20

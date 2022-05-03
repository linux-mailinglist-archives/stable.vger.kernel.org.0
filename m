Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48DC517F48
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 09:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiECICA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 04:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiECIB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 04:01:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906C02B276
        for <stable@vger.kernel.org>; Tue,  3 May 2022 00:58:27 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id v11so4652188pff.6
        for <stable@vger.kernel.org>; Tue, 03 May 2022 00:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kvUKmsKgM/FyCdpnhbcQrvY+ab8p9AoR0lvbClzAZ50=;
        b=D5TI/yJYkooHgsC5pfbH5iIijCeaxZPjSIc58W7dCo12hu1ZF54hW6hohNs3IxpFE/
         M9Yd55Vj/gQUjkuS2S1Dke7il9470h+niqc1IYFLLtDc6A6OqHXz4MTrTQTyh/qliHJR
         4oZ3rRYAkbbEuQ8OMsdpss24M+x7moQO/mib0KSOSxG7qRzpK0+MWdGYqMnp5EKbY55H
         LoE6vdTXUXde6LfZkp+qAxGqXkzzRWOBKbaSPkps346/J1Gsgf8t2FfPbcS5Jj5tEIZl
         KGcXhQj8kHkTLPll+fh4h5YdsTkxaS2KJi7+rZNtFj/cBSZ18wqOMHJVGC9tSFG3ROf1
         cz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kvUKmsKgM/FyCdpnhbcQrvY+ab8p9AoR0lvbClzAZ50=;
        b=OQmivXi/vZnTFfnofl34zVqMmhG9/bHbwOguqx/X5sEa6ZmKpcVxTGJmN9tbIowRjW
         zbjsi27nsHMseC8fWPnMF1btCIk1uC28QJjvGuAXADzcBkq2fKzMY576QnJJZIAOe+Rp
         rXx3DKtqG09w2T7FWZ5Obd18jWfMdJ58fK+9sX2z8iZVvWvnAshhu2ckrQ0RY5dVPi7z
         9gYcaLQrWSRJbF7O9uIoHq2hNiRqfAa/lG/JpLQAYaaNiCp0VmUa3Tr0ajOOsgpvf3Uf
         O6+kNzdW7/Vzr3gfdJDbZgpCf4vSENyRHUXsoQOee8ddnVO8sm7zKUa/g/O1Y2uq1zSx
         Zqbw==
X-Gm-Message-State: AOAM533V99b/UKvyrJPEoPcz2kRBITva53/CSfEt8Ijm8wy9AbnAL10m
        bda/z4ZZzyJ5DnrtBAB6hohMv5sr/ELleGC8L+I=
X-Google-Smtp-Source: ABdhPJwRLyx3Y5Yhv1Dxu0ADLSqT1UQQJgK3xiuM7DJBlnGDKnGoRQC9U/gBfcFewHWfrNd0zE1RJQ==
X-Received: by 2002:a63:45:0:b0:3c2:3ed2:43c with SMTP id 66-20020a630045000000b003c23ed2043cmr5483095pga.276.1651564706861;
        Tue, 03 May 2022 00:58:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bn10-20020a056a00324a00b0050dc7628193sm5839952pfb.109.2022.05.03.00.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 00:58:26 -0700 (PDT)
Message-ID: <6270e0a2.1c69fb81.c3564.e7d8@mx.google.com>
Date:   Tue, 03 May 2022 00:58:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.241-48-g07d29c81eb01
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 102 runs,
 2 regressions (v4.19.241-48-g07d29c81eb01)
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

stable-rc/queue/4.19 baseline: 102 runs, 2 regressions (v4.19.241-48-g07d29=
c81eb01)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.241-48-g07d29c81eb01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.241-48-g07d29c81eb01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07d29c81eb0153de2dbe22bbddbcc441405fc096 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6270337ea434efdd8ddc7b6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-48-g07d29c81eb01/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-48-g07d29c81eb01/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6270337ea434efdd8ddc7=
b6c
        failing since 13 days (last pass: v4.19.238-22-gb215381f8cf05, firs=
t fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627036cce60a9677e1dc7b29

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-48-g07d29c81eb01/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-48-g07d29c81eb01/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627036cce60a9677e1dc7b4f
        failing since 57 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-05-02T19:53:33.731488  <8>[   35.672986] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0B65BB19D
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiIPRcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPRcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:32:06 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12611B56D4
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 10:32:06 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s18so16118389plr.4
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 10:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=s3DVL5JEMYP+X9s5gt5CNof9UOqdhGXwEssYBRUlZLY=;
        b=qLvKXZRIIV2+y/qR+vWaxUwdAgWCIWiy1Rq1HXs3EuEjmp9E/1IouW5I+nVh55KQAM
         ynXXnTTZiERcZ+Cbut/nVof7NVPbeeZtyxJP5ROWZ5rinEOFBaF1BrzgwXsWS4FTRgOE
         /2Bf82SRhuplsX2LrGKakUi26PBDKkhocDyrRM9LVNq3nudigLfxAOUE+YvcFVluXuyM
         +TeirSG3Q1quZr5v0DhzYVMtRBsSJnBZjnAiGokUnjEas4ieJ1YstxYBipND/3AyLYMd
         ooJ8At+yKdIgQAu4rf9bE7q2S47WAzizUfRsG4SLMhfIg8XaVcNwBXdK4yhYXV40qZzW
         16nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=s3DVL5JEMYP+X9s5gt5CNof9UOqdhGXwEssYBRUlZLY=;
        b=Z7LPqe6AqBuiZMurnoxLuxs/suMBbnL4/U2l6WzYZGsD1S4AG6YlZbtIe95voOfiAb
         YtBTGql1i27oRhLVZO1+9oHYAt/ZjBbdAuFVJC2VuthErmZ78PIUW8339jmrqjxTox43
         1x80pUvEyekgFu7ig6rGsLRh3RaosR+AmxXlZF3DTpEbrWJU3t1ftLt55pABla2e0Wqx
         1kriAsG/LIbxBcx85bU6Q0bITEiYI/0uSYL4hdsmsMDqp10RZ9BEVFpJwrVBpE/eof2q
         Ndy7+7OUFW0rIZ0iNECx+nTRIpFJHbzusw8K/XMK8LJpaSdfGGstdpzOMHFL/31b+QQD
         4iWg==
X-Gm-Message-State: ACrzQf3F0E0MM1d1lc+VtnUZOtzVgYEs0mAbxsup0ZVezAUIpnFedGUN
        vkR+sc+kBBzanK6x/ybTRU0sk3BLPqGPM+/bmyU=
X-Google-Smtp-Source: AMsMyM5DGEIW27H21QzUburj8Pl9mfc8Qqxrg6OtPSBd6R5t2wQdw3fqhI6qa/N3I5qMuySvOHJWGA==
X-Received: by 2002:a17:903:2c9:b0:172:57d5:d6f0 with SMTP id s9-20020a17090302c900b0017257d5d6f0mr919565plk.61.1663349525354;
        Fri, 16 Sep 2022 10:32:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8-20020aa79e48000000b0053b850b17c8sm14917058pfq.152.2022.09.16.10.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 10:32:04 -0700 (PDT)
Message-ID: <6324b314.a70a0220.a51cb.ac91@mx.google.com>
Date:   Fri, 16 Sep 2022 10:32:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.143-23-gc5efcef738aeb
Subject: stable-rc/queue/5.10 baseline: 123 runs,
 4 regressions (v5.10.143-23-gc5efcef738aeb)
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

stable-rc/queue/5.10 baseline: 123 runs, 4 regressions (v5.10.143-23-gc5efc=
ef738aeb)

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
nel/v5.10.143-23-gc5efcef738aeb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.143-23-gc5efcef738aeb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5efcef738aeb9400654d9708e73c8b4d25e7fde =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63247f88609d2ecebb355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247f88609d2ecebb355=
651
        failing since 129 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63247f8769aca5245b3556b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247f8769aca5245b355=
6b1
        failing since 129 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63247f719f289cf995355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247f719f289cf995355=
644
        failing since 129 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63247f859f289cf995355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.143=
-23-gc5efcef738aeb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247f859f289cf995355=
651
        failing since 129 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65D5964D3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 23:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiHPVmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 17:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiHPVmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 17:42:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569E989CF3
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 14:42:48 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so75528pjj.4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 14:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=aHAmaG4xA51yn6596Q5K+inF7vZL29FzOEwnEo863Qc=;
        b=SBxFSj8Rm47rShadyJkKlGEhFqKSrEKb/31sJ2U3AjQvkXKVtUIiDzKr2crq9IdgCQ
         6WaRc3PcRsI0PzGsmInRkKxphSeYfM+IbxXJQAaqZulvutqDN2lmfnygjpBAACuczg8P
         ik+KrTpw210Zc6A73GLVnkxe8gudN0ZSCdEG44He5MihosucmxUkKeUOF1X2yQ5zEG6J
         NTCVcbmuWNrnkfK8CeHi4Y3xduv88nPJQJc5ygzzyIrw025iFBPkAWACvtu8P9cxNnZ/
         YRJBndKA3k8T9hsh0/at9Rd1qrtqdUhOfhNWtTgTDbQ0mZWOKJdxMi2Im/lUnW0APKKt
         W+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=aHAmaG4xA51yn6596Q5K+inF7vZL29FzOEwnEo863Qc=;
        b=Xfd/WvENlmKc19i7MQ1vsG6Cqy+2zq/IT6GPbqrhEEJGHvlnvebtQrki6HtgjXZGkj
         xrUYjv8SYYnWQd2pjA5FGK1enQxRmH6cf1PQQv6G3sFvT1RsK+1E+EeQar005zaDujA5
         p6GSgV69Faus1Ba06FPyL+WlzJcO/IRnSJYUFe0Ndeahjcx8zzl/om7FKWWQ+5O60IJC
         S1+7hs4sTaGrLCEDWFyZfk8ZTg4pes833iPieSZbw0purHV+O3AH4M4YZhFzwa3IxtA4
         1MtSuvRx4TkJgJQqJ2psFdPR7uHOzXNr71+t5v6W+B72Hf+VprW9pnSrI0tXYrRZf2Yr
         bKrw==
X-Gm-Message-State: ACgBeo2w0NBNGitGKtUnHRiISLib6UmFdMpQ6j1PM+RoBK9VEVzy+qE+
        kcvL0SVqth2+Hbv2TvZ0zXvTzSxgA2PfKhhr
X-Google-Smtp-Source: AA6agR6J/CK5hbwhkTid/YkuaenAEBIvD9nWyEm/ebTVaT5kJ4LAC0rCwlbLlXIwZs6l+VUEs0yPYA==
X-Received: by 2002:a17:90b:1a8f:b0:1f4:fb36:a9b3 with SMTP id ng15-20020a17090b1a8f00b001f4fb36a9b3mr580257pjb.186.1660686167782;
        Tue, 16 Aug 2022 14:42:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a128-20020a636686000000b004114cc062f0sm7952849pgc.65.2022.08.16.14.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:42:47 -0700 (PDT)
Message-ID: <62fc0f57.630a0220.d3c4c.d569@mx.google.com>
Date:   Tue, 16 Aug 2022 14:42:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.255-210-gee176f17ff600
Subject: stable-rc/queue/4.19 baseline: 65 runs,
 4 regressions (v4.19.255-210-gee176f17ff600)
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

stable-rc/queue/4.19 baseline: 65 runs, 4 regressions (v4.19.255-210-gee176=
f17ff600)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.255-210-gee176f17ff600/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.255-210-gee176f17ff600
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee176f17ff600fa0d64e48446e6b9478e34785be =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbdcef3fdc131adc355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbdcef3fdc131adc355=
673
        failing since 98 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbdcb41085e68de935565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbdcb41085e68de9355=
65b
        failing since 98 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbdcb31085e68de9355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbdcb31085e68de9355=
658
        failing since 98 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbdcdb3fdc131adc355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-gee176f17ff600/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbdcdb3fdc131adc355=
648
        failing since 98 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09B0586D54
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiHAO4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiHAO4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:56:51 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78903247E
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 07:56:49 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id iw1so10675340plb.6
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 07:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xDgdFVdhszAT1AS6m2L8OBM5xtrwINjvWHvEnTHxJmM=;
        b=RL6lG3o7tsKSth+HLZfqWG6DPo43KSq3QhxthYi3gtdvC7dfHM9DKhm/rs6n4LlF29
         mduRjiUj57XlHtRp6bp/jD2SXWCrCIz09O3K4fHh/oixWL5GlQNkhdcRlbu6OGVJtldA
         oB+D90Dk3ug42dLvyG3ZqvLs7taHtzVcquiHsno8p/m6ksd4E1m7obboc46dghfjkrpd
         ey+pumo52N2rQN5U05N46cODQfghDNy1aaZFENgAgEIVqASBgj/WKo71WEuPbmc/9fp0
         Sz7yxXVN8niC47HoFiui8t8IQS6M/xnK0EQgvzmV35C3Se1O7G7mM1bRS7gknSZFrBfY
         VfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xDgdFVdhszAT1AS6m2L8OBM5xtrwINjvWHvEnTHxJmM=;
        b=sJ4YSl318EwD8PO6CGqSfOZUVHE0cFwas+cLQBNkdSbJ5zCxgauXOtftwuB9jNSvQn
         5DgmIIQZnUCle0O8q5DTVaP0hvaKFv7z2wjR8NBFZrHtkp7vf5K/n3Z5jVGavQ/ZrcVd
         /4zMmvdAtH3sxtZOTvI0t9ysx3UUqiSKMmFj7GPB2TCZI/Wnjd77G5myce/c3E1Kxaqf
         NuibWjknqbM2vZEkNgbdMDWJpBUSomnuwazZBNJQRgnBKJkKcA8Kwp+g6x2h/7Lx/GwN
         tY0SLQdTaSLGmVbBvFP68AoO3lrlCFeyl/nfMYFQKJygIz7oGi7JKfy4fnwuVvezsS1o
         Rjnw==
X-Gm-Message-State: ACgBeo1xHgPlkUbzeJYM86pULHA/GIp3TDMVaxWm90kmI5TgiiaoF9ew
        jGlh/5r3fqCFYpS7XHPU3ErAMIKLjyeeLzghWIk=
X-Google-Smtp-Source: AA6agR6xKSLb60aK0oYy/RAA9KexmhErfSWnfYVimYdssro4KHzAL/eq+SE6uNiditKEzECFHl2R/w==
X-Received: by 2002:a17:90a:c4f:b0:1df:a178:897f with SMTP id u15-20020a17090a0c4f00b001dfa178897fmr19312222pje.19.1659365809185;
        Mon, 01 Aug 2022 07:56:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5-20020a17090ad34500b001f3162e4e55sm8990172pjx.35.2022.08.01.07.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 07:56:48 -0700 (PDT)
Message-ID: <62e7e9b0.170a0220.d6905.d212@mx.google.com>
Date:   Mon, 01 Aug 2022 07:56:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.253-92-g6c77d7aea663
Subject: stable-rc/queue/4.19 baseline: 50 runs,
 5 regressions (v4.19.253-92-g6c77d7aea663)
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

stable-rc/queue/4.19 baseline: 50 runs, 5 regressions (v4.19.253-92-g6c77d7=
aea663)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.253-92-g6c77d7aea663/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.253-92-g6c77d7aea663
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c77d7aea66321e398bd52359a971e48ab2715b3 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b06f71d3b7d320daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b06f71d3b7d320daf=
077
        failing since 104 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b12a2ba6450f85daf0a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b12a2ba6450f85daf=
0a3
        failing since 83 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b12b2ba6450f85daf0a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b12b2ba6450f85daf=
0a6
        failing since 83 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b1a2a2205d2f19daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b1a2a2205d2f19daf=
05a
        failing since 83 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b0ee198662f158daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-92-g6c77d7aea663/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b0ee198662f158daf=
058
        failing since 83 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =20

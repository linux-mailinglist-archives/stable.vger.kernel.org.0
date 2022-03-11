Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D804D5A52
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 06:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbiCKFOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 00:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346354AbiCKFOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 00:14:45 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800861ACA1D
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 21:13:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g19so6985989pfc.9
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 21:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rMiou3uHHujihshxnsX0nNoLB9BC6q1/ZXfP+jCiO+A=;
        b=FGw2AsYf0vD1c4SSN4MNBUmV3THqov9L9FGtA2hISHkaA88m97NsMeBjM19KBqkDDs
         eMGlA/1CWNiejJqvbluxChbEec1Dlktv8dK8DUBOy+h1P5v/OqaQHBa28thbOVOoqEi7
         RVREsXK01qPNEguYaA8B/ZhAYQdihtEjVf8EH8bDijk0d8soUQ/aHuwcqiYpoZM1qof7
         JBNamXZ/XvM2vFs1tCHabKRJwkOIwEkFweCs6oJeoK/MKLz6geiTvfuFctRYkZ0lselx
         GHSfP0+S/r6cXHa3I1bfdQT/InU8UhAHBR6CoXqNA7PBTT72cO8dHi919rhfGK3vD3Ys
         qCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rMiou3uHHujihshxnsX0nNoLB9BC6q1/ZXfP+jCiO+A=;
        b=g4piHgreKHfto2Ha4IrElkzsJyuxsE7OeFK16q5PdaJxwrmNEvkvyoIFoqzkTE/wbp
         ihqGAJKHxCcQ1l4sqa26W7Fv8hFndXv+zGjm/4FJvLwCLp9kT0ZlD2zm/LwZMQjTAvaq
         ppkr4Z2KKEzmhuJqYABh+zWT+wE+wvTrAtXHtEa7Fse7ZiAAHx6ys7kPMccQYQCSLEVY
         rv2VHAQSOgwRPHL/voeIR2SwILhs3v5Pb/Wj3Rh3t5Pn0DQ9KeSP1n541HHpDVtrJS71
         NVERqI7GXHFOVbC7HACqx8Q7NRm6ZvY9zLd5eFNpOOhO/ntH7aRqv+9wcORFcCeKCW60
         U2YA==
X-Gm-Message-State: AOAM532HoKsFznslsORrYmbo9m1fCXdKKcUhGsUoKKuZQb/3HBPskmDN
        dYWU8tTn6WK1AYn50nEkNOkKGrvyfy6kF66REYk=
X-Google-Smtp-Source: ABdhPJznDa92rFeLK5IqDpJK4kIv04UaevL590r/6YBiNVyczgeu4ExOuSzptKfvHxPUhirYt6L7sA==
X-Received: by 2002:a63:8a42:0:b0:37c:872d:c45c with SMTP id y63-20020a638a42000000b0037c872dc45cmr6921011pgd.95.1646975615822;
        Thu, 10 Mar 2022 21:13:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4-20020a056a00150400b004f78d4821a0sm650730pfu.204.2022.03.10.21.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 21:13:35 -0800 (PST)
Message-ID: <622ada7f.1c69fb81.1320a.2762@mx.google.com>
Date:   Thu, 10 Mar 2022 21:13:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-33-g82bfde770211
Subject: stable-rc/queue/5.4 baseline: 82 runs,
 2 regressions (v5.4.183-33-g82bfde770211)
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

stable-rc/queue/5.4 baseline: 82 runs, 2 regressions (v5.4.183-33-g82bfde77=
0211)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-33-g82bfde770211/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-33-g82bfde770211
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      82bfde770211fb3a48c5ccb97f22de397e0aac51 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622aa38a0a72a82e6bc62976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-g82bfde770211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-g82bfde770211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622aa38a0a72a82e6bc62=
977
        failing since 85 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622aa38cf7ccfc81f1c62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-g82bfde770211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-g82bfde770211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622aa38cf7ccfc81f1c62=
976
        failing since 85 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20

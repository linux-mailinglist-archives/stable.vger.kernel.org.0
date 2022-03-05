Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC94CE6FD
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 21:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbiCEUa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 15:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiCEUa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 15:30:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4573FB843
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:30:07 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so10837038pjl.4
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 12:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KlZ75rZeGLdnL+LZOGXfihdRDhZDfLZjePqbZN5bmWQ=;
        b=wMqpHR36jRTn6tfdYNyRMdKVQvru6w8PVxKcbwcz8AFi74hKotgPm96qzpEzvHm3dq
         wZxE81MPqR7mR4gMp9bJWNH5ukg2FZfpNzvK2rhdmHgVq8zItsnLrMsv3F6hhCkWPAUz
         k58vFL0K2XP2BBt44Y/XFGSKOtLK1J7vTFSBHLN4fxAUuQGogbgXbGndxGA25Y2uGtQv
         d8x4qxLvBZaT2SW60+EDo3DDLFH1WFP1HGLezBjVt4IeL0f3v59cL3wVPYfZ7Rk7C8lA
         MTW0UP23wnL9rMMlfKKxnZa5yUkd/iVtxxXbomtCUFBbnVbskmJ6GNGB0B09oOvptvWi
         DTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KlZ75rZeGLdnL+LZOGXfihdRDhZDfLZjePqbZN5bmWQ=;
        b=Q6QnKiteLQVPih1knvhbgaurUGRXZA09lcH7MSWQZpr+LVtxpkvZzXfyKmdL2IkMUN
         8D/IV53WMCPa2xHNRehnfxToycYwdztMYkgWqkF8O//b1tYJPgqhZHbH9hObr+03A9kx
         aQD5e2z2j7o+u7oiurtEND+6cd9pxDBYlUiG/7S07pghqwjmTSfYenmRMWbgDJoXDE8w
         HyjYYqj7DBdpUp0PQhw+WiSmvWmSVv0iZOZuxP1raq8x4zUP29E+mHUyA6VI1YVGy9JV
         MOacVdlsoXAbhBHuaO694GkXEKT728/FwUNGtAojj+js6BZUr7pi+sqjUFNDMBtx6jbE
         DuqA==
X-Gm-Message-State: AOAM531Ex1J0KjjioOH3q0Ec8YoCmKfc4L2utkhMqoLXJMqC9cDClhrV
        eA449yUertTX9YVr2JGea5KLyiAXmFD2XzzCXZY=
X-Google-Smtp-Source: ABdhPJyFarGly+yJNlrEmzl+lcSTqh6Pv7lmAFhfe3iSP0UjUGsUPmkfRkZ173ZU7rmjDiAjriWQfQ==
X-Received: by 2002:a17:90b:4ad2:b0:1bf:d47:8077 with SMTP id mh18-20020a17090b4ad200b001bf0d478077mr15281349pjb.85.1646512206590;
        Sat, 05 Mar 2022 12:30:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w21-20020a634755000000b00368f3ba336dsm7684292pgk.88.2022.03.05.12.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:30:06 -0800 (PST)
Message-ID: <6223c84e.1c69fb81.3f773.3e7f@mx.google.com>
Date:   Sat, 05 Mar 2022 12:30:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-30-g45ccd59cc16f
Subject: stable-rc/queue/5.4 baseline: 61 runs,
 2 regressions (v5.4.182-30-g45ccd59cc16f)
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

stable-rc/queue/5.4 baseline: 61 runs, 2 regressions (v5.4.182-30-g45ccd59c=
c16f)

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
el/v5.4.182-30-g45ccd59cc16f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-30-g45ccd59cc16f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45ccd59cc16f5343e4d4be79de516510f23e8449 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62238f2bf243e6c92ec629a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-3=
0-g45ccd59cc16f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-3=
0-g45ccd59cc16f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62238f2bf243e6c92ec62=
9a8
        failing since 79 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62238f3ffdc3a84418c6298f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-3=
0-g45ccd59cc16f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-3=
0-g45ccd59cc16f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62238f3ffdc3a84418c62=
990
        failing since 79 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20

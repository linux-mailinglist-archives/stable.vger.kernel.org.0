Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDC4E6B3D
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 00:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355961AbiCXXeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 19:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355887AbiCXXeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 19:34:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D101BB913
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 16:32:41 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c2so5049619pga.10
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 16:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rAYs/rbY8ihPQvQlSDk6yLxemA+OsekUnouzHs+h4Yo=;
        b=Mv7LpA0UEhOWSyIXUANugdUmf5+gJk2a0jlpUZotafx/PADp6l+RXxqKDXzFO+XhBF
         o/UrwH7pCCu9YvJuUKHxaBWe/ociTthgDZDjAFfERSeyeCQjP47Lh0eL3zgcHV0bmOdw
         yC4en7EySDdeIme3p3Yb2JXPXp02TKbqp+AZkipZNEFoDFd+xA3n8aDX+eKtlbjW3kWj
         lnYfo3aAVazhHi/wcyc8QlyarRLNDiMAUlI0Jdpt41dzruskj1vCvN8K/pEKb7xmB/kk
         LagMA67zdeZ7fclJ1DajuT8Mm+oABq+uqRbT1oja43EvjjwgSrUpDG6+lWf80yIsIHW2
         AHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rAYs/rbY8ihPQvQlSDk6yLxemA+OsekUnouzHs+h4Yo=;
        b=vi2mUOzS5UIHpielZmfkz93IcAgN+KWQqpKB1XpdIEc/IxjFDB5RZZvTGZ5bayIi0g
         6qoRF+NNMyOgfyN/3msAnW6HcvJ7khW1bnCJhKWbwbhmISsL2BrBIMp5CVAdqTiBPUWk
         pb7q3WlGn55MhRpw7tz6MRo81EdVYOnwRfkBxZkFatnwOYIUcCXFdOPYkRy6pvwFvwX+
         2AWo8eZH+MxQRpNLqMxOZvFf2gPkoFKaNujostDrNo/ojde5OAGxlDSpoi3vRUgd+JXk
         RjpGh4YXbTMmEWsUhzo2ErTojQErwqPIh9gwTZ/DwV7I1sKKn8DanqsLgdYhLJKJPZa1
         4CuQ==
X-Gm-Message-State: AOAM533ARqxIfFA2Ot7flMbA7rYZt+Uj8fo45UY+/92BXOjZZWpruY8E
        yEFx143nuLCe8FAiVSZwEuOC1yDeywdDKOIsJEI=
X-Google-Smtp-Source: ABdhPJzuLI2v8ep9oO9lEkaWiL8zHy/dA/AI/fXjm0Mzlh0msQDehqB8YsudaZotudLKkIACs5TM7w==
X-Received: by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id u5-20020aa78385000000b004f6ef47e943mr7309470pfm.38.1648164760715;
        Thu, 24 Mar 2022 16:32:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r4-20020a638f44000000b0038105776895sm3428001pgn.76.2022.03.24.16.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 16:32:40 -0700 (PDT)
Message-ID: <623cff98.1c69fb81.40629.b0c6@mx.google.com>
Date:   Thu, 24 Mar 2022 16:32:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.187-7-g7e2268c1a255
Subject: stable-rc/queue/5.4 baseline: 49 runs,
 2 regressions (v5.4.187-7-g7e2268c1a255)
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

stable-rc/queue/5.4 baseline: 49 runs, 2 regressions (v5.4.187-7-g7e2268c1a=
255)

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
el/v5.4.187-7-g7e2268c1a255/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.187-7-g7e2268c1a255
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e2268c1a255f52829a6cc75bf428394b81a9290 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/623cce9ff12a8b0daa77251c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-7=
-g7e2268c1a255/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-7=
-g7e2268c1a255/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623cce9ff12a8b0daa772=
51d
        failing since 98 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/623cce893498815ff3772537

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-7=
-g7e2268c1a255/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-7=
-g7e2268c1a255/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623cce893498815ff3772=
538
        failing since 98 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20

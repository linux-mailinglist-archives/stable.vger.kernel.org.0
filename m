Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E0156C4F9
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 02:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbiGHXaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 19:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiGHXaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 19:30:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD07419AA
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 16:30:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so3350618pjl.5
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 16:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4mU3dzMPMSPMXwC5Zloc2/DqdMOCyoGzED7c7QvkGBA=;
        b=jpPnAe+mwvUbbbknnljwF9PVLpeBqC53WvUmu2Zu/4oVv2JNBm7kNtWro+3OBYsvcJ
         qrTUZTGat0V3K+oc7UYLrk4WmlTq3C1zQHSAlAegNzkXzhxZk3OrEVaXPzybBnbL7GKh
         bar2hpT8IfNATDwU9hqp71+4rPZGOYrS3YsAjlHiMW2HgT7WODveDsvFV8sIH9ppPfn9
         h4kr6KxK78LA6ENKlXGai0vL9RdYtyQ7DVm1dDpwhdjlxG/akN4x0gJdpFqdqcvjHDiT
         tPczTXbRxKCQHt8aJn88waO606dZGs6Gngk8tdPStV5OEQ13LNKQIhn3yRkX25IUEqNl
         EP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4mU3dzMPMSPMXwC5Zloc2/DqdMOCyoGzED7c7QvkGBA=;
        b=evYVcMKyW7kQBpfP4xs8nCQAmaFf1V3r6LRMrHzcfHIWZWnAmqcUlb0qnyZRWlmjMQ
         6jfAlGEDM3qoenghxOKnxj3keorGss7n9OjRvfQ38n6AMnnOntexwoxRNF70bRfhtCQF
         a7cnGRWPY8NEtNTdj+I3PyZWwrY8u77qVNL+6eOVLuHCNpm8KpRwN0RaJn1vvhvaczSP
         eMBaTl7m/u6q23G63kZW0cAiX9SlJFZedjaLJzvvSX/rhkG5XneRZ1TZ7/FJODkzvqbH
         dmGJqLUrB4cCZWe1SFrXPKB8Uq+SfJjiEsVRAJH5f8jwK23TQIo8nChDTuClHMOSdD+8
         5d7g==
X-Gm-Message-State: AJIora9xh2Jf50lyJccUQgmtIBbJ2bFOZ7TqddhguPxCnOt95IvMhJ+G
        yhQumTBnCOarrf46pbPhEkoDUTYSsezYrfIR
X-Google-Smtp-Source: AGRyM1t568Sps98ZZlRfmfmoQYhVywlhe3GP4y3h8LIumJ6paAy7/VEDzi1/IqiSYaWyjKTuMPHFjg==
X-Received: by 2002:a17:90a:7ac4:b0:1ef:a606:4974 with SMTP id b4-20020a17090a7ac400b001efa6064974mr2565840pjl.51.1657323023420;
        Fri, 08 Jul 2022 16:30:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11-20020aa79aeb000000b00525203c2847sm127582pfp.128.2022.07.08.16.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 16:30:22 -0700 (PDT)
Message-ID: <62c8be0e.1c69fb81.bfc8a.045d@mx.google.com>
Date:   Fri, 08 Jul 2022 16:30:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.204-7-gae67618cb073
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 81 runs,
 3 regressions (v5.4.204-7-gae67618cb073)
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

stable-rc/queue/5.4 baseline: 81 runs, 3 regressions (v5.4.204-7-gae67618cb=
073)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig  | 1    =
      =

jetson-tk1    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =

jetson-tk1    | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.204-7-gae67618cb073/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.204-7-gae67618cb073
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae67618cb07320e9352c68ab979990c240735390 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig  | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62c884b8e1fca753a3a39c43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.204-7=
-gae67618cb073/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g2=
0ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.204-7=
-gae67618cb073/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g2=
0ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c884b8e1fca753a3a39=
c44
        new failure (last pass: v5.4.203-58-g697535a977b6) =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
jetson-tk1    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62c884dc8934d58614a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.204-7=
-gae67618cb073/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.204-7=
-gae67618cb073/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c884dc8934d58614a39=
bce
        failing since 4 days (last pass: v5.4.202-15-g2e1aff81650a, first f=
ail: v5.4.202-22-g1655a87a79ab) =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
jetson-tk1    | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62c887fc46c34364d7a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.204-7=
-gae67618cb073/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.204-7=
-gae67618cb073/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c887fc46c34364d7a39=
bf0
        failing since 21 days (last pass: v5.4.198-15-g2ff259ec549cc, first=
 fail: v5.4.199-3-gfa1633c6dfd3a) =

 =20

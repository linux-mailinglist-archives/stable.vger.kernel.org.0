Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BDA6049EC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJSOyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJSOxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:53:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5234F1413AB
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 07:45:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h185so16438534pgc.10
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 07:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oCjKWR+gsIkcJwSFm1XB1oCQEP9ez0PBEvUWpmy+L/c=;
        b=v4ZKMGLo/aKnflZ89/gzo5t+uS4aVcZGntr1/jNDIfD1FL1jAyuvoDz16jNGE9Zjd8
         r+o+Q2XXeBPi+hav81iqwVaIRZ/HpqbyMCJ2KCtuJWgJyz9McmZRJz81DlUF5xeRD1GN
         S9BFMCv3m2JAfqOAwreBC6GRIHTA+hYT8JFOiqAcr3aHoFRAAxtYLr6TtuAt67MlStI9
         iq/FLrdUNndqasOETlurVCYfE1MqpQS1cCGb4Si7jTs39AhHQSSkDvA3jR8NMzpZ38xv
         eKZNunIIqFkIRUDY46l+6Yk3j61SWued2EYDWv6GpgGNFU+5yZcDh22vZZVa4NN44pD0
         srGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oCjKWR+gsIkcJwSFm1XB1oCQEP9ez0PBEvUWpmy+L/c=;
        b=xgKgVZBNPLiof4SMtBR0oNboKTIU+WC6D3At7Bt/lERXAtIQMW1xpBs+0Wsi9XJ8QB
         S0dLw9kZ1udg22/TEl9VeLqrOiBflUkJnD4My9Ind+7WULc2uP7x72/xs98sLtaQAe2u
         oCfaXi+n/9kazSGU2hp2439t8Er3DlGoNr8GwTsgRxwKbaLl7aTsOXzQ+/httL1pB5lq
         hpwXyBUuy22H39+QA1cyE4lZqLXQcZBb6Qxt4OdWuvYwV8sKmVzq+nnhu70DmhgCPP+U
         Bp8LcGakaYEi0e9j8aAuJhcK4MTR9zwZwzpQEdP63jSaZR1UbPeHLVgdPky5F67IHjI4
         3w5g==
X-Gm-Message-State: ACrzQf23TxWY/0gy9Pvwcs4keSEa4DWboIRecfWLTCEMkHhuDzwziGYT
        NPn+Malef91SCbifxtLrnAf38Xv1As1WXTmm
X-Google-Smtp-Source: AMsMyM4NyHcV3lEvQhuuR/GL7dFRW7QnVGo11lUUsTI3CFmN5mtXuux30h+SfZu9PUs2JINXuFiHPw==
X-Received: by 2002:a63:1c4e:0:b0:458:e183:1342 with SMTP id c14-20020a631c4e000000b00458e1831342mr7445521pgm.409.1666190717657;
        Wed, 19 Oct 2022 07:45:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902e74400b0017b69f99321sm10985924plf.219.2022.10.19.07.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 07:45:17 -0700 (PDT)
Message-ID: <63500d7d.170a0220.bd1da.42cd@mx.google.com>
Date:   Wed, 19 Oct 2022 07:45:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.74-597-geff65abcee9da
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 179 runs,
 2 regressions (v5.15.74-597-geff65abcee9da)
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

stable-rc/queue/5.15 baseline: 179 runs, 2 regressions (v5.15.74-597-geff65=
abcee9da)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.74-597-geff65abcee9da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.74-597-geff65abcee9da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eff65abcee9da7a62eaef90e2e7c0165bd43146b =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig  | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/634fd9184f6c22ede25e5b67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
597-geff65abcee9da/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
597-geff65abcee9da/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634fd9184f6c22ede25e5=
b68
        new failure (last pass: v5.15.74-600-g23ade3cda2fe) =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
jetson-tk1    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/634fddff3ef732b9055e5b4f

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
597-geff65abcee9da/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
597-geff65abcee9da/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/634fddff3ef732b=
9055e5b52
        new failure (last pass: v5.15.74-600-g23ade3cda2fe)
        1 lines

    2022-10-19T11:21:13.495984  <8>[    9.121034] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2022-10-19T11:21:13.496784  <8>[    9.130759] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 2699165_1.5.2.4.1>   =

 =20

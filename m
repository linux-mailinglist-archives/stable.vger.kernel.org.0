Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1A64CDAC
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 17:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiLNQHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 11:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238460AbiLNQGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 11:06:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAA563DB
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:06:51 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a14so4785170pfa.1
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=96rgpoi9dLqlHapzJtXYvsHEbLSaKkAW02ASww5pgZU=;
        b=z0Vdp1XGizRTcUYL5N+YfoQy1u/IXqxD6NCi1/IQe0SAbhNcTPW/GIuwdCIlHPgPOb
         WA9VWaO0ZHIEis+q2zT6N0Z0+/OEuphr6IkHwiIrT0XFU/M84wfwJdv5HKkMkNpYBIOi
         C/DMWsUCqtE3L3ZoonvdeYI1gvE9uQbdZ3SX2+fefsXch5BJJrlaDWzy92L7fUNQet2T
         f+LE4SUFSs7Nt4t6nMefYefmG65TMLmchf1BipcR/vzT5muUpZJzAv/PUDyP7c5Im1jz
         7Eupsmhm15STymDKdfM2RVkHVct8LgF8iTODR35zTWXeTaizms38bpYIjQHi0UXp0vHP
         seug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96rgpoi9dLqlHapzJtXYvsHEbLSaKkAW02ASww5pgZU=;
        b=IYP94XAPT51yIkqRcHtez3eGgtMIE3bvbapQjS8ZFEUXQ+JwbG0XbItq/NXGv50U/b
         n+aoSkMQOb0QuBWpr/Otb0nBDQydg3Ug40aY8euj92LMUwQT/GJ9huzHM+s/BGFnWZXY
         8jQGrALRZjudSjzzQ/183YWCZOCnWuuc4+Yo66hHTszVpn+iqMZWjGOFzAt/lsSt5OlF
         ab5RyQ4u3RmUxd8sLm3cL64TJYt2bvB7o3pPll/o/5/qro9ywZ+nSFOCsLNRSlcc9R2C
         7z7xLgS4Md2JcUw8qnLrIGNwgMJiNL/OrD5hXWrxu+ZMBXJID48Ocrngd2tAkDU9nssd
         vkgA==
X-Gm-Message-State: ANoB5pn5d+jNEaWuV0c2sO85l6+BVTmpyfP0vFRcgGZeloJsAq+Ks82z
        HZQgTJFrCEt9ATmqGX4DRJNMclm/jaUQDH3gjxMgpg==
X-Google-Smtp-Source: AA0mqf70nv3ydJ0utfdTZ5YT5jx9ugTuxBLkgwaMHi7SXKbXpJ9f/kmwXUHoS6rB8PxGJH8sIsYbfA==
X-Received: by 2002:a62:1c42:0:b0:577:9182:199a with SMTP id c63-20020a621c42000000b005779182199amr23443802pfc.29.1671034010761;
        Wed, 14 Dec 2022 08:06:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s11-20020aa78bcb000000b00574db8ca00fsm34086pfd.185.2022.12.14.08.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:06:50 -0800 (PST)
Message-ID: <6399f49a.a70a0220.291fd.014f@mx.google.com>
Date:   Wed, 14 Dec 2022 08:06:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.159
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 132 runs, 2 regressions (v5.10.159)
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

stable/linux-5.10.y baseline: 132 runs, 2 regressions (v5.10.159)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.159/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.159
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      931578be69875087a62524da69964d575426d287 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6399c060600036ec922abd06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.159/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.159/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6399c060600036ec922ab=
d07
        failing since 18 days (last pass: v5.10.155, first fail: v5.10.156) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6399c3733323c674cc2abcfa

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.159/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.159/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6399c3733323c674cc2abd1c
        failing since 280 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-12-14T12:36:48.091802  <8>[   32.872128] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-12-14T12:36:49.106967  /lava-8371378/1/../bin/lava-test-case
    2022-12-14T12:36:49.107377  =

    2022-12-14T12:36:49.117796  <8>[   33.898221] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

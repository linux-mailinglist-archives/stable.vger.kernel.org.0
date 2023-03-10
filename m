Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D416B5177
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 21:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCJUKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 15:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCJUKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 15:10:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250E712B963
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:10:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id kb15so6414868pjb.1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678479049;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WXVDqQsnaAxtJPwF8aCIlh3ASMRY/DjREEjv/evwB2s=;
        b=Ycm+1fhK3HrirhP5LpEcl9c2ppPxycAm4C+z/Fs0F/XXNiYZjnc9S/QUidykyJdRrK
         xxDmX/4WcOCwGUwYdHWN/QDZGsgT2ZiWox7BzeTd/HOBAefK5oCe4BgcFEDIke5qKEKv
         afOccTlQEg+BPNdLZ0jOlLlYfaB1cnZBnWH+a717JN85CW7okt2sXVXtFImMR++VMCKK
         wfI1BkCxEnVjMsaXFi7M36PmuqjhiYlTG8E64wzm0bZIKn/cI2fgqM/PgYhRkyH5QhtV
         7vaAuCOC9R8YFW6UqC8gcqaAjJWgUHCY0W9yYorcWDY+nzvJxMNK0FvK6jQst+hmMM/M
         a1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678479049;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXVDqQsnaAxtJPwF8aCIlh3ASMRY/DjREEjv/evwB2s=;
        b=p+UINS3iCaz0UG1K6PalJybtKxMob81CkoVYxkaVPMKPUHujcAbIwvLmaRFTNAbEij
         E66niRRwDTvXWZDWEzAjNF8Q65tW5+4p0yemX8JYjDBWeYA49hyNIifLaprye/Nog5ww
         IHyQoODw2hS58ofy9pDIMtFVonbj0AtOTIUzwSLCMc6p3HDI1XD/83bxvHPOUCoLcuUF
         r+clspdp/i9Emm/kjMKRPgZ+uS1JOLG0UL6R4TzKAy6NNm69pSbzcERshCCwoDlcq/f3
         hmr0JYpmDDiGuXENsMM9qF2SQ/hW549AOZx821ggjs1n0N2FgkHsEmkc2O/shNqS1eJs
         22NQ==
X-Gm-Message-State: AO0yUKVXjjPppYns9CqMkDSspqFR5g/L8ajzsXhBThUMYmhA5wdKewUa
        1RO3G8wLZgsl+Ei8+JzUDjLKKmNksdYq8uRU+PoV4O6u
X-Google-Smtp-Source: AK7set8Bt93p+le3ZTLvvbo1p7ra+NSBT6sMzn7RwOxWikGLJD5vXTFoWtCgEfpA2i5M6jwp8Gn7uA==
X-Received: by 2002:a17:90a:1957:b0:237:659a:a44d with SMTP id 23-20020a17090a195700b00237659aa44dmr27484967pjh.9.1678479049380;
        Fri, 10 Mar 2023 12:10:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ds11-20020a17090b08cb00b002372106a5casm300345pjb.44.2023.03.10.12.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:10:49 -0800 (PST)
Message-ID: <640b8ec9.170a0220.fd82a.1024@mx.google.com>
Date:   Fri, 10 Mar 2023 12:10:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.16
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 172 runs, 3 regressions (v6.1.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 172 runs, 3 regressions (v6.1.16)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
bcm2835-rpi-b-rev2 | arm   | lab-broonie | gcc-10   | bcm2835_defconfig | 1=
          =

kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig         | 2=
          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.16/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8a923980a19087421e8c99efb68ca0e4200daefd =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
bcm2835-rpi-b-rev2 | arm   | lab-broonie | gcc-10   | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/640b55e2748456236a8c86a0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.16/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.16/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b55e2748456236a8c86a9
        new failure (last pass: v6.1.15)

    2023-03-10T16:07:36.464557  + set +x
    2023-03-10T16:07:36.468537  <8>[   17.155067] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 137168_1.5.2.4.1>
    2023-03-10T16:07:36.584864  / # #
    2023-03-10T16:07:36.688037  export SHELL=3D/bin/sh
    2023-03-10T16:07:36.688913  #
    2023-03-10T16:07:36.791318  / # export SHELL=3D/bin/sh. /lava-137168/en=
vironment
    2023-03-10T16:07:36.792036  =

    2023-03-10T16:07:36.894535  / # . /lava-137168/environment/lava-137168/=
bin/lava-test-runner /lava-137168/1
    2023-03-10T16:07:36.895798  =

    2023-03-10T16:07:36.902349  / # /lava-137168/bin/lava-test-runner /lava=
-137168/1 =

    ... (14 line(s) more)  =

 =



platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig         | 2=
          =


  Details:     https://kernelci.org/test/plan/id/640b5b1a5b92ce21ce8c8634

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.16/arm=
64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.16/arm=
64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b5b1a5b92ce21ce8c863b
        new failure (last pass: v6.1.13)

    2023-03-10T16:30:09.320846  / # #
    2023-03-10T16:30:09.422751  export SHELL=3D/bin/sh
    2023-03-10T16:30:09.423192  #
    2023-03-10T16:30:09.524639  / # export SHELL=3D/bin/sh. /lava-291657/en=
vironment
    2023-03-10T16:30:09.525102  =

    2023-03-10T16:30:09.626606  / # . /lava-291657/environment/lava-291657/=
bin/lava-test-runner /lava-291657/1
    2023-03-10T16:30:09.627326  =

    2023-03-10T16:30:09.632859  / # /lava-291657/bin/lava-test-runner /lava=
-291657/1
    2023-03-10T16:30:09.696725  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-10T16:30:09.697031  + cd /l<8>[   14.419978] <LAVA_SIGNAL_START=
RUN 1_bootrr 291657_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/640=
b5b1a5b92ce21ce8c864b
        new failure (last pass: v6.1.13)

    2023-03-10T16:30:12.046966  /lava-291657/1/../bin/lava-test-case
    2023-03-10T16:30:12.047338  <8>[   16.864575] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-10T16:30:12.047577  /lava-291657/1/../bin/lava-test-case   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C951200F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243715AbiD0RF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 13:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243653AbiD0RFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 13:05:55 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB025EF
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 10:02:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c23so2123034plo.0
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 10:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bBoVdQa5cfN9fTCZC/Cl7heNgBC94Y2fDxfBwgqGRTI=;
        b=TqH4nsal7TrJPr10p7V28XWQGImMHRxF2SKmei0z+4UqyBxPf1LEyMQQg0u91OWqKP
         db6jOMhZVu8v9qCebnQiPmewGzpgirmdNmrCDABqk2frc5cQyl0bKk8wJlwanars1uKD
         /JCD1yMED3FtZ9P41vIAztIsSyMeHp5ZaAsfZY3PSRvoihPIo6LsUF7cKwccW0ajhYbu
         T2jK4tFpygdMV4IRMfOBU/MsQkaJUIsQQOotnlM2aD/mx7d1UVV+0fvbBOLkPdZtcGWf
         DK194nx4Y5qVBGiwkRQOwnVrCno+Cm656YjFM+f94Kvrx8bZ+D85iwFUmUXATCmQmyAH
         ZazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bBoVdQa5cfN9fTCZC/Cl7heNgBC94Y2fDxfBwgqGRTI=;
        b=HRsp2VCkwShTgoddtbpir0x4wTn+ERu7KAcMutJAhvjrxp3kl6zbVLGNdH+l4Ik0X6
         Du2LCOI7XYOki8vNdnjLDlKTqNFNHFR5M9dW1jgBhbSP7SP953e7BUTayMCYl9AC/lCy
         zBHOGHHX7glCAOGz9j+Cjq9fdls8uvR6ovDJRhMj9nddRAyWlrmasNQU7jRAgwtcjh7k
         JhH9NTXwYPB2gDmBVeusb8s7wR0QPkUzBbANWo+NnXFWOlz47nKbGpQ/c9/Wy8V5fBrE
         wHTJ9Dn1AsjyjZZWGD8f49DFNeV2sKTDsizOizb84nNoZYurzYQ+dkBW6vLzKTAXGa+H
         WIoQ==
X-Gm-Message-State: AOAM530OlQHwX/Pb3QZh6TnLw+F9oPkAQ+r46FMUvpHqdAXO0W87EYVt
        2I61Nr+SsxoPPGXx5WLP2Yu1yjERdLt/uuzO81I=
X-Google-Smtp-Source: ABdhPJyGQpbbtdNRXqdN0+RspkdQtEmSbJ4Mp0VYke3jsApQheSmQS3IBRV5euupAQgIveodk6566A==
X-Received: by 2002:a17:90a:f3cb:b0:1d9:62d4:25db with SMTP id ha11-20020a17090af3cb00b001d962d425dbmr20561730pjb.222.1651078961927;
        Wed, 27 Apr 2022 10:02:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090a390a00b001cda0b69a30sm3411543pjb.52.2022.04.27.10.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 10:02:41 -0700 (PDT)
Message-ID: <62697731.1c69fb81.620b9.7477@mx.google.com>
Date:   Wed, 27 Apr 2022 10:02:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.35-124-g1607e7874f87
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 110 runs,
 2 regressions (v5.15.35-124-g1607e7874f87)
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

stable-rc/queue/5.15 baseline: 110 runs, 2 regressions (v5.15.35-124-g1607e=
7874f87)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.35-124-g1607e7874f87/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.35-124-g1607e7874f87
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1607e7874f873a59f5e5450ee25aa54d32099f67 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62694551ac44d5e7e9ff9492

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g1607e7874f87/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g1607e7874f87/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62694551ac44d5e7e9ff9=
493
        failing since 27 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62694a10feb8fcedbaff9460

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g1607e7874f87/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g1607e7874f87/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62694a10feb8fcedbaff9486
        failing since 50 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-27T13:49:44.044040  <8>[   32.582564] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-27T13:49:45.067176  /lava-6191369/1/../bin/lava-test-case
    2022-04-27T13:49:45.078150  <8>[   33.617067] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

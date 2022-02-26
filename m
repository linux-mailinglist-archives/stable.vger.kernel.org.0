Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314CF4C5605
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 14:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiBZNBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Feb 2022 08:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbiBZNBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Feb 2022 08:01:53 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96A4266D9B
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 05:01:18 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g21so724805pfj.11
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 05:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QZlQsl/Q1hgTgl/05AVVn+xAkUOOa/vVM85nK2K+vx0=;
        b=0CUHKnHkKnfPkaXT6SRICBcmwmTKJrmiOQTkbCsUvmQWaoeALdU8sDqVwOydJBNzmb
         tjMk1wQRRAbsFFg2IsCOBwgcqssX8AuJJoWU60UMAVUFrQTUsPCJowHzdxzDOLoiinIx
         zeXl7ckob++pB0B+0QMvpAUjpCebfhxoG81zBxbZdePzb7N1r9DXHLllUE5VrFQrz+Yu
         +XQR2D80kE+exBiBRD2b2TEKtKkb5b3YyREezjxW0j/ka9lSfnktkZri71J24/38ScYU
         9z6dDhjiRFtLNT0zz1JqcdVDoisIePAVJJx9mDDPN0PViehIoWsXlviDGCF32v4hLdCA
         Ex7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QZlQsl/Q1hgTgl/05AVVn+xAkUOOa/vVM85nK2K+vx0=;
        b=TeB6hBmjEZl22rKSH2GpZRxMKm5B+CbFmrXDuDgF7xJygnUq0BdTSqU10YQOQgzYGx
         HyLeN1H3YyuWsngvAnnk3IffVdRKfFz55h+4JIxJEKcqxXNBRSTH+PqYuW4wcJi5+BOd
         7L1M3c+K2gVZ1y5SaDHv+QFMMh2pbFjQm7Ynih32cLJ5y+e3CqeVuIvK1KjjqXsbfgaO
         laoR4jn+bEX4XZFa/qfyepY3tohl1wTFihYP2+SC9bSbizWnuwSFDX28o6PdAbyuJeMj
         MRW+0nEYDONkIcBQ78bSv7QqBaGJTW0/toVrvwQCQOwuol8lWOURudI2WxuixMreb8gj
         BZwg==
X-Gm-Message-State: AOAM533S2Evl96JAU5Aq1b5F2FgHPIJaDJIBMTe+em8Aic0dhWDAmr2U
        UoqhsBgS1VF45ENeS6zo9uOFCSpjI/qZSIAekiE=
X-Google-Smtp-Source: ABdhPJx8BGMLlinb+4bLz9tDnJeu8PUVjjf+GuWi9il12ztWeyVPyJR2GJmwwzNr7XneA7HsqjJpPg==
X-Received: by 2002:a63:ec46:0:b0:35e:7865:ac76 with SMTP id r6-20020a63ec46000000b0035e7865ac76mr9988013pgj.453.1645880478185;
        Sat, 26 Feb 2022 05:01:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b004c122b90703sm6691701pfm.27.2022.02.26.05.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 05:01:17 -0800 (PST)
Message-ID: <621a249d.1c69fb81.eee51.0fb8@mx.google.com>
Date:   Sat, 26 Feb 2022 05:01:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.102-51-g28a525c0db30
Subject: stable-rc/queue/5.10 baseline: 110 runs,
 2 regressions (v5.10.102-51-g28a525c0db30)
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

stable-rc/queue/5.10 baseline: 110 runs, 2 regressions (v5.10.102-51-g28a52=
5c0db30)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.102-51-g28a525c0db30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.102-51-g28a525c0db30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28a525c0db309d479a16003fe98daad065e80a90 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/6219ebf9dac97f003cc62968

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.102=
-51-g28a525c0db30/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.102=
-51-g28a525c0db30/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6219ebf9dac97f0=
03cc6296c
        new failure (last pass: v5.10.102-1-g77884558a50f)
        4 lines

    2022-02-26T08:59:16.049588  kern  :alert : 8<--- cut here ---
    2022-02-26T08:59:16.080802  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2022-02-26T08:59:16.081068  kern  :alert : pgd =3D (ptrval)
    2022-02-26T08:59:16.081961  kern  :alert : [<8>[   44.931211] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2022-02-26T08:59:16.082229  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6219ebf9dac97f0=
03cc6296d
        new failure (last pass: v5.10.102-1-g77884558a50f)
        26 lines

    2022-02-26T08:59:16.097602  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2022-02-26T08:59:16.139925  kern  :emerg : Process kworker/1:0 (pid: 16=
, stack limit =3D 0x(ptrval))
    2022-02-26T08:59:16.140190  kern  :emerg : Stack: (0xc212feb0 to<8>[   =
44.978834] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2022-02-26T08:59:16.140421   0xc2130000)   =

 =20

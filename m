Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4FB6311EC
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 00:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiKSXRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 18:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbiKSXRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 18:17:03 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1903414010
        for <stable@vger.kernel.org>; Sat, 19 Nov 2022 15:17:02 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so7782098pjb.0
        for <stable@vger.kernel.org>; Sat, 19 Nov 2022 15:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=x++wOqGKZpuApNie3pWxwS21B0XSza5TNIscZNTDebA=;
        b=zKBWPMTIHHbYP8ZKcxD0Dgga3KtM9LU2yI/PaLpBt1K7FMT03GTlaQkCm0balbzyeK
         VsJGJQmbAI7sQWESPUeSdKyzUjf6w2joL+ifDS6iX6ghFxdRCVEZs5ra6/xYFoXEdv6D
         Ayi1EVbol3my3n72eIDRHmVigUxR9xHXFcDMGGTrgebobjvNXH+auiX4GpAwf6VQyJNY
         knHcGj1yu0sVeBcHnQmF6WNNZ6VzHKCpiMjL/Ue+LNhKVuxqZDqzHIV6S7x5KzNIXOYS
         OFGY5QnRALL5f0QWkJXHVjQt+jks11cRB9TPCWWwtDZWaOJaEpJQUjzEEOXyDSDtPObo
         Prdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x++wOqGKZpuApNie3pWxwS21B0XSza5TNIscZNTDebA=;
        b=Eu4MbFxYnW2ERTjyfBN1BUTvT2rlkLPd4LlWdvP6FgCOjhrJiTbeEGVmOBCILSeok1
         tuxtsyRnl6hd358M+gM3PguvSlRz0Brcz8W9VMbpRjvs8q/9VlztesCoc+LVuUFIL28F
         urcLH9yhfHquyYhOXFBWiEqwlwR8g2E+ouZnua92pdu1Ccz0Prvz9HRtzveG9h2i9WXa
         JJcBBgw1D2zykB9dwdyg1i4WxyGV7vL7BHVf0NY24QCwbEsnUMGAnbz5+SNtUPW9KuAx
         Mpp1Ee/6wnQWQb7FFzsbfWv32WQyciShsYJZYbR8gYyNV1gMV0JdcSbLzecvqwj7Uw7q
         QYfw==
X-Gm-Message-State: ANoB5pnty/pU53o4nsUBOmdysPYjGHqVXDODl+rwcAmywuGsZasCxhi2
        DDmmEEUga4LvgbelN07O7NrJ9Fx9Slse6GZz
X-Google-Smtp-Source: AA0mqf6Aly9dlyAJqN8MVq8cYI91H1TJT5Sky+/Bq0DwT/lfPd/qW0385EXjGI3iM42KQrp+o8FJDw==
X-Received: by 2002:a17:90a:5911:b0:218:7b32:d353 with SMTP id k17-20020a17090a591100b002187b32d353mr12124551pji.100.1668899821382;
        Sat, 19 Nov 2022 15:17:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d125-20020a623683000000b0056da8c41bbasm5591461pfa.161.2022.11.19.15.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 15:17:01 -0800 (PST)
Message-ID: <637963ed.620a0220.45c69.855a@mx.google.com>
Date:   Sat, 19 Nov 2022 15:17:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-37-g99f5f90196e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 3 regressions (v5.15.79-37-g99f5f90196e7)
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

stable-rc/queue/5.15 baseline: 136 runs, 3 regressions (v5.15.79-37-g99f5f9=
0196e7)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | imx_v6_v7_defconfig |=
 1          =

imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | multi_v7_defconfig  |=
 1          =

kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig           |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-37-g99f5f90196e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-37-g99f5f90196e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99f5f90196e7d9f35224fed0719f77c5e38260f8 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | imx_v6_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/637930d28eb886c28d2abd05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
37-g99f5f90196e7/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
37-g99f5f90196e7/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637930d28eb886c28d2ab=
d06
        failing since 55 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6379346ac4d4974c002abd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
37-g99f5f90196e7/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
37-g99f5f90196e7/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6379346ac4d4974c002ab=
d08
        failing since 55 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig           |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6379342fe6a6938d592abd5a

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
37-g99f5f90196e7/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
37-g99f5f90196e7/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/637=
9342fe6a6938d592abd6d
        new failure (last pass: v5.15.79-33-gbb894c0ae2bc)

    2022-11-19T19:52:57.187659  /lava-210109/1/../bin/lava-test-case
    2022-11-19T19:52:57.188093  <8>[   14.569692] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =20

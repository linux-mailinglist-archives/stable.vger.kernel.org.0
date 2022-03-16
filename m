Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B04DB9DC
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 22:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244413AbiCPVDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 17:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353443AbiCPVDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 17:03:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76F25A5BA
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 14:02:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n18so2804201plg.5
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 14:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xHmEeKCFEBJtkMAEJX5hzblmSEnQV7AwWpNRZc/cf2Q=;
        b=gWulfu30dNtdRrxBPnmFZn8Ps2zf9ySMNpTGMGgePqS6iISiOU5mhtBpfaTvapSxAA
         cdFE07/QsyAyOdtzrde2sifHbJGaxe6+SoY3oeGiazIrNt+tQdgrdKGqm5nzm9Q3Wxjr
         xvjy+Tlt/mphFjKQe0Ect0hPINLpPC0K8I3cfFFV1uzHksIqYp90mVmUFEcyQ2j9vY50
         21kuDukshonn8thXWi+hws1IAPua26ToMCflshj+9GRZGOMfq+75/gcsOnwCuwllWj3T
         NKjVuWQRqR8QY2+c3UW/P6204jKghM306rZLU4SXmtkWinp/Xok9Ci/cmLde7iQmW8RQ
         2xJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xHmEeKCFEBJtkMAEJX5hzblmSEnQV7AwWpNRZc/cf2Q=;
        b=hF1JqA2A0TdyUrGgL32YYfVXyqVxJQxtrFFYF6vpcxZUZJD+fthQnHdxObsfMLA3i/
         YRwIQpHnBBsfLu0QpjgFlmPlCchOyGseoFZrkMPrmmth4JwSysTNiGkPuLNSt6sBFZQU
         OnAYRdMGlGCXaLP1dZEMF/Ux5CPjLV1MBaLa3h3Bay3XZw4sr7QJM5MMKr08r+4LCXtK
         YoU2hrnGOs8jaR0l8UCBeVfmlHuTlaSxCh3fIfm/ulCRbRgiAAs1/sMT1XcDPmMex9Vq
         6pR8JqdFGhqxWvX7iFFLUdFFyRsu3KuG9UiY+5eZjTzxAOw6B7w1DfeRuh5rIYvbvPdr
         wxjg==
X-Gm-Message-State: AOAM532sUmY6AdGMsmjRfSI0sHWYx9Oxvw66KJIe2jUywf7bQBzlk0gr
        HbxBdEjuYT+CPafVZk2VRO0QNQmUcRvz1CTvjLQ=
X-Google-Smtp-Source: ABdhPJzNMGMKXdzBwT1w1xK9i57UC+CsJ8UbyuHR91vUg6rNQBGGdVqKfX7Gv7Y+MSxhTp8DzemrLg==
X-Received: by 2002:a17:902:a40a:b0:153:dc29:e079 with SMTP id p10-20020a170902a40a00b00153dc29e079mr1557928plq.146.1647464551280;
        Wed, 16 Mar 2022 14:02:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00134b00b004f7bc05c676sm4584296pfu.197.2022.03.16.14.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 14:02:31 -0700 (PDT)
Message-ID: <62325067.1c69fb81.bb7c5.af79@mx.google.com>
Date:   Wed, 16 Mar 2022 14:02:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.29-24-g8464bb5afc5b
Subject: stable-rc/queue/5.15 baseline: 81 runs,
 2 regressions (v5.15.29-24-g8464bb5afc5b)
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

stable-rc/queue/5.15 baseline: 81 runs, 2 regressions (v5.15.29-24-g8464bb5=
afc5b)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.29-24-g8464bb5afc5b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.29-24-g8464bb5afc5b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8464bb5afc5bee6a21089d65c6a32dbe2f0c3aa5 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62321ae99301d3d4a2c629bf

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
24-g8464bb5afc5b/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
24-g8464bb5afc5b/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/623=
21ae99301d3d4a2c629d6
        new failure (last pass: v5.15.28-111-gadbed68f083b)

    2022-03-16T17:13:58.963965  /lava-99639/1/../bin/lava-test-case
    2022-03-16T17:13:59.038603  <8>[   11.264059] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-03-16T17:13:59.039013  /lava-99639/1/../bin/lava-test-case   =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623220162c0a28a53ec629b5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
24-g8464bb5afc5b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
24-g8464bb5afc5b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623220162c0a28a53ec629db
        failing since 8 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-16T17:36:06.952359  /lava-5892198/1/../bin/lava-test-case   =

 =20

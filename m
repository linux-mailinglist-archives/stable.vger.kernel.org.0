Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259F04D6D8D
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiCLI3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiCLI3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:29:18 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BEB1AA48F
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 00:28:13 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so10168590pjl.4
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 00:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CfSY+GpTOD2jqFnBt6aN7ADPSFA37ZUJpeHkPIo7qVw=;
        b=tNDwvGdi798xZryl/1HBId1UZWrCpfP1opERYd/BQ6Q7ggcacHe0szgTHx4ErnFBsG
         qrZIU76O9MTK3Xyh9X222TnZcS6dWJZneXEv31ACclAa9vSLW5s1kK7IEBJ7Ax3ZD4+t
         eZ8pQoOAkUgtM5CW6+yOiEDbGZY1cPfvWasK9pFr9v3hPFg/XBo5HiKaXUm+dtf+UN9C
         QjFtYobftDLDFpuFjmN0w27Ui4Ag1KgQ0TayT3ZbruaXgx1jUAYzrQl39L0Xf8VIEMLz
         Yv+iP2BsDbvsfPBfpC3ZCpZb3ZlNhVnpUx4i6HM0IEWY+nHyxCs5rbZ/lwPENG52A4E0
         yaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CfSY+GpTOD2jqFnBt6aN7ADPSFA37ZUJpeHkPIo7qVw=;
        b=0v/u39X70fRcP0fJn0NMXtvFUKLOeZNmb00aPaHfWFqmUYvXI/LUkd1NcUs5MtQ/Zg
         dTc9delpWsuYYk7K4CRjxx283MvGpMlWDMrIcGuOf8GuDNIGisiUTZMz/sKzin5gboX9
         hGgWZ97lcBR85wEZnMntoHhVoTagxccXvDy4rCZbPmBqxL+LFSqLdu5rITtVmrS8mI3N
         4kfawM/nC7Vms2ccvZWl1iBJe2pqrLMqk+2oxO20ScJAwlKSJE5WBtQLyoQq7Ga/iCSL
         7Rj8oJ+cp3wht/x/RLhR82dmNGskQweRy6JgXfTk2ucIMkbWrPzmH7AZQOY9rJYELbhY
         16sQ==
X-Gm-Message-State: AOAM5330+wCVpwH5SKbqJTnIpucyPVrM2bDRTEBiQZ2vXz0Tefqx7EGG
        M/f1NiuZNmcJqeG+SHlf2QDgD5E4g5is0nS/0GE=
X-Google-Smtp-Source: ABdhPJxrcI0X99WbF2W8xflh5Tr6KYBrH3EVHPdu3xXUewFEIBeVySkDFyZeSBMZtBiSIQwnUbAfqA==
X-Received: by 2002:a17:902:a3cb:b0:151:e52e:fa0c with SMTP id q11-20020a170902a3cb00b00151e52efa0cmr13996602plb.70.1647073692755;
        Sat, 12 Mar 2022 00:28:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b003807411b89esm10556772pge.54.2022.03.12.00.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 00:28:12 -0800 (PST)
Message-ID: <622c599c.1c69fb81.4ef3a.b5d1@mx.google.com>
Date:   Sat, 12 Mar 2022 00:28:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.27-59-g733316a3fd59
Subject: stable-rc/linux-5.15.y baseline: 92 runs,
 2 regressions (v5.15.27-59-g733316a3fd59)
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

stable-rc/linux-5.15.y baseline: 92 runs, 2 regressions (v5.15.27-59-g73331=
6a3fd59)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.27-59-g733316a3fd59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.27-59-g733316a3fd59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      733316a3fd593d01eef349f96da2ba8f870f6245 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/622c22078bdfb0738dc62980

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
7-59-g733316a3fd59/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
7-59-g733316a3fd59/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/622=
c22078bdfb0738dc62997
        new failure (last pass: v5.15.27-44-g980f7d3e8f91)

    2022-03-12T04:30:47.877306  /lava-98004/1/../bin/lava-test-case
    2022-03-12T04:30:47.877593  <8>[   11.268975] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-03-12T04:30:47.877747  /lava-98004/1/../bin/lava-test-case
    2022-03-12T04:30:47.877890  <8>[   11.289077] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-03-12T04:30:47.878063  /lava-98004/1/../bin/lava-test-case
    2022-03-12T04:30:47.878203  <8>[   11.310533] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-03-12T04:30:47.878345  /lava-98004/1/../bin/lava-test-case   =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622c2436cdde85559cc62978

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
7-59-g733316a3fd59/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
7-59-g733316a3fd59/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622c2436cdde85559cc6299e
        failing since 4 days (last pass: v5.15.26, first fail: v5.15.26-258=
-g7b9aacd770fa)

    2022-03-12T04:39:54.534235  /lava-5864002/1/../bin/lava-test-case   =

 =20

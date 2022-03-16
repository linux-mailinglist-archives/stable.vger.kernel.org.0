Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC04DB913
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 20:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbiCPTyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 15:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiCPTyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 15:54:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E33C1A399
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 12:53:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so3472265pjl.4
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 12:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z8u6Deu+wZupkvrjihxOBoN27zl49dZ0qYZpPt43Ry8=;
        b=wTRCLwcBrrsOM0QrOKCrUQgV50Xwy8rTNHAxhvKW70MBwkqU0oD0hOOSMR0W1BHx34
         x449ikySZpZx0FKtq7ha8VVSpyXi8N3kovCRvecPPToj6NPxh4V9uFwC5m06C0kjDsuq
         kK/14nY/9XhMuAeP1yS7r73vohzr8QXDCEB5Jjk/5kK6yECOvM9An0dXgVnQnLyYyk48
         y1bwD9635fS+RTJA0lcd/Q7wcj9VdA53PYfHhUw4naTQ3UD/XEKoKfFFvKLuvrXFyqlz
         cXzFMcNXnohqM93J2mMvFJZyRubJTco95jT+yUmA27uQgQOCaz5YGW7RgwsTEgUiElNj
         8cVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z8u6Deu+wZupkvrjihxOBoN27zl49dZ0qYZpPt43Ry8=;
        b=ZRAOtuT4+8BiZYWsC9xzLXm5liIdjZbY73pdauhCCPQAziWmLpHFwBPRWOs4wWwzSR
         Dz+0dT60nBvNmaW1QSr6wJVdPua4gGISX7iwRSjtMJb3uv+swRazAzQjCWEXCi3KkcWx
         x+J9Kw6Odzp/MNvb0B40Q7T7eBaAj+K7YJyTUxFuT3NiSfATX8FKbgJMMKvwXFuNP9Q0
         /hztt6B0jCsXnuWm6vYBjuhPVotZUs60667X3NIY7wTLbVFpauo0JEZktGT2fDaVT2SE
         KRbcekVARx/OuDcJR9fV3qXSoarBXYTRT9He27Ak3kSPNDw9pSnP/jfZMcKF0bZOLoNT
         wvxA==
X-Gm-Message-State: AOAM531Xv/RwfCAOdZy9u6MNQLFd0QzOSWL5cB0HcKIz9WSlr/8KBeGL
        EeXUhUW9QGiRLFrMHtzqrM8YHdkPLzTt8/WY8P4=
X-Google-Smtp-Source: ABdhPJxQVLtYpEAqynNBukvk9GcsgbH6uZPksxy8i/CExSEsKnFfIKoGo8jXuyK5hHr6MY4dme55Jg==
X-Received: by 2002:a17:90b:3ec8:b0:1c5:68d3:1883 with SMTP id rm8-20020a17090b3ec800b001c568d31883mr1406384pjb.201.1647460403946;
        Wed, 16 Mar 2022 12:53:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a00231200b004f72b290994sm3302444pfh.180.2022.03.16.12.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 12:53:23 -0700 (PDT)
Message-ID: <62324033.1c69fb81.e640.89bf@mx.google.com>
Date:   Wed, 16 Mar 2022 12:53:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.106
Subject: stable/linux-5.10.y baseline: 70 runs, 1 regressions (v5.10.106)
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

stable/linux-5.10.y baseline: 70 runs, 1 regressions (v5.10.106)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.106/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.106
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      327f1e7d813c77eceadafbdc498f5eb680fd9fb2 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623207f5d8d49f3de2c6296d

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.106/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.106/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623207f5d8d49f3de2c62993
        failing since 7 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-03-16T15:53:03.650231  /lava-5891494/1/../bin/lava-test-case
    2022-03-16T15:53:03.660822  <8>[   34.057312] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20

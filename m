Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370E64D2B19
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 09:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiCII7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 03:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiCII7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 03:59:16 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6998C3FBD2
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 00:58:17 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d17so1668479pfv.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 00:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VUDD26J4yzmGyxFpmCKWaIE9d0anjc2yY0+qJWQmFqU=;
        b=fQRkjFcIq3x618akzpjyRvzy/6S3tp42Yu0AKlAJhYnSO8nMvfVe6udHvrhUXTwhyR
         MDBeEIhWB9jpnLA9I0X4QBfQ1CBvstR2R/b49tVAy7ol5mCWarV5cW4eB6JazVAr+O0S
         vvKtfnjb23mckaIsBef6FDfJElXqQTBDroiuPJvhZAjOBKwkJvHlnNJoxKqa2t/qvegs
         eoGcQjaSMh6mgSB3tnMVMKlIFsOJBYvF8FpXDNgTAsgZq/7W1I9Sg7o9aL0qLEyTpxzw
         L7Br09OiX2psENI/HjMWS9HO4CEdmMSwbBFz/nFJy+1gktRDdDiJ2zQvyUJvn3dmVvam
         Og2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VUDD26J4yzmGyxFpmCKWaIE9d0anjc2yY0+qJWQmFqU=;
        b=VIxAbY9ODMVIVqxXJQyI27k46U2lnAvnffQfjzEywz3E6hCGvnNgYSgH63BUWMgbEP
         O2fFjd4QmcmhQyWALYTSQxUBTwd8dBbV0BqDNfOsJPohu1i4vZ4Bhqq0kC/EyFlcHcP0
         CYRYxIyxVVoP2JZZ8M0XnDk5GzpRV+JgmV4xq65hmbHktcyluNK+b7oLullIMdAjbgrX
         3OOSm1Wp8SDo4lZ9UkicF5jHwwS18XglnU/TC1yPJm5geEBMl8Y2VHCCDftNcE0e3SkP
         EuLWskO1ZQg2Xpr+PnjpyrRylfjum0/ZgXNw8LKYFdbHBILAcGfXjIDPMhtec4LwwovQ
         n1QA==
X-Gm-Message-State: AOAM532vM+GujN7VtYOQVFxLOIe0RPqUz+vUZvDmzYXUWUi8jdJz6EBy
        3z44batDqYbDq4j3EHagtivlKVZjhzct0BuW3gw=
X-Google-Smtp-Source: ABdhPJwsoQCdrDlQVsopjqQYd4AgG5u1Qy7FF5ekySKtpIuoY/WZ4iiS4g96HNg8RYypmks56FLhEw==
X-Received: by 2002:a05:6a00:244c:b0:4f6:67b8:a6b4 with SMTP id d12-20020a056a00244c00b004f667b8a6b4mr22605206pfj.51.1646816296958;
        Wed, 09 Mar 2022 00:58:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23-20020a63fe57000000b0036490068f12sm1577124pgj.90.2022.03.09.00.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 00:58:16 -0800 (PST)
Message-ID: <62286c28.1c69fb81.f60f4.3e4f@mx.google.com>
Date:   Wed, 09 Mar 2022 00:58:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.104-43-ge5e4a8f0fb6e
Subject: stable-rc/linux-5.10.y baseline: 26 runs,
 1 regressions (v5.10.104-43-ge5e4a8f0fb6e)
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

stable-rc/linux-5.10.y baseline: 26 runs, 1 regressions (v5.10.104-43-ge5e4=
a8f0fb6e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.104-43-ge5e4a8f0fb6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.104-43-ge5e4a8f0fb6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5e4a8f0fb6eb54f3804492468a31ffd8bb4f81e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228380e7babf51052c62971

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
04-43-ge5e4a8f0fb6e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
04-43-ge5e4a8f0fb6e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228380e7babf51052c62997
        failing since 1 day (last pass: v5.10.103, first fail: v5.10.103-10=
6-g79bd6348914c)

    2022-03-09T05:15:50.293556  <8>[   32.917929] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T05:15:51.324103  /lava-5843331/1/../bin/lava-test-case   =

 =20

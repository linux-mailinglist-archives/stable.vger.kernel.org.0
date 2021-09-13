Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662E4409D5C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbhIMTrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 15:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbhIMTrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 15:47:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D330EC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 12:46:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mi6-20020a17090b4b4600b00199280a31cbso603797pjb.0
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=932qbc8OoS+HGIjHD2YsZmEz7M4Tkl2+7Wjc9cS0o4I=;
        b=GsEyzP6VdThekfRF4aV4Px4Cqtrut6rr5sElAr9799jgxTH5gUWSwy5sisvK2Uz5V3
         nqC1zFLG85xb4hz5VpSSbpQ6SRCpMAvgC0LdAafjuYVyzLz9A5nJrks0kHtd+tf0PahO
         r6l7ww4RJScRUlLbFdacy+j4fBoSVXz191JLHu7aDtb/OCwd/b70JNcRfwrK6eU/G4oZ
         0wSld+rA8I0twnTFCr7D4qxVIRwmLOd1huzGYnF9sFR4YaLsT4oBoHQBoRtnqhhvKSeV
         TtT0qA7uOrJpXwherEAnpO1d1LQ833rNNMihgTVzMIoFZXHg842YeFVVk3DAyTkAgbS6
         Cukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=932qbc8OoS+HGIjHD2YsZmEz7M4Tkl2+7Wjc9cS0o4I=;
        b=spCDwbyBWOPyAs+FdLH86e7O/8hpVgAD1ilnYYwYgIn/PzyrVpyNQtrtXf0xfoZqBp
         KNTFaOsRL2qVR+mUetWKLBwQPyciqMZvZCpvIPpndZWYwzguwvm4NLWnx1al3M9b9kVd
         d6Qzz44ic7qQp1oaJNOlO0i8cLJ3Jx3Oi5tcCCljNwts7RvtH4VlalyosGndd0CEpiWR
         CFCadJ/LKJzfMGHl0mjivJGMB5DbHKxyOXT2cBHnCcaamBfACEB29lkyU+iPC5+7vjeC
         gX4bkUpDtCijmk9XfrhBkctYtJ18qT1UJW0Ula1xJzxQSwZ7pvG4PidhRPJH6yf6GlEW
         IOwA==
X-Gm-Message-State: AOAM5336mtO75rp/Cz8VgJppuTyE43ua+GaRjZQCbyX5fAeHSMXYGtAh
        cqaCQTN3KqxPJ4qcHH9CxZBO8zMgEZW4WcEN
X-Google-Smtp-Source: ABdhPJwc2/xErwJli79xx7NOkDo/oleSFfsdB+DTSMF+5SnC0t5253u7fsaCwSbZI5ZAniD33I4lbA==
X-Received: by 2002:a17:90b:4901:: with SMTP id kr1mr1273945pjb.80.1631562360107;
        Mon, 13 Sep 2021 12:46:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm3216214pfp.26.2021.09.13.12.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 12:45:59 -0700 (PDT)
Message-ID: <613faa77.1c69fb81.7b878.a1c1@mx.google.com>
Date:   Mon, 13 Sep 2021 12:45:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246-100-gf55c08e525f4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 133 runs,
 3 regressions (v4.14.246-100-gf55c08e525f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 133 runs, 3 regressions (v4.14.246-100-gf55c=
08e525f4)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-100-gf55c08e525f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-100-gf55c08e525f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f55c08e525f425a572d68bcf3ccce2656200f75a =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613f990aacd026ae1d99a315

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-100-gf55c08e525f4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-100-gf55c08e525f4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f990aacd026ae1d99a329
        failing since 90 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-13T18:31:16.924159  /lava-4511071/1/../bin/lava-test-case
    2021-09-13T18:31:16.924478  [   17.238326] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f990aacd026ae1d99a342
        failing since 90 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f990aacd026ae1d99a343
        failing since 90 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-13T18:31:13.472151  /lava-4511071/1/../bin/lava-test-case
    2021-09-13T18:31:13.477469  [   13.788393] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337253DE49C
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 05:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhHCDOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 23:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhHCDOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 23:14:10 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93821C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 20:14:00 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d1so22047377pll.1
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 20:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dWpPStAvxFnPIE9N35wka8oBFF3TfuXCJdVjVCLyv70=;
        b=ZPQDuaPJmrT5IcsWEyMkR70uYNPHOhhadDNV01T69CbaUZLMNZFMO0e5SMekdHC6T/
         eRil8dfd9YF76ci1shtoLCHJjXPu4WpLRq1egSr0jrFIUNMuOYE/yuCljOxdO70L/R30
         rXxYPiSP0kJ+Zl+ehT5XaJSyM8M+Z8fp8kww4npB5hAb8rd9tdh0htKX7hB73f9DBQ91
         J9KMwiHcCjXsGxJhMYwBHwUqz1B9KGfsABMLP7e59EBlAJVgmBIMnjf1gVx+wiX55Jhv
         GrPpdq6+LldFdPwTQZ44rcJVqtBCCb5VWlWPW8/NmeIgwNMyvHWD86otzTflE7rtKrKm
         EZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dWpPStAvxFnPIE9N35wka8oBFF3TfuXCJdVjVCLyv70=;
        b=Jsj+N0evUexfQVsh8Fd45Pyr6G7OFwiYfcbghnpUp5/vHbFOHKjDFRnWhbQR6Q9SbK
         vy7ASe1trBA6kvCEW4aOStWnsxo7kC7Wit1XAFVfcOKeyS43nDzX3gXUnj0xTNTaFz+B
         OtSKCN4pGLI9ZcyVy7lsrmnLKhsx0KZ8zxgsQ0b9mCjlPU4C16kQ+8QS+Hlsx4cHnbt6
         5fx1r2YdI6EoQlVTn2mfLyNqbKVA4/GZ8QtnsELme4DyQBcm5uLt4NFYAzYQv6WQxIpK
         PCwHnQka6dvkR00X+z86YF8e079SxQu/cSQv7sgqkLI+DvmQ6wYiCWnK7bi1SbglDISb
         FqIA==
X-Gm-Message-State: AOAM530FIqfQj1vaMMx7No6+JniFRKxw1oz3Enj0/rxoVkJ2hlzOJCCN
        Pv/GgTck2y1OE6AYPZIfrbt5g6xLP7G/ww8L
X-Google-Smtp-Source: ABdhPJwn1kMor3TA9Qe/e7UjY7RckndfwSfwiLD/u4wvKYnCdeU8CXE0cix4+C7W33oa5EsS3XjTeA==
X-Received: by 2002:a05:6a00:158e:b029:32b:9de5:a199 with SMTP id u14-20020a056a00158eb029032b9de5a199mr19637562pfk.76.1627960439932;
        Mon, 02 Aug 2021 20:13:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g26sm1923443pgb.45.2021.08.02.20.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 20:13:59 -0700 (PDT)
Message-ID: <6108b477.1c69fb81.76ceb.84d6@mx.google.com>
Date:   Mon, 02 Aug 2021 20:13:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.241-39-g8314a8525f0c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 4 regressions (v4.14.241-39-g8314a8525f0c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 4 regressions (v4.14.241-39-g8314a=
8525f0c)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6ull-14x14-evk | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-39-g8314a8525f0c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-39-g8314a8525f0c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8314a8525f0cfbfd861902b568e6bc22f6b07617 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6ull-14x14-evk | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/610892d78c8eb4edacb1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-39-g8314a8525f0c/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-39-g8314a8525f0c/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610892d78c8eb4edacb13=
67b
        new failure (last pass: v4.14.241-16-g69e247082971) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6108a76f0cec2f7c31b13676

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-39-g8314a8525f0c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-39-g8314a8525f0c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6108a76f0cec2f7c31b1368e
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-03T02:18:08.895455  /lava-4312565/1/../bin/lava-test-case
    2021-08-03T02:18:08.912104  [   16.368057] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6108a7700cec2f7c31b136a3
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-03T02:18:05.452163  /lava-4312565/1/../bin/lava-test-case[   12=
.917932] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-08-03T02:18:05.452406  =

    2021-08-03T02:18:06.464695  /lava-4312565/1/../bin/lava-test-case
    2021-08-03T02:18:06.481601  [   13.936508] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6108a7700cec2f7c31b136a4
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20

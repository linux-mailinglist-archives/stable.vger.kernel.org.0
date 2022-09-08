Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BEB5B2433
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiIHRGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiIHRGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:06:17 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FBAEB865
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 10:06:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y136so13620156pfb.3
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 10:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=io04qv8/MvX1WDcguYko51sc5ZhKwDsInNX4hhMS7ko=;
        b=LbXD70g+HBIIXk35sAYFyHw5Acq/uru0LBPSkR1Qtq+wmj1/zn0cOlOC1Bt2UeW++0
         9dUQy0Npasp5Lu8ZwtBEIYaPHbQHB2mTkVbaLQDChASACJ35AjGPMZihoa+9dR3gHdSG
         KhSaIXHt6C2q/xuvEsZyr3llwehhk9grwUQRLpVMmb3Uwp3XEpXZMKSCasa+3JakoNNO
         VyHuIz37aiEey/KN+t786YQ/YIyrYz3mHa/T9iKbUbWZCWDXKLfuqud1hPIaKhsG7O4b
         zX/TsR542BCLDzh/mRLQ3Yy5qWr7Yb8KGO3IW3BXvhCacrHRj//m5s5aWUk9cnsho/ev
         Ri2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=io04qv8/MvX1WDcguYko51sc5ZhKwDsInNX4hhMS7ko=;
        b=P06vj2RN+gFTMabLkgDZ1Nvrb9/BrQAeFYRqW1Nq8c1oUQVdtzThaBkO7R4qN6by4F
         yA3uCPSHKEd7/7s2CWqmj4lUQ19j8/PZs24VSjmRSlMbX/seuA5pry2hTlmK3Wo3kSEM
         rRtpdm+HfPcVJf94dRJQxWjvgrXLU++ObBe0pXZh61O1UWPyrP1hNMMIO/YAoZctNICm
         BaYa8EwrmEcgOfwKjeQfA0f5kpDbrrc2UBdCXh9gOriET8JG0vI1r8NaLW1XMwj9avoZ
         GbccYDupwvCNBxp1b5o5dJ6kBw3Q9g+ge90OP9ED2LsP4rJFJ/HnmOsuYUMBGrHA3mnc
         3C/A==
X-Gm-Message-State: ACgBeo2LBVqE7EH4YpWRbdMsHVBWvt+a7II0emq511aqiAF/1hv5ebc2
        0C0rqcTtSs8CAUq/ni5m+bzUe56s4QFZifhf9Fw=
X-Google-Smtp-Source: AA6agR6S2BdSS0fHsb7l7BZlYylnmSbu9Xun5Or3nwd6QwQjUAqXgU4oSKM3GE1i9/4CmD10b1WKlw==
X-Received: by 2002:a63:f91f:0:b0:434:aa68:977d with SMTP id h31-20020a63f91f000000b00434aa68977dmr8282442pgi.333.1662656774325;
        Thu, 08 Sep 2022 10:06:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090a300b00b002005c3d4d4fsm1992051pjb.19.2022.09.08.10.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 10:06:13 -0700 (PDT)
Message-ID: <631a2105.170a0220.6a01c.34f1@mx.google.com>
Date:   Thu, 08 Sep 2022 10:06:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.67
Subject: stable/linux-5.15.y baseline: 202 runs, 1 regressions (v5.15.67)
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

stable/linux-5.15.y baseline: 202 runs, 1 regressions (v5.15.67)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.67/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e1ad7a011591d4a508a08e180ae0471224fcc17c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6319eb47e9a7110d0a355663

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.67/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.67/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6319eb47e9a7110d0a355689
        failing since 183 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-09-08T13:16:32.000084  <8>[   32.512578] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-09-08T13:16:33.024820  /lava-7213154/1/../bin/lava-test-case   =

 =20

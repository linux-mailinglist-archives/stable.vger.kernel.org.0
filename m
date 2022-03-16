Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0254DBAC0
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 23:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiCPWvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 18:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiCPWvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 18:51:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669EE2648
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 15:49:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d10-20020a17090a7bca00b001c5ed9a196bso4544631pjl.1
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XGGt4xSUiQphLyaoryQQoeYL81O+XM84EtXYsS4cPtg=;
        b=YRXXD2n7RZTc16M9tRx1K0HQWUwlj4CJIlOOyOCl5J3ete1vliQzGQcHKiQIWyTDrr
         xzEKctUzB+LL2pIS2OMcTWlJmR2RzO6+mzgfEXqlnb1d4ABBG/Y9LFvemZsSy6NjOTCZ
         X27MLKa1ZeTKUef5p5iiwm/gAyvHXItIbeN5IyPc8IhqwnYP82yP90F90ulU1veVzacX
         sBqusTWTbvYKrfXxJCPReJOp8eVs6xNxIY2X4OIhmOYG7RHiOLtw7EKjzod+4H2u+FfE
         UCvNlOCkD64jOrb2vNbgPVOIDkPeGH0Gi8lSxJW+yd13t5cznZfuq+Ge/3PVUAuiSRjr
         9XEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XGGt4xSUiQphLyaoryQQoeYL81O+XM84EtXYsS4cPtg=;
        b=iuE/CjsAGXQsde07jDrZkvDn+bWigh57vXxvuE6M59tQ3fNUSns0E9KzI74Zbs5D9Z
         3HAYFn873irLf9ALlZIH00ubxbjgh5vajI5ns9PljYYCZTBLRkg5LvpZgrgqBCbNOq6A
         pWBEzj7gixV/50uMywQAulV1ZmEhOZ/MuWapezcqfwH+Msv7tPL97ZGI/fNBy5brK1pZ
         oQ3R2cUOB02UxIVNBEvqpTGoL+mob3/0a/SmuvdE4ZZ6ULgROmwckNWNJ1Nvu/udhCcp
         PU5SOGT2jXMlQPsKl/Ye2ze3Z220GZ2fo53isvo/GnzWYoeS4/y04GVCeTLpLsD7GReA
         0dKQ==
X-Gm-Message-State: AOAM530KbWXlsyEbxN7t+5Yg1vX2Gt9zclXIEcE/jXzTaCdPxvbMPQPw
        ZHqJvhFJLm+SU52gil2baNiyllhy8T2ufw8OdsY=
X-Google-Smtp-Source: ABdhPJwjAA0E+B+45TiiracDBmtYBsOGfPvJkj1g2euuDwFRHRKHG0vNWBvixBw5q3xe4DOjHf17AQ==
X-Received: by 2002:a17:902:7248:b0:151:f36d:9c3 with SMTP id c8-20020a170902724800b00151f36d09c3mr2129298pll.69.1647470993726;
        Wed, 16 Mar 2022 15:49:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f771b48736sm4489678pfj.194.2022.03.16.15.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 15:49:53 -0700 (PDT)
Message-ID: <62326991.1c69fb81.4fdbe.b329@mx.google.com>
Date:   Wed, 16 Mar 2022 15:49:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.29
Subject: stable/linux-5.15.y baseline: 57 runs, 1 regressions (v5.15.29)
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

stable/linux-5.15.y baseline: 57 runs, 1 regressions (v5.15.29)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.29/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b9a0208cb3e3e37def2abe4d602f084e0f746419 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62323539dafd10ff05c629da

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.29/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.29/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62323539dafd10ff05c62a00
        failing since 7 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-03-16T19:06:16.526273  <8>[   59.842599] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T19:06:17.547731  /lava-5892734/1/../bin/lava-test-case   =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFC3286627
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 19:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgJGRpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 13:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgJGRpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 13:45:17 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14377C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 10:45:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x22so1706908pfo.12
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 10:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JrmjKzZVjTJZjT0KMb4NDPf5oEbN7zqL2jSvK8plEyI=;
        b=wFutRO63s1Suj9/o8v+G8s6U6URC0jdCXFZRQz+PNBu73gclH4bCi5uWn2//0Zn8R9
         k4hg5jij4YMFvsNGsLCU6GgJkeKhpLYaFn+seJqABzUQ1sj0GCOzl4U8n7XTEreJUWrf
         TDz0seYpbp0eho+9EsWBmQ2EGwNsq3r0GjlMg758N35U3hUSpOXt1/ZvACyNfjDtagtl
         PUwuL53fhd1+V0x/G39l2CxVM9/aLAwNKlnq/x3s2Jsj0zPG2v4yVtCkgp53mBXt9Q2i
         sjnE+CRusT4gmqL6U6UQRP9chW55b3uzPZHgX0I1+eDnEl8GqtjIwc8JXQMz1JJXXQEy
         BrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JrmjKzZVjTJZjT0KMb4NDPf5oEbN7zqL2jSvK8plEyI=;
        b=NlRfRGGphW95fMIT+O5NzFrTssWD53IPQcDugpLD4H5H1iAn1N/qqcwfM89sW2vhZn
         dq1cUlly3Tlz0c9ZdNFS7Ykg7CgcFY2YCztj23Kc6mj/iYL1a8jEABRI0BkKNBSH+ugx
         tR/MYJauvA4E38VvceanexME9pHDbCButqrph06LL9zpEMCN33yGjkUAC1JYA8e83VfU
         fl1I9OMYFBwm6kAIZTudctIcKlXEbxKHMmNYSTIxwDrWpm92oUm+hOfOamMHxUt+W3U8
         9xOJjNFGVa3lsC2OaPLEX+pnON3a9BxzbZB0hEbzoTZRTFXGU8qQjMEGS0YNFJeb4b8j
         ZeUA==
X-Gm-Message-State: AOAM5302lnB91PIbwlV4j8tD81PHHB+o3VO2lXDLge8nYJtGPVer/IgW
        E+3/7C2pnMFLkfAe1CpoNbfsyYK9U3RGcA==
X-Google-Smtp-Source: ABdhPJwXdv4LeMgENm9oCcRbrxUOtvd/l2Ld4PS5snrATRBHZiLuXHDdArPA5tj3apEAqLCjW91oVA==
X-Received: by 2002:a62:b616:0:b029:150:f692:412d with SMTP id j22-20020a62b6160000b0290150f692412dmr3881915pff.8.1602092716236;
        Wed, 07 Oct 2020 10:45:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y137sm4095464pfc.77.2020.10.07.10.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 10:45:15 -0700 (PDT)
Message-ID: <5f7dfeab.1c69fb81.14c0.76f7@mx.google.com>
Date:   Wed, 07 Oct 2020 10:45:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-62-gc2842380f027
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 144 runs,
 3 regressions (v5.4.69-62-gc2842380f027)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 144 runs, 3 regressions (v5.4.69-62-gc2842380=
f027)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-62-gc2842380f027/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-62-gc2842380f027
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2842380f0274fca05d34cdb8f4031b1b383fc1e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7dbcc9982521bc6a4ff40d

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-62=
-gc2842380f027/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-62=
-gc2842380f027/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7dbcc9982521bc6a4ff421
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 13:04:00.377000  <8>[   20.655453] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7dbcc9982521bc6a4ff422
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 13:04:01.398000  <8>[   21.676620] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7dbcc9982521bc6a4ff423
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)  =20

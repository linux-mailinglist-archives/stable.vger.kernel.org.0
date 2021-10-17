Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6DC430B96
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 20:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhJQSxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 14:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhJQSxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 14:53:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C012C06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 11:50:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m26so13006787pff.3
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 11:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H4FTlA/C2XdezqapFrZ3RLSlL76SSVMJh30gCcObqD8=;
        b=UWuoP8Wyl6UlUb5cqG4O4wzymwtYb3csdKlJg5yuZtry9SRdBfZIRlrFs/1mskCJYk
         K77qJHqfyra1u6QxifyeNbhkwXl2kdbtVI8ZxjhUTIuHDllwkHxbtm1XE+arUrfjd/C5
         9bgVRX324xvo7dL//vjcLa8Zezzwg5qvVt3p7CtJVQPkvbuyRHMe7mHrKX0SNIWppL/v
         aZVqWoRPi4LL52MzQ/VuuPIk4nWMsml02UruzJBQZyOcQKO5u/rjGCl+VbUYTQIQSKgb
         GSt5ii1tZ/l6qu3rxMw8ls2OweH++cShBlzBJV1zBnHbc4rD7E+9XkAsHhMYj7TIpIcT
         iuig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H4FTlA/C2XdezqapFrZ3RLSlL76SSVMJh30gCcObqD8=;
        b=cVGrmhNPDwe+GClcwwPNh7lej7IpXAC2SmExW8GLWAL7HZMb3N4dWMBS++lBu9ncgy
         fRwH6cDk8P0nMGYfV3p3yttU+2WJ3BlL21goO6j818MwWzHSsNAQVLDDt0/UwWah3lA/
         y9KFKTixuFMP+CvwoFatgTToGPkT4TCRraM2FoszWEisJ0rHWL0GSZFuevo6Fj3WQVdy
         j7ouE2MXDE101yn6vqrx/oUZreQ5Bx1k+0ngtbC2207dyQFIVLLmKSkHmOod7vuzyf7h
         kBJ3L1nvE8M4j02Srk10/IX37RM0OuzvFhirnpSsNcgvd90Sj5JhLoiWoJVnxYH5Iblb
         9SDw==
X-Gm-Message-State: AOAM533RXYrAUP3e/M+cTJtq97oDlfHjv6NjZPbD2RfFEhyuVv3KEq1c
        0Yq3u4b2/hmAuLW3gFu+3qu1hv6YW26R3Y6O
X-Google-Smtp-Source: ABdhPJzoAQ45YtB9tVS27ZbaIojBV0L1iMP/papZAEbhi+PQL2rLVL+6cII6I4HraWEYIPMATl/zkA==
X-Received: by 2002:a05:6a00:1407:b0:44c:d2cc:916e with SMTP id l7-20020a056a00140700b0044cd2cc916emr24418675pfu.64.1634496655862;
        Sun, 17 Oct 2021 11:50:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20sm10517568pjp.48.2021.10.17.11.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 11:50:55 -0700 (PDT)
Message-ID: <616c708f.1c69fb81.c559d.df55@mx.google.com>
Date:   Sun, 17 Oct 2021 11:50:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.74
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 125 runs, 2 regressions (v5.10.74)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 125 runs, 2 regressions (v5.10.74)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig          | regressions
-----------+-------+---------+----------+--------------------+------------
imx7d-sdb  | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =

imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.74/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.74
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      77434fe5a077f05f0851931d6a71d1098b6004f8 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig          | regressions
-----------+-------+---------+----------+--------------------+------------
imx7d-sdb  | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3541b1bb3a3c923358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.74/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.74/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3541b1bb3a3c92335=
8dd
        failing since 3 days (last pass: v5.10.72, first fail: v5.10.73) =

 =



platform   | arch  | lab     | compiler | defconfig          | regressions
-----------+-------+---------+----------+--------------------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3d890211374b563358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.74/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.74/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3d890211374b56335=
8fe
        new failure (last pass: v5.10.72) =

 =20

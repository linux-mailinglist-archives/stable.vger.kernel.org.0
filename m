Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEAB31C41F
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 23:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhBOWqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 17:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBOWqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 17:46:50 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF15C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 14:46:10 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o7so5062978pgl.1
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 14:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t4Kppii1F6JGWEp0AXXo5gxZUQOJ6G9kMLzcNZ1BR+U=;
        b=yrGL3OXT0rHeTayAnb1lIwNNLXDmSkqQUxwHmXKmpaFV+GXQjl5ZLjZD1LsKEVBuah
         bcyeY83H+jVI0XOijgiK+96oRUN+sY7XRapv8D5VE5c9E2JEeJfKgN9ILRTf7y3hM1VN
         xM8JMsj7ndI6jKtfcp+0LvKc+FI8X3KP+pSBQTHO26a11rflrnhQBZ00Va5xsfCuHwH2
         vXwYfoxhinoYJ1MG1aNpaXe88W7qeyGpJfzudpxT7RA6v2r5PuB6HD5SQYl5YHL3v2Il
         YRmPZatkUWi3jTTN4/NtXpNyjbO+jSgi+8obTtlwjSzJ02NiBKSSyISnNNhx5n5fjpy6
         GXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t4Kppii1F6JGWEp0AXXo5gxZUQOJ6G9kMLzcNZ1BR+U=;
        b=b5V2W1cbB0duE0aXPlsa0TbX23DAf37d30ssNBXU0wax2JPgym6aDmwHPkTrfKxhPY
         nHsGgn0MEKNCetYeZoO0TEY47itstj+qfe7zSWvjsn8OHP3Bf6FJF6xwTL4oRWk14syt
         JHVp/FV/rbnF+JeecYcHwVncndyGlBKeAl0Iu0mpmQuKN3mnVt6/O8No6eKqc/27hMuN
         CRjr9ldkobQfaawlu5prv4cZr0r/IU2Alzzj+dYFYSUf4PqEjf51MVglp1x6T+DFep42
         w/a4mQyrQiqNuru5o2ZtiGYwI1Gxq9JIJR7T8j6wRhK34WwY9YJlrqsYkSNTEUmLLMjg
         dk2g==
X-Gm-Message-State: AOAM53071gW8AlFGeV9z9CmVFbKsrpcDddQplSe8bqAb0EDvUpYaS6ru
        jEEsTwB2zko+I+pxqFC2PLq3md9MGu22Tg==
X-Google-Smtp-Source: ABdhPJx8ORYdRcILoUXozLZO9l6lRXLPHAMwbmjiHWshHbaXJFDHVms1Kgr66Z/DSsWWdSrpQiLFGg==
X-Received: by 2002:a63:a401:: with SMTP id c1mr16635045pgf.60.1613429169605;
        Mon, 15 Feb 2021 14:46:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1sm3425671pgi.78.2021.02.15.14.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 14:46:09 -0800 (PST)
Message-ID: <602af9b1.1c69fb81.e309c.69ce@mx.google.com>
Date:   Mon, 15 Feb 2021 14:46:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.16-105-g643709657afaa
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 96 runs,
 1 regressions (v5.10.16-105-g643709657afaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 96 runs, 1 regressions (v5.10.16-105-g6437=
09657afaa)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.16-105-g643709657afaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.16-105-g643709657afaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      643709657afaaebc02f8fc7cd4e96bebe6ad0ccb =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/602ac72a114657dc2faddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
6-105-g643709657afaa/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
6-105-g643709657afaa/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602ac72a114657dc2fadd=
cbf
        new failure (last pass: v5.10.16-17-g91ae446e84dab) =

 =20

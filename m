Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAED4386527
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhEQUGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhEQUGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 16:06:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BCDC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:05:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b21so3815759plz.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RH8yhhFTbaewgQ7LQqXlJaNkJ/jxX9PkNTcs/7hqgVc=;
        b=xjKsozvKlZHqULX1bFe+2O/QhTTREmh9ZBl0xwG+n7cyQjogvMvM7TyQvZA8TEFF8c
         MD7d+l/44hOZzHQdJdpjIjBVLknAv+BZRO7tfTy+rM2+qc9vCDdNKXCTMjX15auDBC+1
         N7Dskm46//LlJn5vEj0X8jZ/Wh5AfjNXF9kH1TFufeH88fhClp9DO91j0pozpdFsF9wX
         Nkjss+36isKYs3Dbt57EfwYWcgIdY0u4ckvG6LV+0SOdBIJqYIWw3F9qop3xTeMFmDg3
         hXYBhg/n6kQjSWnpI7Uz5sIFA2kx9kndmT5L4sR846OH8d6rViZpZhsKLc/iDZO/phXV
         KlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RH8yhhFTbaewgQ7LQqXlJaNkJ/jxX9PkNTcs/7hqgVc=;
        b=M1Ybd98NBETetweFRp+KCCtCufQ67AqHJD3J5JLAeq9Jt8pbYYYxXgvBjXRcEb/c9V
         Yfxcmy+VCfuxUTzT6kTv0kJNuysASxQd6w2Z6/Y7LJc0l0V1CLfuS0vrIKxKTbIDk99Z
         NivvY37Wr+clZB4s8Ew70JR5sHlcF8+RaFMlcSlX+v+BwHVXp0IyIAzBhHONNDdGN2ga
         OlEkd+h3eWqAJkl2/WvWTMSRo69w3XAdVkoMJA2x4kuFZ3LR+MSGAC3SaXQ+bAmQ1KkL
         VzMTfdHgSgHbwSoxugLlx7tSS17FLmnFFZlEiLuuUo0li8/vtNxXEliKUM8yRN1dKmO8
         11NQ==
X-Gm-Message-State: AOAM531lomq+U7Nym3g4d6/vRIAFdGbwGTiqrWtCQ0q/mNYip/iE48VG
        c+fBEIHufF59z1zjkRYWboJuqZuA/FWSNupK
X-Google-Smtp-Source: ABdhPJyCseZ4X1ze/JNzuRhFFhwCgQcwNYHNFkuqAIJnHWqlLNYxxHKsXNcI3AfC996fW9oIVyrNEA==
X-Received: by 2002:a17:90a:fa5:: with SMTP id 34mr816648pjz.113.1621281933648;
        Mon, 17 May 2021 13:05:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p54sm5651049pfw.210.2021.05.17.13.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 13:05:33 -0700 (PDT)
Message-ID: <60a2cc8d.1c69fb81.cc484.2132@mx.google.com>
Date:   Mon, 17 May 2021 13:05:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-223-g1e57fbc60e7d
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 3 regressions (v4.9.268-223-g1e57fbc60e7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 3 regressions (v4.9.268-223-g1e57fbc=
60e7d)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-223-g1e57fbc60e7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-223-g1e57fbc60e7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e57fbc60e7d3dc940154a48b66cae3226867109 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a29874ad55ba69c0b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-g1e57fbc60e7d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-g1e57fbc60e7d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a29874ad55ba69c0b3a=
f9c
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a29878ad55ba69c0b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-g1e57fbc60e7d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-g1e57fbc60e7d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a29878ad55ba69c0b3a=
fa1
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a298810e7f152943b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-g1e57fbc60e7d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-g1e57fbc60e7d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a298810e7f152943b3a=
f99
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20

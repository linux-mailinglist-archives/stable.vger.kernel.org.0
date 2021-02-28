Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337CA3273F9
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 20:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhB1TIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 14:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbhB1TIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 14:08:04 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9AC06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 11:07:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o6so10190812pjf.5
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 11:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NlKWRxQlfK+bxJuOJJ5IovajWI9uRolbUKzXOsSLrbI=;
        b=V4h+IEqTSzy5oaQrkAEoaR80r2hsGJCPtDeVFTUR+pChxXNDWx6/PkpbBfKgCMSfEr
         7P4o7N1LPTMId+o28WPrWIJ80po2VZeUIGEiBdmWMR+ro6etX90ZexMelenO8UGv7oZ0
         ec+4n7EzhS1429O/jYt7Yfe2SgNt5U72VM7EUzHdVX/FQK43xiD9qwpV+YuaKOyKMUfU
         NpqUJQCYkwL99kaJRD6tyXOnasToOVa/iM6+nEE1EGZ7L50kKkeA/rfizVLcVZ/+y+fv
         AWiSmVATMWnz73koZnhgF29O5r8TtkMT+N8/ENHTQluVfoQMB2D/amXIi1o1Aq1hsfg1
         q6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NlKWRxQlfK+bxJuOJJ5IovajWI9uRolbUKzXOsSLrbI=;
        b=VB74DuBbBCTexrouYGqLsSh5qL7+gYETDp/k6hqrfGLT84TlvWKRIzIEdi9lWz/lmj
         0ITsS85NYCaeNaU3cUyvWs+nyOtxuPq11GIwfSlnXdMPVab7BWjmVjLXNUVcXiCZpEm1
         1Wmfn4OHwsjxuS49yqN8mOtIXHTtOJTNEn8Zg4DmJflqJmWKYa/nNkdRUgcZJhOGcuDW
         gohn+RrEIrE5AufFlQKWyZl4TlqEZuQUCDspdQ8vUt1f2zgRlULmC1jgR/kB3QhI07qi
         QclrV7bOdeeOOjcgZv/UY5y5nyITwAKR5tIg+6RaiOPw4X6GC+IKJQT39bI9EUUqCzeQ
         0Ogg==
X-Gm-Message-State: AOAM532Mp0bHQX8KhL8KDjQHX51y9f6kf4nMdzLtcYEYdKUCq4j2YF8z
        r9LoDbrLeCTyrrMV5SiEkbi2v8HJy8RzPg==
X-Google-Smtp-Source: ABdhPJxA/NfL1ESsl/ZPzpv5/6ltKzzDo5Tc86+TDU9ovhwXR4GOnke5ekPHOtSATrTiB8RjcUn5pw==
X-Received: by 2002:a17:902:a40b:b029:e0:1096:7fb with SMTP id p11-20020a170902a40bb02900e0109607fbmr12118425plq.40.1614539242937;
        Sun, 28 Feb 2021 11:07:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 192sm12426444pfx.193.2021.02.28.11.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 11:07:22 -0800 (PST)
Message-ID: <603be9ea.1c69fb81.8709c.da2e@mx.google.com>
Date:   Sun, 28 Feb 2021 11:07:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-12-g45e721ab1b650
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 97 runs,
 2 regressions (v5.4.101-12-g45e721ab1b650)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 97 runs, 2 regressions (v5.4.101-12-g45e721ab=
1b650)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-12-g45e721ab1b650/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-12-g45e721ab1b650
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45e721ab1b6508bb5209f53d101d8ac5da128076 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/603bb53fa08ce48d10addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-1=
2-g45e721ab1b650/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-1=
2-g45e721ab1b650/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bb53fa08ce48d10add=
cd4
        failing since 100 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/603bb6ecfe9e4752d7addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-1=
2-g45e721ab1b650/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-1=
2-g45e721ab1b650/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bb6ecfe9e4752d7add=
cd0
        new failure (last pass: v5.4.101-2-g74001afa8f115) =

 =20

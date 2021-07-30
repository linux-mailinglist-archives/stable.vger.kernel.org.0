Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3543DB089
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 03:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhG3BMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 21:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhG3BMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 21:12:23 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F85C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:12:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t21so9026476plr.13
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4V3F0lzjgCCqJbetkGS5Z/P6GtaLEZ+XkHhttn6GC/8=;
        b=M9lcOeL6gf+aua2WVqRDQblFixurZtwVGxv8IAwfYJol/Wz5Z/OFwY3RJxqCvN6UOH
         NzVoYEA5wg9VeK7n+ukgBCrjw4LGpV5pP3eY+6+SnIeWRpQhwrYx8jEWlNyYw8FSCD4l
         VBv5Kgm+52uvEm9+wpaiU25L7SjHR+XAS4+3FsK+7N+li7ZZyXvWCDGKg60aRlLKZ5KA
         kQBRlUybd0eBZTXTq7fDnaGSblO6aCDzRYUJU4F0ZpByzpZH8uWhy2EFKW/Iog+qgnyc
         ZqeEKQ/a6+E8dCbslTgN3aBRtoqxmhBD3AN6hX7I3roZsDyxgQezEWEk2Lrrk67Y8JMb
         bLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4V3F0lzjgCCqJbetkGS5Z/P6GtaLEZ+XkHhttn6GC/8=;
        b=G4MGsjWVgWnc2wskYZo8iAP3pEHJTsRwVj0pUZEzx/b9LNPEliTmcecCAg6C2kez1n
         rQRXCF5yr8eNwM1hkl8gnwdFdjp50AJsf9H4qbLP2SJzIfimOLddo6iixjzA6Hn8J5iw
         0YYftEqdbonGihI5xZKS1E8/qI8z7rIBtM52tVf8InfraEbaZfqmPOQ930b55xuEWgTc
         o709VufnWKBuXZzaL6ZX3ZxlYJDAFbGnXhoEC1aJUUd3TasyKNvQNbigvsYrdyiopHEh
         yp8qJT6kTt6GUxye2xj1JPXVChzCihPi1u+HW+UN4jBvJ42S4aODGH7kmyrROFdqu55v
         eEvQ==
X-Gm-Message-State: AOAM531+nlacC8DsNJuHA3xkwYMtAqFQy0GVwX2o1p23w6iQ1IZK4mIy
        YY9EqfUx170Sw8MjjddHKtDq7VqP6Nk5oIPy
X-Google-Smtp-Source: ABdhPJzm5ndanqdb1EIIdof+1Y0u2Cp/dsoCDlJnnN7Orr35FUCYKwl+GBu8Wc2gdsN2U0ITB16Csg==
X-Received: by 2002:a63:114d:: with SMTP id 13mr6319724pgr.180.1627607539147;
        Thu, 29 Jul 2021 18:12:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d22sm44031pfq.177.2021.07.29.18.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 18:12:18 -0700 (PDT)
Message-ID: <610351f2.1c69fb81.7e704.034c@mx.google.com>
Date:   Thu, 29 Jul 2021 18:12:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.54-25-gdfa33f1e9f64
Subject: stable-rc/linux-5.10.y baseline: 147 runs,
 3 regressions (v5.10.54-25-gdfa33f1e9f64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 147 runs, 3 regressions (v5.10.54-25-gdfa3=
3f1e9f64)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

r8a77950-salvator-x     | arm64 | lab-baylibre  | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.54-25-gdfa33f1e9f64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.54-25-gdfa33f1e9f64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dfa33f1e9f64f87f2483e3dd6ff84244281527db =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61031c1e846b370c595018d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4-25-gdfa33f1e9f64/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4-25-gdfa33f1e9f64/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031c1e846b370c59501=
8d9
        failing since 28 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
r8a77950-salvator-x     | arm64 | lab-baylibre  | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61031c15846b370c595018d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4-25-gdfa33f1e9f64/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4-25-gdfa33f1e9f64/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031c15846b370c59501=
8d5
        new failure (last pass: v5.10.54) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61031b82bdcc50be1c5018d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4-25-gdfa33f1e9f64/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4-25-gdfa33f1e9f64/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031b82bdcc50be1c501=
8d3
        failing since 1 day (last pass: v5.10.53-169-gf52d2bc365d2, first f=
ail: v5.10.54) =

 =20

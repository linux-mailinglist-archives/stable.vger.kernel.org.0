Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB0C23D5E1
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 05:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgHFDy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 23:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgHFDy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 23:54:27 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6FBC061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 20:54:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ep8so5797042pjb.3
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 20:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0LL9hsJCzKHQFAnTZOu5uKH1XE01cK4WEkMbufyGzrI=;
        b=hncrOYuPU8ZN5dhrdBgp+JKdXbwLqyDr5QiMU1NlFLG13hhTURbXyRmFtwH0iuviIH
         kJ65DeYBBfknxSPpjpStLFNCWE2YMPXvs/oZFmzKILBNXtFmt/XRcjvYEx4zjtJHJyYV
         gVeB4lzerJPJ61soaC1WGjSKZxpJK3GTMVaUubHOuhRA8p/lCX1tou+R3v2m2f+DPwnX
         UAJH6/MT1EqOoYYSKnxyMI+/WDv6Aoa6lHA1jM916FjlncK0whO2g/1l02cS3T0kfj8C
         onTIMSwdMcKUUwfH8jGad0p9yH7+/UGYpfQMXjv6Cc0VT+73Z6gQBEFbSNIE096pY6OK
         GIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0LL9hsJCzKHQFAnTZOu5uKH1XE01cK4WEkMbufyGzrI=;
        b=saLXUtkDN6HPV/nejXMe7K9J4D0aViInbzTXkK75Q2ObwmhecD+6MKdvdcBVCk2+pc
         JAGqE56082OQLEWmCG1wjDs4H3s01p+kqfOAvIBq39XBfUQygluMtHpzUJQu1QKmKquS
         ZAHZ0obSzAKclystXWhOhLwgo/SYH+qW+3aOPdeJqNwRSV5W+hg35sKybW4CeFJ6QMbq
         90tIOzOowi5Ict7jMWKSUHaSAUoAKKimYdMqFzm04svlh7NHJdgMly8b/CZVCFMn6WyZ
         2PMh0/I3IwhVwPR0u6pBKJ3Xl1XHkwfWr6sbi2YEmZMAsAp/lO1YvspLYrI+Zd1JHbAq
         nvEQ==
X-Gm-Message-State: AOAM5322DEv42tpD5Ndoy/FOLdWmAeJaoo0mYMtQHJUqDh92bgAUHkJI
        NghagR1tMJKBgwhtqDYrgy97PltDecA=
X-Google-Smtp-Source: ABdhPJw7GETCmVDx1ioKaJOpUfm+R2uUW0AN21+f52ri0BO+UdiqGZaNGrGHB32EORNH3O4Mq0CzHQ==
X-Received: by 2002:a17:902:ab96:: with SMTP id f22mr6058361plr.155.1596686064573;
        Wed, 05 Aug 2020 20:54:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cv3sm4940792pjb.45.2020.08.05.20.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 20:54:23 -0700 (PDT)
Message-ID: <5f2b7eef.1c69fb81.f32c1.d2ae@mx.google.com>
Date:   Wed, 05 Aug 2020 20:54:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.191-57-ge8ffd3efac22
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 135 runs,
 2 regressions (v4.14.191-57-ge8ffd3efac22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 135 runs, 2 regressions (v4.14.191-57-ge8f=
fd3efac22)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.191-57-ge8ffd3efac22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.191-57-ge8ffd3efac22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8ffd3efac224a0f72ae9ddffc0522f6b2e169ba =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2b4c84c5a2e303e952c1bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-57-ge8ffd3efac22/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-57-ge8ffd3efac22/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2b4c84c5a2e303e952c=
1bc
      failing since 12 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2b4acaa4d8233d6b52c1ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-57-ge8ffd3efac22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-57-ge8ffd3efac22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2b4acaa4d8233d6b52c=
1af
      failing since 127 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20

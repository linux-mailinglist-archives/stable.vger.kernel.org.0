Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF24276644
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 04:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgIXCPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 22:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgIXCPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 22:15:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966C5C0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 19:15:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t7so805717pjd.3
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 19:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gwFCCG5aXY9Xajxg9HhiSjufiYEjjlaEsaWwl5A/D2o=;
        b=pjd2maVB+1j70o+ZxcnZkStN3XoPYd9VDPgzYZ6wLKxXzAAeFfCe0joed5KEkgX+vt
         nymFXcwbRqt8aZ9ET/0dn0A3l/ZGqKOqsYtvcDKW1rz3C7cI/fsM0h17vknYTeS+4ZWb
         pJh+uoM/d6TeLS0H9hsWNQo/VTTxaQnCKHSciUrMs2BuEym2xt451+TDw/lRVNWnDDtN
         OBWqg8wibc+DWQFrEjbjArB9sKwQTZh/gveddVMnGgZ7bIgBgFahwy+VTlnrvjXIkGR+
         p3J89VWiIa2xYII3lK+PvMFbYdceGiVYczIo6hqPnhWdlScwyE0jgpS50dpaB+KlD+/a
         ghdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gwFCCG5aXY9Xajxg9HhiSjufiYEjjlaEsaWwl5A/D2o=;
        b=qNz8oVbIFpw2o+Oi6YaSrnX3/+q5pU7EV3Z8GneM3spVKyhMxHyV6dC/tphkJ+ZyIw
         y/xNBBugLloiROP2WV0A1FGmjkSmZXbb6QKQ5CtBgMEJSqS5crdbvknK7jWM6EDnpElx
         T3VDO6VDGfHLPpO/F/mpqZu3GD/lSgAXfN/RiukBzvL0D+6sQ9EfLA2zA8MROobgmHAl
         qfQV/QMieT3d3rvte9mEuI5+hlVJQrFvb6DjY/0wLGfi9wvtWXGDUDKhWiYxgxfN6IJQ
         aM0EBbTw2Y+0I8dG6GkwIVEGgmT+eeuzPLQAtamk11atBGAp6Czrjx32FlOFEDjD5qlX
         LfjQ==
X-Gm-Message-State: AOAM533NhsuLL88e7tFFhbBzLdARKSMv5ga5LAfX2cjbBN8piNQ11Ocu
        44k87ajlJjrr0qn0IhZdZWQU/sSp+DKGtA==
X-Google-Smtp-Source: ABdhPJyce4wuIJV/z/AYZWw6v4uB9DwjK9Sslymi5k5QrKEVK658D587f7KNU7XgI4AO+I5Gh3iqeA==
X-Received: by 2002:a17:90a:d496:: with SMTP id s22mr1843582pju.167.1600913699783;
        Wed, 23 Sep 2020 19:14:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j19sm883395pfe.108.2020.09.23.19.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 19:14:58 -0700 (PDT)
Message-ID: <5f6c0122.1c69fb81.97c31.3a91@mx.google.com>
Date:   Wed, 23 Sep 2020 19:14:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.199
Subject: stable-rc/linux-4.14.y baseline: 160 runs, 2 regressions (v4.14.199)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 160 runs, 2 regressions (v4.14.199)

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
nel/v4.14.199/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.199
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca87c82811906f4fc5e936705564ba8176ba497f =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6bc7417d299dc026bf9dba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6bc7417d299dc026bf9=
dbb
      failing since 61 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6bc5e368879e7654bf9dc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6bc5e368879e7654bf9=
dc5
      failing since 176 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20

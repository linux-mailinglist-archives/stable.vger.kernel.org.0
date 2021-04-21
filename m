Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245A736733F
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 21:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhDUTPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 15:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239729AbhDUTPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 15:15:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB96C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 12:15:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p67so24847198pfp.10
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 12:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SM7im1h9LAe4LkO6qh9K8dnHYa207V3bzv0cstYIj4c=;
        b=WggWGO7f2aeRD2SDFcJ9nb5GDMoES1pE42NvOzBsyFllaIMndHdk17a7Rn1AsR7VXy
         CoegzJt3oHT5W0suUbsZwFGOBboeDemjNTwGwcQeQTDkbJ7V2siv8lAMaiUQcYb21EA0
         92urljWlMNjd0AE9HWHNMrOcjwO2+In+TwjQlxGBSQGuAwf2wb31aNYDZgzAqM5QjEOi
         nBXXC4Mf6Jp8506HUHqeVJaLqYGtV+eawp90Y1X+e3b415nCiw8IcUGRmbCXTNZ557WW
         u5xxoCarJwssgbC/+yAGmufX6B4FuOoXUM+XP3ohK9SaQyUx14eIEuNklvWM7yEBObDy
         Uc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SM7im1h9LAe4LkO6qh9K8dnHYa207V3bzv0cstYIj4c=;
        b=oI9oUDjmCqcv8oLBoUfUNM6uiaYoD09GkTJ4s6R8udeK1XZNECuodSNs/PF3pcuLMb
         kKrKphC5aaLe7I+uTJ0mrcn8gN5GjsJHLsGVuEaJsUtkK4p4EO58V9MX0lQL8sMyjKIj
         5lXY8PETpT8uSQ/3PnN2B+QQGwOzzpXH1M5T0KO6Q/VoD92HKL/S/LXIh3LXA5V0I3ch
         aQWymx15RCyIHwUJO4ynWIia2XLWlFxpf3dpmnLxfeQW7u9dr7Y3ZudXHnKnpXc9G5P/
         Y8ktN77uiCTyf16Se6GCyBcCKU0cCVVWE3lo/JLultrTlLregUsVr4lhgweBlv5CQQc9
         kgpQ==
X-Gm-Message-State: AOAM533UNOTlJ0LxyM6l2gDdq0BSnaRQku0GA4iNbd+PDuQihnuTqGTR
        XjOHe4K1Wn0didy+73RBY9SrtayRvMhVEdDhUhk=
X-Google-Smtp-Source: ABdhPJxDhe0NyHGYNY3sIQth7HXWgG/DXeNRs0UnNxf9m1CXSO2ogrZqWPEXYtjYDrxkp97TlfdB9A==
X-Received: by 2002:a17:90a:c3:: with SMTP id v3mr13407109pjd.55.1619032508503;
        Wed, 21 Apr 2021 12:15:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n25sm85965pff.154.2021.04.21.12.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 12:15:08 -0700 (PDT)
Message-ID: <608079bc.1c69fb81.91e28.074d@mx.google.com>
Date:   Wed, 21 Apr 2021 12:15:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 127 runs, 1 regressions (v5.10.32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 127 runs, 1 regressions (v5.10.32)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aea70bd5a45591de27aac367af94d184892c06ab =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60807004558006bf979b77b9

  Results:     2 PASS, 3 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60807004558006bf979b7=
7ba
        new failure (last pass: v5.10.31-104-gbcedd92af6e5) =

 =20

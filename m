Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA0B24EF57
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 21:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgHWTG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 15:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgHWTG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 15:06:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516C9C061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 12:06:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s14so3167803plp.4
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 12:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hq50LGK0YMlpG+wNloF+s3qJtho2zyFuI38Y9rEV0ao=;
        b=SOd1CxOYWBHGSiO1ltmp9xxiBIGonDjN1I3gFyiiAIqNywzn7RKY07rNVgmydyfohu
         FPUEZexgzVcfqcTYkTiIhu8lOK0N1Wgmgy4TQFOF91ztGXbe5FQ7KpVLHutlQxcQzy8V
         DRKbTgbSFQlKrjmBTwa3OTam7qJfLxPfUj8s8UZEJ6J4iz44Dmayh744s1gA3XAo0LbT
         iNgLSRtck17XTU+9w5emHeUPMRoFK3OfjX3SA9X8HpaWyU2aBdcNonmz1cLwGoNWS4u+
         r3CpzQnJjAlDWywZcWXMmK1/y5nXakN7RdiLHoQC+Ro59jmjvk7xCOO+epE0o4Dw85SS
         f+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hq50LGK0YMlpG+wNloF+s3qJtho2zyFuI38Y9rEV0ao=;
        b=eDPT/VpaUfWKyytl6sjtlepafsC+URt6KPek/BB1u9bNCRrXglSjtJenBs59GxTurU
         TerD5QSBfhTLunsAnZg+fugQj1Mhvtb5t2QZca1UQtOMeuNqdrjuyggA272L85hF4DZH
         HxoZR6TPyabZrvidOpzZOSJ1J3k3gLKT0RH56WEyfWghZTLyQeIjW7VRmrfUQbPUYiZI
         wAZUnWmqM3hnh+pG4Wy46cMT0wP4Pv9gbjd4jthflK0dVjN2K3+9rVCcC3/y0T0ECV9q
         iP1+Hrwa65sgO9VRXfswoZ/Docd08as9nZ88ZCpbPOQso9r+wAbwuicXfQHKOo2VJGAS
         9OOA==
X-Gm-Message-State: AOAM530nzyXOxk5jrzj9g13BwQDWUcQ9yWxtSHIokbhfaJ1gm4XkgdN+
        u3uRwYERSGvLtukL1y+hRcV5w4Amph0mPw==
X-Google-Smtp-Source: ABdhPJxcB6dGBmZVEu3wGu9Itt8DoWy0bfVAtEyrxdO2lJqYSJK1ipdfK2B6mZ+HCOakyfo9B0VZLg==
X-Received: by 2002:a17:90b:1116:: with SMTP id gi22mr1894987pjb.8.1598209583458;
        Sun, 23 Aug 2020 12:06:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10sm9076581pfb.82.2020.08.23.12.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 12:06:22 -0700 (PDT)
Message-ID: <5f42be2e.1c69fb81.68f76.c433@mx.google.com>
Date:   Sun, 23 Aug 2020 12:06:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.194-19-g53665ee380b9
Subject: stable-rc/linux-4.14.y baseline: 150 runs,
 2 regressions (v4.14.194-19-g53665ee380b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 150 runs, 2 regressions (v4.14.194-19-g536=
65ee380b9)

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
nel/v4.14.194-19-g53665ee380b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.194-19-g53665ee380b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      53665ee380b9c328c9960fd4bbee7a05e1fea6b4 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f42879344121432fe9fb441

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-19-g53665ee380b9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-19-g53665ee380b9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f42879344121432fe9fb=
442
      failing since 30 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4283ad43d6ad50b19fb432

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-19-g53665ee380b9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-19-g53665ee380b9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4283ad43d6ad50b19fb=
433
      failing since 145 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20

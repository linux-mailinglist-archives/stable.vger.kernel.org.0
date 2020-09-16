Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F2F26B7D7
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIPAaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgIPAai (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 20:30:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77565C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 17:30:26 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c3so2223815plz.5
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 17:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ldx0E8ST2kGXNMN1TEWKzS2Pu3KO/gr7wpfkO6TpXk4=;
        b=tf6BmvXjfwZ12FV/x3INl1f8smONOudXppeikZL6Ep6jo+f6OA1NuBY+XXMfLLjX1Y
         7LgMEqRsCjSVNSPufykWDRq7mNhmlPu+Q3fPxQdOjBEPfzECgToEN7QbN7/duxixqqwa
         ywoekACGXvwSh19BBatMf+93RfMjSaXVA+SY5HXfvRyTXoK+qGkNCURM2AvXElpw2Enu
         89RBEpuGeXaAvHPWK6TwgDTvF43R4Rgh8rjFBsIygITJMfouhbn/9i1s7Crwo9h/KMif
         9C0D7KXdcijgNCyS9mzQSGWCpsAicyK0R/cfUJar0ovFrF63tTYEvQXEuZuW1uBCkDNC
         ynWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ldx0E8ST2kGXNMN1TEWKzS2Pu3KO/gr7wpfkO6TpXk4=;
        b=K+6UNfNgEUJeiQcqwhsHPsgHczcihAsPA5eM9FCBcugSOIX/x82Y90/OHNP7kSM0O3
         tg8NZzb4EUmwAcEhZSupEavjo2hz7oUDy74gyQl+aFyq5TY7S69lb2OhKxqmRYWHZHzt
         HweERjQMQYoyTzQ/SdTHiEqzR+SfTKvdg8OoJCVLIbJy+xYwJsYRxWmKl+rdGprtpW0H
         B/vHc4W0AKBD7XTgoTfIiVlHRqLRidR1Aq4GBKJaNBPjandBVww5AH4ZfVDdD5WMJWnJ
         KDubUa7PjMCHRmdT04kXEj2f/i6Ht2cbckrFdclOcb9gC8A1GOeKwlVw5s6/5IiQDz+M
         ehcA==
X-Gm-Message-State: AOAM5317wOSwKVI9juaovAMyHuV/9peizYlhxdPa+knn230rNSv6Rmvm
        zIqNQvx1neVc7trbalUXVR5d6D9tfkhJxg==
X-Google-Smtp-Source: ABdhPJy0sJ+7LLiYllH2uoYat82/HpPEYGErS8OvLZ6dkW5lx8f9QSuEL5Vceb0zlfh5D0W62amKBg==
X-Received: by 2002:a17:90a:e609:: with SMTP id j9mr1534396pjy.129.1600216223830;
        Tue, 15 Sep 2020 17:30:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10sm569921pjf.34.2020.09.15.17.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 17:30:23 -0700 (PDT)
Message-ID: <5f615c9f.1c69fb81.f61c8.1e4e@mx.google.com>
Date:   Tue, 15 Sep 2020 17:30:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.198-60-gec572a7e7f50
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 143 runs,
 2 regressions (v4.14.198-60-gec572a7e7f50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 143 runs, 2 regressions (v4.14.198-60-gec5=
72a7e7f50)

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
nel/v4.14.198-60-gec572a7e7f50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.198-60-gec572a7e7f50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec572a7e7f50552c09b72df5db49fa75b085abc7 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f61296120ea0480b9bed968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-60-gec572a7e7f50/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-60-gec572a7e7f50/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f61296120ea0480b9bed=
969
      failing since 53 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f612a446ea4c4fc69bed950

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-60-gec572a7e7f50/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98-60-gec572a7e7f50/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f612a446ea4c4fc69bed=
951
      failing since 168 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20

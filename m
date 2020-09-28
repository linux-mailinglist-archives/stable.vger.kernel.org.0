Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3EA27B5D2
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 21:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgI1T7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 15:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgI1T7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 15:59:09 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4476C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 12:59:09 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t14so1803720pgl.10
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 12:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IBGaKuY6xiOGxUDqY8LKQ4fgk8/xuvKLhQ/eFPuZYPE=;
        b=pN1G3g4r4GgtbA31VZCa0huN99AyngLWAIUi1v3QUw4iRyuW7MBPuwFiGzMYQKkcOR
         lHWNUP91Yzdda5PApcAPZwwH1SoPWMS0pfr4ujev74SZqXBgCLCQq9RvIL82iVHpSf7R
         4bn2IwBz/irD4HzUj8qR2k3QTNEH74B864BVihFhCEwhmZw28S8Itf5WkDXZCtWPtcJF
         dwLSRMs7bJ5P36NqP9e6Ai0S1zwrTvC9onHeim+dsMz/6WGmS8qB9uRpkIq84TfOtdgm
         K9UAP+rLYnvwdkzf5zlMcRGC1IUrkShe5vTElEjnCRszKRN42yypMfMNC+MM7JeTlFo3
         LDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IBGaKuY6xiOGxUDqY8LKQ4fgk8/xuvKLhQ/eFPuZYPE=;
        b=La9CvGu0wLEkemLjaEE+BHya9eicJFi+GUBOjLfBHdhZfhuF20KJgwKOBf4zW14zqx
         PLxAynb1Wmk7hClV8juQ6QKmJk9/DCdi1onybbQEESf4zsass15xD6InfY1a7338tR+V
         rWv9Fv9f4pzQObF2/CK4zkxJf4KZYEGvIBZwgQCxKxHgmGDfDo28O7m/tOgvO2OVc2/5
         PhhFWc82xMC4PY0hNuQgcDWEE+at+jgvkWL3xDLCqzCDOZk3DRSdkQfBPOLir5MCiilk
         szetjW+thlteS2lyhbrYSiAAxKbS6hupQzG2FCxyufSH0QIbiAN41iyfMmDXTsd9CbRs
         P8og==
X-Gm-Message-State: AOAM531888zVCLv5kxoZjCYbwKu69CvJeA5l4S79fY4qgM3BdY+LOaQP
        3FxVUNuCwGtC4llHxd/+dK9G0hng5/0YhA==
X-Google-Smtp-Source: ABdhPJwWn40uAZrUJKJcU0YPCkSdpRwxKzdjrOX90MWFjUfEOzwjbpaYdGIPZ6rJUExCKiRa+h85ag==
X-Received: by 2002:a17:902:b685:b029:d2:1e62:4cbe with SMTP id c5-20020a170902b685b02900d21e624cbemr1038750pls.58.1601323148780;
        Mon, 28 Sep 2020 12:59:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm2106305pjd.57.2020.09.28.12.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 12:59:08 -0700 (PDT)
Message-ID: <5f72408c.1c69fb81.9de8a.3d13@mx.google.com>
Date:   Mon, 28 Sep 2020 12:59:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.199
Subject: stable-rc/linux-4.14.y baseline: 175 runs, 2 regressions (v4.14.199)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 175 runs, 2 regressions (v4.14.199)

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

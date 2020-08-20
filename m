Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96D824C642
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 21:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHTT1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 15:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgHTT1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 15:27:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6821BC061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 12:27:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d22so1530379pfn.5
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 12:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=29L69sjJNiencZZ9oKrAwaqaCtxTIdWQT+xGfUlZF0Y=;
        b=DEcGfpirqK2YCfND/Z6PIDOUkohXXsislJStgvE2liKoB81xlNxNnhQcbektF0TNUL
         tOx8qBy2qhy+61eawAZ7u2FD7h18r9brr/W3lZOaySFnEXBUroQOo1Wbw05vk5eye7l9
         7HrUcOCiX3KmCp+0jxSjH5ZJRwz3bnUcAUyaP78eByGFNJeey96qx4RdIfXQTEh5qJwU
         nQ6bA/jvsT8nogYFM6vNwo4QEPnQiFWtL4DJO63qNEE0HrY1mj/PqYaFW6cfxjcIsogm
         JYNchusmMN7bKBWLpRYHvN2iVbWCeVhYRjA9Fdm/QOs4fl06ipJgXc/qAcJww3AuVHcD
         J28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=29L69sjJNiencZZ9oKrAwaqaCtxTIdWQT+xGfUlZF0Y=;
        b=K6dtS7FopAefw3IifJ0+okCpRmQfzFyxWhAPCGk/pzQocbN4c+iOmSGss6iAQZEciM
         rpKeNRGxU8GY4IUTaA6IkqzbTbNuLVnF84OET4uIYPndIdAZqu1tifjnL+Gu1XtSZ045
         iP/p/cmmU14NkqOqO+xTbpAn3sEWRmK0edERFmA/Ah2y9ZoOw8rt8Atd7nZdcxBvtdxo
         kI0Y23lWJRDyQgJCtE3D4YGMhJuXfIt8QpY09njJ6t05NinXn7hKRb0/UqMzwSbQkzh4
         V41BlFXbSn6F+IrNfV6B3KqTzwrWEDLzUHg3a7pMc59WNYKzrDDbWWUlScrVZ8YMwgF8
         ra5w==
X-Gm-Message-State: AOAM532TMczKdWtO1cc5Bw6oC5Q37lYOKgibXdXAM9A2AL2NQ/JybxSW
        kMzcR9UOCxiDWPyWVf6hdW3wBIWUruonGQ==
X-Google-Smtp-Source: ABdhPJwfl8Nd/pnSrwk3kVBUlUQwhAQkCFlhrl5PG/kY9oAvQaJsY9y9la0lfmzcJRbYbs5ZaYSJXg==
X-Received: by 2002:a63:24c2:: with SMTP id k185mr193109pgk.415.1597951650491;
        Thu, 20 Aug 2020 12:27:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jb1sm2960295pjb.9.2020.08.20.12.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 12:27:29 -0700 (PDT)
Message-ID: <5f3ecea1.1c69fb81.2f1b1.6c54@mx.google.com>
Date:   Thu, 20 Aug 2020 12:27:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.193-227-g6c7d4935a4ff
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 153 runs,
 2 regressions (v4.14.193-227-g6c7d4935a4ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 153 runs, 2 regressions (v4.14.193-227-g6c=
7d4935a4ff)

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
nel/v4.14.193-227-g6c7d4935a4ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193-227-g6c7d4935a4ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c7d4935a4ff2afa46df3377ea214a86c4ac5f56 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e9bff6b056547a9d99a4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-227-g6c7d4935a4ff/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-227-g6c7d4935a4ff/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e9bff6b056547a9d99=
a4e
      failing since 27 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e9bd48c06704e8cd99a5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-227-g6c7d4935a4ff/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-227-g6c7d4935a4ff/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e9bd48c06704e8cd99=
a5d
      failing since 142 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20

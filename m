Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D979923BD0D
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 17:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgHDPSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 11:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgHDPSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 11:18:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65585C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 08:18:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s26so20482796pfm.4
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eP3TQXsiap92hk8AzjHcXaqVPwxGP3RgqqIoKbnpPFw=;
        b=sj5MRstLo+HO91r51S613SK+PrlZ5rdCx6ImFAD9J5yYruFfQOAMWi9xksYx3F6pJd
         lGXRbxO0DcHvBq0oT8pK/JEayOAdlIfjxJXiTNrF8966NqHg/nkfrfwc+UzMXWJvC8ny
         9/hsQdSVPUPc9YUYszo5807CkiCf7NmYgr2I/vQrYokZDm+gQEAZvFr01uJGD1j5jxxd
         RrmcrSPzoQK+WTJ/Sz8p1sgYh+eQVJxAtGHZVDALyuGxGz9uO4QdFGQr8N+r8lMzvkbz
         wp75I4CxWrPq4seBNVVRJck1H9tckbijWYkMDucspRUoRSI4Oa9j51JRisb61pte3GjL
         aBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eP3TQXsiap92hk8AzjHcXaqVPwxGP3RgqqIoKbnpPFw=;
        b=JjJKjhPUA3thetzaMJPnDp6f7N6aydBU/PRRGQOtBdqgPgKXXuGFiQfROIADaa4U9g
         K4WG9DOrU/H5iZpkCzxGcT3/vDmVqD1FkBbfWUlrytmHpcXX7r5MTXdkz2mbKYrcF8Sa
         fySUCKCh6jXd6LqUgG7bWnOX/zRvnDbaAogdK6b1pjLBPAyosG468y1vGRpsFC206UFj
         +KEJqaqr/W6pGicuDnrD4Vmwti7VA4SV62xiArJgOQ/ExFlryH6jAQE1bdSaC8dkYfrC
         C4WH9+9YdOglps7i0GN3lF0DKxuOQfI9dMFORHc3nat2Nn4V5rfdwFPXXoYyOLhchKps
         Og5Q==
X-Gm-Message-State: AOAM530WeI80wjJCYSN6kMsOUGSgV2RBxqkV4SzBiFnZxUUaXUQHYXvl
        r3EkiAm/3q78/eW6+Xa17Zpr/cSxCBs=
X-Google-Smtp-Source: ABdhPJzioEARp9OeISbb4hxOx+AjhY1hHMfVmdECETgd4qJVEKgY0//K4l/YDJaBCwA4htQo8gD8pg==
X-Received: by 2002:a63:3484:: with SMTP id b126mr11718206pga.297.1596554294181;
        Tue, 04 Aug 2020 08:18:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b185sm23438912pfg.71.2020.08.04.08.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 08:18:13 -0700 (PDT)
Message-ID: <5f297c35.1c69fb81.57bdd.aa20@mx.google.com>
Date:   Tue, 04 Aug 2020 08:18:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.191-48-g7083248d6b07
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 150 runs,
 2 regressions (v4.14.191-48-g7083248d6b07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 150 runs, 2 regressions (v4.14.191-48-g708=
3248d6b07)

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
nel/v4.14.191-48-g7083248d6b07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.191-48-g7083248d6b07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7083248d6b07cb6515a68a2615895a121d7429e0 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f294819b4614f3ea352c1c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-48-g7083248d6b07/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-48-g7083248d6b07/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f294819b4614f3ea352c=
1ca
      failing since 11 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2949d4e4df79443352c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-48-g7083248d6b07/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91-48-g7083248d6b07/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2949d4e4df79443352c=
1a7
      failing since 125 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20

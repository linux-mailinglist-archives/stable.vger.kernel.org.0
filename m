Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97033241482
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 03:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgHKBUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 21:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgHKBUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 21:20:48 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4525AC06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:20:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d22so6718829pfn.5
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MgRJKkm/RNv18EIHtqBkMipK7P60FWqXFozx81+Se/s=;
        b=IC91l++Bv1wpI8Z0lXNFRccSLL3jbkHryK1mn5r1l+Y4OdilXKvpwNrEXjyP6mFiWJ
         9COT7UeJOhehQbiVlC4g6YKGylu0G/QIXctxidVwPsU+LCX8WqombfHMqYrUB8+h4NhF
         l/cZ5q3ez0Qx1tyOmrMpG8MmCzLd2k1zWLeR/tsDuslH81BuXpCU8NwlyWd3ZbEot3NM
         D49psJ5A14gTpr/nsTkIJ6sRgIy3Scrzur0LTnRsna12scK+agNOIthKuFjrl9bkwwYP
         8qf/6UyTQCtyJc5lWldwdLr5KRvTeEOopSF6Zsg6xHnWZSMhR7zeI353oNzLgkBNYK6g
         bs1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MgRJKkm/RNv18EIHtqBkMipK7P60FWqXFozx81+Se/s=;
        b=aWdI3kEfAPMlM8D0rFnNotAuLxosJE0ydvByzxtSfz2Su2CUw17b7Uul7knQRONbKA
         Pbijhn58jGa9ZQgkmiwKQsCKpOJLJ4BvfCdw1J4axQrcCqu+o19y4e8Csr+c3K/Mz+O5
         0gkhD/Ddk2DPLF1LPHRgb5lY2I8axcqMlHGF5VeGDese8HlMltj5JoYOzeE5feUyT2ma
         36P2SQiIdjso0gSwwHsMskH7E3OsNHjcXSrlk+Chw3pFZYIP2L+n4jaghuOTwsuuQsHE
         f+gA52HQNHxZv9zvJtYk9+5v7WPcgjabMvjal7DTQ5mz5jZ8yhdBwloi0l8evszRuCdX
         /QvA==
X-Gm-Message-State: AOAM5328XDDaFnhYYrj1Z33Ej8gGPzdKDK4qV4FzG37PUgBtLykJpH17
        Gu3WOspiGIFBqbLurCkxyNVPdaNUT2s=
X-Google-Smtp-Source: ABdhPJwq/RAw8gq+48kR/6zDpYe+QgptkQhDxHaCLRN27ORRBN3UkHaU/nSQNVI0Q6KYSUlUZL7HEA==
X-Received: by 2002:a63:5160:: with SMTP id r32mr20220394pgl.112.1597108847376;
        Mon, 10 Aug 2020 18:20:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s185sm22008990pgc.18.2020.08.10.18.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 18:20:46 -0700 (PDT)
Message-ID: <5f31f26e.1c69fb81.4a5aa.c32b@mx.google.com>
Date:   Mon, 10 Aug 2020 18:20:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.193-43-g288931e8c436
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 147 runs,
 2 regressions (v4.14.193-43-g288931e8c436)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 2 regressions (v4.14.193-43-g288=
931e8c436)

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
nel/v4.14.193-43-g288931e8c436/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193-43-g288931e8c436
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      288931e8c4364aa6ad46ed925bb3c469262a10bc =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f31b9a1bf0103fdfb52c1ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-43-g288931e8c436/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-43-g288931e8c436/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31b9a1bf0103fdfb52c=
1bb
      failing since 17 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f31b9ef258f1f8e7452c1b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-43-g288931e8c436/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-43-g288931e8c436/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31b9ef258f1f8e7452c=
1b5
      failing since 132 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20

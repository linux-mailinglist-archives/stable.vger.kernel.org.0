Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A916922D8A0
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 18:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgGYQEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgGYQEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 12:04:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15978C08C5C0
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 09:04:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m16so6049436pls.5
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dqB8VcvTz3iXSImYJW65hAQksrymVNvDA3qDmi/hX40=;
        b=fsx9bdBePTwtGNG72CfIgjNqvt0243zvsHL6SOsywDnkgROIKmg6uBLMPpBA8bHofB
         LlMi6rTb9MaHjcosHj0eiHO4M6fCEG7Igd15nBCEAaEKy+EKtwTvPj7JqiqpAzUUeeM9
         vVH9AF5r5EggNVB5/WMTIvcARLY1a5iXPJVQ3ONG8C7+VMXqNNpHpvgwCL1ohEeMQdMg
         4qBKxtwjT/Uq/57i2zdpfRMD5/vIlTAm2bwARHTpdBHvzVBUN6LfqCY07HUbI5NFqoMa
         1WS7huADbqJ1WwW1i862SCXlmmpSWgeNwj9k88lnOgnVVoNs8UbC1ymqMxYKSmSgtGv2
         T9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dqB8VcvTz3iXSImYJW65hAQksrymVNvDA3qDmi/hX40=;
        b=iDP1BDvUyKcMTc73n41gVEqWNu/jxa/hqLNRreJ4kz4FHqPEQo6KAaRsT6752MeaGo
         igi1x5J6yM9jh6qc9cu2TRtkotlnVe7A4qxN8NSpJmYdgsbo4iztkDJNdLJoAbvVB3t7
         qqBvWCY7w0TscpoNxZzjxHKStq5bFMd8+oXaO2+7ibL4b7+EMYTgZ93e+0Omu8GS71Jn
         hej0YDn41iI11VpOo220Dv4hbAsUiAy8EDxHBd81Dk9UDL7ELYpmeNPRK0djBm0LOWay
         05RES52OU0RZguQBeHdrEI7NknnQq9fayReySuuNDR3PHq95at4UQCUh/NeEs12LgH78
         Am/w==
X-Gm-Message-State: AOAM5318Lbb+AAwx1YRVrfOGvYi50nw8FKZe4+dhJevq4mKcZ0/ju46F
        IZJMzNal99/WKGOXFyEXHI4N+ZMc4qQ=
X-Google-Smtp-Source: ABdhPJyFr6l8yPbkf401j/k+3zs/HlhnZ9O74e2zxpw/B5UXQzVNf7bg4Rug9l+McPzTLARID00D/A==
X-Received: by 2002:a17:90a:db87:: with SMTP id h7mr11362724pjv.159.1595693092137;
        Sat, 25 Jul 2020 09:04:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm10104010pfn.171.2020.07.25.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 09:04:51 -0700 (PDT)
Message-ID: <5f1c5823.1c69fb81.dc9ea.0999@mx.google.com>
Date:   Sat, 25 Jul 2020 09:04:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.189
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 154 runs, 2 regressions (v4.14.189)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 154 runs, 2 regressions (v4.14.189)

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
nel/v4.14.189/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.189
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69b94dd6dcd14d9bfcba35a492f5e27c15cf4d0a =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1ac77ac5f6635c5385bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1ac77ac5f6635c5385b=
b19
      new failure (last pass: v4.14.188-126-g5b1e982af0f8) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1ac27de51bf0a15585bb36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1ac27de51bf0a15585b=
b37
      failing since 114 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20

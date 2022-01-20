Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC4E49565D
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 23:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378079AbiATWc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 17:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378078AbiATWc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 17:32:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C96C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 14:32:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso11933002pjh.0
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 14:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vldE44npA/aOd/YMva1W+V5dn/WXMME9s67+sflk1RA=;
        b=MP3Aw0it2OpgaHg2vIfduMmdvhOQH/7sZQB0xYI/pY65bFkI7TPJUkXKo0TOn0N5sN
         rFeR7k2MZ4xf/snL10Ds7mjXwi4NC6u7KYnSgQxx/QXD38USB8cWAqdQEitLFhBIgYLz
         XxnkDw2hi4Nu0/hGySDIXY2Sz0xWVh0YtS/u0EIqcB/N91If4M6ozRtrUxhke7Bb1Rwe
         g9RvLDOpBVwtyOapAZc11EeaNF6Av0zM/HCLYNQ6xytyCU0c6uXWuIMEbjp2x4g3h2hO
         J1RX1f2TqqVo79ngPDCaFl3pFZIC0ixk4m6L5YYGhkkZuZJm1MxthsuB8goGUyfnqsd6
         vC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vldE44npA/aOd/YMva1W+V5dn/WXMME9s67+sflk1RA=;
        b=i8IO26ejf2cGRKlAaBJThDwboM5AoeWZ1heh7418RqY9tahyslFbzIUWqdKZ3TpvpD
         qAL397F2HtoG5yhs44NsPdthv7xzaHqjcCmaVSp5YyRuSRDBELsLgxXffI0P+P5/xFYA
         HRyTLUdZ8FidA9o0RNfjPf4QzrWV0vQU2kFAAyKMOCRXPSAKBhWtpwr2ie/eBrWL6U9L
         lYLj3hKRYJqRkgBuOV8usCgaLw+/rr6xRXWCyAZPnZVVnOAnmCVBe84zPS+yBXuSK/P8
         S/eAk/T8rOHpsknOVfTLD2rpBBfyyjLp9hxuKFS+SwVn8uZhdtOGXyDSAVqGxZt9kYwn
         Dnww==
X-Gm-Message-State: AOAM531WAjAPIEP2wC38pA6TZVoNgBaGcUZ67pdwro9Yc9xuelXqrm+o
        h3LeHRKuzwMVi06sy0NuFU/zoGAf0wQ1i8ea
X-Google-Smtp-Source: ABdhPJzaJjHka3FIbg0jW7EM/RPeC7Mph/rh++Acf3VHQCw5nZ9u2NsinzzB1t5rAled9kVH8TFelA==
X-Received: by 2002:a17:90b:1c03:: with SMTP id oc3mr13284491pjb.227.1642717944937;
        Thu, 20 Jan 2022 14:32:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm4665031pfh.40.2022.01.20.14.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 14:32:24 -0800 (PST)
Message-ID: <61e9e2f8.1c69fb81.6a2ef.dd24@mx.google.com>
Date:   Thu, 20 Jan 2022 14:32:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.15-28-g1f75a74f84d6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 151 runs,
 1 regressions (v5.15.15-28-g1f75a74f84d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 151 runs, 1 regressions (v5.15.15-28-g1f75a7=
4f84d6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.15-28-g1f75a74f84d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.15-28-g1f75a74f84d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f75a74f84d6221d204ad411e33ebe52161ed9ca =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9af614b37df8eb8abbd4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.15-=
28-g1f75a74f84d6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.15-=
28-g1f75a74f84d6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9af614b37df8eb8abb=
d4e
        new failure (last pass: v5.15.14-69-gc1152c1284d7) =

 =20

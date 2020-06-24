Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E063E206ABF
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 05:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388393AbgFXDsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 23:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388288AbgFXDsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 23:48:31 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849EDC061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 20:48:30 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x207so507093pfc.5
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 20:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o1ruF5bZ1aIWExgTp6qny0VbS3oCWBgzjlTbSwueeic=;
        b=wTNy8Rf4Q5FVAwJLwZ5gjbphbKOCREpwLCay0BR0/ctm2FYKF75q4WJ+UTDBxAo15B
         MKVvRV3ut9UPHyL8LiVcdfT7ZY9KhiAroNyd5dHYdv9ohKsopRNg2snE2+E62lqw8SzT
         nOWYilT9XpGg7B/wZ3IYlaGCgYfn7WtRb/Xdaler1gx40AiYpqrU/liErfQZ4vW0G7S6
         uJluYLIW5mR/KpyONmnzLOO2xtm5pubR/3dvL1bncTpZ/HYotySAvKJpZ71sGZCT8mZ2
         jsD6NhzPDBQnB6Hi4xIXnstC2SRmDeMik7NxxmfoWdD0vFIypv9W9PLI1GJZ3puS73vd
         l87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o1ruF5bZ1aIWExgTp6qny0VbS3oCWBgzjlTbSwueeic=;
        b=VXiRnT5AqyuouJI3wTdi3+gMiWORewW3b+DZHzkAD+n9T8Q4oI3F45Uxa6d8SdkNex
         ToTTXsQxqJrpmLExSon14xZsy9m96+5zztpeLjrOnR/+HIlXLyUvLwefz326quAK85i8
         +dLsuM3MaCISWOlg+2sYKlF02O2owlTB7D2kNU1tSMuBESkGM3Rx1vBzzv5uG2ICcMX1
         KdLGX8Eo9DGLs4iqBb2aWrWlFFY1DKcUKrL4xQQXqrm0Hd4b1PqgMZkiQ4L4FrUS9rXE
         InlBjT+gKK9eWmPLHXePYJfzGRE/TT/fMvbhuj9shUXH/lIK0M3W5Ei+lnv4hsU+/Xnj
         87Fg==
X-Gm-Message-State: AOAM53183RGS8i8OvdtxxWUIT1MS5wO4QUuVHX7XwaX8/Nrok1b+uKI+
        1RbiZPbjDUKAkA0E3axUYw91Ym/jZlk=
X-Google-Smtp-Source: ABdhPJxWYNUOgOcj5BuJjC/usnoi5T8HdlF8KNPRT2o7Ug16FjRyxLdbPsx/CTUmqZhGYlwULNkA7w==
X-Received: by 2002:aa7:8b43:: with SMTP id i3mr29324038pfd.7.1592970508894;
        Tue, 23 Jun 2020 20:48:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm3603677pjr.41.2020.06.23.20.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 20:48:28 -0700 (PDT)
Message-ID: <5ef2cd0c.1c69fb81.5841d.dac7@mx.google.com>
Date:   Tue, 23 Jun 2020 20:48:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-375-g6d27b216d316
Subject: stable-rc/linux-4.14.y baseline: 56 runs,
 1 regressions (v4.14.183-375-g6d27b216d316)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 56 runs, 1 regressions (v4.14.183-375-g6d2=
7b216d316)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-375-g6d27b216d316/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-375-g6d27b216d316
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d27b216d316636782b7e79f41eb29e335f14991 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef29bc327fad9e84c97bf28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-375-g6d27b216d316/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-375-g6d27b216d316/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef29bc327fad9e84c97b=
f29
      failing since 84 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20

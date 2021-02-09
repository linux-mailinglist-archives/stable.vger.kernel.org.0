Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459283149AA
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 08:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBIHre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhBIHrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 02:47:33 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B72C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 23:46:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y10so9279367plk.7
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 23:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iO28uYiLG1v9ndZ6JI+neNXnF0bsA5w2dNfHr//vfBA=;
        b=MfQVOGHZ1Vw6KkYTnD/BCl/QoUDwvYqqQyUNAD5xs5RPzgJCvW40xtO9UeKPRZbfKU
         uGSPtf9za9Os8+eITsMydHgkBIDly8Ga+y6FnePle0Kjh8DEApnOJRU0xL0/NSU/7dNa
         YRh7SLQzUj3lbJZ45oTsS/hAfmrqyKHhGJr8ZQbTrifxeNgmbt5HBZ66awzqf87I/QUj
         ZRDh7vC2rz3u0h46Zi+LnjHQuRSsd5Kit2zNf6su9uSMUmE8jISXnqaW59THll/26q5G
         Cy7RdnRpiCpQOEWBHAR86nVd35FvqtsSFipw2Zu3bq50qosV4AK2ASLOjhFStHXsMqKr
         2gGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iO28uYiLG1v9ndZ6JI+neNXnF0bsA5w2dNfHr//vfBA=;
        b=UAFuIhflzEisqqQhsfyLcssGUxDIh/hpRYvdXEQslwOdagbSiSPn21LJenPZ2Ky9ZB
         P2HJzDpdgu7J5lwVPNc4/+C7TDrfMWKauiYko+H5mdjkxEcVtNfNNlsDwHW20ikz/7xy
         GO+jznU3tVvPlV6LE3Nq2iYEa0dvdkGbPMssj9tckSx0zfm9G/pgNnaxOO9ucOyo56rO
         kkD5QYvrNudEdXBLrV3AczG/XP7kq+ljl+F5P+r89oaMmEp1t8E7gB+8SWBqDSUtV93R
         lpNLEsxC7GmD4FzqsMuUGnhEFVhCyuCcf+ZS+E9186iCGDDSmtKreElr8kkFCkE1UIp7
         y7+w==
X-Gm-Message-State: AOAM533fMdxNigL1FNL6ekfeverQrXdPbR8q621HsuKYnn0A3Ib5v6n6
        56jgB4NMrfXc1sOPRgwka+etQP5Fe0t28A==
X-Google-Smtp-Source: ABdhPJwTQdz43ZyUTlLPJcjUkNi5U+ufPZ2XpItwu2P8dwWkiJ4ZxoPKn9NiEqmqgFeZmNA4tuYV/w==
X-Received: by 2002:a17:902:9a46:b029:e2:f97b:47da with SMTP id x6-20020a1709029a46b02900e2f97b47damr349654plv.77.1612856811708;
        Mon, 08 Feb 2021 23:46:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x11sm6423716pfr.24.2021.02.08.23.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 23:46:50 -0800 (PST)
Message-ID: <60223dea.1c69fb81.778c5.f0c5@mx.google.com>
Date:   Mon, 08 Feb 2021 23:46:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.96-65-g28b8ea189a5c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 99 runs,
 1 regressions (v5.4.96-65-g28b8ea189a5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 99 runs, 1 regressions (v5.4.96-65-g28b8ea189=
a5c)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.96-65-g28b8ea189a5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.96-65-g28b8ea189a5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28b8ea189a5c596608340d850da8a5cc4b272052 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60220e6392f629377b3abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-65=
-g28b8ea189a5c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-65=
-g28b8ea189a5c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60220e6392f629377b3ab=
e8e
        new failure (last pass: v5.4.96-22-g157237aef1207) =

 =20

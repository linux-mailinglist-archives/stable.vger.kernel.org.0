Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD61F041D
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 03:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgFFBKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 21:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgFFBKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 21:10:48 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FADC08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 18:10:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o6so5973227pgh.2
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 18:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KsGpFqfWCjXWtHXrv1q9WSNNmwYL2usVLJ1wT+z37hQ=;
        b=GNqcnx0OShi6VvAM1ZTePnB2qTiwg6qHPRZm9hJxf8U/P6r91tK9fdotXCGEIunlg/
         npqiRZtHBMspE6PBsu60uyjZoX7JnMvAGHsUZTZi5WfScb3LBFY6ZJp39sIPzeHoIdvl
         34C798y8jSGDATn3Rp3+3neZKAb9GF4oUcU9DPCmg97SFRg0fqVjb8z/KskxVF3rbEVx
         Vt/ouU32nP9uhJWqpYAlgBaKxOGHT7Q6f5+VGR65cKsoSdEywmTteVEL8NLPyP66KRSC
         OfL9NOjdC8x5b9m+OTGDr4daLF1yrhkgThsIF3o+OkIYazIk8J1hjWrNR+xxQHHL4BGL
         q2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KsGpFqfWCjXWtHXrv1q9WSNNmwYL2usVLJ1wT+z37hQ=;
        b=t3aBInye99bZyJp9xF6g/rYE8N/rFE99Xtvxd2YmybZwQnWNq+E5qq6Jjbj68c1ztD
         JVlvmJ2O3Vk847G4OOyAncpSvn1ovc2bux1IahIFI97zJQnoJw5B/6KNxXcOchI+oiI6
         uyY1qy3Skqa1hWgS9HiW1fUfNkuH1K1W/qxEgqh55tX+yghdb+caDkXx4gb06tvuHeFE
         MSQx4DQSsKOb7ikydxn5v+x4e28PupJic0M2D6CZJ7gt+x1nTY1w64uoWvbUmh8Sjd0j
         gwc6KSI24soOe6docjBEOuyPYy1KOtKaac64HzNjVTc8vRiBlDHTS0CbJa+6Rgw1ZoQM
         QwrQ==
X-Gm-Message-State: AOAM532KhKectQKeslCMPgNPo68eCqe3Ybs6YmK+cNiFJ+Buvncxtpaz
        eKfbHT2pQk/TvzeVBO9Sr7925Jhfnj0=
X-Google-Smtp-Source: ABdhPJylZu/Sk/yUFTJgpEhecVxEcraKLw4YFMTIiBVW/OwE2w8QpXqlULyp88rY7IXmHrQHaDmtxA==
X-Received: by 2002:a65:5285:: with SMTP id y5mr12226217pgp.271.1591405847271;
        Fri, 05 Jun 2020 18:10:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p190sm712891pfp.207.2020.06.05.18.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 18:10:46 -0700 (PDT)
Message-ID: <5edaed16.1c69fb81.b39b5.932f@mx.google.com>
Date:   Fri, 05 Jun 2020 18:10:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-29-g65151bf9f715
Subject: stable-rc/linux-4.19.y baseline: 61 runs,
 1 regressions (v4.19.126-29-g65151bf9f715)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 61 runs, 1 regressions (v4.19.126-29-g6515=
1bf9f715)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig           | resul=
ts
------------+------+---------------+----------+---------------------+------=
--
omap4-panda | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5  =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-29-g65151bf9f715/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-29-g65151bf9f715
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65151bf9f715983d62613a4d9196525eb64dda53 =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | resul=
ts
------------+------+---------------+----------+---------------------+------=
--
omap4-panda | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5  =
  =


  Details:     https://kernelci.org/test/plan/id/5edab2d8d39c317b9097bf13

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-29-g65151bf9f715/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-om=
ap4-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-29-g65151bf9f715/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-om=
ap4-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5edab2d8d39c317=
b9097bf18
      new failure (last pass: v4.19.126)
      2 lines =20

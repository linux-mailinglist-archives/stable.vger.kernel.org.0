Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA7E3183D0
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 04:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBKDFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 22:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhBKDFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 22:05:33 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F55C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:04:53 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t29so2754063pfg.11
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7/uYuFG2Xi7lo3n3XalxhjdAYlnNkVY2C7gfMHDNaYU=;
        b=UH42O571E3mIodsG2KViLJ6j15QtE+M5tjP31MW39ItkasoLjQtOqyI8UipxfdQ0qv
         dLTqRo41+L+eyi2wqcTd9wc2Z+Jnp0y9r5Q8SV/KThUpgvyCnwBaAH80wtQcixSXBGCh
         C8XEmxIpMAsdEWov/AAgqVADsJaVvPsJPldgBpmHmGEAq9r+PLrGZENMKykr628N8Sy2
         c5Dg/zHPAgEfvl1kb3WB41nFSafroh+ZdH47RfNTHiWuDznzSuKX8M6aTMNebxqH+AIr
         DWoo0E5uRlC7THsGGcI3Ie8R/HaVSVL25GhZGs9wzO5odzCTWX2NFJdblMB1K0kIuYCw
         vHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7/uYuFG2Xi7lo3n3XalxhjdAYlnNkVY2C7gfMHDNaYU=;
        b=J0YwIgSXFNrYgsOvzzbpsWSaEmNco3agAFctojrpSQlNK7XzDVFylFbz2mD+9uCnEK
         +KcC9eat0UQ+Nw4EbJKFYoJwDKiAsBpiAbPK6ehr58O9rm6ppshmi71BwT4dmRe+yVSc
         ZqlZWNCUgq5mKRLISkEf1cR5cxqOSvDg9UwXRalM77Yig4NDLfFXVt9MWRA/2wvb0XpJ
         OYWxj/4GFl4wswNJCG/AofWKSVV7pkAzN6uuds/ftn/+soW/snJfpkiZEQa5yjMxkTPV
         g/iSB018T0E7ZMOVTu8fMPbDYw/Wxo7ZLu7bwRoznaKdrCgpb3UTSzXu3cZbUBU30p9f
         XsuQ==
X-Gm-Message-State: AOAM530dws7N+b4XMPVdiuGevs8bI7C8tV4ShETVeJJ1THr5KP8qSkig
        M0Z3zOqEGuZ921Ef2J2ehRIu0sE6UxodOQ==
X-Google-Smtp-Source: ABdhPJyIkdOpe6JgvtrOQ2LHgxL3hjH6fHWrDEWNQ1Gjvc75bCq8r3RZ5hdR0+hNpjG/IWTBfodAuA==
X-Received: by 2002:a63:1241:: with SMTP id 1mr5956940pgs.350.1613012692540;
        Wed, 10 Feb 2021 19:04:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm3971255pfj.58.2021.02.10.19.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 19:04:52 -0800 (PST)
Message-ID: <60249ed4.1c69fb81.c4b91.9aaa@mx.google.com>
Date:   Wed, 10 Feb 2021 19:04:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.97
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 93 runs, 1 regressions (v5.4.97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 93 runs, 1 regressions (v5.4.97)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e1942063dc3633f7a127aa2b159c13507580d21 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60246af732d1c6295e3abee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.97/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.97/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60246af732d1c6295e3ab=
ee4
        failing since 82 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2014731DC0F
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 16:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhBQPUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 10:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbhBQPTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 10:19:21 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C461C061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 07:18:31 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id r2so7554179plr.10
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AFV/wMQsNbLaUBMK/n0UsHtgGL9sqP4vGvBKgSaZqmQ=;
        b=Q4CZ7YA1XVxP7l9IlRL2kA5RBFcnUc1ZMH8S3vFSc0covwFMyDyCJHktxBzeJszuj8
         yD78zT7UoiCe0wVSOGdVpbylVHQCRCsxS2p11qTqlSxuhCxgLSex5pxrtaw3tMdeMX05
         V1YtYcXVsdzI54mhPtpLmQFTfsB4CQ56a2lfASqFxkFSwprz8L4fSOOCKSPo2PGN/avk
         fDWpHEVr4lquI4uv3qdEn16vh4vjo4XGHWWJdQ9YjRUKWMLnpX+TLH0FtKxgg1Yu2QLb
         AH9MldngK1+1iezgKwF8Hi9Ydgnr71bFnQPjcq7wUW2paLlOz9lSQG7T8N4ovv8Uvf9H
         S5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AFV/wMQsNbLaUBMK/n0UsHtgGL9sqP4vGvBKgSaZqmQ=;
        b=gjjQX8qUIJRwGgHPTvG/kABLQQ8SZzOpX8KXJq55wl/vczjNTqd/G2d1P7EkXyEnzn
         DoKj7XefSlKjB5ZCv0AGLxygwHOlZQW3mdhDnjfhYmVrxRjES6SZUGkUNswpEPrtrkSl
         NcZD4FfRAPhirEDPMAFEHJnGmoFNL55hcYcoClriAyH0FHkvxTKDWiid9nAkPZWzuhhZ
         6cyWTl2v1kP1cZeEKMNXRiQMlGacFPBwRCjTZKSG2gWI+aI97YA/0Yxxv3/uI/kPCAaX
         GuPHrWHqbN7Mc2+1TWHScoWc073zoTG3AdXffQsB0GXHpbFO/XKAa7/XY5gzRmaTfXYW
         9RTQ==
X-Gm-Message-State: AOAM532geVveQmzBRH0gUu2vvv5hDWW0+N1iJT9GZJgQlzCq+KXb0uEm
        cAwUm6HhcMV4AxQniclWfp8iyisVYmdZ+g==
X-Google-Smtp-Source: ABdhPJxwQPDrypL9VJty2a0plmPdV5Mrpyxj/mL9AoVHqvr0ahN03zVyf5gYeDqYzdWLPMBfVv7xnQ==
X-Received: by 2002:a17:90b:440b:: with SMTP id hx11mr9486002pjb.95.1613575109024;
        Wed, 17 Feb 2021 07:18:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c23sm2687939pfi.47.2021.02.17.07.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 07:18:28 -0800 (PST)
Message-ID: <602d33c4.1c69fb81.fb22.591b@mx.google.com>
Date:   Wed, 17 Feb 2021 07:18:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.98-60-g39e91bfbe270
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 103 runs,
 1 regressions (v5.4.98-60-g39e91bfbe270)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 103 runs, 1 regressions (v5.4.98-60-g39e91bfb=
e270)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98-60-g39e91bfbe270/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98-60-g39e91bfbe270
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39e91bfbe270491dc238cd23652322e0636b7ce3 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602cf7c09e2f1304b7addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g39e91bfbe270/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g39e91bfbe270/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602cf7c09e2f1304b7add=
cc7
        failing since 89 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20

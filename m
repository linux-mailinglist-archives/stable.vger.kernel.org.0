Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D91D372FF7
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 20:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhEDSvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 14:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhEDSvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 14:51:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2C6C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 11:50:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m190so1075450pga.2
        for <stable@vger.kernel.org>; Tue, 04 May 2021 11:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=83edrlcxbaGPN2VVbYTFcGXHviphJd4yyg7sJ78rFRs=;
        b=cHw6gUFCBbrM61NYOT8oEfhMs6aHZscrBbDlrr8ooGaX0SQJNzTIoI+o11w73y8sQM
         Je/3qUK1QSb00qCx0RmM+ynaHgkt13Fof3X0eP2hXTkLDJO2nT+LMGUOdHstw17jZhTN
         TRC46dNQ7BQLY8WhcLmiwsQXdVy+jg3quaxI896lJ3c4rsaSBuNmLwzklnkgsZ3gQvHI
         7PIBG4sAd4Ygv07yX3kYGvS95lCGRWkcxfiizg/tb9Htnr6hNY1AH6vjGNFE2cAMO9IH
         CVOU7hHheRhO90raO1NJ9mFzLJoTDkqOGQRG27ATyvbJWNvkB4KsQkIHqwuYrs+S4nx3
         tEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=83edrlcxbaGPN2VVbYTFcGXHviphJd4yyg7sJ78rFRs=;
        b=s2knQKJ6qqgbwop+ejBHBibH1DFLJ8G4cgNSJbGopz8mzQWO1r6fO2uwXzsp7kJBfz
         Nt8lOtnXgaF5MCjYXy9z4buxBJmfjolzFXp7rTuLRrz+TrMyWjyKey25F4xywHwukB7D
         oFQYI9hZh32cJZ5BT43igVz/crzNGDRsO8e9GwDZ/NZMyZ4o7aGZm8Fip1ydlhEGK0he
         VW/m2dKcIDrRyNKDsfS0ONAixglhWR8G9M7VF2G9fFuiTshxPKpbA0NtZRtnWADlBwaT
         eOuydecDr6gXOOSKgNFbeNmOEwDPYsNK6Cr7ZzVqMat0RQ2BgqQYNTHuhfmfkmf20zMm
         1HDg==
X-Gm-Message-State: AOAM533k56FgG9g2Pj4Oj/OOth3lemYqrTA0m0RDMkJ3K4oSgdCGd7Fr
        mcYr9p6CWzBRfjDD6FOqTleXYVfpr1OCJ9JE
X-Google-Smtp-Source: ABdhPJwhcCvUPIOR2cOAVZP7UQUU6KMkeir6MYIm6QpbKRxjSReSggzUTdbtQav8q7ZehpP1DCkxFg==
X-Received: by 2002:a17:90a:5806:: with SMTP id h6mr29229468pji.14.1620154221760;
        Tue, 04 May 2021 11:50:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ch14sm14128256pjb.55.2021.05.04.11.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 11:50:21 -0700 (PDT)
Message-ID: <6091976d.1c69fb81.ef34e.3077@mx.google.com>
Date:   Tue, 04 May 2021 11:50:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.34-6-g4912ffb397b5d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 90 runs,
 1 regressions (v5.10.34-6-g4912ffb397b5d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 90 runs, 1 regressions (v5.10.34-6-g4912ffb3=
97b5d)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-8    | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.34-6-g4912ffb397b5d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.34-6-g4912ffb397b5d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4912ffb397b5d309f384248354cc2fbc3bf07b2b =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-8    | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60915e09372de4476a843f32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
6-g4912ffb397b5d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
6-g4912ffb397b5d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60915e09372de4476a843=
f33
        new failure (last pass: v5.10.34-4-g409a7a0c5b5ee) =

 =20

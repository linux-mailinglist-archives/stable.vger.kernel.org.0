Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC9E457AC9
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 04:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhKTDf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 22:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhKTDf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 22:35:26 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEE8C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 19:32:24 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 28so10204588pgq.8
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 19:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mRU8xvlyYyKxpFEQ4rx1kBkXurVSbZnyVnntEuj8By4=;
        b=M2+3jgGCUWUX8dpwD/rsFaK1v+OYaOCA2cuDfYR4R5Kgc2A5QqXhbRgnjRPHbdCt85
         8q7jn4940zE+LEOkQNZG6xfmcSvMtBj6vjHeFovmcgDWykGBxn53lI3mnpehKvm/N4vU
         k7Nsxs4kkuMU3vKj/BIpuKMcsF5Tc9tInflKJFyc6nsJbHWNh+z5kYRsVeA/pwTsHtN3
         SIpokXjHbD24VuEsmvlwxP/PhC2Un6pPelNbnJKMv4Yx8x8PmE4cD4a/vR1/lbkJzexZ
         UqXfpv8Y8UP7ZyL3okqll9E7+onZrJ01+qOm2IIlExknsoDJFnJFxtmJOGE1e4BSrnmx
         Th+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mRU8xvlyYyKxpFEQ4rx1kBkXurVSbZnyVnntEuj8By4=;
        b=QVjG4SXIpsdndSeDvyijD1Tf/pBlRdHtCi1K4joZYtm4ftAPckGHdCm+gfdXpppFg6
         CPfGhezXF5hyu/A5Ms7KC4locyyACTbKPXvu5kKftHpNKoV+T1HZIQuMhmjcQAXlaLw+
         LY5pjVpg0cCDHMbsoWYE8bMz6+y4tsealA1CZlfyb+ENRMS+0P7FD9PceRNoxTMpp6L9
         L1LNWrj2jP0o1CJfoCQ+VULB6qECjMtN2yIW4g5vPg6/6xGfyMNV4GmCZnE0CiPzU8nV
         2V4qrFdQQqw7KWEDWYEbwHOXfrpH2UucMmTCBl9RBlDtnYmr3LX6eNCAIyKzycVUe0Uk
         NpXA==
X-Gm-Message-State: AOAM532g+3XlCb6W85RyVKGHIt/jk64F12BMqgiFjmbVySLqZHNDPAfs
        9ZpX5YK1ue2ob1uiRbX9+ys6ob0wi3cfjmid
X-Google-Smtp-Source: ABdhPJwr8334SgQjTREuaBQb9oezR1OzgXRlvrhf93sspWBoq+1CV+/YFwZ8pIBDHTZsUzSSV42s5Q==
X-Received: by 2002:aa7:8b14:0:b0:4a3:a714:30ed with SMTP id f20-20020aa78b14000000b004a3a71430edmr11523781pfd.2.1637379143482;
        Fri, 19 Nov 2021 19:32:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i33sm774579pgi.71.2021.11.19.19.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 19:32:23 -0800 (PST)
Message-ID: <61986c47.1c69fb81.23b87.3a6d@mx.google.com>
Date:   Fri, 19 Nov 2021 19:32:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.3-21-g9f5b4a585c82d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 136 runs,
 1 regressions (v5.15.3-21-g9f5b4a585c82d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 136 runs, 1 regressions (v5.15.3-21-g9f5b4=
a585c82d)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.3-21-g9f5b4a585c82d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.3-21-g9f5b4a585c82d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f5b4a585c82d545acbc198579edfa8991532019 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/619833c5c97820e3e3e551d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
-21-g9f5b4a585c82d/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
-21-g9f5b4a585c82d/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619833c5c97820e3e3e55=
1d6
        new failure (last pass: v5.15.3) =

 =20

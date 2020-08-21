Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D7224DD6B
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgHURQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgHURQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 13:16:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D092EC061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 10:16:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nv17so1107086pjb.3
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 10:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mtfoyod7uGFIuHNho+Drfk0XL5H7OwKqjl8VjyCxJDA=;
        b=dXXYBHyEYyVHoV4GJjUnMiDhlcwd/q2yUJ3DokmHFfrs3b6jqh3IzJX7pv8UEwwYXu
         R4+qlvtYgWI7OjocZU3Znlzdx7hdvGpmdUHGUnR3aqD8c2sOKlkjqwnC1kG9PzJzFERB
         IJOpFpVtWiacA7ZOdfw/a7FgzwjaZW2sAXE2bUWr77cMQwlrxEIFlq+O/aytgjH3bZkl
         CeGh7jggUBRMqIMV+PSVRe8Ul+933nrifc+Q6d0N/wf9mrYp69/r+4dQK4MNUrQjgZZP
         V79RdNDEO9nWuEH4GHCn2IxG68SWs+wBt6xjyPyJuomm6Tnu9sg3SlVbee+v/ANAIR2m
         4MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mtfoyod7uGFIuHNho+Drfk0XL5H7OwKqjl8VjyCxJDA=;
        b=mS6h2SLmmLM7AolcQGg/zSpJyGI8uxql9BPYz1VEjU3iCvk2mrbtquLEDER64GCk/c
         IkSo1IQgumzectoL96rdbJa9t5/jo0ax3FNz/wXtx9nogTf6uMh3ja+yVsCf1JjXKFag
         V4qqvwkI3/Mvjyg2lImZkogCGuuxwwKak+G2I1pp3e8PnQ0K8ieC3B/xWroYHO3RoeLe
         mAWHtJFfIvCxckdTh4hgNhDiO6kOA8ZKAOCLJOZjanwwRle1A28qYYs09iwKi8FWDlBE
         eBUGbq4H+vWlNMl4XY+wCT5xu+owVDJ4DFHgE1/ijBXl6Z60uy6wG09b34qd7f+Zkvw8
         gcug==
X-Gm-Message-State: AOAM531avJNjrWhoMTNSgAaaWGbqGR8crLBIwJVw4+x+TfgbUii+6LBA
        PvGzBSbAmaYtuKjy+93oSi4S8ZY90cwDrg==
X-Google-Smtp-Source: ABdhPJz0ZN+ToMj5CFgQfLzQe7/1oYz2aQu7YgpG0kE1oi2nF0YlCRSz47nPR03+oCU9yfwxnGf98A==
X-Received: by 2002:a17:90a:ca89:: with SMTP id y9mr2747858pjt.108.1598030207497;
        Fri, 21 Aug 2020 10:16:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 131sm2761430pgh.67.2020.08.21.10.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 10:16:46 -0700 (PDT)
Message-ID: <5f40017e.1c69fb81.76c9.759f@mx.google.com>
Date:   Fri, 21 Aug 2020 10:16:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.194
Subject: stable/linux-4.14.y baseline: 166 runs, 1 regressions (v4.14.194)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 166 runs, 1 regressions (v4.14.194)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.194/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.194
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6a24ca2506d64598eac5d5219e99acca9bde4ca5 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3fca01aff253c8619fb442

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.194/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.194/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3fca01aff253c8619fb=
443
      failing since 140 days (last pass: v4.14.172, first fail: v4.14.175) =
 =20

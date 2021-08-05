Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000483E1E0A
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhHEVgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 17:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhHEVgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 17:36:13 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B8FC0613D5
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 14:35:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so18164828pjr.1
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 14:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wb6b/A+unwTHglebUbAOyH5ckQqnEV1O/EdtaWbGej0=;
        b=uLMe01R/91xc7aRN9SWVq8e7VqcZps7Jam2nvVDHE5q3DyjJGp4F9XjfM6Dlf16BHS
         TP3JJ3ICV94KAwgxuODf4Plj7+Ho6E91TV1caLdz6JOYVBS7AwEQCrULLroozt1dvcwM
         0N6U6nYFd8Y7wMMRFap9fXSgD/Djk20IJIx++YJ5/gVmEbL6OBLrxrjcOtkLi4TdzxD3
         fgJPCxAHBXxjpx5mbCp0waVLn7jl1d5tInGv6SgL/vR68/5FTDqCPECnZf1z42k618gA
         XyALIKPVe8/l20qOTMcP6BM6MBZzDPtYNcDnBymvc6h2VaKq/+A0XlOScFww0Ky3TgaD
         UuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wb6b/A+unwTHglebUbAOyH5ckQqnEV1O/EdtaWbGej0=;
        b=fvjP4gf+2RD81XFBsIuRBhC+0vCVlKEKRb8w2tZVvHJUM7Jt1C713XZhOataYjb0BC
         huZTLlanjOk+/JEoLd65ybKmXZ6pdfjz7Lvyk6UpH1m3aAtWcI99/4+MLVka94VQCg3q
         Em72vHTihpVEvjywmjXNrtgvu55UpqRxNFyl6UfqTTHyJH8JlCx6i/iIClcwZ98Hgbb8
         gS7uAkmjWCXJj0aGZWhGkmEL8zyU6JyybRUilxKAqyuPB9x39f7nLhg9s0gNBCrNlHXe
         zXM/KlFfjKeFu+WvXz2n9lBrMsASoqMR5KnvIVv8XG3y+cx/+YwCuwLZ9KcY3+AOduMp
         COHg==
X-Gm-Message-State: AOAM5313cHVTZuFetgE48vwFNKSfaVLx7vp0ZGUbwedUolKzG2bImjKp
        tQ+Ryb7S414UUK7kxOJXvmmla2KJAM0cHPka
X-Google-Smtp-Source: ABdhPJwsPqegf4nhAUMeP3W4p7Dg41eiVXy9jUw3EA7Qn/uyS0r30mPVRgtdx7Ed+3D5dZ6HnCJ7+Q==
X-Received: by 2002:a65:5ccd:: with SMTP id b13mr325953pgt.203.1628199357233;
        Thu, 05 Aug 2021 14:35:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g19sm10470671pjl.25.2021.08.05.14.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 14:35:56 -0700 (PDT)
Message-ID: <610c59bc.1c69fb81.61c8d.03da@mx.google.com>
Date:   Thu, 05 Aug 2021 14:35:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-31-g806b73d1fc53
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 120 runs,
 1 regressions (v5.13.8-31-g806b73d1fc53)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 120 runs, 1 regressions (v5.13.8-31-g806b73d=
1fc53)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-31-g806b73d1fc53/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-31-g806b73d1fc53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      806b73d1fc535d2d4cac248b7aeb1ff299fdcd88 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/610c27b8bc90cb6075b13689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
1-g806b73d1fc53/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
1-g806b73d1fc53/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c27b8bc90cb6075b13=
68a
        new failure (last pass: v5.13.8-31-gc1a06c46ed3d) =

 =20

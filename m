Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19125317126
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 21:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhBJUTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 15:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhBJUTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 15:19:34 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB49C06174A
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 12:18:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id fa16so1785648pjb.1
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 12:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4y57y2LLtRWyPpoZLzXPI9+Em42SBB3cshoRB3jXBpo=;
        b=ISbJmtG0BjaaGcWikZlW9OleFixQf62KEG2PeULvEnEbWtIBLTeoO1kFNm0N07gKZV
         Agxg3HmEb5IcYln4vmXn0aMrThsj+7sOsjAIArWYygeHKyQibvUlQ3LXSjAMhxInM+N5
         l1ASqcegmv1/TygsWtJL/08bad37gLksYscZoL0jK4eCXHIBbrpwewJHKBdAw/xFkjBn
         YnIBB5IJqAsW9t1ZDX2ulbcKyfnnPZgL0QE+JcavlcI7PXjGlPDHUId0PCcbkktJrYBS
         oNf4bmuA/v3EiY2JlHEr216rJDmffwM7KqWCLg4/CREKp0RQ8iGXF6Vbs4Gt5gqYjRQ5
         3HnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4y57y2LLtRWyPpoZLzXPI9+Em42SBB3cshoRB3jXBpo=;
        b=i/G6gu9i5/cMcg5UYoHrJtv+WKbn6Sjgrol62yTDrKOpyJ1mqyIE4RxShiI/vQLKKN
         4ZQeTF71SxciGOfEhouMIbgzph0EvIF/qxmzXDxZrg2TP584F3ev6/ggCkl3X4zY4SWe
         2wUtlbcvu9HXZGeZmLnB/Ypblz0JudYnKLHZCUVTcn4yoUI+4iZ5ERsB5QIlUZ9V8ye+
         1pY0sJ50h3XHzg3SZZpPhl2iJ67Ol9PSCKJJjTkZ2gcMEvEmgfYeb8UbYdgDQ2UYTC1G
         3dA+4wRL3WUYcZWS1hIZpyIcxPnM1ea38t8yQstJJxLXauCUqosmM4AJ8ykv45AQp3AL
         ZAWQ==
X-Gm-Message-State: AOAM533JBFWMNrYX7FhQRPw+qOnUqf1WgqKNAO9qWG2hvmBQ7pWApnm+
        h8ssg8fgTpmccGw2oqVhyhNO6A8EzGKTOg==
X-Google-Smtp-Source: ABdhPJxwv+eyTxY4rQHIohLiIi/CxFrl+a2hWxnqn2/YgXeeS90gYdgLCBx8LeDcZwUZWio1rZeqmQ==
X-Received: by 2002:a17:90a:8c08:: with SMTP id a8mr577946pjo.179.1612988333864;
        Wed, 10 Feb 2021 12:18:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm3169658pgb.89.2021.02.10.12.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:18:53 -0800 (PST)
Message-ID: <60243fad.1c69fb81.48f39.6e74@mx.google.com>
Date:   Wed, 10 Feb 2021 12:18:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 41 runs, 1 regressions (v4.9.257)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 41 runs, 1 regressions (v4.9.257)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.257/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      282aeb477a10d09cc5c4d73c54bb996964723f96 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60240cff22ced6fbd83abe67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.257/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.257/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60240cff22ced6fbd83ab=
e68
        failing since 83 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20

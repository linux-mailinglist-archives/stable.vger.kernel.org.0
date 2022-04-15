Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0F502E7E
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbiDOR7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbiDOR7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:59:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EDDDB493
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:56:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso8870089pjf.5
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hkbYBO7LMeKrtP+Kogd22Kazr/RF06FCFAUuE9noQSE=;
        b=gJ5gfmDeVyjufQvf061kBrSBmBcRi6ZLuDXlZR3+klgIyt5rfyTa+cjA3MPJ1PDOtj
         xCAXF/AY8M1Z21s9vhv6pLYrYR+8ZVFfNOO5t3cuXy6Ern7IDjMUwjs/wxKRXTlBXUYP
         y9oAr/w41aDlmTpNxwGrN9Ui8vnatUiGXVf4UteXycuXN9wCWJZK7DjqQm/FX6fX3mI6
         0lypO/DOrOyadeKLwk7f+R3mJG6O4UcgtsRlRhwbwZyBoAbtkI1nTVRlRnWagrvImhPd
         /0pykSQeEQn5EP7435T5X1wo7aJQSQKBznXMf3+DufaNYNxFk5kbx5mIYWFbZNAgNHCr
         apuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hkbYBO7LMeKrtP+Kogd22Kazr/RF06FCFAUuE9noQSE=;
        b=U3iwPuY4mE6KcmVUtTeDd6Ss3ryBR/XnhN5/fh5aRSUZPyJvC+M0NSoasYgcCP954J
         4fvQdg16hH5BO1jV3hHPzHfomjgaOBkiY3B6OjHvpFgfY8xS0AKr7gABSNkLRuVWJHrm
         jiEA0UfyqTEjTrNNsVBth8jQk1zvnus90+EcFsu0gLChPnbYt4l2ifS4j2rNbxGQ49t2
         M8hmpN8M4ESSUCvq+g9BMSrhqq/6XCdI+0d0cPLYs1yBGX3VjdwJdRHVxqlYWn9W8LdS
         zsFbhEapFckfHfYcL70gT54pxevBE01Oy40ZUbxqAXRfJwMXROF6f/V1AnpdmGFbHM1y
         M/Mw==
X-Gm-Message-State: AOAM532Lo5Htyr2jxvQlJJuUySduMOLe7udEczBFFGyh+GTJ/t7kMmlx
        5+U9v4ZJWW9AL9TV42PQhqmmBngpBXaoGVMO
X-Google-Smtp-Source: ABdhPJxht+enw3t26hV9HdenIyD8upybOKmXmLnnltJ0ZOscKHvOF5qZdMPYnU4f6WBZXiR9XJKLhg==
X-Received: by 2002:a17:90b:1e47:b0:1c6:d5a9:b147 with SMTP id pi7-20020a17090b1e4700b001c6d5a9b147mr22412pjb.223.1650045401869;
        Fri, 15 Apr 2022 10:56:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090ac50500b001cd5ffcca96sm7510475pjt.27.2022.04.15.10.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 10:56:41 -0700 (PDT)
Message-ID: <6259b1d9.1c69fb81.448c1.4018@mx.google.com>
Date:   Fri, 15 Apr 2022 10:56:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-201-gf1812046b492a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 1 regressions (v4.9.310-201-gf1812046b492a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 1 regressions (v4.9.310-201-gf181204=
6b492a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-201-gf1812046b492a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-201-gf1812046b492a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1812046b492a285de1821980904db86eac86e8f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6259838620a1d3d4daae0683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-gf1812046b492a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-gf1812046b492a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259838620a1d3d4daae0=
684
        failing since 9 days (last pass: v4.9.306-19-g53cdf8047e71, first f=
ail: v4.9.307-10-g6fa56dc70baa) =

 =20

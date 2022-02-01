Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFBA4A587C
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 09:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiBAIZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 03:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiBAIZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 03:25:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB94C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 00:25:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so1966373pju.2
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 00:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fj4s4UA/WNUCb9qZ9+nWPry8j55d18y5VHQyf3l+T+M=;
        b=BeB4zo8vI/8pmk4ItXChWndWpVioabxPArjSeouiNPeQl3Kr+B7vstRD/pMrK4CcZd
         HcDknRaJ7oj+bcrrfTnqdiwZ1IQoR9yVnDEXaqzdtj6NUN/fh0j5r8GtS1/OwcnCEqPc
         najuOWg0yxVQYj+urUa6PByvKLumS10JxjExtRF1hs4aKFqUDHIajIBxJDnY1MY6gxjS
         E/KbS56VVREUNdXmHTwyKBRaFFKXIqY+Tdd6vw9ovjfkWyXeGgEh7wae5II2NjTTVFL9
         AnNtYlO354VRSf7EMzmT+D9x/CffwV3gLxF1iRECHLYK8ZQ+ujfJFegSwOeXphiAQ6zZ
         GRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fj4s4UA/WNUCb9qZ9+nWPry8j55d18y5VHQyf3l+T+M=;
        b=zRlq3pT5tgz7NVsFR/upt3HARFb7eBMzejOK10GarmBfrwa4LusZ9QfExytVTqWEEL
         /RTaIC8Cdy11Wpic5pVj/MJAn71vCdQwTwyJvLIUOuK0Epq5kXB4rCYgEZSWq5ic3KuD
         YgW9DwDHcbuDpmqurJfA1RZ1ZHbuDuE0LNdDiCNWki68+8t81Rs+kRxXBtyPtNz54+dl
         FvVzuob+NAbge/JtIElBD4nhr0+lDmhqFKOK1nKKS8ZoQ1jgjqdLF14sI/Eg1h8+g3xX
         RZrpyIBKljijPImtbjn8ZsErWjO+DajSWlYo6wo/WHQ19pMWOwlQJwvNG14ofqzVKmCh
         bvfg==
X-Gm-Message-State: AOAM532zd2HgVoI7RqSsSJnT9NaDj8J+K8CUPehvX+J9wbRC9MaMeu8W
        CL1VwSso4R8sSRVjady9WLPrhFiof2C1vACZ
X-Google-Smtp-Source: ABdhPJxN4tIhX/hO/7l2+fIkOxZe4xj2Us/uaU2eOJtOM5uEu/a1mZp1eVEEkooPV+ofirnMbth/8Q==
X-Received: by 2002:a17:902:b692:: with SMTP id c18mr15475759pls.51.1643703922502;
        Tue, 01 Feb 2022 00:25:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm3404223pfp.181.2022.02.01.00.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 00:25:22 -0800 (PST)
Message-ID: <61f8ee72.1c69fb81.fd336.8f0d@mx.google.com>
Date:   Tue, 01 Feb 2022 00:25:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.18-171-g8324c2911e04
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 109 runs,
 1 regressions (v5.15.18-171-g8324c2911e04)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 109 runs, 1 regressions (v5.15.18-171-g8324c=
2911e04)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.18-171-g8324c2911e04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.18-171-g8324c2911e04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8324c2911e04ee29473d5a395755aeb2699fd165 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61f8b78d99c4ea460a5d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.18-=
171-g8324c2911e04/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.18-=
171-g8324c2911e04/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f8b78d99c4ea460a5d6=
ee9
        new failure (last pass: v5.15.18-153-ga1f52b5c2fc8e) =

 =20

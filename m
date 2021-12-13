Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5DB471F30
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 02:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhLMBqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 20:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhLMBqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 20:46:07 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84551C06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 17:46:07 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so13521667pjb.5
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 17:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/DyDnX73544fg8e2wrYyG90K8BWTjq9AABc2gWoLpYw=;
        b=jwooyEOZAXbgX+1XzYhBi/+bWtYq9N21j0Mhwmflhj2wueFgg03fZfoyx5kYlsE3Wx
         8k7C9Xcbs1f0Y8iT/JGVPunr9KSdUS7wrclcT3lWFuoqhkRicJZAebb4a+oq/LnGxAxJ
         xYZSQWWwVH8dSjOEEUmwIGzDiYT5SnB7JUd4JWkHKffv57QZhiQfT6YeLVfdzzqsVmZh
         W0jMk5//kVvvaHfSK8c0ADWTFZgpPq2Ud8Ye595m0WAyztFkC58t10Z1fR3tbVSpNMoY
         c1COmxpyoSmRoEj8qF+CfZUrPBF1zNu1O0aCZkjITZ9wAgnf5aOQL8qqEiwsU43eeDRH
         OOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/DyDnX73544fg8e2wrYyG90K8BWTjq9AABc2gWoLpYw=;
        b=Exf0aZB9EOoMXFyb5puI7UbpjJNrZJscsmjXRqZOhJ8sOnfYPJaZIqTaqNOylo11dx
         une2lnJF1lajB1qABy7dX43/++rzM5Jxidx+6aMd9Lf4a9PqXaumIe1+1CZ9774rSVx+
         QDzj+2gGJxT0nc7rgTkT3pf+iAiQh5VGhAXtmO9VcjJAgdREmqSNtSk/NGcSwjoIGWm/
         y+hP4qTTy4It7OVgOaey9B60nMggipqqv+mgHikn50jDPCOrSbwUafGtVBGreEbjfEDn
         I62OaWYAUmQO3+Jlseaxl1TRbkAUYBqiVxDTqIHVQpo8hZ9+YTKa0raTNIRrtAu0olPz
         RvZg==
X-Gm-Message-State: AOAM530IprTPU+qYHVyrMP/5AXEWa/dam3UIPE1KNZ2x17W+/FhWDECZ
        z6d6CHZs81m6sNkvsbXl1fPbjdV//Eirb7Xx
X-Google-Smtp-Source: ABdhPJyB8FhCUCHDoLbHURxPecrZ5hRmIuG047yViz4PIake4TkGf/31GZAW9ltXbka/zCVyLx5ZhQ==
X-Received: by 2002:a17:902:7595:b0:144:ce0e:d42 with SMTP id j21-20020a170902759500b00144ce0e0d42mr93045706pll.39.1639359966751;
        Sun, 12 Dec 2021 17:46:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22sm10055458pfh.111.2021.12.12.17.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 17:46:06 -0800 (PST)
Message-ID: <61b6a5de.1c69fb81.73068.dde5@mx.google.com>
Date:   Sun, 12 Dec 2021 17:46:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294-28-g4af7e373e6fb
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 129 runs,
 1 regressions (v4.4.294-28-g4af7e373e6fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 129 runs, 1 regressions (v4.4.294-28-g4af7e=
373e6fb)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.294-28-g4af7e373e6fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.294-28-g4af7e373e6fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4af7e373e6fb05e868915c64504303b486443864 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b66bc1d90b189cab397151

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
-28-g4af7e373e6fb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
-28-g4af7e373e6fb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b66bc1d90b189cab397=
152
        new failure (last pass: v4.4.292-160-g026850c9b4d0) =

 =20

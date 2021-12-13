Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB01473500
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242252AbhLMTbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242411AbhLMTbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:31:04 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3284CC061751
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:31:04 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id q17so11883282plr.11
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pdcK5touCCOkO/5kLL3qQsW2NZXmcjEWTttDYNIoViA=;
        b=hORfbZpHYl8GBttwshkE9EvlXpEuAnCjIXvyrchHffH3wfLJLnMDrKqzJoCJqud+MG
         dsLn4eVbOqM/8BiydsaCsBpYVrXSCovCje3PIxNAjes7FuIq8SHvg91Wx3iCBpjYFhfO
         RV+weubd3Wr4OjkQSmiueMQE9OB8hm1gLKOV6qYQP2Alp59vsXwx5rjCCu2cGrvaPF8C
         S9pOvNNT+NuFAaMPFD5tppyOE8mk2ORao6ynFta05f1yV1+vl1xndwDH9PHO8ZTvrqDu
         WNq23htD64AVTJLzn1nPff0rPxiWL8Gyn7VXwnc7yHoineLS9d/my62j+1cLr91eZGU2
         XeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pdcK5touCCOkO/5kLL3qQsW2NZXmcjEWTttDYNIoViA=;
        b=b9Bjw+o42c0YUbuooWweqrd8qfrQURcSX8XWLjaXjvn3JdqWMOMmS2/0CnednCv/1G
         Hwutwx3L06UOeahWzf7AIZLNTBFbQS4bOn6hAnz95XuP5KV2axXsoQiuND4Oy4TBG+m9
         TuNs660xjsXyGnpgXA+Gs0IYdzfDTGSmEKTM+TBTkIDWtAD5bfi7U4laSpm1ZTk+YnVf
         URoSWH/SRk8riw6RrKwkshUwDxvx9TSvOVgNT/xVkFOKekmk4r7voPjDNgDUEh+bBIx7
         Cyja6xBEi6xQpm9tsYAq2ToQeMpeI0SrMmxpOoQeWNjMCbSHtWP+8vQnylNiJgkJ7rF3
         3CNA==
X-Gm-Message-State: AOAM531TnwKjkR3fkt1NMUAZV9tgK8BpvwmCExr6WGcfSK8vT2+PYpMe
        RgbXM616OVDkmkHwETapjXork56osjOjCv1t
X-Google-Smtp-Source: ABdhPJyv+Vin6EtgE29U/y8EkE8jSUuoob2kVcfPw2W85Eij/Jpf27kqEcwJlyptuGvKO69CMH5rZQ==
X-Received: by 2002:a17:902:7007:b0:143:c6e8:4117 with SMTP id y7-20020a170902700700b00143c6e84117mr12470plk.55.1639423863527;
        Mon, 13 Dec 2021 11:31:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm12257968pfv.37.2021.12.13.11.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:31:03 -0800 (PST)
Message-ID: <61b79f77.1c69fb81.f0b6a.32cb@mx.google.com>
Date:   Mon, 13 Dec 2021 11:31:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164-89-g0896ccf90364
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 195 runs,
 1 regressions (v5.4.164-89-g0896ccf90364)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 195 runs, 1 regressions (v5.4.164-89-g0896c=
cf90364)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig               =
   | regressions
---------------+-------+--------------+----------+-------------------------=
---+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromebo=
ok | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.164-89-g0896ccf90364/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.164-89-g0896ccf90364
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0896ccf9036401df1f284b0a02b954d71d071d74 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig               =
   | regressions
---------------+-------+--------------+----------+-------------------------=
---+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromebo=
ok | 1          =


  Details:     https://kernelci.org/test/plan/id/61b76ada79cdb49a4639714e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
-89-g0896ccf90364/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
-89-g0896ccf90364/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b76ada79cdb49a46397=
14f
        new failure (last pass: v5.4.164-89-gc50f1e613033) =

 =20

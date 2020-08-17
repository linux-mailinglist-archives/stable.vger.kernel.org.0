Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EF7247808
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgHQURw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHQURv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 16:17:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559FCC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 13:17:51 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x6so8631255pgx.12
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 13:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mgtlnPkRj3lQG3y6TZ2pe3wWsxC1GD4RwAgaPwaiQvk=;
        b=Pn2EwY4RG+bDcgFjP2nAoxHIsPNKDjojKyTU46Uvw7ebic+lflr1GefLLHCOoitm3h
         Gl6ugOU7TR3cg1+SRwyoeYl4NXyWd1EoMFYD6mgoeDbeC24zQP2UNEk0czBYt2L2MYja
         TjFBhubo7dG7GdxjoFKOh/1g+V8K4FUgV2rvNRiyP9SznFlqzD4JWNn2KmW5mo4rPE1l
         VUnNX4tOj3D41Y14tA93+8ySEQj5JGzk/qGb3hZz/24aGn7gSho/Z8kwZ9iMicBgtLb+
         a+vUKSJYsENMs2eHTcWVdAJ4yg7zPB4Q+NM2eTV0YB61NC6Dc/q1HXtHUwZccvIQj9oZ
         mGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mgtlnPkRj3lQG3y6TZ2pe3wWsxC1GD4RwAgaPwaiQvk=;
        b=LApDowKY9FmKzX7MqZIdVouZOGi+nrb77J9va0XfxVodQVwkn/P6B27MCwfELFx6FN
         Hs5e00q2S7iPC6yWl7K68wt1BlCyUMy4lD7gckPODwkJpWJrgIIuMOFqBU9HYU+vYbOB
         phzBbgwxSvDnY6lnTVxQ87PgAvAHT6SLMgyuxPnEyosa4fKcy7cA5Gb314CSBAqsRbxv
         orbtRGldZuJ5bqtFgYlvLB90kQja5weeqUkfzxYFQZ62eQ5J5LoYvJccdIFgRhULNmPx
         r/Kd3OxaI19Sedb9NjPeksPA9WT/iNqFsKEA8p1eDwUKQclVNir/WhmYwWNUhkG/8WOR
         ALeg==
X-Gm-Message-State: AOAM531OuquKynHKIm9Y9+RhLsDF9Zj0xb6Kmw7iF8DkqShcM22J00I8
        mVgCxU457ZSvwlAGc7WA9ntH1rJR/rMYLQ==
X-Google-Smtp-Source: ABdhPJzqkzNlhE1sfURV5sxOczifmGvzNnz7UEpSI0N0YH+pnVZgRQqRFjF3eEFVP+009AsVETnl1g==
X-Received: by 2002:a63:b51e:: with SMTP id y30mr9795673pge.395.1597695470008;
        Mon, 17 Aug 2020 13:17:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k23sm18648286pgb.92.2020.08.17.13.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 13:17:49 -0700 (PDT)
Message-ID: <5f3ae5ed.1c69fb81.b5996.9cc1@mx.google.com>
Date:   Mon, 17 Aug 2020 13:17:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.193-166-gfe2a5ed20494
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 164 runs,
 2 regressions (v4.14.193-166-gfe2a5ed20494)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 164 runs, 2 regressions (v4.14.193-166-gfe=
2a5ed20494)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.193-166-gfe2a5ed20494/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193-166-gfe2a5ed20494
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe2a5ed20494ff57e6c069583c0a92fb4136feda =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ab2b0db185cbc83d99a3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-166-gfe2a5ed20494/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-166-gfe2a5ed20494/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ab2b0db185cbc83d99=
a3d
      failing since 24 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3aad4ac79444ab77d99a47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-166-gfe2a5ed20494/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-166-gfe2a5ed20494/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3aad4ac79444ab77d99=
a48
      failing since 139 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A129429ECCA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 14:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgJ2NXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 09:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJ2NXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 09:23:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3A2C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:23:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x13so2321762pgp.7
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H9Iav0tpTgYAJ+fu0i/Ys9UyfFz7xe6Sm9y3u2ZIjUY=;
        b=XjvXA6F0MLFNpQx4ZkgHa24/8/mrj8K8/q3PFeUmxqlCuccva4bkPZONu0Z4CuZTBy
         evgPD9l2FyNDsX49Ho/XKOBAMLmF0tBTcpTmmPbda77nFcCB6MMB17bq0by98yh716s9
         KWXqpbFTkWhVc9Jr1AcQFm+WJVFndACVsr3deJFvyKeGFtHdUaqyusVEfnXgCYWQPtqx
         9iNXK4L5RK3DoiEbFC5qM8x28VXn8SDhalbaIg1clGC1XZpyPkh9kkkdu6eg2D8r8+ET
         xjsdg20ghDfMFaCHZRSwmwcOVKMNnk5LF6ey/LnRW3737IHiw5suyCNYDuLWRdUt9miz
         A6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H9Iav0tpTgYAJ+fu0i/Ys9UyfFz7xe6Sm9y3u2ZIjUY=;
        b=PLkkMsOlHEPc8PTMH3dIyckNwI+iBxqEK9dXWyR1JFhtmS2aU8U3J0VwyM/GgODE9J
         yzuWaeCIqSMA3uj3W3TE42XIA6n3zXwgfXqYD8HmxTrHTtkG7kzU931HAVxgR5y+XlP6
         Oi3J5k5yaOk7t8evZ1eCjE9Lp4XNvWpDLOFmdpSKj+hpTYgpPWKAGknN1BH6y39fJhp/
         N4CItqHMA9hMOySHV6xAaHpsouuDzepaMgnfaUG1na4hqmoeNyi0mSFSSf1/4ofaW3pl
         723XsOwIa7+Xmf+znG2pg2z5OGE/i0Iy8h/BjnQub9GDFWCwBSTj6rq4d6ouogIbn9jS
         z2Rw==
X-Gm-Message-State: AOAM533xZE44QuhPQBm/5JJWlYv6IS7AeurGgL/nDivsQARDcrircodA
        Ptfe+iAnk8/Vl4lKNjyrf5ebBbKLURHEQA==
X-Google-Smtp-Source: ABdhPJzJ5jrBH7ppFGzIimYLKOplO7TO7GqS9nv8ywlg9JmTg4ObFCm7Fk9lyQXgtMDxvj/w4mwYcA==
X-Received: by 2002:a17:90a:10c1:: with SMTP id b1mr4452001pje.58.1603977819161;
        Thu, 29 Oct 2020 06:23:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm3122753pjl.45.2020.10.29.06.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:23:38 -0700 (PDT)
Message-ID: <5f9ac25a.1c69fb81.3e585.6bf2@mx.google.com>
Date:   Thu, 29 Oct 2020 06:23:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-139-gf340d121834f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 147 runs,
 2 regressions (v4.9.240-139-gf340d121834f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 147 runs, 2 regressions (v4.9.240-139-gf340d1=
21834f)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-139-gf340d121834f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-139-gf340d121834f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f340d121834f9f6736ff655ff2c4c2d0c08082ac =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a8fc453df6f07df38101f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-gf340d121834f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-gf340d121834f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a8fc453df6f07df381=
020
        failing since 0 day (last pass: v4.9.240-139-gd719c4ad8056, first f=
ail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a91731b6252d08238101f

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-gf340d121834f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-gf340d121834f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a91731b6252d=
082381026
        new failure (last pass: v4.9.240-139-g65bd9a74252c)
        2 lines =

 =20

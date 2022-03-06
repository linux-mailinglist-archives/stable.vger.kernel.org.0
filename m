Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E2F4CED90
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 20:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiCFT7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 14:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiCFT7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 14:59:03 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD41F65C0
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 11:58:10 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso12325019pjo.5
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 11:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZkUebEAxjd3bYiVE65yH5pNbbLO+/qZaVWtTdwXZflE=;
        b=tgb283GOOOVBcBhqDrtgfTsDW9chVwGqN3i59snh0Ym1nfbwGRBwtsoW4PFuF6jPAU
         DLtAXoeTenrY5BGv9CLWI9XcNgUWzI0OAbALewZCSlaOa+NSOHZ2M3RGCDkIMPx56RD4
         a4MEjSDsZbogRhCObvyezFxWO+lqx12OtMfLdI7lwnmAsw8PXcxZJhryON65QjYWl0wY
         V+iO6w7QRaskHq6XkHWyBUwvMzfzXPGWMnEHR/InAyIQVGT7TQRJeWKDBOWhOkmjr6wh
         ocyXElal9zeF9x8aX0ySYAAgFFDd7psxnug8riZXDsQuewnpU5rp0d934yQSVkCvwZiO
         kk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZkUebEAxjd3bYiVE65yH5pNbbLO+/qZaVWtTdwXZflE=;
        b=QEzDhWmBiReyYdmoDoYJ4r1b3832RG0ex3kdjzoexioW/sus7/Ch3iEA1eE7XFTexV
         sDHGXjTLkF2P+Q65wRZYT7hlV1Qx5hZFP+3nqkCKnolAfgPRFlPIq9PlAMGMNdi4r79Y
         +l30tFA0WbJC0SqyRl/EpK+inQ1bPSWYhZAAl1Lq0+H0vl39VMnc+fPhz71gE2HhxjVP
         ylgivt3Nhf4bN7KRZ5MwVb30GGygtaqq0VX/o0/WQuc7/Ez1Cazt2rxIm8vNPNeaeTNy
         nOmA5H1IjRjmAP4EJtYAI1Z3L5H/wUyszCsu0IwUEXn3LU3gqvfxGZZoQFBNe2vFKfNL
         GKeQ==
X-Gm-Message-State: AOAM5333SLwwEsIzisKnNpjTe1p/RoQXpa2M/Tf6er2luw3+h+3Tgnj4
        2k3RVp0uwn018rHqudAPrjTzl5GT6x/3ULTJgQQ=
X-Google-Smtp-Source: ABdhPJwFTlH9JTPsxk76/bgHKA9t8kVtb7IoyjT7xFZVg6diFH6Jkmt5KDfmuEoozQAJ8x+Xnan+Rw==
X-Received: by 2002:a17:90a:10c8:b0:1bc:e369:1f2c with SMTP id b8-20020a17090a10c800b001bce3691f2cmr21443193pje.193.1646596690003;
        Sun, 06 Mar 2022 11:58:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v66-20020a622f45000000b004f129e7767fsm12431930pfv.130.2022.03.06.11.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 11:58:09 -0800 (PST)
Message-ID: <62251251.1c69fb81.d8e18.03b7@mx.google.com>
Date:   Sun, 06 Mar 2022 11:58:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.269-41-gb1792c331b0d
Subject: stable-rc/queue/4.14 baseline: 57 runs,
 1 regressions (v4.14.269-41-gb1792c331b0d)
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

stable-rc/queue/4.14 baseline: 57 runs, 1 regressions (v4.14.269-41-gb1792c=
331b0d)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.269-41-gb1792c331b0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.269-41-gb1792c331b0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1792c331b0d986583504489a758af553b7cecea =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6224db71d502893bd9c62990

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-41-gb1792c331b0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-41-gb1792c331b0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6224db71d502893bd9c62=
991
        failing since 21 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20

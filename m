Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A00639F65
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 03:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiK1CRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 21:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiK1CRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 21:17:06 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8381CFDA
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 18:17:05 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j12so8828216plj.5
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 18:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=szZaPVjXzqdoLucbUFmmGX7rFlixmOFWt1lGWBtWHa4=;
        b=RFbLZDeG7jgBhN5ztVb6MyFSO4DYrr6GuKA1fVQROitrS/t+v21QbB52ZvQ1c8zVqp
         6JJ5n/HsybVG+nyeajIUDCuEczPVfWOybhczdG4TcRVwFuHlqG6EkavgMvtEWTEhd/oX
         88aEjDLyAJCr28lrA8iU2Y1Eh7/qKFHPHL44l1aAlL7S6A+FM7PQfnX0/aht0454qVAA
         +LDLJXneoaOL0T8YMHcMNHU77K3zBqh769VrqHAj7cRvGgKNOShBwpCfha4jzU3RaTnc
         9/sHKWu+oFPojMfqpeVABEw3KJgrWolClztQAeOI3TTP8bkNQieaEeSLiRBmJjS+Wd6L
         S7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=szZaPVjXzqdoLucbUFmmGX7rFlixmOFWt1lGWBtWHa4=;
        b=pZymTU4PrWCH6IQVKPRkvxh4pnJF79J0/rHEGrw9YKImzQTbkyXzAeQbKm3vB/OymL
         2GNprPz6s1vvPACCmLmn+KREokZu4W+7pYyGwnMe1mPigTAOugYHCz4TC/th6vembNRz
         WMkxiHWieGvE+XyeRH+3BZM5+JX91H4YF7bts2CrzTg6ZDY3zujAv3T6GxRLf3SAKrym
         HjKIZSELtz53/MEtPSyu9QNSR3VMPhKurEtMwOhElYYKMZveb988mqs/3tNHPhK7d7YK
         LkTQ9urBcENqlTuUjW6wbPXi7TASAnGlMVii+e4KCwgxMTvipKOSAUhMzTZp9Ezw6zt8
         xjuw==
X-Gm-Message-State: ANoB5plwrFxvxLnRDH7bp/WzggItgefF5hs7vTu5QbJlTc5ZO5z0l2EJ
        C/cUI6a1p4nhDvWV4ue6vwt8Ho9hCzavocVt
X-Google-Smtp-Source: AA0mqf4MEQMozt61CBGpmnpCAu48Ua5HA6uw7qrYeRwSulFflvlF/XlRKrzrD+04oQ3Xnuee+44z8Q==
X-Received: by 2002:a17:90b:609:b0:219:3ad9:64f5 with SMTP id gb9-20020a17090b060900b002193ad964f5mr2123138pjb.138.1669601824744;
        Sun, 27 Nov 2022 18:17:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lt18-20020a17090b355200b002191ffeac8esm2876746pjb.20.2022.11.27.18.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 18:17:04 -0800 (PST)
Message-ID: <63841a20.170a0220.31f5f.3803@mx.google.com>
Date:   Sun, 27 Nov 2022 18:17:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-315-g0eeaab2cba8e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 80 runs,
 1 regressions (v5.15.79-315-g0eeaab2cba8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 80 runs, 1 regressions (v5.15.79-315-g0eeaab=
2cba8e)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-315-g0eeaab2cba8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-315-g0eeaab2cba8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0eeaab2cba8e281cf57a3471ece97e7a9811766e =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/638409907e9bf247062abd67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
315-g0eeaab2cba8e/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
315-g0eeaab2cba8e/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638409907e9bf247062ab=
d68
        new failure (last pass: v5.15.79-314-gf09f9989f237) =

 =20

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EFD6C3B11
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjCUTz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCUTz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:55:28 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928DA5257
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:55:25 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z19so6808933plo.2
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679428524;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/wUwxvW+FfThUfdWCfnXj78MTC+zyznEfwwlCcll78=;
        b=sKPpwpVwDcvSjMCFibi/QjkT59oMAqhZkxVl6BnNA9pgfQYS4EDuP2QjxEcodO/prf
         Yq8R880DJ+geg540r1HXawIJel6uOC480AwODyfCWVjspuGhir70JYsDG6573vXNJ+Ci
         li3efWJb1HmoSH0x0HGorX8eOk05wOKhqFhFu5ZUaYBhMAtjT8ohskhYYIuqsVZTqe0u
         npsttSUXQlOO34mcAZFigJNEtAx/eLfuAtHkDNjySiukuDnjNeJ0U9/4GVMKe1wQRjgQ
         1nTg2TeQ2VOl7WZGh3Ia1kUbV0vXXqwkyNLJDWaDdKYyq9EftHj8BtzkOH4OBi7MVXz2
         JS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679428524;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q/wUwxvW+FfThUfdWCfnXj78MTC+zyznEfwwlCcll78=;
        b=g8tAOiI5owgYXMI6PYNct6AC8pXHWjZBZtTJQ+AEay7oCF1ViWOeKID9t7D4i+3uvM
         vjxJwtEWWpGmMfStC9N7SOnaSxr1NaTsVJDV89247Mdg8Kg1BYvOyu2pLU1+ExRzBh6l
         kPXSB3Nz5bH+0CoJj1MFzYqRmM8lAqxy8vC5k1fcDZrrwX4BDtJyMvqebnoQ7u3VkFMn
         InwHumYd6hALKIFtbkpTxoAm/4x/pFEQQ78X/BceyPFiSLoezc4V2AM2fTZmvW/OSewI
         VfVelFaJGYCRdl56iRxiUqvVgp4PUylVzcURhyxjTLW/6NMfKErwcY9rerDCJBmYamXT
         PsGg==
X-Gm-Message-State: AO0yUKXwK538lJa+mjKPjj4tX80oLwhAhN+XsUXjvNobS+twfsHmP4cJ
        ezXWs0iwz6AI25wvq20Ro4XF43R9Ut/35RS+JQfPXw==
X-Google-Smtp-Source: AK7set9lipDyYxYYXFvZIllDRm79g4f91lxs09dzuHKF6D+V4r9tQKqLMTd1M2/ClOK0IxAYQG5xDw==
X-Received: by 2002:a17:902:dad1:b0:1a1:9fa4:1b18 with SMTP id q17-20020a170902dad100b001a19fa41b18mr344531plx.19.1679428524070;
        Tue, 21 Mar 2023 12:55:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ji17-20020a170903325100b00199023c688esm9166918plb.26.2023.03.21.12.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:55:23 -0700 (PDT)
Message-ID: <641a0bab.170a0220.34137.0ed1@mx.google.com>
Date:   Tue, 21 Mar 2023 12:55:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.103-115-gac0c67f7c475
Subject: stable-rc/queue/5.15 baseline: 179 runs,
 1 regressions (v5.15.103-115-gac0c67f7c475)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 179 runs, 1 regressions (v5.15.103-115-gac0c=
67f7c475)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-115-gac0c67f7c475/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-115-gac0c67f7c475
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac0c67f7c4752d245e461a5ee01fc9efbcd1d7af =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6419d7ece0b8c993519c9529

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-gac0c67f7c475/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-gac0c67f7c475/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6419d7ece0b8c993519c9532
        failing since 63 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-21T16:14:02.941762  <8>[   10.005871] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3432201_1.5.2.4.1>
    2023-03-21T16:14:03.048398  / # #
    2023-03-21T16:14:03.149802  export SHELL=3D/bin/sh
    2023-03-21T16:14:03.150170  #
    2023-03-21T16:14:03.251362  / # export SHELL=3D/bin/sh. /lava-3432201/e=
nvironment
    2023-03-21T16:14:03.251926  =

    2023-03-21T16:14:03.353407  / # . /lava-3432201/environment/lava-343220=
1/bin/lava-test-runner /lava-3432201/1
    2023-03-21T16:14:03.354259  =

    2023-03-21T16:14:03.359099  / # /lava-3432201/bin/lava-test-runner /lav=
a-3432201/1
    2023-03-21T16:14:03.442260  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20

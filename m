Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1049A63A262
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 08:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiK1H6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 02:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiK1H6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 02:58:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B986B114E
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 23:58:52 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s196so9248697pgs.3
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 23:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3VwU9xYyf5Ctj9tKRjBfBg+TbCHdK2e7iSruCKBreKE=;
        b=wo3oqWC5D9sPRoo/AHVZR8TJ5FP6JPjrOw+WfV3zKmflY+6VQKfCYNjcrxNdcrMQKo
         2k90s9IBl8+Fj5HaHp5r1RfnevaUKsb/cbhhSuGO7Hvx2blw65DXbTMHs2daWSoHwF7J
         0A9I5Y+7IaQMJApBvId/WXV4F92+3sbpvUzcAHA4JPNsPS44mel/4QtUqo6AknMnRS12
         UQyGWANrx1DZSTueE7oaQ2TIIqOs6/M9jXPJLWWAvZ7vlhvr/t8MZ4l8Qb1H82ddP50/
         +jwzxg1ZXMamSuwrmJUZQLM7tiosGTDmMta/vDKSQg5NEJ8BkTX8WXNR6QdfkDrv4B4V
         nQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3VwU9xYyf5Ctj9tKRjBfBg+TbCHdK2e7iSruCKBreKE=;
        b=NdNAl6NAxbTpDgOH8dvkY7SwLqjgsuIIreAeqCpxNR4xcvhsLObVQp4Ko3mwOJVOTF
         AFg/lcA+nwXKmO4DdFrWPuYt+b4kM5ZgNakUajYqO6SMsG6ZZjH7aiPOu1yZIZufrkX5
         8KjUQgTFYduUP1WfbagPY0fYq2SkEIxVjHxQOYouy4yCnB5L9C3GvUSZyVYvtzDw5Zq2
         HoawQZWhI6GworRz0O6JPvKog3o+zOgdS4D+y9e3bHIs/SnPPLhizoJEQsVPgW1hdqyW
         CFdOILQIiQUvDrMHSsJjP9cwDSL08N9fLDCEoq7GqhaVz2Qcaj7tPUi3qX7Vmri3I79n
         bLhA==
X-Gm-Message-State: ANoB5pnIdrqA8rXdAgfSPXW+oLxmQvEW3V7jF7J9mqsbvrQdjMQCiNrn
        ixh/iHsKGcpXhTjer+yUktqURmHrABXenfWE
X-Google-Smtp-Source: AA0mqf4N1naTIs4XOEv4sn7saLyuvPO4aIcw6OwVCg9oN5tnsMmhfIVngm4n9h+SaXbSewezvB9uKg==
X-Received: by 2002:a05:6a00:21c2:b0:56b:bba4:650a with SMTP id t2-20020a056a0021c200b0056bbba4650amr31043861pfj.4.1669622331939;
        Sun, 27 Nov 2022 23:58:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jc21-20020a17090325d500b00189847cd4acsm2273681plb.237.2022.11.27.23.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 23:58:51 -0800 (PST)
Message-ID: <63846a3b.170a0220.9efcb.30da@mx.google.com>
Date:   Sun, 27 Nov 2022 23:58:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-321-gf8c75c7aafca
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 109 runs,
 1 regressions (v5.15.79-321-gf8c75c7aafca)
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

stable-rc/queue/5.15 baseline: 109 runs, 1 regressions (v5.15.79-321-gf8c75=
c7aafca)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-321-gf8c75c7aafca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-321-gf8c75c7aafca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8c75c7aafcabc296ff1004e653c9e014fbe2922 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63843b1d9f88a3d4f22abd1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
321-gf8c75c7aafca/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
321-gf8c75c7aafca/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63843b1d9f88a3d4f22ab=
d1d
        new failure (last pass: v5.15.79-317-g8fb5aa642f7c) =

 =20

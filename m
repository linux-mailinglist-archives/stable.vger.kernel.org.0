Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85593D7F45
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhG0UaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 16:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhG0UaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 16:30:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21052C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 13:30:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i1so17511876plr.9
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 13:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RaPsBWkwo5czoIwQaI+kMWQ3UsHslenhOWiatpoiGMo=;
        b=CHuur5E85dvV1M/uk668hRNXTtDT1weTAmBXRCnvS3KcTUlymnjpRpNi2Rjionh+gG
         j6US93xJ1utpkfiWfKGj9Yen1GaAprJYQvBLRTs0pn+SZahdlkN2Q1IUP6/rvYmqB9EX
         48R0d+ympFtaRvuoRmlyOjdrnCbURpWBJG3wCqqkWYsGHhGzDdztEam2RADowUzzKDG7
         rxE71dNQixFJciE6gyNHoY5bBdf1SKuHZWvThJ+X0US+byxcAZHeQ3b3IkiQ4kXWK710
         qCQLAl7y2/QJfDo7f+VBDYJq1mSValV3o5mptX4p/aCNCBfRsaaKLPmoblgoYnm0UZEG
         3uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RaPsBWkwo5czoIwQaI+kMWQ3UsHslenhOWiatpoiGMo=;
        b=oT7O9+8zDItU38X04Q+3FqoCXjgonDQa9ND9QHvVx7l7BoPWVD2q/pIZoxwCDs8TpB
         kAhR2fKvqgidzTXwEgQEtlylECgor3Nyg7v4Caly48ZfaFptZezt/pp/4HTGy0VdtRsU
         3oesL6Pr0ntu5/LztShWVFDgVw04hkpzBvMZ5KaAxngnc2IeiSoUYxVZQBdAwUndLyOf
         CnDKZ8c3AGWbhVPj3Gh7xbi7cLkmnIcRvWh7oWcklDMac6clo8i25E2axhn4rkmHAWP+
         jsE/w77UncZTtLw+Cs7wbFgDp9nP/3Zb+Q+e3nBc0xjGnK9Fzl6OQKEcmroZmWvYNvlu
         PviQ==
X-Gm-Message-State: AOAM533KNL2tgCiWMUFQmKjgKll/M4mTZBtMfjCpg0o8xLxczJgiDLX4
        QoyOXyiSBwZpl16WOXhUZKOmXej5v2y+N7Id
X-Google-Smtp-Source: ABdhPJwNOs8+2U/Z9r9kePLeHK8p8RBiZpSxZL9C2f8259D10GT3PFjZd2feCW2FeGqPuYXqkincNw==
X-Received: by 2002:a65:6441:: with SMTP id s1mr24778950pgv.214.1627417822041;
        Tue, 27 Jul 2021 13:30:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm4674755pfp.129.2021.07.27.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:30:21 -0700 (PDT)
Message-ID: <61006cdd.1c69fb81.cbd31.ee8d@mx.google.com>
Date:   Tue, 27 Jul 2021 13:30:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.53-167-g886572962bd8
Subject: stable-rc/queue/5.10 baseline: 121 runs,
 2 regressions (v5.10.53-167-g886572962bd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 121 runs, 2 regressions (v5.10.53-167-g88657=
2962bd8)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.53-167-g886572962bd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.53-167-g886572962bd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      886572962bd81d1f87fc32a8fbc74bcf4723dfec =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/610032a8dbde85eb125018cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g886572962bd8/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g886572962bd8/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610032a8dbde85eb12501=
8cc
        failing since 16 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/61003438346e7ca63b5018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g886572962bd8/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g886572962bd8/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61003438346e7ca63b501=
8c2
        failing since 16 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =20
